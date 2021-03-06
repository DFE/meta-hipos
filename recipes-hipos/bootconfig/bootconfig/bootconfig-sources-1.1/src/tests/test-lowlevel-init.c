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

int main( int argc, char ** argv)
{
    struct bootconfig bc;
    int dev_fd            = 42;
    void* mtd_hdl         = (void*) 23;
    const char * test_dev = "/test/device";

    {
        uint32_t channels, levels;
        get_log_config(&channels, &levels);
        set_log_config(channels, BC_LOG_STDERR);
    }


    MOCK_2_CALL( dev_fd,  my_open,             test_dev, O_RDWR );
    MOCK_0_CALL( mtd_hdl, libmtd_open );
    MOCK_3_CALL( 0,       mtd_get_dev_info, mtd_hdl,  test_dev, &bc.info );
    _mtd_get_dev_info_cb = _mock_mtd_get_dev_info;

    MOCK_3_CALL( 0, mtd_is_bad, &bc.info, dev_fd, 0 );
    MOCK_3_CALL( 0, mtd_is_bad, &bc.info, dev_fd, 1 );
    MOCK_3_CALL( 0, mtd_is_bad, &bc.info, dev_fd, 2 );
    MOCK_3_CALL( 0, mtd_is_bad, &bc.info, dev_fd, 3 );

    MOCK_6_CALL( 0, mtd_read, &bc.info, dev_fd, 0, 0, DONT_CHECK_PARAM, sizeof(struct btblock) );
    MOCK_6_CALL( 0, mtd_read, &bc.info, dev_fd, 1, 0, DONT_CHECK_PARAM, sizeof(struct btblock) );
    MOCK_6_CALL( 0, mtd_read, &bc.info, dev_fd, 2, 0, DONT_CHECK_PARAM, sizeof(struct btblock) );
    MOCK_6_CALL( 0, mtd_read, &bc.info, dev_fd, 3, 0, DONT_CHECK_PARAM, sizeof(struct btblock) );


    bc_ll_init( &bc, test_dev );

    TEST_ASSERT( 1, initialised, int );

    TEST_ASSERT( 0, _my_open_called_count, int );
    TEST_ASSERT( 0, _libmtd_open_called_count, int );
    TEST_ASSERT( 0, _mtd_get_dev_info_called_count, int );
    TEST_ASSERT( 3, _mtd_is_bad_called_count, int );
    TEST_ASSERT( 3, _mtd_read_called_count, int );

    return 0;
}
/* -- */
