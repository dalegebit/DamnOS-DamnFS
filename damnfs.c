
#include <syslib.h>

#include <damnfs.h>
#include <ide.h>


volatile struct DamnSuper * super;
volatile struct DamnInode * inodes;

// --------------------------------------------------------------
// Super block
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
	if (super->magic != DAMN_MAGIC)
		panic("bad file system magic number");

	if (super->blk_num > DISKSIZE/BLKSIZE)
		panic("file system is too large");

	cprintf("superblock is good\n");
}

// --------------------------------------------------------------
// Free block bitmap
// --------------------------------------------------------------

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint16_t blockno)
{
	if (super == 0 || blockno >= super->blk_num)
		return 0;
	if ((super->blk_ocp[blockno / 32] & (1 << (blockno % 32))) == 0)
		return 1;
	return 0;
}

// Mark a block free in the bitmap
void
free_block(uint16_t blockno)
{
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
		panic("attempt to free zero block");
	super->blk_ocp[blockno/32] &= ~(1<<(blockno%32));
	flush_block(super);
}

// Check to see if the inode bitmap indicates that block 'inodeno' is free.
// Return 1 if the block is free, 0 if not.
bool
inode_is_free(uint16_t inodeno)
{
	if (super == 0 || inodeno >= super->in_num)
		return 0;
	if ((super->in_ocp[inodeno / 32] & (1 << (inodeno % 32))) == 0)
		return 1;
	return 0;
}

// Mark a block free in the bitmap
void
free_inode(uint16_t inodeno)
{
	// Blockno zero is the null pointer of block numbers.
	if (inodeno == 0)
		panic("attempt to free zero inode");
	super->in_ocp[inodeno/32] &= ~(1<<(inodeno%32));
	flush_block(super);
}

// Search the bitmap for a free block and allocate it.  When you
// allocate a block, immediately flush the changed bitmap block
// to disk.
//
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
//
int
alloc_block(void)
{
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.
	int blockno;
	for(blockno = 0; blockno < super->blk_num; ++blockno)
	{
		if(block_is_free(blockno))
		{
			super->blk_ocp[blockno / 32] |= 1 << (blockno % 32);
			flush_block(super);
			return blockno;
		}
	}
	return -E_NO_DISK;
}


int
alloc_inode(void)
{
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.
	int inodeno;
	for(inodeno = 0; inodeno < super->in_num; ++inodeno)
	{
		if(inode_is_free(inodeno))
		{
			super->in_ocp[inodeno / 32] |= 1 << (inodeno % 32);
			flush_block(super);
			return inodeno;
		}
	}
	return -E_NO_INODE;
}


// --------------------------------------------------------------
// File system structures
// --------------------------------------------------------------



// Initialize the file system
void
fs_init(void)
{

	// Find a damnfs disk.  Use the second IDE disk (number 1) if availabl
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
	bc_init();

	// Set "super" to point to the super block.
	super = diskaddr(0);
	super->magic;
	//cprintf("magic good : %d\n", super->magic == DAMN_MAGIC);
	cprintf("FS: superblock loaded!\n");
	// check_super();

	inodes = diskaddr(1);
	inodes[0];
	cprintf("FS: inodes loaded!\n");
}

// Find the disk block number slot for the 'filebno'th block in file 'f'.
// Set '*ppdiskbno' to point to that slot.
// The slot will be one of the f->f_direct[] entries,
// or an entry in the indirect block.
// When 'alloc' is set, this function will allocate an indirect block
// if necessary.
//
// Returns:
//	0 on success (but note that *ppdiskbno might equal 0).
//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
//		alloc was 0.
//	-E_NO_DISK if there's no space on the disk for an indirect block.
//	-E_INVAL if filebno is out of range (it's >= NDIRECT + NINDIRECT).
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct DamnInode * inode, uint16_t blockind,
	uint16_t **ppdiskbno)
{
	if(blockind < NDIRECT) {
		if (ppdiskbno)
			*ppdiskbno = &(inode->blk_ind[blockind]);
	}
	else
		return -E_INVAL;
	return 0;
}

// Set *blk to the address in memory where the filebno'th
// block of file 'f' would be mapped.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct DamnInode * inode, uint16_t blockind, char **blk)
{
	int r;
	uint16_t * pointer_to_slot;
	if((r = file_block_walk(inode, blockind, &pointer_to_slot)) < 0)
		return r;
	if((*pointer_to_slot) == 0)
	{
		if((r = alloc_block()) < 0)
			return r;
		*pointer_to_slot = r;
		inode->blk_used++;
	}
	*blk = diskaddr(*pointer_to_slot);
	flush_block(inode);
	return 0;
}

