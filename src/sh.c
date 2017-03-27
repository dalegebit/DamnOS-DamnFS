#include <syslib.h>

#define BUFSIZ 1024		/* Find the buffer overrun bug! */
char buf[BUFSIZ];
int debug = 0;


int flag[256];
char curpath[MAXPATHLEN];
char oldpath[MAXPATHLEN];
char fullpath[MAXPATHLEN];

void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
update_curpath(const char *post, int size)
{
	int len = strlen(curpath);
	if (size > 0) {
		if (post[0] != '/' && curpath[len-1] != '/')
			curpath[len++] = '/';
		memcpy(curpath+len, post, size);
		curpath[len+size] = '\0';
	}
	else {
		int i = len-1;
		while(curpath[i] != '/' && i > 1)
			--i;
		curpath[i] = 0;
	}
}
void

update_fullpath(const char *post)
{
	int len = strlen(curpath);
	strcpy(fullpath, curpath);
	if (curpath[len-1] != '/') {
		fullpath[len] = '/';
		fullpath[++len] = '\0';
	}
	strcpy(fullpath+len, post);
}


int
cd(const char *path)
{
	int end = 0, end1, fd, r, n;
	struct Stat st;
	struct DirEntry f;

	if (path[0] == '\0')
		return 0;

	if (path[0] == '/')
		path++;

	while (path[end] != '/' && path[end])
		++end;
	if (!path[end] && end == 0)
		return 0;

	char target[MAXNAMELEN];
	memcpy(target, path, end);
	target[end] = 0;

	if (end > MAXNAMELEN) {
		update_fullpath(target);
		printf("cd %s: %e\n", fullpath, -E_BAD_NAME);
		return -1;
	}
	if (path[end] && end == 0) {
		update_fullpath("/");
		printf("cd %s: %e\n", fullpath, -E_BAD_PATH);
		return -1;
	}



	update_fullpath(target);

	if ((r = stat(curpath, &st)) < 0) {
		printf("cd %s: %e\n", fullpath, r);
		return r;
	}
	if (!st.st_isdir) {
		printf("cd %s: not a directory\n", fullpath);
		return r;
	}

	if ((fd = open(curpath, O_RDONLY)) < 0) {
		printf("cd %s: %e\n", path, fd);
		return fd;
	}
	while ((n = readn(fd, &f, sizeof f)) == sizeof f) {
		if (strcmp(f.f_name, target) == 0) {
			if (strcmp(f.f_name, "..") == 0 && strcmp(curpath, "/") != 0)
				update_curpath("", -1);
			else if (strcmp(f.f_name, "..") != 0 && strcmp(f.f_name, ".") != 0)
				update_curpath(target, end);
			close(fd);
			return cd(path+end);
		}
	}

	printf("cd %s: no such directory\n", fullpath);
	close(fd);
	return -1;
}

void
pwd()
{
	printf("    %s\n", curpath);
	return;
}



void
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0 && n < BUFSIZ)
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
mkdir(const char *path)
{
	int r;
	struct Stat st;

	if (path[0] != '/') {
		update_fullpath(path);
		path = fullpath;
	}
	if ((r = stat(path, &st)) < 0) {
		if (r != -E_NOT_FOUND) {
			printf("mkdir %s: %e", path, r);
		}
		if ((r = makedir(path)) < 0) {
			printf("mkdir %s: %e", path, r);
		}
		return;
	}
	printf("mkdir %s: %e\n", path, -E_FILE_EXISTS);
}

void
rm(const char *path)
{
	int r;
	struct Stat st;

	if (path[0] != '/') {
		update_fullpath(path);
		path = fullpath;
	}
	if ((r = stat(path, &st)) < 0) {
		printf("rm %s: %e\n", path, r);
		return;
	}
	if (st.st_isdir && st.st_size > 2*DIRESIZE) {
		printf("rm %s: not an empty directory\n", path);
		return;
	}
	if ((r = remove(path)) < 0) {
		printf("rm %s: %e\n", path, r);
	}
}

