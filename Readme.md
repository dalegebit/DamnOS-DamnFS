# DamnOS + DamnFS

DamnOS is an operating system based on MIT 6.828 JOS , and DamnFS is just a self-designed brained-fucked simple ext-like File System that DamnOS relies on.

>This is a simple combination of DamnOS and DamnFS  like:

```
DamnOS in hda:
| 512b  |       2m      |
-------------------------
| boot  |    kernel     |
| sect  |   (DamnOs)    |
-------------------------

DanmFs in hdb:
|            16m + 8K           |
---------------------------------
|  4K       4K         16M      |
| Super |  inodes |    ...      |
---------------------------------
```
>The structure of DamnFs can be viewed at the back of this doc.

***

## To Boot
### Dependencies : Qemu

-`make qemu`

> This instruction automatically allocate 8M to the simple ugly kernel.

> There are two page directory were used in total when booting. The first one is pre-defined in  `entrypgdir.c` and deprecated after the REAL page directory set up and properly mapped in function `mem_init()`.

> For more detail, go check out `init.c` and `pmap.c`.

> Other information is written in my report.

`Ctrl-a + x` to exit.




***
***

## Intro to DamnFS

> **DamnFS** is a simple ext-like file system. It has 128 inodes and 4096 blocks. (Of course it's not practical) Although it's small and simple, with `./damn` you can still apply `ls`, `touch`, `mkdir`, `rm`, `cat` and `edit` on it, just like in linux. The reason it's not fat-like is that I think a file system should be slim.

***

### Details
- The structure of the `super block`. `block_avai` records the availability of each block, similar to `inode_avai`.  
```
struct DamnSuper{
	uint32_t magic;
	uint16_t in_num;
	uint16_t blk_num;
	uint16_t in_size;
	uint16_t blk_size;
	uintptr_t in_entry;
	uint32_t blk_ocp[MAXBLKNUM/32];
	uint32_t in_ocp[MAXINODENUM/32];
} __attribute__((aligned(BLKSIZE)));
```


* The structure of `inode`. Obviously, an inode can records 8 block indices. The file system doesn't support indirect search for blocks.
```
struct DamnInode{
	uint16_t type;
	uint16_t size;
	uint16_t blk_used;
	uint16_t blk_ind[NDIRECT];
} __attribute__((packed));
```

* The struture of `directory entry`:
```
struct DirEntry{
	char f_name[MAXNAMELEN];
	uint16_t in_ind;
} __attribute__((packed));;
};
```


***

### Usage:


-`make fs.img`

Then you can get a proper formatted "fs.img" in current dir.

Now the file system it's yours. You can use `./damn [command] [path]`  to modify the file system. The supported commands are listed in the introduction part.

***

### Tips

- You can only remove a directory when there are only "." and ".." in it.