// Try to find a file named "name" in dir.  If so, set *entry to it.
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct DamnInode *dir, const char *name, struct DirEntry **entry)
{
	int r;
	uint16_t i, j, nblock;
	char *blk;
	struct DirEntry *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	nblock = dir->blk_used;
	for (i = 0; i < nblock; i++)
	{
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct DirEntry *) blk;
		for (j = 0; j < BLKFILES; j++)
		{
			if (strcmp(f[j].f_name, name) == 0)
			{
				*entry = &f[j];
				return 0;
			}
		}
	}
	return -E_NOT_FOUND;
}

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_entry(struct DamnInode *dir, struct DirEntry **entry)
{
	int r;
	uint16_t nblock, i, j;
	char *blk;
	struct DirEntry *f;

	nblock = dir->blk_used;
	for (i = 0; i < nblock; i++)
	{
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct DirEntry*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0')
			{
				*entry = &f[j];
				dir->size += DIRESIZE;
				return 0;
			}
	}
	dir->blk_used += 1;
	dir->size += DIRESIZE;
	if ((r = file_get_block(dir, i, &blk)) < 0)
		return r;
	f = (struct DirEntry*) blk;
	*entry = &f[0];
	return 0;
}

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
	return p;
}

static bool
name_is_valid(const char *name)
{
	if (strlen(name) >= MAXNAMELEN || strcmp(name, "..") == 0 || strcmp(name, ".") == 0)
		return false;
	const char *p = name;
	while (*p) {
		if (*p == '/' || *p == ' ')
			return false;
		++p;
	}
	return true;
}

// Evaluate a path name, starting at the root.
// On success, set *pf to the file we found
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct DamnInode **pdir, struct DirEntry **pf, char *lastelem)
{
	const char *p;
	char name[MAXNAMELEN];
	struct DamnInode *dir, *f;
	struct DirEntry *entry;
	int r;
	
	//cprintf("walk path: %s\n", path);
	if (*path != '/')
		return -E_BAD_PATH;
	path = skip_slash(path);
	f = &inodes[0];
	entry = NULL;
	dir = 0;
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0')
	{
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &entry)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
		}
		f = &inodes[entry->in_ind];
	}

	if (pdir)
		*pdir = dir;
	*pf = entry;
	return 0;
}

// --------------------------------------------------------------
// File operations
// --------------------------------------------------------------

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct DirEntry **pf, uint16_t type)
{
	char name[MAXNAMELEN];
	int r;
	struct DamnInode *dir;
	struct DirEntry *entry, *blk;
	uint16_t inodeno;

	if ((r = walk_path(path, &dir, &entry, name)) == 0)
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
	if (name_is_valid(name) == false)
		return -E_BAD_NAME;
	if ((r = dir_alloc_entry(dir, &entry)) < 0)
		return r;
	if ((r = alloc_inode()) < 0)
		return r;
	inodeno = r;
	if (type == FTYPE_DIR) {
		if ((r = file_get_block(&inodes[inodeno], 0, (char**)&blk)) < 0) {
			free_inode(inodeno);
			return r;
		}
		strcpy(blk[0].f_name, "..");
		strcpy(blk[1].f_name, ".");
		blk[0].in_ind = blk[1].in_ind = inodeno;
		inodes[inodeno].size = 2 * DIRESIZE;
	}
	strcpy(entry->f_name, name);
	entry->in_ind = inodeno;
	inodes[inodeno].type = type;
	if (pf)
		*pf = entry;
	//cprintf("begin flush file: 0x%08x\n", entry);
	file_flush(entry);
	return 0;
}

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
	int r;
	struct DirEntry *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
		return r;

	file_set_size(f, 0);
	f->f_name[0] = '\0';
	inodes[f->in_ind].size = 0;
	flush_block(f);
	flush_block(inodes);
	return 0;
}

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct DirEntry **pf)
{
	//cprintf("open file: %s\n", path);
	return walk_path(path, 0, pf, 0);
}

// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct DirEntry *f, void *buf, size_t count, off_t offset)
{
	int r, bn;
	off_t pos;
	char *blk;
	struct DamnInode * inode;


	//cprintf("read file: %s\n", f->f_name);
	inode = &inodes[f->in_ind];
	if (offset >= inode->size)
		return 0;

	count = MIN(count, inode->size - offset);

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(inode, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
}


// Write count bytes from buf into f, starting at seek position
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct DirEntry *f, const void *buf, size_t count, off_t offset)
{
	int r, bn;
	off_t pos;
	char *blk;
	struct DamnInode * inode;

	inode = &inodes[f->in_ind];
	// Extend file if necessary
	if (offset + count > inode->size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(inode, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	file_flush(f);
	return count;
}

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct DirEntry *f, uint16_t blockno)
{
	int r;
	uint16_t *ptr;
	struct DamnInode * inode;

	inode = &inodes[f->in_ind];
	if ((r = file_block_walk(inode, blockno, &ptr)) < 0)
		return r;
	if (*ptr) {
		free_block(*ptr);
		*ptr = 0;
	}
	return 0;
}

// Remove any blocks currently used by file 'f',
// but not necessary for a file of size 'newsize'.
// For both the old and new sizes, figure out the number of blocks required,
// and then clear the blocks from new_nblocks to old_nblocks.
// If the new_nblocks is no more than NDIRECT, and the indirect block has
// been allocated (f->f_indirect != 0), then free the indirect block too.
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct DirEntry *f, off_t newsize)
{
	int r;
	uint16_t bno, old_nblocks, new_nblocks;
	struct DamnInode * inode;

	inode = &inodes[f->in_ind];

	old_nblocks = (inode->size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct DirEntry *f, off_t newsize)
{
	struct DamnInode * inode;

	inode = &inodes[f->in_ind];
	if (inode->size > newsize)
		file_truncate_blocks(f, newsize);
	inode->size = newsize;
	flush_block(f);
	return 0;
}

// Flush the contents and metadata of file f out to disk.
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct DirEntry *f)
{
	int i;
	uint16_t *pdiskbno;
	struct DamnInode * inode;

	inode = &inodes[f->in_ind];
	for (i = 0; i < (inode->size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(inode, i, &pdiskbno) < 0 ||
			pdiskbno == NULL || *pdiskbno == 0)
			continue;
		//cprintf("begin flush fileblock: 0x%08x\n", diskaddr(*pdiskbno));
		flush_block(diskaddr(*pdiskbno));
	}
	
	//cprintf("begin flush inode: 0x%08x\n", inode);
	flush_block(inode);
	//cprintf("begin flush dir: 0x%08x\n", f);
	flush_block(f);
}


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->blk_num; i++)
		flush_block(diskaddr(i));
}


// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
	if (super && blockno >= super->blk_num)
		panic("bad block number %08x in diskaddr", blockno);
	return (char*) (DISKMAP + blockno * BLKSIZE);
}

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
}

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
}

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;
    envid_t envid;
    void *blkaddr;
    blkaddr = ROUNDDOWN(addr, PGSIZE);

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->blk_num)
		panic("reading non-existent block %08x\n", blockno);

	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page, and mark the
	// page not-dirty (since reading the data from disk will mark
	// the page dirty).
	//
    if (sys_page_alloc(0, blkaddr, PTE_SYSCALL) < 0) {
        panic("bg_pgfault: can't allocate new page for disk block\n");
    }

    if (ide_read(blockno*BLKSECTS, blkaddr, BLKSECTS) < 0) {
        panic("bg_pgfault: failed to read disk block\n");
    }

    if (sys_page_map(0, blkaddr, 0, blkaddr, PTE_W | PTE_U | PTE_SYSCALL) < 0) {
        panic("bg_pgfault: failed to mark disk page as non dirty\n");
    }

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (super && block_is_free(blockno))
		panic("reading free block %08x\n", blockno);
}

// Flush the contents of the block containing VA out to disk if
// necessary, then clear the PTE_D bit using sys_page_map.
// If the block is not in the block cache or is not dirty, does
// nothing.
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("flush_block of bad va %08x", addr);

	if(!va_is_mapped(addr) || !va_is_dirty(addr))
		return;
	addr = ROUNDDOWN(addr, PGSIZE);
	int r;
	if((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
		panic("flush_block : ide_write : error num : %d\n", r);
	if((r = sys_page_map(0, addr, 0, addr,
		uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
		panic("flush_block : sys_page_map : %e", r);
	//cprintf("flush done! block: %d\n", blockno);
}

int a[100];

void
bc_init(void)
{
	set_pgfault_handler(bc_pgfault);
	char tmp;
	int i;
	for (i = 0; i < 100; ++i)
		a[i] = i;
	// back up super block
	memmove(&tmp, diskaddr(0), sizeof(tmp));
}
