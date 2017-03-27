#include "myfs.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define MIN(a,b) (((a)>(b))?(b):(a))
#define MAX_STR_LEN 1024

struct DirEntry * rt_dir;
struct DamnInode * inode;
index_t rt_ind = 0;
struct DamnSuperBlock sb;
FILE * file;

int shoutup;


int 
main(int argc, char ** argv)
{
	
	if (argc != 3) {
		printf("Usage: ./damn [command] [path]\n");
		return 0;
	}
	
	
	file = fopen("./fs.img", "r+");
	
	
	char * cur_block;
	
	
	fseek(file, 0, 0);
	fread((void*)&sb, sizeof(struct DamnSuperBlock), 1, file);

	if (sb.magic != DAMN_MAGIC) {
		printf("File system error!\n");
		return 0;
	}

	/* printf("%d\n", ROUNDUP(340, sb.block_size)); */

	inode = (struct DamnInode *)malloc(sb.inode_size*sb.inode_num);
	fseek(file, sb.inode_entry, 0);
	fread((void*)inode, sb.inode_size, sb.inode_num, file);
	if (inode[rt_ind].block_used == 0 || inode[rt_ind].type != 'd') {
		print_inode(rt_ind);
		printf("File system error!\n");
		return 0;
	}
	
	
	cur_block = (char *)malloc(sb.block_size);
	fseek(file, sb.block_entry + sb.block_size * inode[rt_ind].block_index[0], 0);
	fread((void*)cur_block, sb.block_size, 1, file);
	rt_dir = (struct DirEntry*)cur_block;
	
	char * path = argv[2];
	char * cmd = argv[1];
	
	if (strcmp(cmd, "ls") == 0)
		ls(path);
	else if(strcmp(cmd, "touch") == 0)
		touch(path);
	else if(strcmp(cmd, "mkdir") == 0)
		mkdir(path);
	else if(strcmp(cmd, "rm") == 0)
		rm(path);
	else if(strcmp(cmd, "cat") == 0)
		cat(path);
	else if (strcmp(cmd, "edit") == 0)
		edit(path);
	
	if (sync_inode() == 0 || sync_sb() == 0)
		printf("sync error!\n");
	free(cur_block);
	free(inode);
	fclose(file);
}




int 
isvalid(char c) 
{
	return (c == '.') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c == '.') || (c == '_') || (c == '-') || (c >= '0' && c <= '9');
}


void 
print_inode(index_t inode_ind) 
{
	struct DamnInode inode_in = inode[inode_ind];
	printf("index:%d\ntype:%c\nsize:%d\nblock_used:%d\n", inode_ind, inode_in.type, inode_in.size, inode_in.block_used);
	int i;
	for (i = 0; i < inode_in.block_used; ++i) 
		printf("block %d: %d\n", i, inode_in.block_index[i]);
}

void
print_block_status(index_t begin, ushort len)
{
	int i;
	for (i = begin; i < MIN(sb.block_num, begin+len); ++i) {
		if ((i+1%8) == 0)
			printf("\n");
		printf("%d", sb.block_avai[i]);
	}
	printf("\n");
}

void
print_inode_status(index_t begin, ushort len)
{
	int i;
	for (i = begin; i < MIN(sb.inode_num, begin+len); ++i) {
		if ((i+1%8) == 0)
			printf("\n");
		printf("%d", sb.inode_avai[i]);
	}
	printf("\n");
}	


int 
findpath(char * path, index_t * inode_ind) 
{
	
	int i = 0, j = 0, k = 0;
	int fail = 0, found = 1;
	
	struct DirEntry * cur_dir = (struct DirEntry *)malloc(sb.block_size);
	memcpy(cur_dir, rt_dir, sb.block_size);
	index_t cur_inode_ind = rt_ind;
	char tmp[MAX_FILE_NAME];
	int fn_len = 0;
			
		
	while (k < inode[cur_inode_ind].block_used) {
		
		if (found == 1) {
			if (path[i] != '/') {
				fail = 1;
				break;
			}
			if (inode[cur_inode_ind].type != 'd') {
				fail = 1;
				break;
			}

			i++;
			fn_len = 0;
			while (isvalid(path[i]) && fn_len < MAX_FILE_NAME) {
				tmp[fn_len++] = path[i++];
			}
			tmp[fn_len] = 0;
			if (fn_len == 0)
				break;
		}
		j = 0;
		found = 0;
		
		int limit = MIN(inode[cur_inode_ind].size-k*sb.block_size, sb.block_size)/sizeof(struct DirEntry) 

		while (j < limit && strcmp(tmp, cur_dir[j].file) != 0) j ++;
		
		
		if (j < limit) {
			found = 1;
			cur_inode_ind = cur_dir[j].inode_index;
			// print_inode(inode[cur_inode_ind]);
			if (inode[cur_inode_ind].block_used == 0) {
				fail = 1;
				break;
			}
			read_block((void*)cur_dir, inode[cur_inode_ind].block_index[0]);
			k = 0;
		}
		else if (inode[cur_inode_ind].size > (k+1) * sb.block_size) {
			k++;
			if (k >= inode[cur_inode_ind].block_used) {
				fail = 1;
				break;
			}
			read_block((void*)cur_dir, inode[cur_inode_ind].block_index[k]);
		}
		else 
			break;
		if (!path[i])
			break;
	}		

	free(cur_dir);

	if (fail || !found) {
		if (shoutup == 0)
			printf("Unvalid path: %s\n", path);
		return 0;
	}
	else {
		*inode_ind = cur_inode_ind;
		return 1;
	}
	
}