void
ls(const char *path, const char *prefix)
{
	int r;
	struct Stat st;

	if (path[0] == '.') {
		update_fullpath(path);
		path = fullpath;
	}
	if ((r = stat(path, &st)) < 0) {
		printf("ls %s: %e", path, r);
	}
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

	len = strlen(path);
	if ((fd = open(path, O_RDONLY)) < 0) {
		printf("ls %s: %e\n", path, fd);
		return;
	}
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0]) {
			update_fullpath(f.f_name);
			if ((r = stat(fullpath, &st)) < 0)
				printf("ls %s: %e\n", fullpath, r);
			ls1(prefix, st.st_isdir, st.st_size, f.f_name);
		}
	close(fd);
	if (n > 0)
		panic("short read in directory %s\n", path);
	if (n < 0)
		panic("error reading directory %s: %e\n", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
	const char *sep;

	printf("%6d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
		printf("%s%s", prefix, sep);
	}
	printf("%s", name);
	printf("\n");
}

void
pingpong()
{
	envid_t who;

	if ((who = fork()) != 0) {
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
		if (i >= 10)
			return;
		i++;
		ipc_send(who, i, 0, 0);
		if (i >= 10)
			return;
	}
}

void load_curpath(){
	int glb_var_fd;

	// load curpath
	if ((glb_var_fd = open("/.global_var", O_RDONLY)) < 0)
		printf("open %s: %e", "/.global_var", glb_var_fd);
	int curpathlen = readn(glb_var_fd, curpath, MAXPATHLEN);
	curpath[curpathlen] = '\0';
	close(glb_var_fd);
}




void save_curpath(){
	int glb_var_fd;

	// store curpath
	if ((glb_var_fd = open("/.global_var", O_WRONLY|O_CREAT)) < 0)
		panic("open %s: %e", "/.global_var", glb_var_fd);
	write(glb_var_fd, curpath, strlen(curpath));
	close(glb_var_fd);
	//printf("save_curpath done\n");

}

// gettoken(s, 0) prepares gettoken for subsequent calls and returns 0.
// gettoken(0, token) parses a shell token from the previously set string,
// null-terminates that token, stores the token pointer in '*token',
// and returns a token ID (0, '<', '>', '|', or 'w').
// Subsequent calls to 'gettoken(0, token)' will return subsequent
// tokens from the string.
int gettoken(char *s, char **token);


