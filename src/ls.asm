
ls:     file format elf32-i386


Disassembly of section .text:

80001020 <_start>:
;// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	;// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
80001020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
80001026:	75 04                	jne    8000102c <args_exist>

	;// If not, push dummy argc/argv arguments.
	;// This happens when we are loaded by the kernel,
	;// because the kernel does not know about passing arguments.
	pushl $0
80001028:	6a 00                	push   $0x0
	pushl $0
8000102a:	6a 00                	push   $0x0

8000102c <args_exist>:

args_exist:
	call libmain
8000102c:	e8 df 07 00 00       	call   80001810 <libmain>
1:	jmp 1b
80001031:	eb fe                	jmp    80001031 <args_exist+0x5>

80001033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
80001033:	55                   	push   %ebp
80001034:	89 e5                	mov    %esp,%ebp
80001036:	56                   	push   %esi
80001037:	53                   	push   %ebx
80001038:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000103b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
8000103e:	83 3d 70 56 00 80 00 	cmpl   $0x0,0x80005670
80001045:	74 20                	je     80001067 <ls1+0x34>
		printf("%11d %c ", size, isdir ? 'd' : '-');
80001047:	89 f0                	mov    %esi,%eax
80001049:	3c 01                	cmp    $0x1,%al
8000104b:	19 c0                	sbb    %eax,%eax
8000104d:	83 e0 c9             	and    $0xffffffc9,%eax
80001050:	83 c0 64             	add    $0x64,%eax
80001053:	83 ec 04             	sub    $0x4,%esp
80001056:	50                   	push   %eax
80001057:	ff 75 10             	pushl  0x10(%ebp)
8000105a:	68 22 33 00 80       	push   $0x80003322
8000105f:	e8 4d 1f 00 00       	call   80002fb1 <printf>
80001064:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
80001067:	85 db                	test   %ebx,%ebx
80001069:	74 3a                	je     800010a5 <ls1+0x72>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
8000106b:	b8 7c 33 00 80       	mov    $0x8000337c,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
80001070:	80 3b 00             	cmpb   $0x0,(%ebx)
80001073:	74 1e                	je     80001093 <ls1+0x60>
80001075:	83 ec 0c             	sub    $0xc,%esp
80001078:	53                   	push   %ebx
80001079:	e8 56 03 00 00       	call   800013d4 <strlen>
8000107e:	83 c4 10             	add    $0x10,%esp
			sep = "/";
		else
			sep = "";
80001081:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
80001086:	ba 7c 33 00 80       	mov    $0x8000337c,%edx
8000108b:	b8 20 33 00 80       	mov    $0x80003320,%eax
80001090:	0f 44 c2             	cmove  %edx,%eax
		printf("%s%s", prefix, sep);
80001093:	83 ec 04             	sub    $0x4,%esp
80001096:	50                   	push   %eax
80001097:	53                   	push   %ebx
80001098:	68 2b 33 00 80       	push   $0x8000332b
8000109d:	e8 0f 1f 00 00       	call   80002fb1 <printf>
800010a2:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
800010a5:	83 ec 08             	sub    $0x8,%esp
800010a8:	ff 75 14             	pushl  0x14(%ebp)
800010ab:	68 65 33 00 80       	push   $0x80003365
800010b0:	e8 fc 1e 00 00       	call   80002fb1 <printf>
	if(flag['F'] && isdir)
800010b5:	83 c4 10             	add    $0x10,%esp
800010b8:	83 3d d8 55 00 80 00 	cmpl   $0x0,0x800055d8
800010bf:	74 16                	je     800010d7 <ls1+0xa4>
800010c1:	89 f0                	mov    %esi,%eax
800010c3:	84 c0                	test   %al,%al
800010c5:	74 10                	je     800010d7 <ls1+0xa4>
		printf("/");
800010c7:	83 ec 0c             	sub    $0xc,%esp
800010ca:	68 20 33 00 80       	push   $0x80003320
800010cf:	e8 dd 1e 00 00       	call   80002fb1 <printf>
800010d4:	83 c4 10             	add    $0x10,%esp
	printf("\n");
800010d7:	83 ec 0c             	sub    $0xc,%esp
800010da:	68 7b 33 00 80       	push   $0x8000337b
800010df:	e8 cd 1e 00 00       	call   80002fb1 <printf>
}
800010e4:	83 c4 10             	add    $0x10,%esp
800010e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
800010ea:	5b                   	pop    %ebx
800010eb:	5e                   	pop    %esi
800010ec:	5d                   	pop    %ebp
800010ed:	c3                   	ret    

800010ee <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
800010ee:	55                   	push   %ebp
800010ef:	89 e5                	mov    %esp,%ebp
800010f1:	57                   	push   %edi
800010f2:	56                   	push   %esi
800010f3:	53                   	push   %ebx
800010f4:	81 ec d8 00 00 00    	sub    $0xd8,%esp
	int fd, n, len, r;
	struct DirEntry f;
	struct Stat st;
	char fullpath[MAXPATHLEN];

	len = strlen(path);
800010fa:	ff 75 08             	pushl  0x8(%ebp)
800010fd:	e8 d2 02 00 00       	call   800013d4 <strlen>
80001102:	89 c6                	mov    %eax,%esi
	if ((fd = open(path, O_RDONLY)) < 0)
80001104:	83 c4 08             	add    $0x8,%esp
80001107:	6a 00                	push   $0x0
80001109:	ff 75 08             	pushl  0x8(%ebp)
8000110c:	e8 5d 11 00 00       	call   8000226e <open>
80001111:	89 c3                	mov    %eax,%ebx
80001113:	83 c4 10             	add    $0x10,%esp
80001116:	85 c0                	test   %eax,%eax
80001118:	0f 89 8b 00 00 00    	jns    800011a9 <lsdir+0xbb>
		panic("open %s: %e", path, fd);
8000111e:	83 ec 0c             	sub    $0xc,%esp
80001121:	50                   	push   %eax
80001122:	ff 75 08             	pushl  0x8(%ebp)
80001125:	68 30 33 00 80       	push   $0x80003330
8000112a:	6a 28                	push   $0x28
8000112c:	68 3c 33 00 80       	push   $0x8000333c
80001131:	e8 09 20 00 00       	call   8000313f <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0]) {
80001136:	80 7d d6 00          	cmpb   $0x0,-0x2a(%ebp)
8000113a:	74 7f                	je     800011bb <lsdir+0xcd>
			strcpy(fullpath, path);
8000113c:	83 ec 08             	sub    $0x8,%esp
8000113f:	ff 75 08             	pushl  0x8(%ebp)
80001142:	57                   	push   %edi
80001143:	e8 e7 02 00 00       	call   8000142f <strcpy>
			strcpy(fullpath+len, f.f_name);
80001148:	83 c4 08             	add    $0x8,%esp
8000114b:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8000114e:	50                   	push   %eax
8000114f:	ff b5 34 ff ff ff    	pushl  -0xcc(%ebp)
80001155:	e8 d5 02 00 00       	call   8000142f <strcpy>
			if ((r = stat(fullpath, &st)) < 0)
8000115a:	83 c4 08             	add    $0x8,%esp
8000115d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80001160:	50                   	push   %eax
80001161:	57                   	push   %edi
80001162:	e8 50 0f 00 00       	call   800020b7 <stat>
80001167:	83 c4 10             	add    $0x10,%esp
8000116a:	85 c0                	test   %eax,%eax
8000116c:	79 1c                	jns    8000118a <lsdir+0x9c>
				panic("stat %s: %e", fullpath, r);
8000116e:	83 ec 0c             	sub    $0xc,%esp
80001171:	50                   	push   %eax
80001172:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80001178:	50                   	push   %eax
80001179:	68 41 33 00 80       	push   $0x80003341
8000117e:	6a 2e                	push   $0x2e
80001180:	68 3c 33 00 80       	push   $0x8000333c
80001185:	e8 b5 1f 00 00       	call   8000313f <_panic>
			ls1(prefix, st.st_isdir, st.st_size, f.f_name);
8000118a:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8000118d:	50                   	push   %eax
8000118e:	ff 75 c8             	pushl  -0x38(%ebp)
80001191:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80001195:	0f 95 c0             	setne  %al
80001198:	0f b6 c0             	movzbl %al,%eax
8000119b:	50                   	push   %eax
8000119c:	ff 75 0c             	pushl  0xc(%ebp)
8000119f:	e8 8f fe ff ff       	call   80001033 <ls1>
800011a4:	83 c4 10             	add    $0x10,%esp
800011a7:	eb 0f                	jmp    800011b8 <lsdir+0xca>
	len = strlen(path);
	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0]) {
			strcpy(fullpath, path);
800011a9:	8d bd 38 ff ff ff    	lea    -0xc8(%ebp),%edi
			strcpy(fullpath+len, f.f_name);
800011af:	8d 04 37             	lea    (%edi,%esi,1),%eax
800011b2:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
	char fullpath[MAXPATHLEN];

	len = strlen(path);
	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
800011b8:	8d 75 d6             	lea    -0x2a(%ebp),%esi
800011bb:	83 ec 04             	sub    $0x4,%esp
800011be:	6a 12                	push   $0x12
800011c0:	56                   	push   %esi
800011c1:	53                   	push   %ebx
800011c2:	e8 e8 0c 00 00       	call   80001eaf <readn>
800011c7:	83 c4 10             	add    $0x10,%esp
800011ca:	83 f8 12             	cmp    $0x12,%eax
800011cd:	0f 84 63 ff ff ff    	je     80001136 <lsdir+0x48>
			strcpy(fullpath+len, f.f_name);
			if ((r = stat(fullpath, &st)) < 0)
				panic("stat %s: %e", fullpath, r);
			ls1(prefix, st.st_isdir, st.st_size, f.f_name);
		}
	if (n > 0)
800011d3:	85 c0                	test   %eax,%eax
800011d5:	7e 14                	jle    800011eb <lsdir+0xfd>
		panic("short read in directory %s", path);
800011d7:	ff 75 08             	pushl  0x8(%ebp)
800011da:	68 4d 33 00 80       	push   $0x8000334d
800011df:	6a 32                	push   $0x32
800011e1:	68 3c 33 00 80       	push   $0x8000333c
800011e6:	e8 54 1f 00 00       	call   8000313f <_panic>
	if (n < 0)
800011eb:	85 c0                	test   %eax,%eax
800011ed:	79 18                	jns    80001207 <lsdir+0x119>
		panic("error reading directory %s: %e", path, n);
800011ef:	83 ec 0c             	sub    $0xc,%esp
800011f2:	50                   	push   %eax
800011f3:	ff 75 08             	pushl  0x8(%ebp)
800011f6:	68 8c 33 00 80       	push   $0x8000338c
800011fb:	6a 34                	push   $0x34
800011fd:	68 3c 33 00 80       	push   $0x8000333c
80001202:	e8 38 1f 00 00       	call   8000313f <_panic>
}
80001207:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000120a:	5b                   	pop    %ebx
8000120b:	5e                   	pop    %esi
8000120c:	5f                   	pop    %edi
8000120d:	5d                   	pop    %ebp
8000120e:	c3                   	ret    

8000120f <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
8000120f:	55                   	push   %ebp
80001210:	89 e5                	mov    %esp,%ebp
80001212:	56                   	push   %esi
80001213:	53                   	push   %ebx
80001214:	81 ec a0 00 00 00    	sub    $0xa0,%esp
8000121a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;
	char fullpath[MAXPATHLEN];

	if (path[0] == '.') {
8000121d:	80 3b 2e             	cmpb   $0x2e,(%ebx)
80001220:	75 2b                	jne    8000124d <ls+0x3e>
		strcpy(fullpath, curpath);
80001222:	83 ec 08             	sub    $0x8,%esp
80001225:	68 20 54 00 80       	push   $0x80005420
8000122a:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
80001230:	56                   	push   %esi
80001231:	e8 f9 01 00 00       	call   8000142f <strcpy>
		strcpy(fullpath+curpathlen, path);
80001236:	83 c4 08             	add    $0x8,%esp
80001239:	53                   	push   %ebx
8000123a:	89 f0                	mov    %esi,%eax
8000123c:	03 05 a0 54 00 80    	add    0x800054a0,%eax
80001242:	50                   	push   %eax
80001243:	e8 e7 01 00 00       	call   8000142f <strcpy>
80001248:	83 c4 10             	add    $0x10,%esp
		path = fullpath;
8000124b:	89 f3                	mov    %esi,%ebx
	}
	if ((r = stat(path, &st)) < 0)
8000124d:	83 ec 08             	sub    $0x8,%esp
80001250:	8d 45 dc             	lea    -0x24(%ebp),%eax
80001253:	50                   	push   %eax
80001254:	53                   	push   %ebx
80001255:	e8 5d 0e 00 00       	call   800020b7 <stat>
8000125a:	83 c4 10             	add    $0x10,%esp
8000125d:	85 c0                	test   %eax,%eax
8000125f:	79 16                	jns    80001277 <ls+0x68>
		panic("stat %s: %e", path, r);
80001261:	83 ec 0c             	sub    $0xc,%esp
80001264:	50                   	push   %eax
80001265:	53                   	push   %ebx
80001266:	68 41 33 00 80       	push   $0x80003341
8000126b:	6a 17                	push   $0x17
8000126d:	68 3c 33 00 80       	push   $0x8000333c
80001272:	e8 c8 1e 00 00       	call   8000313f <_panic>
	if (st.st_isdir && !flag['d'])
80001277:	8b 45 f0             	mov    -0x10(%ebp),%eax
8000127a:	85 c0                	test   %eax,%eax
8000127c:	74 18                	je     80001296 <ls+0x87>
8000127e:	83 3d 50 56 00 80 00 	cmpl   $0x0,0x80005650
80001285:	75 0f                	jne    80001296 <ls+0x87>
		lsdir(path, path);
80001287:	83 ec 08             	sub    $0x8,%esp
8000128a:	53                   	push   %ebx
8000128b:	53                   	push   %ebx
8000128c:	e8 5d fe ff ff       	call   800010ee <lsdir>
80001291:	83 c4 10             	add    $0x10,%esp
80001294:	eb 17                	jmp    800012ad <ls+0x9e>
	else
		ls1(0, st.st_isdir, st.st_size, path);
80001296:	53                   	push   %ebx
80001297:	ff 75 ec             	pushl  -0x14(%ebp)
8000129a:	85 c0                	test   %eax,%eax
8000129c:	0f 95 c0             	setne  %al
8000129f:	0f b6 c0             	movzbl %al,%eax
800012a2:	50                   	push   %eax
800012a3:	6a 00                	push   $0x0
800012a5:	e8 89 fd ff ff       	call   80001033 <ls1>
800012aa:	83 c4 10             	add    $0x10,%esp
}
800012ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
800012b0:	5b                   	pop    %ebx
800012b1:	5e                   	pop    %esi
800012b2:	5d                   	pop    %ebp
800012b3:	c3                   	ret    

800012b4 <usage>:
	printf("\n");
}

void
usage(void)
{
800012b4:	55                   	push   %ebp
800012b5:	89 e5                	mov    %esp,%ebp
800012b7:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [file...]\n");
800012ba:	68 68 33 00 80       	push   $0x80003368
800012bf:	e8 ed 1c 00 00       	call   80002fb1 <printf>
	exit();
800012c4:	e8 db 14 00 00       	call   800027a4 <exit>
}
800012c9:	83 c4 10             	add    $0x10,%esp
800012cc:	c9                   	leave  
800012cd:	c3                   	ret    

800012ce <load_curpath>:


void load_curpath(){
800012ce:	55                   	push   %ebp
800012cf:	89 e5                	mov    %esp,%ebp
800012d1:	53                   	push   %ebx
800012d2:	83 ec 0c             	sub    $0xc,%esp
	int glb_var_fd;
	
	// load curpath
	if ((glb_var_fd = open("/.global_var", O_RDONLY)) < 0)
800012d5:	6a 00                	push   $0x0
800012d7:	68 7d 33 00 80       	push   $0x8000337d
800012dc:	e8 8d 0f 00 00       	call   8000226e <open>
800012e1:	89 c3                	mov    %eax,%ebx
800012e3:	83 c4 10             	add    $0x10,%esp
800012e6:	85 c0                	test   %eax,%eax
800012e8:	79 1a                	jns    80001304 <load_curpath+0x36>
		panic("open %s: %e", "/.global_var", glb_var_fd);
800012ea:	83 ec 0c             	sub    $0xc,%esp
800012ed:	50                   	push   %eax
800012ee:	68 7d 33 00 80       	push   $0x8000337d
800012f3:	68 30 33 00 80       	push   $0x80003330
800012f8:	6a 58                	push   $0x58
800012fa:	68 3c 33 00 80       	push   $0x8000333c
800012ff:	e8 3b 1e 00 00       	call   8000313f <_panic>
	curpathlen = readn(glb_var_fd, curpath, MAXPATHLEN);
80001304:	83 ec 04             	sub    $0x4,%esp
80001307:	68 80 00 00 00       	push   $0x80
8000130c:	68 20 54 00 80       	push   $0x80005420
80001311:	50                   	push   %eax
80001312:	e8 98 0b 00 00       	call   80001eaf <readn>
80001317:	a3 a0 54 00 80       	mov    %eax,0x800054a0
	curpath[curpathlen] = '\0';
8000131c:	c6 80 20 54 00 80 00 	movb   $0x0,-0x7fffabe0(%eax)
	close(glb_var_fd);
80001323:	89 1c 24             	mov    %ebx,(%esp)
80001326:	e8 b9 09 00 00       	call   80001ce4 <close>
}
8000132b:	83 c4 10             	add    $0x10,%esp
8000132e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001331:	c9                   	leave  
80001332:	c3                   	ret    

80001333 <umain>:

void
umain(int argc, char **argv)
{
80001333:	55                   	push   %ebp
80001334:	89 e5                	mov    %esp,%ebp
80001336:	56                   	push   %esi
80001337:	53                   	push   %ebx
80001338:	83 ec 10             	sub    $0x10,%esp
8000133b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	load_curpath();
8000133e:	e8 8b ff ff ff       	call   800012ce <load_curpath>

	argstart(&argc, argv, &args);
80001343:	83 ec 04             	sub    $0x4,%esp
80001346:	8d 45 e8             	lea    -0x18(%ebp),%eax
80001349:	50                   	push   %eax
8000134a:	56                   	push   %esi
8000134b:	8d 45 08             	lea    0x8(%ebp),%eax
8000134e:	50                   	push   %eax
8000134f:	e8 a5 14 00 00       	call   800027f9 <argstart>
	while ((i = argnext(&args)) >= 0)
80001354:	83 c4 10             	add    $0x10,%esp
80001357:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8000135a:	eb 1e                	jmp    8000137a <umain+0x47>
		switch (i) {
8000135c:	83 f8 64             	cmp    $0x64,%eax
8000135f:	74 0a                	je     8000136b <umain+0x38>
80001361:	83 f8 6c             	cmp    $0x6c,%eax
80001364:	74 05                	je     8000136b <umain+0x38>
80001366:	83 f8 46             	cmp    $0x46,%eax
80001369:	75 0a                	jne    80001375 <umain+0x42>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
8000136b:	83 04 85 c0 54 00 80 	addl   $0x1,-0x7fffab40(,%eax,4)
80001372:	01 
			break;
80001373:	eb 05                	jmp    8000137a <umain+0x47>
		default:
			usage();
80001375:	e8 3a ff ff ff       	call   800012b4 <usage>
	struct Argstate args;

	load_curpath();

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
8000137a:	83 ec 0c             	sub    $0xc,%esp
8000137d:	53                   	push   %ebx
8000137e:	e8 a6 14 00 00       	call   80002829 <argnext>
80001383:	83 c4 10             	add    $0x10,%esp
80001386:	85 c0                	test   %eax,%eax
80001388:	79 d2                	jns    8000135c <umain+0x29>
			break;
		default:
			usage();
		}

	if (argc == 1)
8000138a:	8b 45 08             	mov    0x8(%ebp),%eax
8000138d:	83 f8 01             	cmp    $0x1,%eax
80001390:	74 0c                	je     8000139e <umain+0x6b>
		lsdir(curpath, curpath);
	else {
		for (i = 1; i < argc; i++)
80001392:	bb 01 00 00 00       	mov    $0x1,%ebx
80001397:	83 f8 01             	cmp    $0x1,%eax
8000139a:	7f 19                	jg     800013b5 <umain+0x82>
8000139c:	eb 2f                	jmp    800013cd <umain+0x9a>
		default:
			usage();
		}

	if (argc == 1)
		lsdir(curpath, curpath);
8000139e:	83 ec 08             	sub    $0x8,%esp
800013a1:	68 20 54 00 80       	push   $0x80005420
800013a6:	68 20 54 00 80       	push   $0x80005420
800013ab:	e8 3e fd ff ff       	call   800010ee <lsdir>
800013b0:	83 c4 10             	add    $0x10,%esp
800013b3:	eb 18                	jmp    800013cd <umain+0x9a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
800013b5:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
800013b8:	83 ec 08             	sub    $0x8,%esp
800013bb:	50                   	push   %eax
800013bc:	50                   	push   %eax
800013bd:	e8 4d fe ff ff       	call   8000120f <ls>
		}

	if (argc == 1)
		lsdir(curpath, curpath);
	else {
		for (i = 1; i < argc; i++)
800013c2:	83 c3 01             	add    $0x1,%ebx
800013c5:	83 c4 10             	add    $0x10,%esp
800013c8:	39 5d 08             	cmp    %ebx,0x8(%ebp)
800013cb:	7f e8                	jg     800013b5 <umain+0x82>
			ls(argv[i], argv[i]);
	}
}
800013cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
800013d0:	5b                   	pop    %ebx
800013d1:	5e                   	pop    %esi
800013d2:	5d                   	pop    %ebp
800013d3:	c3                   	ret    

800013d4 <strlen>:
#include <x86.h>
#define ASM 1

