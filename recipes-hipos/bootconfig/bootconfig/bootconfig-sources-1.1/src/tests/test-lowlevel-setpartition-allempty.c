/*
 *  Copyright (C) 2011, 2012 DResearch Fahrzeugelektronik GmbH   
 *                                                               
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License  
 *  as published by the Free Software Foundation; either version 
 *  2 of the License, or (at your option) any later version.     
 *
 *
 *  Boot configuration user space tooling low-level unit tests
 */

#include <stdio.h>
#include <fcntl.h>

#include <test_harness.h>

#include "mocks.c"

#define open my_open
#include "../logging.c"
#include "../lowlevel.c"

static void my_mtd_read( struct bootinfo * bi, int fd, int indx, int b, struct btblock * block ,int len )
{
    static uint32_t called=0;
    called++;

    switch (indx)
    {
        case 0:
                memcpy( block, "Boot", 4);
                block->epoch = 1;
                block->kernel.partition = 1;
                block->kernel.n_booted  = 1;
                block->kernel.n_healthy = 1;
                block->rootfs.partition = 0;
                block->rootfs.n_booted  = 1;
                block->rootfs.n_healthy = 1;
        break;
        case 1:
		;
        break;
        case 2:
		;
        break;
        case 3:
                ;
        break;
        case 4:
                ;
        break;
        case 5:
                block->kernel.partition = 1;
                block->kernel.n_booted  = 1;
                block->kernel.n_healthy = 0;
                block->rootfs.partition = 0;
                block->rootfs.n_booted  = 1;
                block->rootfs.n_healthy = 1;
        break;

    }

}


int main( int argc, char ** argv)
{
    struct bootconfig bc;
    enum bt_ll_parttype which = kernel;
    int res;

    {
        uint32_t channels, levels;
        get_log_config(&channels, &levels);
        set_log_config(channels, BC_LOG_STDERR);
    }

    MOCK_CB_SET( mtd_read, my_mtd_read );

    initialised = 1;

    bc.info.eb_cnt = 6;
    bc.info.min_io_size = 9876;
    bc.blocks = _alloc_blocks( bc.info.eb_cnt );
    bc.dev = "/test/device";

    bc.blocks[5].kernel.partition = 1;
    bc.blocks[5].kernel.n_booted  = 1;
    bc.blocks[5].kernel.n_healthy = 0;
    bc.blocks[5].rootfs.partition = 0;
    bc.blocks[5].rootfs.n_booted  = 1;
    bc.blocks[5].rootfs.n_healthy = 1;

    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 0 );
    MOCK_4_CALL(  0, mtd_erase, bc.mtd, &bc.info, bc.fd, 0 );

    MOCK_10_CALL( 0, mtd_write, bc.mtd, &bc.info, bc.fd, 0, 0, DONT_CHECK_PARAM, bc.info.min_io_size,
            NULL, 0, 0 );

    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 0 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 0, 0, &bc.blocks[0], sizeof( *bc.blocks ) );
    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 1 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 1, 0, &bc.blocks[1], sizeof( *bc.blocks ) );
    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 2 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 2, 0, &bc.blocks[2], sizeof( *bc.blocks ) );
    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 3 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 3, 0, &bc.blocks[3], sizeof( *bc.blocks ) );
    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 4 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 4, 0, &bc.blocks[4], sizeof( *bc.blocks ) );
    MOCK_3_CALL(  0, mtd_is_bad, &bc.info, bc.fd, 5 );
    MOCK_6_CALL( 0, mtd_read, &bc.info, bc.fd, 5, 0, &bc.blocks[5], sizeof( *bc.blocks ) );

    res = bc_ll_set_partition( &bc, kernel, 1 );

    TEST_ASSERT( 0, res, int);
    TEST_ASSERT( 0, memcmp(         &bc.blocks[0], "Boot", 4), int );
    TEST_ASSERT( 1, !!(0 != memcmp( &bc.blocks[1], "Boot", 4)),int );
    TEST_ASSERT( 1, !!(0 != memcmp( &bc.blocks[2], "Boot", 4)),int );
    TEST_ASSERT( 1, !!(0 != memcmp( &bc.blocks[3], "Boot", 4)),int );
    TEST_ASSERT( 1, !!(0 != memcmp( &bc.blocks[4], "Boot", 4)),int );
    TEST_ASSERT( 1, !!(0 != memcmp( &bc.blocks[5], "Boot", 4)),int );

    TEST_ASSERT( 1, bc.blocks[0].kernel.partition, int );
    TEST_ASSERT( 1, bc.blocks[0].kernel.n_booted, int);
    TEST_ASSERT( 1, bc.blocks[0].kernel.n_healthy, int);
    TEST_ASSERT( 0, bc.blocks[0].rootfs.partition, int)
    TEST_ASSERT( 1, bc.blocks[0].rootfs.n_booted, int);
    TEST_ASSERT( 1, bc.blocks[0].rootfs.n_healthy, int);

    TEST_ASSERT( 6, _mtd_is_bad_called_count, int );
    TEST_ASSERT( 0, _mtd_erase_called_count, int );
    TEST_ASSERT( 0, _mtd_write_called_count, int );

    return 0;
}
/* -- */

