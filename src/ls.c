#include <syslib.h>

int flag[256];
char curpath[MAXPATHLEN];
int curpathlen;

void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
	int r;
	struct Stat st;
	char fullpath[MAXPATHLEN];

	if (path[0] == '.') {
		strcpy(fullpath, curpath);
		strcpy(fullpath+curpathlen, path);
		path = fullpath;
	}
	if ((r = stat(path, &st)) < 0)
		panic("stat %s: %e", path, r);
	if (st.st_isdir && !flag['d'])
		lsdir(path, path);
	else
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
	int fd, n, len, r;
	struct DirEntry f;
	struct Stat st;
	char fullpath[MAXPATHLEN];

	len = strlen(path);
	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0]) {
			strcpy(fullpath, path);
			strcpy(fullpath+len, f.f_name);
			if ((r = stat(fullpath, &st)) < 0)
				panic("stat %s: %e", fullpath, r);
			ls1(prefix, st.st_isdir, st.st_size, f.f_name);
		}
	if (n > 0)
		panic("short read in directory %s", path);
	if (n < 0)
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
		printf("%s%s", prefix, sep);
	}
	printf("%s", name);
	if(flag['F'] && isdir)
		printf("/");
	printf("\n");
}

void
usage(void)
{
	printf("usage: ls [file...]\n");
	exit();
}


void load_curpath(){
	int glb_var_fd;

	// load curpath
	if ((glb_var_fd = open("/.global_var", O_RDONLY)) < 0)
		panic("open %s: %e", "/.global_var", glb_var_fd);
	curpathlen = readn(glb_var_fd, curpath, MAXPATHLEN);
	curpath[curpathlen] = '\0';
	close(glb_var_fd);
}

void
umain(int argc, char **argv)
{
	int i;
	struct Argstate args;

	load_curpath();

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
			break;
		default:
			usage();
		}

	if (argc == 1)
		ls(curpath, curpath);
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
	}
}