static int
read_block(void* dest_buf, index_t block_ind)
{
	int suc = 0;
	suc = fseek(file, sb.block_entry + sb.block_size * block_ind, 0);
	suc = fread(dest_buf, sb.block_size, 1, file);
	if (suc == 0)
		return 0;
	return 1;
}


static int
write_block(void* src_buf, index_t block_ind)
{
	int suc = 0;
	suc = fseek(file, sb.block_entry + sb.block_size * block_ind, 0);
	suc = fwrite(src_buf, sb.block_size, 1, file);
	if (suc == 0)
		return 0;
	return 1;
}

static int
sync_inode()
{
	int suc = 0;
	suc = fseek(file, sb.inode_entry, 0);
	suc = fwrite((void*)inode, sb.inode_size, sb.inode_num, file);
	if (suc == 0)
		return 0;
	return 1;	
}

static int
sync_sb()
{
	int suc = 0;
	suc = fseek(file, 0, 0);
	suc = fwrite((void*)&sb, sizeof(struct DamnSuperBlock), 1, file);
	if (suc = 0)
		return 0;
	return 1;
}


static int
allocb(index_t * block_ind)
{
	int i;
	for (i = 0; i < sb.block_num; ++i)
		if (sb.block_avai[i] == 0)
			break;
	if (i >= sb.block_num) {
		printf("Not enough block.\n");
		return 0;
	}
	sb.block_avai[i] = 1;
	*block_ind = i;
	return 1;
}


static int
alloci(index_t * inode_ind)
{
	int i;
	for (i = 0; i < sb.inode_num; ++i)
		if (sb.inode_avai[i] == 0)
			break;
	if (i >= sb.inode_num) {
		printf("Not enough inode.\n");
		return 0;
	}
	sb.inode_avai[i] = 1;
	*inode_ind = i;
	return 1;
}

static int
zero_block(index_t block_ind)
{
	int suc = 0;
	if (block_ind >= sb.block_num)
		return 0;
	char * zb = (char*)malloc(sb.block_size);
	memset(zb, 0, sb.block_size);
	suc = write_block((void*)zb, block_ind)==0?0:1;
	free(zb);
	return suc;
}

static int
zero_inode(index_t inode_ind)
{
	if (inode_ind >= sb.inode_num)
		return 0;
	memset(inode + sb.inode_size*inode_ind, 0, sb.inode_size);
	return 1;
}


static int
create_instance(index_t inode_ind, index_t block_ind, char type)
{
	if (sb.block_avai[block_ind] != 1 || sb.inode_avai[block_ind] != 1)
		return 0;
	zero_inode(inode_ind);
	zero_block(block_ind);
	inode[inode_ind].block_index[inode[inode_ind].block_used++] = block_ind;
	inode[inode_ind].type = type;
	return 1;
}



static int
new_block_for_file(index_t inode_ind)
{
	index_t new_block_ind;
	if (inode[inode_ind].block_used == 8) {
		if (inode[inode_ind].type == 'd')
			printf("This directory is full.\n");
		else if(inode[inode_ind].type == 'f')
			printf("This file is full\n");
		return 0;
	}
	if (allocb(&new_block_ind) == 0)
		return 0;
	inode[inode_ind].block_index[inode[inode_ind].block_used++] = new_block_ind;
	zero_block(new_block_ind);


#ifdef DEBUG
	printf("new_block_for_file succeed!\n");
#endif

	return 1;
}


static int
free_block_for_file(index_t inode_ind)
{
	if (inode[inode_ind].block_used <= 0)
		return 0;
	index_t free_block_ind = inode[inode_ind].block_index[--(inode[inode_ind].block_used)];
	sb.block_avai[free_block_ind] = 0;
}


