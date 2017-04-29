/*
 * =====================================================================================
 *
 *       Filename:  ramdisk.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  03/26/2012 06:16:29 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Chen Yuheng (Chen Yuheng), chyh1990@163.com
 *   Organization:  Tsinghua Unv.
 *
 * =====================================================================================
 */

#include <defs.h>
#include <ramdisk.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <fs.h>

#define MIN(x,y) (((x)<(y))?(x):(y))

extern char _binary_bin_swap_img_start[], _binary_bin_swap_img_end[];
extern char _binary_bin_sfs_img_start[], _binary_bin_sfs_img_end[];

bool check_initrd(const char _initrd_begin[], const char _initrd_end[])
{
	if (_initrd_begin == _initrd_end) {
		cprintf("Warning: No Initrd!\n");
		return 0;
	}
	cprintf("Initrd: 0x%08x - 0x%08x, size: 0x%08x\n",
		_initrd_begin, _initrd_end - 1, _initrd_end - _initrd_begin);
	return 1;
}

static int ramdisk_read(struct ide_device *dev, size_t secno, void *dst,
			size_t nsecs)
{
	nsecs = MIN(nsecs, dev->size - secno);
	if (nsecs < 0)
		return -1;
	memcpy(dst, (void *)(dev->iobase + secno * SECTSIZE), nsecs * SECTSIZE);
	return 0;
}

static int ramdisk_write(struct ide_device *dev, size_t secno, const void *src,
			 size_t nsecs)
{
	//kprintf("%08x(%d) %08x(%d)\n", dev->size, dev->size, secno, secno);
	nsecs = MIN(nsecs, dev->size - secno);
	if (nsecs < 0)
		return -1;
	memcpy((void *)(dev->iobase + secno * SECTSIZE), src, nsecs * SECTSIZE);
	return 0;
}

void ramdisk_init(int devno, struct ide_device *dev)
{
	memset(dev, 0, sizeof(struct ide_device));
	char* _initrd_begin;
	char* _initrd_end;
	if (devno == SWAP_DEV_NO) {
		_initrd_begin = _binary_bin_swap_img_start;
		_initrd_end = _binary_bin_swap_img_end;
	} else if (devno == DISK0_DEV_NO) {
		_initrd_begin = _binary_bin_sfs_img_start;
		_initrd_end = _binary_bin_sfs_img_end;
	} else {
		panic("Device Not Found");
	}

	if (check_initrd(_initrd_begin, _initrd_end)) {
		dev->valid = 1;
		dev->sets = ~0;
		dev->size = (unsigned int)(_initrd_end - _initrd_begin) / SECTSIZE;
		dev->iobase = (uintptr_t)_initrd_begin;
		strcpy(dev->model, "KERN_INITRD");
		dev->read_secs = ramdisk_read;
		dev->write_secs = ramdisk_write;
	}
}
