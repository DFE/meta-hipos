/*
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Thanks to yiliang for variable audio packet length and more audio
 *  formats support.
 */
#include <linux/module.h>
#include <sound/core.h>
#include <sound/control.h>
#include <sound/pcm.h>
#include <sound/pcm_params.h>
#include <sound/initval.h>

#include "TW68.h"
#include "TW68_defines.h"

#define TW68_AUDIO_BEGIN 8

MODULE_DESCRIPTION("alsa driver module for tw68 PCIe capture chip");
MODULE_AUTHOR("Simon Xu");
MODULE_LICENSE("GPL");

#define audio_nCH		8
#define DMA_page		4096
#define MAX_BUFFER		(DMA_page * 4 *audio_nCH)

unsigned int TW68_debug_alsa=0;
module_param(TW68_debug_alsa, int, 0644);
MODULE_PARM_DESC(TW68_debug_alsa,"enable ALSA debug messages");


#define AUDIO_PAGE_SIZE (DMA_page/2)
// static struct snd_card *snd_TW68_cards[SNDRV_CARDS];

static long TW68_audio_nPCM = 0;

/*
 * PCM structure
 */
typedef struct snd_card_TW68_pcm {
	struct TW68_adev *dev;
	spinlock_t lock;
	struct snd_pcm_substream *substream;
} snd_card_TW68_pcm_t;

#if 1
int TW68_dev_set_audio(struct TW68_dev *chip, int samplerate, int bits, int channels, int blksize)
{
  u32 tmp1, tmp2, tmp3;

  tmp1 = tw_read(TW6864_R_AUDIO_CTRL1);
  tmp1 &= 0x0000001F;
  tmp1 |= (125000000/samplerate) << 5;
  tmp1 |= blksize << 19;

  tw_write(TW6864_R_AUDIO_CTRL1,  tmp1);

  tmp2 = ((125000000 / samplerate) << 16) +
         ((125000000 % samplerate) << 16)/samplerate;

  tw_write(TW6864_R_AUDIO_CTRL2,  tmp2);
  tmp3 = tw_read(TW6864_R_AUDIO_CTRL3);
  tmp3 &= ~BIT(8);
  tmp3 |= (bits==8) ? BIT(8) : 0;
  tw_write(TW6864_R_AUDIO_CTRL3, tmp3);
  return 0;
}


void TW68_dev_run_audio(struct TW68_adev *dev, bool b_run)
{
    struct TW68_dev *chip = dev->chip;
    int  ch   = dev->channel_id+TW686X_AUDIO_BEGIN;
	u32  tmp  = tw_read(TW6864_R_DMA_CMD);
	u32  tmp1 = tw_read(TW6864_R_DMA_CHANNEL_ENABLE);
	daprintk(DPRT_LEVEL0, dev, "%s(%d %d)\n", __func__, ch, b_run);
	if(b_run) {
        tmp |= (1<<31);
        tmp |= (1<<ch);
        tmp1|= (1<<ch);
	}
	else {
		if(!(tmp&(1<<ch)) && !(tmp1&(1<<ch))) {
			return;
		}
		tmp &= ~(1<<ch);
		tmp1&= ~(1<<ch);
		if( tmp1 == 0 ) {
		    tmp = 0;
		}
	}
	tw_write(TW6864_R_DMA_CHANNEL_ENABLE, tmp1);
	tw_write(TW6864_R_DMA_CMD, tmp);
}

int TW68_dev_set_adma_buffer(struct TW68_adev *dev, u32 buf_addr, int pb)
{
    struct TW68_dev *chip = dev->chip;
    if(pb == 0) {
        tw_write(TW6864_R_CH8to15_CONFIG_REG_P(dev->channel_id), buf_addr);
    }
    else {
        tw_write(TW6864_R_CH8to15_CONFIG_REG_B(dev->channel_id), buf_addr);
    }
	//daprintk(DPRT_LEVEL0, dev, "%s(%x %d)\n", __func__, buf_addr, pb);
    return 0;
}
#endif