int
strlen(const char *s)
{
800013d4:	55                   	push   %ebp
800013d5:	89 e5                	mov    %esp,%ebp
800013d7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
800013da:	80 3a 00             	cmpb   $0x0,(%edx)
800013dd:	74 10                	je     800013ef <strlen+0x1b>
800013df:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
800013e4:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
800013e7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
800013eb:	75 f7                	jne    800013e4 <strlen+0x10>
800013ed:	eb 05                	jmp    800013f4 <strlen+0x20>
800013ef:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
800013f4:	5d                   	pop    %ebp
800013f5:	c3                   	ret    

800013f6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
800013f6:	55                   	push   %ebp
800013f7:	89 e5                	mov    %esp,%ebp
800013f9:	53                   	push   %ebx
800013fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
800013fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
80001400:	85 c9                	test   %ecx,%ecx
80001402:	74 1c                	je     80001420 <strnlen+0x2a>
80001404:	80 3b 00             	cmpb   $0x0,(%ebx)
80001407:	74 1e                	je     80001427 <strnlen+0x31>
80001409:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
8000140e:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
80001410:	39 ca                	cmp    %ecx,%edx
80001412:	74 18                	je     8000142c <strnlen+0x36>
80001414:	83 c2 01             	add    $0x1,%edx
80001417:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
8000141c:	75 f0                	jne    8000140e <strnlen+0x18>
8000141e:	eb 0c                	jmp    8000142c <strnlen+0x36>
80001420:	b8 00 00 00 00       	mov    $0x0,%eax
80001425:	eb 05                	jmp    8000142c <strnlen+0x36>
80001427:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
8000142c:	5b                   	pop    %ebx
8000142d:	5d                   	pop    %ebp
8000142e:	c3                   	ret    

8000142f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
8000142f:	55                   	push   %ebp
80001430:	89 e5                	mov    %esp,%ebp
80001432:	53                   	push   %ebx
80001433:	8b 45 08             	mov    0x8(%ebp),%eax
80001436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
80001439:	89 c2                	mov    %eax,%edx
8000143b:	83 c2 01             	add    $0x1,%edx
8000143e:	83 c1 01             	add    $0x1,%ecx
80001441:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
80001445:	88 5a ff             	mov    %bl,-0x1(%edx)
80001448:	84 db                	test   %bl,%bl
8000144a:	75 ef                	jne    8000143b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
8000144c:	5b                   	pop    %ebx
8000144d:	5d                   	pop    %ebp
8000144e:	c3                   	ret    

8000144f <strcat>:

char *
strcat(char *dst, const char *src)
{
8000144f:	55                   	push   %ebp
80001450:	89 e5                	mov    %esp,%ebp
80001452:	53                   	push   %ebx
80001453:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
80001456:	53                   	push   %ebx
80001457:	e8 78 ff ff ff       	call   800013d4 <strlen>
8000145c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
8000145f:	ff 75 0c             	pushl  0xc(%ebp)
80001462:	01 d8                	add    %ebx,%eax
80001464:	50                   	push   %eax
80001465:	e8 c5 ff ff ff       	call   8000142f <strcpy>
	return dst;
}
8000146a:	89 d8                	mov    %ebx,%eax
8000146c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000146f:	c9                   	leave  
80001470:	c3                   	ret    

80001471 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
80001471:	55                   	push   %ebp
80001472:	89 e5                	mov    %esp,%ebp
80001474:	56                   	push   %esi
80001475:	53                   	push   %ebx
80001476:	8b 75 08             	mov    0x8(%ebp),%esi
80001479:	8b 55 0c             	mov    0xc(%ebp),%edx
8000147c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
8000147f:	85 db                	test   %ebx,%ebx
80001481:	74 17                	je     8000149a <strncpy+0x29>
80001483:	01 f3                	add    %esi,%ebx
80001485:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
80001487:	83 c1 01             	add    $0x1,%ecx
8000148a:	0f b6 02             	movzbl (%edx),%eax
8000148d:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
80001490:	80 3a 01             	cmpb   $0x1,(%edx)
80001493:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
80001496:	39 cb                	cmp    %ecx,%ebx
80001498:	75 ed                	jne    80001487 <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
8000149a:	89 f0                	mov    %esi,%eax
8000149c:	5b                   	pop    %ebx
8000149d:	5e                   	pop    %esi
8000149e:	5d                   	pop    %ebp
8000149f:	c3                   	ret    

800014a0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
800014a0:	55                   	push   %ebp
800014a1:	89 e5                	mov    %esp,%ebp
800014a3:	56                   	push   %esi
800014a4:	53                   	push   %ebx
800014a5:	8b 75 08             	mov    0x8(%ebp),%esi
800014a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
800014ab:	8b 55 10             	mov    0x10(%ebp),%edx
800014ae:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
800014b0:	85 d2                	test   %edx,%edx
800014b2:	74 35                	je     800014e9 <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
800014b4:	89 d0                	mov    %edx,%eax
800014b6:	83 e8 01             	sub    $0x1,%eax
800014b9:	74 25                	je     800014e0 <strlcpy+0x40>
800014bb:	0f b6 0b             	movzbl (%ebx),%ecx
800014be:	84 c9                	test   %cl,%cl
800014c0:	74 22                	je     800014e4 <strlcpy+0x44>
800014c2:	8d 53 01             	lea    0x1(%ebx),%edx
800014c5:	01 c3                	add    %eax,%ebx
800014c7:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
800014c9:	83 c0 01             	add    $0x1,%eax
800014cc:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
800014cf:	39 da                	cmp    %ebx,%edx
800014d1:	74 13                	je     800014e6 <strlcpy+0x46>
800014d3:	83 c2 01             	add    $0x1,%edx
800014d6:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
800014da:	84 c9                	test   %cl,%cl
800014dc:	75 eb                	jne    800014c9 <strlcpy+0x29>
800014de:	eb 06                	jmp    800014e6 <strlcpy+0x46>
800014e0:	89 f0                	mov    %esi,%eax
800014e2:	eb 02                	jmp    800014e6 <strlcpy+0x46>
800014e4:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
800014e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
800014e9:	29 f0                	sub    %esi,%eax
}
800014eb:	5b                   	pop    %ebx
800014ec:	5e                   	pop    %esi
800014ed:	5d                   	pop    %ebp
800014ee:	c3                   	ret    

800014ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
800014ef:	55                   	push   %ebp
800014f0:	89 e5                	mov    %esp,%ebp
800014f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
800014f5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
800014f8:	0f b6 01             	movzbl (%ecx),%eax
800014fb:	84 c0                	test   %al,%al
800014fd:	74 15                	je     80001514 <strcmp+0x25>
800014ff:	3a 02                	cmp    (%edx),%al
80001501:	75 11                	jne    80001514 <strcmp+0x25>
		p++, q++;
80001503:	83 c1 01             	add    $0x1,%ecx
80001506:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
80001509:	0f b6 01             	movzbl (%ecx),%eax
8000150c:	84 c0                	test   %al,%al
8000150e:	74 04                	je     80001514 <strcmp+0x25>
80001510:	3a 02                	cmp    (%edx),%al
80001512:	74 ef                	je     80001503 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
80001514:	0f b6 c0             	movzbl %al,%eax
80001517:	0f b6 12             	movzbl (%edx),%edx
8000151a:	29 d0                	sub    %edx,%eax
}
8000151c:	5d                   	pop    %ebp
8000151d:	c3                   	ret    

8000151e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
8000151e:	55                   	push   %ebp
8000151f:	89 e5                	mov    %esp,%ebp
80001521:	56                   	push   %esi
80001522:	53                   	push   %ebx
80001523:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001526:	8b 55 0c             	mov    0xc(%ebp),%edx
80001529:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
8000152c:	85 f6                	test   %esi,%esi
8000152e:	74 29                	je     80001559 <strncmp+0x3b>
80001530:	0f b6 03             	movzbl (%ebx),%eax
80001533:	84 c0                	test   %al,%al
80001535:	74 30                	je     80001567 <strncmp+0x49>
80001537:	3a 02                	cmp    (%edx),%al
80001539:	75 2c                	jne    80001567 <strncmp+0x49>
8000153b:	8d 43 01             	lea    0x1(%ebx),%eax
8000153e:	01 de                	add    %ebx,%esi
		n--, p++, q++;
80001540:	89 c3                	mov    %eax,%ebx
80001542:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
80001545:	39 c6                	cmp    %eax,%esi
80001547:	74 17                	je     80001560 <strncmp+0x42>
80001549:	0f b6 08             	movzbl (%eax),%ecx
8000154c:	84 c9                	test   %cl,%cl
8000154e:	74 17                	je     80001567 <strncmp+0x49>
80001550:	83 c0 01             	add    $0x1,%eax
80001553:	3a 0a                	cmp    (%edx),%cl
80001555:	74 e9                	je     80001540 <strncmp+0x22>
80001557:	eb 0e                	jmp    80001567 <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
80001559:	b8 00 00 00 00       	mov    $0x0,%eax
8000155e:	eb 0f                	jmp    8000156f <strncmp+0x51>
80001560:	b8 00 00 00 00       	mov    $0x0,%eax
80001565:	eb 08                	jmp    8000156f <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
80001567:	0f b6 03             	movzbl (%ebx),%eax
8000156a:	0f b6 12             	movzbl (%edx),%edx
8000156d:	29 d0                	sub    %edx,%eax
}
8000156f:	5b                   	pop    %ebx
80001570:	5e                   	pop    %esi
80001571:	5d                   	pop    %ebp
80001572:	c3                   	ret    

80001573 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
80001573:	55                   	push   %ebp
80001574:	89 e5                	mov    %esp,%ebp
80001576:	53                   	push   %ebx
80001577:	8b 45 08             	mov    0x8(%ebp),%eax
8000157a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
8000157d:	0f b6 10             	movzbl (%eax),%edx
80001580:	84 d2                	test   %dl,%dl
80001582:	74 1d                	je     800015a1 <strchr+0x2e>
80001584:	89 d9                	mov    %ebx,%ecx
		if (*s == c)
80001586:	38 d3                	cmp    %dl,%bl
80001588:	75 06                	jne    80001590 <strchr+0x1d>
8000158a:	eb 1a                	jmp    800015a6 <strchr+0x33>
8000158c:	38 ca                	cmp    %cl,%dl
8000158e:	74 16                	je     800015a6 <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
80001590:	83 c0 01             	add    $0x1,%eax
80001593:	0f b6 10             	movzbl (%eax),%edx
80001596:	84 d2                	test   %dl,%dl
80001598:	75 f2                	jne    8000158c <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
8000159a:	b8 00 00 00 00       	mov    $0x0,%eax
8000159f:	eb 05                	jmp    800015a6 <strchr+0x33>
800015a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
800015a6:	5b                   	pop    %ebx
800015a7:	5d                   	pop    %ebp
800015a8:	c3                   	ret    

800015a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
800015a9:	55                   	push   %ebp
800015aa:	89 e5                	mov    %esp,%ebp
800015ac:	53                   	push   %ebx
800015ad:	8b 45 08             	mov    0x8(%ebp),%eax
800015b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
800015b3:	0f b6 18             	movzbl (%eax),%ebx
		if (*s == c)
800015b6:	38 d3                	cmp    %dl,%bl
800015b8:	74 14                	je     800015ce <strfind+0x25>
800015ba:	89 d1                	mov    %edx,%ecx
800015bc:	84 db                	test   %bl,%bl
800015be:	74 0e                	je     800015ce <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
800015c0:	83 c0 01             	add    $0x1,%eax
800015c3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
800015c6:	38 ca                	cmp    %cl,%dl
800015c8:	74 04                	je     800015ce <strfind+0x25>
800015ca:	84 d2                	test   %dl,%dl
800015cc:	75 f2                	jne    800015c0 <strfind+0x17>
			break;
	return (char *) s;
}
800015ce:	5b                   	pop    %ebx
800015cf:	5d                   	pop    %ebp
800015d0:	c3                   	ret    

800015d1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
800015d1:	55                   	push   %ebp
800015d2:	89 e5                	mov    %esp,%ebp
800015d4:	57                   	push   %edi
800015d5:	56                   	push   %esi
800015d6:	53                   	push   %ebx
800015d7:	8b 7d 08             	mov    0x8(%ebp),%edi
800015da:	8b 4d 10             	mov    0x10(%ebp),%ecx

	if (n == 0)
800015dd:	85 c9                	test   %ecx,%ecx
800015df:	74 36                	je     80001617 <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
800015e1:	f7 c7 03 00 00 00    	test   $0x3,%edi
800015e7:	75 28                	jne    80001611 <memset+0x40>
800015e9:	f6 c1 03             	test   $0x3,%cl
800015ec:	75 23                	jne    80001611 <memset+0x40>
		c &= 0xFF;
800015ee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
800015f2:	89 d3                	mov    %edx,%ebx
800015f4:	c1 e3 08             	shl    $0x8,%ebx
800015f7:	89 d6                	mov    %edx,%esi
800015f9:	c1 e6 18             	shl    $0x18,%esi
800015fc:	89 d0                	mov    %edx,%eax
800015fe:	c1 e0 10             	shl    $0x10,%eax
80001601:	09 f0                	or     %esi,%eax
80001603:	09 c2                	or     %eax,%edx
		asm volatile("cld; rep stosl\n"
80001605:	89 d8                	mov    %ebx,%eax
80001607:	09 d0                	or     %edx,%eax
80001609:	c1 e9 02             	shr    $0x2,%ecx
8000160c:	fc                   	cld    
8000160d:	f3 ab                	rep stos %eax,%es:(%edi)
8000160f:	eb 06                	jmp    80001617 <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
80001611:	8b 45 0c             	mov    0xc(%ebp),%eax
80001614:	fc                   	cld    
80001615:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
80001617:	89 f8                	mov    %edi,%eax
80001619:	5b                   	pop    %ebx
8000161a:	5e                   	pop    %esi
8000161b:	5f                   	pop    %edi
8000161c:	5d                   	pop    %ebp
8000161d:	c3                   	ret    

8000161e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
8000161e:	55                   	push   %ebp
8000161f:	89 e5                	mov    %esp,%ebp
80001621:	57                   	push   %edi
80001622:	56                   	push   %esi
80001623:	8b 45 08             	mov    0x8(%ebp),%eax
80001626:	8b 75 0c             	mov    0xc(%ebp),%esi
80001629:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
8000162c:	39 c6                	cmp    %eax,%esi
8000162e:	73 35                	jae    80001665 <memmove+0x47>
80001630:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
80001633:	39 d0                	cmp    %edx,%eax
80001635:	73 2e                	jae    80001665 <memmove+0x47>
		s += n;
		d += n;
80001637:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
8000163a:	89 d6                	mov    %edx,%esi
8000163c:	09 fe                	or     %edi,%esi
8000163e:	f7 c6 03 00 00 00    	test   $0x3,%esi
80001644:	75 13                	jne    80001659 <memmove+0x3b>
80001646:	f6 c1 03             	test   $0x3,%cl
80001649:	75 0e                	jne    80001659 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
8000164b:	83 ef 04             	sub    $0x4,%edi
8000164e:	8d 72 fc             	lea    -0x4(%edx),%esi
80001651:	c1 e9 02             	shr    $0x2,%ecx
80001654:	fd                   	std    
80001655:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80001657:	eb 09                	jmp    80001662 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
80001659:	83 ef 01             	sub    $0x1,%edi
8000165c:	8d 72 ff             	lea    -0x1(%edx),%esi
8000165f:	fd                   	std    
80001660:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
80001662:	fc                   	cld    
80001663:	eb 1d                	jmp    80001682 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
80001665:	89 f2                	mov    %esi,%edx
80001667:	09 c2                	or     %eax,%edx
80001669:	f6 c2 03             	test   $0x3,%dl
8000166c:	75 0f                	jne    8000167d <memmove+0x5f>
8000166e:	f6 c1 03             	test   $0x3,%cl
80001671:	75 0a                	jne    8000167d <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
80001673:	c1 e9 02             	shr    $0x2,%ecx
80001676:	89 c7                	mov    %eax,%edi
80001678:	fc                   	cld    
80001679:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
8000167b:	eb 05                	jmp    80001682 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
8000167d:	89 c7                	mov    %eax,%edi
8000167f:	fc                   	cld    
80001680:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
80001682:	5e                   	pop    %esi
80001683:	5f                   	pop    %edi
80001684:	5d                   	pop    %ebp
80001685:	c3                   	ret    

80001686 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
80001686:	55                   	push   %ebp
80001687:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
80001689:	ff 75 10             	pushl  0x10(%ebp)
8000168c:	ff 75 0c             	pushl  0xc(%ebp)
8000168f:	ff 75 08             	pushl  0x8(%ebp)
80001692:	e8 87 ff ff ff       	call   8000161e <memmove>
}
80001697:	c9                   	leave  
80001698:	c3                   	ret    

80001699 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
80001699:	55                   	push   %ebp
8000169a:	89 e5                	mov    %esp,%ebp
8000169c:	57                   	push   %edi
8000169d:	56                   	push   %esi
8000169e:	53                   	push   %ebx
8000169f:	8b 5d 08             	mov    0x8(%ebp),%ebx
800016a2:	8b 75 0c             	mov    0xc(%ebp),%esi
800016a5:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
800016a8:	85 c0                	test   %eax,%eax
800016aa:	74 39                	je     800016e5 <memcmp+0x4c>
800016ac:	8d 78 ff             	lea    -0x1(%eax),%edi
		if (*s1 != *s2)
800016af:	0f b6 13             	movzbl (%ebx),%edx
800016b2:	0f b6 0e             	movzbl (%esi),%ecx
800016b5:	38 ca                	cmp    %cl,%dl
800016b7:	75 17                	jne    800016d0 <memcmp+0x37>
800016b9:	b8 00 00 00 00       	mov    $0x0,%eax
800016be:	eb 1a                	jmp    800016da <memcmp+0x41>
800016c0:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
800016c5:	83 c0 01             	add    $0x1,%eax
800016c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
800016cc:	38 ca                	cmp    %cl,%dl
800016ce:	74 0a                	je     800016da <memcmp+0x41>
			return (int) *s1 - (int) *s2;
800016d0:	0f b6 c2             	movzbl %dl,%eax
800016d3:	0f b6 c9             	movzbl %cl,%ecx
800016d6:	29 c8                	sub    %ecx,%eax
800016d8:	eb 10                	jmp    800016ea <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
800016da:	39 f8                	cmp    %edi,%eax
800016dc:	75 e2                	jne    800016c0 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
800016de:	b8 00 00 00 00       	mov    $0x0,%eax
800016e3:	eb 05                	jmp    800016ea <memcmp+0x51>
800016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
800016ea:	5b                   	pop    %ebx
800016eb:	5e                   	pop    %esi
800016ec:	5f                   	pop    %edi
800016ed:	5d                   	pop    %ebp
800016ee:	c3                   	ret    

800016ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
800016ef:	55                   	push   %ebp
800016f0:	89 e5                	mov    %esp,%ebp
800016f2:	53                   	push   %ebx
800016f3:	8b 55 08             	mov    0x8(%ebp),%edx
	const void *ends = (const char *) s + n;
800016f6:	89 d0                	mov    %edx,%eax
800016f8:	03 45 10             	add    0x10(%ebp),%eax
	for (; s < ends; s++)
800016fb:	39 c2                	cmp    %eax,%edx
800016fd:	73 1d                	jae    8000171c <memfind+0x2d>
		if (*(const unsigned char *) s == (unsigned char) c)
800016ff:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
80001703:	0f b6 0a             	movzbl (%edx),%ecx
80001706:	39 d9                	cmp    %ebx,%ecx
80001708:	75 09                	jne    80001713 <memfind+0x24>
8000170a:	eb 14                	jmp    80001720 <memfind+0x31>
8000170c:	0f b6 0a             	movzbl (%edx),%ecx
8000170f:	39 d9                	cmp    %ebx,%ecx
80001711:	74 11                	je     80001724 <memfind+0x35>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
80001713:	83 c2 01             	add    $0x1,%edx
80001716:	39 d0                	cmp    %edx,%eax
80001718:	75 f2                	jne    8000170c <memfind+0x1d>
8000171a:	eb 0a                	jmp    80001726 <memfind+0x37>
8000171c:	89 d0                	mov    %edx,%eax
8000171e:	eb 06                	jmp    80001726 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
80001720:	89 d0                	mov    %edx,%eax
80001722:	eb 02                	jmp    80001726 <memfind+0x37>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
80001724:	89 d0                	mov    %edx,%eax
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
80001726:	5b                   	pop    %ebx
80001727:	5d                   	pop    %ebp
80001728:	c3                   	ret    

80001729 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
80001729:	55                   	push   %ebp
8000172a:	89 e5                	mov    %esp,%ebp
8000172c:	57                   	push   %edi
8000172d:	56                   	push   %esi
8000172e:	53                   	push   %ebx
8000172f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80001732:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
80001735:	0f b6 01             	movzbl (%ecx),%eax
80001738:	3c 20                	cmp    $0x20,%al
8000173a:	74 04                	je     80001740 <strtol+0x17>
8000173c:	3c 09                	cmp    $0x9,%al
8000173e:	75 0e                	jne    8000174e <strtol+0x25>
		s++;
80001740:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
80001743:	0f b6 01             	movzbl (%ecx),%eax
80001746:	3c 20                	cmp    $0x20,%al
80001748:	74 f6                	je     80001740 <strtol+0x17>
8000174a:	3c 09                	cmp    $0x9,%al
8000174c:	74 f2                	je     80001740 <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
8000174e:	3c 2b                	cmp    $0x2b,%al
80001750:	75 0a                	jne    8000175c <strtol+0x33>
		s++;
80001752:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
80001755:	bf 00 00 00 00       	mov    $0x0,%edi
8000175a:	eb 11                	jmp    8000176d <strtol+0x44>
8000175c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
80001761:	3c 2d                	cmp    $0x2d,%al
80001763:	75 08                	jne    8000176d <strtol+0x44>
		s++, neg = 1;
80001765:	83 c1 01             	add    $0x1,%ecx
80001768:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
8000176d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
80001773:	75 15                	jne    8000178a <strtol+0x61>
80001775:	80 39 30             	cmpb   $0x30,(%ecx)
80001778:	75 10                	jne    8000178a <strtol+0x61>
8000177a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
8000177e:	75 7c                	jne    800017fc <strtol+0xd3>
		s += 2, base = 16;
80001780:	83 c1 02             	add    $0x2,%ecx
80001783:	bb 10 00 00 00       	mov    $0x10,%ebx
80001788:	eb 16                	jmp    800017a0 <strtol+0x77>
	else if (base == 0 && s[0] == '0')
8000178a:	85 db                	test   %ebx,%ebx
8000178c:	75 12                	jne    800017a0 <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
8000178e:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
80001793:	80 39 30             	cmpb   $0x30,(%ecx)
80001796:	75 08                	jne    800017a0 <strtol+0x77>
		s++, base = 8;
80001798:	83 c1 01             	add    $0x1,%ecx
8000179b:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
800017a0:	b8 00 00 00 00       	mov    $0x0,%eax
800017a5:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
800017a8:	0f b6 11             	movzbl (%ecx),%edx
800017ab:	8d 72 d0             	lea    -0x30(%edx),%esi
800017ae:	89 f3                	mov    %esi,%ebx
800017b0:	80 fb 09             	cmp    $0x9,%bl
800017b3:	77 08                	ja     800017bd <strtol+0x94>
			dig = *s - '0';
800017b5:	0f be d2             	movsbl %dl,%edx
800017b8:	83 ea 30             	sub    $0x30,%edx
800017bb:	eb 22                	jmp    800017df <strtol+0xb6>
		else if (*s >= 'a' && *s <= 'z')
800017bd:	8d 72 9f             	lea    -0x61(%edx),%esi
800017c0:	89 f3                	mov    %esi,%ebx
800017c2:	80 fb 19             	cmp    $0x19,%bl
800017c5:	77 08                	ja     800017cf <strtol+0xa6>
			dig = *s - 'a' + 10;
800017c7:	0f be d2             	movsbl %dl,%edx
800017ca:	83 ea 57             	sub    $0x57,%edx
800017cd:	eb 10                	jmp    800017df <strtol+0xb6>
		else if (*s >= 'A' && *s <= 'Z')
800017cf:	8d 72 bf             	lea    -0x41(%edx),%esi
800017d2:	89 f3                	mov    %esi,%ebx
800017d4:	80 fb 19             	cmp    $0x19,%bl
800017d7:	77 16                	ja     800017ef <strtol+0xc6>
			dig = *s - 'A' + 10;
800017d9:	0f be d2             	movsbl %dl,%edx
800017dc:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
800017df:	3b 55 10             	cmp    0x10(%ebp),%edx
800017e2:	7d 0b                	jge    800017ef <strtol+0xc6>
			break;
		s++, val = (val * base) + dig;
800017e4:	83 c1 01             	add    $0x1,%ecx
800017e7:	0f af 45 10          	imul   0x10(%ebp),%eax
800017eb:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
800017ed:	eb b9                	jmp    800017a8 <strtol+0x7f>

	if (endptr)
800017ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
800017f3:	74 0d                	je     80001802 <strtol+0xd9>
		*endptr = (char *) s;