static int
find_entry_by_name(index_t 		dir_inode_ind, 
					struct 		DirEntry * cur_dir, 
					char * 		file_name, 
					index_t *	block_ind,
					index_t * 	entry_ind)
{

	int found = 0;
	int i, j;
	

	i = 0;
	while (i < inode[dir_inode_ind].block_used) {
		
		read_block((void*)cur_dir, inode[dir_inode_ind].block_index[i]);
		
		j = 0;
		while (j < MIN(inode[dir_inode_ind].size-i*sb.block_size, sb.block_size)/sizeof(struct DirEntry) && strcmp(file_name, cur_dir[j].file) != 0) j ++;
		
			
		if (j < MIN(inode[dir_inode_ind].size-i*sb.block_size, sb.block_size)/sizeof(struct DirEntry)) {
			found = 1;
			break;
		}
	}		
	if (!found) 
		return 0;

	*block_ind = inode[dir_inode_ind].block_index[i];
	*entry_ind = j;
	return 1; 
}





static int
find_entry_by_inode(index_t 		dir_inode_ind, 
					struct 		DirEntry * cur_dir, 
					index_t 	inode_ind,
					index_t *	block_ind,
					index_t * 	entry_ind)
{

	int found = 0;
	int i, j;
	

	i = 0;
	while (i < inode[dir_inode_ind].block_used) {
		
		read_block((void*)cur_dir, inode[dir_inode_ind].block_index[i]);
		
		j = 0;
		while (j < MIN(inode[dir_inode_ind].size-i*sb.block_size, sb.block_size)/sizeof(struct DirEntry) && cur_dir[j].inode_index != inode_ind) j ++;
		
			
		if (j < MIN(inode[dir_inode_ind].size-i*sb.block_size, sb.block_size)/sizeof(struct DirEntry)) {
			found = 1;
			break;
		}
	}		
	if (!found) 
		return 0;
	
	*block_ind = inode[dir_inode_ind].block_index[i];
	*entry_ind = j;
	return 1; 
}	


static int
link(index_t dir_inode_ind, char * file_name, index_t inode_ind)
{
	struct DirEntry file_entry;
	index_t insert_pos = (inode[dir_inode_ind].size - (inode[dir_inode_ind].block_used-1)*sb.block_size)/sizeof(struct DirEntry);
	//printf("insert_pos: %d\n", insert_pos);
	if (insert_pos == sb.block_size/sizeof(struct DirEntry)) {
		if (new_block_for_file(dir_inode_ind) == 0)
			return 0;
		insert_pos = 0;
	}
	inode[dir_inode_ind].size += sizeof(struct DirEntry);

	strcpy(file_entry.file, file_name);
	file_entry.inode_index = inode_ind;


	struct DirEntry * cur_dir = (struct DirEntry*)malloc(sb.block_size);
	//print_inode(dir_inode_ind);
	read_block((void*)cur_dir, inode[dir_inode_ind].block_index[inode[dir_inode_ind].block_used-1]);
	cur_dir[insert_pos] = file_entry;
	write_block((void*)cur_dir, inode[dir_inode_ind].block_index[inode[dir_inode_ind].block_used-1]); 
	free(cur_dir);

#ifdef DEBUG
	printf("link succeed!\n");
#endif

	return 1;
}




static int
unlink_via_name(index_t dir_inode_ind, char * file_name, index_t * inode_ind)
{
	index_t rm_pos, last_pos;
	index_t block_ind;
	struct DirEntry file_entry;
	
	struct DirEntry * cur_dir = (struct DirEntry*)malloc(sb.block_size);
	
	read_block((void*)cur_dir, inode[dir_inode_ind].block_index[inode[dir_inode_ind].block_used-1]);
	last_pos = (inode[dir_inode_ind].size - (inode[dir_inode_ind].block_used-1)*sb.block_size)/sizeof(struct DirEntry);
	file_entry = cur_dir[last_pos];
	
	

	if (find_entry_by_name(dir_inode_ind, cur_dir, file_name, &block_ind, &rm_pos) == 0) {
		free(cur_dir);
		return 0;
	}

	*inode_ind = cur_dir[rm_pos].inode_index;
	cur_dir[rm_pos] = file_entry;
	write_block((void*)cur_dir, block_ind);

	if (last_pos == 1)
		free_block_for_file(dir_inode_ind);

	inode[dir_inode_ind].size -= sizeof(struct DirEntry);

	free(cur_dir);
	return 1;
}