void TW68_alsa_irq(struct TW68_adev *dev, u32 dma_status, u32 pb_status)
{
	int pb = (pb_status>>(dev->channel_id+TW68_AUDIO_BEGIN)) & 1;
	struct snd_pcm_runtime *runtime = dev->substream->runtime;
	int len = AUDIO_PAGE_SIZE;
	unsigned char *buf;
	int frames;
	int elapsed;
	int next_pb;
	
	if (!dev->running)
		return;
	
	buf = (pb == 0) ? dev->dma_area : dev->dma_area + AUDIO_PAGE_SIZE;
	next_pb = (pb == 0) ? 1 : 0;
	
	if (next_pb != dev->pb_flag) {
		dev->chip->stat_audio[dev->channel_id].pb_mismatch++;
		// may want to advance the hw_ptr, but not necessarily.
		// there is really no way to know how many IRQs/frames were missed.
	}
	dev->pb_flag = pb;
	/* do the copy */
	dev->captured_bytes += len;
	frames = bytes_to_frames(runtime, len);
	spin_lock(&dev->slock2);
	dev->hw_ptr += frames;
	if (dev->hw_ptr >= runtime->buffer_size)
		dev->hw_ptr -= runtime->buffer_size;
	dev->avail += frames;
	spin_unlock(&dev->slock2);
	
	if (dev->w_idx + len > runtime->dma_bytes) {
		int cpy = runtime->dma_bytes - dev->w_idx;
		memcpy(runtime->dma_area + dev->w_idx, buf, cpy);
		len -= cpy;
		buf += cpy;
		dev->w_idx = 0;
	}
	memcpy(runtime->dma_area + dev->w_idx, buf, len);
	dev->w_idx += len;
	spin_lock(&dev->slock2);
	if (dev->avail < runtime->period_size) {
		spin_unlock(&dev->slock2);
		return;
	}
	elapsed = 0;
	while (dev->avail >= runtime->period_size) {
		elapsed = 1;
		dev->avail -= runtime->period_size;
	}
	spin_unlock(&dev->slock2);

	if (dev->running && elapsed) {
		snd_pcm_period_elapsed(dev->substream);
	}
}


/*
 * ALSA capture trigger
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called whenever a capture is started or stopped. Must be defined,
 *   but there's nothing we want to do here
 *
 */

static int snd_card_TW68_capture_trigger(struct snd_pcm_substream * substream,
					  int cmd)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	snd_card_TW68_pcm_t *pcm = runtime->private_data;
	struct TW68_adev *dev=pcm->dev;
	unsigned long flags = 0;
	
	daprintk(DPRT_LEVEL0, dev, "%s(%d)\n", __func__, (cmd == SNDRV_PCM_TRIGGER_START));
	switch (cmd) {
	case SNDRV_PCM_TRIGGER_START:
		/* start dma */
		if (dev->running) {
			printk("already running\n");
			return 0;
		}
		
		dev->pb_flag = 1;
		dev->running = 1;
		dev->w_idx = 0; dev->hw_ptr = 0; dev->avail = 0;
		spin_lock_irqsave(&dev->chip->slock, flags);
		TW68_dev_set_audio(dev->chip, runtime->rate, runtime->sample_bits, runtime->channels, AUDIO_PAGE_SIZE);//dev->blksize);
		TW68_dev_run_audio(dev, true);
		spin_unlock_irqrestore(&dev->chip->slock, flags);
		break;
	case SNDRV_PCM_TRIGGER_STOP:
		/* stop dma */
		// need device global spinlock.  channel enable/disable
		spin_lock_irqsave(&dev->chip->slock, flags);
		TW68_dev_run_audio(dev, false);
		spin_unlock_irqrestore(&dev->chip->slock, flags);
		dev->running = 0;
		break;
	default:
		return -EINVAL;
	}
	return 0;
}