800017f5:	8b 75 0c             	mov    0xc(%ebp),%esi
800017f8:	89 0e                	mov    %ecx,(%esi)
800017fa:	eb 06                	jmp    80001802 <strtol+0xd9>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
800017fc:	85 db                	test   %ebx,%ebx
800017fe:	74 98                	je     80001798 <strtol+0x6f>
80001800:	eb 9e                	jmp    800017a0 <strtol+0x77>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
80001802:	89 c2                	mov    %eax,%edx
80001804:	f7 da                	neg    %edx
80001806:	85 ff                	test   %edi,%edi
80001808:	0f 45 c2             	cmovne %edx,%eax
}
8000180b:	5b                   	pop    %ebx
8000180c:	5e                   	pop    %esi
8000180d:	5f                   	pop    %edi
8000180e:	5d                   	pop    %ebp
8000180f:	c3                   	ret    

80001810 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
80001810:	55                   	push   %ebp
80001811:	89 e5                	mov    %esp,%ebp
80001813:	56                   	push   %esi
80001814:	53                   	push   %ebx
80001815:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001818:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	thisenv = &envs[ENVX(sys_getenvid())];
8000181b:	e8 b4 00 00 00       	call   800018d4 <sys_getenvid>
80001820:	25 ff 03 00 00       	and    $0x3ff,%eax
80001825:	6b c0 7c             	imul   $0x7c,%eax,%eax
80001828:	05 00 00 c0 ee       	add    $0xeec00000,%eax
8000182d:	a3 c0 58 00 80       	mov    %eax,0x800058c0

	// save the name of the program so that panic() can use it
	if (argc > 0)
80001832:	85 db                	test   %ebx,%ebx
80001834:	7e 07                	jle    8000183d <libmain+0x2d>
		binaryname = argv[0];
80001836:	8b 06                	mov    (%esi),%eax
80001838:	a3 00 40 00 80       	mov    %eax,0x80004000

	// call user main routine
	umain(argc, argv);
8000183d:	83 ec 08             	sub    $0x8,%esp
80001840:	56                   	push   %esi
80001841:	53                   	push   %ebx
80001842:	e8 ec fa ff ff       	call   80001333 <umain>

	// exit gracefully
	exit();
80001847:	e8 58 0f 00 00       	call   800027a4 <exit>
}
8000184c:	83 c4 10             	add    $0x10,%esp
8000184f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80001852:	5b                   	pop    %ebx
80001853:	5e                   	pop    %esi
80001854:	5d                   	pop    %ebp
80001855:	c3                   	ret    

80001856 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
80001856:	55                   	push   %ebp
80001857:	89 e5                	mov    %esp,%ebp
80001859:	57                   	push   %edi
8000185a:	56                   	push   %esi
8000185b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
8000185c:	b8 00 00 00 00       	mov    $0x0,%eax
80001861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001864:	8b 55 08             	mov    0x8(%ebp),%edx
80001867:	89 c3                	mov    %eax,%ebx
80001869:	89 c7                	mov    %eax,%edi
8000186b:	89 c6                	mov    %eax,%esi
8000186d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
8000186f:	5b                   	pop    %ebx
80001870:	5e                   	pop    %esi
80001871:	5f                   	pop    %edi
80001872:	5d                   	pop    %ebp
80001873:	c3                   	ret    

80001874 <sys_cgetc>:

int
sys_cgetc(void)
{
80001874:	55                   	push   %ebp
80001875:	89 e5                	mov    %esp,%ebp
80001877:	57                   	push   %edi
80001878:	56                   	push   %esi
80001879:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
8000187a:	ba 00 00 00 00       	mov    $0x0,%edx
8000187f:	b8 01 00 00 00       	mov    $0x1,%eax
80001884:	89 d1                	mov    %edx,%ecx
80001886:	89 d3                	mov    %edx,%ebx
80001888:	89 d7                	mov    %edx,%edi
8000188a:	89 d6                	mov    %edx,%esi
8000188c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
8000188e:	5b                   	pop    %ebx
8000188f:	5e                   	pop    %esi
80001890:	5f                   	pop    %edi
80001891:	5d                   	pop    %ebp
80001892:	c3                   	ret    

80001893 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
80001893:	55                   	push   %ebp
80001894:	89 e5                	mov    %esp,%ebp
80001896:	57                   	push   %edi
80001897:	56                   	push   %esi
80001898:	53                   	push   %ebx
80001899:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
8000189c:	b9 00 00 00 00       	mov    $0x0,%ecx
800018a1:	b8 03 00 00 00       	mov    $0x3,%eax
800018a6:	8b 55 08             	mov    0x8(%ebp),%edx
800018a9:	89 cb                	mov    %ecx,%ebx
800018ab:	89 cf                	mov    %ecx,%edi
800018ad:	89 ce                	mov    %ecx,%esi
800018af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
800018b1:	85 c0                	test   %eax,%eax
800018b3:	7e 17                	jle    800018cc <sys_env_destroy+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
800018b5:	83 ec 0c             	sub    $0xc,%esp
800018b8:	50                   	push   %eax
800018b9:	6a 03                	push   $0x3
800018bb:	68 b5 33 00 80       	push   $0x800033b5
800018c0:	6a 21                	push   $0x21
800018c2:	68 d2 33 00 80       	push   $0x800033d2
800018c7:	e8 73 18 00 00       	call   8000313f <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
800018cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
800018cf:	5b                   	pop    %ebx
800018d0:	5e                   	pop    %esi
800018d1:	5f                   	pop    %edi
800018d2:	5d                   	pop    %ebp
800018d3:	c3                   	ret    

800018d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
800018d4:	55                   	push   %ebp
800018d5:	89 e5                	mov    %esp,%ebp
800018d7:	57                   	push   %edi
800018d8:	56                   	push   %esi
800018d9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
800018da:	ba 00 00 00 00       	mov    $0x0,%edx
800018df:	b8 02 00 00 00       	mov    $0x2,%eax
800018e4:	89 d1                	mov    %edx,%ecx
800018e6:	89 d3                	mov    %edx,%ebx
800018e8:	89 d7                	mov    %edx,%edi
800018ea:	89 d6                	mov    %edx,%esi
800018ec:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
800018ee:	5b                   	pop    %ebx
800018ef:	5e                   	pop    %esi
800018f0:	5f                   	pop    %edi
800018f1:	5d                   	pop    %ebp
800018f2:	c3                   	ret    

800018f3 <sys_yield>:

void
sys_yield(void)
{
800018f3:	55                   	push   %ebp
800018f4:	89 e5                	mov    %esp,%ebp
800018f6:	57                   	push   %edi
800018f7:	56                   	push   %esi
800018f8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
800018f9:	ba 00 00 00 00       	mov    $0x0,%edx
800018fe:	b8 0b 00 00 00       	mov    $0xb,%eax
80001903:	89 d1                	mov    %edx,%ecx
80001905:	89 d3                	mov    %edx,%ebx
80001907:	89 d7                	mov    %edx,%edi
80001909:	89 d6                	mov    %edx,%esi
8000190b:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
8000190d:	5b                   	pop    %ebx
8000190e:	5e                   	pop    %esi
8000190f:	5f                   	pop    %edi
80001910:	5d                   	pop    %ebp
80001911:	c3                   	ret    

80001912 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
80001912:	55                   	push   %ebp
80001913:	89 e5                	mov    %esp,%ebp
80001915:	57                   	push   %edi
80001916:	56                   	push   %esi
80001917:	53                   	push   %ebx
80001918:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
8000191b:	be 00 00 00 00       	mov    $0x0,%esi
80001920:	b8 04 00 00 00       	mov    $0x4,%eax
80001925:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001928:	8b 55 08             	mov    0x8(%ebp),%edx
8000192b:	8b 5d 10             	mov    0x10(%ebp),%ebx
8000192e:	89 f7                	mov    %esi,%edi
80001930:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001932:	85 c0                	test   %eax,%eax
80001934:	7e 17                	jle    8000194d <sys_page_alloc+0x3b>
		panic("syscall %d returned %d (> 0)", num, ret);
80001936:	83 ec 0c             	sub    $0xc,%esp
80001939:	50                   	push   %eax
8000193a:	6a 04                	push   $0x4
8000193c:	68 b5 33 00 80       	push   $0x800033b5
80001941:	6a 21                	push   $0x21
80001943:	68 d2 33 00 80       	push   $0x800033d2
80001948:	e8 f2 17 00 00       	call   8000313f <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
8000194d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001950:	5b                   	pop    %ebx
80001951:	5e                   	pop    %esi
80001952:	5f                   	pop    %edi
80001953:	5d                   	pop    %ebp
80001954:	c3                   	ret    

80001955 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
80001955:	55                   	push   %ebp
80001956:	89 e5                	mov    %esp,%ebp
80001958:	57                   	push   %edi
80001959:	56                   	push   %esi
8000195a:	53                   	push   %ebx
8000195b:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
8000195e:	b8 05 00 00 00       	mov    $0x5,%eax
80001963:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001966:	8b 55 08             	mov    0x8(%ebp),%edx
80001969:	8b 5d 10             	mov    0x10(%ebp),%ebx
8000196c:	8b 7d 14             	mov    0x14(%ebp),%edi
8000196f:	8b 75 18             	mov    0x18(%ebp),%esi
80001972:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001974:	85 c0                	test   %eax,%eax
80001976:	7e 17                	jle    8000198f <sys_page_map+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001978:	83 ec 0c             	sub    $0xc,%esp
8000197b:	50                   	push   %eax
8000197c:	6a 05                	push   $0x5
8000197e:	68 b5 33 00 80       	push   $0x800033b5
80001983:	6a 21                	push   $0x21
80001985:	68 d2 33 00 80       	push   $0x800033d2
8000198a:	e8 b0 17 00 00       	call   8000313f <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
8000198f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001992:	5b                   	pop    %ebx
80001993:	5e                   	pop    %esi
80001994:	5f                   	pop    %edi
80001995:	5d                   	pop    %ebp
80001996:	c3                   	ret    

80001997 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
80001997:	55                   	push   %ebp
80001998:	89 e5                	mov    %esp,%ebp
8000199a:	57                   	push   %edi
8000199b:	56                   	push   %esi
8000199c:	53                   	push   %ebx
8000199d:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
800019a0:	bb 00 00 00 00       	mov    $0x0,%ebx
800019a5:	b8 06 00 00 00       	mov    $0x6,%eax
800019aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800019ad:	8b 55 08             	mov    0x8(%ebp),%edx
800019b0:	89 df                	mov    %ebx,%edi
800019b2:	89 de                	mov    %ebx,%esi
800019b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
800019b6:	85 c0                	test   %eax,%eax
800019b8:	7e 17                	jle    800019d1 <sys_page_unmap+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
800019ba:	83 ec 0c             	sub    $0xc,%esp
800019bd:	50                   	push   %eax
800019be:	6a 06                	push   $0x6
800019c0:	68 b5 33 00 80       	push   $0x800033b5
800019c5:	6a 21                	push   $0x21
800019c7:	68 d2 33 00 80       	push   $0x800033d2
800019cc:	e8 6e 17 00 00       	call   8000313f <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
800019d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
800019d4:	5b                   	pop    %ebx
800019d5:	5e                   	pop    %esi
800019d6:	5f                   	pop    %edi
800019d7:	5d                   	pop    %ebp
800019d8:	c3                   	ret    

800019d9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
800019d9:	55                   	push   %ebp
800019da:	89 e5                	mov    %esp,%ebp
800019dc:	57                   	push   %edi
800019dd:	56                   	push   %esi
800019de:	53                   	push   %ebx
800019df:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
800019e2:	bb 00 00 00 00       	mov    $0x0,%ebx
800019e7:	b8 08 00 00 00       	mov    $0x8,%eax
800019ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800019ef:	8b 55 08             	mov    0x8(%ebp),%edx
800019f2:	89 df                	mov    %ebx,%edi
800019f4:	89 de                	mov    %ebx,%esi
800019f6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
800019f8:	85 c0                	test   %eax,%eax
800019fa:	7e 17                	jle    80001a13 <sys_env_set_status+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
800019fc:	83 ec 0c             	sub    $0xc,%esp
800019ff:	50                   	push   %eax
80001a00:	6a 08                	push   $0x8
80001a02:	68 b5 33 00 80       	push   $0x800033b5
80001a07:	6a 21                	push   $0x21
80001a09:	68 d2 33 00 80       	push   $0x800033d2
80001a0e:	e8 2c 17 00 00       	call   8000313f <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
80001a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001a16:	5b                   	pop    %ebx
80001a17:	5e                   	pop    %esi
80001a18:	5f                   	pop    %edi
80001a19:	5d                   	pop    %ebp
80001a1a:	c3                   	ret    

80001a1b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
80001a1b:	55                   	push   %ebp
80001a1c:	89 e5                	mov    %esp,%ebp
80001a1e:	57                   	push   %edi
80001a1f:	56                   	push   %esi
80001a20:	53                   	push   %ebx
80001a21:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001a24:	bb 00 00 00 00       	mov    $0x0,%ebx
80001a29:	b8 09 00 00 00       	mov    $0x9,%eax
80001a2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001a31:	8b 55 08             	mov    0x8(%ebp),%edx
80001a34:	89 df                	mov    %ebx,%edi
80001a36:	89 de                	mov    %ebx,%esi
80001a38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001a3a:	85 c0                	test   %eax,%eax
80001a3c:	7e 17                	jle    80001a55 <sys_env_set_trapframe+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001a3e:	83 ec 0c             	sub    $0xc,%esp
80001a41:	50                   	push   %eax
80001a42:	6a 09                	push   $0x9
80001a44:	68 b5 33 00 80       	push   $0x800033b5
80001a49:	6a 21                	push   $0x21
80001a4b:	68 d2 33 00 80       	push   $0x800033d2
80001a50:	e8 ea 16 00 00       	call   8000313f <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
80001a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001a58:	5b                   	pop    %ebx
80001a59:	5e                   	pop    %esi
80001a5a:	5f                   	pop    %edi
80001a5b:	5d                   	pop    %ebp
80001a5c:	c3                   	ret    

80001a5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
80001a5d:	55                   	push   %ebp
80001a5e:	89 e5                	mov    %esp,%ebp
80001a60:	57                   	push   %edi
80001a61:	56                   	push   %esi
80001a62:	53                   	push   %ebx
80001a63:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001a66:	bb 00 00 00 00       	mov    $0x0,%ebx
80001a6b:	b8 0a 00 00 00       	mov    $0xa,%eax
80001a70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001a73:	8b 55 08             	mov    0x8(%ebp),%edx
80001a76:	89 df                	mov    %ebx,%edi
80001a78:	89 de                	mov    %ebx,%esi
80001a7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001a7c:	85 c0                	test   %eax,%eax
80001a7e:	7e 17                	jle    80001a97 <sys_env_set_pgfault_upcall+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001a80:	83 ec 0c             	sub    $0xc,%esp
80001a83:	50                   	push   %eax
80001a84:	6a 0a                	push   $0xa
80001a86:	68 b5 33 00 80       	push   $0x800033b5
80001a8b:	6a 21                	push   $0x21
80001a8d:	68 d2 33 00 80       	push   $0x800033d2
80001a92:	e8 a8 16 00 00       	call   8000313f <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
80001a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001a9a:	5b                   	pop    %ebx
80001a9b:	5e                   	pop    %esi
80001a9c:	5f                   	pop    %edi
80001a9d:	5d                   	pop    %ebp
80001a9e:	c3                   	ret    

80001a9f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
80001a9f:	55                   	push   %ebp
80001aa0:	89 e5                	mov    %esp,%ebp
80001aa2:	57                   	push   %edi
80001aa3:	56                   	push   %esi
80001aa4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001aa5:	be 00 00 00 00       	mov    $0x0,%esi
80001aaa:	b8 0c 00 00 00       	mov    $0xc,%eax
80001aaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001ab2:	8b 55 08             	mov    0x8(%ebp),%edx
80001ab5:	8b 5d 10             	mov    0x10(%ebp),%ebx
80001ab8:	8b 7d 14             	mov    0x14(%ebp),%edi
80001abb:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
80001abd:	5b                   	pop    %ebx
80001abe:	5e                   	pop    %esi
80001abf:	5f                   	pop    %edi
80001ac0:	5d                   	pop    %ebp
80001ac1:	c3                   	ret    

80001ac2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
80001ac2:	55                   	push   %ebp
80001ac3:	89 e5                	mov    %esp,%ebp
80001ac5:	57                   	push   %edi
80001ac6:	56                   	push   %esi
80001ac7:	53                   	push   %ebx
80001ac8:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001acb:	b9 00 00 00 00       	mov    $0x0,%ecx
80001ad0:	b8 0d 00 00 00       	mov    $0xd,%eax
80001ad5:	8b 55 08             	mov    0x8(%ebp),%edx
80001ad8:	89 cb                	mov    %ecx,%ebx
80001ada:	89 cf                	mov    %ecx,%edi
80001adc:	89 ce                	mov    %ecx,%esi
80001ade:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001ae0:	85 c0                	test   %eax,%eax
80001ae2:	7e 17                	jle    80001afb <sys_ipc_recv+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
80001ae4:	83 ec 0c             	sub    $0xc,%esp
80001ae7:	50                   	push   %eax
80001ae8:	6a 0d                	push   $0xd
80001aea:	68 b5 33 00 80       	push   $0x800033b5
80001aef:	6a 21                	push   $0x21
80001af1:	68 d2 33 00 80       	push   $0x800033d2
80001af6:	e8 44 16 00 00       	call   8000313f <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
80001afb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001afe:	5b                   	pop    %ebx
80001aff:	5e                   	pop    %esi
80001b00:	5f                   	pop    %edi
80001b01:	5d                   	pop    %ebp
80001b02:	c3                   	ret    

80001b03 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
80001b03:	55                   	push   %ebp
80001b04:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
80001b06:	8b 45 08             	mov    0x8(%ebp),%eax
80001b09:	2d 00 00 00 20       	sub    $0x20000000,%eax
80001b0e:	c1 e8 0c             	shr    $0xc,%eax
}
80001b11:	5d                   	pop    %ebp
80001b12:	c3                   	ret    

80001b13 <fd2data>:

char*
fd2data(struct Fd *fd)
{
80001b13:	55                   	push   %ebp
80001b14:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
80001b16:	8b 45 08             	mov    0x8(%ebp),%eax
80001b19:	2d 00 00 00 20       	sub    $0x20000000,%eax
80001b1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80001b23:	8d 80 00 00 02 20    	lea    0x20020000(%eax),%eax
}
80001b29:	5d                   	pop    %ebp
80001b2a:	c3                   	ret    

80001b2b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
80001b2b:	55                   	push   %ebp
80001b2c:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
80001b2e:	a1 00 d2 7b ef       	mov    0xef7bd200,%eax
80001b33:	a8 01                	test   $0x1,%al
80001b35:	74 34                	je     80001b6b <fd_alloc+0x40>
80001b37:	a1 00 00 48 ef       	mov    0xef480000,%eax
80001b3c:	a8 01                	test   $0x1,%al
80001b3e:	74 32                	je     80001b72 <fd_alloc+0x47>
80001b40:	b8 00 10 00 20       	mov    $0x20001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
80001b45:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
80001b47:	89 c2                	mov    %eax,%edx
80001b49:	c1 ea 16             	shr    $0x16,%edx
80001b4c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
80001b53:	f6 c2 01             	test   $0x1,%dl
80001b56:	74 1f                	je     80001b77 <fd_alloc+0x4c>
80001b58:	89 c2                	mov    %eax,%edx
80001b5a:	c1 ea 0c             	shr    $0xc,%edx
80001b5d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
80001b64:	f6 c2 01             	test   $0x1,%dl
80001b67:	75 1a                	jne    80001b83 <fd_alloc+0x58>
80001b69:	eb 0c                	jmp    80001b77 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
80001b6b:	b9 00 00 00 20       	mov    $0x20000000,%ecx
80001b70:	eb 05                	jmp    80001b77 <fd_alloc+0x4c>
80001b72:	b9 00 00 00 20       	mov    $0x20000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
80001b77:	8b 45 08             	mov    0x8(%ebp),%eax
80001b7a:	89 08                	mov    %ecx,(%eax)
			return 0;
80001b7c:	b8 00 00 00 00       	mov    $0x0,%eax
80001b81:	eb 1a                	jmp    80001b9d <fd_alloc+0x72>
80001b83:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
80001b88:	3d 00 00 02 20       	cmp    $0x20020000,%eax
80001b8d:	75 b6                	jne    80001b45 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
80001b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80001b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
80001b98:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
80001b9d:	5d                   	pop    %ebp
80001b9e:	c3                   	ret    

80001b9f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
80001b9f:	55                   	push   %ebp
80001ba0:	89 e5                	mov    %esp,%ebp
80001ba2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
80001ba5:	83 f8 1f             	cmp    $0x1f,%eax
80001ba8:	77 36                	ja     80001be0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
80001baa:	05 00 00 02 00       	add    $0x20000,%eax
80001baf:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
80001bb2:	89 c2                	mov    %eax,%edx
80001bb4:	c1 ea 16             	shr    $0x16,%edx
80001bb7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
80001bbe:	f6 c2 01             	test   $0x1,%dl
80001bc1:	74 24                	je     80001be7 <fd_lookup+0x48>
80001bc3:	89 c2                	mov    %eax,%edx
80001bc5:	c1 ea 0c             	shr    $0xc,%edx
80001bc8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
80001bcf:	f6 c2 01             	test   $0x1,%dl
80001bd2:	74 1a                	je     80001bee <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
80001bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
80001bd7:	89 02                	mov    %eax,(%edx)
	return 0;
80001bd9:	b8 00 00 00 00       	mov    $0x0,%eax
80001bde:	eb 13                	jmp    80001bf3 <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
80001be0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80001be5:	eb 0c                	jmp    80001bf3 <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
80001be7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80001bec:	eb 05                	jmp    80001bf3 <fd_lookup+0x54>
80001bee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
80001bf3:	5d                   	pop    %ebp
80001bf4:	c3                   	ret    

80001bf5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
80001bf5:	55                   	push   %ebp
80001bf6:	89 e5                	mov    %esp,%ebp
80001bf8:	53                   	push   %ebx
80001bf9:	83 ec 04             	sub    $0x4,%esp
80001bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80001bff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
80001c02:	3b 05 04 40 00 80    	cmp    0x80004004,%eax
80001c08:	75 1e                	jne    80001c28 <dev_lookup+0x33>
80001c0a:	eb 0e                	jmp    80001c1a <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
80001c0c:	b8 20 40 00 80       	mov    $0x80004020,%eax
80001c11:	eb 0c                	jmp    80001c1f <dev_lookup+0x2a>
80001c13:	b8 3c 40 00 80       	mov    $0x8000403c,%eax
80001c18:	eb 05                	jmp    80001c1f <dev_lookup+0x2a>
80001c1a:	b8 04 40 00 80       	mov    $0x80004004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
80001c1f:	89 03                	mov    %eax,(%ebx)
			return 0;
80001c21:	b8 00 00 00 00       	mov    $0x0,%eax
80001c26:	eb 36                	jmp    80001c5e <dev_lookup+0x69>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
80001c28:	3b 05 20 40 00 80    	cmp    0x80004020,%eax
80001c2e:	74 dc                	je     80001c0c <dev_lookup+0x17>
80001c30:	3b 05 3c 40 00 80    	cmp    0x8000403c,%eax
80001c36:	74 db                	je     80001c13 <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
80001c38:	8b 15 c0 58 00 80    	mov    0x800058c0,%edx
80001c3e:	8b 52 48             	mov    0x48(%edx),%edx
80001c41:	83 ec 04             	sub    $0x4,%esp
80001c44:	50                   	push   %eax
80001c45:	52                   	push   %edx
80001c46:	68 dc 33 00 80       	push   $0x800033dc
80001c4b:	e8 c7 12 00 00       	call   80002f17 <cprintf>
	*dev = 0;
80001c50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
80001c56:	83 c4 10             	add    $0x10,%esp
80001c59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
80001c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001c61:	c9                   	leave  
80001c62:	c3                   	ret    

80001c63 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
80001c63:	55                   	push   %ebp
80001c64:	89 e5                	mov    %esp,%ebp
80001c66:	56                   	push   %esi
80001c67:	53                   	push   %ebx
80001c68:	83 ec 10             	sub    $0x10,%esp
80001c6b:	8b 75 08             	mov    0x8(%ebp),%esi
80001c6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
80001c71:	8d 45 f4             	lea    -0xc(%ebp),%eax
80001c74:	50                   	push   %eax
80001c75:	8d 86 00 00 00 e0    	lea    -0x20000000(%esi),%eax
80001c7b:	c1 e8 0c             	shr    $0xc,%eax
80001c7e:	50                   	push   %eax
80001c7f:	e8 1b ff ff ff       	call   80001b9f <fd_lookup>
80001c84:	83 c4 08             	add    $0x8,%esp
80001c87:	85 c0                	test   %eax,%eax
80001c89:	78 05                	js     80001c90 <fd_close+0x2d>
	    || fd != fd2)