static int
unlink_via_inode(index_t dir_inode_ind, index_t inode_ind)
{
	index_t rm_pos, last_pos;
	index_t block_ind;
	struct DirEntry file_entry;
	
	struct DirEntry * cur_dir = (struct DirEntry*)malloc(sb.block_size);
	
	read_block((void*)cur_dir, inode[dir_inode_ind].block_index[inode[dir_inode_ind].block_used-1]);
	last_pos = (inode[dir_inode_ind].size - (inode[dir_inode_ind].block_used-1)*sb.block_size)/sizeof(struct DirEntry);
	file_entry = cur_dir[last_pos];
	
	

	if (find_entry_by_inode(dir_inode_ind, cur_dir, inode_ind, &block_ind, &rm_pos) == 0) {
		free(cur_dir);
		return 0;
	}
	cur_dir[rm_pos] = file_entry;
	write_block((void*)cur_dir, block_ind);

	if (last_pos == 1)
		free_block_for_file(dir_inode_ind);

	inode[dir_inode_ind].size -= sizeof(struct DirEntry);

	free(cur_dir);
	return 1;
}


static int
create_file(index_t dir_inode_ind, char * file_name, char type)
{
	index_t inode_ind, block_ind;

	if (strlen(file_name) >= MAX_FILE_NAME || (type != 'd' && type != 'f'))
		return 0;

	//print_inode_status(0, 8);
	if (alloci(&inode_ind) == 0 || allocb(&block_ind) == 0)
		return 0;

	//print_inode_status(0, 8);
	if (create_instance(inode_ind, block_ind, type) == 0)
		return 0;
	
	//print_inode_status(0, 8);
	if (link(dir_inode_ind, file_name, inode_ind) == 0)
		return 0;
	
	if (type == 'd') {
		link(inode_ind, ".", inode_ind);
		link(inode_ind, "..", dir_inode_ind);
	}

#ifdef DEBUG
	printf("create_file succeed!\n");
#endif

	return 1;
}



static int
create_file_via_path(char * path, char type)
{
	index_t cur_inode_ind;
	char file_name[MAX_FILE_NAME];
	int path_len = strlen(path);
	int i, j;
	i = path_len - 1;
	while (i >= 0 && isvalid(path[i])) --i;

	if (i == path_len-1  || i < 0 || path[i] != '/' || path_len-i > MAX_FILE_NAME) {
		printf("Unvalid file name.\n");
		return 0;
	}
	
	strcpy(file_name, path+i+1);

	shoutup = 1;
	
	if (findpath(path, &cur_inode_ind) != 0) {
		if (inode[cur_inode_ind].type == 'd')
			printf("It's a directory.\n");
		else if (inode[cur_inode_ind].type == 'f')
			printf("File exists.\n");
		return 1;
	}

	char tmp = path[i+1];
	path[i+1] = 0;
	if (findpath(path, &cur_inode_ind) == 0)
		return 0;
	if (inode[cur_inode_ind].type != 'd') {
		printf("Cannot create file on %path: it's a file\n", path);
		return 0;
	}
	path[i+1] = tmp;
	
	shoutup = 0;
	

	if (create_file(cur_inode_ind, file_name, type) == 0) {
		printf("Cannot create %s: %s\n", type=='d'?"directory":"file", path);
		return 0;
	}


#ifdef DEBUG
	printf("create_file_via_path succeed!\n");
#endif


	return 1;
}

static int
remove_file(index_t dir_inode_ind, char * file_name)
{
	index_t inode_ind, dir_block_ind;
	int i;

	struct DirEntry * cur_dir = (struct DirEntry *)malloc(sb.block_size);
	if (unlink_via_name(dir_inode_ind, file_name, &inode_ind) == 0) {
		free(cur_dir);
		return 0;
	}

	for (i = 0; i < inode[inode_ind].block_used; ++i)
		sb.block_avai[i] = 0;
	sb.inode_avai[inode_ind] = 0;
	return 1;
}


static int
remove_file_via_path(char * path)
{
	index_t cur_inode_ind;
	char file_name[MAX_FILE_NAME];
	int path_len = strlen(path);
	int i, j;
	i = path_len - 1;
	while (i >= 0 && isvalid(path[i])) --i;

	if (i == path_len-1  || i < 0 || path[i] != '/' || path_len-i > MAX_FILE_NAME) {
		printf("Unvalid file name.\n");
		return 0;
	}
	
	strcpy(file_name, path+i+1);
	
	if (strcmp(file_name, ".") == 0 || strcmp(file_name, "..") == 0) {
		printf("Unvalid file name.\n");
		return 0;	
	}

	
	if (findpath(path, &cur_inode_ind) == 0)
		return 0;

	if (inode[cur_inode_ind].type == 'd' && inode[cur_inode_ind].size > 2*sizeof(struct DirEntry)) {
		printf("Not removed. The directory is not empty.\n");
		return 0;	
	}


	char tmp = path[i+1];
	path[i+1] = 0;
	if (findpath(path, &cur_inode_ind) == 0)
		return 0;
	if (inode[cur_inode_ind].type != 'd') {
		printf("Cannot remove file on %path: it's a file\n", path);
		return 0;
	}
	path[i+1] = tmp;	
	

	if (remove_file(cur_inode_ind, file_name) == 0) {
		printf("Cannot remove : %s\n", path);
		return 0;
	}
	return 1;
}