/*
 * ALSA PCM preparation
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called right after the capture device is opened, this function configures
 *  the buffer using the previously defined functions, allocates the memory,
 *  sets up the hardware registers, and then starts the DMA. When this function
 *  returns, the audio should be flowing.
 *
 */

static int snd_card_TW68_capture_prepare(struct snd_pcm_substream * substream)
{
//	struct snd_pcm_runtime *runtime = substream->runtime;
//	snd_card_TW68_t *card_TW68 = snd_pcm_substream_chip(substream);
//	struct TW68_adev *dev = card_TW68->dev;
//	snd_card_TW68_pcm_t *pcm = runtime->private_data;
//    TW68_dev_set_audio(dev->chip, runtime->rate, runtime->sample_bits, runtime->channels, AUDIO_PAGE_SIZE);
    return 0;
}

/*
 * ALSA pointer fetching
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called whenever a period elapses, it must return the current hardware
 *  position of the buffer.
 *   Also resets the read counter used to prevent overruns
 *
 */

static snd_pcm_uframes_t
snd_card_TW68_capture_pointer(struct snd_pcm_substream * substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	snd_card_TW68_pcm_t *pcm = runtime->private_data;
	struct TW68_adev *dev=pcm->dev;
    //printk("pointer %d\n", dev->hw_ptr);
	return dev->hw_ptr;
}

/*
 * ALSA hardware capabilities definition
 */

static struct snd_pcm_hardware snd_card_TW68_capture =
{
	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
	        SNDRV_PCM_INFO_MMAP |
          	SNDRV_PCM_INFO_INTERLEAVED |
	        SNDRV_PCM_INFO_MMAP_VALID,
	.formats = SNDRV_PCM_FMTBIT_S16_LE,// | SNDRV_PCM_FMTBIT_S8,
	.rates = SNDRV_PCM_RATE_8000_48000,//KNOT,
	.rate_min = 8000,
	.rate_max = 48000,
	.channels_min = 1,
	.channels_max = 1,
	.buffer_bytes_max =	1024 * 1024,
	.period_bytes_min =	AUDIO_PAGE_SIZE,
	.period_bytes_max =	AUDIO_PAGE_SIZE*2,
	.periods_min      = 4,
	.periods_max      = 64,
};



static void snd_card_TW68_runtime_free(struct snd_pcm_runtime *runtime)
{
	snd_card_TW68_pcm_t *pcm = runtime->private_data;
	struct TW68_adev *dev = pcm->dev;
	daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);
	kfree(pcm);
}


/*
 * ALSA hardware params
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called on initialization, right before the PCM preparation
 *
 */

static int snd_card_TW68_hw_params(struct snd_pcm_substream * substream,
				      struct snd_pcm_hw_params * hw_params)
{
	snd_card_TW68_t *card_TW68 = snd_pcm_substream_chip(substream);
	struct TW68_adev *dev = card_TW68->dev;
	unsigned long flags = 0;
	struct snd_pcm_runtime *runtime = substream->runtime;

	if (!runtime) {
		printk("null runtime!\n");
		return -ENOMEM;
	}
    spin_lock_irqsave(&dev->slock2, flags);
    dev->hw_ptr = 0;
    dev->w_idx = 0;
    dev->avail = 0;
    spin_unlock_irqrestore(&dev->slock2, flags);
	return snd_pcm_lib_alloc_vmalloc_buffer(substream, params_buffer_bytes(hw_params));
}

/*
 * ALSA hardware release
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called after closing the device, but before snd_card_TW68_capture_close
 *   It stops the DMA audio and releases the buffers.
 *
 */

static int snd_card_TW68_hw_free(struct snd_pcm_substream * substream)
{
	snd_card_TW68_t *card_TW68 = snd_pcm_substream_chip(substream);
	struct TW68_adev *dev;

	dev = card_TW68->dev;
	daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);
	dev->running = 0;
	return snd_pcm_lib_free_vmalloc_buffer(substream);

}