80001c8b:	3b 75 f4             	cmp    -0xc(%ebp),%esi
80001c8e:	74 0c                	je     80001c9c <fd_close+0x39>
		return (must_exist ? r : 0);
80001c90:	84 db                	test   %bl,%bl
80001c92:	ba 00 00 00 00       	mov    $0x0,%edx
80001c97:	0f 44 c2             	cmove  %edx,%eax
80001c9a:	eb 41                	jmp    80001cdd <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
80001c9c:	83 ec 08             	sub    $0x8,%esp
80001c9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80001ca2:	50                   	push   %eax
80001ca3:	ff 36                	pushl  (%esi)
80001ca5:	e8 4b ff ff ff       	call   80001bf5 <dev_lookup>
80001caa:	89 c3                	mov    %eax,%ebx
80001cac:	83 c4 10             	add    $0x10,%esp
80001caf:	85 c0                	test   %eax,%eax
80001cb1:	78 1a                	js     80001ccd <fd_close+0x6a>
		if (dev->dev_close)
80001cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001cb6:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
80001cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
80001cbe:	85 c0                	test   %eax,%eax
80001cc0:	74 0b                	je     80001ccd <fd_close+0x6a>
			r = (*dev->dev_close)(fd);
80001cc2:	83 ec 0c             	sub    $0xc,%esp
80001cc5:	56                   	push   %esi
80001cc6:	ff d0                	call   *%eax
80001cc8:	89 c3                	mov    %eax,%ebx
80001cca:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
80001ccd:	83 ec 08             	sub    $0x8,%esp
80001cd0:	56                   	push   %esi
80001cd1:	6a 00                	push   $0x0
80001cd3:	e8 bf fc ff ff       	call   80001997 <sys_page_unmap>
	return r;
80001cd8:	83 c4 10             	add    $0x10,%esp
80001cdb:	89 d8                	mov    %ebx,%eax
}
80001cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80001ce0:	5b                   	pop    %ebx
80001ce1:	5e                   	pop    %esi
80001ce2:	5d                   	pop    %ebp
80001ce3:	c3                   	ret    

80001ce4 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
80001ce4:	55                   	push   %ebp
80001ce5:	89 e5                	mov    %esp,%ebp
80001ce7:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80001cea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80001ced:	50                   	push   %eax
80001cee:	ff 75 08             	pushl  0x8(%ebp)
80001cf1:	e8 a9 fe ff ff       	call   80001b9f <fd_lookup>
80001cf6:	83 c4 08             	add    $0x8,%esp
80001cf9:	85 c0                	test   %eax,%eax
80001cfb:	78 10                	js     80001d0d <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
80001cfd:	83 ec 08             	sub    $0x8,%esp
80001d00:	6a 01                	push   $0x1
80001d02:	ff 75 f4             	pushl  -0xc(%ebp)
80001d05:	e8 59 ff ff ff       	call   80001c63 <fd_close>
80001d0a:	83 c4 10             	add    $0x10,%esp
}
80001d0d:	c9                   	leave  
80001d0e:	c3                   	ret    

80001d0f <close_all>:

void
close_all(void)
{
80001d0f:	55                   	push   %ebp
80001d10:	89 e5                	mov    %esp,%ebp
80001d12:	53                   	push   %ebx
80001d13:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
80001d16:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
80001d1b:	83 ec 0c             	sub    $0xc,%esp
80001d1e:	53                   	push   %ebx
80001d1f:	e8 c0 ff ff ff       	call   80001ce4 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
80001d24:	83 c3 01             	add    $0x1,%ebx
80001d27:	83 c4 10             	add    $0x10,%esp
80001d2a:	83 fb 20             	cmp    $0x20,%ebx
80001d2d:	75 ec                	jne    80001d1b <close_all+0xc>
		close(i);
}
80001d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001d32:	c9                   	leave  
80001d33:	c3                   	ret    

80001d34 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
80001d34:	55                   	push   %ebp
80001d35:	89 e5                	mov    %esp,%ebp
80001d37:	57                   	push   %edi
80001d38:	56                   	push   %esi
80001d39:	53                   	push   %ebx
80001d3a:	83 ec 2c             	sub    $0x2c,%esp
80001d3d:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
80001d40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80001d43:	50                   	push   %eax
80001d44:	ff 75 08             	pushl  0x8(%ebp)
80001d47:	e8 53 fe ff ff       	call   80001b9f <fd_lookup>
80001d4c:	83 c4 08             	add    $0x8,%esp
80001d4f:	85 c0                	test   %eax,%eax
80001d51:	0f 88 bf 00 00 00    	js     80001e16 <dup+0xe2>
		return r;
	close(newfdnum);
80001d57:	83 ec 0c             	sub    $0xc,%esp
80001d5a:	56                   	push   %esi
80001d5b:	e8 84 ff ff ff       	call   80001ce4 <close>

	newfd = INDEX2FD(newfdnum);
80001d60:	8d 9e 00 00 02 00    	lea    0x20000(%esi),%ebx
80001d66:	c1 e3 0c             	shl    $0xc,%ebx
	ova = fd2data(oldfd);
80001d69:	83 c4 04             	add    $0x4,%esp
80001d6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80001d6f:	e8 9f fd ff ff       	call   80001b13 <fd2data>
80001d74:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
80001d76:	89 1c 24             	mov    %ebx,(%esp)
80001d79:	e8 95 fd ff ff       	call   80001b13 <fd2data>
80001d7e:	83 c4 10             	add    $0x10,%esp
80001d81:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
80001d84:	89 f8                	mov    %edi,%eax
80001d86:	c1 e8 16             	shr    $0x16,%eax
80001d89:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
80001d90:	a8 01                	test   $0x1,%al
80001d92:	74 37                	je     80001dcb <dup+0x97>
80001d94:	89 f8                	mov    %edi,%eax
80001d96:	c1 e8 0c             	shr    $0xc,%eax
80001d99:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
80001da0:	f6 c2 01             	test   $0x1,%dl
80001da3:	74 26                	je     80001dcb <dup+0x97>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
80001da5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80001dac:	83 ec 0c             	sub    $0xc,%esp
80001daf:	25 07 0e 00 00       	and    $0xe07,%eax
80001db4:	50                   	push   %eax
80001db5:	ff 75 d4             	pushl  -0x2c(%ebp)
80001db8:	6a 00                	push   $0x0
80001dba:	57                   	push   %edi
80001dbb:	6a 00                	push   $0x0
80001dbd:	e8 93 fb ff ff       	call   80001955 <sys_page_map>
80001dc2:	89 c7                	mov    %eax,%edi
80001dc4:	83 c4 20             	add    $0x20,%esp
80001dc7:	85 c0                	test   %eax,%eax
80001dc9:	78 2e                	js     80001df9 <dup+0xc5>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
80001dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80001dce:	89 d0                	mov    %edx,%eax
80001dd0:	c1 e8 0c             	shr    $0xc,%eax
80001dd3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80001dda:	83 ec 0c             	sub    $0xc,%esp
80001ddd:	25 07 0e 00 00       	and    $0xe07,%eax
80001de2:	50                   	push   %eax
80001de3:	53                   	push   %ebx
80001de4:	6a 00                	push   $0x0
80001de6:	52                   	push   %edx
80001de7:	6a 00                	push   $0x0
80001de9:	e8 67 fb ff ff       	call   80001955 <sys_page_map>
80001dee:	89 c7                	mov    %eax,%edi
80001df0:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
80001df3:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
80001df5:	85 ff                	test   %edi,%edi
80001df7:	79 1d                	jns    80001e16 <dup+0xe2>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
80001df9:	83 ec 08             	sub    $0x8,%esp
80001dfc:	53                   	push   %ebx
80001dfd:	6a 00                	push   $0x0
80001dff:	e8 93 fb ff ff       	call   80001997 <sys_page_unmap>
	sys_page_unmap(0, nva);
80001e04:	83 c4 08             	add    $0x8,%esp
80001e07:	ff 75 d4             	pushl  -0x2c(%ebp)
80001e0a:	6a 00                	push   $0x0
80001e0c:	e8 86 fb ff ff       	call   80001997 <sys_page_unmap>
	return r;
80001e11:	83 c4 10             	add    $0x10,%esp
80001e14:	89 f8                	mov    %edi,%eax
}
80001e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001e19:	5b                   	pop    %ebx
80001e1a:	5e                   	pop    %esi
80001e1b:	5f                   	pop    %edi
80001e1c:	5d                   	pop    %ebp
80001e1d:	c3                   	ret    

80001e1e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
80001e1e:	55                   	push   %ebp
80001e1f:	89 e5                	mov    %esp,%ebp
80001e21:	53                   	push   %ebx
80001e22:	83 ec 14             	sub    $0x14,%esp
80001e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
80001e28:	8d 45 f0             	lea    -0x10(%ebp),%eax
80001e2b:	50                   	push   %eax
80001e2c:	53                   	push   %ebx
80001e2d:	e8 6d fd ff ff       	call   80001b9f <fd_lookup>
80001e32:	83 c4 08             	add    $0x8,%esp
80001e35:	89 c2                	mov    %eax,%edx
80001e37:	85 c0                	test   %eax,%eax
80001e39:	78 6d                	js     80001ea8 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80001e3b:	83 ec 08             	sub    $0x8,%esp
80001e3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80001e41:	50                   	push   %eax
80001e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001e45:	ff 30                	pushl  (%eax)
80001e47:	e8 a9 fd ff ff       	call   80001bf5 <dev_lookup>
80001e4c:	83 c4 10             	add    $0x10,%esp
80001e4f:	85 c0                	test   %eax,%eax
80001e51:	78 4c                	js     80001e9f <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
80001e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80001e56:	8b 42 08             	mov    0x8(%edx),%eax
80001e59:	83 e0 03             	and    $0x3,%eax
80001e5c:	83 f8 01             	cmp    $0x1,%eax
80001e5f:	75 21                	jne    80001e82 <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
80001e61:	a1 c0 58 00 80       	mov    0x800058c0,%eax
80001e66:	8b 40 48             	mov    0x48(%eax),%eax
80001e69:	83 ec 04             	sub    $0x4,%esp
80001e6c:	53                   	push   %ebx
80001e6d:	50                   	push   %eax
80001e6e:	68 1d 34 00 80       	push   $0x8000341d
80001e73:	e8 9f 10 00 00       	call   80002f17 <cprintf>
		return -E_INVAL;
80001e78:	83 c4 10             	add    $0x10,%esp
80001e7b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
80001e80:	eb 26                	jmp    80001ea8 <read+0x8a>
	}
	if (!dev->dev_read)
80001e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80001e85:	8b 40 08             	mov    0x8(%eax),%eax
80001e88:	85 c0                	test   %eax,%eax
80001e8a:	74 17                	je     80001ea3 <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
80001e8c:	83 ec 04             	sub    $0x4,%esp
80001e8f:	ff 75 10             	pushl  0x10(%ebp)
80001e92:	ff 75 0c             	pushl  0xc(%ebp)
80001e95:	52                   	push   %edx
80001e96:	ff d0                	call   *%eax
80001e98:	89 c2                	mov    %eax,%edx
80001e9a:	83 c4 10             	add    $0x10,%esp
80001e9d:	eb 09                	jmp    80001ea8 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80001e9f:	89 c2                	mov    %eax,%edx
80001ea1:	eb 05                	jmp    80001ea8 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
80001ea3:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_read)(fd, buf, n);
}
80001ea8:	89 d0                	mov    %edx,%eax
80001eaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001ead:	c9                   	leave  
80001eae:	c3                   	ret    

80001eaf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
80001eaf:	55                   	push   %ebp
80001eb0:	89 e5                	mov    %esp,%ebp
80001eb2:	57                   	push   %edi
80001eb3:	56                   	push   %esi
80001eb4:	53                   	push   %ebx
80001eb5:	83 ec 0c             	sub    $0xc,%esp
80001eb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80001ebb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
80001ebe:	85 f6                	test   %esi,%esi
80001ec0:	74 31                	je     80001ef3 <readn+0x44>
80001ec2:	b8 00 00 00 00       	mov    $0x0,%eax
80001ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
80001ecc:	83 ec 04             	sub    $0x4,%esp
80001ecf:	89 f2                	mov    %esi,%edx
80001ed1:	29 c2                	sub    %eax,%edx
80001ed3:	52                   	push   %edx
80001ed4:	03 45 0c             	add    0xc(%ebp),%eax
80001ed7:	50                   	push   %eax
80001ed8:	57                   	push   %edi
80001ed9:	e8 40 ff ff ff       	call   80001e1e <read>
		if (m < 0)
80001ede:	83 c4 10             	add    $0x10,%esp
80001ee1:	85 c0                	test   %eax,%eax
80001ee3:	78 17                	js     80001efc <readn+0x4d>
			return m;
		if (m == 0)
80001ee5:	85 c0                	test   %eax,%eax
80001ee7:	74 11                	je     80001efa <readn+0x4b>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
80001ee9:	01 c3                	add    %eax,%ebx
80001eeb:	89 d8                	mov    %ebx,%eax
80001eed:	39 f3                	cmp    %esi,%ebx
80001eef:	72 db                	jb     80001ecc <readn+0x1d>
80001ef1:	eb 09                	jmp    80001efc <readn+0x4d>
80001ef3:	b8 00 00 00 00       	mov    $0x0,%eax
80001ef8:	eb 02                	jmp    80001efc <readn+0x4d>
80001efa:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
80001efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001eff:	5b                   	pop    %ebx
80001f00:	5e                   	pop    %esi
80001f01:	5f                   	pop    %edi
80001f02:	5d                   	pop    %ebp
80001f03:	c3                   	ret    

80001f04 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
80001f04:	55                   	push   %ebp
80001f05:	89 e5                	mov    %esp,%ebp
80001f07:	53                   	push   %ebx
80001f08:	83 ec 14             	sub    $0x14,%esp
80001f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
80001f0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80001f11:	50                   	push   %eax
80001f12:	53                   	push   %ebx
80001f13:	e8 87 fc ff ff       	call   80001b9f <fd_lookup>
80001f18:	83 c4 08             	add    $0x8,%esp
80001f1b:	89 c2                	mov    %eax,%edx
80001f1d:	85 c0                	test   %eax,%eax
80001f1f:	78 68                	js     80001f89 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80001f21:	83 ec 08             	sub    $0x8,%esp
80001f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80001f27:	50                   	push   %eax
80001f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001f2b:	ff 30                	pushl  (%eax)
80001f2d:	e8 c3 fc ff ff       	call   80001bf5 <dev_lookup>
80001f32:	83 c4 10             	add    $0x10,%esp
80001f35:	85 c0                	test   %eax,%eax
80001f37:	78 47                	js     80001f80 <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
80001f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001f3c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
80001f40:	75 21                	jne    80001f63 <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
80001f42:	a1 c0 58 00 80       	mov    0x800058c0,%eax
80001f47:	8b 40 48             	mov    0x48(%eax),%eax
80001f4a:	83 ec 04             	sub    $0x4,%esp
80001f4d:	53                   	push   %ebx
80001f4e:	50                   	push   %eax
80001f4f:	68 39 34 00 80       	push   $0x80003439
80001f54:	e8 be 0f 00 00       	call   80002f17 <cprintf>
		return -E_INVAL;
80001f59:	83 c4 10             	add    $0x10,%esp
80001f5c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
80001f61:	eb 26                	jmp    80001f89 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
80001f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
80001f66:	8b 52 0c             	mov    0xc(%edx),%edx
80001f69:	85 d2                	test   %edx,%edx
80001f6b:	74 17                	je     80001f84 <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
80001f6d:	83 ec 04             	sub    $0x4,%esp
80001f70:	ff 75 10             	pushl  0x10(%ebp)
80001f73:	ff 75 0c             	pushl  0xc(%ebp)
80001f76:	50                   	push   %eax
80001f77:	ff d2                	call   *%edx
80001f79:	89 c2                	mov    %eax,%edx
80001f7b:	83 c4 10             	add    $0x10,%esp
80001f7e:	eb 09                	jmp    80001f89 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80001f80:	89 c2                	mov    %eax,%edx
80001f82:	eb 05                	jmp    80001f89 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
80001f84:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_write)(fd, buf, n);
}
80001f89:	89 d0                	mov    %edx,%eax
80001f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001f8e:	c9                   	leave  
80001f8f:	c3                   	ret    

80001f90 <seek>:

int
seek(int fdnum, off_t offset)
{
80001f90:	55                   	push   %ebp
80001f91:	89 e5                	mov    %esp,%ebp
80001f93:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80001f96:	8d 45 fc             	lea    -0x4(%ebp),%eax
80001f99:	50                   	push   %eax
80001f9a:	ff 75 08             	pushl  0x8(%ebp)
80001f9d:	e8 fd fb ff ff       	call   80001b9f <fd_lookup>
80001fa2:	83 c4 08             	add    $0x8,%esp
80001fa5:	85 c0                	test   %eax,%eax
80001fa7:	78 0e                	js     80001fb7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
80001fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80001fac:	8b 55 0c             	mov    0xc(%ebp),%edx
80001faf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
80001fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80001fb7:	c9                   	leave  
80001fb8:	c3                   	ret    

80001fb9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
80001fb9:	55                   	push   %ebp
80001fba:	89 e5                	mov    %esp,%ebp
80001fbc:	53                   	push   %ebx
80001fbd:	83 ec 14             	sub    $0x14,%esp
80001fc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
80001fc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80001fc6:	50                   	push   %eax
80001fc7:	53                   	push   %ebx
80001fc8:	e8 d2 fb ff ff       	call   80001b9f <fd_lookup>
80001fcd:	83 c4 08             	add    $0x8,%esp
80001fd0:	89 c2                	mov    %eax,%edx
80001fd2:	85 c0                	test   %eax,%eax
80001fd4:	78 65                	js     8000203b <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80001fd6:	83 ec 08             	sub    $0x8,%esp
80001fd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80001fdc:	50                   	push   %eax
80001fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001fe0:	ff 30                	pushl  (%eax)
80001fe2:	e8 0e fc ff ff       	call   80001bf5 <dev_lookup>
80001fe7:	83 c4 10             	add    $0x10,%esp
80001fea:	85 c0                	test   %eax,%eax
80001fec:	78 44                	js     80002032 <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
80001fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80001ff1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
80001ff5:	75 21                	jne    80002018 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
80001ff7:	a1 c0 58 00 80       	mov    0x800058c0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
80001ffc:	8b 40 48             	mov    0x48(%eax),%eax
80001fff:	83 ec 04             	sub    $0x4,%esp
80002002:	53                   	push   %ebx
80002003:	50                   	push   %eax
80002004:	68 fc 33 00 80       	push   $0x800033fc
80002009:	e8 09 0f 00 00       	call   80002f17 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
8000200e:	83 c4 10             	add    $0x10,%esp
80002011:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
80002016:	eb 23                	jmp    8000203b <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
80002018:	8b 55 f4             	mov    -0xc(%ebp),%edx
8000201b:	8b 52 18             	mov    0x18(%edx),%edx
8000201e:	85 d2                	test   %edx,%edx
80002020:	74 14                	je     80002036 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
80002022:	83 ec 08             	sub    $0x8,%esp
80002025:	ff 75 0c             	pushl  0xc(%ebp)
80002028:	50                   	push   %eax
80002029:	ff d2                	call   *%edx
8000202b:	89 c2                	mov    %eax,%edx
8000202d:	83 c4 10             	add    $0x10,%esp
80002030:	eb 09                	jmp    8000203b <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80002032:	89 c2                	mov    %eax,%edx
80002034:	eb 05                	jmp    8000203b <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
80002036:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
8000203b:	89 d0                	mov    %edx,%eax
8000203d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002040:	c9                   	leave  
80002041:	c3                   	ret    

80002042 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
80002042:	55                   	push   %ebp
80002043:	89 e5                	mov    %esp,%ebp
80002045:	53                   	push   %ebx
80002046:	83 ec 14             	sub    $0x14,%esp
80002049:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
8000204c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8000204f:	50                   	push   %eax
80002050:	ff 75 08             	pushl  0x8(%ebp)
80002053:	e8 47 fb ff ff       	call   80001b9f <fd_lookup>
80002058:	83 c4 08             	add    $0x8,%esp
8000205b:	89 c2                	mov    %eax,%edx
8000205d:	85 c0                	test   %eax,%eax
8000205f:	78 4f                	js     800020b0 <fstat+0x6e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80002061:	83 ec 08             	sub    $0x8,%esp
80002064:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002067:	50                   	push   %eax
80002068:	8b 45 f0             	mov    -0x10(%ebp),%eax
8000206b:	ff 30                	pushl  (%eax)
8000206d:	e8 83 fb ff ff       	call   80001bf5 <dev_lookup>
80002072:	83 c4 10             	add    $0x10,%esp
80002075:	85 c0                	test   %eax,%eax
80002077:	78 2e                	js     800020a7 <fstat+0x65>
		return r;
	if (!dev->dev_stat)
80002079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000207c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
80002080:	74 29                	je     800020ab <fstat+0x69>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
80002082:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
80002085:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	stat->st_isdir = 0;
8000208c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	stat->st_dev = dev;
80002093:	89 43 18             	mov    %eax,0x18(%ebx)
	return (*dev->dev_stat)(fd, stat);
80002096:	83 ec 08             	sub    $0x8,%esp
80002099:	53                   	push   %ebx
8000209a:	ff 75 f0             	pushl  -0x10(%ebp)
8000209d:	ff 50 14             	call   *0x14(%eax)
800020a0:	89 c2                	mov    %eax,%edx
800020a2:	83 c4 10             	add    $0x10,%esp
800020a5:	eb 09                	jmp    800020b0 <fstat+0x6e>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
800020a7:	89 c2                	mov    %eax,%edx
800020a9:	eb 05                	jmp    800020b0 <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
800020ab:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
800020b0:	89 d0                	mov    %edx,%eax
800020b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800020b5:	c9                   	leave  
800020b6:	c3                   	ret    

800020b7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
800020b7:	55                   	push   %ebp
800020b8:	89 e5                	mov    %esp,%ebp
800020ba:	56                   	push   %esi
800020bb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
800020bc:	83 ec 08             	sub    $0x8,%esp
800020bf:	6a 00                	push   $0x0
800020c1:	ff 75 08             	pushl  0x8(%ebp)
800020c4:	e8 a5 01 00 00       	call   8000226e <open>
800020c9:	89 c3                	mov    %eax,%ebx
800020cb:	83 c4 10             	add    $0x10,%esp
800020ce:	85 c0                	test   %eax,%eax
800020d0:	78 1b                	js     800020ed <stat+0x36>
		return fd;
	r = fstat(fd, stat);
800020d2:	83 ec 08             	sub    $0x8,%esp
800020d5:	ff 75 0c             	pushl  0xc(%ebp)
800020d8:	50                   	push   %eax
800020d9:	e8 64 ff ff ff       	call   80002042 <fstat>
800020de:	89 c6                	mov    %eax,%esi
	close(fd);
800020e0:	89 1c 24             	mov    %ebx,(%esp)
800020e3:	e8 fc fb ff ff       	call   80001ce4 <close>
	return r;
800020e8:	83 c4 10             	add    $0x10,%esp
800020eb:	89 f0                	mov    %esi,%eax
}
800020ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
800020f0:	5b                   	pop    %ebx
800020f1:	5e                   	pop    %esi
800020f2:	5d                   	pop    %ebp
800020f3:	c3                   	ret    