// Parse a shell command from string 's' and execute it.
// Do not return until the shell command is finished.
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
				cprintf("too many arguments\n");
				exit();
			}
			argv[argc++] = t;
			break;

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
				cprintf("syntax error: < not followed by word\n");
				exit();
			}
			// Open 't' for reading as file descriptor 0
			// (which environments use as standard input).
			// We can't open a file onto a particular descriptor,
			// so open the file as 'fd',
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// panic("< redirection not implemented");
			update_fullpath(t);
			if((fd = open(fullpath, O_RDONLY)) < 0)
			{
				cprintf("open %s for read: %e", t, fd);
				exit();
			}
			if(fd != 0)
			{
				dup(fd, 0);
				close(fd);
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
				cprintf("syntax error: > not followed by word\n");
				exit();
			}
			update_fullpath(t);
			if ((fd = open(fullpath, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
				cprintf("open %s for write: %e", t, fd);
				exit();
			}
			if (fd != 1) {
				dup(fd, 1);
				close(fd);
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
				cprintf("pipe: %e", r);
				exit();
			}
			if (debug)
				cprintf("PIPE: %d %d\n", p[0], p[1]);
			if ((r = fork()) < 0) {
				cprintf("fork: %e", r);
				exit();
			}
			if (r == 0) {
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
			} else {
				pipe_child = r;
				if (p[1] != 1) {
					dup(p[1], 1);
					close(p[1]);
				}
				close(p[0]);
				goto runit;
			}
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
			break;

		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
		if (debug)
			cprintf("EMPTY COMMAND\n");
		return;
	}


	if (argv[0][0] == 'c' && argv[0][1] == 'd' && argv[0][2] == 0) {
		if (argc == 1)
			strcpy(curpath, "/");
		else if (argc == 2) {
			strcpy(oldpath, curpath);
			if (argv[1][0] == '/') {
				curpath[0] = '/';
				argv0buf[0] = 0;
				strcpy(argv0buf, argv[1]+1);
				argv[1] = argv0buf;
			}
			//cprintf("%s\n", argv[1]);
			if (cd(argv[1]) < 0)
				strcpy(curpath, oldpath);
			save_curpath();
		}
		else {
			printf("usage: cd [path]\n");
		}
		return;
	}

	if (argv[0][0] == 'p' && argv[0][1] == 'w' && argv[0][2] == 'd' && argv[0][3] == 0) {
	 	pwd();
		exit();
	}

	if (argv[0][0] == 'r' && argv[0][1] == 'm' && argv[0][2] == 0) {
		if (argc != 2)
			printf("usage: rm [path]\n");
		else {
			update_fullpath(argv[1]);
			rm(fullpath);
		}
		exit();
	}

	if (argv[0][0] == 'm' && argv[0][1] == 'k' && argv[0][2] == 'd' && argv[0][3] == 'i' && argv[0][4] == 'r' && argv[0][5] == 0) {
		if (argc != 2)
			printf("usage: mkdir [path]\n");
		else {
			update_fullpath(argv[1]);
			mkdir(fullpath);
		}
		exit();
	}

	if (argv[0][0] == 'e' && argv[0][1] == 'c' && argv[0][2] == 'h' && argv[0][3] == 'o' && argv[0][4] == 0) {
		int i, nflag;

		nflag = 0;
		
		for (i = 1; i < argc; i++) {
			if (i > 1)
				write(1, " ", 1);
			write(1, argv[i], strlen(argv[i]));
		}
		if (!nflag)
			write(1, "\n", 1);
		exit();
	}

	if (argv[0][0] == 'p' && argv[0][1] == 'i' && argv[0][2] == 'n' && argv[0][3] == 'g' \
		&& argv[0][4] == 'p' && argv[0][5] == 'o' && argv[0][6] == 'n' && argv[0][7] == 'g' && argv[0][8] == 0 ) {
			pingpong();
			exit();
	}

	if (argv[0][0] == 'c' && argv[0][1] == 'a' && argv[0][2] == 't' && argv[0][3] == 0) {
		int f, i;

		if (argc == 1)
			cat(0, "<stdin>");
		else
			for (i = 1; i < argc; i++) {
				update_fullpath(argv[i]);
				f = open(fullpath, O_RDONLY);
				if (f < 0)
					printf("can't open %s: %e\n", argv[i], f);
				else {
					cat(f, fullpath);
					close(f);
				}
			}
		exit();
	}


	if (argv[0][0] == 'l' && argv[0][1] == 's' && argv[0][2] == 0) {
		if (argc == 1)
			ls(curpath, curpath);
		else
			ls(argv[1], argv[1]);
		exit();
	}
	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
		strcpy(argv0buf, curpath);
		strcpy(argv0buf + 1, argv[0]);
		argv[0] = argv0buf;
	}
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
			cprintf(" %s", argv[i]);
		cprintf("\n");
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
		wait(r);
		if (debug)
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
		if (debug)
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
		wait(pipe_child);
		if (debug)
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}


// Get the next token from string s.
// Set *p1 to the beginning of the token and *p2 just past the token.
// Returns
//	0 for end-of-string;
//	< for <;
//	> for >;
//	| for |;
//	w for a word.
//
// Eventually (once we parse the space where the \0 will go),
// words get nul-terminated.
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}

int
gettoken(char *s, char **p1)
{
	static int c, nc;
	static char* np1, *np2;

	if (s) {
		nc = _gettoken(s, &np1, &np2);
		return 0;
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}


void
usage(void)
{
	cprintf("usage: sh [-dix] [command-file]\n");
	exit();
}

void
umain(int argc, char **argv)
{
	int interactive, echocmds;
	struct Argstate args;
	int r;

	cprintf("initsh: running sh\n");

	// being run directly from kernel, so no file descriptors open yet
	close(0);
	if ((r = opencons()) < 0)
		panic("opencons: %e", r);
	if (r != 0)
		panic("first opencons used fd %d", r);
	if ((r = dup(0, 1)) < 0)
		panic("dup: %e", r);

	cprintf("initsh: starting sh\n");


	curpath[0] = '/', curpath[1] = '\0';
	save_curpath();

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
		}

	if (argc > 2)
		usage();
	if (argc == 2) {
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
	}
	if (interactive == '?')
		interactive = iscons(0);

	while (1) {
		char *buf;

		buf = readline(interactive ? "$> " : NULL);
		if (buf == NULL) {
			if (debug)
				cprintf("EXITING\n");
			exit();	// end of file
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
		if (debug)
			cprintf("BEFORE FORK\n");
		if (strlen(buf) >= 2 && buf[0] == 'c' && buf[1] == 'd') {
			runcmd(buf);
			continue;
		}
		if ((r = fork()) < 0)
			panic("fork: %e", r);
		if (debug)
			cprintf("FORK: %d\n", r);
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
	}
}