/*
 * ALSA capture finish
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called after closing the device.
 *
 */

static int snd_card_TW68_capture_close(struct snd_pcm_substream * substream)
{
	snd_card_TW68_t *card_TW68 = snd_pcm_substream_chip(substream);
	struct TW68_adev *dev = card_TW68->dev;
    unsigned long flags = 0;
    daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);
	dev->running = 0;
    spin_lock_irqsave(&dev->chip->slock, flags);
    TW68_dev_run_audio(dev, false);
    spin_unlock_irqrestore(&dev->chip->slock, flags);
	return 0;
}

/*
 * ALSA capture start
 *
 *   - One of the ALSA capture callbacks.
 *
 *   Called when opening the device. It creates and populates the PCM
 *  structure
 *
 */

static int snd_card_TW68_capture_open(struct snd_pcm_substream * substream)
{
	struct snd_pcm_runtime *runtime = substream->runtime;
	snd_card_TW68_pcm_t *pcm;
	snd_card_TW68_t *card_TW68 = snd_pcm_substream_chip(substream);
	struct TW68_adev *dev;


	if (!card_TW68) {
		printk(KERN_ERR "BUG: TW68 can't find device struct."
				" Can't proceed with open\n");
		return -ENODEV;
	}
	dev = card_TW68->dev;

	daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);

	pcm = kzalloc(sizeof(*pcm), GFP_KERNEL);
	if (pcm == NULL)
		return -ENOMEM;

	pcm->dev=dev;

	spin_lock_init(&pcm->lock);

    dev->hw_ptr = dev->w_idx = dev->avail = 0;

	pcm->substream = substream;
    dev->substream = substream;
	runtime->private_data = pcm;
	runtime->private_free = snd_card_TW68_runtime_free;
	runtime->hw = snd_card_TW68_capture;
#if 0
	err = snd_pcm_hw_constraint_integer(runtime,
						SNDRV_PCM_HW_PARAM_PERIODS);
	if (err < 0)
		return err;
#endif
	return 0;
}

/*
 * page callback
 */

static struct page *snd_card_TW68_page(struct snd_pcm_substream *substream,
					unsigned long offset)
{
	return vmalloc_to_page(substream->runtime->dma_area + offset);
}

/*
 * ALSA capture callbacks definition
 */

static struct snd_pcm_ops snd_card_TW68_capture_ops = {
	.open =		snd_card_TW68_capture_open,
	.close =		snd_card_TW68_capture_close,
	.ioctl =		snd_pcm_lib_ioctl,
	.hw_params =	snd_card_TW68_hw_params,
	.hw_free =	snd_card_TW68_hw_free,
	.prepare =	snd_card_TW68_capture_prepare,
	.trigger =	snd_card_TW68_capture_trigger,
	.pointer =	snd_card_TW68_capture_pointer,
	.page =		snd_card_TW68_page,
	.mmap =		snd_pcm_lib_mmap_vmalloc,
};

/*
 * ALSA PCM setup
 *
 *   Called when initializing the board. Sets up the name and hooks up
 *  the callbacks
 *
 */

static int snd_card_TW68_pcm(snd_card_TW68_t *card_TW68, long device)
{
	struct snd_pcm *pcm;
	int err;

	printk( "ENTER %s\n", __FUNCTION__ );
	daprintk(DPRT_LEVEL0, card_TW68->dev, "%s()\n", __func__);

	if ((err = snd_pcm_new(card_TW68->card, "TW6869 PCM", device, 0, 1, &pcm)) < 0)
	{
		printk( "snd_pcm_new failed, err=%d\n", err );
		return err;
	}

	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_card_TW68_capture_ops);
	pcm->private_data = card_TW68;
	pcm->info_flags = 0;
	strcpy(pcm->name, "TW6869 PCM");
	return 0;
}

static void snd_TW68_free(struct snd_card * card)
{
	snd_card_TW68_t *card_TW68 = (snd_card_TW68_t*)card->private_data;
	struct TW68_adev* dev = card_TW68->dev;

	daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);
}