800020f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
800020f4:	55                   	push   %ebp
800020f5:	89 e5                	mov    %esp,%ebp
800020f7:	56                   	push   %esi
800020f8:	53                   	push   %ebx
800020f9:	89 c6                	mov    %eax,%esi
800020fb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
800020fd:	83 3d 00 50 00 80 00 	cmpl   $0x0,0x80005000
80002104:	75 12                	jne    80002118 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
80002106:	83 ec 0c             	sub    $0xc,%esp
80002109:	6a 01                	push   $0x1
8000210b:	e8 4b 06 00 00       	call   8000275b <ipc_find_env>
80002110:	a3 00 50 00 80       	mov    %eax,0x80005000
80002115:	83 c4 10             	add    $0x10,%esp

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", 
			thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
80002118:	6a 07                	push   $0x7
8000211a:	68 00 60 00 80       	push   $0x80006000
8000211f:	56                   	push   %esi
80002120:	ff 35 00 50 00 80    	pushl  0x80005000
80002126:	e8 dc 05 00 00       	call   80002707 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
8000212b:	83 c4 0c             	add    $0xc,%esp
8000212e:	6a 00                	push   $0x0
80002130:	53                   	push   %ebx
80002131:	6a 00                	push   $0x0
80002133:	e8 4e 05 00 00       	call   80002686 <ipc_recv>
}
80002138:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000213b:	5b                   	pop    %ebx
8000213c:	5e                   	pop    %esi
8000213d:	5d                   	pop    %ebp
8000213e:	c3                   	ret    

8000213f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
8000213f:	55                   	push   %ebp
80002140:	89 e5                	mov    %esp,%ebp
80002142:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
80002145:	8b 45 08             	mov    0x8(%ebp),%eax
80002148:	8b 40 0c             	mov    0xc(%eax),%eax
8000214b:	a3 00 60 00 80       	mov    %eax,0x80006000
	fsipcbuf.set_size.req_size = newsize;
80002150:	8b 45 0c             	mov    0xc(%ebp),%eax
80002153:	a3 04 60 00 80       	mov    %eax,0x80006004
	return fsipc(FSREQ_SET_SIZE, NULL);
80002158:	ba 00 00 00 00       	mov    $0x0,%edx
8000215d:	b8 02 00 00 00       	mov    $0x2,%eax
80002162:	e8 8d ff ff ff       	call   800020f4 <fsipc>
}
80002167:	c9                   	leave  
80002168:	c3                   	ret    

80002169 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
80002169:	55                   	push   %ebp
8000216a:	89 e5                	mov    %esp,%ebp
8000216c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
8000216f:	8b 45 08             	mov    0x8(%ebp),%eax
80002172:	8b 40 0c             	mov    0xc(%eax),%eax
80002175:	a3 00 60 00 80       	mov    %eax,0x80006000
	return fsipc(FSREQ_FLUSH, NULL);
8000217a:	ba 00 00 00 00       	mov    $0x0,%edx
8000217f:	b8 06 00 00 00       	mov    $0x6,%eax
80002184:	e8 6b ff ff ff       	call   800020f4 <fsipc>
}
80002189:	c9                   	leave  
8000218a:	c3                   	ret    

8000218b <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
8000218b:	55                   	push   %ebp
8000218c:	89 e5                	mov    %esp,%ebp
8000218e:	53                   	push   %ebx
8000218f:	83 ec 04             	sub    $0x4,%esp
80002192:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
80002195:	8b 45 08             	mov    0x8(%ebp),%eax
80002198:	8b 40 0c             	mov    0xc(%eax),%eax
8000219b:	a3 00 60 00 80       	mov    %eax,0x80006000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
800021a0:	ba 00 00 00 00       	mov    $0x0,%edx
800021a5:	b8 05 00 00 00       	mov    $0x5,%eax
800021aa:	e8 45 ff ff ff       	call   800020f4 <fsipc>
800021af:	85 c0                	test   %eax,%eax
800021b1:	78 26                	js     800021d9 <devfile_stat+0x4e>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
800021b3:	83 ec 08             	sub    $0x8,%esp
800021b6:	68 00 60 00 80       	push   $0x80006000
800021bb:	53                   	push   %ebx
800021bc:	e8 6e f2 ff ff       	call   8000142f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
800021c1:	a1 10 60 00 80       	mov    0x80006010,%eax
800021c6:	89 43 10             	mov    %eax,0x10(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
800021c9:	a1 14 60 00 80       	mov    0x80006014,%eax
800021ce:	89 43 14             	mov    %eax,0x14(%ebx)
	return 0;
800021d1:	83 c4 10             	add    $0x10,%esp
800021d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
800021d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800021dc:	c9                   	leave  
800021dd:	c3                   	ret    

800021de <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
800021de:	55                   	push   %ebp
800021df:	89 e5                	mov    %esp,%ebp
800021e1:	83 ec 0c             	sub    $0xc,%esp
800021e4:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	// panic("devfile_write not implemented");
	int max = PGSIZE - (sizeof(int) + sizeof(size_t));
	n = n > max ? max : n;
800021e7:	3d f8 0f 00 00       	cmp    $0xff8,%eax
800021ec:	ba f8 0f 00 00       	mov    $0xff8,%edx
800021f1:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
800021f4:	8b 55 08             	mov    0x8(%ebp),%edx
800021f7:	8b 52 0c             	mov    0xc(%edx),%edx
800021fa:	89 15 00 60 00 80    	mov    %edx,0x80006000
	fsipcbuf.write.req_n = n;
80002200:	a3 04 60 00 80       	mov    %eax,0x80006004
	memmove(fsipcbuf.write.req_buf, buf, n);
80002205:	50                   	push   %eax
80002206:	ff 75 0c             	pushl  0xc(%ebp)
80002209:	68 08 60 00 80       	push   $0x80006008
8000220e:	e8 0b f4 ff ff       	call   8000161e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
80002213:	ba 00 00 00 00       	mov    $0x0,%edx
80002218:	b8 04 00 00 00       	mov    $0x4,%eax
8000221d:	e8 d2 fe ff ff       	call   800020f4 <fsipc>
}
80002222:	c9                   	leave  
80002223:	c3                   	ret    

80002224 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
80002224:	55                   	push   %ebp
80002225:	89 e5                	mov    %esp,%ebp
80002227:	53                   	push   %ebx
80002228:	83 ec 04             	sub    $0x4,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
8000222b:	8b 45 08             	mov    0x8(%ebp),%eax
8000222e:	8b 40 0c             	mov    0xc(%eax),%eax
80002231:	a3 00 60 00 80       	mov    %eax,0x80006000
	fsipcbuf.read.req_n = n;
80002236:	8b 45 10             	mov    0x10(%ebp),%eax
80002239:	a3 04 60 00 80       	mov    %eax,0x80006004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
8000223e:	ba 00 00 00 00       	mov    $0x0,%edx
80002243:	b8 03 00 00 00       	mov    $0x3,%eax
80002248:	e8 a7 fe ff ff       	call   800020f4 <fsipc>
8000224d:	89 c3                	mov    %eax,%ebx
8000224f:	85 c0                	test   %eax,%eax
80002251:	78 14                	js     80002267 <devfile_read+0x43>
		return r;
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
80002253:	83 ec 04             	sub    $0x4,%esp
80002256:	50                   	push   %eax
80002257:	68 00 60 00 80       	push   $0x80006000
8000225c:	ff 75 0c             	pushl  0xc(%ebp)
8000225f:	e8 ba f3 ff ff       	call   8000161e <memmove>
	return r;
80002264:	83 c4 10             	add    $0x10,%esp
}
80002267:	89 d8                	mov    %ebx,%eax
80002269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000226c:	c9                   	leave  
8000226d:	c3                   	ret    

8000226e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
8000226e:	55                   	push   %ebp
8000226f:	89 e5                	mov    %esp,%ebp
80002271:	53                   	push   %ebx
80002272:	83 ec 20             	sub    $0x20,%esp
80002275:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
80002278:	53                   	push   %ebx
80002279:	e8 56 f1 ff ff       	call   800013d4 <strlen>
8000227e:	83 c4 10             	add    $0x10,%esp
80002281:	83 f8 7f             	cmp    $0x7f,%eax
80002284:	7f 67                	jg     800022ed <open+0x7f>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
80002286:	83 ec 0c             	sub    $0xc,%esp
80002289:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000228c:	50                   	push   %eax
8000228d:	e8 99 f8 ff ff       	call   80001b2b <fd_alloc>
80002292:	83 c4 10             	add    $0x10,%esp
		return r;
80002295:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
80002297:	85 c0                	test   %eax,%eax
80002299:	78 57                	js     800022f2 <open+0x84>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
8000229b:	83 ec 08             	sub    $0x8,%esp
8000229e:	53                   	push   %ebx
8000229f:	68 00 60 00 80       	push   $0x80006000
800022a4:	e8 86 f1 ff ff       	call   8000142f <strcpy>
	fsipcbuf.open.req_omode = mode;
800022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
800022ac:	a3 80 60 00 80       	mov    %eax,0x80006080

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
800022b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
800022b4:	b8 01 00 00 00       	mov    $0x1,%eax
800022b9:	e8 36 fe ff ff       	call   800020f4 <fsipc>
800022be:	89 c3                	mov    %eax,%ebx
800022c0:	83 c4 10             	add    $0x10,%esp
800022c3:	85 c0                	test   %eax,%eax
800022c5:	79 14                	jns    800022db <open+0x6d>
		fd_close(fd, 0);
800022c7:	83 ec 08             	sub    $0x8,%esp
800022ca:	6a 00                	push   $0x0
800022cc:	ff 75 f4             	pushl  -0xc(%ebp)
800022cf:	e8 8f f9 ff ff       	call   80001c63 <fd_close>
		return r;
800022d4:	83 c4 10             	add    $0x10,%esp
800022d7:	89 da                	mov    %ebx,%edx
800022d9:	eb 17                	jmp    800022f2 <open+0x84>
	}

	return fd2num(fd);
800022db:	83 ec 0c             	sub    $0xc,%esp
800022de:	ff 75 f4             	pushl  -0xc(%ebp)
800022e1:	e8 1d f8 ff ff       	call   80001b03 <fd2num>
800022e6:	89 c2                	mov    %eax,%edx
800022e8:	83 c4 10             	add    $0x10,%esp
800022eb:	eb 05                	jmp    800022f2 <open+0x84>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
800022ed:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
800022f2:	89 d0                	mov    %edx,%eax
800022f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800022f7:	c9                   	leave  
800022f8:	c3                   	ret    

800022f9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
800022f9:	55                   	push   %ebp
800022fa:	89 e5                	mov    %esp,%ebp
800022fc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
800022ff:	ba 00 00 00 00       	mov    $0x0,%edx
80002304:	b8 09 00 00 00       	mov    $0x9,%eax
80002309:	e8 e6 fd ff ff       	call   800020f4 <fsipc>
}
8000230e:	c9                   	leave  
8000230f:	c3                   	ret    

80002310 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
80002310:	55                   	push   %ebp
80002311:	89 e5                	mov    %esp,%ebp
80002313:	56                   	push   %esi
80002314:	53                   	push   %ebx
80002315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
80002318:	83 ec 0c             	sub    $0xc,%esp
8000231b:	ff 75 08             	pushl  0x8(%ebp)
8000231e:	e8 f0 f7 ff ff       	call   80001b13 <fd2data>
80002323:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
80002325:	83 c4 08             	add    $0x8,%esp
80002328:	68 56 34 00 80       	push   $0x80003456
8000232d:	53                   	push   %ebx
8000232e:	e8 fc f0 ff ff       	call   8000142f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
80002333:	8b 46 04             	mov    0x4(%esi),%eax
80002336:	2b 06                	sub    (%esi),%eax
80002338:	89 43 10             	mov    %eax,0x10(%ebx)
	stat->st_isdir = 0;
8000233b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	stat->st_dev = &devpipe;
80002342:	c7 43 18 20 40 00 80 	movl   $0x80004020,0x18(%ebx)
	return 0;
}
80002349:	b8 00 00 00 00       	mov    $0x0,%eax
8000234e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002351:	5b                   	pop    %ebx
80002352:	5e                   	pop    %esi
80002353:	5d                   	pop    %ebp
80002354:	c3                   	ret    

80002355 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
80002355:	55                   	push   %ebp
80002356:	89 e5                	mov    %esp,%ebp
80002358:	53                   	push   %ebx
80002359:	83 ec 0c             	sub    $0xc,%esp
8000235c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
8000235f:	53                   	push   %ebx
80002360:	6a 00                	push   $0x0
80002362:	e8 30 f6 ff ff       	call   80001997 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
80002367:	89 1c 24             	mov    %ebx,(%esp)
8000236a:	e8 a4 f7 ff ff       	call   80001b13 <fd2data>
8000236f:	83 c4 08             	add    $0x8,%esp
80002372:	50                   	push   %eax
80002373:	6a 00                	push   $0x0
80002375:	e8 1d f6 ff ff       	call   80001997 <sys_page_unmap>
}
8000237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000237d:	c9                   	leave  
8000237e:	c3                   	ret    

8000237f <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
8000237f:	55                   	push   %ebp
80002380:	89 e5                	mov    %esp,%ebp
80002382:	57                   	push   %edi
80002383:	56                   	push   %esi
80002384:	53                   	push   %ebx
80002385:	83 ec 1c             	sub    $0x1c,%esp
80002388:	89 45 e0             	mov    %eax,-0x20(%ebp)
8000238b:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
8000238d:	a1 c0 58 00 80       	mov    0x800058c0,%eax
80002392:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
80002395:	83 ec 0c             	sub    $0xc,%esp
80002398:	ff 75 e0             	pushl  -0x20(%ebp)
8000239b:	e8 1e 04 00 00       	call   800027be <pageref>
800023a0:	89 c3                	mov    %eax,%ebx
800023a2:	89 3c 24             	mov    %edi,(%esp)
800023a5:	e8 14 04 00 00       	call   800027be <pageref>
800023aa:	83 c4 10             	add    $0x10,%esp
800023ad:	39 c3                	cmp    %eax,%ebx
800023af:	0f 94 c1             	sete   %cl
800023b2:	0f b6 c9             	movzbl %cl,%ecx
800023b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
800023b8:	8b 15 c0 58 00 80    	mov    0x800058c0,%edx
800023be:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
800023c1:	39 ce                	cmp    %ecx,%esi
800023c3:	74 1b                	je     800023e0 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
800023c5:	39 c3                	cmp    %eax,%ebx
800023c7:	75 c4                	jne    8000238d <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
800023c9:	8b 42 58             	mov    0x58(%edx),%eax
800023cc:	ff 75 e4             	pushl  -0x1c(%ebp)
800023cf:	50                   	push   %eax
800023d0:	56                   	push   %esi
800023d1:	68 5d 34 00 80       	push   $0x8000345d
800023d6:	e8 3c 0b 00 00       	call   80002f17 <cprintf>
800023db:	83 c4 10             	add    $0x10,%esp
800023de:	eb ad                	jmp    8000238d <_pipeisclosed+0xe>
	}
}
800023e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
800023e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
800023e6:	5b                   	pop    %ebx
800023e7:	5e                   	pop    %esi
800023e8:	5f                   	pop    %edi
800023e9:	5d                   	pop    %ebp
800023ea:	c3                   	ret    

800023eb <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
800023eb:	55                   	push   %ebp
800023ec:	89 e5                	mov    %esp,%ebp
800023ee:	57                   	push   %edi
800023ef:	56                   	push   %esi
800023f0:	53                   	push   %ebx
800023f1:	83 ec 28             	sub    $0x28,%esp
800023f4:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
800023f7:	56                   	push   %esi
800023f8:	e8 16 f7 ff ff       	call   80001b13 <fd2data>
800023fd:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
800023ff:	83 c4 10             	add    $0x10,%esp
80002402:	bf 00 00 00 00       	mov    $0x0,%edi
80002407:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8000240b:	75 52                	jne    8000245f <devpipe_write+0x74>
8000240d:	eb 5e                	jmp    8000246d <devpipe_write+0x82>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
8000240f:	89 da                	mov    %ebx,%edx
80002411:	89 f0                	mov    %esi,%eax
80002413:	e8 67 ff ff ff       	call   8000237f <_pipeisclosed>
80002418:	85 c0                	test   %eax,%eax
8000241a:	75 56                	jne    80002472 <devpipe_write+0x87>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
8000241c:	e8 d2 f4 ff ff       	call   800018f3 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
80002421:	8b 43 04             	mov    0x4(%ebx),%eax
80002424:	8b 0b                	mov    (%ebx),%ecx
80002426:	8d 51 20             	lea    0x20(%ecx),%edx
80002429:	39 d0                	cmp    %edx,%eax
8000242b:	73 e2                	jae    8000240f <devpipe_write+0x24>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
8000242d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002430:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
80002434:	88 4d e7             	mov    %cl,-0x19(%ebp)
80002437:	89 c2                	mov    %eax,%edx
80002439:	c1 fa 1f             	sar    $0x1f,%edx
8000243c:	89 d1                	mov    %edx,%ecx
8000243e:	c1 e9 1b             	shr    $0x1b,%ecx
80002441:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80002444:	83 e2 1f             	and    $0x1f,%edx
80002447:	29 ca                	sub    %ecx,%edx
80002449:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
8000244d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
80002451:	83 c0 01             	add    $0x1,%eax
80002454:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002457:	83 c7 01             	add    $0x1,%edi
8000245a:	39 7d 10             	cmp    %edi,0x10(%ebp)
8000245d:	74 0e                	je     8000246d <devpipe_write+0x82>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
8000245f:	8b 43 04             	mov    0x4(%ebx),%eax
80002462:	8b 0b                	mov    (%ebx),%ecx
80002464:	8d 51 20             	lea    0x20(%ecx),%edx
80002467:	39 d0                	cmp    %edx,%eax
80002469:	73 a4                	jae    8000240f <devpipe_write+0x24>
8000246b:	eb c0                	jmp    8000242d <devpipe_write+0x42>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
8000246d:	8b 45 10             	mov    0x10(%ebp),%eax
80002470:	eb 05                	jmp    80002477 <devpipe_write+0x8c>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
80002472:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
80002477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000247a:	5b                   	pop    %ebx
8000247b:	5e                   	pop    %esi
8000247c:	5f                   	pop    %edi
8000247d:	5d                   	pop    %ebp
8000247e:	c3                   	ret    

