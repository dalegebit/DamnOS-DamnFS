#ifndef __DAMN_FS
#define __DAMN_FS

#include <x86.h>
#include <util.h>

#define MAXINODENUM 128

#define MAXBLKNUM 4096

#define MAXNAMELEN 16

#define DAMN_MAGIC 0x89ABCDEF

// File nodes (both in-memory and on-disk)

// Bytes per file system block - same as page size
#define BLKSIZE		PGSIZE
#define BLKBITSIZE	(BLKSIZE * 8)

// Bytes per inode
#define INSIZE	32

// Bytes per dir entry
#define DIRESIZE sizeof(struct DirEntry)

// Maximum size of a complete pathname, including null
#define MAXPATHLEN	128

// Number of block pointers in a File descriptor
#define NDIRECT		13

#define SECTSIZE	512			// bytes per disk sector
#define BLKSECTS	(BLKSIZE / SECTSIZE)	// sectors per block

// An inode block contains exactly BLKFILES 'struct File's
#define BLKFILES	(BLKSIZE / DIRESIZE)

/* Disk block n, when in memory, is mapped into the file system
 * server's address space at DISKMAP + (n*BLKSIZE). */
#define DISKMAP		0x10000000

/* Maximum disk size we can handle (16MB + 8KB) */
#define DISKSIZE	0x11002000

// File types
#define FTYPE_REG	'f'	// Regular file
#define FTYPE_DIR	'd'	// Directory

#define MIN(a,b) (((a)<(b))?(a):(b))

enum {
	FSREQ_OPEN = 1,
	FSREQ_SET_SIZE,
	// Read returns a Fsret_read on the request page
	FSREQ_READ,
	FSREQ_WRITE,
	// Stat returns a Fsret_stat on the request page
	FSREQ_STAT,
	FSREQ_FLUSH,
	FSREQ_MKDIR,
	FSREQ_REMOVE,
	FSREQ_SYNC
};

struct DamnInode{
	uint16_t type;
	uint16_t size;
	uint16_t blk_used;
	uint16_t blk_ind[NDIRECT];
} __attribute__((packed));

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


struct DirEntry{
	char f_name[MAXNAMELEN];
	uint16_t in_ind;
} __attribute__((packed));;


union Fsipc {
	struct Fsreq_open
	{
		char req_path[MAXPATHLEN];
		int req_omode;
	} open;
	struct Fsreq_set_size
	{
		int req_fileid;
		off_t req_size;
	} set_size;
	struct Fsreq_read
	{
		int req_fileid;
		size_t req_n;
	} read;
	struct Fsret_read
	{
		char ret_buf[PGSIZE];
	} readRet;
	struct Fsreq_write
	{
		int req_fileid;
		size_t req_n;
		char req_buf[PGSIZE - (sizeof(int) + sizeof(size_t))];
	} write;
	struct Fsreq_stat
	{
		int req_fileid;
	} stat;
	struct Fsret_stat
	{
		char ret_name[MAXNAMELEN];
		off_t ret_size;
		int ret_isdir;
	} statRet;
	struct Fsreq_flush
	{
		int req_fileid;
	} flush;
	struct Fsreq_remove
	{
		char req_path[MAXPATHLEN];
	} remove;
	struct Fsreq_mkdir
	{
		char req_path[MAXPATHLEN];
	} mkdir;

	// Ensure Fsipc is one page
	char _pad[PGSIZE];
};

void*	diskaddr(uint32_t blockno);
bool	va_is_mapped(void *va);
bool	va_is_dirty(void *va);
void	flush_block(void *addr);
void	bc_init(void);

bool	block_is_free(uint16_t blockno);
int	alloc_block(void);
bool	inode_is_free(uint16_t inodeno);
int alloc_inode(void);

void	fs_init(void);
int file_get_block(struct DamnInode * inode, uint16_t blockind, char **blk);
int file_create(const char *path, struct DirEntry **pf, uint16_t type);
int file_open(const char *path, struct DirEntry **pf);
ssize_t file_read(struct DirEntry *f, void *buf, size_t count, off_t offset);
int file_write(struct DirEntry *f, const void *buf, size_t count, off_t offset);
int	file_set_size(struct DirEntry *f, off_t newsize);
void	file_flush(struct DirEntry *f);
int	file_remove(const char *path);
void	fs_sync(void);

#endif