static int
read_file(char* buf, index_t inode_ind)
{


	if (inode[inode_ind].type == 'd') {
		printf("It's a directory!\n");
		return 0;
	}
	
	char * tmp = (char *)malloc(sb.block_size);
	int file_size = inode[inode_ind].size;
	int i, j;

	i = 0;
	j = 0;
	while (i < inode[inode_ind].block_used) {
		read_block((void*) tmp, inode[inode_ind].block_index[i]);
		memcpy(buf + j, tmp, MIN(file_size, sb.block_size));
		file_size -= sb.block_size;
		j += sb.block_size;
		i ++;
	}
	
	free(tmp);
	return 1;
}

static int
write_file(char* str, index_t inode_ind)
{
	int size = strlen(str);
	int block_used = ROUNDUP(size, sb.block_size)/sb.block_size;
	int i, j;
	
	if (block_used > 8) {
		printf("Exceeded file size limit!\n");
		return 0;
	}
	
	if (block_used > inode[inode_ind].block_used)
		while (block_used > inode[inode_ind].block_used)
			new_block_for_file(inode_ind);
	else if (block_used < inode[inode_ind].block_used)
		while (block_used < inode[inode_ind].block_used)
			free_block_for_file(inode_ind);
	
	inode[inode_ind].size = size;

	char * tmp = (char *)malloc(sb.block_size);

	i = 0;
	j = 0;
	while (i < block_used) {
		memcpy(tmp, str+j, MIN(size-j, sb.block_size));
		write_block(tmp, inode[inode_ind].block_index[i]);
		j += sb.block_size;
		i ++;
	}

	free(tmp);
	return 1;
}



int 
ls(char * path)
{

	index_t cur_inode_ind;

	if (findpath(path, &cur_inode_ind) == 0)
		return 0;
	if (inode[cur_inode_ind].type != 'd') {
		printf("It's not a directory!\n");
		return 0;
	}

	struct DirEntry * cur_dir = (struct DirEntry *)malloc(sb.block_size);

	int i = 0, j = 0;
	int dir_size = inode[cur_inode_ind].size;

	while (i < inode[cur_inode_ind].block_used) {
		
		read_block((void*)cur_dir, inode[cur_inode_ind].block_index[i]);
		
		j = 0;
		while (j < MIN(dir_size, sb.block_size)/sizeof(struct DirEntry)) {
			printf("%c\t%-12s\t%d\n", inode[cur_dir[j].inode_index].type, cur_dir[j].file, inode[cur_dir[j].inode_index].size);
			j ++;
		}
		dir_size -= sb.block_size;
	 	i++;
	}

	free(cur_dir);
	return 1;
}



int
touch(char * path)
{
	if (create_file_via_path(path, 'f') == 0)
		return 0;
	printf("Touch succeeded: %s\n", path);
	return 1;

}



int 
mkdir(char * path) 
{
	if (create_file_via_path(path, 'd') == 0)
		return 0;
	printf("Mkdir succeeded: %s\n", path);
	return 1;
}


int
rm(char * path)
{
	if (remove_file_via_path(path) == 0)
		return 0;
	printf("Remove succeeded: %s\n", path);
	return 1;
}

int
cat(char * path)
{	
	index_t inode_ind;
	if (findpath(path, &inode_ind) == 0)
		return 0;
	int size = inode[inode_ind].size;

	char * buf = (char *)malloc(size);
	if (read_file(buf, inode_ind) == 0) {
		free(buf);
		return 0;
	}
	printf("%s\n", buf);
	return 1;
}

int
edit(char * path)
{
	index_t inode_ind;
	if (findpath(path, &inode_ind) == 0)
		return 0;

	printf("Please input the content:\n");
	
	char * str = (char *)malloc(MAX_STR_LEN);
	scanf("%s", str);
	if (write_file(str, inode_ind) == 0) {
		free(str);
		return 0;
	}
	printf("Edit succeed!\n");
	free(str);
	return 1;
}