8000247f <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
8000247f:	55                   	push   %ebp
80002480:	89 e5                	mov    %esp,%ebp
80002482:	57                   	push   %edi
80002483:	56                   	push   %esi
80002484:	53                   	push   %ebx
80002485:	83 ec 18             	sub    $0x18,%esp
80002488:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
8000248b:	57                   	push   %edi
8000248c:	e8 82 f6 ff ff       	call   80001b13 <fd2data>
80002491:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002493:	83 c4 10             	add    $0x10,%esp
80002496:	be 00 00 00 00       	mov    $0x0,%esi
8000249b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8000249f:	75 40                	jne    800024e1 <devpipe_read+0x62>
800024a1:	eb 4b                	jmp    800024ee <devpipe_read+0x6f>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
800024a3:	89 f0                	mov    %esi,%eax
800024a5:	eb 51                	jmp    800024f8 <devpipe_read+0x79>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
800024a7:	89 da                	mov    %ebx,%edx
800024a9:	89 f8                	mov    %edi,%eax
800024ab:	e8 cf fe ff ff       	call   8000237f <_pipeisclosed>
800024b0:	85 c0                	test   %eax,%eax
800024b2:	75 3f                	jne    800024f3 <devpipe_read+0x74>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
800024b4:	e8 3a f4 ff ff       	call   800018f3 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
800024b9:	8b 03                	mov    (%ebx),%eax
800024bb:	3b 43 04             	cmp    0x4(%ebx),%eax
800024be:	74 e7                	je     800024a7 <devpipe_read+0x28>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
800024c0:	99                   	cltd   
800024c1:	c1 ea 1b             	shr    $0x1b,%edx
800024c4:	01 d0                	add    %edx,%eax
800024c6:	83 e0 1f             	and    $0x1f,%eax
800024c9:	29 d0                	sub    %edx,%eax
800024cb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
800024d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800024d3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
800024d6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
800024d9:	83 c6 01             	add    $0x1,%esi
800024dc:	39 75 10             	cmp    %esi,0x10(%ebp)
800024df:	74 0d                	je     800024ee <devpipe_read+0x6f>
		while (p->p_rpos == p->p_wpos) {
800024e1:	8b 03                	mov    (%ebx),%eax
800024e3:	3b 43 04             	cmp    0x4(%ebx),%eax
800024e6:	75 d8                	jne    800024c0 <devpipe_read+0x41>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
800024e8:	85 f6                	test   %esi,%esi
800024ea:	75 b7                	jne    800024a3 <devpipe_read+0x24>
800024ec:	eb b9                	jmp    800024a7 <devpipe_read+0x28>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
800024ee:	8b 45 10             	mov    0x10(%ebp),%eax
800024f1:	eb 05                	jmp    800024f8 <devpipe_read+0x79>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
800024f3:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
800024f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
800024fb:	5b                   	pop    %ebx
800024fc:	5e                   	pop    %esi
800024fd:	5f                   	pop    %edi
800024fe:	5d                   	pop    %ebp
800024ff:	c3                   	ret    

80002500 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
80002500:	55                   	push   %ebp
80002501:	89 e5                	mov    %esp,%ebp
80002503:	56                   	push   %esi
80002504:	53                   	push   %ebx
80002505:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
80002508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000250b:	50                   	push   %eax
8000250c:	e8 1a f6 ff ff       	call   80001b2b <fd_alloc>
80002511:	83 c4 10             	add    $0x10,%esp
80002514:	89 c2                	mov    %eax,%edx
80002516:	85 c0                	test   %eax,%eax
80002518:	0f 88 2c 01 00 00    	js     8000264a <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
8000251e:	83 ec 04             	sub    $0x4,%esp
80002521:	68 07 04 00 00       	push   $0x407
80002526:	ff 75 f4             	pushl  -0xc(%ebp)
80002529:	6a 00                	push   $0x0
8000252b:	e8 e2 f3 ff ff       	call   80001912 <sys_page_alloc>
80002530:	83 c4 10             	add    $0x10,%esp
80002533:	89 c2                	mov    %eax,%edx
80002535:	85 c0                	test   %eax,%eax
80002537:	0f 88 0d 01 00 00    	js     8000264a <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
8000253d:	83 ec 0c             	sub    $0xc,%esp
80002540:	8d 45 f0             	lea    -0x10(%ebp),%eax
80002543:	50                   	push   %eax
80002544:	e8 e2 f5 ff ff       	call   80001b2b <fd_alloc>
80002549:	89 c3                	mov    %eax,%ebx
8000254b:	83 c4 10             	add    $0x10,%esp
8000254e:	85 c0                	test   %eax,%eax
80002550:	0f 88 e2 00 00 00    	js     80002638 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002556:	83 ec 04             	sub    $0x4,%esp
80002559:	68 07 04 00 00       	push   $0x407
8000255e:	ff 75 f0             	pushl  -0x10(%ebp)
80002561:	6a 00                	push   $0x0
80002563:	e8 aa f3 ff ff       	call   80001912 <sys_page_alloc>
80002568:	89 c3                	mov    %eax,%ebx
8000256a:	83 c4 10             	add    $0x10,%esp
8000256d:	85 c0                	test   %eax,%eax
8000256f:	0f 88 c3 00 00 00    	js     80002638 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
80002575:	83 ec 0c             	sub    $0xc,%esp
80002578:	ff 75 f4             	pushl  -0xc(%ebp)
8000257b:	e8 93 f5 ff ff       	call   80001b13 <fd2data>
80002580:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002582:	83 c4 0c             	add    $0xc,%esp
80002585:	68 07 04 00 00       	push   $0x407
8000258a:	50                   	push   %eax
8000258b:	6a 00                	push   $0x0
8000258d:	e8 80 f3 ff ff       	call   80001912 <sys_page_alloc>
80002592:	89 c3                	mov    %eax,%ebx
80002594:	83 c4 10             	add    $0x10,%esp
80002597:	85 c0                	test   %eax,%eax
80002599:	0f 88 89 00 00 00    	js     80002628 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
8000259f:	83 ec 0c             	sub    $0xc,%esp
800025a2:	ff 75 f0             	pushl  -0x10(%ebp)
800025a5:	e8 69 f5 ff ff       	call   80001b13 <fd2data>
800025aa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
800025b1:	50                   	push   %eax
800025b2:	6a 00                	push   $0x0
800025b4:	56                   	push   %esi
800025b5:	6a 00                	push   $0x0
800025b7:	e8 99 f3 ff ff       	call   80001955 <sys_page_map>
800025bc:	89 c3                	mov    %eax,%ebx
800025be:	83 c4 20             	add    $0x20,%esp
800025c1:	85 c0                	test   %eax,%eax
800025c3:	78 55                	js     8000261a <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
800025c5:	8b 15 20 40 00 80    	mov    0x80004020,%edx
800025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
800025ce:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
800025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
800025d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
800025da:	8b 15 20 40 00 80    	mov    0x80004020,%edx
800025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
800025e3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
800025e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
800025e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
800025ef:	83 ec 0c             	sub    $0xc,%esp
800025f2:	ff 75 f4             	pushl  -0xc(%ebp)
800025f5:	e8 09 f5 ff ff       	call   80001b03 <fd2num>
800025fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
800025fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
800025ff:	83 c4 04             	add    $0x4,%esp
80002602:	ff 75 f0             	pushl  -0x10(%ebp)
80002605:	e8 f9 f4 ff ff       	call   80001b03 <fd2num>
8000260a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8000260d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
80002610:	83 c4 10             	add    $0x10,%esp
80002613:	ba 00 00 00 00       	mov    $0x0,%edx
80002618:	eb 30                	jmp    8000264a <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
8000261a:	83 ec 08             	sub    $0x8,%esp
8000261d:	56                   	push   %esi
8000261e:	6a 00                	push   $0x0
80002620:	e8 72 f3 ff ff       	call   80001997 <sys_page_unmap>
80002625:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
80002628:	83 ec 08             	sub    $0x8,%esp
8000262b:	ff 75 f0             	pushl  -0x10(%ebp)
8000262e:	6a 00                	push   $0x0
80002630:	e8 62 f3 ff ff       	call   80001997 <sys_page_unmap>
80002635:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
80002638:	83 ec 08             	sub    $0x8,%esp
8000263b:	ff 75 f4             	pushl  -0xc(%ebp)
8000263e:	6a 00                	push   $0x0
80002640:	e8 52 f3 ff ff       	call   80001997 <sys_page_unmap>
80002645:	83 c4 10             	add    $0x10,%esp
80002648:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
8000264a:	89 d0                	mov    %edx,%eax
8000264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000264f:	5b                   	pop    %ebx
80002650:	5e                   	pop    %esi
80002651:	5d                   	pop    %ebp
80002652:	c3                   	ret    

80002653 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
80002653:	55                   	push   %ebp
80002654:	89 e5                	mov    %esp,%ebp
80002656:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80002659:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000265c:	50                   	push   %eax
8000265d:	ff 75 08             	pushl  0x8(%ebp)
80002660:	e8 3a f5 ff ff       	call   80001b9f <fd_lookup>
80002665:	83 c4 10             	add    $0x10,%esp
80002668:	85 c0                	test   %eax,%eax
8000266a:	78 18                	js     80002684 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
8000266c:	83 ec 0c             	sub    $0xc,%esp
8000266f:	ff 75 f4             	pushl  -0xc(%ebp)
80002672:	e8 9c f4 ff ff       	call   80001b13 <fd2data>
	return _pipeisclosed(fd, p);
80002677:	89 c2                	mov    %eax,%edx
80002679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000267c:	e8 fe fc ff ff       	call   8000237f <_pipeisclosed>
80002681:	83 c4 10             	add    $0x10,%esp
}
80002684:	c9                   	leave  
80002685:	c3                   	ret    

80002686 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
80002686:	55                   	push   %ebp
80002687:	89 e5                	mov    %esp,%ebp
80002689:	56                   	push   %esi
8000268a:	53                   	push   %ebx
8000268b:	8b 75 08             	mov    0x8(%ebp),%esi
8000268e:	8b 45 0c             	mov    0xc(%ebp),%eax
80002691:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int r;
	if(!pg)
80002694:	85 c0                	test   %eax,%eax
		pg = (void *)-1;	// all 1
80002696:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8000269b:	0f 44 c2             	cmove  %edx,%eax
	if((r = sys_ipc_recv(pg)) < 0)
8000269e:	83 ec 0c             	sub    $0xc,%esp
800026a1:	50                   	push   %eax
800026a2:	e8 1b f4 ff ff       	call   80001ac2 <sys_ipc_recv>
800026a7:	83 c4 10             	add    $0x10,%esp
800026aa:	85 c0                	test   %eax,%eax
800026ac:	79 10                	jns    800026be <ipc_recv+0x38>
	{
		if(from_env_store)
800026ae:	85 f6                	test   %esi,%esi
800026b0:	74 40                	je     800026f2 <ipc_recv+0x6c>
			*from_env_store = 0;
800026b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
800026b8:	85 db                	test   %ebx,%ebx
800026ba:	74 20                	je     800026dc <ipc_recv+0x56>
800026bc:	eb 24                	jmp    800026e2 <ipc_recv+0x5c>
			*perm_store = 0;
	}
	if(from_env_store)
800026be:	85 f6                	test   %esi,%esi
800026c0:	74 0a                	je     800026cc <ipc_recv+0x46>
		*from_env_store = thisenv->env_ipc_from;
800026c2:	a1 c0 58 00 80       	mov    0x800058c0,%eax
800026c7:	8b 40 74             	mov    0x74(%eax),%eax
800026ca:	89 06                	mov    %eax,(%esi)
	if(perm_store)
800026cc:	85 db                	test   %ebx,%ebx
800026ce:	74 28                	je     800026f8 <ipc_recv+0x72>
		*perm_store = thisenv->env_ipc_perm;
800026d0:	a1 c0 58 00 80       	mov    0x800058c0,%eax
800026d5:	8b 40 78             	mov    0x78(%eax),%eax
800026d8:	89 03                	mov    %eax,(%ebx)
800026da:	eb 1c                	jmp    800026f8 <ipc_recv+0x72>
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
	}
	if(from_env_store)
800026dc:	85 f6                	test   %esi,%esi
800026de:	75 e2                	jne    800026c2 <ipc_recv+0x3c>
800026e0:	eb 16                	jmp    800026f8 <ipc_recv+0x72>
	if((r = sys_ipc_recv(pg)) < 0)
	{
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
800026e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
800026e8:	eb d8                	jmp    800026c2 <ipc_recv+0x3c>
800026ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
800026f0:	eb de                	jmp    800026d0 <ipc_recv+0x4a>
		pg = (void *)-1;	// all 1
	if((r = sys_ipc_recv(pg)) < 0)
	{
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
800026f2:	85 db                	test   %ebx,%ebx
800026f4:	75 f4                	jne    800026ea <ipc_recv+0x64>
800026f6:	eb e4                	jmp    800026dc <ipc_recv+0x56>
	}
	if(from_env_store)
		*from_env_store = thisenv->env_ipc_from;
	if(perm_store)
		*perm_store = thisenv->env_ipc_perm;
	return thisenv->env_ipc_value;
800026f8:	a1 c0 58 00 80       	mov    0x800058c0,%eax
800026fd:	8b 40 70             	mov    0x70(%eax),%eax
}
80002700:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002703:	5b                   	pop    %ebx
80002704:	5e                   	pop    %esi
80002705:	5d                   	pop    %ebp
80002706:	c3                   	ret    

80002707 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
80002707:	55                   	push   %ebp
80002708:	89 e5                	mov    %esp,%ebp
8000270a:	57                   	push   %edi
8000270b:	56                   	push   %esi
8000270c:	53                   	push   %ebx
8000270d:	83 ec 0c             	sub    $0xc,%esp
80002710:	8b 7d 08             	mov    0x8(%ebp),%edi
80002713:	8b 75 0c             	mov    0xc(%ebp),%esi
80002716:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	int r;
	if(!pg)
80002719:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;	// all 1
8000271b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80002720:	0f 44 d8             	cmove  %eax,%ebx
80002723:	eb 1c                	jmp    80002741 <ipc_send+0x3a>
	while((r = sys_ipc_try_send(to_env, val, pg, perm)))
	{
		if(r == 0)
			break;
		if(r != -E_IPC_NOT_RECV)
80002725:	83 f8 f9             	cmp    $0xfffffff9,%eax
80002728:	74 12                	je     8000273c <ipc_send+0x35>
			panic("ipc_send : %e", r);
8000272a:	50                   	push   %eax
8000272b:	68 75 34 00 80       	push   $0x80003475
80002730:	6a 41                	push   $0x41
80002732:	68 83 34 00 80       	push   $0x80003483
80002737:	e8 03 0a 00 00       	call   8000313f <_panic>
		sys_yield();
8000273c:	e8 b2 f1 ff ff       	call   800018f3 <sys_yield>
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	int r;
	if(!pg)
		pg = (void *)-1;	// all 1
	while((r = sys_ipc_try_send(to_env, val, pg, perm)))
80002741:	ff 75 14             	pushl  0x14(%ebp)
80002744:	53                   	push   %ebx
80002745:	56                   	push   %esi
80002746:	57                   	push   %edi
80002747:	e8 53 f3 ff ff       	call   80001a9f <sys_ipc_try_send>
	{
		if(r == 0)
8000274c:	83 c4 10             	add    $0x10,%esp
8000274f:	85 c0                	test   %eax,%eax
80002751:	75 d2                	jne    80002725 <ipc_send+0x1e>
			break;
		if(r != -E_IPC_NOT_RECV)
			panic("ipc_send : %e", r);
		sys_yield();
	}
}
80002753:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002756:	5b                   	pop    %ebx
80002757:	5e                   	pop    %esi
80002758:	5f                   	pop    %edi
80002759:	5d                   	pop    %ebp
8000275a:	c3                   	ret    

8000275b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
8000275b:	55                   	push   %ebp
8000275c:	89 e5                	mov    %esp,%ebp
8000275e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
80002761:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
80002766:	39 c1                	cmp    %eax,%ecx
80002768:	74 17                	je     80002781 <ipc_find_env+0x26>
8000276a:	b8 01 00 00 00       	mov    $0x1,%eax
8000276f:	6b d0 7c             	imul   $0x7c,%eax,%edx
80002772:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
80002778:	8b 52 50             	mov    0x50(%edx),%edx
8000277b:	39 ca                	cmp    %ecx,%edx
8000277d:	75 14                	jne    80002793 <ipc_find_env+0x38>
8000277f:	eb 05                	jmp    80002786 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
80002781:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
80002786:	6b c0 7c             	imul   $0x7c,%eax,%eax
80002789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
8000278e:	8b 40 48             	mov    0x48(%eax),%eax
80002791:	eb 0f                	jmp    800027a2 <ipc_find_env+0x47>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
80002793:	83 c0 01             	add    $0x1,%eax
80002796:	3d 00 04 00 00       	cmp    $0x400,%eax
8000279b:	75 d2                	jne    8000276f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
8000279d:	b8 00 00 00 00       	mov    $0x0,%eax
}
800027a2:	5d                   	pop    %ebp
800027a3:	c3                   	ret    

800027a4 <exit>:

#include <syslib.h>

void
exit(void)
{
800027a4:	55                   	push   %ebp
800027a5:	89 e5                	mov    %esp,%ebp
800027a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
800027aa:	e8 60 f5 ff ff       	call   80001d0f <close_all>
	sys_env_destroy(0);
800027af:	83 ec 0c             	sub    $0xc,%esp
800027b2:	6a 00                	push   $0x0
800027b4:	e8 da f0 ff ff       	call   80001893 <sys_env_destroy>
}
800027b9:	83 c4 10             	add    $0x10,%esp
800027bc:	c9                   	leave  
800027bd:	c3                   	ret    

800027be <pageref>:
#include <syslib.h>

int
pageref(void *v)
{
800027be:	55                   	push   %ebp
800027bf:	89 e5                	mov    %esp,%ebp
800027c1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
800027c4:	89 d0                	mov    %edx,%eax
800027c6:	c1 e8 16             	shr    $0x16,%eax
800027c9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
800027d0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
800027d5:	f6 c1 01             	test   $0x1,%cl
800027d8:	74 1d                	je     800027f7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
800027da:	c1 ea 0c             	shr    $0xc,%edx
800027dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// cprintf("pageref pte:0x%08x\n", pte);
	if (!(pte & PTE_P))
800027e4:	f6 c2 01             	test   $0x1,%dl
800027e7:	74 0e                	je     800027f7 <pageref+0x39>
		return 0;
	// cprintf("pageref 0x%08x: %d\n", v, pages[PGNUM(pte)].pp_ref);
	return pages[PGNUM(pte)].pp_ref;
800027e9:	c1 ea 0c             	shr    $0xc,%edx
800027ec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
800027f3:	ef 
800027f4:	0f b7 c0             	movzwl %ax,%eax
}
800027f7:	5d                   	pop    %ebp
800027f8:	c3                   	ret    

800027f9 <argstart>:
#include <args.h>
#include <string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
800027f9:	55                   	push   %ebp
800027fa:	89 e5                	mov    %esp,%ebp
800027fc:	8b 55 08             	mov    0x8(%ebp),%edx
800027ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002802:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
80002805:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
80002807:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
8000280a:	83 3a 01             	cmpl   $0x1,(%edx)
8000280d:	7e 09                	jle    80002818 <argstart+0x1f>
8000280f:	ba 7c 33 00 80       	mov    $0x8000337c,%edx
80002814:	85 c9                	test   %ecx,%ecx
80002816:	75 05                	jne    8000281d <argstart+0x24>
80002818:	ba 00 00 00 00       	mov    $0x0,%edx
8000281d:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
80002820:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
80002827:	5d                   	pop    %ebp
80002828:	c3                   	ret    

80002829 <argnext>:

int
argnext(struct Argstate *args)
{
80002829:	55                   	push   %ebp
8000282a:	89 e5                	mov    %esp,%ebp
8000282c:	53                   	push   %ebx
8000282d:	83 ec 04             	sub    $0x4,%esp
80002830:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
80002833:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
8000283a:	8b 43 08             	mov    0x8(%ebx),%eax
8000283d:	85 c0                	test   %eax,%eax
8000283f:	74 6f                	je     800028b0 <argnext+0x87>
		return -1;

	if (!*args->curarg) {
80002841:	80 38 00             	cmpb   $0x0,(%eax)
80002844:	75 4e                	jne    80002894 <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
80002846:	8b 0b                	mov    (%ebx),%ecx
80002848:	83 39 01             	cmpl   $0x1,(%ecx)
8000284b:	74 55                	je     800028a2 <argnext+0x79>
		    || args->argv[1][0] != '-'
8000284d:	8b 53 04             	mov    0x4(%ebx),%edx
80002850:	8b 42 04             	mov    0x4(%edx),%eax
80002853:	80 38 2d             	cmpb   $0x2d,(%eax)
80002856:	75 4a                	jne    800028a2 <argnext+0x79>
		    || args->argv[1][1] == '\0')
80002858:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
8000285c:	74 44                	je     800028a2 <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
8000285e:	83 c0 01             	add    $0x1,%eax
80002861:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
80002864:	83 ec 04             	sub    $0x4,%esp
80002867:	8b 01                	mov    (%ecx),%eax
80002869:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
80002870:	50                   	push   %eax
80002871:	8d 42 08             	lea    0x8(%edx),%eax
80002874:	50                   	push   %eax
80002875:	83 c2 04             	add    $0x4,%edx
80002878:	52                   	push   %edx
80002879:	e8 a0 ed ff ff       	call   8000161e <memmove>
		(*args->argc)--;
8000287e:	8b 03                	mov    (%ebx),%eax
80002880:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
80002883:	8b 43 08             	mov    0x8(%ebx),%eax
80002886:	83 c4 10             	add    $0x10,%esp
80002889:	80 38 2d             	cmpb   $0x2d,(%eax)
8000288c:	75 06                	jne    80002894 <argnext+0x6b>
8000288e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
80002892:	74 0e                	je     800028a2 <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
80002894:	8b 53 08             	mov    0x8(%ebx),%edx
80002897:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
8000289a:	83 c2 01             	add    $0x1,%edx
8000289d:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
800028a0:	eb 13                	jmp    800028b5 <argnext+0x8c>

    endofargs:
	args->curarg = 0;
800028a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
800028a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
800028ae:	eb 05                	jmp    800028b5 <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
800028b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
800028b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800028b8:	c9                   	leave  
800028b9:	c3                   	ret    

800028ba <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
800028ba:	55                   	push   %ebp
800028bb:	89 e5                	mov    %esp,%ebp
800028bd:	53                   	push   %ebx
800028be:	83 ec 04             	sub    $0x4,%esp
800028c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
800028c4:	8b 43 08             	mov    0x8(%ebx),%eax
800028c7:	85 c0                	test   %eax,%eax
800028c9:	74 58                	je     80002923 <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
800028cb:	80 38 00             	cmpb   $0x0,(%eax)
800028ce:	74 0c                	je     800028dc <argnextvalue+0x22>
		args->argvalue = args->curarg;
800028d0:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
800028d3:	c7 43 08 7c 33 00 80 	movl   $0x8000337c,0x8(%ebx)
800028da:	eb 42                	jmp    8000291e <argnextvalue+0x64>
	} else if (*args->argc > 1) {
800028dc:	8b 13                	mov    (%ebx),%edx
800028de:	83 3a 01             	cmpl   $0x1,(%edx)
800028e1:	7e 2d                	jle    80002910 <argnextvalue+0x56>
		args->argvalue = args->argv[1];
800028e3:	8b 43 04             	mov    0x4(%ebx),%eax
800028e6:	8b 48 04             	mov    0x4(%eax),%ecx
800028e9:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
800028ec:	83 ec 04             	sub    $0x4,%esp
800028ef:	8b 12                	mov    (%edx),%edx
800028f1:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
800028f8:	52                   	push   %edx
800028f9:	8d 50 08             	lea    0x8(%eax),%edx
800028fc:	52                   	push   %edx
800028fd:	83 c0 04             	add    $0x4,%eax
80002900:	50                   	push   %eax
80002901:	e8 18 ed ff ff       	call   8000161e <memmove>
		(*args->argc)--;
80002906:	8b 03                	mov    (%ebx),%eax
80002908:	83 28 01             	subl   $0x1,(%eax)
8000290b:	83 c4 10             	add    $0x10,%esp
8000290e:	eb 0e                	jmp    8000291e <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
80002910:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
80002917:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
8000291e:	8b 43 0c             	mov    0xc(%ebx),%eax
80002921:	eb 05                	jmp    80002928 <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
80002923:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
80002928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000292b:	c9                   	leave  
8000292c:	c3                   	ret    

8000292d <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
8000292d:	55                   	push   %ebp
8000292e:	89 e5                	mov    %esp,%ebp
80002930:	83 ec 08             	sub    $0x8,%esp
80002933:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
80002936:	8b 51 0c             	mov    0xc(%ecx),%edx
80002939:	89 d0                	mov    %edx,%eax
8000293b:	85 d2                	test   %edx,%edx
8000293d:	75 0c                	jne    8000294b <argvalue+0x1e>
8000293f:	83 ec 0c             	sub    $0xc,%esp
80002942:	51                   	push   %ecx
80002943:	e8 72 ff ff ff       	call   800028ba <argnextvalue>
80002948:	83 c4 10             	add    $0x10,%esp
}
8000294b:	c9                   	leave  
8000294c:	c3                   	ret    

8000294d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
8000294d:	55                   	push   %ebp
8000294e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
80002950:	83 fa 01             	cmp    $0x1,%edx
80002953:	7e 0e                	jle    80002963 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
80002955:	8b 10                	mov    (%eax),%edx
80002957:	8d 4a 08             	lea    0x8(%edx),%ecx
8000295a:	89 08                	mov    %ecx,(%eax)
8000295c:	8b 02                	mov    (%edx),%eax
8000295e:	8b 52 04             	mov    0x4(%edx),%edx
80002961:	eb 22                	jmp    80002985 <getuint+0x38>
	else if (lflag)
80002963:	85 d2                	test   %edx,%edx
80002965:	74 10                	je     80002977 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
80002967:	8b 10                	mov    (%eax),%edx
80002969:	8d 4a 04             	lea    0x4(%edx),%ecx
8000296c:	89 08                	mov    %ecx,(%eax)
8000296e:	8b 02                	mov    (%edx),%eax
80002970:	ba 00 00 00 00       	mov    $0x0,%edx
80002975:	eb 0e                	jmp    80002985 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
80002977:	8b 10                	mov    (%eax),%edx
80002979:	8d 4a 04             	lea    0x4(%edx),%ecx
8000297c:	89 08                	mov    %ecx,(%eax)
8000297e:	8b 02                	mov    (%edx),%eax
80002980:	ba 00 00 00 00       	mov    $0x0,%edx
}
80002985:	5d                   	pop    %ebp
80002986:	c3                   	ret    

80002987 <printnum>:
}