/*
 * ALSA initialization
 *
 *   Called by the init routine, once for each TW68 device present,
 *  it creates the basic structures and registers the ALSA devices
 *
 */

int TW68_alsa_create(struct TW68_adev *dev)
{
	struct snd_card *card = NULL;
	snd_card_TW68_t *card_TW68;
	int err;

	printk( "ENTER %s\n", __FUNCTION__ );
	daprintk(DPRT_LEVEL0, dev, "%s()\n", __func__);

	if(TW68_audio_nPCM > (SNDRV_CARDS-1))
	{
		printk( "TW68_alsa_create failed to create card %ld > %d-1\n", TW68_audio_nPCM, SNDRV_CARDS );
		return -ENODEV;
	}
	
	dev->dma_area = pci_alloc_consistent(dev->chip->pci, PAGE_SIZE * 2 * 40, &dev->dma_addr);
	if (dev->dma_area == NULL)
	{
		printk( "TW68_alsa_create: err = -ENOMEM\n" );
		return -ENOMEM;
	}

	TW68_dev_set_adma_buffer (dev, dev->dma_addr, 0);
	TW68_dev_set_adma_buffer (dev, dev->dma_addr + AUDIO_PAGE_SIZE, 1);

#if(LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
#if(LINUX_VERSION_CODE < KERNEL_VERSION(3,15,0))
	err = snd_card_create(-1, NULL, THIS_MODULE, sizeof(snd_card_TW68_t), &card);
	if (err < 0)
	{
		printk( "TW68_alsa_create: snd_card_create failed err=%d\n", err );
		return err;
	}
#else
	err = snd_card_new(&dev->chip->pci->dev, -1, NULL, THIS_MODULE, sizeof(snd_card_TW68_t), &card);
	if (err < 0)
	{
		printk( "TW68_alsa_create: snd_card_new failed err=%d\n", err );
		return err;
	}
#endif

#else
	card = snd_card_new(-2, NULL, THIS_MODULE, sizeof(snd_card_TW68_t));
	if (card == NULL)
	{
		printk( "TW68_alsa_create: snd_card_new failed err=-ENOMEM\n" );
		return -ENOMEM;
	}
#endif

	strcpy(card->driver, "TW6869");
	/* Card "creation" */

	card->private_free = snd_TW68_free;
	card_TW68 = (snd_card_TW68_t *) card->private_data;

	spin_lock_init(&card_TW68->lock);

	card_TW68->dev = dev;
	card_TW68->card= card;
	dev->card = card_TW68;

	mutex_init(&dev->lock);

	if ((err = snd_card_TW68_pcm(card_TW68, 0)) < 0)
	{
		printk( "TW68_alsa_create: snd_card_TW68_pcm failed err=%d\n", err );
		goto __nodev;
	}

	snd_card_set_dev(card, &dev->chip->pci->dev);

	/* End of "creation" */

	strcpy(card->shortname, "TW6869");
	sprintf(card->longname, "%s at 0x%p irq %d",
		dev->chip->name, dev->chip->bmmio, dev->chip->pci->irq);

	daprintk(1, dev, "alsa: %s registered as card %d\n",card->longname,dev->channel_id);
	if ((err = snd_card_register(card)) == 0) {
		TW68_audio_nPCM++;
		return 0;
	}

__nodev:
	snd_card_free(card);
	return err;
}

int TW68_alsa_free(struct TW68_adev *dev)
{
    if (dev->dma_area != NULL) {
        pci_free_consistent(dev->chip->pci, PAGE_SIZE * 2 * 40,
                            dev->dma_area, dev->dma_addr);
        dev->dma_area = NULL;
        dev->dma_addr = 0;
    }

    if(dev->card) {
        snd_card_free(dev->card->card);
        dev->card = NULL;
    }

    TW68_audio_nPCM--;

	return 1;
}