static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long num, unsigned base, int width, int padc)
{
80002987:	55                   	push   %ebp
80002988:	89 e5                	mov    %esp,%ebp
8000298a:	57                   	push   %edi
8000298b:	56                   	push   %esi
8000298c:	53                   	push   %ebx
8000298d:	83 ec 1c             	sub    $0x1c,%esp
80002990:	89 c7                	mov    %eax,%edi
80002992:	89 d6                	mov    %edx,%esi
80002994:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
80002997:	3b 4d 08             	cmp    0x8(%ebp),%ecx
8000299a:	73 0c                	jae    800029a8 <printnum+0x21>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
8000299c:	8b 45 0c             	mov    0xc(%ebp),%eax
8000299f:	8d 58 ff             	lea    -0x1(%eax),%ebx
800029a2:	85 db                	test   %ebx,%ebx
800029a4:	7f 2d                	jg     800029d3 <printnum+0x4c>
800029a6:	eb 3c                	jmp    800029e4 <printnum+0x5d>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
800029a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
800029ab:	ba 00 00 00 00       	mov    $0x0,%edx
800029b0:	f7 75 08             	divl   0x8(%ebp)
800029b3:	89 c1                	mov    %eax,%ecx
800029b5:	83 ec 04             	sub    $0x4,%esp
800029b8:	ff 75 10             	pushl  0x10(%ebp)
800029bb:	8b 45 0c             	mov    0xc(%ebp),%eax
800029be:	8d 50 ff             	lea    -0x1(%eax),%edx
800029c1:	52                   	push   %edx
800029c2:	ff 75 08             	pushl  0x8(%ebp)
800029c5:	89 f2                	mov    %esi,%edx
800029c7:	89 f8                	mov    %edi,%eax
800029c9:	e8 b9 ff ff ff       	call   80002987 <printnum>
800029ce:	83 c4 10             	add    $0x10,%esp
800029d1:	eb 11                	jmp    800029e4 <printnum+0x5d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
800029d3:	83 ec 08             	sub    $0x8,%esp
800029d6:	56                   	push   %esi
800029d7:	ff 75 10             	pushl  0x10(%ebp)
800029da:	ff d7                	call   *%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
800029dc:	83 c4 10             	add    $0x10,%esp
800029df:	83 eb 01             	sub    $0x1,%ebx
800029e2:	75 ef                	jne    800029d3 <printnum+0x4c>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
800029e4:	83 ec 08             	sub    $0x8,%esp
800029e7:	56                   	push   %esi
800029e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
800029eb:	ba 00 00 00 00       	mov    $0x0,%edx
800029f0:	f7 75 08             	divl   0x8(%ebp)
800029f3:	0f be 82 89 34 00 80 	movsbl -0x7fffcb77(%edx),%eax
800029fa:	50                   	push   %eax
800029fb:	ff d7                	call   *%edi
}
800029fd:	83 c4 10             	add    $0x10,%esp
80002a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002a03:	5b                   	pop    %ebx
80002a04:	5e                   	pop    %esi
80002a05:	5f                   	pop    %edi
80002a06:	5d                   	pop    %ebp
80002a07:	c3                   	ret    

80002a08 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
80002a08:	55                   	push   %ebp
80002a09:	89 e5                	mov    %esp,%ebp
80002a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
80002a0e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
80002a12:	8b 10                	mov    (%eax),%edx
80002a14:	3b 50 04             	cmp    0x4(%eax),%edx
80002a17:	73 0a                	jae    80002a23 <sprintputch+0x1b>
		*b->buf++ = ch;
80002a19:	8d 4a 01             	lea    0x1(%edx),%ecx
80002a1c:	89 08                	mov    %ecx,(%eax)
80002a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80002a21:	88 02                	mov    %al,(%edx)
}
80002a23:	5d                   	pop    %ebp
80002a24:	c3                   	ret    

80002a25 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
80002a25:	55                   	push   %ebp
80002a26:	89 e5                	mov    %esp,%ebp
80002a28:	53                   	push   %ebx
80002a29:	83 ec 04             	sub    $0x4,%esp
80002a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
80002a2f:	8b 13                	mov    (%ebx),%edx
80002a31:	8d 42 01             	lea    0x1(%edx),%eax
80002a34:	89 03                	mov    %eax,(%ebx)
80002a36:	8b 4d 08             	mov    0x8(%ebp),%ecx
80002a39:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
80002a3d:	3d ff 00 00 00       	cmp    $0xff,%eax
80002a42:	75 1a                	jne    80002a5e <putch+0x39>
		sys_cputs(b->buf, b->idx);
80002a44:	83 ec 08             	sub    $0x8,%esp
80002a47:	68 ff 00 00 00       	push   $0xff
80002a4c:	8d 43 08             	lea    0x8(%ebx),%eax
80002a4f:	50                   	push   %eax
80002a50:	e8 01 ee ff ff       	call   80001856 <sys_cputs>
		b->idx = 0;
80002a55:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80002a5b:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
80002a5e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
80002a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002a65:	c9                   	leave  
80002a66:	c3                   	ret    

80002a67 <writebuf>:


static void
writebuf(struct fprintbuf *b)
{
	if (b->error > 0) {
80002a67:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
80002a6b:	7e 37                	jle    80002aa4 <writebuf+0x3d>
};


static void
writebuf(struct fprintbuf *b)
{
80002a6d:	55                   	push   %ebp
80002a6e:	89 e5                	mov    %esp,%ebp
80002a70:	53                   	push   %ebx
80002a71:	83 ec 08             	sub    $0x8,%esp
80002a74:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
80002a76:	ff 70 04             	pushl  0x4(%eax)
80002a79:	8d 40 10             	lea    0x10(%eax),%eax
80002a7c:	50                   	push   %eax
80002a7d:	ff 33                	pushl  (%ebx)
80002a7f:	e8 80 f4 ff ff       	call   80001f04 <write>
		if (result > 0)
80002a84:	83 c4 10             	add    $0x10,%esp
80002a87:	85 c0                	test   %eax,%eax
80002a89:	7e 03                	jle    80002a8e <writebuf+0x27>
			b->result += result;
80002a8b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
80002a8e:	3b 43 04             	cmp    0x4(%ebx),%eax
80002a91:	74 0d                	je     80002aa0 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
80002a93:	85 c0                	test   %eax,%eax
80002a95:	ba 00 00 00 00       	mov    $0x0,%edx
80002a9a:	0f 4f c2             	cmovg  %edx,%eax
80002a9d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
80002aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002aa3:	c9                   	leave  
80002aa4:	f3 c3                	repz ret 

80002aa6 <fputch>:

static void
fputch(int ch, void *thunk)
{
80002aa6:	55                   	push   %ebp
80002aa7:	89 e5                	mov    %esp,%ebp
80002aa9:	53                   	push   %ebx
80002aaa:	83 ec 04             	sub    $0x4,%esp
80002aad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct fprintbuf *b = (struct fprintbuf *) thunk;
	b->buf[b->idx++] = ch;
80002ab0:	8b 53 04             	mov    0x4(%ebx),%edx
80002ab3:	8d 42 01             	lea    0x1(%edx),%eax
80002ab6:	89 43 04             	mov    %eax,0x4(%ebx)
80002ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80002abc:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
80002ac0:	3d 00 01 00 00       	cmp    $0x100,%eax
80002ac5:	75 0e                	jne    80002ad5 <fputch+0x2f>
		writebuf(b);
80002ac7:	89 d8                	mov    %ebx,%eax
80002ac9:	e8 99 ff ff ff       	call   80002a67 <writebuf>
		b->idx = 0;
80002ace:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
80002ad5:	83 c4 04             	add    $0x4,%esp
80002ad8:	5b                   	pop    %ebx
80002ad9:	5d                   	pop    %ebp
80002ada:	c3                   	ret    

80002adb <vprintfmt>:
	va_end(ap);
}

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
80002adb:	55                   	push   %ebp
80002adc:	89 e5                	mov    %esp,%ebp
80002ade:	57                   	push   %edi
80002adf:	56                   	push   %esi
80002ae0:	53                   	push   %ebx
80002ae1:	83 ec 2c             	sub    $0x2c,%esp
80002ae4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80002ae7:	eb 03                	jmp    80002aec <vprintfmt+0x11>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
80002ae9:	89 75 10             	mov    %esi,0x10(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
80002aec:	8b 45 10             	mov    0x10(%ebp),%eax
80002aef:	8d 70 01             	lea    0x1(%eax),%esi
80002af2:	0f b6 00             	movzbl (%eax),%eax
80002af5:	83 f8 25             	cmp    $0x25,%eax
80002af8:	74 2c                	je     80002b26 <vprintfmt+0x4b>
			if (ch == '\0')
80002afa:	85 c0                	test   %eax,%eax
80002afc:	75 0f                	jne    80002b0d <vprintfmt+0x32>
80002afe:	e9 bb 03 00 00       	jmp    80002ebe <vprintfmt+0x3e3>
80002b03:	85 c0                	test   %eax,%eax
80002b05:	0f 84 b3 03 00 00    	je     80002ebe <vprintfmt+0x3e3>
80002b0b:	eb 03                	jmp    80002b10 <vprintfmt+0x35>
80002b0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
				return;
			putch(ch, putdat);
80002b10:	83 ec 08             	sub    $0x8,%esp
80002b13:	57                   	push   %edi
80002b14:	50                   	push   %eax
80002b15:	ff d3                	call   *%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
80002b17:	83 c6 01             	add    $0x1,%esi
80002b1a:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80002b1e:	83 c4 10             	add    $0x10,%esp
80002b21:	83 f8 25             	cmp    $0x25,%eax
80002b24:	75 dd                	jne    80002b03 <vprintfmt+0x28>
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
80002b26:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
80002b2a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80002b31:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80002b38:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80002b3f:	ba 00 00 00 00       	mov    $0x0,%edx
80002b44:	bb 00 00 00 00       	mov    $0x0,%ebx
80002b49:	eb 07                	jmp    80002b52 <vprintfmt+0x77>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002b4b:	8b 75 10             	mov    0x10(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
80002b4e:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002b52:	8d 46 01             	lea    0x1(%esi),%eax
80002b55:	89 45 10             	mov    %eax,0x10(%ebp)
80002b58:	0f b6 06             	movzbl (%esi),%eax
80002b5b:	0f b6 c8             	movzbl %al,%ecx
80002b5e:	83 e8 23             	sub    $0x23,%eax
80002b61:	3c 55                	cmp    $0x55,%al
80002b63:	0f 87 15 03 00 00    	ja     80002e7e <vprintfmt+0x3a3>
80002b69:	0f b6 c0             	movzbl %al,%eax
80002b6c:	ff 24 85 00 36 00 80 	jmp    *-0x7fffca00(,%eax,4)
80002b73:	8b 75 10             	mov    0x10(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
80002b76:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
80002b7a:	eb d6                	jmp    80002b52 <vprintfmt+0x77>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
80002b7c:	8d 41 d0             	lea    -0x30(%ecx),%eax
80002b7f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
80002b82:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
80002b86:	8d 48 d0             	lea    -0x30(%eax),%ecx
80002b89:	83 f9 09             	cmp    $0x9,%ecx
80002b8c:	77 5b                	ja     80002be9 <vprintfmt+0x10e>
80002b8e:	8b 75 10             	mov    0x10(%ebp),%esi
80002b91:	89 55 d0             	mov    %edx,-0x30(%ebp)
80002b94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
80002b97:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
80002b9a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80002b9d:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
				ch = *fmt;
80002ba1:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
80002ba4:	8d 48 d0             	lea    -0x30(%eax),%ecx
80002ba7:	83 f9 09             	cmp    $0x9,%ecx
80002baa:	76 eb                	jbe    80002b97 <vprintfmt+0xbc>
80002bac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80002baf:	8b 55 d0             	mov    -0x30(%ebp),%edx
80002bb2:	eb 38                	jmp    80002bec <vprintfmt+0x111>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
80002bb4:	8b 45 14             	mov    0x14(%ebp),%eax
80002bb7:	8d 48 04             	lea    0x4(%eax),%ecx
80002bba:	89 4d 14             	mov    %ecx,0x14(%ebp)
80002bbd:	8b 00                	mov    (%eax),%eax
80002bbf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002bc2:	8b 75 10             	mov    0x10(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
80002bc5:	eb 25                	jmp    80002bec <vprintfmt+0x111>
80002bc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80002bca:	85 c0                	test   %eax,%eax
80002bcc:	0f 48 c3             	cmovs  %ebx,%eax
80002bcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002bd2:	8b 75 10             	mov    0x10(%ebp),%esi
80002bd5:	e9 78 ff ff ff       	jmp    80002b52 <vprintfmt+0x77>
80002bda:	8b 75 10             	mov    0x10(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
80002bdd:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
80002be4:	e9 69 ff ff ff       	jmp    80002b52 <vprintfmt+0x77>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002be9:	8b 75 10             	mov    0x10(%ebp),%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
80002bec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80002bf0:	0f 89 5c ff ff ff    	jns    80002b52 <vprintfmt+0x77>
				width = precision, precision = -1;
80002bf6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80002bf9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80002bfc:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80002c03:	e9 4a ff ff ff       	jmp    80002b52 <vprintfmt+0x77>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
80002c08:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80002c0b:	8b 75 10             	mov    0x10(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
80002c0e:	e9 3f ff ff ff       	jmp    80002b52 <vprintfmt+0x77>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
80002c13:	8b 45 14             	mov    0x14(%ebp),%eax
80002c16:	8d 50 04             	lea    0x4(%eax),%edx
80002c19:	89 55 14             	mov    %edx,0x14(%ebp)
80002c1c:	83 ec 08             	sub    $0x8,%esp
80002c1f:	57                   	push   %edi
80002c20:	ff 30                	pushl  (%eax)
80002c22:	ff 55 08             	call   *0x8(%ebp)
			break;
80002c25:	83 c4 10             	add    $0x10,%esp
80002c28:	e9 bf fe ff ff       	jmp    80002aec <vprintfmt+0x11>

		// error message
		case 'e':
			err = va_arg(ap, int);
80002c2d:	8b 45 14             	mov    0x14(%ebp),%eax
80002c30:	8d 50 04             	lea    0x4(%eax),%edx
80002c33:	89 55 14             	mov    %edx,0x14(%ebp)
80002c36:	8b 00                	mov    (%eax),%eax
80002c38:	99                   	cltd   
80002c39:	31 d0                	xor    %edx,%eax
80002c3b:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
80002c3d:	83 f8 11             	cmp    $0x11,%eax
80002c40:	7f 0b                	jg     80002c4d <vprintfmt+0x172>
80002c42:	8b 14 85 60 37 00 80 	mov    -0x7fffc8a0(,%eax,4),%edx
80002c49:	85 d2                	test   %edx,%edx
80002c4b:	75 17                	jne    80002c64 <vprintfmt+0x189>
				printfmt(putch, putdat, "error %d", err);
80002c4d:	50                   	push   %eax
80002c4e:	68 a1 34 00 80       	push   $0x800034a1
80002c53:	57                   	push   %edi
80002c54:	ff 75 08             	pushl  0x8(%ebp)
80002c57:	e8 6b 03 00 00       	call   80002fc7 <printfmt>
80002c5c:	83 c4 10             	add    $0x10,%esp
80002c5f:	e9 88 fe ff ff       	jmp    80002aec <vprintfmt+0x11>
			else
				printfmt(putch, putdat, "%s", p);
80002c64:	52                   	push   %edx
80002c65:	68 65 33 00 80       	push   $0x80003365
80002c6a:	57                   	push   %edi
80002c6b:	ff 75 08             	pushl  0x8(%ebp)
80002c6e:	e8 54 03 00 00       	call   80002fc7 <printfmt>
80002c73:	83 c4 10             	add    $0x10,%esp
80002c76:	e9 71 fe ff ff       	jmp    80002aec <vprintfmt+0x11>
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
80002c7b:	8b 45 14             	mov    0x14(%ebp),%eax
80002c7e:	8d 50 04             	lea    0x4(%eax),%edx
80002c81:	89 55 14             	mov    %edx,0x14(%ebp)
80002c84:	8b 00                	mov    (%eax),%eax
				p = "(null)";
80002c86:	85 c0                	test   %eax,%eax
80002c88:	b9 9a 34 00 80       	mov    $0x8000349a,%ecx
80002c8d:	0f 45 c8             	cmovne %eax,%ecx
80002c90:	89 4d d0             	mov    %ecx,-0x30(%ebp)
			if (width > 0 && padc != '-')
80002c93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80002c97:	7e 06                	jle    80002c9f <vprintfmt+0x1c4>
80002c99:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
80002c9d:	75 19                	jne    80002cb8 <vprintfmt+0x1dd>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80002c9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80002ca2:	8d 70 01             	lea    0x1(%eax),%esi
80002ca5:	0f b6 00             	movzbl (%eax),%eax
80002ca8:	0f be d0             	movsbl %al,%edx
80002cab:	85 d2                	test   %edx,%edx
80002cad:	0f 85 92 00 00 00    	jne    80002d45 <vprintfmt+0x26a>
80002cb3:	e9 82 00 00 00       	jmp    80002d3a <vprintfmt+0x25f>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
80002cb8:	83 ec 08             	sub    $0x8,%esp
80002cbb:	ff 75 d4             	pushl  -0x2c(%ebp)
80002cbe:	ff 75 d0             	pushl  -0x30(%ebp)
80002cc1:	e8 30 e7 ff ff       	call   800013f6 <strnlen>
80002cc6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
80002cc9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80002ccc:	83 c4 10             	add    $0x10,%esp
80002ccf:	85 c9                	test   %ecx,%ecx
80002cd1:	0f 8e ce 01 00 00    	jle    80002ea5 <vprintfmt+0x3ca>
					putch(padc, putdat);
80002cd7:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
80002cdb:	89 cb                	mov    %ecx,%ebx
80002cdd:	83 ec 08             	sub    $0x8,%esp
80002ce0:	57                   	push   %edi
80002ce1:	56                   	push   %esi
80002ce2:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
80002ce5:	83 c4 10             	add    $0x10,%esp
80002ce8:	83 eb 01             	sub    $0x1,%ebx
80002ceb:	75 f0                	jne    80002cdd <vprintfmt+0x202>
80002ced:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80002cf0:	e9 b0 01 00 00       	jmp    80002ea5 <vprintfmt+0x3ca>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
80002cf5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80002cf9:	74 1b                	je     80002d16 <vprintfmt+0x23b>
80002cfb:	0f be c0             	movsbl %al,%eax
80002cfe:	83 e8 20             	sub    $0x20,%eax
80002d01:	83 f8 5e             	cmp    $0x5e,%eax
80002d04:	76 10                	jbe    80002d16 <vprintfmt+0x23b>
					putch('?', putdat);
80002d06:	83 ec 08             	sub    $0x8,%esp
80002d09:	ff 75 0c             	pushl  0xc(%ebp)
80002d0c:	6a 3f                	push   $0x3f
80002d0e:	ff 55 08             	call   *0x8(%ebp)
80002d11:	83 c4 10             	add    $0x10,%esp
80002d14:	eb 0d                	jmp    80002d23 <vprintfmt+0x248>
				else
					putch(ch, putdat);
80002d16:	83 ec 08             	sub    $0x8,%esp
80002d19:	ff 75 0c             	pushl  0xc(%ebp)
80002d1c:	52                   	push   %edx
80002d1d:	ff 55 08             	call   *0x8(%ebp)
80002d20:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80002d23:	83 ef 01             	sub    $0x1,%edi
80002d26:	83 c6 01             	add    $0x1,%esi
80002d29:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80002d2d:	0f be d0             	movsbl %al,%edx
80002d30:	85 d2                	test   %edx,%edx
80002d32:	75 25                	jne    80002d59 <vprintfmt+0x27e>
80002d34:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80002d37:	8b 7d 0c             	mov    0xc(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
80002d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80002d3e:	7f 2a                	jg     80002d6a <vprintfmt+0x28f>
80002d40:	e9 a7 fd ff ff       	jmp    80002aec <vprintfmt+0x11>
80002d45:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80002d48:	89 7d 0c             	mov    %edi,0xc(%ebp)
80002d4b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80002d4e:	eb 09                	jmp    80002d59 <vprintfmt+0x27e>
80002d50:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80002d53:	89 7d 0c             	mov    %edi,0xc(%ebp)
80002d56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80002d59:	85 db                	test   %ebx,%ebx
80002d5b:	78 98                	js     80002cf5 <vprintfmt+0x21a>
80002d5d:	83 eb 01             	sub    $0x1,%ebx
80002d60:	79 93                	jns    80002cf5 <vprintfmt+0x21a>
80002d62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80002d65:	8b 7d 0c             	mov    0xc(%ebp),%edi
80002d68:	eb d0                	jmp    80002d3a <vprintfmt+0x25f>
80002d6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80002d6d:	8b 75 08             	mov    0x8(%ebp),%esi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
80002d70:	83 ec 08             	sub    $0x8,%esp
80002d73:	57                   	push   %edi
80002d74:	6a 20                	push   $0x20
80002d76:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
80002d78:	83 c4 10             	add    $0x10,%esp
80002d7b:	83 eb 01             	sub    $0x1,%ebx
80002d7e:	75 f0                	jne    80002d70 <vprintfmt+0x295>
80002d80:	e9 67 fd ff ff       	jmp    80002aec <vprintfmt+0x11>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
80002d85:	83 fa 01             	cmp    $0x1,%edx
80002d88:	7e 16                	jle    80002da0 <vprintfmt+0x2c5>
		return va_arg(*ap, long long);
80002d8a:	8b 45 14             	mov    0x14(%ebp),%eax
80002d8d:	8d 50 08             	lea    0x8(%eax),%edx
80002d90:	89 55 14             	mov    %edx,0x14(%ebp)
80002d93:	8b 50 04             	mov    0x4(%eax),%edx
80002d96:	8b 00                	mov    (%eax),%eax
80002d98:	89 45 d8             	mov    %eax,-0x28(%ebp)
80002d9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80002d9e:	eb 32                	jmp    80002dd2 <vprintfmt+0x2f7>
	else if (lflag)
80002da0:	85 d2                	test   %edx,%edx
80002da2:	74 18                	je     80002dbc <vprintfmt+0x2e1>
		return va_arg(*ap, long);
80002da4:	8b 45 14             	mov    0x14(%ebp),%eax
80002da7:	8d 50 04             	lea    0x4(%eax),%edx
80002daa:	89 55 14             	mov    %edx,0x14(%ebp)
80002dad:	8b 30                	mov    (%eax),%esi
80002daf:	89 75 d8             	mov    %esi,-0x28(%ebp)
80002db2:	89 f0                	mov    %esi,%eax
80002db4:	c1 f8 1f             	sar    $0x1f,%eax
80002db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80002dba:	eb 16                	jmp    80002dd2 <vprintfmt+0x2f7>
	else
		return va_arg(*ap, int);
80002dbc:	8b 45 14             	mov    0x14(%ebp),%eax
80002dbf:	8d 50 04             	lea    0x4(%eax),%edx
80002dc2:	89 55 14             	mov    %edx,0x14(%ebp)
80002dc5:	8b 30                	mov    (%eax),%esi
80002dc7:	89 75 d8             	mov    %esi,-0x28(%ebp)
80002dca:	89 f0                	mov    %esi,%eax
80002dcc:	c1 f8 1f             	sar    $0x1f,%eax
80002dcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
80002dd2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
80002dd5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
80002dda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80002dde:	79 70                	jns    80002e50 <vprintfmt+0x375>
				putch('-', putdat);
80002de0:	83 ec 08             	sub    $0x8,%esp
80002de3:	57                   	push   %edi
80002de4:	6a 2d                	push   $0x2d
80002de6:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
80002de9:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80002dec:	f7 d9                	neg    %ecx
80002dee:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
80002df1:	b8 0a 00 00 00       	mov    $0xa,%eax
80002df6:	eb 58                	jmp    80002e50 <vprintfmt+0x375>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
80002df8:	8d 45 14             	lea    0x14(%ebp),%eax
80002dfb:	e8 4d fb ff ff       	call   8000294d <getuint>
80002e00:	89 c1                	mov    %eax,%ecx
			base = 10;
80002e02:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
80002e07:	eb 47                	jmp    80002e50 <vprintfmt+0x375>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
80002e09:	8d 45 14             	lea    0x14(%ebp),%eax
80002e0c:	e8 3c fb ff ff       	call   8000294d <getuint>
80002e11:	89 c1                	mov    %eax,%ecx
			base = 8;
80002e13:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
80002e18:	eb 36                	jmp    80002e50 <vprintfmt+0x375>

		// pointer
		case 'p':
			putch('0', putdat);
80002e1a:	83 ec 08             	sub    $0x8,%esp
80002e1d:	57                   	push   %edi
80002e1e:	6a 30                	push   $0x30
80002e20:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
80002e23:	83 c4 08             	add    $0x8,%esp
80002e26:	57                   	push   %edi
80002e27:	6a 78                	push   $0x78
80002e29:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
80002e2c:	8b 45 14             	mov    0x14(%ebp),%eax
80002e2f:	8d 50 04             	lea    0x4(%eax),%edx
80002e32:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
80002e35:	8b 08                	mov    (%eax),%ecx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
80002e37:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
80002e3a:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
80002e3f:	eb 0f                	jmp    80002e50 <vprintfmt+0x375>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
80002e41:	8d 45 14             	lea    0x14(%ebp),%eax
80002e44:	e8 04 fb ff ff       	call   8000294d <getuint>
80002e49:	89 c1                	mov    %eax,%ecx
			base = 16;
80002e4b:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
80002e50:	83 ec 04             	sub    $0x4,%esp
80002e53:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
80002e57:	56                   	push   %esi
80002e58:	ff 75 e4             	pushl  -0x1c(%ebp)
80002e5b:	50                   	push   %eax
80002e5c:	89 fa                	mov    %edi,%edx
80002e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80002e61:	e8 21 fb ff ff       	call   80002987 <printnum>
			break;
80002e66:	83 c4 10             	add    $0x10,%esp
80002e69:	e9 7e fc ff ff       	jmp    80002aec <vprintfmt+0x11>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
80002e6e:	83 ec 08             	sub    $0x8,%esp
80002e71:	57                   	push   %edi
80002e72:	51                   	push   %ecx
80002e73:	ff 55 08             	call   *0x8(%ebp)
			break;
80002e76:	83 c4 10             	add    $0x10,%esp
80002e79:	e9 6e fc ff ff       	jmp    80002aec <vprintfmt+0x11>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
80002e7e:	83 ec 08             	sub    $0x8,%esp
80002e81:	57                   	push   %edi
80002e82:	6a 25                	push   $0x25
80002e84:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
80002e87:	83 c4 10             	add    $0x10,%esp
80002e8a:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
80002e8e:	0f 84 55 fc ff ff    	je     80002ae9 <vprintfmt+0xe>
80002e94:	83 ee 01             	sub    $0x1,%esi
80002e97:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
80002e9b:	75 f7                	jne    80002e94 <vprintfmt+0x3b9>
80002e9d:	89 75 10             	mov    %esi,0x10(%ebp)
80002ea0:	e9 47 fc ff ff       	jmp    80002aec <vprintfmt+0x11>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80002ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80002ea8:	8d 70 01             	lea    0x1(%eax),%esi
80002eab:	0f b6 00             	movzbl (%eax),%eax
80002eae:	0f be d0             	movsbl %al,%edx
80002eb1:	85 d2                	test   %edx,%edx
80002eb3:	0f 85 97 fe ff ff    	jne    80002d50 <vprintfmt+0x275>
80002eb9:	e9 2e fc ff ff       	jmp    80002aec <vprintfmt+0x11>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
80002ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002ec1:	5b                   	pop    %ebx
80002ec2:	5e                   	pop    %esi
80002ec3:	5f                   	pop    %edi
80002ec4:	5d                   	pop    %ebp
80002ec5:	c3                   	ret    

80002ec6 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
80002ec6:	55                   	push   %ebp
80002ec7:	89 e5                	mov    %esp,%ebp
80002ec9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
80002ecf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80002ed6:	00 00 00 
	b.cnt = 0;
80002ed9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80002ee0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
80002ee3:	ff 75 0c             	pushl  0xc(%ebp)
80002ee6:	ff 75 08             	pushl  0x8(%ebp)
80002ee9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
80002eef:	50                   	push   %eax
80002ef0:	68 25 2a 00 80       	push   $0x80002a25
80002ef5:	e8 e1 fb ff ff       	call   80002adb <vprintfmt>
	sys_cputs(b.buf, b.idx);
80002efa:	83 c4 08             	add    $0x8,%esp
80002efd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80002f03:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
80002f09:	50                   	push   %eax
80002f0a:	e8 47 e9 ff ff       	call   80001856 <sys_cputs>

	return b.cnt;
}
80002f0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80002f15:	c9                   	leave  
80002f16:	c3                   	ret    

80002f17 <cprintf>:

int
cprintf(const char *fmt, ...)
{
80002f17:	55                   	push   %ebp
80002f18:	89 e5                	mov    %esp,%ebp
80002f1a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80002f1d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
80002f20:	50                   	push   %eax
80002f21:	ff 75 08             	pushl  0x8(%ebp)
80002f24:	e8 9d ff ff ff       	call   80002ec6 <vcprintf>
	va_end(ap);

	return cnt;
}
80002f29:	c9                   	leave  
80002f2a:	c3                   	ret    

80002f2b <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
80002f2b:	55                   	push   %ebp
80002f2c:	89 e5                	mov    %esp,%ebp
80002f2e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct fprintbuf b;

	b.fd = fd;
80002f34:	8b 45 08             	mov    0x8(%ebp),%eax
80002f37:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
80002f3d:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80002f44:	00 00 00 
	b.result = 0;
80002f47:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80002f4e:	00 00 00 
	b.error = 1;
80002f51:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
80002f58:	00 00 00 
	vprintfmt(fputch, &b, fmt, ap);
80002f5b:	ff 75 10             	pushl  0x10(%ebp)
80002f5e:	ff 75 0c             	pushl  0xc(%ebp)
80002f61:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80002f67:	50                   	push   %eax
80002f68:	68 a6 2a 00 80       	push   $0x80002aa6
80002f6d:	e8 69 fb ff ff       	call   80002adb <vprintfmt>
	if (b.idx > 0)
80002f72:	83 c4 10             	add    $0x10,%esp
80002f75:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
80002f7c:	7e 0b                	jle    80002f89 <vfprintf+0x5e>
		writebuf(&b);
80002f7e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80002f84:	e8 de fa ff ff       	call   80002a67 <writebuf>

	return (b.result ? b.result : b.error);
80002f89:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80002f8f:	85 c0                	test   %eax,%eax
80002f91:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
80002f98:	c9                   	leave  
80002f99:	c3                   	ret    

80002f9a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
80002f9a:	55                   	push   %ebp
80002f9b:	89 e5                	mov    %esp,%ebp
80002f9d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80002fa0:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
80002fa3:	50                   	push   %eax
80002fa4:	ff 75 0c             	pushl  0xc(%ebp)
80002fa7:	ff 75 08             	pushl  0x8(%ebp)
80002faa:	e8 7c ff ff ff       	call   80002f2b <vfprintf>
	va_end(ap);

	return cnt;
}
80002faf:	c9                   	leave  
80002fb0:	c3                   	ret    

80002fb1 <printf>:

int
printf(const char *fmt, ...)
{
80002fb1:	55                   	push   %ebp
80002fb2:	89 e5                	mov    %esp,%ebp
80002fb4:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80002fb7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
80002fba:	50                   	push   %eax
80002fbb:	ff 75 08             	pushl  0x8(%ebp)
80002fbe:	6a 01                	push   $0x1
80002fc0:	e8 66 ff ff ff       	call   80002f2b <vfprintf>
	va_end(ap);

	return cnt;
}
80002fc5:	c9                   	leave  
80002fc6:	c3                   	ret    

80002fc7 <printfmt>:
	putch("0123456789abcdef"[num % base], putdat);
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
80002fc7:	55                   	push   %ebp
80002fc8:	89 e5                	mov    %esp,%ebp
80002fca:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
80002fcd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
80002fd0:	50                   	push   %eax
80002fd1:	ff 75 10             	pushl  0x10(%ebp)
80002fd4:	ff 75 0c             	pushl  0xc(%ebp)
80002fd7:	ff 75 08             	pushl  0x8(%ebp)
80002fda:	e8 fc fa ff ff       	call   80002adb <vprintfmt>
	va_end(ap);
}
80002fdf:	83 c4 10             	add    $0x10,%esp
80002fe2:	c9                   	leave  
80002fe3:	c3                   	ret    

80002fe4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
80002fe4:	55                   	push   %ebp
80002fe5:	89 e5                	mov    %esp,%ebp
80002fe7:	83 ec 18             	sub    $0x18,%esp
80002fea:	8b 45 08             	mov    0x8(%ebp),%eax
80002fed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
80002ff0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80002ff3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
80002ff7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80002ffa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
80003001:	85 c0                	test   %eax,%eax
80003003:	74 26                	je     8000302b <vsnprintf+0x47>
80003005:	85 d2                	test   %edx,%edx
80003007:	7e 22                	jle    8000302b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
80003009:	ff 75 14             	pushl  0x14(%ebp)
8000300c:	ff 75 10             	pushl  0x10(%ebp)
8000300f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80003012:	50                   	push   %eax
80003013:	68 08 2a 00 80       	push   $0x80002a08
80003018:	e8 be fa ff ff       	call   80002adb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
8000301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80003020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
80003023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003026:	83 c4 10             	add    $0x10,%esp
80003029:	eb 05                	jmp    80003030 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
8000302b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
80003030:	c9                   	leave  
80003031:	c3                   	ret    

80003032 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
80003032:	55                   	push   %ebp
80003033:	89 e5                	mov    %esp,%ebp
80003035:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
80003038:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
8000303b:	50                   	push   %eax
8000303c:	ff 75 10             	pushl  0x10(%ebp)
8000303f:	ff 75 0c             	pushl  0xc(%ebp)
80003042:	ff 75 08             	pushl  0x8(%ebp)
80003045:	e8 9a ff ff ff       	call   80002fe4 <vsnprintf>
	va_end(ap);

	return rc;
}
8000304a:	c9                   	leave  
8000304b:	c3                   	ret    

8000304c <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
8000304c:	55                   	push   %ebp
8000304d:	89 e5                	mov    %esp,%ebp
8000304f:	57                   	push   %edi
80003050:	56                   	push   %esi
80003051:	53                   	push   %ebx
80003052:	83 ec 0c             	sub    $0xc,%esp
80003055:	8b 45 08             	mov    0x8(%ebp),%eax

#ifndef __FOR_USER__
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
80003058:	85 c0                	test   %eax,%eax
8000305a:	74 13                	je     8000306f <readline+0x23>
		fprintf(1, "%s", prompt);
8000305c:	83 ec 04             	sub    $0x4,%esp
8000305f:	50                   	push   %eax
80003060:	68 65 33 00 80       	push   $0x80003365
80003065:	6a 01                	push   $0x1
80003067:	e8 2e ff ff ff       	call   80002f9a <fprintf>
8000306c:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
8000306f:	83 ec 0c             	sub    $0xc,%esp
80003072:	6a 00                	push   $0x0
80003074:	e8 1b 02 00 00       	call   80003294 <iscons>
80003079:	89 c7                	mov    %eax,%edi
8000307b:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
8000307e:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
80003083:	e8 e1 01 00 00       	call   80003269 <getchar>
80003088:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
8000308a:	85 c0                	test   %eax,%eax
8000308c:	79 29                	jns    800030b7 <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
8000308e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
80003093:	83 fb f8             	cmp    $0xfffffff8,%ebx
80003096:	0f 84 9b 00 00 00    	je     80003137 <readline+0xeb>
				cprintf("read error: %e\n", c);
8000309c:	83 ec 08             	sub    $0x8,%esp
8000309f:	53                   	push   %ebx
800030a0:	68 aa 34 00 80       	push   $0x800034aa
800030a5:	e8 6d fe ff ff       	call   80002f17 <cprintf>
800030aa:	83 c4 10             	add    $0x10,%esp
			return NULL;
800030ad:	b8 00 00 00 00       	mov    $0x0,%eax
800030b2:	e9 80 00 00 00       	jmp    80003137 <readline+0xeb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
800030b7:	83 f8 08             	cmp    $0x8,%eax
800030ba:	0f 94 c2             	sete   %dl
800030bd:	83 f8 7f             	cmp    $0x7f,%eax
800030c0:	0f 94 c0             	sete   %al
800030c3:	08 c2                	or     %al,%dl
800030c5:	74 1a                	je     800030e1 <readline+0x95>
800030c7:	85 f6                	test   %esi,%esi
800030c9:	7e 16                	jle    800030e1 <readline+0x95>
			if (echoing)
800030cb:	85 ff                	test   %edi,%edi
800030cd:	74 0d                	je     800030dc <readline+0x90>
				cputchar('\b');
800030cf:	83 ec 0c             	sub    $0xc,%esp
800030d2:	6a 08                	push   $0x8
800030d4:	e8 74 01 00 00       	call   8000324d <cputchar>
800030d9:	83 c4 10             	add    $0x10,%esp
			i--;
800030dc:	83 ee 01             	sub    $0x1,%esi
800030df:	eb a2                	jmp    80003083 <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
800030e1:	83 fb 1f             	cmp    $0x1f,%ebx
800030e4:	7e 26                	jle    8000310c <readline+0xc0>
800030e6:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
800030ec:	7f 1e                	jg     8000310c <readline+0xc0>
			if (echoing)
800030ee:	85 ff                	test   %edi,%edi
800030f0:	74 0c                	je     800030fe <readline+0xb2>
				cputchar(c);
800030f2:	83 ec 0c             	sub    $0xc,%esp
800030f5:	53                   	push   %ebx
800030f6:	e8 52 01 00 00       	call   8000324d <cputchar>
800030fb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
800030fe:	88 9e 20 50 00 80    	mov    %bl,-0x7fffafe0(%esi)
80003104:	8d 76 01             	lea    0x1(%esi),%esi
80003107:	e9 77 ff ff ff       	jmp    80003083 <readline+0x37>
		} else if (c == '\n' || c == '\r') {
8000310c:	83 fb 0a             	cmp    $0xa,%ebx
8000310f:	74 09                	je     8000311a <readline+0xce>
80003111:	83 fb 0d             	cmp    $0xd,%ebx
80003114:	0f 85 69 ff ff ff    	jne    80003083 <readline+0x37>
			if (echoing)
8000311a:	85 ff                	test   %edi,%edi
8000311c:	74 0d                	je     8000312b <readline+0xdf>
				cputchar('\n');
8000311e:	83 ec 0c             	sub    $0xc,%esp
80003121:	6a 0a                	push   $0xa
80003123:	e8 25 01 00 00       	call   8000324d <cputchar>
80003128:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
8000312b:	c6 86 20 50 00 80 00 	movb   $0x0,-0x7fffafe0(%esi)
			return buf;
80003132:	b8 20 50 00 80       	mov    $0x80005020,%eax
		}
	}
}
80003137:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000313a:	5b                   	pop    %ebx
8000313b:	5e                   	pop    %esi
8000313c:	5f                   	pop    %edi
8000313d:	5d                   	pop    %ebp
8000313e:	c3                   	ret    

8000313f <_panic>:
 */
#include <syslib.h>

void
_panic(const char *file, int line, const char *fmt, ...)
{
8000313f:	55                   	push   %ebp
80003140:	89 e5                	mov    %esp,%ebp
80003142:	56                   	push   %esi
80003143:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
80003144:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
80003147:	8b 35 00 40 00 80    	mov    0x80004000,%esi
8000314d:	e8 82 e7 ff ff       	call   800018d4 <sys_getenvid>
80003152:	83 ec 0c             	sub    $0xc,%esp
80003155:	ff 75 0c             	pushl  0xc(%ebp)
80003158:	ff 75 08             	pushl  0x8(%ebp)
8000315b:	56                   	push   %esi
8000315c:	50                   	push   %eax
8000315d:	68 a8 37 00 80       	push   $0x800037a8
80003162:	e8 b0 fd ff ff       	call   80002f17 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
80003167:	83 c4 18             	add    $0x18,%esp
8000316a:	53                   	push   %ebx
8000316b:	ff 75 10             	pushl  0x10(%ebp)
8000316e:	e8 53 fd ff ff       	call   80002ec6 <vcprintf>
	cprintf("\n");
80003173:	c7 04 24 7b 33 00 80 	movl   $0x8000337b,(%esp)
8000317a:	e8 98 fd ff ff       	call   80002f17 <cprintf>
8000317f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
80003182:	cc                   	int3   
80003183:	eb fd                	jmp    80003182 <_panic+0x43>

80003185 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
80003185:	55                   	push   %ebp
80003186:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
80003188:	b8 00 00 00 00       	mov    $0x0,%eax
8000318d:	5d                   	pop    %ebp
8000318e:	c3                   	ret    

8000318f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
8000318f:	55                   	push   %ebp
80003190:	89 e5                	mov    %esp,%ebp
80003192:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
80003195:	68 ec 37 00 80       	push   $0x800037ec
8000319a:	ff 75 0c             	pushl  0xc(%ebp)
8000319d:	e8 8d e2 ff ff       	call   8000142f <strcpy>
	return 0;
}
800031a2:	b8 00 00 00 00       	mov    $0x0,%eax
800031a7:	c9                   	leave  
800031a8:	c3                   	ret    

800031a9 <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
800031a9:	55                   	push   %ebp
800031aa:	89 e5                	mov    %esp,%ebp
800031ac:	57                   	push   %edi
800031ad:	56                   	push   %esi
800031ae:	53                   	push   %ebx
800031af:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
800031b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
800031b9:	74 46                	je     80003201 <devcons_write+0x58>
800031bb:	b8 00 00 00 00       	mov    $0x0,%eax
800031c0:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
800031c5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
800031cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
800031ce:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
800031d0:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
800031d3:	ba 7f 00 00 00       	mov    $0x7f,%edx
800031d8:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
800031db:	83 ec 04             	sub    $0x4,%esp
800031de:	53                   	push   %ebx
800031df:	03 45 0c             	add    0xc(%ebp),%eax
800031e2:	50                   	push   %eax
800031e3:	57                   	push   %edi
800031e4:	e8 35 e4 ff ff       	call   8000161e <memmove>
		sys_cputs(buf, m);
800031e9:	83 c4 08             	add    $0x8,%esp
800031ec:	53                   	push   %ebx
800031ed:	57                   	push   %edi
800031ee:	e8 63 e6 ff ff       	call   80001856 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
800031f3:	01 de                	add    %ebx,%esi
800031f5:	89 f0                	mov    %esi,%eax
800031f7:	83 c4 10             	add    $0x10,%esp
800031fa:	3b 75 10             	cmp    0x10(%ebp),%esi
800031fd:	72 cc                	jb     800031cb <devcons_write+0x22>
800031ff:	eb 05                	jmp    80003206 <devcons_write+0x5d>
80003201:	be 00 00 00 00       	mov    $0x0,%esi
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
80003206:	89 f0                	mov    %esi,%eax
80003208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000320b:	5b                   	pop    %ebx
8000320c:	5e                   	pop    %esi
8000320d:	5f                   	pop    %edi
8000320e:	5d                   	pop    %ebp
8000320f:	c3                   	ret    

80003210 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
80003210:	55                   	push   %ebp
80003211:	89 e5                	mov    %esp,%ebp
80003213:	83 ec 08             	sub    $0x8,%esp
80003216:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
8000321b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8000321f:	74 2a                	je     8000324b <devcons_read+0x3b>
80003221:	eb 05                	jmp    80003228 <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
80003223:	e8 cb e6 ff ff       	call   800018f3 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
80003228:	e8 47 e6 ff ff       	call   80001874 <sys_cgetc>
8000322d:	85 c0                	test   %eax,%eax
8000322f:	74 f2                	je     80003223 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
80003231:	85 c0                	test   %eax,%eax
80003233:	78 16                	js     8000324b <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
80003235:	83 f8 04             	cmp    $0x4,%eax
80003238:	74 0c                	je     80003246 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
8000323a:	8b 55 0c             	mov    0xc(%ebp),%edx
8000323d:	88 02                	mov    %al,(%edx)
	return 1;
8000323f:	b8 01 00 00 00       	mov    $0x1,%eax
80003244:	eb 05                	jmp    8000324b <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
80003246:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
8000324b:	c9                   	leave  
8000324c:	c3                   	ret    

8000324d <cputchar>:
#include <string.h>
#include <syslib.h>

void
cputchar(int ch)
{
8000324d:	55                   	push   %ebp
8000324e:	89 e5                	mov    %esp,%ebp
80003250:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
80003253:	8b 45 08             	mov    0x8(%ebp),%eax
80003256:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
80003259:	6a 01                	push   $0x1
8000325b:	8d 45 f7             	lea    -0x9(%ebp),%eax
8000325e:	50                   	push   %eax
8000325f:	e8 f2 e5 ff ff       	call   80001856 <sys_cputs>
}
80003264:	83 c4 10             	add    $0x10,%esp
80003267:	c9                   	leave  
80003268:	c3                   	ret    

80003269 <getchar>:

int
getchar(void)
{
80003269:	55                   	push   %ebp
8000326a:	89 e5                	mov    %esp,%ebp
8000326c:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
8000326f:	6a 01                	push   $0x1
80003271:	8d 45 f7             	lea    -0x9(%ebp),%eax
80003274:	50                   	push   %eax
80003275:	6a 00                	push   $0x0
80003277:	e8 a2 eb ff ff       	call   80001e1e <read>
	if (r < 0)
8000327c:	83 c4 10             	add    $0x10,%esp
8000327f:	85 c0                	test   %eax,%eax
80003281:	78 0f                	js     80003292 <getchar+0x29>
		return r;
	if (r < 1)
80003283:	85 c0                	test   %eax,%eax
80003285:	7e 06                	jle    8000328d <getchar+0x24>
		return -E_EOF;
	return c;
80003287:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
8000328b:	eb 05                	jmp    80003292 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
8000328d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
80003292:	c9                   	leave  
80003293:	c3                   	ret    

80003294 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
80003294:	55                   	push   %ebp
80003295:	89 e5                	mov    %esp,%ebp
80003297:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
8000329a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000329d:	50                   	push   %eax
8000329e:	ff 75 08             	pushl  0x8(%ebp)
800032a1:	e8 f9 e8 ff ff       	call   80001b9f <fd_lookup>
800032a6:	83 c4 10             	add    $0x10,%esp
800032a9:	85 c0                	test   %eax,%eax
800032ab:	78 11                	js     800032be <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
800032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
800032b0:	8b 15 3c 40 00 80    	mov    0x8000403c,%edx
800032b6:	39 10                	cmp    %edx,(%eax)
800032b8:	0f 94 c0             	sete   %al
800032bb:	0f b6 c0             	movzbl %al,%eax
}
800032be:	c9                   	leave  
800032bf:	c3                   	ret    

800032c0 <opencons>:

int
opencons(void)
{
800032c0:	55                   	push   %ebp
800032c1:	89 e5                	mov    %esp,%ebp
800032c3:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
800032c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
800032c9:	50                   	push   %eax
800032ca:	e8 5c e8 ff ff       	call   80001b2b <fd_alloc>
800032cf:	83 c4 10             	add    $0x10,%esp
		return r;
800032d2:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
800032d4:	85 c0                	test   %eax,%eax
800032d6:	78 3e                	js     80003316 <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
800032d8:	83 ec 04             	sub    $0x4,%esp
800032db:	68 07 04 00 00       	push   $0x407
800032e0:	ff 75 f4             	pushl  -0xc(%ebp)
800032e3:	6a 00                	push   $0x0
800032e5:	e8 28 e6 ff ff       	call   80001912 <sys_page_alloc>
800032ea:	83 c4 10             	add    $0x10,%esp
		return r;
800032ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
800032ef:	85 c0                	test   %eax,%eax
800032f1:	78 23                	js     80003316 <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
800032f3:	8b 15 3c 40 00 80    	mov    0x8000403c,%edx
800032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
800032fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
800032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003301:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
80003308:	83 ec 0c             	sub    $0xc,%esp
8000330b:	50                   	push   %eax
8000330c:	e8 f2 e7 ff ff       	call   80001b03 <fd2num>
80003311:	89 c2                	mov    %eax,%edx
80003313:	83 c4 10             	add    $0x10,%esp
}
80003316:	89 d0                	mov    %edx,%eax
80003318:	c9                   	leave  
80003319:	c3                   	ret    
