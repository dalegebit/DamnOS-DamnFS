
sh:     file format elf32-i386


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
8000102c:	e8 d5 0c 00 00       	call   80001d06 <libmain>
1:	jmp 1b
80001031:	eb fe                	jmp    80001031 <args_exist+0x5>

80001033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
80001033:	55                   	push   %ebp
80001034:	89 e5                	mov    %esp,%ebp
80001036:	57                   	push   %edi
80001037:	56                   	push   %esi
80001038:	53                   	push   %ebx
80001039:	83 ec 0c             	sub    $0xc,%esp
8000103c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000103f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
80001042:	85 db                	test   %ebx,%ebx
80001044:	75 2c                	jne    80001072 <_gettoken+0x3f>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
80001046:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
8000104b:	83 3d 00 60 00 80 01 	cmpl   $0x1,0x80006000
80001052:	0f 8e 45 01 00 00    	jle    8000119d <_gettoken+0x16a>
			cprintf("GETTOKEN NULL\n");
80001058:	83 ec 0c             	sub    $0xc,%esp
8000105b:	68 c0 41 00 80       	push   $0x800041c0
80001060:	e8 ea 2e 00 00       	call   80003f4f <cprintf>
80001065:	83 c4 10             	add    $0x10,%esp
		return 0;
80001068:	b8 00 00 00 00       	mov    $0x0,%eax
8000106d:	e9 2b 01 00 00       	jmp    8000119d <_gettoken+0x16a>
	}

	if (debug > 1)
80001072:	83 3d 00 60 00 80 01 	cmpl   $0x1,0x80006000
80001079:	7e 11                	jle    8000108c <_gettoken+0x59>
		cprintf("GETTOKEN: %s\n", s);
8000107b:	83 ec 08             	sub    $0x8,%esp
8000107e:	53                   	push   %ebx
8000107f:	68 cf 41 00 80       	push   $0x800041cf
80001084:	e8 c6 2e 00 00       	call   80003f4f <cprintf>
80001089:	83 c4 10             	add    $0x10,%esp

	*p1 = 0;
8000108c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
80001092:	8b 45 10             	mov    0x10(%ebp),%eax
80001095:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
8000109b:	eb 07                	jmp    800010a4 <_gettoken+0x71>
		*s++ = 0;
8000109d:	83 c3 01             	add    $0x1,%ebx
800010a0:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
800010a4:	83 ec 08             	sub    $0x8,%esp
800010a7:	0f be 03             	movsbl (%ebx),%eax
800010aa:	50                   	push   %eax
800010ab:	68 dd 41 00 80       	push   $0x800041dd
800010b0:	e8 b4 09 00 00       	call   80001a69 <strchr>
800010b5:	83 c4 10             	add    $0x10,%esp
800010b8:	85 c0                	test   %eax,%eax
800010ba:	75 e1                	jne    8000109d <_gettoken+0x6a>
		*s++ = 0;
	if (*s == 0) {
800010bc:	0f b6 03             	movzbl (%ebx),%eax
800010bf:	84 c0                	test   %al,%al
800010c1:	75 2c                	jne    800010ef <_gettoken+0xbc>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
800010c3:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
800010c8:	83 3d 00 60 00 80 01 	cmpl   $0x1,0x80006000
800010cf:	0f 8e c8 00 00 00    	jle    8000119d <_gettoken+0x16a>
			cprintf("EOL\n");
800010d5:	83 ec 0c             	sub    $0xc,%esp
800010d8:	68 e2 41 00 80       	push   $0x800041e2
800010dd:	e8 6d 2e 00 00       	call   80003f4f <cprintf>
800010e2:	83 c4 10             	add    $0x10,%esp
		return 0;
800010e5:	b8 00 00 00 00       	mov    $0x0,%eax
800010ea:	e9 ae 00 00 00       	jmp    8000119d <_gettoken+0x16a>
	}
	if (strchr(SYMBOLS, *s)) {
800010ef:	83 ec 08             	sub    $0x8,%esp
800010f2:	0f be c0             	movsbl %al,%eax
800010f5:	50                   	push   %eax
800010f6:	68 f3 41 00 80       	push   $0x800041f3
800010fb:	e8 69 09 00 00       	call   80001a69 <strchr>
80001100:	83 c4 10             	add    $0x10,%esp
80001103:	85 c0                	test   %eax,%eax
80001105:	74 30                	je     80001137 <_gettoken+0x104>
		t = *s;
80001107:	0f be 3b             	movsbl (%ebx),%edi
		*p1 = s;
8000110a:	89 1e                	mov    %ebx,(%esi)
		*s++ = 0;
8000110c:	c6 03 00             	movb   $0x0,(%ebx)
		*p2 = s;
8000110f:	83 c3 01             	add    $0x1,%ebx
80001112:	8b 45 10             	mov    0x10(%ebp),%eax
80001115:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
80001117:	89 f8                	mov    %edi,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
80001119:	83 3d 00 60 00 80 01 	cmpl   $0x1,0x80006000
80001120:	7e 7b                	jle    8000119d <_gettoken+0x16a>
			cprintf("TOK %c\n", t);
80001122:	83 ec 08             	sub    $0x8,%esp
80001125:	57                   	push   %edi
80001126:	68 e7 41 00 80       	push   $0x800041e7
8000112b:	e8 1f 2e 00 00       	call   80003f4f <cprintf>
80001130:	83 c4 10             	add    $0x10,%esp
		return t;
80001133:	89 f8                	mov    %edi,%eax
80001135:	eb 66                	jmp    8000119d <_gettoken+0x16a>
	}
	*p1 = s;
80001137:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
80001139:	0f b6 03             	movzbl (%ebx),%eax
8000113c:	84 c0                	test   %al,%al
8000113e:	75 0c                	jne    8000114c <_gettoken+0x119>
80001140:	eb 22                	jmp    80001164 <_gettoken+0x131>
		s++;
80001142:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
80001145:	0f b6 03             	movzbl (%ebx),%eax
80001148:	84 c0                	test   %al,%al
8000114a:	74 18                	je     80001164 <_gettoken+0x131>
8000114c:	83 ec 08             	sub    $0x8,%esp
8000114f:	0f be c0             	movsbl %al,%eax
80001152:	50                   	push   %eax
80001153:	68 ef 41 00 80       	push   $0x800041ef
80001158:	e8 0c 09 00 00       	call   80001a69 <strchr>
8000115d:	83 c4 10             	add    $0x10,%esp
80001160:	85 c0                	test   %eax,%eax
80001162:	74 de                	je     80001142 <_gettoken+0x10f>
		s++;
	*p2 = s;
80001164:	8b 45 10             	mov    0x10(%ebp),%eax
80001167:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
80001169:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
8000116e:	83 3d 00 60 00 80 01 	cmpl   $0x1,0x80006000
80001175:	7e 26                	jle    8000119d <_gettoken+0x16a>
		t = **p2;
80001177:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
8000117a:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
8000117d:	83 ec 08             	sub    $0x8,%esp
80001180:	ff 36                	pushl  (%esi)
80001182:	68 fb 41 00 80       	push   $0x800041fb
80001187:	e8 c3 2d 00 00       	call   80003f4f <cprintf>
		**p2 = t;
8000118c:	8b 45 10             	mov    0x10(%ebp),%eax
8000118f:	8b 00                	mov    (%eax),%eax
80001191:	89 fa                	mov    %edi,%edx
80001193:	88 10                	mov    %dl,(%eax)
80001195:	83 c4 10             	add    $0x10,%esp
	}
	return 'w';
80001198:	b8 77 00 00 00       	mov    $0x77,%eax
}
8000119d:	8d 65 f4             	lea    -0xc(%ebp),%esp
800011a0:	5b                   	pop    %ebx
800011a1:	5e                   	pop    %esi
800011a2:	5f                   	pop    %edi
800011a3:	5d                   	pop    %ebp
800011a4:	c3                   	ret    

800011a5 <gettoken>:

int
gettoken(char *s, char **p1)
{
800011a5:	55                   	push   %ebp
800011a6:	89 e5                	mov    %esp,%ebp
800011a8:	83 ec 08             	sub    $0x8,%esp
800011ab:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
800011ae:	85 c0                	test   %eax,%eax
800011b0:	74 22                	je     800011d4 <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
800011b2:	83 ec 04             	sub    $0x4,%esp
800011b5:	68 0c 60 00 80       	push   $0x8000600c
800011ba:	68 10 60 00 80       	push   $0x80006010
800011bf:	50                   	push   %eax
800011c0:	e8 6e fe ff ff       	call   80001033 <_gettoken>
800011c5:	a3 08 60 00 80       	mov    %eax,0x80006008
		return 0;
800011ca:	83 c4 10             	add    $0x10,%esp
800011cd:	b8 00 00 00 00       	mov    $0x0,%eax
800011d2:	eb 3a                	jmp    8000120e <gettoken+0x69>
	}
	c = nc;
800011d4:	a1 08 60 00 80       	mov    0x80006008,%eax
800011d9:	a3 04 60 00 80       	mov    %eax,0x80006004
	*p1 = np1;
800011de:	8b 45 0c             	mov    0xc(%ebp),%eax
800011e1:	8b 15 10 60 00 80    	mov    0x80006010,%edx
800011e7:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
800011e9:	83 ec 04             	sub    $0x4,%esp
800011ec:	68 0c 60 00 80       	push   $0x8000600c
800011f1:	68 10 60 00 80       	push   $0x80006010
800011f6:	ff 35 0c 60 00 80    	pushl  0x8000600c
800011fc:	e8 32 fe ff ff       	call   80001033 <_gettoken>
80001201:	a3 08 60 00 80       	mov    %eax,0x80006008
	return c;
80001206:	a1 04 60 00 80       	mov    0x80006004,%eax
8000120b:	83 c4 10             	add    $0x10,%esp
}
8000120e:	c9                   	leave  
8000120f:	c3                   	ret    

80001210 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
80001210:	55                   	push   %ebp
80001211:	89 e5                	mov    %esp,%ebp
80001213:	57                   	push   %edi
80001214:	56                   	push   %esi
80001215:	53                   	push   %ebx
80001216:	81 ec 64 04 00 00    	sub    $0x464,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
8000121c:	6a 00                	push   $0x0
8000121e:	ff 75 08             	pushl  0x8(%ebp)
80001221:	e8 7f ff ff ff       	call   800011a5 <gettoken>
80001226:	83 c4 10             	add    $0x10,%esp

again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
80001229:	8d 5d a4             	lea    -0x5c(%ebp),%ebx

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
8000122c:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
80001231:	83 ec 08             	sub    $0x8,%esp
80001234:	53                   	push   %ebx
80001235:	6a 00                	push   $0x0
80001237:	e8 69 ff ff ff       	call   800011a5 <gettoken>
8000123c:	83 c4 10             	add    $0x10,%esp
8000123f:	83 f8 3e             	cmp    $0x3e,%eax
80001242:	0f 84 cc 00 00 00    	je     80001314 <runcmd+0x104>
80001248:	83 f8 3e             	cmp    $0x3e,%eax
8000124b:	7f 12                	jg     8000125f <runcmd+0x4f>
8000124d:	85 c0                	test   %eax,%eax
8000124f:	0f 84 3b 02 00 00    	je     80001490 <runcmd+0x280>
80001255:	83 f8 3c             	cmp    $0x3c,%eax
80001258:	74 3e                	je     80001298 <runcmd+0x88>
8000125a:	e9 1f 02 00 00       	jmp    8000147e <runcmd+0x26e>
8000125f:	83 f8 77             	cmp    $0x77,%eax
80001262:	74 0e                	je     80001272 <runcmd+0x62>
80001264:	83 f8 7c             	cmp    $0x7c,%eax
80001267:	0f 84 25 01 00 00    	je     80001392 <runcmd+0x182>
8000126d:	e9 0c 02 00 00       	jmp    8000147e <runcmd+0x26e>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
80001272:	83 fe 10             	cmp    $0x10,%esi
80001275:	75 15                	jne    8000128c <runcmd+0x7c>
				cprintf("too many arguments\n");
80001277:	83 ec 0c             	sub    $0xc,%esp
8000127a:	68 05 42 00 80       	push   $0x80004205
8000127f:	e8 cb 2c 00 00       	call   80003f4f <cprintf>
				exit();
80001284:	e8 c3 24 00 00       	call   8000374c <exit>
80001289:	83 c4 10             	add    $0x10,%esp
			}
			argv[argc++] = t;
8000128c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
8000128f:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
80001293:	8d 76 01             	lea    0x1(%esi),%esi
			break;
80001296:	eb 99                	jmp    80001231 <runcmd+0x21>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
80001298:	83 ec 08             	sub    $0x8,%esp
8000129b:	53                   	push   %ebx
8000129c:	6a 00                	push   $0x0
8000129e:	e8 02 ff ff ff       	call   800011a5 <gettoken>
800012a3:	83 c4 10             	add    $0x10,%esp
800012a6:	83 f8 77             	cmp    $0x77,%eax
800012a9:	74 15                	je     800012c0 <runcmd+0xb0>
				cprintf("syntax error: < not followed by word\n");
800012ab:	83 ec 0c             	sub    $0xc,%esp
800012ae:	68 a8 43 00 80       	push   $0x800043a8
800012b3:	e8 97 2c 00 00       	call   80003f4f <cprintf>
				exit();
800012b8:	e8 8f 24 00 00       	call   8000374c <exit>
800012bd:	83 c4 10             	add    $0x10,%esp
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			// panic("< redirection not implemented");
			if((fd = open(t, O_RDONLY)) < 0)
800012c0:	83 ec 08             	sub    $0x8,%esp
800012c3:	6a 00                	push   $0x0
800012c5:	ff 75 a4             	pushl  -0x5c(%ebp)
800012c8:	e8 2c 16 00 00       	call   800028f9 <open>
800012cd:	89 c7                	mov    %eax,%edi
800012cf:	83 c4 10             	add    $0x10,%esp
800012d2:	85 c0                	test   %eax,%eax
800012d4:	79 1b                	jns    800012f1 <runcmd+0xe1>
			{
				cprintf("open %s for read: %e", t, fd);
800012d6:	83 ec 04             	sub    $0x4,%esp
800012d9:	50                   	push   %eax
800012da:	ff 75 a4             	pushl  -0x5c(%ebp)
800012dd:	68 19 42 00 80       	push   $0x80004219
800012e2:	e8 68 2c 00 00       	call   80003f4f <cprintf>
				exit();
800012e7:	e8 60 24 00 00       	call   8000374c <exit>
800012ec:	83 c4 10             	add    $0x10,%esp
800012ef:	eb 08                	jmp    800012f9 <runcmd+0xe9>
			}
			if(fd != 0)
800012f1:	85 c0                	test   %eax,%eax
800012f3:	0f 84 38 ff ff ff    	je     80001231 <runcmd+0x21>
			{
				dup(fd, 0);
800012f9:	83 ec 08             	sub    $0x8,%esp
800012fc:	6a 00                	push   $0x0
800012fe:	57                   	push   %edi
800012ff:	e8 bb 10 00 00       	call   800023bf <dup>
				close(fd);
80001304:	89 3c 24             	mov    %edi,(%esp)
80001307:	e8 63 10 00 00       	call   8000236f <close>
8000130c:	83 c4 10             	add    $0x10,%esp
8000130f:	e9 1d ff ff ff       	jmp    80001231 <runcmd+0x21>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
80001314:	83 ec 08             	sub    $0x8,%esp
80001317:	53                   	push   %ebx
80001318:	6a 00                	push   $0x0
8000131a:	e8 86 fe ff ff       	call   800011a5 <gettoken>
8000131f:	83 c4 10             	add    $0x10,%esp
80001322:	83 f8 77             	cmp    $0x77,%eax
80001325:	74 15                	je     8000133c <runcmd+0x12c>
				cprintf("syntax error: > not followed by word\n");
80001327:	83 ec 0c             	sub    $0xc,%esp
8000132a:	68 d0 43 00 80       	push   $0x800043d0
8000132f:	e8 1b 2c 00 00       	call   80003f4f <cprintf>
				exit();
80001334:	e8 13 24 00 00       	call   8000374c <exit>
80001339:	83 c4 10             	add    $0x10,%esp
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
8000133c:	83 ec 08             	sub    $0x8,%esp
8000133f:	68 01 03 00 00       	push   $0x301
80001344:	ff 75 a4             	pushl  -0x5c(%ebp)
80001347:	e8 ad 15 00 00       	call   800028f9 <open>
8000134c:	89 c7                	mov    %eax,%edi
8000134e:	83 c4 10             	add    $0x10,%esp
80001351:	85 c0                	test   %eax,%eax
80001353:	79 19                	jns    8000136e <runcmd+0x15e>
				cprintf("open %s for write: %e", t, fd);
80001355:	83 ec 04             	sub    $0x4,%esp
80001358:	50                   	push   %eax
80001359:	ff 75 a4             	pushl  -0x5c(%ebp)
8000135c:	68 2e 42 00 80       	push   $0x8000422e
80001361:	e8 e9 2b 00 00       	call   80003f4f <cprintf>
				exit();
80001366:	e8 e1 23 00 00       	call   8000374c <exit>
8000136b:	83 c4 10             	add    $0x10,%esp
			}
			if (fd != 1) {
8000136e:	83 ff 01             	cmp    $0x1,%edi
80001371:	0f 84 ba fe ff ff    	je     80001231 <runcmd+0x21>
				dup(fd, 1);
80001377:	83 ec 08             	sub    $0x8,%esp
8000137a:	6a 01                	push   $0x1
8000137c:	57                   	push   %edi
8000137d:	e8 3d 10 00 00       	call   800023bf <dup>
				close(fd);
80001382:	89 3c 24             	mov    %edi,(%esp)
80001385:	e8 e5 0f 00 00       	call   8000236f <close>
8000138a:	83 c4 10             	add    $0x10,%esp
8000138d:	e9 9f fe ff ff       	jmp    80001231 <runcmd+0x21>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
80001392:	83 ec 0c             	sub    $0xc,%esp
80001395:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
8000139b:	50                   	push   %eax
8000139c:	e8 ea 17 00 00       	call   80002b8b <pipe>
800013a1:	83 c4 10             	add    $0x10,%esp
800013a4:	85 c0                	test   %eax,%eax
800013a6:	79 16                	jns    800013be <runcmd+0x1ae>
				cprintf("pipe: %e", r);
800013a8:	83 ec 08             	sub    $0x8,%esp
800013ab:	50                   	push   %eax
800013ac:	68 44 42 00 80       	push   $0x80004244
800013b1:	e8 99 2b 00 00       	call   80003f4f <cprintf>
				exit();
800013b6:	e8 91 23 00 00       	call   8000374c <exit>
800013bb:	83 c4 10             	add    $0x10,%esp
			}
			if (debug)
800013be:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800013c5:	74 1c                	je     800013e3 <runcmd+0x1d3>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
800013c7:	83 ec 04             	sub    $0x4,%esp
800013ca:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
800013d0:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
800013d6:	68 4d 42 00 80       	push   $0x8000424d
800013db:	e8 6f 2b 00 00       	call   80003f4f <cprintf>
800013e0:	83 c4 10             	add    $0x10,%esp
			if ((r = fork()) < 0) {
800013e3:	e8 1d 1b 00 00       	call   80002f05 <fork>
800013e8:	89 c7                	mov    %eax,%edi
800013ea:	85 c0                	test   %eax,%eax
800013ec:	79 16                	jns    80001404 <runcmd+0x1f4>
				cprintf("fork: %e", r);
800013ee:	83 ec 08             	sub    $0x8,%esp
800013f1:	50                   	push   %eax
800013f2:	68 5a 42 00 80       	push   $0x8000425a
800013f7:	e8 53 2b 00 00       	call   80003f4f <cprintf>
				exit();
800013fc:	e8 4b 23 00 00       	call   8000374c <exit>
80001401:	83 c4 10             	add    $0x10,%esp
			}
			if (r == 0) {
80001404:	85 ff                	test   %edi,%edi
80001406:	75 3c                	jne    80001444 <runcmd+0x234>
				if (p[0] != 0) {
80001408:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
8000140e:	85 c0                	test   %eax,%eax
80001410:	74 1c                	je     8000142e <runcmd+0x21e>
					dup(p[0], 0);
80001412:	83 ec 08             	sub    $0x8,%esp
80001415:	6a 00                	push   $0x0
80001417:	50                   	push   %eax
80001418:	e8 a2 0f 00 00       	call   800023bf <dup>
					close(p[0]);
8000141d:	83 c4 04             	add    $0x4,%esp
80001420:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
80001426:	e8 44 0f 00 00       	call   8000236f <close>
8000142b:	83 c4 10             	add    $0x10,%esp
				}
				close(p[1]);
8000142e:	83 ec 0c             	sub    $0xc,%esp
80001431:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
80001437:	e8 33 0f 00 00       	call   8000236f <close>
				goto again;
8000143c:	83 c4 10             	add    $0x10,%esp
8000143f:	e9 e8 fd ff ff       	jmp    8000122c <runcmd+0x1c>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
80001444:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
8000144a:	83 f8 01             	cmp    $0x1,%eax
8000144d:	74 1c                	je     8000146b <runcmd+0x25b>
					dup(p[1], 1);
8000144f:	83 ec 08             	sub    $0x8,%esp
80001452:	6a 01                	push   $0x1
80001454:	50                   	push   %eax
80001455:	e8 65 0f 00 00       	call   800023bf <dup>
					close(p[1]);
8000145a:	83 c4 04             	add    $0x4,%esp
8000145d:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
80001463:	e8 07 0f 00 00       	call   8000236f <close>
80001468:	83 c4 10             	add    $0x10,%esp
				}
				close(p[0]);
8000146b:	83 ec 0c             	sub    $0xc,%esp
8000146e:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
80001474:	e8 f6 0e 00 00       	call   8000236f <close>
				goto runit;
80001479:	83 c4 10             	add    $0x10,%esp
8000147c:	eb 17                	jmp    80001495 <runcmd+0x285>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
8000147e:	50                   	push   %eax
8000147f:	68 63 42 00 80       	push   $0x80004263
80001484:	6a 7a                	push   $0x7a
80001486:	68 7f 42 00 80       	push   $0x8000427f
8000148b:	e8 e7 2c 00 00       	call   80004177 <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
80001490:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
80001495:	85 f6                	test   %esi,%esi
80001497:	75 22                	jne    800014bb <runcmd+0x2ab>
		if (debug)
80001499:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800014a0:	0f 84 9b 01 00 00    	je     80001641 <runcmd+0x431>
			cprintf("EMPTY COMMAND\n");
800014a6:	83 ec 0c             	sub    $0xc,%esp
800014a9:	68 84 42 00 80       	push   $0x80004284
800014ae:	e8 9c 2a 00 00       	call   80003f4f <cprintf>
800014b3:	83 c4 10             	add    $0x10,%esp
800014b6:	e9 86 01 00 00       	jmp    80001641 <runcmd+0x431>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
800014bb:	8b 45 a8             	mov    -0x58(%ebp),%eax
800014be:	80 38 2f             	cmpb   $0x2f,(%eax)
800014c1:	74 23                	je     800014e6 <runcmd+0x2d6>
		argv0buf[0] = '/';
800014c3:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
800014ca:	83 ec 08             	sub    $0x8,%esp
800014cd:	50                   	push   %eax
800014ce:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
800014d4:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
800014da:	50                   	push   %eax
800014db:	e8 45 04 00 00       	call   80001925 <strcpy>
		argv[0] = argv0buf;
800014e0:	89 5d a8             	mov    %ebx,-0x58(%ebp)
800014e3:	83 c4 10             	add    $0x10,%esp
	}
	argv[argc] = 0;
800014e6:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
800014ed:	00 

	// Print the command.
	if (debug) {
800014ee:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800014f5:	74 4e                	je     80001545 <runcmd+0x335>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
800014f7:	a1 20 64 00 80       	mov    0x80006420,%eax
800014fc:	8b 40 48             	mov    0x48(%eax),%eax
800014ff:	83 ec 08             	sub    $0x8,%esp
80001502:	50                   	push   %eax
80001503:	68 93 42 00 80       	push   $0x80004293
80001508:	e8 42 2a 00 00       	call   80003f4f <cprintf>
		for (i = 0; argv[i]; i++)
8000150d:	8b 45 a8             	mov    -0x58(%ebp),%eax
80001510:	83 c4 10             	add    $0x10,%esp
80001513:	85 c0                	test   %eax,%eax
80001515:	74 1e                	je     80001535 <runcmd+0x325>
80001517:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
8000151a:	83 ec 08             	sub    $0x8,%esp
8000151d:	50                   	push   %eax
8000151e:	68 a1 42 00 80       	push   $0x800042a1
80001523:	e8 27 2a 00 00       	call   80003f4f <cprintf>
80001528:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
8000152b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8000152e:	83 c4 10             	add    $0x10,%esp
80001531:	85 c0                	test   %eax,%eax
80001533:	75 e5                	jne    8000151a <runcmd+0x30a>
			cprintf(" %s", argv[i]);
		cprintf("\n");
80001535:	83 ec 0c             	sub    $0xc,%esp
80001538:	68 e0 41 00 80       	push   $0x800041e0
8000153d:	e8 0d 2a 00 00       	call   80003f4f <cprintf>
80001542:	83 c4 10             	add    $0x10,%esp
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
80001545:	83 ec 08             	sub    $0x8,%esp
80001548:	8d 45 a8             	lea    -0x58(%ebp),%eax
8000154b:	50                   	push   %eax
8000154c:	ff 75 a8             	pushl  -0x58(%ebp)
8000154f:	e8 15 1c 00 00       	call   80003169 <spawn>
80001554:	89 c3                	mov    %eax,%ebx
80001556:	83 c4 10             	add    $0x10,%esp
80001559:	85 c0                	test   %eax,%eax
8000155b:	0f 89 c3 00 00 00    	jns    80001624 <runcmd+0x414>
		cprintf("spawn %s: %e\n", argv[0], r);
80001561:	83 ec 04             	sub    $0x4,%esp
80001564:	50                   	push   %eax
80001565:	ff 75 a8             	pushl  -0x58(%ebp)
80001568:	68 a5 42 00 80       	push   $0x800042a5
8000156d:	e8 dd 29 00 00       	call   80003f4f <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
80001572:	e8 23 0e 00 00       	call   8000239a <close_all>
80001577:	83 c4 10             	add    $0x10,%esp
8000157a:	eb 4c                	jmp    800015c8 <runcmd+0x3b8>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
8000157c:	a1 20 64 00 80       	mov    0x80006420,%eax
80001581:	8b 40 48             	mov    0x48(%eax),%eax
80001584:	53                   	push   %ebx
80001585:	ff 75 a8             	pushl  -0x58(%ebp)
80001588:	50                   	push   %eax
80001589:	68 b3 42 00 80       	push   $0x800042b3
8000158e:	e8 bc 29 00 00       	call   80003f4f <cprintf>
80001593:	83 c4 10             	add    $0x10,%esp
		wait(r);
80001596:	83 ec 0c             	sub    $0xc,%esp
80001599:	53                   	push   %ebx
8000159a:	e8 7c 1b 00 00       	call   8000311b <wait>
		if (debug)
8000159f:	83 c4 10             	add    $0x10,%esp
800015a2:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800015a9:	0f 84 8c 00 00 00    	je     8000163b <runcmd+0x42b>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
800015af:	a1 20 64 00 80       	mov    0x80006420,%eax
800015b4:	8b 40 48             	mov    0x48(%eax),%eax
800015b7:	83 ec 08             	sub    $0x8,%esp
800015ba:	50                   	push   %eax
800015bb:	68 c8 42 00 80       	push   $0x800042c8
800015c0:	e8 8a 29 00 00       	call   80003f4f <cprintf>
800015c5:	83 c4 10             	add    $0x10,%esp
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
800015c8:	85 ff                	test   %edi,%edi
800015ca:	74 51                	je     8000161d <runcmd+0x40d>
		if (debug)
800015cc:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800015d3:	74 1a                	je     800015ef <runcmd+0x3df>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
800015d5:	a1 20 64 00 80       	mov    0x80006420,%eax
800015da:	8b 40 48             	mov    0x48(%eax),%eax
800015dd:	83 ec 04             	sub    $0x4,%esp
800015e0:	57                   	push   %edi
800015e1:	50                   	push   %eax
800015e2:	68 de 42 00 80       	push   $0x800042de
800015e7:	e8 63 29 00 00       	call   80003f4f <cprintf>
800015ec:	83 c4 10             	add    $0x10,%esp
		wait(pipe_child);
800015ef:	83 ec 0c             	sub    $0xc,%esp
800015f2:	57                   	push   %edi
800015f3:	e8 23 1b 00 00       	call   8000311b <wait>
		if (debug)
800015f8:	83 c4 10             	add    $0x10,%esp
800015fb:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
80001602:	74 19                	je     8000161d <runcmd+0x40d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
80001604:	a1 20 64 00 80       	mov    0x80006420,%eax
80001609:	8b 40 48             	mov    0x48(%eax),%eax
8000160c:	83 ec 08             	sub    $0x8,%esp
8000160f:	50                   	push   %eax
80001610:	68 c8 42 00 80       	push   $0x800042c8
80001615:	e8 35 29 00 00       	call   80003f4f <cprintf>
8000161a:	83 c4 10             	add    $0x10,%esp
	}

	// Done!
	exit();
8000161d:	e8 2a 21 00 00       	call   8000374c <exit>
80001622:	eb 1d                	jmp    80001641 <runcmd+0x431>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
80001624:	e8 71 0d 00 00       	call   8000239a <close_all>
	if (r >= 0) {
		if (debug)
80001629:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
80001630:	0f 84 60 ff ff ff    	je     80001596 <runcmd+0x386>
80001636:	e9 41 ff ff ff       	jmp    8000157c <runcmd+0x36c>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
8000163b:	85 ff                	test   %edi,%edi
8000163d:	75 b0                	jne    800015ef <runcmd+0x3df>
8000163f:	eb dc                	jmp    8000161d <runcmd+0x40d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
80001641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001644:	5b                   	pop    %ebx
80001645:	5e                   	pop    %esi
80001646:	5f                   	pop    %edi
80001647:	5d                   	pop    %ebp
80001648:	c3                   	ret    

80001649 <usage>:
}


void
usage(void)
{
80001649:	55                   	push   %ebp
8000164a:	89 e5                	mov    %esp,%ebp
8000164c:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
8000164f:	68 f8 43 00 80       	push   $0x800043f8
80001654:	e8 f6 28 00 00       	call   80003f4f <cprintf>
	exit();
80001659:	e8 ee 20 00 00       	call   8000374c <exit>
}
8000165e:	83 c4 10             	add    $0x10,%esp
80001661:	c9                   	leave  
80001662:	c3                   	ret    

80001663 <umain>:

void
umain(int argc, char **argv)
{
80001663:	55                   	push   %ebp
80001664:	89 e5                	mov    %esp,%ebp
80001666:	57                   	push   %edi
80001667:	56                   	push   %esi
80001668:	53                   	push   %ebx
80001669:	83 ec 38             	sub    $0x38,%esp
	int interactive, echocmds;
	struct Argstate args;
	int r;

	cprintf("initsh: running sh\n");
8000166c:	68 fb 42 00 80       	push   $0x800042fb
80001671:	e8 d9 28 00 00       	call   80003f4f <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
80001676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8000167d:	e8 ed 0c 00 00       	call   8000236f <close>
	if ((r = opencons()) < 0)
80001682:	e8 ad 0a 00 00       	call   80002134 <opencons>
80001687:	83 c4 10             	add    $0x10,%esp
8000168a:	85 c0                	test   %eax,%eax
8000168c:	79 15                	jns    800016a3 <umain+0x40>
		panic("opencons: %e", r);
8000168e:	50                   	push   %eax
8000168f:	68 0f 43 00 80       	push   $0x8000430f
80001694:	68 19 01 00 00       	push   $0x119
80001699:	68 7f 42 00 80       	push   $0x8000427f
8000169e:	e8 d4 2a 00 00       	call   80004177 <_panic>
	if (r != 0)
800016a3:	85 c0                	test   %eax,%eax
800016a5:	74 15                	je     800016bc <umain+0x59>
		panic("first opencons used fd %d", r);
800016a7:	50                   	push   %eax
800016a8:	68 1c 43 00 80       	push   $0x8000431c
800016ad:	68 1b 01 00 00       	push   $0x11b
800016b2:	68 7f 42 00 80       	push   $0x8000427f
800016b7:	e8 bb 2a 00 00       	call   80004177 <_panic>
	if ((r = dup(0, 1)) < 0)
800016bc:	83 ec 08             	sub    $0x8,%esp
800016bf:	6a 01                	push   $0x1
800016c1:	6a 00                	push   $0x0
800016c3:	e8 f7 0c 00 00       	call   800023bf <dup>
800016c8:	83 c4 10             	add    $0x10,%esp
800016cb:	85 c0                	test   %eax,%eax
800016cd:	79 15                	jns    800016e4 <umain+0x81>
		panic("dup: %e", r);
800016cf:	50                   	push   %eax
800016d0:	68 36 43 00 80       	push   $0x80004336
800016d5:	68 1d 01 00 00       	push   $0x11d
800016da:	68 7f 42 00 80       	push   $0x8000427f
800016df:	e8 93 2a 00 00       	call   80004177 <_panic>

	cprintf("init: starting sh\n");
800016e4:	83 ec 0c             	sub    $0xc,%esp
800016e7:	68 3e 43 00 80       	push   $0x8000433e
800016ec:	e8 5e 28 00 00       	call   80003f4f <cprintf>

	cprintf("sh begin!\n");
800016f1:	c7 04 24 51 43 00 80 	movl   $0x80004351,(%esp)
800016f8:	e8 52 28 00 00       	call   80003f4f <cprintf>
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
800016fd:	83 c4 0c             	add    $0xc,%esp
80001700:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001703:	50                   	push   %eax
80001704:	ff 75 0c             	pushl  0xc(%ebp)
80001707:	8d 45 08             	lea    0x8(%ebp),%eax
8000170a:	50                   	push   %eax
8000170b:	e8 91 20 00 00       	call   800037a1 <argstart>
	while ((r = argnext(&args)) >= 0)
80001710:	83 c4 10             	add    $0x10,%esp

	cprintf("init: starting sh\n");

	cprintf("sh begin!\n");
	interactive = '?';
	echocmds = 0;
80001713:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		panic("dup: %e", r);

	cprintf("init: starting sh\n");

	cprintf("sh begin!\n");
	interactive = '?';
8000171a:	be 3f 00 00 00       	mov    $0x3f,%esi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
8000171f:	8d 5d d8             	lea    -0x28(%ebp),%ebx
80001722:	eb 2f                	jmp    80001753 <umain+0xf0>
		switch (r) {
80001724:	83 f8 69             	cmp    $0x69,%eax
80001727:	74 25                	je     8000174e <umain+0xeb>
80001729:	83 f8 78             	cmp    $0x78,%eax
8000172c:	74 07                	je     80001735 <umain+0xd2>
8000172e:	83 f8 64             	cmp    $0x64,%eax
80001731:	75 14                	jne    80001747 <umain+0xe4>
80001733:	eb 09                	jmp    8000173e <umain+0xdb>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
80001735:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
8000173c:	eb 15                	jmp    80001753 <umain+0xf0>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
8000173e:	83 05 00 60 00 80 01 	addl   $0x1,0x80006000
			break;
80001745:	eb 0c                	jmp    80001753 <umain+0xf0>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
80001747:	e8 fd fe ff ff       	call   80001649 <usage>
8000174c:	eb 05                	jmp    80001753 <umain+0xf0>
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
8000174e:	be 01 00 00 00       	mov    $0x1,%esi

	cprintf("sh begin!\n");
	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
80001753:	83 ec 0c             	sub    $0xc,%esp
80001756:	53                   	push   %ebx
80001757:	e8 75 20 00 00       	call   800037d1 <argnext>
8000175c:	83 c4 10             	add    $0x10,%esp
8000175f:	85 c0                	test   %eax,%eax
80001761:	79 c1                	jns    80001724 <umain+0xc1>
			break;
		default:
			usage();
		}

	if (argc > 2)
80001763:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
80001767:	7e 05                	jle    8000176e <umain+0x10b>
		usage();
80001769:	e8 db fe ff ff       	call   80001649 <usage>
	if (argc == 2) {
8000176e:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
80001772:	75 3f                	jne    800017b3 <umain+0x150>
		close(0);
80001774:	83 ec 0c             	sub    $0xc,%esp
80001777:	6a 00                	push   $0x0
80001779:	e8 f1 0b 00 00       	call   8000236f <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
8000177e:	83 c4 08             	add    $0x8,%esp
80001781:	6a 00                	push   $0x0
80001783:	8b 45 0c             	mov    0xc(%ebp),%eax
80001786:	ff 70 04             	pushl  0x4(%eax)
80001789:	e8 6b 11 00 00       	call   800028f9 <open>
8000178e:	83 c4 10             	add    $0x10,%esp
80001791:	85 c0                	test   %eax,%eax
80001793:	79 1e                	jns    800017b3 <umain+0x150>
			panic("open %s: %e", argv[1], r);
80001795:	83 ec 0c             	sub    $0xc,%esp
80001798:	50                   	push   %eax
80001799:	8b 45 0c             	mov    0xc(%ebp),%eax
8000179c:	ff 70 04             	pushl  0x4(%eax)
8000179f:	68 5c 43 00 80       	push   $0x8000435c
800017a4:	68 39 01 00 00       	push   $0x139
800017a9:	68 7f 42 00 80       	push   $0x8000427f
800017ae:	e8 c4 29 00 00       	call   80004177 <_panic>
	}
	if (interactive == '?')
800017b3:	83 fe 3f             	cmp    $0x3f,%esi
800017b6:	75 0f                	jne    800017c7 <umain+0x164>
		interactive = iscons(0);
800017b8:	83 ec 0c             	sub    $0xc,%esp
800017bb:	6a 00                	push   $0x0
800017bd:	e8 46 09 00 00       	call   80002108 <iscons>
800017c2:	89 c6                	mov    %eax,%esi
800017c4:	83 c4 10             	add    $0x10,%esp

	cprintf("sh work!\n");
800017c7:	83 ec 0c             	sub    $0xc,%esp
800017ca:	68 68 43 00 80       	push   $0x80004368
800017cf:	e8 7b 27 00 00       	call   80003f4f <cprintf>
800017d4:	83 c4 10             	add    $0x10,%esp
800017d7:	85 f6                	test   %esi,%esi
800017d9:	b8 00 00 00 00       	mov    $0x0,%eax
800017de:	bf 72 43 00 80       	mov    $0x80004372,%edi
800017e3:	0f 44 f8             	cmove  %eax,%edi
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
800017e6:	83 ec 0c             	sub    $0xc,%esp
800017e9:	57                   	push   %edi
800017ea:	e8 95 28 00 00       	call   80004084 <readline>
800017ef:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
800017f1:	83 c4 10             	add    $0x10,%esp
800017f4:	85 c0                	test   %eax,%eax
800017f6:	75 1e                	jne    80001816 <umain+0x1b3>
			if (debug)
800017f8:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
800017ff:	74 10                	je     80001811 <umain+0x1ae>
				cprintf("EXITING\n");
80001801:	83 ec 0c             	sub    $0xc,%esp
80001804:	68 75 43 00 80       	push   $0x80004375
80001809:	e8 41 27 00 00       	call   80003f4f <cprintf>
8000180e:	83 c4 10             	add    $0x10,%esp
			exit();	// end of file
80001811:	e8 36 1f 00 00       	call   8000374c <exit>
		}
		if (debug)
80001816:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
8000181d:	74 11                	je     80001830 <umain+0x1cd>
			cprintf("LINE: %s\n", buf);
8000181f:	83 ec 08             	sub    $0x8,%esp
80001822:	53                   	push   %ebx
80001823:	68 7e 43 00 80       	push   $0x8000437e
80001828:	e8 22 27 00 00       	call   80003f4f <cprintf>
8000182d:	83 c4 10             	add    $0x10,%esp
		if (buf[0] == '#')
80001830:	80 3b 23             	cmpb   $0x23,(%ebx)
80001833:	74 b1                	je     800017e6 <umain+0x183>
			continue;
		if (echocmds)
80001835:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80001839:	74 11                	je     8000184c <umain+0x1e9>
			printf("# %s\n", buf);
8000183b:	83 ec 08             	sub    $0x8,%esp
8000183e:	53                   	push   %ebx
8000183f:	68 88 43 00 80       	push   $0x80004388
80001844:	e8 a0 27 00 00       	call   80003fe9 <printf>
80001849:	83 c4 10             	add    $0x10,%esp
		if (debug)
8000184c:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
80001853:	74 10                	je     80001865 <umain+0x202>
			cprintf("BEFORE FORK\n");
80001855:	83 ec 0c             	sub    $0xc,%esp
80001858:	68 8e 43 00 80       	push   $0x8000438e
8000185d:	e8 ed 26 00 00       	call   80003f4f <cprintf>
80001862:	83 c4 10             	add    $0x10,%esp
		if ((r = fork()) < 0)
80001865:	e8 9b 16 00 00       	call   80002f05 <fork>
8000186a:	89 c6                	mov    %eax,%esi
8000186c:	85 c0                	test   %eax,%eax
8000186e:	79 15                	jns    80001885 <umain+0x222>
			panic("fork: %e", r);
80001870:	50                   	push   %eax
80001871:	68 5a 42 00 80       	push   $0x8000425a
80001876:	68 51 01 00 00       	push   $0x151
8000187b:	68 7f 42 00 80       	push   $0x8000427f
80001880:	e8 f2 28 00 00       	call   80004177 <_panic>
		if (debug)
80001885:	83 3d 00 60 00 80 00 	cmpl   $0x0,0x80006000
8000188c:	74 11                	je     8000189f <umain+0x23c>
			cprintf("FORK: %d\n", r);
8000188e:	83 ec 08             	sub    $0x8,%esp
80001891:	50                   	push   %eax
80001892:	68 9b 43 00 80       	push   $0x8000439b
80001897:	e8 b3 26 00 00       	call   80003f4f <cprintf>
8000189c:	83 c4 10             	add    $0x10,%esp
		if (r == 0) {
8000189f:	85 f6                	test   %esi,%esi
800018a1:	75 16                	jne    800018b9 <umain+0x256>
			runcmd(buf);
800018a3:	83 ec 0c             	sub    $0xc,%esp
800018a6:	53                   	push   %ebx
800018a7:	e8 64 f9 ff ff       	call   80001210 <runcmd>
			exit();
800018ac:	e8 9b 1e 00 00       	call   8000374c <exit>
800018b1:	83 c4 10             	add    $0x10,%esp
800018b4:	e9 2d ff ff ff       	jmp    800017e6 <umain+0x183>
		} else
			wait(r);
800018b9:	83 ec 0c             	sub    $0xc,%esp
800018bc:	56                   	push   %esi
800018bd:	e8 59 18 00 00       	call   8000311b <wait>
800018c2:	83 c4 10             	add    $0x10,%esp
800018c5:	e9 1c ff ff ff       	jmp    800017e6 <umain+0x183>

800018ca <strlen>:
#include <x86.h>
#define ASM 1

int
strlen(const char *s)
{
800018ca:	55                   	push   %ebp
800018cb:	89 e5                	mov    %esp,%ebp
800018cd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
800018d0:	80 3a 00             	cmpb   $0x0,(%edx)
800018d3:	74 10                	je     800018e5 <strlen+0x1b>
800018d5:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
800018da:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
800018dd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
800018e1:	75 f7                	jne    800018da <strlen+0x10>
800018e3:	eb 05                	jmp    800018ea <strlen+0x20>
800018e5:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
800018ea:	5d                   	pop    %ebp
800018eb:	c3                   	ret    

800018ec <strnlen>:

int
strnlen(const char *s, size_t size)
{
800018ec:	55                   	push   %ebp
800018ed:	89 e5                	mov    %esp,%ebp
800018ef:	53                   	push   %ebx
800018f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
800018f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
800018f6:	85 c9                	test   %ecx,%ecx
800018f8:	74 1c                	je     80001916 <strnlen+0x2a>
800018fa:	80 3b 00             	cmpb   $0x0,(%ebx)
800018fd:	74 1e                	je     8000191d <strnlen+0x31>
800018ff:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
80001904:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
80001906:	39 ca                	cmp    %ecx,%edx
80001908:	74 18                	je     80001922 <strnlen+0x36>
8000190a:	83 c2 01             	add    $0x1,%edx
8000190d:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
80001912:	75 f0                	jne    80001904 <strnlen+0x18>
80001914:	eb 0c                	jmp    80001922 <strnlen+0x36>
80001916:	b8 00 00 00 00       	mov    $0x0,%eax
8000191b:	eb 05                	jmp    80001922 <strnlen+0x36>
8000191d:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
80001922:	5b                   	pop    %ebx
80001923:	5d                   	pop    %ebp
80001924:	c3                   	ret    

80001925 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
80001925:	55                   	push   %ebp
80001926:	89 e5                	mov    %esp,%ebp
80001928:	53                   	push   %ebx
80001929:	8b 45 08             	mov    0x8(%ebp),%eax
8000192c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
8000192f:	89 c2                	mov    %eax,%edx
80001931:	83 c2 01             	add    $0x1,%edx
80001934:	83 c1 01             	add    $0x1,%ecx
80001937:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
8000193b:	88 5a ff             	mov    %bl,-0x1(%edx)
8000193e:	84 db                	test   %bl,%bl
80001940:	75 ef                	jne    80001931 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
80001942:	5b                   	pop    %ebx
80001943:	5d                   	pop    %ebp
80001944:	c3                   	ret    

80001945 <strcat>:

char *
strcat(char *dst, const char *src)
{
80001945:	55                   	push   %ebp
80001946:	89 e5                	mov    %esp,%ebp
80001948:	53                   	push   %ebx
80001949:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
8000194c:	53                   	push   %ebx
8000194d:	e8 78 ff ff ff       	call   800018ca <strlen>
80001952:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
80001955:	ff 75 0c             	pushl  0xc(%ebp)
80001958:	01 d8                	add    %ebx,%eax
8000195a:	50                   	push   %eax
8000195b:	e8 c5 ff ff ff       	call   80001925 <strcpy>
	return dst;
}
80001960:	89 d8                	mov    %ebx,%eax
80001962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001965:	c9                   	leave  
80001966:	c3                   	ret    

80001967 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
80001967:	55                   	push   %ebp
80001968:	89 e5                	mov    %esp,%ebp
8000196a:	56                   	push   %esi
8000196b:	53                   	push   %ebx
8000196c:	8b 75 08             	mov    0x8(%ebp),%esi
8000196f:	8b 55 0c             	mov    0xc(%ebp),%edx
80001972:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
80001975:	85 db                	test   %ebx,%ebx
80001977:	74 17                	je     80001990 <strncpy+0x29>
80001979:	01 f3                	add    %esi,%ebx
8000197b:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
8000197d:	83 c1 01             	add    $0x1,%ecx
80001980:	0f b6 02             	movzbl (%edx),%eax
80001983:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
80001986:	80 3a 01             	cmpb   $0x1,(%edx)
80001989:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
8000198c:	39 cb                	cmp    %ecx,%ebx
8000198e:	75 ed                	jne    8000197d <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
80001990:	89 f0                	mov    %esi,%eax
80001992:	5b                   	pop    %ebx
80001993:	5e                   	pop    %esi
80001994:	5d                   	pop    %ebp
80001995:	c3                   	ret    

80001996 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
80001996:	55                   	push   %ebp
80001997:	89 e5                	mov    %esp,%ebp
80001999:	56                   	push   %esi
8000199a:	53                   	push   %ebx
8000199b:	8b 75 08             	mov    0x8(%ebp),%esi
8000199e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
800019a1:	8b 55 10             	mov    0x10(%ebp),%edx
800019a4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
800019a6:	85 d2                	test   %edx,%edx
800019a8:	74 35                	je     800019df <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
800019aa:	89 d0                	mov    %edx,%eax
800019ac:	83 e8 01             	sub    $0x1,%eax
800019af:	74 25                	je     800019d6 <strlcpy+0x40>
800019b1:	0f b6 0b             	movzbl (%ebx),%ecx
800019b4:	84 c9                	test   %cl,%cl
800019b6:	74 22                	je     800019da <strlcpy+0x44>
800019b8:	8d 53 01             	lea    0x1(%ebx),%edx
800019bb:	01 c3                	add    %eax,%ebx
800019bd:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
800019bf:	83 c0 01             	add    $0x1,%eax
800019c2:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
800019c5:	39 da                	cmp    %ebx,%edx
800019c7:	74 13                	je     800019dc <strlcpy+0x46>
800019c9:	83 c2 01             	add    $0x1,%edx
800019cc:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
800019d0:	84 c9                	test   %cl,%cl
800019d2:	75 eb                	jne    800019bf <strlcpy+0x29>
800019d4:	eb 06                	jmp    800019dc <strlcpy+0x46>
800019d6:	89 f0                	mov    %esi,%eax
800019d8:	eb 02                	jmp    800019dc <strlcpy+0x46>
800019da:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
800019dc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
800019df:	29 f0                	sub    %esi,%eax
}
800019e1:	5b                   	pop    %ebx
800019e2:	5e                   	pop    %esi
800019e3:	5d                   	pop    %ebp
800019e4:	c3                   	ret    

800019e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
800019e5:	55                   	push   %ebp
800019e6:	89 e5                	mov    %esp,%ebp
800019e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
800019eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
800019ee:	0f b6 01             	movzbl (%ecx),%eax
800019f1:	84 c0                	test   %al,%al
800019f3:	74 15                	je     80001a0a <strcmp+0x25>
800019f5:	3a 02                	cmp    (%edx),%al
800019f7:	75 11                	jne    80001a0a <strcmp+0x25>
		p++, q++;
800019f9:	83 c1 01             	add    $0x1,%ecx
800019fc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
800019ff:	0f b6 01             	movzbl (%ecx),%eax
80001a02:	84 c0                	test   %al,%al
80001a04:	74 04                	je     80001a0a <strcmp+0x25>
80001a06:	3a 02                	cmp    (%edx),%al
80001a08:	74 ef                	je     800019f9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
80001a0a:	0f b6 c0             	movzbl %al,%eax
80001a0d:	0f b6 12             	movzbl (%edx),%edx
80001a10:	29 d0                	sub    %edx,%eax
}
80001a12:	5d                   	pop    %ebp
80001a13:	c3                   	ret    

80001a14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
80001a14:	55                   	push   %ebp
80001a15:	89 e5                	mov    %esp,%ebp
80001a17:	56                   	push   %esi
80001a18:	53                   	push   %ebx
80001a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80001a1f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
80001a22:	85 f6                	test   %esi,%esi
80001a24:	74 29                	je     80001a4f <strncmp+0x3b>
80001a26:	0f b6 03             	movzbl (%ebx),%eax
80001a29:	84 c0                	test   %al,%al
80001a2b:	74 30                	je     80001a5d <strncmp+0x49>
80001a2d:	3a 02                	cmp    (%edx),%al
80001a2f:	75 2c                	jne    80001a5d <strncmp+0x49>
80001a31:	8d 43 01             	lea    0x1(%ebx),%eax
80001a34:	01 de                	add    %ebx,%esi
		n--, p++, q++;
80001a36:	89 c3                	mov    %eax,%ebx
80001a38:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
80001a3b:	39 c6                	cmp    %eax,%esi
80001a3d:	74 17                	je     80001a56 <strncmp+0x42>
80001a3f:	0f b6 08             	movzbl (%eax),%ecx
80001a42:	84 c9                	test   %cl,%cl
80001a44:	74 17                	je     80001a5d <strncmp+0x49>
80001a46:	83 c0 01             	add    $0x1,%eax
80001a49:	3a 0a                	cmp    (%edx),%cl
80001a4b:	74 e9                	je     80001a36 <strncmp+0x22>
80001a4d:	eb 0e                	jmp    80001a5d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
80001a4f:	b8 00 00 00 00       	mov    $0x0,%eax
80001a54:	eb 0f                	jmp    80001a65 <strncmp+0x51>
80001a56:	b8 00 00 00 00       	mov    $0x0,%eax
80001a5b:	eb 08                	jmp    80001a65 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
80001a5d:	0f b6 03             	movzbl (%ebx),%eax
80001a60:	0f b6 12             	movzbl (%edx),%edx
80001a63:	29 d0                	sub    %edx,%eax
}
80001a65:	5b                   	pop    %ebx
80001a66:	5e                   	pop    %esi
80001a67:	5d                   	pop    %ebp
80001a68:	c3                   	ret    

80001a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
80001a69:	55                   	push   %ebp
80001a6a:	89 e5                	mov    %esp,%ebp
80001a6c:	53                   	push   %ebx
80001a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80001a70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
80001a73:	0f b6 10             	movzbl (%eax),%edx
80001a76:	84 d2                	test   %dl,%dl
80001a78:	74 1d                	je     80001a97 <strchr+0x2e>
80001a7a:	89 d9                	mov    %ebx,%ecx
		if (*s == c)
80001a7c:	38 d3                	cmp    %dl,%bl
80001a7e:	75 06                	jne    80001a86 <strchr+0x1d>
80001a80:	eb 1a                	jmp    80001a9c <strchr+0x33>
80001a82:	38 ca                	cmp    %cl,%dl
80001a84:	74 16                	je     80001a9c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
80001a86:	83 c0 01             	add    $0x1,%eax
80001a89:	0f b6 10             	movzbl (%eax),%edx
80001a8c:	84 d2                	test   %dl,%dl
80001a8e:	75 f2                	jne    80001a82 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
80001a90:	b8 00 00 00 00       	mov    $0x0,%eax
80001a95:	eb 05                	jmp    80001a9c <strchr+0x33>
80001a97:	b8 00 00 00 00       	mov    $0x0,%eax
}
80001a9c:	5b                   	pop    %ebx
80001a9d:	5d                   	pop    %ebp
80001a9e:	c3                   	ret    

80001a9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
80001a9f:	55                   	push   %ebp
80001aa0:	89 e5                	mov    %esp,%ebp
80001aa2:	53                   	push   %ebx
80001aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80001aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
80001aa9:	0f b6 18             	movzbl (%eax),%ebx
		if (*s == c)
80001aac:	38 d3                	cmp    %dl,%bl
80001aae:	74 14                	je     80001ac4 <strfind+0x25>
80001ab0:	89 d1                	mov    %edx,%ecx
80001ab2:	84 db                	test   %bl,%bl
80001ab4:	74 0e                	je     80001ac4 <strfind+0x25>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
80001ab6:	83 c0 01             	add    $0x1,%eax
80001ab9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
80001abc:	38 ca                	cmp    %cl,%dl
80001abe:	74 04                	je     80001ac4 <strfind+0x25>
80001ac0:	84 d2                	test   %dl,%dl
80001ac2:	75 f2                	jne    80001ab6 <strfind+0x17>
			break;
	return (char *) s;
}
80001ac4:	5b                   	pop    %ebx
80001ac5:	5d                   	pop    %ebp
80001ac6:	c3                   	ret    

80001ac7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
80001ac7:	55                   	push   %ebp
80001ac8:	89 e5                	mov    %esp,%ebp
80001aca:	57                   	push   %edi
80001acb:	56                   	push   %esi
80001acc:	53                   	push   %ebx
80001acd:	8b 7d 08             	mov    0x8(%ebp),%edi
80001ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx

	if (n == 0)
80001ad3:	85 c9                	test   %ecx,%ecx
80001ad5:	74 36                	je     80001b0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
80001ad7:	f7 c7 03 00 00 00    	test   $0x3,%edi
80001add:	75 28                	jne    80001b07 <memset+0x40>
80001adf:	f6 c1 03             	test   $0x3,%cl
80001ae2:	75 23                	jne    80001b07 <memset+0x40>
		c &= 0xFF;
80001ae4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
80001ae8:	89 d3                	mov    %edx,%ebx
80001aea:	c1 e3 08             	shl    $0x8,%ebx
80001aed:	89 d6                	mov    %edx,%esi
80001aef:	c1 e6 18             	shl    $0x18,%esi
80001af2:	89 d0                	mov    %edx,%eax
80001af4:	c1 e0 10             	shl    $0x10,%eax
80001af7:	09 f0                	or     %esi,%eax
80001af9:	09 c2                	or     %eax,%edx
		asm volatile("cld; rep stosl\n"
80001afb:	89 d8                	mov    %ebx,%eax
80001afd:	09 d0                	or     %edx,%eax
80001aff:	c1 e9 02             	shr    $0x2,%ecx
80001b02:	fc                   	cld    
80001b03:	f3 ab                	rep stos %eax,%es:(%edi)
80001b05:	eb 06                	jmp    80001b0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
80001b07:	8b 45 0c             	mov    0xc(%ebp),%eax
80001b0a:	fc                   	cld    
80001b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
80001b0d:	89 f8                	mov    %edi,%eax
80001b0f:	5b                   	pop    %ebx
80001b10:	5e                   	pop    %esi
80001b11:	5f                   	pop    %edi
80001b12:	5d                   	pop    %ebp
80001b13:	c3                   	ret    

80001b14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
80001b14:	55                   	push   %ebp
80001b15:	89 e5                	mov    %esp,%ebp
80001b17:	57                   	push   %edi
80001b18:	56                   	push   %esi
80001b19:	8b 45 08             	mov    0x8(%ebp),%eax
80001b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80001b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
80001b22:	39 c6                	cmp    %eax,%esi
80001b24:	73 35                	jae    80001b5b <memmove+0x47>
80001b26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
80001b29:	39 d0                	cmp    %edx,%eax
80001b2b:	73 2e                	jae    80001b5b <memmove+0x47>
		s += n;
		d += n;
80001b2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
80001b30:	89 d6                	mov    %edx,%esi
80001b32:	09 fe                	or     %edi,%esi
80001b34:	f7 c6 03 00 00 00    	test   $0x3,%esi
80001b3a:	75 13                	jne    80001b4f <memmove+0x3b>
80001b3c:	f6 c1 03             	test   $0x3,%cl
80001b3f:	75 0e                	jne    80001b4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
80001b41:	83 ef 04             	sub    $0x4,%edi
80001b44:	8d 72 fc             	lea    -0x4(%edx),%esi
80001b47:	c1 e9 02             	shr    $0x2,%ecx
80001b4a:	fd                   	std    
80001b4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80001b4d:	eb 09                	jmp    80001b58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
80001b4f:	83 ef 01             	sub    $0x1,%edi
80001b52:	8d 72 ff             	lea    -0x1(%edx),%esi
80001b55:	fd                   	std    
80001b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
80001b58:	fc                   	cld    
80001b59:	eb 1d                	jmp    80001b78 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
80001b5b:	89 f2                	mov    %esi,%edx
80001b5d:	09 c2                	or     %eax,%edx
80001b5f:	f6 c2 03             	test   $0x3,%dl
80001b62:	75 0f                	jne    80001b73 <memmove+0x5f>
80001b64:	f6 c1 03             	test   $0x3,%cl
80001b67:	75 0a                	jne    80001b73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
80001b69:	c1 e9 02             	shr    $0x2,%ecx
80001b6c:	89 c7                	mov    %eax,%edi
80001b6e:	fc                   	cld    
80001b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80001b71:	eb 05                	jmp    80001b78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
80001b73:	89 c7                	mov    %eax,%edi
80001b75:	fc                   	cld    
80001b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
80001b78:	5e                   	pop    %esi
80001b79:	5f                   	pop    %edi
80001b7a:	5d                   	pop    %ebp
80001b7b:	c3                   	ret    

80001b7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
80001b7c:	55                   	push   %ebp
80001b7d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
80001b7f:	ff 75 10             	pushl  0x10(%ebp)
80001b82:	ff 75 0c             	pushl  0xc(%ebp)
80001b85:	ff 75 08             	pushl  0x8(%ebp)
80001b88:	e8 87 ff ff ff       	call   80001b14 <memmove>
}
80001b8d:	c9                   	leave  
80001b8e:	c3                   	ret    

80001b8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
80001b8f:	55                   	push   %ebp
80001b90:	89 e5                	mov    %esp,%ebp
80001b92:	57                   	push   %edi
80001b93:	56                   	push   %esi
80001b94:	53                   	push   %ebx
80001b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001b98:	8b 75 0c             	mov    0xc(%ebp),%esi
80001b9b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
80001b9e:	85 c0                	test   %eax,%eax
80001ba0:	74 39                	je     80001bdb <memcmp+0x4c>
80001ba2:	8d 78 ff             	lea    -0x1(%eax),%edi
		if (*s1 != *s2)
80001ba5:	0f b6 13             	movzbl (%ebx),%edx
80001ba8:	0f b6 0e             	movzbl (%esi),%ecx
80001bab:	38 ca                	cmp    %cl,%dl
80001bad:	75 17                	jne    80001bc6 <memcmp+0x37>
80001baf:	b8 00 00 00 00       	mov    $0x0,%eax
80001bb4:	eb 1a                	jmp    80001bd0 <memcmp+0x41>
80001bb6:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80001bbb:	83 c0 01             	add    $0x1,%eax
80001bbe:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80001bc2:	38 ca                	cmp    %cl,%dl
80001bc4:	74 0a                	je     80001bd0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
80001bc6:	0f b6 c2             	movzbl %dl,%eax
80001bc9:	0f b6 c9             	movzbl %cl,%ecx
80001bcc:	29 c8                	sub    %ecx,%eax
80001bce:	eb 10                	jmp    80001be0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
80001bd0:	39 f8                	cmp    %edi,%eax
80001bd2:	75 e2                	jne    80001bb6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
80001bd4:	b8 00 00 00 00       	mov    $0x0,%eax
80001bd9:	eb 05                	jmp    80001be0 <memcmp+0x51>
80001bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80001be0:	5b                   	pop    %ebx
80001be1:	5e                   	pop    %esi
80001be2:	5f                   	pop    %edi
80001be3:	5d                   	pop    %ebp
80001be4:	c3                   	ret    

80001be5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
80001be5:	55                   	push   %ebp
80001be6:	89 e5                	mov    %esp,%ebp
80001be8:	53                   	push   %ebx
80001be9:	8b 55 08             	mov    0x8(%ebp),%edx
	const void *ends = (const char *) s + n;
80001bec:	89 d0                	mov    %edx,%eax
80001bee:	03 45 10             	add    0x10(%ebp),%eax
	for (; s < ends; s++)
80001bf1:	39 c2                	cmp    %eax,%edx
80001bf3:	73 1d                	jae    80001c12 <memfind+0x2d>
		if (*(const unsigned char *) s == (unsigned char) c)
80001bf5:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
80001bf9:	0f b6 0a             	movzbl (%edx),%ecx
80001bfc:	39 d9                	cmp    %ebx,%ecx
80001bfe:	75 09                	jne    80001c09 <memfind+0x24>
80001c00:	eb 14                	jmp    80001c16 <memfind+0x31>
80001c02:	0f b6 0a             	movzbl (%edx),%ecx
80001c05:	39 d9                	cmp    %ebx,%ecx
80001c07:	74 11                	je     80001c1a <memfind+0x35>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
80001c09:	83 c2 01             	add    $0x1,%edx
80001c0c:	39 d0                	cmp    %edx,%eax
80001c0e:	75 f2                	jne    80001c02 <memfind+0x1d>
80001c10:	eb 0a                	jmp    80001c1c <memfind+0x37>
80001c12:	89 d0                	mov    %edx,%eax
80001c14:	eb 06                	jmp    80001c1c <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
80001c16:	89 d0                	mov    %edx,%eax
80001c18:	eb 02                	jmp    80001c1c <memfind+0x37>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
80001c1a:	89 d0                	mov    %edx,%eax
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
80001c1c:	5b                   	pop    %ebx
80001c1d:	5d                   	pop    %ebp
80001c1e:	c3                   	ret    

80001c1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
80001c1f:	55                   	push   %ebp
80001c20:	89 e5                	mov    %esp,%ebp
80001c22:	57                   	push   %edi
80001c23:	56                   	push   %esi
80001c24:	53                   	push   %ebx
80001c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
80001c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
80001c2b:	0f b6 01             	movzbl (%ecx),%eax
80001c2e:	3c 20                	cmp    $0x20,%al
80001c30:	74 04                	je     80001c36 <strtol+0x17>
80001c32:	3c 09                	cmp    $0x9,%al
80001c34:	75 0e                	jne    80001c44 <strtol+0x25>
		s++;
80001c36:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
80001c39:	0f b6 01             	movzbl (%ecx),%eax
80001c3c:	3c 20                	cmp    $0x20,%al
80001c3e:	74 f6                	je     80001c36 <strtol+0x17>
80001c40:	3c 09                	cmp    $0x9,%al
80001c42:	74 f2                	je     80001c36 <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
80001c44:	3c 2b                	cmp    $0x2b,%al
80001c46:	75 0a                	jne    80001c52 <strtol+0x33>
		s++;
80001c48:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
80001c4b:	bf 00 00 00 00       	mov    $0x0,%edi
80001c50:	eb 11                	jmp    80001c63 <strtol+0x44>
80001c52:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
80001c57:	3c 2d                	cmp    $0x2d,%al
80001c59:	75 08                	jne    80001c63 <strtol+0x44>
		s++, neg = 1;
80001c5b:	83 c1 01             	add    $0x1,%ecx
80001c5e:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
80001c63:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
80001c69:	75 15                	jne    80001c80 <strtol+0x61>
80001c6b:	80 39 30             	cmpb   $0x30,(%ecx)
80001c6e:	75 10                	jne    80001c80 <strtol+0x61>
80001c70:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
80001c74:	75 7c                	jne    80001cf2 <strtol+0xd3>
		s += 2, base = 16;
80001c76:	83 c1 02             	add    $0x2,%ecx
80001c79:	bb 10 00 00 00       	mov    $0x10,%ebx
80001c7e:	eb 16                	jmp    80001c96 <strtol+0x77>
	else if (base == 0 && s[0] == '0')
80001c80:	85 db                	test   %ebx,%ebx
80001c82:	75 12                	jne    80001c96 <strtol+0x77>
		s++, base = 8;
	else if (base == 0)
		base = 10;
80001c84:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
80001c89:	80 39 30             	cmpb   $0x30,(%ecx)
80001c8c:	75 08                	jne    80001c96 <strtol+0x77>
		s++, base = 8;
80001c8e:	83 c1 01             	add    $0x1,%ecx
80001c91:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
80001c96:	b8 00 00 00 00       	mov    $0x0,%eax
80001c9b:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
80001c9e:	0f b6 11             	movzbl (%ecx),%edx
80001ca1:	8d 72 d0             	lea    -0x30(%edx),%esi
80001ca4:	89 f3                	mov    %esi,%ebx
80001ca6:	80 fb 09             	cmp    $0x9,%bl
80001ca9:	77 08                	ja     80001cb3 <strtol+0x94>
			dig = *s - '0';
80001cab:	0f be d2             	movsbl %dl,%edx
80001cae:	83 ea 30             	sub    $0x30,%edx
80001cb1:	eb 22                	jmp    80001cd5 <strtol+0xb6>
		else if (*s >= 'a' && *s <= 'z')
80001cb3:	8d 72 9f             	lea    -0x61(%edx),%esi
80001cb6:	89 f3                	mov    %esi,%ebx
80001cb8:	80 fb 19             	cmp    $0x19,%bl
80001cbb:	77 08                	ja     80001cc5 <strtol+0xa6>
			dig = *s - 'a' + 10;
80001cbd:	0f be d2             	movsbl %dl,%edx
80001cc0:	83 ea 57             	sub    $0x57,%edx
80001cc3:	eb 10                	jmp    80001cd5 <strtol+0xb6>
		else if (*s >= 'A' && *s <= 'Z')
80001cc5:	8d 72 bf             	lea    -0x41(%edx),%esi
80001cc8:	89 f3                	mov    %esi,%ebx
80001cca:	80 fb 19             	cmp    $0x19,%bl
80001ccd:	77 16                	ja     80001ce5 <strtol+0xc6>
			dig = *s - 'A' + 10;
80001ccf:	0f be d2             	movsbl %dl,%edx
80001cd2:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
80001cd5:	3b 55 10             	cmp    0x10(%ebp),%edx
80001cd8:	7d 0b                	jge    80001ce5 <strtol+0xc6>
			break;
		s++, val = (val * base) + dig;
80001cda:	83 c1 01             	add    $0x1,%ecx
80001cdd:	0f af 45 10          	imul   0x10(%ebp),%eax
80001ce1:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
80001ce3:	eb b9                	jmp    80001c9e <strtol+0x7f>

	if (endptr)
80001ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80001ce9:	74 0d                	je     80001cf8 <strtol+0xd9>
		*endptr = (char *) s;
80001ceb:	8b 75 0c             	mov    0xc(%ebp),%esi
80001cee:	89 0e                	mov    %ecx,(%esi)
80001cf0:	eb 06                	jmp    80001cf8 <strtol+0xd9>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
80001cf2:	85 db                	test   %ebx,%ebx
80001cf4:	74 98                	je     80001c8e <strtol+0x6f>
80001cf6:	eb 9e                	jmp    80001c96 <strtol+0x77>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
80001cf8:	89 c2                	mov    %eax,%edx
80001cfa:	f7 da                	neg    %edx
80001cfc:	85 ff                	test   %edi,%edi
80001cfe:	0f 45 c2             	cmovne %edx,%eax
}
80001d01:	5b                   	pop    %ebx
80001d02:	5e                   	pop    %esi
80001d03:	5f                   	pop    %edi
80001d04:	5d                   	pop    %ebp
80001d05:	c3                   	ret    

80001d06 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
80001d06:	55                   	push   %ebp
80001d07:	89 e5                	mov    %esp,%ebp
80001d09:	56                   	push   %esi
80001d0a:	53                   	push   %ebx
80001d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001d0e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	thisenv = &envs[ENVX(sys_getenvid())];
80001d11:	e8 b4 00 00 00       	call   80001dca <sys_getenvid>
80001d16:	25 ff 03 00 00       	and    $0x3ff,%eax
80001d1b:	6b c0 7c             	imul   $0x7c,%eax,%eax
80001d1e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80001d23:	a3 20 64 00 80       	mov    %eax,0x80006420

	// save the name of the program so that panic() can use it
	if (argc > 0)
80001d28:	85 db                	test   %ebx,%ebx
80001d2a:	7e 07                	jle    80001d33 <libmain+0x2d>
		binaryname = argv[0];
80001d2c:	8b 06                	mov    (%esi),%eax
80001d2e:	a3 00 50 00 80       	mov    %eax,0x80005000

	// call user main routine
	umain(argc, argv);
80001d33:	83 ec 08             	sub    $0x8,%esp
80001d36:	56                   	push   %esi
80001d37:	53                   	push   %ebx
80001d38:	e8 26 f9 ff ff       	call   80001663 <umain>

	// exit gracefully
	exit();
80001d3d:	e8 0a 1a 00 00       	call   8000374c <exit>
}
80001d42:	83 c4 10             	add    $0x10,%esp
80001d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80001d48:	5b                   	pop    %ebx
80001d49:	5e                   	pop    %esi
80001d4a:	5d                   	pop    %ebp
80001d4b:	c3                   	ret    

80001d4c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
80001d4c:	55                   	push   %ebp
80001d4d:	89 e5                	mov    %esp,%ebp
80001d4f:	57                   	push   %edi
80001d50:	56                   	push   %esi
80001d51:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001d52:	b8 00 00 00 00       	mov    $0x0,%eax
80001d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001d5a:	8b 55 08             	mov    0x8(%ebp),%edx
80001d5d:	89 c3                	mov    %eax,%ebx
80001d5f:	89 c7                	mov    %eax,%edi
80001d61:	89 c6                	mov    %eax,%esi
80001d63:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
80001d65:	5b                   	pop    %ebx
80001d66:	5e                   	pop    %esi
80001d67:	5f                   	pop    %edi
80001d68:	5d                   	pop    %ebp
80001d69:	c3                   	ret    

80001d6a <sys_cgetc>:

int
sys_cgetc(void)
{
80001d6a:	55                   	push   %ebp
80001d6b:	89 e5                	mov    %esp,%ebp
80001d6d:	57                   	push   %edi
80001d6e:	56                   	push   %esi
80001d6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001d70:	ba 00 00 00 00       	mov    $0x0,%edx
80001d75:	b8 01 00 00 00       	mov    $0x1,%eax
80001d7a:	89 d1                	mov    %edx,%ecx
80001d7c:	89 d3                	mov    %edx,%ebx
80001d7e:	89 d7                	mov    %edx,%edi
80001d80:	89 d6                	mov    %edx,%esi
80001d82:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
80001d84:	5b                   	pop    %ebx
80001d85:	5e                   	pop    %esi
80001d86:	5f                   	pop    %edi
80001d87:	5d                   	pop    %ebp
80001d88:	c3                   	ret    

80001d89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
80001d89:	55                   	push   %ebp
80001d8a:	89 e5                	mov    %esp,%ebp
80001d8c:	57                   	push   %edi
80001d8d:	56                   	push   %esi
80001d8e:	53                   	push   %ebx
80001d8f:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001d92:	b9 00 00 00 00       	mov    $0x0,%ecx
80001d97:	b8 03 00 00 00       	mov    $0x3,%eax
80001d9c:	8b 55 08             	mov    0x8(%ebp),%edx
80001d9f:	89 cb                	mov    %ecx,%ebx
80001da1:	89 cf                	mov    %ecx,%edi
80001da3:	89 ce                	mov    %ecx,%esi
80001da5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001da7:	85 c0                	test   %eax,%eax
80001da9:	7e 17                	jle    80001dc2 <sys_env_destroy+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
80001dab:	83 ec 0c             	sub    $0xc,%esp
80001dae:	50                   	push   %eax
80001daf:	6a 03                	push   $0x3
80001db1:	68 23 44 00 80       	push   $0x80004423
80001db6:	6a 21                	push   $0x21
80001db8:	68 40 44 00 80       	push   $0x80004440
80001dbd:	e8 b5 23 00 00       	call   80004177 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
80001dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001dc5:	5b                   	pop    %ebx
80001dc6:	5e                   	pop    %esi
80001dc7:	5f                   	pop    %edi
80001dc8:	5d                   	pop    %ebp
80001dc9:	c3                   	ret    

80001dca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
80001dca:	55                   	push   %ebp
80001dcb:	89 e5                	mov    %esp,%ebp
80001dcd:	57                   	push   %edi
80001dce:	56                   	push   %esi
80001dcf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001dd0:	ba 00 00 00 00       	mov    $0x0,%edx
80001dd5:	b8 02 00 00 00       	mov    $0x2,%eax
80001dda:	89 d1                	mov    %edx,%ecx
80001ddc:	89 d3                	mov    %edx,%ebx
80001dde:	89 d7                	mov    %edx,%edi
80001de0:	89 d6                	mov    %edx,%esi
80001de2:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
80001de4:	5b                   	pop    %ebx
80001de5:	5e                   	pop    %esi
80001de6:	5f                   	pop    %edi
80001de7:	5d                   	pop    %ebp
80001de8:	c3                   	ret    

80001de9 <sys_yield>:

void
sys_yield(void)
{
80001de9:	55                   	push   %ebp
80001dea:	89 e5                	mov    %esp,%ebp
80001dec:	57                   	push   %edi
80001ded:	56                   	push   %esi
80001dee:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001def:	ba 00 00 00 00       	mov    $0x0,%edx
80001df4:	b8 0b 00 00 00       	mov    $0xb,%eax
80001df9:	89 d1                	mov    %edx,%ecx
80001dfb:	89 d3                	mov    %edx,%ebx
80001dfd:	89 d7                	mov    %edx,%edi
80001dff:	89 d6                	mov    %edx,%esi
80001e01:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
80001e03:	5b                   	pop    %ebx
80001e04:	5e                   	pop    %esi
80001e05:	5f                   	pop    %edi
80001e06:	5d                   	pop    %ebp
80001e07:	c3                   	ret    

80001e08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
80001e08:	55                   	push   %ebp
80001e09:	89 e5                	mov    %esp,%ebp
80001e0b:	57                   	push   %edi
80001e0c:	56                   	push   %esi
80001e0d:	53                   	push   %ebx
80001e0e:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001e11:	be 00 00 00 00       	mov    $0x0,%esi
80001e16:	b8 04 00 00 00       	mov    $0x4,%eax
80001e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001e1e:	8b 55 08             	mov    0x8(%ebp),%edx
80001e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
80001e24:	89 f7                	mov    %esi,%edi
80001e26:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001e28:	85 c0                	test   %eax,%eax
80001e2a:	7e 17                	jle    80001e43 <sys_page_alloc+0x3b>
		panic("syscall %d returned %d (> 0)", num, ret);
80001e2c:	83 ec 0c             	sub    $0xc,%esp
80001e2f:	50                   	push   %eax
80001e30:	6a 04                	push   $0x4
80001e32:	68 23 44 00 80       	push   $0x80004423
80001e37:	6a 21                	push   $0x21
80001e39:	68 40 44 00 80       	push   $0x80004440
80001e3e:	e8 34 23 00 00       	call   80004177 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
80001e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001e46:	5b                   	pop    %ebx
80001e47:	5e                   	pop    %esi
80001e48:	5f                   	pop    %edi
80001e49:	5d                   	pop    %ebp
80001e4a:	c3                   	ret    

80001e4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
80001e4b:	55                   	push   %ebp
80001e4c:	89 e5                	mov    %esp,%ebp
80001e4e:	57                   	push   %edi
80001e4f:	56                   	push   %esi
80001e50:	53                   	push   %ebx
80001e51:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001e54:	b8 05 00 00 00       	mov    $0x5,%eax
80001e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001e5c:	8b 55 08             	mov    0x8(%ebp),%edx
80001e5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
80001e62:	8b 7d 14             	mov    0x14(%ebp),%edi
80001e65:	8b 75 18             	mov    0x18(%ebp),%esi
80001e68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001e6a:	85 c0                	test   %eax,%eax
80001e6c:	7e 17                	jle    80001e85 <sys_page_map+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001e6e:	83 ec 0c             	sub    $0xc,%esp
80001e71:	50                   	push   %eax
80001e72:	6a 05                	push   $0x5
80001e74:	68 23 44 00 80       	push   $0x80004423
80001e79:	6a 21                	push   $0x21
80001e7b:	68 40 44 00 80       	push   $0x80004440
80001e80:	e8 f2 22 00 00       	call   80004177 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
80001e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001e88:	5b                   	pop    %ebx
80001e89:	5e                   	pop    %esi
80001e8a:	5f                   	pop    %edi
80001e8b:	5d                   	pop    %ebp
80001e8c:	c3                   	ret    

80001e8d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
80001e8d:	55                   	push   %ebp
80001e8e:	89 e5                	mov    %esp,%ebp
80001e90:	57                   	push   %edi
80001e91:	56                   	push   %esi
80001e92:	53                   	push   %ebx
80001e93:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001e96:	bb 00 00 00 00       	mov    $0x0,%ebx
80001e9b:	b8 06 00 00 00       	mov    $0x6,%eax
80001ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001ea3:	8b 55 08             	mov    0x8(%ebp),%edx
80001ea6:	89 df                	mov    %ebx,%edi
80001ea8:	89 de                	mov    %ebx,%esi
80001eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001eac:	85 c0                	test   %eax,%eax
80001eae:	7e 17                	jle    80001ec7 <sys_page_unmap+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001eb0:	83 ec 0c             	sub    $0xc,%esp
80001eb3:	50                   	push   %eax
80001eb4:	6a 06                	push   $0x6
80001eb6:	68 23 44 00 80       	push   $0x80004423
80001ebb:	6a 21                	push   $0x21
80001ebd:	68 40 44 00 80       	push   $0x80004440
80001ec2:	e8 b0 22 00 00       	call   80004177 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
80001ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001eca:	5b                   	pop    %ebx
80001ecb:	5e                   	pop    %esi
80001ecc:	5f                   	pop    %edi
80001ecd:	5d                   	pop    %ebp
80001ece:	c3                   	ret    

80001ecf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
80001ecf:	55                   	push   %ebp
80001ed0:	89 e5                	mov    %esp,%ebp
80001ed2:	57                   	push   %edi
80001ed3:	56                   	push   %esi
80001ed4:	53                   	push   %ebx
80001ed5:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001ed8:	bb 00 00 00 00       	mov    $0x0,%ebx
80001edd:	b8 08 00 00 00       	mov    $0x8,%eax
80001ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001ee5:	8b 55 08             	mov    0x8(%ebp),%edx
80001ee8:	89 df                	mov    %ebx,%edi
80001eea:	89 de                	mov    %ebx,%esi
80001eec:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001eee:	85 c0                	test   %eax,%eax
80001ef0:	7e 17                	jle    80001f09 <sys_env_set_status+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001ef2:	83 ec 0c             	sub    $0xc,%esp
80001ef5:	50                   	push   %eax
80001ef6:	6a 08                	push   $0x8
80001ef8:	68 23 44 00 80       	push   $0x80004423
80001efd:	6a 21                	push   $0x21
80001eff:	68 40 44 00 80       	push   $0x80004440
80001f04:	e8 6e 22 00 00       	call   80004177 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
80001f09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001f0c:	5b                   	pop    %ebx
80001f0d:	5e                   	pop    %esi
80001f0e:	5f                   	pop    %edi
80001f0f:	5d                   	pop    %ebp
80001f10:	c3                   	ret    

80001f11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
80001f11:	55                   	push   %ebp
80001f12:	89 e5                	mov    %esp,%ebp
80001f14:	57                   	push   %edi
80001f15:	56                   	push   %esi
80001f16:	53                   	push   %ebx
80001f17:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
80001f1f:	b8 09 00 00 00       	mov    $0x9,%eax
80001f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001f27:	8b 55 08             	mov    0x8(%ebp),%edx
80001f2a:	89 df                	mov    %ebx,%edi
80001f2c:	89 de                	mov    %ebx,%esi
80001f2e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001f30:	85 c0                	test   %eax,%eax
80001f32:	7e 17                	jle    80001f4b <sys_env_set_trapframe+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001f34:	83 ec 0c             	sub    $0xc,%esp
80001f37:	50                   	push   %eax
80001f38:	6a 09                	push   $0x9
80001f3a:	68 23 44 00 80       	push   $0x80004423
80001f3f:	6a 21                	push   $0x21
80001f41:	68 40 44 00 80       	push   $0x80004440
80001f46:	e8 2c 22 00 00       	call   80004177 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
80001f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001f4e:	5b                   	pop    %ebx
80001f4f:	5e                   	pop    %esi
80001f50:	5f                   	pop    %edi
80001f51:	5d                   	pop    %ebp
80001f52:	c3                   	ret    

80001f53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
80001f53:	55                   	push   %ebp
80001f54:	89 e5                	mov    %esp,%ebp
80001f56:	57                   	push   %edi
80001f57:	56                   	push   %esi
80001f58:	53                   	push   %ebx
80001f59:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
80001f61:	b8 0a 00 00 00       	mov    $0xa,%eax
80001f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001f69:	8b 55 08             	mov    0x8(%ebp),%edx
80001f6c:	89 df                	mov    %ebx,%edi
80001f6e:	89 de                	mov    %ebx,%esi
80001f70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001f72:	85 c0                	test   %eax,%eax
80001f74:	7e 17                	jle    80001f8d <sys_env_set_pgfault_upcall+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
80001f76:	83 ec 0c             	sub    $0xc,%esp
80001f79:	50                   	push   %eax
80001f7a:	6a 0a                	push   $0xa
80001f7c:	68 23 44 00 80       	push   $0x80004423
80001f81:	6a 21                	push   $0x21
80001f83:	68 40 44 00 80       	push   $0x80004440
80001f88:	e8 ea 21 00 00       	call   80004177 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
80001f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001f90:	5b                   	pop    %ebx
80001f91:	5e                   	pop    %esi
80001f92:	5f                   	pop    %edi
80001f93:	5d                   	pop    %ebp
80001f94:	c3                   	ret    

80001f95 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
80001f95:	55                   	push   %ebp
80001f96:	89 e5                	mov    %esp,%ebp
80001f98:	57                   	push   %edi
80001f99:	56                   	push   %esi
80001f9a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001f9b:	be 00 00 00 00       	mov    $0x0,%esi
80001fa0:	b8 0c 00 00 00       	mov    $0xc,%eax
80001fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80001fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80001fab:	8b 5d 10             	mov    0x10(%ebp),%ebx
80001fae:	8b 7d 14             	mov    0x14(%ebp),%edi
80001fb1:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
80001fb3:	5b                   	pop    %ebx
80001fb4:	5e                   	pop    %esi
80001fb5:	5f                   	pop    %edi
80001fb6:	5d                   	pop    %ebp
80001fb7:	c3                   	ret    

80001fb8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
80001fb8:	55                   	push   %ebp
80001fb9:	89 e5                	mov    %esp,%ebp
80001fbb:	57                   	push   %edi
80001fbc:	56                   	push   %esi
80001fbd:	53                   	push   %ebx
80001fbe:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
80001fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
80001fc6:	b8 0d 00 00 00       	mov    $0xd,%eax
80001fcb:	8b 55 08             	mov    0x8(%ebp),%edx
80001fce:	89 cb                	mov    %ecx,%ebx
80001fd0:	89 cf                	mov    %ecx,%edi
80001fd2:	89 ce                	mov    %ecx,%esi
80001fd4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
80001fd6:	85 c0                	test   %eax,%eax
80001fd8:	7e 17                	jle    80001ff1 <sys_ipc_recv+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
80001fda:	83 ec 0c             	sub    $0xc,%esp
80001fdd:	50                   	push   %eax
80001fde:	6a 0d                	push   $0xd
80001fe0:	68 23 44 00 80       	push   $0x80004423
80001fe5:	6a 21                	push   $0x21
80001fe7:	68 40 44 00 80       	push   $0x80004440
80001fec:	e8 86 21 00 00       	call   80004177 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
80001ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001ff4:	5b                   	pop    %ebx
80001ff5:	5e                   	pop    %esi
80001ff6:	5f                   	pop    %edi
80001ff7:	5d                   	pop    %ebp
80001ff8:	c3                   	ret    

80001ff9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
80001ff9:	55                   	push   %ebp
80001ffa:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
80001ffc:	b8 00 00 00 00       	mov    $0x0,%eax
80002001:	5d                   	pop    %ebp
80002002:	c3                   	ret    

80002003 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
80002003:	55                   	push   %ebp
80002004:	89 e5                	mov    %esp,%ebp
80002006:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
80002009:	68 4a 44 00 80       	push   $0x8000444a
8000200e:	ff 75 0c             	pushl  0xc(%ebp)
80002011:	e8 0f f9 ff ff       	call   80001925 <strcpy>
	return 0;
}
80002016:	b8 00 00 00 00       	mov    $0x0,%eax
8000201b:	c9                   	leave  
8000201c:	c3                   	ret    

8000201d <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
8000201d:	55                   	push   %ebp
8000201e:	89 e5                	mov    %esp,%ebp
80002020:	57                   	push   %edi
80002021:	56                   	push   %esi
80002022:	53                   	push   %ebx
80002023:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
80002029:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8000202d:	74 46                	je     80002075 <devcons_write+0x58>
8000202f:	b8 00 00 00 00       	mov    $0x0,%eax
80002034:	be 00 00 00 00       	mov    $0x0,%esi
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
80002039:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
8000203f:	8b 5d 10             	mov    0x10(%ebp),%ebx
80002042:	29 c3                	sub    %eax,%ebx
		if (m > sizeof(buf) - 1)
80002044:	83 fb 7f             	cmp    $0x7f,%ebx
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
80002047:	ba 7f 00 00 00       	mov    $0x7f,%edx
8000204c:	0f 47 da             	cmova  %edx,%ebx
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
8000204f:	83 ec 04             	sub    $0x4,%esp
80002052:	53                   	push   %ebx
80002053:	03 45 0c             	add    0xc(%ebp),%eax
80002056:	50                   	push   %eax
80002057:	57                   	push   %edi
80002058:	e8 b7 fa ff ff       	call   80001b14 <memmove>
		sys_cputs(buf, m);
8000205d:	83 c4 08             	add    $0x8,%esp
80002060:	53                   	push   %ebx
80002061:	57                   	push   %edi
80002062:	e8 e5 fc ff ff       	call   80001d4c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
80002067:	01 de                	add    %ebx,%esi
80002069:	89 f0                	mov    %esi,%eax
8000206b:	83 c4 10             	add    $0x10,%esp
8000206e:	3b 75 10             	cmp    0x10(%ebp),%esi
80002071:	72 cc                	jb     8000203f <devcons_write+0x22>
80002073:	eb 05                	jmp    8000207a <devcons_write+0x5d>
80002075:	be 00 00 00 00       	mov    $0x0,%esi
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
8000207a:	89 f0                	mov    %esi,%eax
8000207c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000207f:	5b                   	pop    %ebx
80002080:	5e                   	pop    %esi
80002081:	5f                   	pop    %edi
80002082:	5d                   	pop    %ebp
80002083:	c3                   	ret    

80002084 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
80002084:	55                   	push   %ebp
80002085:	89 e5                	mov    %esp,%ebp
80002087:	83 ec 08             	sub    $0x8,%esp
8000208a:	b8 00 00 00 00       	mov    $0x0,%eax
	int c;

	if (n == 0)
8000208f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80002093:	74 2a                	je     800020bf <devcons_read+0x3b>
80002095:	eb 05                	jmp    8000209c <devcons_read+0x18>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
80002097:	e8 4d fd ff ff       	call   80001de9 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
8000209c:	e8 c9 fc ff ff       	call   80001d6a <sys_cgetc>
800020a1:	85 c0                	test   %eax,%eax
800020a3:	74 f2                	je     80002097 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
800020a5:	85 c0                	test   %eax,%eax
800020a7:	78 16                	js     800020bf <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
800020a9:	83 f8 04             	cmp    $0x4,%eax
800020ac:	74 0c                	je     800020ba <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
800020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
800020b1:	88 02                	mov    %al,(%edx)
	return 1;
800020b3:	b8 01 00 00 00       	mov    $0x1,%eax
800020b8:	eb 05                	jmp    800020bf <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
800020ba:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
800020bf:	c9                   	leave  
800020c0:	c3                   	ret    

800020c1 <cputchar>:
#include <string.h>
#include <syslib.h>

void
cputchar(int ch)
{
800020c1:	55                   	push   %ebp
800020c2:	89 e5                	mov    %esp,%ebp
800020c4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
800020c7:	8b 45 08             	mov    0x8(%ebp),%eax
800020ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
800020cd:	6a 01                	push   $0x1
800020cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
800020d2:	50                   	push   %eax
800020d3:	e8 74 fc ff ff       	call   80001d4c <sys_cputs>
}
800020d8:	83 c4 10             	add    $0x10,%esp
800020db:	c9                   	leave  
800020dc:	c3                   	ret    

800020dd <getchar>:

int
getchar(void)
{
800020dd:	55                   	push   %ebp
800020de:	89 e5                	mov    %esp,%ebp
800020e0:	83 ec 1c             	sub    $0x1c,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
800020e3:	6a 01                	push   $0x1
800020e5:	8d 45 f7             	lea    -0x9(%ebp),%eax
800020e8:	50                   	push   %eax
800020e9:	6a 00                	push   $0x0
800020eb:	e8 b9 03 00 00       	call   800024a9 <read>
	if (r < 0)
800020f0:	83 c4 10             	add    $0x10,%esp
800020f3:	85 c0                	test   %eax,%eax
800020f5:	78 0f                	js     80002106 <getchar+0x29>
		return r;
	if (r < 1)
800020f7:	85 c0                	test   %eax,%eax
800020f9:	7e 06                	jle    80002101 <getchar+0x24>
		return -E_EOF;
	return c;
800020fb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
800020ff:	eb 05                	jmp    80002106 <getchar+0x29>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
80002101:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
80002106:	c9                   	leave  
80002107:	c3                   	ret    

80002108 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
80002108:	55                   	push   %ebp
80002109:	89 e5                	mov    %esp,%ebp
8000210b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
8000210e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002111:	50                   	push   %eax
80002112:	ff 75 08             	pushl  0x8(%ebp)
80002115:	e8 10 01 00 00       	call   8000222a <fd_lookup>
8000211a:	83 c4 10             	add    $0x10,%esp
8000211d:	85 c0                	test   %eax,%eax
8000211f:	78 11                	js     80002132 <iscons+0x2a>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
80002121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002124:	8b 15 04 50 00 80    	mov    0x80005004,%edx
8000212a:	39 10                	cmp    %edx,(%eax)
8000212c:	0f 94 c0             	sete   %al
8000212f:	0f b6 c0             	movzbl %al,%eax
}
80002132:	c9                   	leave  
80002133:	c3                   	ret    

80002134 <opencons>:

int
opencons(void)
{
80002134:	55                   	push   %ebp
80002135:	89 e5                	mov    %esp,%ebp
80002137:	83 ec 24             	sub    $0x24,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
8000213a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000213d:	50                   	push   %eax
8000213e:	e8 73 00 00 00       	call   800021b6 <fd_alloc>
80002143:	83 c4 10             	add    $0x10,%esp
		return r;
80002146:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
80002148:	85 c0                	test   %eax,%eax
8000214a:	78 3e                	js     8000218a <opencons+0x56>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
8000214c:	83 ec 04             	sub    $0x4,%esp
8000214f:	68 07 04 00 00       	push   $0x407
80002154:	ff 75 f4             	pushl  -0xc(%ebp)
80002157:	6a 00                	push   $0x0
80002159:	e8 aa fc ff ff       	call   80001e08 <sys_page_alloc>
8000215e:	83 c4 10             	add    $0x10,%esp
		return r;
80002161:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
80002163:	85 c0                	test   %eax,%eax
80002165:	78 23                	js     8000218a <opencons+0x56>
		return r;
	fd->fd_dev_id = devcons.dev_id;
80002167:	8b 15 04 50 00 80    	mov    0x80005004,%edx
8000216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002170:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
80002172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002175:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
8000217c:	83 ec 0c             	sub    $0xc,%esp
8000217f:	50                   	push   %eax
80002180:	e8 09 00 00 00       	call   8000218e <fd2num>
80002185:	89 c2                	mov    %eax,%edx
80002187:	83 c4 10             	add    $0x10,%esp
}
8000218a:	89 d0                	mov    %edx,%eax
8000218c:	c9                   	leave  
8000218d:	c3                   	ret    

8000218e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
8000218e:	55                   	push   %ebp
8000218f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
80002191:	8b 45 08             	mov    0x8(%ebp),%eax
80002194:	2d 00 00 00 20       	sub    $0x20000000,%eax
80002199:	c1 e8 0c             	shr    $0xc,%eax
}
8000219c:	5d                   	pop    %ebp
8000219d:	c3                   	ret    

8000219e <fd2data>:

char*
fd2data(struct Fd *fd)
{
8000219e:	55                   	push   %ebp
8000219f:	89 e5                	mov    %esp,%ebp
	return INDEX2DATA(fd2num(fd));
800021a1:	8b 45 08             	mov    0x8(%ebp),%eax
800021a4:	2d 00 00 00 20       	sub    $0x20000000,%eax
800021a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
800021ae:	8d 80 00 00 02 20    	lea    0x20020000(%eax),%eax
}
800021b4:	5d                   	pop    %ebp
800021b5:	c3                   	ret    

800021b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
800021b6:	55                   	push   %ebp
800021b7:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
800021b9:	a1 00 d2 7b ef       	mov    0xef7bd200,%eax
800021be:	a8 01                	test   $0x1,%al
800021c0:	74 34                	je     800021f6 <fd_alloc+0x40>
800021c2:	a1 00 00 48 ef       	mov    0xef480000,%eax
800021c7:	a8 01                	test   $0x1,%al
800021c9:	74 32                	je     800021fd <fd_alloc+0x47>
800021cb:	b8 00 10 00 20       	mov    $0x20001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
800021d0:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
800021d2:	89 c2                	mov    %eax,%edx
800021d4:	c1 ea 16             	shr    $0x16,%edx
800021d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
800021de:	f6 c2 01             	test   $0x1,%dl
800021e1:	74 1f                	je     80002202 <fd_alloc+0x4c>
800021e3:	89 c2                	mov    %eax,%edx
800021e5:	c1 ea 0c             	shr    $0xc,%edx
800021e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
800021ef:	f6 c2 01             	test   $0x1,%dl
800021f2:	75 1a                	jne    8000220e <fd_alloc+0x58>
800021f4:	eb 0c                	jmp    80002202 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
800021f6:	b9 00 00 00 20       	mov    $0x20000000,%ecx
800021fb:	eb 05                	jmp    80002202 <fd_alloc+0x4c>
800021fd:	b9 00 00 00 20       	mov    $0x20000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
80002202:	8b 45 08             	mov    0x8(%ebp),%eax
80002205:	89 08                	mov    %ecx,(%eax)
			return 0;
80002207:	b8 00 00 00 00       	mov    $0x0,%eax
8000220c:	eb 1a                	jmp    80002228 <fd_alloc+0x72>
8000220e:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
80002213:	3d 00 00 02 20       	cmp    $0x20020000,%eax
80002218:	75 b6                	jne    800021d0 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
8000221a:	8b 45 08             	mov    0x8(%ebp),%eax
8000221d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
80002223:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
80002228:	5d                   	pop    %ebp
80002229:	c3                   	ret    

8000222a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
8000222a:	55                   	push   %ebp
8000222b:	89 e5                	mov    %esp,%ebp
8000222d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
80002230:	83 f8 1f             	cmp    $0x1f,%eax
80002233:	77 36                	ja     8000226b <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
80002235:	05 00 00 02 00       	add    $0x20000,%eax
8000223a:	c1 e0 0c             	shl    $0xc,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
8000223d:	89 c2                	mov    %eax,%edx
8000223f:	c1 ea 16             	shr    $0x16,%edx
80002242:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
80002249:	f6 c2 01             	test   $0x1,%dl
8000224c:	74 24                	je     80002272 <fd_lookup+0x48>
8000224e:	89 c2                	mov    %eax,%edx
80002250:	c1 ea 0c             	shr    $0xc,%edx
80002253:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
8000225a:	f6 c2 01             	test   $0x1,%dl
8000225d:	74 1a                	je     80002279 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
8000225f:	8b 55 0c             	mov    0xc(%ebp),%edx
80002262:	89 02                	mov    %eax,(%edx)
	return 0;
80002264:	b8 00 00 00 00       	mov    $0x0,%eax
80002269:	eb 13                	jmp    8000227e <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
8000226b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80002270:	eb 0c                	jmp    8000227e <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
80002272:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80002277:	eb 05                	jmp    8000227e <fd_lookup+0x54>
80002279:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
8000227e:	5d                   	pop    %ebp
8000227f:	c3                   	ret    

80002280 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
80002280:	55                   	push   %ebp
80002281:	89 e5                	mov    %esp,%ebp
80002283:	53                   	push   %ebx
80002284:	83 ec 04             	sub    $0x4,%esp
80002287:	8b 45 08             	mov    0x8(%ebp),%eax
8000228a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
8000228d:	3b 05 20 50 00 80    	cmp    0x80005020,%eax
80002293:	75 1e                	jne    800022b3 <dev_lookup+0x33>
80002295:	eb 0e                	jmp    800022a5 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
80002297:	b8 3c 50 00 80       	mov    $0x8000503c,%eax
8000229c:	eb 0c                	jmp    800022aa <dev_lookup+0x2a>
8000229e:	b8 04 50 00 80       	mov    $0x80005004,%eax
800022a3:	eb 05                	jmp    800022aa <dev_lookup+0x2a>
800022a5:	b8 20 50 00 80       	mov    $0x80005020,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
800022aa:	89 03                	mov    %eax,(%ebx)
			return 0;
800022ac:	b8 00 00 00 00       	mov    $0x0,%eax
800022b1:	eb 36                	jmp    800022e9 <dev_lookup+0x69>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
800022b3:	3b 05 3c 50 00 80    	cmp    0x8000503c,%eax
800022b9:	74 dc                	je     80002297 <dev_lookup+0x17>
800022bb:	3b 05 04 50 00 80    	cmp    0x80005004,%eax
800022c1:	74 db                	je     8000229e <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
800022c3:	8b 15 20 64 00 80    	mov    0x80006420,%edx
800022c9:	8b 52 48             	mov    0x48(%edx),%edx
800022cc:	83 ec 04             	sub    $0x4,%esp
800022cf:	50                   	push   %eax
800022d0:	52                   	push   %edx
800022d1:	68 58 44 00 80       	push   $0x80004458
800022d6:	e8 74 1c 00 00       	call   80003f4f <cprintf>
	*dev = 0;
800022db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
800022e1:	83 c4 10             	add    $0x10,%esp
800022e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
800022e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800022ec:	c9                   	leave  
800022ed:	c3                   	ret    

800022ee <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
800022ee:	55                   	push   %ebp
800022ef:	89 e5                	mov    %esp,%ebp
800022f1:	56                   	push   %esi
800022f2:	53                   	push   %ebx
800022f3:	83 ec 10             	sub    $0x10,%esp
800022f6:	8b 75 08             	mov    0x8(%ebp),%esi
800022f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
800022fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
800022ff:	50                   	push   %eax
80002300:	8d 86 00 00 00 e0    	lea    -0x20000000(%esi),%eax
80002306:	c1 e8 0c             	shr    $0xc,%eax
80002309:	50                   	push   %eax
8000230a:	e8 1b ff ff ff       	call   8000222a <fd_lookup>
8000230f:	83 c4 08             	add    $0x8,%esp
80002312:	85 c0                	test   %eax,%eax
80002314:	78 05                	js     8000231b <fd_close+0x2d>
	    || fd != fd2)
80002316:	3b 75 f4             	cmp    -0xc(%ebp),%esi
80002319:	74 0c                	je     80002327 <fd_close+0x39>
		return (must_exist ? r : 0);
8000231b:	84 db                	test   %bl,%bl
8000231d:	ba 00 00 00 00       	mov    $0x0,%edx
80002322:	0f 44 c2             	cmove  %edx,%eax
80002325:	eb 41                	jmp    80002368 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
80002327:	83 ec 08             	sub    $0x8,%esp
8000232a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8000232d:	50                   	push   %eax
8000232e:	ff 36                	pushl  (%esi)
80002330:	e8 4b ff ff ff       	call   80002280 <dev_lookup>
80002335:	89 c3                	mov    %eax,%ebx
80002337:	83 c4 10             	add    $0x10,%esp
8000233a:	85 c0                	test   %eax,%eax
8000233c:	78 1a                	js     80002358 <fd_close+0x6a>
		if (dev->dev_close)
8000233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80002341:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
80002344:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
80002349:	85 c0                	test   %eax,%eax
8000234b:	74 0b                	je     80002358 <fd_close+0x6a>
			r = (*dev->dev_close)(fd);
8000234d:	83 ec 0c             	sub    $0xc,%esp
80002350:	56                   	push   %esi
80002351:	ff d0                	call   *%eax
80002353:	89 c3                	mov    %eax,%ebx
80002355:	83 c4 10             	add    $0x10,%esp
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
80002358:	83 ec 08             	sub    $0x8,%esp
8000235b:	56                   	push   %esi
8000235c:	6a 00                	push   $0x0
8000235e:	e8 2a fb ff ff       	call   80001e8d <sys_page_unmap>
	return r;
80002363:	83 c4 10             	add    $0x10,%esp
80002366:	89 d8                	mov    %ebx,%eax
}
80002368:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000236b:	5b                   	pop    %ebx
8000236c:	5e                   	pop    %esi
8000236d:	5d                   	pop    %ebp
8000236e:	c3                   	ret    

8000236f <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
8000236f:	55                   	push   %ebp
80002370:	89 e5                	mov    %esp,%ebp
80002372:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80002375:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002378:	50                   	push   %eax
80002379:	ff 75 08             	pushl  0x8(%ebp)
8000237c:	e8 a9 fe ff ff       	call   8000222a <fd_lookup>
80002381:	83 c4 08             	add    $0x8,%esp
80002384:	85 c0                	test   %eax,%eax
80002386:	78 10                	js     80002398 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
80002388:	83 ec 08             	sub    $0x8,%esp
8000238b:	6a 01                	push   $0x1
8000238d:	ff 75 f4             	pushl  -0xc(%ebp)
80002390:	e8 59 ff ff ff       	call   800022ee <fd_close>
80002395:	83 c4 10             	add    $0x10,%esp
}
80002398:	c9                   	leave  
80002399:	c3                   	ret    

8000239a <close_all>:

void
close_all(void)
{
8000239a:	55                   	push   %ebp
8000239b:	89 e5                	mov    %esp,%ebp
8000239d:	53                   	push   %ebx
8000239e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
800023a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
800023a6:	83 ec 0c             	sub    $0xc,%esp
800023a9:	53                   	push   %ebx
800023aa:	e8 c0 ff ff ff       	call   8000236f <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
800023af:	83 c3 01             	add    $0x1,%ebx
800023b2:	83 c4 10             	add    $0x10,%esp
800023b5:	83 fb 20             	cmp    $0x20,%ebx
800023b8:	75 ec                	jne    800023a6 <close_all+0xc>
		close(i);
}
800023ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800023bd:	c9                   	leave  
800023be:	c3                   	ret    

800023bf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
800023bf:	55                   	push   %ebp
800023c0:	89 e5                	mov    %esp,%ebp
800023c2:	57                   	push   %edi
800023c3:	56                   	push   %esi
800023c4:	53                   	push   %ebx
800023c5:	83 ec 2c             	sub    $0x2c,%esp
800023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *ova, *nva;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
800023cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
800023ce:	50                   	push   %eax
800023cf:	ff 75 08             	pushl  0x8(%ebp)
800023d2:	e8 53 fe ff ff       	call   8000222a <fd_lookup>
800023d7:	83 c4 08             	add    $0x8,%esp
800023da:	85 c0                	test   %eax,%eax
800023dc:	0f 88 bf 00 00 00    	js     800024a1 <dup+0xe2>
		return r;
	close(newfdnum);
800023e2:	83 ec 0c             	sub    $0xc,%esp
800023e5:	56                   	push   %esi
800023e6:	e8 84 ff ff ff       	call   8000236f <close>

	newfd = INDEX2FD(newfdnum);
800023eb:	8d 9e 00 00 02 00    	lea    0x20000(%esi),%ebx
800023f1:	c1 e3 0c             	shl    $0xc,%ebx
	ova = fd2data(oldfd);
800023f4:	83 c4 04             	add    $0x4,%esp
800023f7:	ff 75 e4             	pushl  -0x1c(%ebp)
800023fa:	e8 9f fd ff ff       	call   8000219e <fd2data>
800023ff:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
80002401:	89 1c 24             	mov    %ebx,(%esp)
80002404:	e8 95 fd ff ff       	call   8000219e <fd2data>
80002409:	83 c4 10             	add    $0x10,%esp
8000240c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
8000240f:	89 f8                	mov    %edi,%eax
80002411:	c1 e8 16             	shr    $0x16,%eax
80002414:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
8000241b:	a8 01                	test   $0x1,%al
8000241d:	74 37                	je     80002456 <dup+0x97>
8000241f:	89 f8                	mov    %edi,%eax
80002421:	c1 e8 0c             	shr    $0xc,%eax
80002424:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
8000242b:	f6 c2 01             	test   $0x1,%dl
8000242e:	74 26                	je     80002456 <dup+0x97>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
80002430:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80002437:	83 ec 0c             	sub    $0xc,%esp
8000243a:	25 07 0e 00 00       	and    $0xe07,%eax
8000243f:	50                   	push   %eax
80002440:	ff 75 d4             	pushl  -0x2c(%ebp)
80002443:	6a 00                	push   $0x0
80002445:	57                   	push   %edi
80002446:	6a 00                	push   $0x0
80002448:	e8 fe f9 ff ff       	call   80001e4b <sys_page_map>
8000244d:	89 c7                	mov    %eax,%edi
8000244f:	83 c4 20             	add    $0x20,%esp
80002452:	85 c0                	test   %eax,%eax
80002454:	78 2e                	js     80002484 <dup+0xc5>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
80002456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80002459:	89 d0                	mov    %edx,%eax
8000245b:	c1 e8 0c             	shr    $0xc,%eax
8000245e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80002465:	83 ec 0c             	sub    $0xc,%esp
80002468:	25 07 0e 00 00       	and    $0xe07,%eax
8000246d:	50                   	push   %eax
8000246e:	53                   	push   %ebx
8000246f:	6a 00                	push   $0x0
80002471:	52                   	push   %edx
80002472:	6a 00                	push   $0x0
80002474:	e8 d2 f9 ff ff       	call   80001e4b <sys_page_map>
80002479:	89 c7                	mov    %eax,%edi
8000247b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
8000247e:	89 f0                	mov    %esi,%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
80002480:	85 ff                	test   %edi,%edi
80002482:	79 1d                	jns    800024a1 <dup+0xe2>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
80002484:	83 ec 08             	sub    $0x8,%esp
80002487:	53                   	push   %ebx
80002488:	6a 00                	push   $0x0
8000248a:	e8 fe f9 ff ff       	call   80001e8d <sys_page_unmap>
	sys_page_unmap(0, nva);
8000248f:	83 c4 08             	add    $0x8,%esp
80002492:	ff 75 d4             	pushl  -0x2c(%ebp)
80002495:	6a 00                	push   $0x0
80002497:	e8 f1 f9 ff ff       	call   80001e8d <sys_page_unmap>
	return r;
8000249c:	83 c4 10             	add    $0x10,%esp
8000249f:	89 f8                	mov    %edi,%eax
}
800024a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
800024a4:	5b                   	pop    %ebx
800024a5:	5e                   	pop    %esi
800024a6:	5f                   	pop    %edi
800024a7:	5d                   	pop    %ebp
800024a8:	c3                   	ret    

800024a9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
800024a9:	55                   	push   %ebp
800024aa:	89 e5                	mov    %esp,%ebp
800024ac:	53                   	push   %ebx
800024ad:	83 ec 14             	sub    $0x14,%esp
800024b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
800024b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
800024b6:	50                   	push   %eax
800024b7:	53                   	push   %ebx
800024b8:	e8 6d fd ff ff       	call   8000222a <fd_lookup>
800024bd:	83 c4 08             	add    $0x8,%esp
800024c0:	89 c2                	mov    %eax,%edx
800024c2:	85 c0                	test   %eax,%eax
800024c4:	78 6d                	js     80002533 <read+0x8a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
800024c6:	83 ec 08             	sub    $0x8,%esp
800024c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
800024cc:	50                   	push   %eax
800024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
800024d0:	ff 30                	pushl  (%eax)
800024d2:	e8 a9 fd ff ff       	call   80002280 <dev_lookup>
800024d7:	83 c4 10             	add    $0x10,%esp
800024da:	85 c0                	test   %eax,%eax
800024dc:	78 4c                	js     8000252a <read+0x81>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
800024de:	8b 55 f0             	mov    -0x10(%ebp),%edx
800024e1:	8b 42 08             	mov    0x8(%edx),%eax
800024e4:	83 e0 03             	and    $0x3,%eax
800024e7:	83 f8 01             	cmp    $0x1,%eax
800024ea:	75 21                	jne    8000250d <read+0x64>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
800024ec:	a1 20 64 00 80       	mov    0x80006420,%eax
800024f1:	8b 40 48             	mov    0x48(%eax),%eax
800024f4:	83 ec 04             	sub    $0x4,%esp
800024f7:	53                   	push   %ebx
800024f8:	50                   	push   %eax
800024f9:	68 99 44 00 80       	push   $0x80004499
800024fe:	e8 4c 1a 00 00       	call   80003f4f <cprintf>
		return -E_INVAL;
80002503:	83 c4 10             	add    $0x10,%esp
80002506:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
8000250b:	eb 26                	jmp    80002533 <read+0x8a>
	}
	if (!dev->dev_read)
8000250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002510:	8b 40 08             	mov    0x8(%eax),%eax
80002513:	85 c0                	test   %eax,%eax
80002515:	74 17                	je     8000252e <read+0x85>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
80002517:	83 ec 04             	sub    $0x4,%esp
8000251a:	ff 75 10             	pushl  0x10(%ebp)
8000251d:	ff 75 0c             	pushl  0xc(%ebp)
80002520:	52                   	push   %edx
80002521:	ff d0                	call   *%eax
80002523:	89 c2                	mov    %eax,%edx
80002525:	83 c4 10             	add    $0x10,%esp
80002528:	eb 09                	jmp    80002533 <read+0x8a>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
8000252a:	89 c2                	mov    %eax,%edx
8000252c:	eb 05                	jmp    80002533 <read+0x8a>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
8000252e:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_read)(fd, buf, n);
}
80002533:	89 d0                	mov    %edx,%eax
80002535:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002538:	c9                   	leave  
80002539:	c3                   	ret    

8000253a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
8000253a:	55                   	push   %ebp
8000253b:	89 e5                	mov    %esp,%ebp
8000253d:	57                   	push   %edi
8000253e:	56                   	push   %esi
8000253f:	53                   	push   %ebx
80002540:	83 ec 0c             	sub    $0xc,%esp
80002543:	8b 7d 08             	mov    0x8(%ebp),%edi
80002546:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
80002549:	85 f6                	test   %esi,%esi
8000254b:	74 31                	je     8000257e <readn+0x44>
8000254d:	b8 00 00 00 00       	mov    $0x0,%eax
80002552:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
80002557:	83 ec 04             	sub    $0x4,%esp
8000255a:	89 f2                	mov    %esi,%edx
8000255c:	29 c2                	sub    %eax,%edx
8000255e:	52                   	push   %edx
8000255f:	03 45 0c             	add    0xc(%ebp),%eax
80002562:	50                   	push   %eax
80002563:	57                   	push   %edi
80002564:	e8 40 ff ff ff       	call   800024a9 <read>
		if (m < 0)
80002569:	83 c4 10             	add    $0x10,%esp
8000256c:	85 c0                	test   %eax,%eax
8000256e:	78 17                	js     80002587 <readn+0x4d>
			return m;
		if (m == 0)
80002570:	85 c0                	test   %eax,%eax
80002572:	74 11                	je     80002585 <readn+0x4b>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
80002574:	01 c3                	add    %eax,%ebx
80002576:	89 d8                	mov    %ebx,%eax
80002578:	39 f3                	cmp    %esi,%ebx
8000257a:	72 db                	jb     80002557 <readn+0x1d>
8000257c:	eb 09                	jmp    80002587 <readn+0x4d>
8000257e:	b8 00 00 00 00       	mov    $0x0,%eax
80002583:	eb 02                	jmp    80002587 <readn+0x4d>
80002585:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
80002587:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000258a:	5b                   	pop    %ebx
8000258b:	5e                   	pop    %esi
8000258c:	5f                   	pop    %edi
8000258d:	5d                   	pop    %ebp
8000258e:	c3                   	ret    

8000258f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
8000258f:	55                   	push   %ebp
80002590:	89 e5                	mov    %esp,%ebp
80002592:	53                   	push   %ebx
80002593:	83 ec 14             	sub    $0x14,%esp
80002596:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
80002599:	8d 45 f0             	lea    -0x10(%ebp),%eax
8000259c:	50                   	push   %eax
8000259d:	53                   	push   %ebx
8000259e:	e8 87 fc ff ff       	call   8000222a <fd_lookup>
800025a3:	83 c4 08             	add    $0x8,%esp
800025a6:	89 c2                	mov    %eax,%edx
800025a8:	85 c0                	test   %eax,%eax
800025aa:	78 68                	js     80002614 <write+0x85>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
800025ac:	83 ec 08             	sub    $0x8,%esp
800025af:	8d 45 f4             	lea    -0xc(%ebp),%eax
800025b2:	50                   	push   %eax
800025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
800025b6:	ff 30                	pushl  (%eax)
800025b8:	e8 c3 fc ff ff       	call   80002280 <dev_lookup>
800025bd:	83 c4 10             	add    $0x10,%esp
800025c0:	85 c0                	test   %eax,%eax
800025c2:	78 47                	js     8000260b <write+0x7c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
800025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
800025c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
800025cb:	75 21                	jne    800025ee <write+0x5f>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
800025cd:	a1 20 64 00 80       	mov    0x80006420,%eax
800025d2:	8b 40 48             	mov    0x48(%eax),%eax
800025d5:	83 ec 04             	sub    $0x4,%esp
800025d8:	53                   	push   %ebx
800025d9:	50                   	push   %eax
800025da:	68 b5 44 00 80       	push   $0x800044b5
800025df:	e8 6b 19 00 00       	call   80003f4f <cprintf>
		return -E_INVAL;
800025e4:	83 c4 10             	add    $0x10,%esp
800025e7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
800025ec:	eb 26                	jmp    80002614 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
800025ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
800025f1:	8b 52 0c             	mov    0xc(%edx),%edx
800025f4:	85 d2                	test   %edx,%edx
800025f6:	74 17                	je     8000260f <write+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
800025f8:	83 ec 04             	sub    $0x4,%esp
800025fb:	ff 75 10             	pushl  0x10(%ebp)
800025fe:	ff 75 0c             	pushl  0xc(%ebp)
80002601:	50                   	push   %eax
80002602:	ff d2                	call   *%edx
80002604:	89 c2                	mov    %eax,%edx
80002606:	83 c4 10             	add    $0x10,%esp
80002609:	eb 09                	jmp    80002614 <write+0x85>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
8000260b:	89 c2                	mov    %eax,%edx
8000260d:	eb 05                	jmp    80002614 <write+0x85>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
8000260f:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_write)(fd, buf, n);
}
80002614:	89 d0                	mov    %edx,%eax
80002616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002619:	c9                   	leave  
8000261a:	c3                   	ret    

8000261b <seek>:

int
seek(int fdnum, off_t offset)
{
8000261b:	55                   	push   %ebp
8000261c:	89 e5                	mov    %esp,%ebp
8000261e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80002621:	8d 45 fc             	lea    -0x4(%ebp),%eax
80002624:	50                   	push   %eax
80002625:	ff 75 08             	pushl  0x8(%ebp)
80002628:	e8 fd fb ff ff       	call   8000222a <fd_lookup>
8000262d:	83 c4 08             	add    $0x8,%esp
80002630:	85 c0                	test   %eax,%eax
80002632:	78 0e                	js     80002642 <seek+0x27>
		return r;
	fd->fd_offset = offset;
80002634:	8b 45 fc             	mov    -0x4(%ebp),%eax
80002637:	8b 55 0c             	mov    0xc(%ebp),%edx
8000263a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
8000263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80002642:	c9                   	leave  
80002643:	c3                   	ret    

80002644 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
80002644:	55                   	push   %ebp
80002645:	89 e5                	mov    %esp,%ebp
80002647:	53                   	push   %ebx
80002648:	83 ec 14             	sub    $0x14,%esp
8000264b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
8000264e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80002651:	50                   	push   %eax
80002652:	53                   	push   %ebx
80002653:	e8 d2 fb ff ff       	call   8000222a <fd_lookup>
80002658:	83 c4 08             	add    $0x8,%esp
8000265b:	89 c2                	mov    %eax,%edx
8000265d:	85 c0                	test   %eax,%eax
8000265f:	78 65                	js     800026c6 <ftruncate+0x82>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80002661:	83 ec 08             	sub    $0x8,%esp
80002664:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002667:	50                   	push   %eax
80002668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8000266b:	ff 30                	pushl  (%eax)
8000266d:	e8 0e fc ff ff       	call   80002280 <dev_lookup>
80002672:	83 c4 10             	add    $0x10,%esp
80002675:	85 c0                	test   %eax,%eax
80002677:	78 44                	js     800026bd <ftruncate+0x79>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
80002679:	8b 45 f0             	mov    -0x10(%ebp),%eax
8000267c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
80002680:	75 21                	jne    800026a3 <ftruncate+0x5f>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
80002682:	a1 20 64 00 80       	mov    0x80006420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
80002687:	8b 40 48             	mov    0x48(%eax),%eax
8000268a:	83 ec 04             	sub    $0x4,%esp
8000268d:	53                   	push   %ebx
8000268e:	50                   	push   %eax
8000268f:	68 78 44 00 80       	push   $0x80004478
80002694:	e8 b6 18 00 00       	call   80003f4f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
80002699:	83 c4 10             	add    $0x10,%esp
8000269c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
800026a1:	eb 23                	jmp    800026c6 <ftruncate+0x82>
	}
	if (!dev->dev_trunc)
800026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
800026a6:	8b 52 18             	mov    0x18(%edx),%edx
800026a9:	85 d2                	test   %edx,%edx
800026ab:	74 14                	je     800026c1 <ftruncate+0x7d>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
800026ad:	83 ec 08             	sub    $0x8,%esp
800026b0:	ff 75 0c             	pushl  0xc(%ebp)
800026b3:	50                   	push   %eax
800026b4:	ff d2                	call   *%edx
800026b6:	89 c2                	mov    %eax,%edx
800026b8:	83 c4 10             	add    $0x10,%esp
800026bb:	eb 09                	jmp    800026c6 <ftruncate+0x82>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
800026bd:	89 c2                	mov    %eax,%edx
800026bf:	eb 05                	jmp    800026c6 <ftruncate+0x82>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
800026c1:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	return (*dev->dev_trunc)(fd, newsize);
}
800026c6:	89 d0                	mov    %edx,%eax
800026c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800026cb:	c9                   	leave  
800026cc:	c3                   	ret    

800026cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
800026cd:	55                   	push   %ebp
800026ce:	89 e5                	mov    %esp,%ebp
800026d0:	53                   	push   %ebx
800026d1:	83 ec 14             	sub    $0x14,%esp
800026d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
800026d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
800026da:	50                   	push   %eax
800026db:	ff 75 08             	pushl  0x8(%ebp)
800026de:	e8 47 fb ff ff       	call   8000222a <fd_lookup>
800026e3:	83 c4 08             	add    $0x8,%esp
800026e6:	89 c2                	mov    %eax,%edx
800026e8:	85 c0                	test   %eax,%eax
800026ea:	78 4f                	js     8000273b <fstat+0x6e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
800026ec:	83 ec 08             	sub    $0x8,%esp
800026ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
800026f2:	50                   	push   %eax
800026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
800026f6:	ff 30                	pushl  (%eax)
800026f8:	e8 83 fb ff ff       	call   80002280 <dev_lookup>
800026fd:	83 c4 10             	add    $0x10,%esp
80002700:	85 c0                	test   %eax,%eax
80002702:	78 2e                	js     80002732 <fstat+0x65>
		return r;
	if (!dev->dev_stat)
80002704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002707:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
8000270b:	74 29                	je     80002736 <fstat+0x69>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
8000270d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
80002710:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	stat->st_isdir = 0;
80002717:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	stat->st_dev = dev;
8000271e:	89 43 18             	mov    %eax,0x18(%ebx)
	return (*dev->dev_stat)(fd, stat);
80002721:	83 ec 08             	sub    $0x8,%esp
80002724:	53                   	push   %ebx
80002725:	ff 75 f0             	pushl  -0x10(%ebp)
80002728:	ff 50 14             	call   *0x14(%eax)
8000272b:	89 c2                	mov    %eax,%edx
8000272d:	83 c4 10             	add    $0x10,%esp
80002730:	eb 09                	jmp    8000273b <fstat+0x6e>
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
80002732:	89 c2                	mov    %eax,%edx
80002734:	eb 05                	jmp    8000273b <fstat+0x6e>
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
80002736:	ba ef ff ff ff       	mov    $0xffffffef,%edx
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
8000273b:	89 d0                	mov    %edx,%eax
8000273d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002740:	c9                   	leave  
80002741:	c3                   	ret    

80002742 <stat>:

int
stat(const char *path, struct Stat *stat)
{
80002742:	55                   	push   %ebp
80002743:	89 e5                	mov    %esp,%ebp
80002745:	56                   	push   %esi
80002746:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
80002747:	83 ec 08             	sub    $0x8,%esp
8000274a:	6a 00                	push   $0x0
8000274c:	ff 75 08             	pushl  0x8(%ebp)
8000274f:	e8 a5 01 00 00       	call   800028f9 <open>
80002754:	89 c3                	mov    %eax,%ebx
80002756:	83 c4 10             	add    $0x10,%esp
80002759:	85 c0                	test   %eax,%eax
8000275b:	78 1b                	js     80002778 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
8000275d:	83 ec 08             	sub    $0x8,%esp
80002760:	ff 75 0c             	pushl  0xc(%ebp)
80002763:	50                   	push   %eax
80002764:	e8 64 ff ff ff       	call   800026cd <fstat>
80002769:	89 c6                	mov    %eax,%esi
	close(fd);
8000276b:	89 1c 24             	mov    %ebx,(%esp)
8000276e:	e8 fc fb ff ff       	call   8000236f <close>
	return r;
80002773:	83 c4 10             	add    $0x10,%esp
80002776:	89 f0                	mov    %esi,%eax
}
80002778:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000277b:	5b                   	pop    %ebx
8000277c:	5e                   	pop    %esi
8000277d:	5d                   	pop    %ebp
8000277e:	c3                   	ret    

8000277f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
8000277f:	55                   	push   %ebp
80002780:	89 e5                	mov    %esp,%ebp
80002782:	56                   	push   %esi
80002783:	53                   	push   %ebx
80002784:	89 c6                	mov    %eax,%esi
80002786:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
80002788:	83 3d 14 60 00 80 00 	cmpl   $0x0,0x80006014
8000278f:	75 12                	jne    800027a3 <fsipc+0x24>
		fsenv = ipc_find_env(ENV_TYPE_FS);
80002791:	83 ec 0c             	sub    $0xc,%esp
80002794:	6a 01                	push   $0x1
80002796:	e8 4b 06 00 00       	call   80002de6 <ipc_find_env>
8000279b:	a3 14 60 00 80       	mov    %eax,0x80006014
800027a0:	83 c4 10             	add    $0x10,%esp

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", 
			thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
800027a3:	6a 07                	push   $0x7
800027a5:	68 00 70 00 80       	push   $0x80007000
800027aa:	56                   	push   %esi
800027ab:	ff 35 14 60 00 80    	pushl  0x80006014
800027b1:	e8 dc 05 00 00       	call   80002d92 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
800027b6:	83 c4 0c             	add    $0xc,%esp
800027b9:	6a 00                	push   $0x0
800027bb:	53                   	push   %ebx
800027bc:	6a 00                	push   $0x0
800027be:	e8 4e 05 00 00       	call   80002d11 <ipc_recv>
}
800027c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
800027c6:	5b                   	pop    %ebx
800027c7:	5e                   	pop    %esi
800027c8:	5d                   	pop    %ebp
800027c9:	c3                   	ret    

800027ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
800027ca:	55                   	push   %ebp
800027cb:	89 e5                	mov    %esp,%ebp
800027cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
800027d0:	8b 45 08             	mov    0x8(%ebp),%eax
800027d3:	8b 40 0c             	mov    0xc(%eax),%eax
800027d6:	a3 00 70 00 80       	mov    %eax,0x80007000
	fsipcbuf.set_size.req_size = newsize;
800027db:	8b 45 0c             	mov    0xc(%ebp),%eax
800027de:	a3 04 70 00 80       	mov    %eax,0x80007004
	return fsipc(FSREQ_SET_SIZE, NULL);
800027e3:	ba 00 00 00 00       	mov    $0x0,%edx
800027e8:	b8 02 00 00 00       	mov    $0x2,%eax
800027ed:	e8 8d ff ff ff       	call   8000277f <fsipc>
}
800027f2:	c9                   	leave  
800027f3:	c3                   	ret    

800027f4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
800027f4:	55                   	push   %ebp
800027f5:	89 e5                	mov    %esp,%ebp
800027f7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
800027fa:	8b 45 08             	mov    0x8(%ebp),%eax
800027fd:	8b 40 0c             	mov    0xc(%eax),%eax
80002800:	a3 00 70 00 80       	mov    %eax,0x80007000
	return fsipc(FSREQ_FLUSH, NULL);
80002805:	ba 00 00 00 00       	mov    $0x0,%edx
8000280a:	b8 06 00 00 00       	mov    $0x6,%eax
8000280f:	e8 6b ff ff ff       	call   8000277f <fsipc>
}
80002814:	c9                   	leave  
80002815:	c3                   	ret    

80002816 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
80002816:	55                   	push   %ebp
80002817:	89 e5                	mov    %esp,%ebp
80002819:	53                   	push   %ebx
8000281a:	83 ec 04             	sub    $0x4,%esp
8000281d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
80002820:	8b 45 08             	mov    0x8(%ebp),%eax
80002823:	8b 40 0c             	mov    0xc(%eax),%eax
80002826:	a3 00 70 00 80       	mov    %eax,0x80007000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
8000282b:	ba 00 00 00 00       	mov    $0x0,%edx
80002830:	b8 05 00 00 00       	mov    $0x5,%eax
80002835:	e8 45 ff ff ff       	call   8000277f <fsipc>
8000283a:	85 c0                	test   %eax,%eax
8000283c:	78 26                	js     80002864 <devfile_stat+0x4e>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
8000283e:	83 ec 08             	sub    $0x8,%esp
80002841:	68 00 70 00 80       	push   $0x80007000
80002846:	53                   	push   %ebx
80002847:	e8 d9 f0 ff ff       	call   80001925 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
8000284c:	a1 10 70 00 80       	mov    0x80007010,%eax
80002851:	89 43 10             	mov    %eax,0x10(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
80002854:	a1 14 70 00 80       	mov    0x80007014,%eax
80002859:	89 43 14             	mov    %eax,0x14(%ebx)
	return 0;
8000285c:	83 c4 10             	add    $0x10,%esp
8000285f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80002864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002867:	c9                   	leave  
80002868:	c3                   	ret    

80002869 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
80002869:	55                   	push   %ebp
8000286a:	89 e5                	mov    %esp,%ebp
8000286c:	83 ec 0c             	sub    $0xc,%esp
8000286f:	8b 45 10             	mov    0x10(%ebp),%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	// panic("devfile_write not implemented");
	int max = PGSIZE - (sizeof(int) + sizeof(size_t));
	n = n > max ? max : n;
80002872:	3d f8 0f 00 00       	cmp    $0xff8,%eax
80002877:	ba f8 0f 00 00       	mov    $0xff8,%edx
8000287c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
8000287f:	8b 55 08             	mov    0x8(%ebp),%edx
80002882:	8b 52 0c             	mov    0xc(%edx),%edx
80002885:	89 15 00 70 00 80    	mov    %edx,0x80007000
	fsipcbuf.write.req_n = n;
8000288b:	a3 04 70 00 80       	mov    %eax,0x80007004
	memmove(fsipcbuf.write.req_buf, buf, n);
80002890:	50                   	push   %eax
80002891:	ff 75 0c             	pushl  0xc(%ebp)
80002894:	68 08 70 00 80       	push   $0x80007008
80002899:	e8 76 f2 ff ff       	call   80001b14 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
8000289e:	ba 00 00 00 00       	mov    $0x0,%edx
800028a3:	b8 04 00 00 00       	mov    $0x4,%eax
800028a8:	e8 d2 fe ff ff       	call   8000277f <fsipc>
}
800028ad:	c9                   	leave  
800028ae:	c3                   	ret    

800028af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
800028af:	55                   	push   %ebp
800028b0:	89 e5                	mov    %esp,%ebp
800028b2:	53                   	push   %ebx
800028b3:	83 ec 04             	sub    $0x4,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
800028b6:	8b 45 08             	mov    0x8(%ebp),%eax
800028b9:	8b 40 0c             	mov    0xc(%eax),%eax
800028bc:	a3 00 70 00 80       	mov    %eax,0x80007000
	fsipcbuf.read.req_n = n;
800028c1:	8b 45 10             	mov    0x10(%ebp),%eax
800028c4:	a3 04 70 00 80       	mov    %eax,0x80007004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
800028c9:	ba 00 00 00 00       	mov    $0x0,%edx
800028ce:	b8 03 00 00 00       	mov    $0x3,%eax
800028d3:	e8 a7 fe ff ff       	call   8000277f <fsipc>
800028d8:	89 c3                	mov    %eax,%ebx
800028da:	85 c0                	test   %eax,%eax
800028dc:	78 14                	js     800028f2 <devfile_read+0x43>
		return r;
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
800028de:	83 ec 04             	sub    $0x4,%esp
800028e1:	50                   	push   %eax
800028e2:	68 00 70 00 80       	push   $0x80007000
800028e7:	ff 75 0c             	pushl  0xc(%ebp)
800028ea:	e8 25 f2 ff ff       	call   80001b14 <memmove>
	return r;
800028ef:	83 c4 10             	add    $0x10,%esp
}
800028f2:	89 d8                	mov    %ebx,%eax
800028f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800028f7:	c9                   	leave  
800028f8:	c3                   	ret    

800028f9 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
800028f9:	55                   	push   %ebp
800028fa:	89 e5                	mov    %esp,%ebp
800028fc:	53                   	push   %ebx
800028fd:	83 ec 20             	sub    $0x20,%esp
80002900:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
80002903:	53                   	push   %ebx
80002904:	e8 c1 ef ff ff       	call   800018ca <strlen>
80002909:	83 c4 10             	add    $0x10,%esp
8000290c:	83 f8 7f             	cmp    $0x7f,%eax
8000290f:	7f 67                	jg     80002978 <open+0x7f>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
80002911:	83 ec 0c             	sub    $0xc,%esp
80002914:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002917:	50                   	push   %eax
80002918:	e8 99 f8 ff ff       	call   800021b6 <fd_alloc>
8000291d:	83 c4 10             	add    $0x10,%esp
		return r;
80002920:	89 c2                	mov    %eax,%edx
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
80002922:	85 c0                	test   %eax,%eax
80002924:	78 57                	js     8000297d <open+0x84>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
80002926:	83 ec 08             	sub    $0x8,%esp
80002929:	53                   	push   %ebx
8000292a:	68 00 70 00 80       	push   $0x80007000
8000292f:	e8 f1 ef ff ff       	call   80001925 <strcpy>
	fsipcbuf.open.req_omode = mode;
80002934:	8b 45 0c             	mov    0xc(%ebp),%eax
80002937:	a3 80 70 00 80       	mov    %eax,0x80007080

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
8000293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8000293f:	b8 01 00 00 00       	mov    $0x1,%eax
80002944:	e8 36 fe ff ff       	call   8000277f <fsipc>
80002949:	89 c3                	mov    %eax,%ebx
8000294b:	83 c4 10             	add    $0x10,%esp
8000294e:	85 c0                	test   %eax,%eax
80002950:	79 14                	jns    80002966 <open+0x6d>
		fd_close(fd, 0);
80002952:	83 ec 08             	sub    $0x8,%esp
80002955:	6a 00                	push   $0x0
80002957:	ff 75 f4             	pushl  -0xc(%ebp)
8000295a:	e8 8f f9 ff ff       	call   800022ee <fd_close>
		return r;
8000295f:	83 c4 10             	add    $0x10,%esp
80002962:	89 da                	mov    %ebx,%edx
80002964:	eb 17                	jmp    8000297d <open+0x84>
	}

	return fd2num(fd);
80002966:	83 ec 0c             	sub    $0xc,%esp
80002969:	ff 75 f4             	pushl  -0xc(%ebp)
8000296c:	e8 1d f8 ff ff       	call   8000218e <fd2num>
80002971:	89 c2                	mov    %eax,%edx
80002973:	83 c4 10             	add    $0x10,%esp
80002976:	eb 05                	jmp    8000297d <open+0x84>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
80002978:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
8000297d:	89 d0                	mov    %edx,%eax
8000297f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002982:	c9                   	leave  
80002983:	c3                   	ret    

80002984 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
80002984:	55                   	push   %ebp
80002985:	89 e5                	mov    %esp,%ebp
80002987:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
8000298a:	ba 00 00 00 00       	mov    $0x0,%edx
8000298f:	b8 09 00 00 00       	mov    $0x9,%eax
80002994:	e8 e6 fd ff ff       	call   8000277f <fsipc>
}
80002999:	c9                   	leave  
8000299a:	c3                   	ret    

8000299b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
8000299b:	55                   	push   %ebp
8000299c:	89 e5                	mov    %esp,%ebp
8000299e:	56                   	push   %esi
8000299f:	53                   	push   %ebx
800029a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
800029a3:	83 ec 0c             	sub    $0xc,%esp
800029a6:	ff 75 08             	pushl  0x8(%ebp)
800029a9:	e8 f0 f7 ff ff       	call   8000219e <fd2data>
800029ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
800029b0:	83 c4 08             	add    $0x8,%esp
800029b3:	68 d2 44 00 80       	push   $0x800044d2
800029b8:	53                   	push   %ebx
800029b9:	e8 67 ef ff ff       	call   80001925 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
800029be:	8b 46 04             	mov    0x4(%esi),%eax
800029c1:	2b 06                	sub    (%esi),%eax
800029c3:	89 43 10             	mov    %eax,0x10(%ebx)
	stat->st_isdir = 0;
800029c6:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
	stat->st_dev = &devpipe;
800029cd:	c7 43 18 3c 50 00 80 	movl   $0x8000503c,0x18(%ebx)
	return 0;
}
800029d4:	b8 00 00 00 00       	mov    $0x0,%eax
800029d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
800029dc:	5b                   	pop    %ebx
800029dd:	5e                   	pop    %esi
800029de:	5d                   	pop    %ebp
800029df:	c3                   	ret    

800029e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
800029e0:	55                   	push   %ebp
800029e1:	89 e5                	mov    %esp,%ebp
800029e3:	53                   	push   %ebx
800029e4:	83 ec 0c             	sub    $0xc,%esp
800029e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
800029ea:	53                   	push   %ebx
800029eb:	6a 00                	push   $0x0
800029ed:	e8 9b f4 ff ff       	call   80001e8d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
800029f2:	89 1c 24             	mov    %ebx,(%esp)
800029f5:	e8 a4 f7 ff ff       	call   8000219e <fd2data>
800029fa:	83 c4 08             	add    $0x8,%esp
800029fd:	50                   	push   %eax
800029fe:	6a 00                	push   $0x0
80002a00:	e8 88 f4 ff ff       	call   80001e8d <sys_page_unmap>
}
80002a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002a08:	c9                   	leave  
80002a09:	c3                   	ret    

80002a0a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
80002a0a:	55                   	push   %ebp
80002a0b:	89 e5                	mov    %esp,%ebp
80002a0d:	57                   	push   %edi
80002a0e:	56                   	push   %esi
80002a0f:	53                   	push   %ebx
80002a10:	83 ec 1c             	sub    $0x1c,%esp
80002a13:	89 45 e0             	mov    %eax,-0x20(%ebp)
80002a16:	89 d7                	mov    %edx,%edi
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
80002a18:	a1 20 64 00 80       	mov    0x80006420,%eax
80002a1d:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
80002a20:	83 ec 0c             	sub    $0xc,%esp
80002a23:	ff 75 e0             	pushl  -0x20(%ebp)
80002a26:	e8 3b 0d 00 00       	call   80003766 <pageref>
80002a2b:	89 c3                	mov    %eax,%ebx
80002a2d:	89 3c 24             	mov    %edi,(%esp)
80002a30:	e8 31 0d 00 00       	call   80003766 <pageref>
80002a35:	83 c4 10             	add    $0x10,%esp
80002a38:	39 c3                	cmp    %eax,%ebx
80002a3a:	0f 94 c1             	sete   %cl
80002a3d:	0f b6 c9             	movzbl %cl,%ecx
80002a40:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		nn = thisenv->env_runs;
80002a43:	8b 15 20 64 00 80    	mov    0x80006420,%edx
80002a49:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
80002a4c:	39 ce                	cmp    %ecx,%esi
80002a4e:	74 1b                	je     80002a6b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
80002a50:	39 c3                	cmp    %eax,%ebx
80002a52:	75 c4                	jne    80002a18 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
80002a54:	8b 42 58             	mov    0x58(%edx),%eax
80002a57:	ff 75 e4             	pushl  -0x1c(%ebp)
80002a5a:	50                   	push   %eax
80002a5b:	56                   	push   %esi
80002a5c:	68 d9 44 00 80       	push   $0x800044d9
80002a61:	e8 e9 14 00 00       	call   80003f4f <cprintf>
80002a66:	83 c4 10             	add    $0x10,%esp
80002a69:	eb ad                	jmp    80002a18 <_pipeisclosed+0xe>
	}
}
80002a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80002a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002a71:	5b                   	pop    %ebx
80002a72:	5e                   	pop    %esi
80002a73:	5f                   	pop    %edi
80002a74:	5d                   	pop    %ebp
80002a75:	c3                   	ret    

80002a76 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
80002a76:	55                   	push   %ebp
80002a77:	89 e5                	mov    %esp,%ebp
80002a79:	57                   	push   %edi
80002a7a:	56                   	push   %esi
80002a7b:	53                   	push   %ebx
80002a7c:	83 ec 28             	sub    $0x28,%esp
80002a7f:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
80002a82:	56                   	push   %esi
80002a83:	e8 16 f7 ff ff       	call   8000219e <fd2data>
80002a88:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002a8a:	83 c4 10             	add    $0x10,%esp
80002a8d:	bf 00 00 00 00       	mov    $0x0,%edi
80002a92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80002a96:	75 52                	jne    80002aea <devpipe_write+0x74>
80002a98:	eb 5e                	jmp    80002af8 <devpipe_write+0x82>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
80002a9a:	89 da                	mov    %ebx,%edx
80002a9c:	89 f0                	mov    %esi,%eax
80002a9e:	e8 67 ff ff ff       	call   80002a0a <_pipeisclosed>
80002aa3:	85 c0                	test   %eax,%eax
80002aa5:	75 56                	jne    80002afd <devpipe_write+0x87>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
80002aa7:	e8 3d f3 ff ff       	call   80001de9 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
80002aac:	8b 43 04             	mov    0x4(%ebx),%eax
80002aaf:	8b 0b                	mov    (%ebx),%ecx
80002ab1:	8d 51 20             	lea    0x20(%ecx),%edx
80002ab4:	39 d0                	cmp    %edx,%eax
80002ab6:	73 e2                	jae    80002a9a <devpipe_write+0x24>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
80002ab8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002abb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
80002abf:	88 4d e7             	mov    %cl,-0x19(%ebp)
80002ac2:	89 c2                	mov    %eax,%edx
80002ac4:	c1 fa 1f             	sar    $0x1f,%edx
80002ac7:	89 d1                	mov    %edx,%ecx
80002ac9:	c1 e9 1b             	shr    $0x1b,%ecx
80002acc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80002acf:	83 e2 1f             	and    $0x1f,%edx
80002ad2:	29 ca                	sub    %ecx,%edx
80002ad4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
80002ad8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
80002adc:	83 c0 01             	add    $0x1,%eax
80002adf:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002ae2:	83 c7 01             	add    $0x1,%edi
80002ae5:	39 7d 10             	cmp    %edi,0x10(%ebp)
80002ae8:	74 0e                	je     80002af8 <devpipe_write+0x82>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
80002aea:	8b 43 04             	mov    0x4(%ebx),%eax
80002aed:	8b 0b                	mov    (%ebx),%ecx
80002aef:	8d 51 20             	lea    0x20(%ecx),%edx
80002af2:	39 d0                	cmp    %edx,%eax
80002af4:	73 a4                	jae    80002a9a <devpipe_write+0x24>
80002af6:	eb c0                	jmp    80002ab8 <devpipe_write+0x42>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
80002af8:	8b 45 10             	mov    0x10(%ebp),%eax
80002afb:	eb 05                	jmp    80002b02 <devpipe_write+0x8c>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
80002afd:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
80002b02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002b05:	5b                   	pop    %ebx
80002b06:	5e                   	pop    %esi
80002b07:	5f                   	pop    %edi
80002b08:	5d                   	pop    %ebp
80002b09:	c3                   	ret    

80002b0a <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
80002b0a:	55                   	push   %ebp
80002b0b:	89 e5                	mov    %esp,%ebp
80002b0d:	57                   	push   %edi
80002b0e:	56                   	push   %esi
80002b0f:	53                   	push   %ebx
80002b10:	83 ec 18             	sub    $0x18,%esp
80002b13:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
80002b16:	57                   	push   %edi
80002b17:	e8 82 f6 ff ff       	call   8000219e <fd2data>
80002b1c:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002b1e:	83 c4 10             	add    $0x10,%esp
80002b21:	be 00 00 00 00       	mov    $0x0,%esi
80002b26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80002b2a:	75 40                	jne    80002b6c <devpipe_read+0x62>
80002b2c:	eb 4b                	jmp    80002b79 <devpipe_read+0x6f>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
80002b2e:	89 f0                	mov    %esi,%eax
80002b30:	eb 51                	jmp    80002b83 <devpipe_read+0x79>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
80002b32:	89 da                	mov    %ebx,%edx
80002b34:	89 f8                	mov    %edi,%eax
80002b36:	e8 cf fe ff ff       	call   80002a0a <_pipeisclosed>
80002b3b:	85 c0                	test   %eax,%eax
80002b3d:	75 3f                	jne    80002b7e <devpipe_read+0x74>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
80002b3f:	e8 a5 f2 ff ff       	call   80001de9 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
80002b44:	8b 03                	mov    (%ebx),%eax
80002b46:	3b 43 04             	cmp    0x4(%ebx),%eax
80002b49:	74 e7                	je     80002b32 <devpipe_read+0x28>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
80002b4b:	99                   	cltd   
80002b4c:	c1 ea 1b             	shr    $0x1b,%edx
80002b4f:	01 d0                	add    %edx,%eax
80002b51:	83 e0 1f             	and    $0x1f,%eax
80002b54:	29 d0                	sub    %edx,%eax
80002b56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
80002b5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002b5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
80002b61:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
80002b64:	83 c6 01             	add    $0x1,%esi
80002b67:	39 75 10             	cmp    %esi,0x10(%ebp)
80002b6a:	74 0d                	je     80002b79 <devpipe_read+0x6f>
		while (p->p_rpos == p->p_wpos) {
80002b6c:	8b 03                	mov    (%ebx),%eax
80002b6e:	3b 43 04             	cmp    0x4(%ebx),%eax
80002b71:	75 d8                	jne    80002b4b <devpipe_read+0x41>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
80002b73:	85 f6                	test   %esi,%esi
80002b75:	75 b7                	jne    80002b2e <devpipe_read+0x24>
80002b77:	eb b9                	jmp    80002b32 <devpipe_read+0x28>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
80002b79:	8b 45 10             	mov    0x10(%ebp),%eax
80002b7c:	eb 05                	jmp    80002b83 <devpipe_read+0x79>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
80002b7e:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
80002b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002b86:	5b                   	pop    %ebx
80002b87:	5e                   	pop    %esi
80002b88:	5f                   	pop    %edi
80002b89:	5d                   	pop    %ebp
80002b8a:	c3                   	ret    

80002b8b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
80002b8b:	55                   	push   %ebp
80002b8c:	89 e5                	mov    %esp,%ebp
80002b8e:	56                   	push   %esi
80002b8f:	53                   	push   %ebx
80002b90:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
80002b93:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002b96:	50                   	push   %eax
80002b97:	e8 1a f6 ff ff       	call   800021b6 <fd_alloc>
80002b9c:	83 c4 10             	add    $0x10,%esp
80002b9f:	89 c2                	mov    %eax,%edx
80002ba1:	85 c0                	test   %eax,%eax
80002ba3:	0f 88 2c 01 00 00    	js     80002cd5 <pipe+0x14a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002ba9:	83 ec 04             	sub    $0x4,%esp
80002bac:	68 07 04 00 00       	push   $0x407
80002bb1:	ff 75 f4             	pushl  -0xc(%ebp)
80002bb4:	6a 00                	push   $0x0
80002bb6:	e8 4d f2 ff ff       	call   80001e08 <sys_page_alloc>
80002bbb:	83 c4 10             	add    $0x10,%esp
80002bbe:	89 c2                	mov    %eax,%edx
80002bc0:	85 c0                	test   %eax,%eax
80002bc2:	0f 88 0d 01 00 00    	js     80002cd5 <pipe+0x14a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
80002bc8:	83 ec 0c             	sub    $0xc,%esp
80002bcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80002bce:	50                   	push   %eax
80002bcf:	e8 e2 f5 ff ff       	call   800021b6 <fd_alloc>
80002bd4:	89 c3                	mov    %eax,%ebx
80002bd6:	83 c4 10             	add    $0x10,%esp
80002bd9:	85 c0                	test   %eax,%eax
80002bdb:	0f 88 e2 00 00 00    	js     80002cc3 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002be1:	83 ec 04             	sub    $0x4,%esp
80002be4:	68 07 04 00 00       	push   $0x407
80002be9:	ff 75 f0             	pushl  -0x10(%ebp)
80002bec:	6a 00                	push   $0x0
80002bee:	e8 15 f2 ff ff       	call   80001e08 <sys_page_alloc>
80002bf3:	89 c3                	mov    %eax,%ebx
80002bf5:	83 c4 10             	add    $0x10,%esp
80002bf8:	85 c0                	test   %eax,%eax
80002bfa:	0f 88 c3 00 00 00    	js     80002cc3 <pipe+0x138>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
80002c00:	83 ec 0c             	sub    $0xc,%esp
80002c03:	ff 75 f4             	pushl  -0xc(%ebp)
80002c06:	e8 93 f5 ff ff       	call   8000219e <fd2data>
80002c0b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002c0d:	83 c4 0c             	add    $0xc,%esp
80002c10:	68 07 04 00 00       	push   $0x407
80002c15:	50                   	push   %eax
80002c16:	6a 00                	push   $0x0
80002c18:	e8 eb f1 ff ff       	call   80001e08 <sys_page_alloc>
80002c1d:	89 c3                	mov    %eax,%ebx
80002c1f:	83 c4 10             	add    $0x10,%esp
80002c22:	85 c0                	test   %eax,%eax
80002c24:	0f 88 89 00 00 00    	js     80002cb3 <pipe+0x128>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
80002c2a:	83 ec 0c             	sub    $0xc,%esp
80002c2d:	ff 75 f0             	pushl  -0x10(%ebp)
80002c30:	e8 69 f5 ff ff       	call   8000219e <fd2data>
80002c35:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
80002c3c:	50                   	push   %eax
80002c3d:	6a 00                	push   $0x0
80002c3f:	56                   	push   %esi
80002c40:	6a 00                	push   $0x0
80002c42:	e8 04 f2 ff ff       	call   80001e4b <sys_page_map>
80002c47:	89 c3                	mov    %eax,%ebx
80002c49:	83 c4 20             	add    $0x20,%esp
80002c4c:	85 c0                	test   %eax,%eax
80002c4e:	78 55                	js     80002ca5 <pipe+0x11a>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
80002c50:	8b 15 3c 50 00 80    	mov    0x8000503c,%edx
80002c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002c59:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
80002c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002c5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
80002c65:	8b 15 3c 50 00 80    	mov    0x8000503c,%edx
80002c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80002c6e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
80002c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80002c73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
80002c7a:	83 ec 0c             	sub    $0xc,%esp
80002c7d:	ff 75 f4             	pushl  -0xc(%ebp)
80002c80:	e8 09 f5 ff ff       	call   8000218e <fd2num>
80002c85:	8b 4d 08             	mov    0x8(%ebp),%ecx
80002c88:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
80002c8a:	83 c4 04             	add    $0x4,%esp
80002c8d:	ff 75 f0             	pushl  -0x10(%ebp)
80002c90:	e8 f9 f4 ff ff       	call   8000218e <fd2num>
80002c95:	8b 4d 08             	mov    0x8(%ebp),%ecx
80002c98:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
80002c9b:	83 c4 10             	add    $0x10,%esp
80002c9e:	ba 00 00 00 00       	mov    $0x0,%edx
80002ca3:	eb 30                	jmp    80002cd5 <pipe+0x14a>

    err3:
	sys_page_unmap(0, va);
80002ca5:	83 ec 08             	sub    $0x8,%esp
80002ca8:	56                   	push   %esi
80002ca9:	6a 00                	push   $0x0
80002cab:	e8 dd f1 ff ff       	call   80001e8d <sys_page_unmap>
80002cb0:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
80002cb3:	83 ec 08             	sub    $0x8,%esp
80002cb6:	ff 75 f0             	pushl  -0x10(%ebp)
80002cb9:	6a 00                	push   $0x0
80002cbb:	e8 cd f1 ff ff       	call   80001e8d <sys_page_unmap>
80002cc0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
80002cc3:	83 ec 08             	sub    $0x8,%esp
80002cc6:	ff 75 f4             	pushl  -0xc(%ebp)
80002cc9:	6a 00                	push   $0x0
80002ccb:	e8 bd f1 ff ff       	call   80001e8d <sys_page_unmap>
80002cd0:	83 c4 10             	add    $0x10,%esp
80002cd3:	89 da                	mov    %ebx,%edx
    err:
	return r;
}
80002cd5:	89 d0                	mov    %edx,%eax
80002cd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002cda:	5b                   	pop    %ebx
80002cdb:	5e                   	pop    %esi
80002cdc:	5d                   	pop    %ebp
80002cdd:	c3                   	ret    

80002cde <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
80002cde:	55                   	push   %ebp
80002cdf:	89 e5                	mov    %esp,%ebp
80002ce1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
80002ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002ce7:	50                   	push   %eax
80002ce8:	ff 75 08             	pushl  0x8(%ebp)
80002ceb:	e8 3a f5 ff ff       	call   8000222a <fd_lookup>
80002cf0:	83 c4 10             	add    $0x10,%esp
80002cf3:	85 c0                	test   %eax,%eax
80002cf5:	78 18                	js     80002d0f <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
80002cf7:	83 ec 0c             	sub    $0xc,%esp
80002cfa:	ff 75 f4             	pushl  -0xc(%ebp)
80002cfd:	e8 9c f4 ff ff       	call   8000219e <fd2data>
	return _pipeisclosed(fd, p);
80002d02:	89 c2                	mov    %eax,%edx
80002d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002d07:	e8 fe fc ff ff       	call   80002a0a <_pipeisclosed>
80002d0c:	83 c4 10             	add    $0x10,%esp
}
80002d0f:	c9                   	leave  
80002d10:	c3                   	ret    

80002d11 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
80002d11:	55                   	push   %ebp
80002d12:	89 e5                	mov    %esp,%ebp
80002d14:	56                   	push   %esi
80002d15:	53                   	push   %ebx
80002d16:	8b 75 08             	mov    0x8(%ebp),%esi
80002d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80002d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int r;
	if(!pg)
80002d1f:	85 c0                	test   %eax,%eax
		pg = (void *)-1;	// all 1
80002d21:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80002d26:	0f 44 c2             	cmove  %edx,%eax
	if((r = sys_ipc_recv(pg)) < 0)
80002d29:	83 ec 0c             	sub    $0xc,%esp
80002d2c:	50                   	push   %eax
80002d2d:	e8 86 f2 ff ff       	call   80001fb8 <sys_ipc_recv>
80002d32:	83 c4 10             	add    $0x10,%esp
80002d35:	85 c0                	test   %eax,%eax
80002d37:	79 10                	jns    80002d49 <ipc_recv+0x38>
	{
		if(from_env_store)
80002d39:	85 f6                	test   %esi,%esi
80002d3b:	74 40                	je     80002d7d <ipc_recv+0x6c>
			*from_env_store = 0;
80002d3d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
80002d43:	85 db                	test   %ebx,%ebx
80002d45:	74 20                	je     80002d67 <ipc_recv+0x56>
80002d47:	eb 24                	jmp    80002d6d <ipc_recv+0x5c>
			*perm_store = 0;
	}
	if(from_env_store)
80002d49:	85 f6                	test   %esi,%esi
80002d4b:	74 0a                	je     80002d57 <ipc_recv+0x46>
		*from_env_store = thisenv->env_ipc_from;
80002d4d:	a1 20 64 00 80       	mov    0x80006420,%eax
80002d52:	8b 40 74             	mov    0x74(%eax),%eax
80002d55:	89 06                	mov    %eax,(%esi)
	if(perm_store)
80002d57:	85 db                	test   %ebx,%ebx
80002d59:	74 28                	je     80002d83 <ipc_recv+0x72>
		*perm_store = thisenv->env_ipc_perm;
80002d5b:	a1 20 64 00 80       	mov    0x80006420,%eax
80002d60:	8b 40 78             	mov    0x78(%eax),%eax
80002d63:	89 03                	mov    %eax,(%ebx)
80002d65:	eb 1c                	jmp    80002d83 <ipc_recv+0x72>
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
	}
	if(from_env_store)
80002d67:	85 f6                	test   %esi,%esi
80002d69:	75 e2                	jne    80002d4d <ipc_recv+0x3c>
80002d6b:	eb 16                	jmp    80002d83 <ipc_recv+0x72>
	if((r = sys_ipc_recv(pg)) < 0)
	{
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
80002d6d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80002d73:	eb d8                	jmp    80002d4d <ipc_recv+0x3c>
80002d75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80002d7b:	eb de                	jmp    80002d5b <ipc_recv+0x4a>
		pg = (void *)-1;	// all 1
	if((r = sys_ipc_recv(pg)) < 0)
	{
		if(from_env_store)
			*from_env_store = 0;
		if(perm_store)
80002d7d:	85 db                	test   %ebx,%ebx
80002d7f:	75 f4                	jne    80002d75 <ipc_recv+0x64>
80002d81:	eb e4                	jmp    80002d67 <ipc_recv+0x56>
	}
	if(from_env_store)
		*from_env_store = thisenv->env_ipc_from;
	if(perm_store)
		*perm_store = thisenv->env_ipc_perm;
	return thisenv->env_ipc_value;
80002d83:	a1 20 64 00 80       	mov    0x80006420,%eax
80002d88:	8b 40 70             	mov    0x70(%eax),%eax
}
80002d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002d8e:	5b                   	pop    %ebx
80002d8f:	5e                   	pop    %esi
80002d90:	5d                   	pop    %ebp
80002d91:	c3                   	ret    

80002d92 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
80002d92:	55                   	push   %ebp
80002d93:	89 e5                	mov    %esp,%ebp
80002d95:	57                   	push   %edi
80002d96:	56                   	push   %esi
80002d97:	53                   	push   %ebx
80002d98:	83 ec 0c             	sub    $0xc,%esp
80002d9b:	8b 7d 08             	mov    0x8(%ebp),%edi
80002d9e:	8b 75 0c             	mov    0xc(%ebp),%esi
80002da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	int r;
	if(!pg)
80002da4:	85 db                	test   %ebx,%ebx
		pg = (void *)-1;	// all 1
80002da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80002dab:	0f 44 d8             	cmove  %eax,%ebx
80002dae:	eb 1c                	jmp    80002dcc <ipc_send+0x3a>
	while((r = sys_ipc_try_send(to_env, val, pg, perm)))
	{
		if(r == 0)
			break;
		if(r != -E_IPC_NOT_RECV)
80002db0:	83 f8 f9             	cmp    $0xfffffff9,%eax
80002db3:	74 12                	je     80002dc7 <ipc_send+0x35>
			panic("ipc_send : %e", r);
80002db5:	50                   	push   %eax
80002db6:	68 f1 44 00 80       	push   $0x800044f1
80002dbb:	6a 41                	push   $0x41
80002dbd:	68 ff 44 00 80       	push   $0x800044ff
80002dc2:	e8 b0 13 00 00       	call   80004177 <_panic>
		sys_yield();
80002dc7:	e8 1d f0 ff ff       	call   80001de9 <sys_yield>
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
	int r;
	if(!pg)
		pg = (void *)-1;	// all 1
	while((r = sys_ipc_try_send(to_env, val, pg, perm)))
80002dcc:	ff 75 14             	pushl  0x14(%ebp)
80002dcf:	53                   	push   %ebx
80002dd0:	56                   	push   %esi
80002dd1:	57                   	push   %edi
80002dd2:	e8 be f1 ff ff       	call   80001f95 <sys_ipc_try_send>
	{
		if(r == 0)
80002dd7:	83 c4 10             	add    $0x10,%esp
80002dda:	85 c0                	test   %eax,%eax
80002ddc:	75 d2                	jne    80002db0 <ipc_send+0x1e>
			break;
		if(r != -E_IPC_NOT_RECV)
			panic("ipc_send : %e", r);
		sys_yield();
	}
}
80002dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002de1:	5b                   	pop    %ebx
80002de2:	5e                   	pop    %esi
80002de3:	5f                   	pop    %edi
80002de4:	5d                   	pop    %ebp
80002de5:	c3                   	ret    

80002de6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
80002de6:	55                   	push   %ebp
80002de7:	89 e5                	mov    %esp,%ebp
80002de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
80002dec:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
80002df1:	39 c1                	cmp    %eax,%ecx
80002df3:	74 17                	je     80002e0c <ipc_find_env+0x26>
80002df5:	b8 01 00 00 00       	mov    $0x1,%eax
80002dfa:	6b d0 7c             	imul   $0x7c,%eax,%edx
80002dfd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
80002e03:	8b 52 50             	mov    0x50(%edx),%edx
80002e06:	39 ca                	cmp    %ecx,%edx
80002e08:	75 14                	jne    80002e1e <ipc_find_env+0x38>
80002e0a:	eb 05                	jmp    80002e11 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
80002e0c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
80002e11:	6b c0 7c             	imul   $0x7c,%eax,%eax
80002e14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80002e19:	8b 40 48             	mov    0x48(%eax),%eax
80002e1c:	eb 0f                	jmp    80002e2d <ipc_find_env+0x47>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
80002e1e:	83 c0 01             	add    $0x1,%eax
80002e21:	3d 00 04 00 00       	cmp    $0x400,%eax
80002e26:	75 d2                	jne    80002dfa <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
80002e28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80002e2d:	5d                   	pop    %ebp
80002e2e:	c3                   	ret    

80002e2f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
80002e2f:	55                   	push   %ebp
80002e30:	89 e5                	mov    %esp,%ebp
80002e32:	53                   	push   %ebx
80002e33:	83 ec 04             	sub    $0x4,%esp
80002e36:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = ROUNDDOWN((void *) utf->utf_fault_va, PGSIZE);
80002e39:	8b 02                	mov    (%edx),%eax
80002e3b:	89 c3                	mov    %eax,%ebx
80002e3d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if(!(utf->utf_err & FEC_WR) && !(uvpt[PGNUM(utf->utf_fault_va)] & PTE_COW))
80002e43:	f6 42 04 02          	testb  $0x2,0x4(%edx)
80002e47:	75 23                	jne    80002e6c <pgfault+0x3d>
80002e49:	c1 e8 0c             	shr    $0xc,%eax
80002e4c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80002e53:	f6 c4 08             	test   $0x8,%ah
80002e56:	75 14                	jne    80002e6c <pgfault+0x3d>
		panic("pgfault check access fails");
80002e58:	83 ec 04             	sub    $0x4,%esp
80002e5b:	68 05 45 00 80       	push   $0x80004505
80002e60:	6a 1c                	push   $0x1c
80002e62:	68 20 45 00 80       	push   $0x80004520
80002e67:	e8 0b 13 00 00       	call   80004177 <_panic>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	if((r = sys_page_alloc(0, PFTEMP, PTE_W|PTE_U|PTE_P)) < 0)
80002e6c:	83 ec 04             	sub    $0x4,%esp
80002e6f:	6a 07                	push   $0x7
80002e71:	68 00 f0 7f 00       	push   $0x7ff000
80002e76:	6a 00                	push   $0x0
80002e78:	e8 8b ef ff ff       	call   80001e08 <sys_page_alloc>
80002e7d:	83 c4 10             	add    $0x10,%esp
80002e80:	85 c0                	test   %eax,%eax
80002e82:	79 12                	jns    80002e96 <pgfault+0x67>
		panic("pgfault : sys_page_alloc : %e" ,r);
80002e84:	50                   	push   %eax
80002e85:	68 27 45 00 80       	push   $0x80004527
80002e8a:	6a 24                	push   $0x24
80002e8c:	68 20 45 00 80       	push   $0x80004520
80002e91:	e8 e1 12 00 00       	call   80004177 <_panic>
	memcpy(PFTEMP, addr, PGSIZE);
80002e96:	83 ec 04             	sub    $0x4,%esp
80002e99:	68 00 10 00 00       	push   $0x1000
80002e9e:	53                   	push   %ebx
80002e9f:	68 00 f0 7f 00       	push   $0x7ff000
80002ea4:	e8 d3 ec ff ff       	call   80001b7c <memcpy>
	if((r = sys_page_map(0, PFTEMP, 0, addr, PTE_W|PTE_U|PTE_P)) < 0)
80002ea9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80002eb0:	53                   	push   %ebx
80002eb1:	6a 00                	push   $0x0
80002eb3:	68 00 f0 7f 00       	push   $0x7ff000
80002eb8:	6a 00                	push   $0x0
80002eba:	e8 8c ef ff ff       	call   80001e4b <sys_page_map>
80002ebf:	83 c4 20             	add    $0x20,%esp
80002ec2:	85 c0                	test   %eax,%eax
80002ec4:	79 12                	jns    80002ed8 <pgfault+0xa9>
		panic("pgfault : sys_page_map : %e" ,r);
80002ec6:	50                   	push   %eax
80002ec7:	68 45 45 00 80       	push   $0x80004545
80002ecc:	6a 27                	push   $0x27
80002ece:	68 20 45 00 80       	push   $0x80004520
80002ed3:	e8 9f 12 00 00       	call   80004177 <_panic>
	if((r = sys_page_unmap(0, PFTEMP)) < 0)
80002ed8:	83 ec 08             	sub    $0x8,%esp
80002edb:	68 00 f0 7f 00       	push   $0x7ff000
80002ee0:	6a 00                	push   $0x0
80002ee2:	e8 a6 ef ff ff       	call   80001e8d <sys_page_unmap>
80002ee7:	83 c4 10             	add    $0x10,%esp
80002eea:	85 c0                	test   %eax,%eax
80002eec:	79 12                	jns    80002f00 <pgfault+0xd1>
		panic("pgfault : sys_page_unmap : %e" ,r);
80002eee:	50                   	push   %eax
80002eef:	68 61 45 00 80       	push   $0x80004561
80002ef4:	6a 29                	push   $0x29
80002ef6:	68 20 45 00 80       	push   $0x80004520
80002efb:	e8 77 12 00 00       	call   80004177 <_panic>
}
80002f00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002f03:	c9                   	leave  
80002f04:	c3                   	ret    

80002f05 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
80002f05:	55                   	push   %ebp
80002f06:	89 e5                	mov    %esp,%ebp
80002f08:	57                   	push   %edi
80002f09:	56                   	push   %esi
80002f0a:	53                   	push   %ebx
80002f0b:	83 ec 28             	sub    $0x28,%esp
	int r;

	// LAB 4: Your code here.
	// panic("fork not implemented");

	set_pgfault_handler(pgfault);
80002f0e:	68 2f 2e 00 80       	push   $0x80002e2f
80002f13:	e8 02 0a 00 00       	call   8000391a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
80002f18:	b8 07 00 00 00       	mov    $0x7,%eax
80002f1d:	cd 30                	int    $0x30
80002f1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80002f22:	89 c7                	mov    %eax,%edi

	envid_t child = sys_exofork();

	if(child == 0)
80002f24:	83 c4 10             	add    $0x10,%esp
80002f27:	bb 00 00 00 00       	mov    $0x0,%ebx
80002f2c:	85 c0                	test   %eax,%eax
80002f2e:	75 21                	jne    80002f51 <fork+0x4c>
	{
		// i'm the child
		thisenv = &envs[ENVX(sys_getenvid())];
80002f30:	e8 95 ee ff ff       	call   80001dca <sys_getenvid>
80002f35:	25 ff 03 00 00       	and    $0x3ff,%eax
80002f3a:	6b c0 7c             	imul   $0x7c,%eax,%eax
80002f3d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80002f42:	a3 20 64 00 80       	mov    %eax,0x80006420
		return 0;
80002f47:	b8 00 00 00 00       	mov    $0x0,%eax
80002f4c:	e9 a8 01 00 00       	jmp    800030f9 <fork+0x1f4>
	}

	uint32_t i;
	for(i = 0; i < USTACKTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
80002f51:	89 d8                	mov    %ebx,%eax
80002f53:	c1 e8 16             	shr    $0x16,%eax
80002f56:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
80002f5d:	a8 01                	test   $0x1,%al
80002f5f:	0f 84 fc 00 00 00    	je     80003061 <fork+0x15c>
			(uvpt[PGNUM(i)] & PTE_P) &&
80002f65:	89 d8                	mov    %ebx,%eax
80002f67:	c1 e8 0c             	shr    $0xc,%eax
80002f6a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	}

	uint32_t i;
	for(i = 0; i < USTACKTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
80002f71:	f6 c2 01             	test   $0x1,%dl
80002f74:	0f 84 e7 00 00 00    	je     80003061 <fork+0x15c>
			(uvpt[PGNUM(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_U))
80002f7a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx

	uint32_t i;
	for(i = 0; i < USTACKTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_P) &&
80002f81:	f6 c2 04             	test   $0x4,%dl
80002f84:	0f 84 d7 00 00 00    	je     80003061 <fork+0x15c>
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	void * addr = (void *)(pn * PGSIZE);
80002f8a:	89 c6                	mov    %eax,%esi
80002f8c:	c1 e6 0c             	shl    $0xc,%esi
	if(uvpt[pn] & PTE_SHARE)
80002f8f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
80002f96:	f6 c6 04             	test   $0x4,%dh
80002f99:	74 2f                	je     80002fca <fork+0xc5>
	{
		if((r = sys_page_map(0, addr, envid, addr, 
80002f9b:	83 ec 0c             	sub    $0xc,%esp
80002f9e:	68 07 0e 00 00       	push   $0xe07
80002fa3:	56                   	push   %esi
80002fa4:	57                   	push   %edi
80002fa5:	56                   	push   %esi
80002fa6:	6a 00                	push   $0x0
80002fa8:	e8 9e ee ff ff       	call   80001e4b <sys_page_map>
80002fad:	83 c4 20             	add    $0x20,%esp
80002fb0:	85 c0                	test   %eax,%eax
80002fb2:	0f 89 a9 00 00 00    	jns    80003061 <fork+0x15c>
			PTE_SHARE | PTE_SYSCALL)) < 0)
			panic("duppage : sys_page_map : %e", r);
80002fb8:	50                   	push   %eax
80002fb9:	68 7f 45 00 80       	push   $0x8000457f
80002fbe:	6a 42                	push   $0x42
80002fc0:	68 20 45 00 80       	push   $0x80004520
80002fc5:	e8 ad 11 00 00       	call   80004177 <_panic>
	}
	else if((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
80002fca:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
80002fd1:	f6 c2 02             	test   $0x2,%dl
80002fd4:	75 0c                	jne    80002fe2 <fork+0xdd>
80002fd6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80002fdd:	f6 c4 08             	test   $0x8,%ah
80002fe0:	74 57                	je     80003039 <fork+0x134>
	{
		if((r = sys_page_map(0, addr, envid, addr, PTE_COW|PTE_U|PTE_P)) < 0)
80002fe2:	83 ec 0c             	sub    $0xc,%esp
80002fe5:	68 05 08 00 00       	push   $0x805
80002fea:	56                   	push   %esi
80002feb:	57                   	push   %edi
80002fec:	56                   	push   %esi
80002fed:	6a 00                	push   $0x0
80002fef:	e8 57 ee ff ff       	call   80001e4b <sys_page_map>
80002ff4:	83 c4 20             	add    $0x20,%esp
80002ff7:	85 c0                	test   %eax,%eax
80002ff9:	79 12                	jns    8000300d <fork+0x108>
			panic("duppage : sys_page_map : %e", r);
80002ffb:	50                   	push   %eax
80002ffc:	68 7f 45 00 80       	push   $0x8000457f
80003001:	6a 47                	push   $0x47
80003003:	68 20 45 00 80       	push   $0x80004520
80003008:	e8 6a 11 00 00       	call   80004177 <_panic>
		if((r = sys_page_map(0, addr, 0, addr, PTE_COW|PTE_U|PTE_P)) < 0)
8000300d:	83 ec 0c             	sub    $0xc,%esp
80003010:	68 05 08 00 00       	push   $0x805
80003015:	56                   	push   %esi
80003016:	6a 00                	push   $0x0
80003018:	56                   	push   %esi
80003019:	6a 00                	push   $0x0
8000301b:	e8 2b ee ff ff       	call   80001e4b <sys_page_map>
80003020:	83 c4 20             	add    $0x20,%esp
80003023:	85 c0                	test   %eax,%eax
80003025:	79 3a                	jns    80003061 <fork+0x15c>
			panic("duppage : sys_page_map : %e", r);
80003027:	50                   	push   %eax
80003028:	68 7f 45 00 80       	push   $0x8000457f
8000302d:	6a 49                	push   $0x49
8000302f:	68 20 45 00 80       	push   $0x80004520
80003034:	e8 3e 11 00 00       	call   80004177 <_panic>
	}
	else
	{
		if((r = sys_page_map(0, addr, envid, addr, PTE_U|PTE_P)) < 0)
80003039:	83 ec 0c             	sub    $0xc,%esp
8000303c:	6a 05                	push   $0x5
8000303e:	56                   	push   %esi
8000303f:	57                   	push   %edi
80003040:	56                   	push   %esi
80003041:	6a 00                	push   $0x0
80003043:	e8 03 ee ff ff       	call   80001e4b <sys_page_map>
80003048:	83 c4 20             	add    $0x20,%esp
8000304b:	85 c0                	test   %eax,%eax
8000304d:	79 12                	jns    80003061 <fork+0x15c>
			panic("duppage : sys_page_map : %e", r);		
8000304f:	50                   	push   %eax
80003050:	68 7f 45 00 80       	push   $0x8000457f
80003055:	6a 4e                	push   $0x4e
80003057:	68 20 45 00 80       	push   $0x80004520
8000305c:	e8 16 11 00 00       	call   80004177 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	uint32_t i;
	for(i = 0; i < USTACKTOP; i += PGSIZE)
80003061:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80003067:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
8000306d:	0f 85 de fe ff ff    	jne    80002f51 <fork+0x4c>
			(uvpt[PGNUM(i)] & PTE_U))
			duppage(child, PGNUM(i));
	}


	if((r = sys_page_alloc(child, (void *)(UXSTACKTOP - PGSIZE),
80003073:	83 ec 04             	sub    $0x4,%esp
80003076:	6a 07                	push   $0x7
80003078:	68 00 f0 bf ee       	push   $0xeebff000
8000307d:	ff 75 e4             	pushl  -0x1c(%ebp)
80003080:	e8 83 ed ff ff       	call   80001e08 <sys_page_alloc>
80003085:	83 c4 10             	add    $0x10,%esp
80003088:	85 c0                	test   %eax,%eax
8000308a:	79 15                	jns    800030a1 <fork+0x19c>
		PTE_W|PTE_U|PTE_P)) < 0)
		panic("fork : sys_page_alloc : %e", r); 
8000308c:	50                   	push   %eax
8000308d:	68 9b 45 00 80       	push   $0x8000459b
80003092:	68 84 00 00 00       	push   $0x84
80003097:	68 20 45 00 80       	push   $0x80004520
8000309c:	e8 d6 10 00 00       	call   80004177 <_panic>

	// sets the user page fault entrypoint for the child 
	extern void _pgfault_upcall(void);
	if((r = sys_env_set_pgfault_upcall(child, _pgfault_upcall)) < 0)
800030a1:	83 ec 08             	sub    $0x8,%esp
800030a4:	68 f5 38 00 80       	push   $0x800038f5
800030a9:	ff 75 e4             	pushl  -0x1c(%ebp)
800030ac:	e8 a2 ee ff ff       	call   80001f53 <sys_env_set_pgfault_upcall>
800030b1:	83 c4 10             	add    $0x10,%esp
800030b4:	85 c0                	test   %eax,%eax
800030b6:	79 15                	jns    800030cd <fork+0x1c8>
		panic("fork : sys_env_set_pgfault_upcall : %e", r); 
800030b8:	50                   	push   %eax
800030b9:	68 e4 45 00 80       	push   $0x800045e4
800030be:	68 89 00 00 00       	push   $0x89
800030c3:	68 20 45 00 80       	push   $0x80004520
800030c8:	e8 aa 10 00 00       	call   80004177 <_panic>

	// mark the child as runable
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
800030cd:	83 ec 08             	sub    $0x8,%esp
800030d0:	6a 02                	push   $0x2
800030d2:	ff 75 e4             	pushl  -0x1c(%ebp)
800030d5:	e8 f5 ed ff ff       	call   80001ecf <sys_env_set_status>
800030da:	83 c4 10             	add    $0x10,%esp
800030dd:	85 c0                	test   %eax,%eax
800030df:	79 15                	jns    800030f6 <fork+0x1f1>
		panic("sys_env_set_status: %e", r);
800030e1:	50                   	push   %eax
800030e2:	68 b6 45 00 80       	push   $0x800045b6
800030e7:	68 8d 00 00 00       	push   $0x8d
800030ec:	68 20 45 00 80       	push   $0x80004520
800030f1:	e8 81 10 00 00       	call   80004177 <_panic>

	return child;
800030f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
800030f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
800030fc:	5b                   	pop    %ebx
800030fd:	5e                   	pop    %esi
800030fe:	5f                   	pop    %edi
800030ff:	5d                   	pop    %ebp
80003100:	c3                   	ret    

80003101 <sfork>:

// Challenge!
int
sfork(void)
{
80003101:	55                   	push   %ebp
80003102:	89 e5                	mov    %esp,%ebp
80003104:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
80003107:	68 cd 45 00 80       	push   $0x800045cd
8000310c:	68 96 00 00 00       	push   $0x96
80003111:	68 20 45 00 80       	push   $0x80004520
80003116:	e8 5c 10 00 00       	call   80004177 <_panic>

8000311b <wait>:
#include <syslib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
8000311b:	55                   	push   %ebp
8000311c:	89 e5                	mov    %esp,%ebp
8000311e:	56                   	push   %esi
8000311f:	53                   	push   %ebx
80003120:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	e = &envs[ENVX(envid)];
80003123:	89 f3                	mov    %esi,%ebx
80003125:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
8000312b:	6b c3 7c             	imul   $0x7c,%ebx,%eax
8000312e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80003133:	8b 40 48             	mov    0x48(%eax),%eax
80003136:	39 c6                	cmp    %eax,%esi
80003138:	75 2b                	jne    80003165 <wait+0x4a>
8000313a:	6b c3 7c             	imul   $0x7c,%ebx,%eax
8000313d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80003142:	8b 40 54             	mov    0x54(%eax),%eax
80003145:	85 c0                	test   %eax,%eax
80003147:	74 1c                	je     80003165 <wait+0x4a>
80003149:	6b db 7c             	imul   $0x7c,%ebx,%ebx
8000314c:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
		sys_yield();
80003152:	e8 92 ec ff ff       	call   80001de9 <sys_yield>
wait(envid_t envid)
{
	const volatile struct Env *e;

	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
80003157:	8b 43 48             	mov    0x48(%ebx),%eax
8000315a:	39 c6                	cmp    %eax,%esi
8000315c:	75 07                	jne    80003165 <wait+0x4a>
8000315e:	8b 43 54             	mov    0x54(%ebx),%eax
80003161:	85 c0                	test   %eax,%eax
80003163:	75 ed                	jne    80003152 <wait+0x37>
		sys_yield();
}
80003165:	5b                   	pop    %ebx
80003166:	5e                   	pop    %esi
80003167:	5d                   	pop    %ebp
80003168:	c3                   	ret    

80003169 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
80003169:	55                   	push   %ebp
8000316a:	89 e5                	mov    %esp,%ebp
8000316c:	57                   	push   %edi
8000316d:	56                   	push   %esi
8000316e:	53                   	push   %ebx
8000316f:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
80003175:	6a 00                	push   $0x0
80003177:	ff 75 08             	pushl  0x8(%ebp)
8000317a:	e8 7a f7 ff ff       	call   800028f9 <open>
8000317f:	89 c7                	mov    %eax,%edi
80003181:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
80003187:	83 c4 10             	add    $0x10,%esp
8000318a:	85 c0                	test   %eax,%eax
8000318c:	0f 88 9b 04 00 00    	js     8000362d <spawn+0x4c4>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
80003192:	83 ec 04             	sub    $0x4,%esp
80003195:	68 00 02 00 00       	push   $0x200
8000319a:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
800031a0:	50                   	push   %eax
800031a1:	57                   	push   %edi
800031a2:	e8 93 f3 ff ff       	call   8000253a <readn>
800031a7:	83 c4 10             	add    $0x10,%esp
800031aa:	3d 00 02 00 00       	cmp    $0x200,%eax
800031af:	75 0c                	jne    800031bd <spawn+0x54>
	    || elf->e_magic != ELF_MAGIC) {
800031b1:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
800031b8:	45 4c 46 
800031bb:	74 33                	je     800031f0 <spawn+0x87>
		close(fd);
800031bd:	83 ec 0c             	sub    $0xc,%esp
800031c0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
800031c6:	e8 a4 f1 ff ff       	call   8000236f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
800031cb:	83 c4 0c             	add    $0xc,%esp
800031ce:	68 7f 45 4c 46       	push   $0x464c457f
800031d3:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
800031d9:	68 0b 46 00 80       	push   $0x8000460b
800031de:	e8 6c 0d 00 00       	call   80003f4f <cprintf>
		return -E_NOT_EXEC;
800031e3:	83 c4 10             	add    $0x10,%esp
800031e6:	bb f0 ff ff ff       	mov    $0xfffffff0,%ebx
800031eb:	e9 be 04 00 00       	jmp    800036ae <spawn+0x545>
800031f0:	b8 07 00 00 00       	mov    $0x7,%eax
800031f5:	cd 30                	int    $0x30
800031f7:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
800031fd:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
80003203:	85 c0                	test   %eax,%eax
80003205:	0f 88 2a 04 00 00    	js     80003635 <spawn+0x4cc>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
8000320b:	89 c6                	mov    %eax,%esi
8000320d:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
80003213:	6b f6 7c             	imul   $0x7c,%esi,%esi
80003216:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
8000321c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
80003222:	b9 11 00 00 00       	mov    $0x11,%ecx
80003227:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
80003229:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
8000322f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
80003235:	8b 45 0c             	mov    0xc(%ebp),%eax
80003238:	8b 00                	mov    (%eax),%eax
8000323a:	85 c0                	test   %eax,%eax
8000323c:	74 3c                	je     8000327a <spawn+0x111>
8000323e:	bb 00 00 00 00       	mov    $0x0,%ebx
80003243:	be 00 00 00 00       	mov    $0x0,%esi
80003248:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
8000324b:	83 ec 0c             	sub    $0xc,%esp
8000324e:	50                   	push   %eax
8000324f:	e8 76 e6 ff ff       	call   800018ca <strlen>
80003254:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
80003258:	83 c3 01             	add    $0x1,%ebx
8000325b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
80003262:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
80003265:	83 c4 10             	add    $0x10,%esp
80003268:	85 c0                	test   %eax,%eax
8000326a:	75 df                	jne    8000324b <spawn+0xe2>
8000326c:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
80003272:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
80003278:	eb 1e                	jmp    80003298 <spawn+0x12f>
8000327a:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
80003281:	00 00 00 
80003284:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
8000328b:	00 00 00 
8000328e:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
80003293:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
80003298:	bf 00 10 40 00       	mov    $0x401000,%edi
8000329d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
8000329f:	89 fa                	mov    %edi,%edx
800032a1:	83 e2 fc             	and    $0xfffffffc,%edx
800032a4:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
800032ab:	29 c2                	sub    %eax,%edx
800032ad:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
800032b3:	8d 42 f8             	lea    -0x8(%edx),%eax
800032b6:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
800032bb:	0f 86 84 03 00 00    	jbe    80003645 <spawn+0x4dc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
800032c1:	83 ec 04             	sub    $0x4,%esp
800032c4:	6a 07                	push   $0x7
800032c6:	68 00 00 40 00       	push   $0x400000
800032cb:	6a 00                	push   $0x0
800032cd:	e8 36 eb ff ff       	call   80001e08 <sys_page_alloc>
800032d2:	83 c4 10             	add    $0x10,%esp
800032d5:	85 c0                	test   %eax,%eax
800032d7:	0f 88 6f 03 00 00    	js     8000364c <spawn+0x4e3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
800032dd:	85 db                	test   %ebx,%ebx
800032df:	7e 46                	jle    80003327 <spawn+0x1be>
800032e1:	be 00 00 00 00       	mov    $0x0,%esi
800032e6:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
800032ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
800032ef:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
800032f5:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
800032fb:	89 04 b2             	mov    %eax,(%edx,%esi,4)
		strcpy(string_store, argv[i]);
800032fe:	83 ec 08             	sub    $0x8,%esp
80003301:	ff 34 b3             	pushl  (%ebx,%esi,4)
80003304:	57                   	push   %edi
80003305:	e8 1b e6 ff ff       	call   80001925 <strcpy>
		string_store += strlen(argv[i]) + 1;
8000330a:	83 c4 04             	add    $0x4,%esp
8000330d:	ff 34 b3             	pushl  (%ebx,%esi,4)
80003310:	e8 b5 e5 ff ff       	call   800018ca <strlen>
80003315:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
80003319:	83 c6 01             	add    $0x1,%esi
8000331c:	83 c4 10             	add    $0x10,%esp
8000331f:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
80003325:	75 c8                	jne    800032ef <spawn+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
80003327:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
8000332d:	8b bd 80 fd ff ff    	mov    -0x280(%ebp),%edi
80003333:	c7 04 38 00 00 00 00 	movl   $0x0,(%eax,%edi,1)

	argv_store[-1] = UTEMP2USTACK(argv_store);
8000333a:	89 c7                	mov    %eax,%edi
8000333c:	2d 00 30 80 11       	sub    $0x11803000,%eax
80003341:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
80003344:	89 f8                	mov    %edi,%eax
80003346:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
8000334c:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
8000334f:	2d 08 30 80 11       	sub    $0x11803008,%eax
80003354:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
8000335a:	83 ec 0c             	sub    $0xc,%esp
8000335d:	6a 07                	push   $0x7
8000335f:	68 00 d0 bf ee       	push   $0xeebfd000
80003364:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
8000336a:	68 00 00 40 00       	push   $0x400000
8000336f:	6a 00                	push   $0x0
80003371:	e8 d5 ea ff ff       	call   80001e4b <sys_page_map>
80003376:	89 c3                	mov    %eax,%ebx
80003378:	83 c4 20             	add    $0x20,%esp
8000337b:	85 c0                	test   %eax,%eax
8000337d:	0f 88 19 03 00 00    	js     8000369c <spawn+0x533>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
80003383:	83 ec 08             	sub    $0x8,%esp
80003386:	68 00 00 40 00       	push   $0x400000
8000338b:	6a 00                	push   $0x0
8000338d:	e8 fb ea ff ff       	call   80001e8d <sys_page_unmap>
80003392:	89 c3                	mov    %eax,%ebx
80003394:	83 c4 10             	add    $0x10,%esp
80003397:	85 c0                	test   %eax,%eax
80003399:	0f 88 fd 02 00 00    	js     8000369c <spawn+0x533>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
8000339f:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
800033a5:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
800033ac:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
800033b2:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
800033b9:	00 
800033ba:	0f 84 bb 02 00 00    	je     8000367b <spawn+0x512>
800033c0:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
800033c7:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
800033ca:	8b 85 78 fd ff ff    	mov    -0x288(%ebp),%eax
800033d0:	83 38 01             	cmpl   $0x1,(%eax)
800033d3:	0f 85 73 01 00 00    	jne    8000354c <spawn+0x3e3>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
800033d9:	89 c7                	mov    %eax,%edi
800033db:	8b 40 18             	mov    0x18(%eax),%eax
800033de:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
800033e4:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
800033e7:	83 f8 01             	cmp    $0x1,%eax
800033ea:	19 c0                	sbb    %eax,%eax
800033ec:	83 e0 fe             	and    $0xfffffffe,%eax
800033ef:	83 c0 07             	add    $0x7,%eax
800033f2:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
800033f8:	89 f8                	mov    %edi,%eax
800033fa:	8b 7f 04             	mov    0x4(%edi),%edi
800033fd:	89 fa                	mov    %edi,%edx
800033ff:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
80003405:	8b 78 10             	mov    0x10(%eax),%edi
80003408:	8b 48 14             	mov    0x14(%eax),%ecx
8000340b:	89 8d 90 fd ff ff    	mov    %ecx,-0x270(%ebp)
80003411:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
80003414:	89 f0                	mov    %esi,%eax
80003416:	25 ff 0f 00 00       	and    $0xfff,%eax
8000341b:	74 14                	je     80003431 <spawn+0x2c8>
		va -= i;
8000341d:	29 c6                	sub    %eax,%esi
		memsz += i;
8000341f:	01 c1                	add    %eax,%ecx
80003421:	89 8d 90 fd ff ff    	mov    %ecx,-0x270(%ebp)
		filesz += i;
80003427:	01 c7                	add    %eax,%edi
		fileoffset -= i;
80003429:	29 c2                	sub    %eax,%edx
8000342b:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
80003431:	83 bd 90 fd ff ff 00 	cmpl   $0x0,-0x270(%ebp)
80003438:	0f 84 0e 01 00 00    	je     8000354c <spawn+0x3e3>
8000343e:	bb 00 00 00 00       	mov    $0x0,%ebx
80003443:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		if (i >= filesz) {
80003449:	39 df                	cmp    %ebx,%edi
8000344b:	77 27                	ja     80003474 <spawn+0x30b>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
8000344d:	83 ec 04             	sub    $0x4,%esp
80003450:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
80003456:	56                   	push   %esi
80003457:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
8000345d:	e8 a6 e9 ff ff       	call   80001e08 <sys_page_alloc>
80003462:	83 c4 10             	add    $0x10,%esp
80003465:	85 c0                	test   %eax,%eax
80003467:	0f 89 c7 00 00 00    	jns    80003534 <spawn+0x3cb>
8000346d:	89 c3                	mov    %eax,%ebx
8000346f:	e9 e6 01 00 00       	jmp    8000365a <spawn+0x4f1>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
80003474:	83 ec 04             	sub    $0x4,%esp
80003477:	6a 07                	push   $0x7
80003479:	68 00 00 40 00       	push   $0x400000
8000347e:	6a 00                	push   $0x0
80003480:	e8 83 e9 ff ff       	call   80001e08 <sys_page_alloc>
80003485:	83 c4 10             	add    $0x10,%esp
80003488:	85 c0                	test   %eax,%eax
8000348a:	0f 88 c0 01 00 00    	js     80003650 <spawn+0x4e7>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
80003490:	83 ec 08             	sub    $0x8,%esp
80003493:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
80003499:	03 85 94 fd ff ff    	add    -0x26c(%ebp),%eax
8000349f:	50                   	push   %eax
800034a0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
800034a6:	e8 70 f1 ff ff       	call   8000261b <seek>
800034ab:	83 c4 10             	add    $0x10,%esp
800034ae:	85 c0                	test   %eax,%eax
800034b0:	0f 88 9e 01 00 00    	js     80003654 <spawn+0x4eb>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
800034b6:	83 ec 04             	sub    $0x4,%esp
800034b9:	89 f8                	mov    %edi,%eax
800034bb:	2b 85 94 fd ff ff    	sub    -0x26c(%ebp),%eax
800034c1:	3d 00 10 00 00       	cmp    $0x1000,%eax
800034c6:	ba 00 10 00 00       	mov    $0x1000,%edx
800034cb:	0f 47 c2             	cmova  %edx,%eax
800034ce:	50                   	push   %eax
800034cf:	68 00 00 40 00       	push   $0x400000
800034d4:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
800034da:	e8 5b f0 ff ff       	call   8000253a <readn>
800034df:	83 c4 10             	add    $0x10,%esp
800034e2:	85 c0                	test   %eax,%eax
800034e4:	0f 88 6e 01 00 00    	js     80003658 <spawn+0x4ef>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
800034ea:	83 ec 0c             	sub    $0xc,%esp
800034ed:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
800034f3:	56                   	push   %esi
800034f4:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
800034fa:	68 00 00 40 00       	push   $0x400000
800034ff:	6a 00                	push   $0x0
80003501:	e8 45 e9 ff ff       	call   80001e4b <sys_page_map>
80003506:	83 c4 20             	add    $0x20,%esp
80003509:	85 c0                	test   %eax,%eax
8000350b:	79 15                	jns    80003522 <spawn+0x3b9>
				panic("spawn: sys_page_map data: %e", r);
8000350d:	50                   	push   %eax
8000350e:	68 25 46 00 80       	push   $0x80004625
80003513:	68 23 01 00 00       	push   $0x123
80003518:	68 42 46 00 80       	push   $0x80004642
8000351d:	e8 55 0c 00 00       	call   80004177 <_panic>
			sys_page_unmap(0, UTEMP);
80003522:	83 ec 08             	sub    $0x8,%esp
80003525:	68 00 00 40 00       	push   $0x400000
8000352a:	6a 00                	push   $0x0
8000352c:	e8 5c e9 ff ff       	call   80001e8d <sys_page_unmap>
80003531:	83 c4 10             	add    $0x10,%esp
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
80003534:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8000353a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80003540:	39 9d 90 fd ff ff    	cmp    %ebx,-0x270(%ebp)
80003546:	0f 87 f7 fe ff ff    	ja     80003443 <spawn+0x2da>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
8000354c:	83 85 80 fd ff ff 01 	addl   $0x1,-0x280(%ebp)
80003553:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
80003559:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
80003560:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
80003567:	39 c8                	cmp    %ecx,%eax
80003569:	0f 8f 5b fe ff ff    	jg     800033ca <spawn+0x261>
8000356f:	e9 07 01 00 00       	jmp    8000367b <spawn+0x512>
{
	// LAB 5: Your code here.
	int i;
	for(i = 0; i < UTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
80003574:	89 d8                	mov    %ebx,%eax
80003576:	c1 e8 16             	shr    $0x16,%eax
80003579:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
80003580:	a8 01                	test   $0x1,%al
80003582:	74 3e                	je     800035c2 <spawn+0x459>
			(uvpt[PGNUM(i)] & PTE_P) &&
80003584:	89 d8                	mov    %ebx,%eax
80003586:	c1 e8 0c             	shr    $0xc,%eax
80003589:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
{
	// LAB 5: Your code here.
	int i;
	for(i = 0; i < UTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
80003590:	f6 c2 01             	test   $0x1,%dl
80003593:	74 2d                	je     800035c2 <spawn+0x459>
			(uvpt[PGNUM(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_U) &&
80003595:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	// LAB 5: Your code here.
	int i;
	for(i = 0; i < UTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_P) &&
8000359c:	f6 c2 04             	test   $0x4,%dl
8000359f:	74 21                	je     800035c2 <spawn+0x459>
			(uvpt[PGNUM(i)] & PTE_U) &&
			(uvpt[PGNUM(i)] & PTE_SHARE))
800035a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	int i;
	for(i = 0; i < UTOP; i += PGSIZE)
	{
		if((uvpd[PDX(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_P) &&
			(uvpt[PGNUM(i)] & PTE_U) &&
800035a8:	f6 c4 04             	test   $0x4,%ah
800035ab:	74 15                	je     800035c2 <spawn+0x459>
			(uvpt[PGNUM(i)] & PTE_SHARE))
			sys_page_map(0, (void *)i, child, (void *)i,
800035ad:	83 ec 0c             	sub    $0xc,%esp
800035b0:	68 07 0e 00 00       	push   $0xe07
800035b5:	53                   	push   %ebx
800035b6:	56                   	push   %esi
800035b7:	53                   	push   %ebx
800035b8:	6a 00                	push   $0x0
800035ba:	e8 8c e8 ff ff       	call   80001e4b <sys_page_map>
800035bf:	83 c4 20             	add    $0x20,%esp
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int i;
	for(i = 0; i < UTOP; i += PGSIZE)
800035c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
800035c8:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
800035ce:	75 a4                	jne    80003574 <spawn+0x40b>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
800035d0:	83 ec 08             	sub    $0x8,%esp
800035d3:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
800035d9:	50                   	push   %eax
800035da:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
800035e0:	e8 2c e9 ff ff       	call   80001f11 <sys_env_set_trapframe>
800035e5:	83 c4 10             	add    $0x10,%esp
800035e8:	85 c0                	test   %eax,%eax
800035ea:	79 15                	jns    80003601 <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
800035ec:	50                   	push   %eax
800035ed:	68 4a 46 00 80       	push   $0x8000464a
800035f2:	68 85 00 00 00       	push   $0x85
800035f7:	68 42 46 00 80       	push   $0x80004642
800035fc:	e8 76 0b 00 00       	call   80004177 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
80003601:	83 ec 08             	sub    $0x8,%esp
80003604:	6a 02                	push   $0x2
80003606:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
8000360c:	e8 be e8 ff ff       	call   80001ecf <sys_env_set_status>
80003611:	83 c4 10             	add    $0x10,%esp
80003614:	85 c0                	test   %eax,%eax
80003616:	79 25                	jns    8000363d <spawn+0x4d4>
		panic("sys_env_set_status: %e", r);
80003618:	50                   	push   %eax
80003619:	68 b6 45 00 80       	push   $0x800045b6
8000361e:	68 88 00 00 00       	push   $0x88
80003623:	68 42 46 00 80       	push   $0x80004642
80003628:	e8 4a 0b 00 00       	call   80004177 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
8000362d:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
80003633:	eb 79                	jmp    800036ae <spawn+0x545>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
80003635:	8b 9d 74 fd ff ff    	mov    -0x28c(%ebp),%ebx
8000363b:	eb 71                	jmp    800036ae <spawn+0x545>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
8000363d:	8b 9d 74 fd ff ff    	mov    -0x28c(%ebp),%ebx
80003643:	eb 69                	jmp    800036ae <spawn+0x545>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
80003645:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
8000364a:	eb 62                	jmp    800036ae <spawn+0x545>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;
8000364c:	89 c3                	mov    %eax,%ebx
8000364e:	eb 5e                	jmp    800036ae <spawn+0x545>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
80003650:	89 c3                	mov    %eax,%ebx
80003652:	eb 06                	jmp    8000365a <spawn+0x4f1>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
80003654:	89 c3                	mov    %eax,%ebx
80003656:	eb 02                	jmp    8000365a <spawn+0x4f1>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
80003658:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
8000365a:	83 ec 0c             	sub    $0xc,%esp
8000365d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
80003663:	e8 21 e7 ff ff       	call   80001d89 <sys_env_destroy>
	close(fd);
80003668:	83 c4 04             	add    $0x4,%esp
8000366b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
80003671:	e8 f9 ec ff ff       	call   8000236f <close>
	return r;
80003676:	83 c4 10             	add    $0x10,%esp
80003679:	eb 33                	jmp    800036ae <spawn+0x545>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
8000367b:	83 ec 0c             	sub    $0xc,%esp
8000367e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
80003684:	e8 e6 ec ff ff       	call   8000236f <close>
80003689:	83 c4 10             	add    $0x10,%esp
8000368c:	bb 00 00 00 00       	mov    $0x0,%ebx
80003691:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
80003697:	e9 d8 fe ff ff       	jmp    80003574 <spawn+0x40b>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
8000369c:	83 ec 08             	sub    $0x8,%esp
8000369f:	68 00 00 40 00       	push   $0x400000
800036a4:	6a 00                	push   $0x0
800036a6:	e8 e2 e7 ff ff       	call   80001e8d <sys_page_unmap>
800036ab:	83 c4 10             	add    $0x10,%esp

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
800036ae:	89 d8                	mov    %ebx,%eax
800036b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
800036b3:	5b                   	pop    %ebx
800036b4:	5e                   	pop    %esi
800036b5:	5f                   	pop    %edi
800036b6:	5d                   	pop    %ebp
800036b7:	c3                   	ret    

800036b8 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
800036b8:	55                   	push   %ebp
800036b9:	89 e5                	mov    %esp,%ebp
800036bb:	57                   	push   %edi
800036bc:	56                   	push   %esi
800036bd:	53                   	push   %ebx
800036be:	83 ec 1c             	sub    $0x1c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
800036c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
800036c5:	74 61                	je     80003728 <spawnl+0x70>
800036c7:	8d 45 14             	lea    0x14(%ebp),%eax
800036ca:	ba 00 00 00 00       	mov    $0x0,%edx
800036cf:	eb 02                	jmp    800036d3 <spawnl+0x1b>
		argc++;
800036d1:	89 ca                	mov    %ecx,%edx
800036d3:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
800036d6:	83 c0 04             	add    $0x4,%eax
800036d9:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
800036dd:	75 f2                	jne    800036d1 <spawnl+0x19>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
800036df:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
800036e6:	83 e0 f0             	and    $0xfffffff0,%eax
800036e9:	29 c4                	sub    %eax,%esp
800036eb:	8d 44 24 03          	lea    0x3(%esp),%eax
800036ef:	c1 e8 02             	shr    $0x2,%eax
800036f2:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
800036f9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
800036fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
800036fe:	89 3c 85 00 00 00 00 	mov    %edi,0x0(,%eax,4)
	argv[argc+1] = NULL;
80003705:	c7 44 96 08 00 00 00 	movl   $0x0,0x8(%esi,%edx,4)
8000370c:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
8000370d:	89 ce                	mov    %ecx,%esi
8000370f:	85 c9                	test   %ecx,%ecx
80003711:	74 25                	je     80003738 <spawnl+0x80>
80003713:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
80003718:	83 c0 01             	add    $0x1,%eax
8000371b:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
8000371f:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
80003722:	39 f0                	cmp    %esi,%eax
80003724:	75 f2                	jne    80003718 <spawnl+0x60>
80003726:	eb 10                	jmp    80003738 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
80003728:	8b 45 0c             	mov    0xc(%ebp),%eax
8000372b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
8000372e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
80003735:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
80003738:	83 ec 08             	sub    $0x8,%esp
8000373b:	53                   	push   %ebx
8000373c:	ff 75 08             	pushl  0x8(%ebp)
8000373f:	e8 25 fa ff ff       	call   80003169 <spawn>
}
80003744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003747:	5b                   	pop    %ebx
80003748:	5e                   	pop    %esi
80003749:	5f                   	pop    %edi
8000374a:	5d                   	pop    %ebp
8000374b:	c3                   	ret    

8000374c <exit>:

#include <syslib.h>

void
exit(void)
{
8000374c:	55                   	push   %ebp
8000374d:	89 e5                	mov    %esp,%ebp
8000374f:	83 ec 08             	sub    $0x8,%esp
	close_all();
80003752:	e8 43 ec ff ff       	call   8000239a <close_all>
	sys_env_destroy(0);
80003757:	83 ec 0c             	sub    $0xc,%esp
8000375a:	6a 00                	push   $0x0
8000375c:	e8 28 e6 ff ff       	call   80001d89 <sys_env_destroy>
}
80003761:	83 c4 10             	add    $0x10,%esp
80003764:	c9                   	leave  
80003765:	c3                   	ret    

80003766 <pageref>:
#include <syslib.h>

int
pageref(void *v)
{
80003766:	55                   	push   %ebp
80003767:	89 e5                	mov    %esp,%ebp
80003769:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
8000376c:	89 d0                	mov    %edx,%eax
8000376e:	c1 e8 16             	shr    $0x16,%eax
80003771:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
80003778:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
8000377d:	f6 c1 01             	test   $0x1,%cl
80003780:	74 1d                	je     8000379f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
80003782:	c1 ea 0c             	shr    $0xc,%edx
80003785:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	// cprintf("pageref pte:0x%08x\n", pte);
	if (!(pte & PTE_P))
8000378c:	f6 c2 01             	test   $0x1,%dl
8000378f:	74 0e                	je     8000379f <pageref+0x39>
		return 0;
	// cprintf("pageref 0x%08x: %d\n", v, pages[PGNUM(pte)].pp_ref);
	return pages[PGNUM(pte)].pp_ref;
80003791:	c1 ea 0c             	shr    $0xc,%edx
80003794:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
8000379b:	ef 
8000379c:	0f b7 c0             	movzwl %ax,%eax
}
8000379f:	5d                   	pop    %ebp
800037a0:	c3                   	ret    

800037a1 <argstart>:
#include <args.h>
#include <string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
800037a1:	55                   	push   %ebp
800037a2:	89 e5                	mov    %esp,%ebp
800037a4:	8b 55 08             	mov    0x8(%ebp),%edx
800037a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800037aa:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
800037ad:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
800037af:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
800037b2:	83 3a 01             	cmpl   $0x1,(%edx)
800037b5:	7e 09                	jle    800037c0 <argstart+0x1f>
800037b7:	ba e1 41 00 80       	mov    $0x800041e1,%edx
800037bc:	85 c9                	test   %ecx,%ecx
800037be:	75 05                	jne    800037c5 <argstart+0x24>
800037c0:	ba 00 00 00 00       	mov    $0x0,%edx
800037c5:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
800037c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
800037cf:	5d                   	pop    %ebp
800037d0:	c3                   	ret    

800037d1 <argnext>:

int
argnext(struct Argstate *args)
{
800037d1:	55                   	push   %ebp
800037d2:	89 e5                	mov    %esp,%ebp
800037d4:	53                   	push   %ebx
800037d5:	83 ec 04             	sub    $0x4,%esp
800037d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
800037db:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
800037e2:	8b 43 08             	mov    0x8(%ebx),%eax
800037e5:	85 c0                	test   %eax,%eax
800037e7:	74 6f                	je     80003858 <argnext+0x87>
		return -1;

	if (!*args->curarg) {
800037e9:	80 38 00             	cmpb   $0x0,(%eax)
800037ec:	75 4e                	jne    8000383c <argnext+0x6b>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
800037ee:	8b 0b                	mov    (%ebx),%ecx
800037f0:	83 39 01             	cmpl   $0x1,(%ecx)
800037f3:	74 55                	je     8000384a <argnext+0x79>
		    || args->argv[1][0] != '-'
800037f5:	8b 53 04             	mov    0x4(%ebx),%edx
800037f8:	8b 42 04             	mov    0x4(%edx),%eax
800037fb:	80 38 2d             	cmpb   $0x2d,(%eax)
800037fe:	75 4a                	jne    8000384a <argnext+0x79>
		    || args->argv[1][1] == '\0')
80003800:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
80003804:	74 44                	je     8000384a <argnext+0x79>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
80003806:	83 c0 01             	add    $0x1,%eax
80003809:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
8000380c:	83 ec 04             	sub    $0x4,%esp
8000380f:	8b 01                	mov    (%ecx),%eax
80003811:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
80003818:	50                   	push   %eax
80003819:	8d 42 08             	lea    0x8(%edx),%eax
8000381c:	50                   	push   %eax
8000381d:	83 c2 04             	add    $0x4,%edx
80003820:	52                   	push   %edx
80003821:	e8 ee e2 ff ff       	call   80001b14 <memmove>
		(*args->argc)--;
80003826:	8b 03                	mov    (%ebx),%eax
80003828:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
8000382b:	8b 43 08             	mov    0x8(%ebx),%eax
8000382e:	83 c4 10             	add    $0x10,%esp
80003831:	80 38 2d             	cmpb   $0x2d,(%eax)
80003834:	75 06                	jne    8000383c <argnext+0x6b>
80003836:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
8000383a:	74 0e                	je     8000384a <argnext+0x79>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
8000383c:	8b 53 08             	mov    0x8(%ebx),%edx
8000383f:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
80003842:	83 c2 01             	add    $0x1,%edx
80003845:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
80003848:	eb 13                	jmp    8000385d <argnext+0x8c>

    endofargs:
	args->curarg = 0;
8000384a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
80003851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80003856:	eb 05                	jmp    8000385d <argnext+0x8c>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
80003858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
8000385d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003860:	c9                   	leave  
80003861:	c3                   	ret    

80003862 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
80003862:	55                   	push   %ebp
80003863:	89 e5                	mov    %esp,%ebp
80003865:	53                   	push   %ebx
80003866:	83 ec 04             	sub    $0x4,%esp
80003869:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
8000386c:	8b 43 08             	mov    0x8(%ebx),%eax
8000386f:	85 c0                	test   %eax,%eax
80003871:	74 58                	je     800038cb <argnextvalue+0x69>
		return 0;
	if (*args->curarg) {
80003873:	80 38 00             	cmpb   $0x0,(%eax)
80003876:	74 0c                	je     80003884 <argnextvalue+0x22>
		args->argvalue = args->curarg;
80003878:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
8000387b:	c7 43 08 e1 41 00 80 	movl   $0x800041e1,0x8(%ebx)
80003882:	eb 42                	jmp    800038c6 <argnextvalue+0x64>
	} else if (*args->argc > 1) {
80003884:	8b 13                	mov    (%ebx),%edx
80003886:	83 3a 01             	cmpl   $0x1,(%edx)
80003889:	7e 2d                	jle    800038b8 <argnextvalue+0x56>
		args->argvalue = args->argv[1];
8000388b:	8b 43 04             	mov    0x4(%ebx),%eax
8000388e:	8b 48 04             	mov    0x4(%eax),%ecx
80003891:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
80003894:	83 ec 04             	sub    $0x4,%esp
80003897:	8b 12                	mov    (%edx),%edx
80003899:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
800038a0:	52                   	push   %edx
800038a1:	8d 50 08             	lea    0x8(%eax),%edx
800038a4:	52                   	push   %edx
800038a5:	83 c0 04             	add    $0x4,%eax
800038a8:	50                   	push   %eax
800038a9:	e8 66 e2 ff ff       	call   80001b14 <memmove>
		(*args->argc)--;
800038ae:	8b 03                	mov    (%ebx),%eax
800038b0:	83 28 01             	subl   $0x1,(%eax)
800038b3:	83 c4 10             	add    $0x10,%esp
800038b6:	eb 0e                	jmp    800038c6 <argnextvalue+0x64>
	} else {
		args->argvalue = 0;
800038b8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
800038bf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
800038c6:	8b 43 0c             	mov    0xc(%ebx),%eax
800038c9:	eb 05                	jmp    800038d0 <argnextvalue+0x6e>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
800038cb:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
800038d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800038d3:	c9                   	leave  
800038d4:	c3                   	ret    

800038d5 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
800038d5:	55                   	push   %ebp
800038d6:	89 e5                	mov    %esp,%ebp
800038d8:	83 ec 08             	sub    $0x8,%esp
800038db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
800038de:	8b 51 0c             	mov    0xc(%ecx),%edx
800038e1:	89 d0                	mov    %edx,%eax
800038e3:	85 d2                	test   %edx,%edx
800038e5:	75 0c                	jne    800038f3 <argvalue+0x1e>
800038e7:	83 ec 0c             	sub    $0xc,%esp
800038ea:	51                   	push   %ecx
800038eb:	e8 72 ff ff ff       	call   80003862 <argnextvalue>
800038f0:	83 c4 10             	add    $0x10,%esp
}
800038f3:	c9                   	leave  
800038f4:	c3                   	ret    

800038f5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
800038f5:	54                   	push   %esp
	movl _pgfault_handler, %eax
800038f6:	a1 00 80 00 80       	mov    0x80008000,%eax
	call *%eax
800038fb:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
800038fd:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

	addl $8, %esp
80003900:	83 c4 08             	add    $0x8,%esp
	movl 32(%esp), %eax
80003903:	8b 44 24 20          	mov    0x20(%esp),%eax
	movl 40(%esp), %edx
80003907:	8b 54 24 28          	mov    0x28(%esp),%edx
	movl %eax, -4(%edx)
8000390b:	89 42 fc             	mov    %eax,-0x4(%edx)
	subl $4, 40(%esp)
8000390e:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
80003913:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4, %esp
80003914:	83 c4 04             	add    $0x4,%esp
	popfl
80003917:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	pop %esp
80003918:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
80003919:	c3                   	ret    

8000391a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
8000391a:	55                   	push   %ebp
8000391b:	89 e5                	mov    %esp,%ebp
8000391d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
80003920:	83 3d 00 80 00 80 00 	cmpl   $0x0,0x80008000
80003927:	75 52                	jne    8000397b <set_pgfault_handler+0x61>
		// First time through!
		if((r = sys_page_alloc(0, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
80003929:	83 ec 04             	sub    $0x4,%esp
8000392c:	6a 07                	push   $0x7
8000392e:	68 00 f0 bf ee       	push   $0xeebff000
80003933:	6a 00                	push   $0x0
80003935:	e8 ce e4 ff ff       	call   80001e08 <sys_page_alloc>
8000393a:	83 c4 10             	add    $0x10,%esp
8000393d:	85 c0                	test   %eax,%eax
8000393f:	79 12                	jns    80003953 <set_pgfault_handler+0x39>
			panic("set_pgfault_handler : %e", r);
80003941:	50                   	push   %eax
80003942:	68 64 46 00 80       	push   $0x80004664
80003947:	6a 1f                	push   $0x1f
80003949:	68 7d 46 00 80       	push   $0x8000467d
8000394e:	e8 24 08 00 00       	call   80004177 <_panic>
		if((r = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
80003953:	83 ec 08             	sub    $0x8,%esp
80003956:	68 f5 38 00 80       	push   $0x800038f5
8000395b:	6a 00                	push   $0x0
8000395d:	e8 f1 e5 ff ff       	call   80001f53 <sys_env_set_pgfault_upcall>
80003962:	83 c4 10             	add    $0x10,%esp
80003965:	85 c0                	test   %eax,%eax
80003967:	79 12                	jns    8000397b <set_pgfault_handler+0x61>
			panic("set_pgfault_handler : %e", r);
80003969:	50                   	push   %eax
8000396a:	68 64 46 00 80       	push   $0x80004664
8000396f:	6a 21                	push   $0x21
80003971:	68 7d 46 00 80       	push   $0x8000467d
80003976:	e8 fc 07 00 00       	call   80004177 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
8000397b:	8b 45 08             	mov    0x8(%ebp),%eax
8000397e:	a3 00 80 00 80       	mov    %eax,0x80008000
}
80003983:	c9                   	leave  
80003984:	c3                   	ret    

80003985 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
80003985:	55                   	push   %ebp
80003986:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
80003988:	83 fa 01             	cmp    $0x1,%edx
8000398b:	7e 0e                	jle    8000399b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
8000398d:	8b 10                	mov    (%eax),%edx
8000398f:	8d 4a 08             	lea    0x8(%edx),%ecx
80003992:	89 08                	mov    %ecx,(%eax)
80003994:	8b 02                	mov    (%edx),%eax
80003996:	8b 52 04             	mov    0x4(%edx),%edx
80003999:	eb 22                	jmp    800039bd <getuint+0x38>
	else if (lflag)
8000399b:	85 d2                	test   %edx,%edx
8000399d:	74 10                	je     800039af <getuint+0x2a>
		return va_arg(*ap, unsigned long);
8000399f:	8b 10                	mov    (%eax),%edx
800039a1:	8d 4a 04             	lea    0x4(%edx),%ecx
800039a4:	89 08                	mov    %ecx,(%eax)
800039a6:	8b 02                	mov    (%edx),%eax
800039a8:	ba 00 00 00 00       	mov    $0x0,%edx
800039ad:	eb 0e                	jmp    800039bd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
800039af:	8b 10                	mov    (%eax),%edx
800039b1:	8d 4a 04             	lea    0x4(%edx),%ecx
800039b4:	89 08                	mov    %ecx,(%eax)
800039b6:	8b 02                	mov    (%edx),%eax
800039b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
800039bd:	5d                   	pop    %ebp
800039be:	c3                   	ret    

800039bf <printnum>:
}

static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long num, unsigned base, int width, int padc)
{
800039bf:	55                   	push   %ebp
800039c0:	89 e5                	mov    %esp,%ebp
800039c2:	57                   	push   %edi
800039c3:	56                   	push   %esi
800039c4:	53                   	push   %ebx
800039c5:	83 ec 1c             	sub    $0x1c,%esp
800039c8:	89 c7                	mov    %eax,%edi
800039ca:	89 d6                	mov    %edx,%esi
800039cc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
800039cf:	3b 4d 08             	cmp    0x8(%ebp),%ecx
800039d2:	73 0c                	jae    800039e0 <printnum+0x21>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
800039d4:	8b 45 0c             	mov    0xc(%ebp),%eax
800039d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
800039da:	85 db                	test   %ebx,%ebx
800039dc:	7f 2d                	jg     80003a0b <printnum+0x4c>
800039de:	eb 3c                	jmp    80003a1c <printnum+0x5d>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
800039e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
800039e3:	ba 00 00 00 00       	mov    $0x0,%edx
800039e8:	f7 75 08             	divl   0x8(%ebp)
800039eb:	89 c1                	mov    %eax,%ecx
800039ed:	83 ec 04             	sub    $0x4,%esp
800039f0:	ff 75 10             	pushl  0x10(%ebp)
800039f3:	8b 45 0c             	mov    0xc(%ebp),%eax
800039f6:	8d 50 ff             	lea    -0x1(%eax),%edx
800039f9:	52                   	push   %edx
800039fa:	ff 75 08             	pushl  0x8(%ebp)
800039fd:	89 f2                	mov    %esi,%edx
800039ff:	89 f8                	mov    %edi,%eax
80003a01:	e8 b9 ff ff ff       	call   800039bf <printnum>
80003a06:	83 c4 10             	add    $0x10,%esp
80003a09:	eb 11                	jmp    80003a1c <printnum+0x5d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
80003a0b:	83 ec 08             	sub    $0x8,%esp
80003a0e:	56                   	push   %esi
80003a0f:	ff 75 10             	pushl  0x10(%ebp)
80003a12:	ff d7                	call   *%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
80003a14:	83 c4 10             	add    $0x10,%esp
80003a17:	83 eb 01             	sub    $0x1,%ebx
80003a1a:	75 ef                	jne    80003a0b <printnum+0x4c>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
80003a1c:	83 ec 08             	sub    $0x8,%esp
80003a1f:	56                   	push   %esi
80003a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80003a23:	ba 00 00 00 00       	mov    $0x0,%edx
80003a28:	f7 75 08             	divl   0x8(%ebp)
80003a2b:	0f be 82 87 46 00 80 	movsbl -0x7fffb979(%edx),%eax
80003a32:	50                   	push   %eax
80003a33:	ff d7                	call   *%edi
}
80003a35:	83 c4 10             	add    $0x10,%esp
80003a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003a3b:	5b                   	pop    %ebx
80003a3c:	5e                   	pop    %esi
80003a3d:	5f                   	pop    %edi
80003a3e:	5d                   	pop    %ebp
80003a3f:	c3                   	ret    

80003a40 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
80003a40:	55                   	push   %ebp
80003a41:	89 e5                	mov    %esp,%ebp
80003a43:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
80003a46:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
80003a4a:	8b 10                	mov    (%eax),%edx
80003a4c:	3b 50 04             	cmp    0x4(%eax),%edx
80003a4f:	73 0a                	jae    80003a5b <sprintputch+0x1b>
		*b->buf++ = ch;
80003a51:	8d 4a 01             	lea    0x1(%edx),%ecx
80003a54:	89 08                	mov    %ecx,(%eax)
80003a56:	8b 45 08             	mov    0x8(%ebp),%eax
80003a59:	88 02                	mov    %al,(%edx)
}
80003a5b:	5d                   	pop    %ebp
80003a5c:	c3                   	ret    

80003a5d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
80003a5d:	55                   	push   %ebp
80003a5e:	89 e5                	mov    %esp,%ebp
80003a60:	53                   	push   %ebx
80003a61:	83 ec 04             	sub    $0x4,%esp
80003a64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
80003a67:	8b 13                	mov    (%ebx),%edx
80003a69:	8d 42 01             	lea    0x1(%edx),%eax
80003a6c:	89 03                	mov    %eax,(%ebx)
80003a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80003a71:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
80003a75:	3d ff 00 00 00       	cmp    $0xff,%eax
80003a7a:	75 1a                	jne    80003a96 <putch+0x39>
		sys_cputs(b->buf, b->idx);
80003a7c:	83 ec 08             	sub    $0x8,%esp
80003a7f:	68 ff 00 00 00       	push   $0xff
80003a84:	8d 43 08             	lea    0x8(%ebx),%eax
80003a87:	50                   	push   %eax
80003a88:	e8 bf e2 ff ff       	call   80001d4c <sys_cputs>
		b->idx = 0;
80003a8d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80003a93:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
80003a96:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
80003a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003a9d:	c9                   	leave  
80003a9e:	c3                   	ret    

80003a9f <writebuf>:


static void
writebuf(struct fprintbuf *b)
{
	if (b->error > 0) {
80003a9f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
80003aa3:	7e 37                	jle    80003adc <writebuf+0x3d>
};


static void
writebuf(struct fprintbuf *b)
{
80003aa5:	55                   	push   %ebp
80003aa6:	89 e5                	mov    %esp,%ebp
80003aa8:	53                   	push   %ebx
80003aa9:	83 ec 08             	sub    $0x8,%esp
80003aac:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
		ssize_t result = write(b->fd, b->buf, b->idx);
80003aae:	ff 70 04             	pushl  0x4(%eax)
80003ab1:	8d 40 10             	lea    0x10(%eax),%eax
80003ab4:	50                   	push   %eax
80003ab5:	ff 33                	pushl  (%ebx)
80003ab7:	e8 d3 ea ff ff       	call   8000258f <write>
		if (result > 0)
80003abc:	83 c4 10             	add    $0x10,%esp
80003abf:	85 c0                	test   %eax,%eax
80003ac1:	7e 03                	jle    80003ac6 <writebuf+0x27>
			b->result += result;
80003ac3:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
80003ac6:	3b 43 04             	cmp    0x4(%ebx),%eax
80003ac9:	74 0d                	je     80003ad8 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
80003acb:	85 c0                	test   %eax,%eax
80003acd:	ba 00 00 00 00       	mov    $0x0,%edx
80003ad2:	0f 4f c2             	cmovg  %edx,%eax
80003ad5:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
80003ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003adb:	c9                   	leave  
80003adc:	f3 c3                	repz ret 

80003ade <fputch>:

static void
fputch(int ch, void *thunk)
{
80003ade:	55                   	push   %ebp
80003adf:	89 e5                	mov    %esp,%ebp
80003ae1:	53                   	push   %ebx
80003ae2:	83 ec 04             	sub    $0x4,%esp
80003ae5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct fprintbuf *b = (struct fprintbuf *) thunk;
	b->buf[b->idx++] = ch;
80003ae8:	8b 53 04             	mov    0x4(%ebx),%edx
80003aeb:	8d 42 01             	lea    0x1(%edx),%eax
80003aee:	89 43 04             	mov    %eax,0x4(%ebx)
80003af1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80003af4:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
80003af8:	3d 00 01 00 00       	cmp    $0x100,%eax
80003afd:	75 0e                	jne    80003b0d <fputch+0x2f>
		writebuf(b);
80003aff:	89 d8                	mov    %ebx,%eax
80003b01:	e8 99 ff ff ff       	call   80003a9f <writebuf>
		b->idx = 0;
80003b06:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
80003b0d:	83 c4 04             	add    $0x4,%esp
80003b10:	5b                   	pop    %ebx
80003b11:	5d                   	pop    %ebp
80003b12:	c3                   	ret    

80003b13 <vprintfmt>:
	va_end(ap);
}

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
80003b13:	55                   	push   %ebp
80003b14:	89 e5                	mov    %esp,%ebp
80003b16:	57                   	push   %edi
80003b17:	56                   	push   %esi
80003b18:	53                   	push   %ebx
80003b19:	83 ec 2c             	sub    $0x2c,%esp
80003b1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80003b1f:	eb 03                	jmp    80003b24 <vprintfmt+0x11>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
80003b21:	89 75 10             	mov    %esi,0x10(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
80003b24:	8b 45 10             	mov    0x10(%ebp),%eax
80003b27:	8d 70 01             	lea    0x1(%eax),%esi
80003b2a:	0f b6 00             	movzbl (%eax),%eax
80003b2d:	83 f8 25             	cmp    $0x25,%eax
80003b30:	74 2c                	je     80003b5e <vprintfmt+0x4b>
			if (ch == '\0')
80003b32:	85 c0                	test   %eax,%eax
80003b34:	75 0f                	jne    80003b45 <vprintfmt+0x32>
80003b36:	e9 bb 03 00 00       	jmp    80003ef6 <vprintfmt+0x3e3>
80003b3b:	85 c0                	test   %eax,%eax
80003b3d:	0f 84 b3 03 00 00    	je     80003ef6 <vprintfmt+0x3e3>
80003b43:	eb 03                	jmp    80003b48 <vprintfmt+0x35>
80003b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
				return;
			putch(ch, putdat);
80003b48:	83 ec 08             	sub    $0x8,%esp
80003b4b:	57                   	push   %edi
80003b4c:	50                   	push   %eax
80003b4d:	ff d3                	call   *%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
80003b4f:	83 c6 01             	add    $0x1,%esi
80003b52:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80003b56:	83 c4 10             	add    $0x10,%esp
80003b59:	83 f8 25             	cmp    $0x25,%eax
80003b5c:	75 dd                	jne    80003b3b <vprintfmt+0x28>
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
80003b5e:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
80003b62:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80003b69:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80003b70:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80003b77:	ba 00 00 00 00       	mov    $0x0,%edx
80003b7c:	bb 00 00 00 00       	mov    $0x0,%ebx
80003b81:	eb 07                	jmp    80003b8a <vprintfmt+0x77>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003b83:	8b 75 10             	mov    0x10(%ebp),%esi

		// flag to pad on the right
		case '-':
			padc = '-';
80003b86:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003b8a:	8d 46 01             	lea    0x1(%esi),%eax
80003b8d:	89 45 10             	mov    %eax,0x10(%ebp)
80003b90:	0f b6 06             	movzbl (%esi),%eax
80003b93:	0f b6 c8             	movzbl %al,%ecx
80003b96:	83 e8 23             	sub    $0x23,%eax
80003b99:	3c 55                	cmp    $0x55,%al
80003b9b:	0f 87 15 03 00 00    	ja     80003eb6 <vprintfmt+0x3a3>
80003ba1:	0f b6 c0             	movzbl %al,%eax
80003ba4:	ff 24 85 e0 47 00 80 	jmp    *-0x7fffb820(,%eax,4)
80003bab:	8b 75 10             	mov    0x10(%ebp),%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
80003bae:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
80003bb2:	eb d6                	jmp    80003b8a <vprintfmt+0x77>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
80003bb4:	8d 41 d0             	lea    -0x30(%ecx),%eax
80003bb7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
80003bba:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
80003bbe:	8d 48 d0             	lea    -0x30(%eax),%ecx
80003bc1:	83 f9 09             	cmp    $0x9,%ecx
80003bc4:	77 5b                	ja     80003c21 <vprintfmt+0x10e>
80003bc6:	8b 75 10             	mov    0x10(%ebp),%esi
80003bc9:	89 55 d0             	mov    %edx,-0x30(%ebp)
80003bcc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
80003bcf:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
80003bd2:	8d 14 92             	lea    (%edx,%edx,4),%edx
80003bd5:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
				ch = *fmt;
80003bd9:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
80003bdc:	8d 48 d0             	lea    -0x30(%eax),%ecx
80003bdf:	83 f9 09             	cmp    $0x9,%ecx
80003be2:	76 eb                	jbe    80003bcf <vprintfmt+0xbc>
80003be4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80003be7:	8b 55 d0             	mov    -0x30(%ebp),%edx
80003bea:	eb 38                	jmp    80003c24 <vprintfmt+0x111>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
80003bec:	8b 45 14             	mov    0x14(%ebp),%eax
80003bef:	8d 48 04             	lea    0x4(%eax),%ecx
80003bf2:	89 4d 14             	mov    %ecx,0x14(%ebp)
80003bf5:	8b 00                	mov    (%eax),%eax
80003bf7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003bfa:	8b 75 10             	mov    0x10(%ebp),%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
80003bfd:	eb 25                	jmp    80003c24 <vprintfmt+0x111>
80003bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80003c02:	85 c0                	test   %eax,%eax
80003c04:	0f 48 c3             	cmovs  %ebx,%eax
80003c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003c0a:	8b 75 10             	mov    0x10(%ebp),%esi
80003c0d:	e9 78 ff ff ff       	jmp    80003b8a <vprintfmt+0x77>
80003c12:	8b 75 10             	mov    0x10(%ebp),%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
80003c15:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
80003c1c:	e9 69 ff ff ff       	jmp    80003b8a <vprintfmt+0x77>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003c21:	8b 75 10             	mov    0x10(%ebp),%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
80003c24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80003c28:	0f 89 5c ff ff ff    	jns    80003b8a <vprintfmt+0x77>
				width = precision, precision = -1;
80003c2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80003c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80003c34:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80003c3b:	e9 4a ff ff ff       	jmp    80003b8a <vprintfmt+0x77>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
80003c40:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
80003c43:	8b 75 10             	mov    0x10(%ebp),%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
80003c46:	e9 3f ff ff ff       	jmp    80003b8a <vprintfmt+0x77>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
80003c4b:	8b 45 14             	mov    0x14(%ebp),%eax
80003c4e:	8d 50 04             	lea    0x4(%eax),%edx
80003c51:	89 55 14             	mov    %edx,0x14(%ebp)
80003c54:	83 ec 08             	sub    $0x8,%esp
80003c57:	57                   	push   %edi
80003c58:	ff 30                	pushl  (%eax)
80003c5a:	ff 55 08             	call   *0x8(%ebp)
			break;
80003c5d:	83 c4 10             	add    $0x10,%esp
80003c60:	e9 bf fe ff ff       	jmp    80003b24 <vprintfmt+0x11>

		// error message
		case 'e':
			err = va_arg(ap, int);
80003c65:	8b 45 14             	mov    0x14(%ebp),%eax
80003c68:	8d 50 04             	lea    0x4(%eax),%edx
80003c6b:	89 55 14             	mov    %edx,0x14(%ebp)
80003c6e:	8b 00                	mov    (%eax),%eax
80003c70:	99                   	cltd   
80003c71:	31 d0                	xor    %edx,%eax
80003c73:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
80003c75:	83 f8 11             	cmp    $0x11,%eax
80003c78:	7f 0b                	jg     80003c85 <vprintfmt+0x172>
80003c7a:	8b 14 85 40 49 00 80 	mov    -0x7fffb6c0(,%eax,4),%edx
80003c81:	85 d2                	test   %edx,%edx
80003c83:	75 17                	jne    80003c9c <vprintfmt+0x189>
				printfmt(putch, putdat, "error %d", err);
80003c85:	50                   	push   %eax
80003c86:	68 9f 46 00 80       	push   $0x8000469f
80003c8b:	57                   	push   %edi
80003c8c:	ff 75 08             	pushl  0x8(%ebp)
80003c8f:	e8 6b 03 00 00       	call   80003fff <printfmt>
80003c94:	83 c4 10             	add    $0x10,%esp
80003c97:	e9 88 fe ff ff       	jmp    80003b24 <vprintfmt+0x11>
			else
				printfmt(putch, putdat, "%s", p);
80003c9c:	52                   	push   %edx
80003c9d:	68 a2 42 00 80       	push   $0x800042a2
80003ca2:	57                   	push   %edi
80003ca3:	ff 75 08             	pushl  0x8(%ebp)
80003ca6:	e8 54 03 00 00       	call   80003fff <printfmt>
80003cab:	83 c4 10             	add    $0x10,%esp
80003cae:	e9 71 fe ff ff       	jmp    80003b24 <vprintfmt+0x11>
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
80003cb3:	8b 45 14             	mov    0x14(%ebp),%eax
80003cb6:	8d 50 04             	lea    0x4(%eax),%edx
80003cb9:	89 55 14             	mov    %edx,0x14(%ebp)
80003cbc:	8b 00                	mov    (%eax),%eax
				p = "(null)";
80003cbe:	85 c0                	test   %eax,%eax
80003cc0:	b9 98 46 00 80       	mov    $0x80004698,%ecx
80003cc5:	0f 45 c8             	cmovne %eax,%ecx
80003cc8:	89 4d d0             	mov    %ecx,-0x30(%ebp)
			if (width > 0 && padc != '-')
80003ccb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80003ccf:	7e 06                	jle    80003cd7 <vprintfmt+0x1c4>
80003cd1:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
80003cd5:	75 19                	jne    80003cf0 <vprintfmt+0x1dd>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80003cd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80003cda:	8d 70 01             	lea    0x1(%eax),%esi
80003cdd:	0f b6 00             	movzbl (%eax),%eax
80003ce0:	0f be d0             	movsbl %al,%edx
80003ce3:	85 d2                	test   %edx,%edx
80003ce5:	0f 85 92 00 00 00    	jne    80003d7d <vprintfmt+0x26a>
80003ceb:	e9 82 00 00 00       	jmp    80003d72 <vprintfmt+0x25f>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
80003cf0:	83 ec 08             	sub    $0x8,%esp
80003cf3:	ff 75 d4             	pushl  -0x2c(%ebp)
80003cf6:	ff 75 d0             	pushl  -0x30(%ebp)
80003cf9:	e8 ee db ff ff       	call   800018ec <strnlen>
80003cfe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
80003d01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80003d04:	83 c4 10             	add    $0x10,%esp
80003d07:	85 c9                	test   %ecx,%ecx
80003d09:	0f 8e ce 01 00 00    	jle    80003edd <vprintfmt+0x3ca>
					putch(padc, putdat);
80003d0f:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
80003d13:	89 cb                	mov    %ecx,%ebx
80003d15:	83 ec 08             	sub    $0x8,%esp
80003d18:	57                   	push   %edi
80003d19:	56                   	push   %esi
80003d1a:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
80003d1d:	83 c4 10             	add    $0x10,%esp
80003d20:	83 eb 01             	sub    $0x1,%ebx
80003d23:	75 f0                	jne    80003d15 <vprintfmt+0x202>
80003d25:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80003d28:	e9 b0 01 00 00       	jmp    80003edd <vprintfmt+0x3ca>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
80003d2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80003d31:	74 1b                	je     80003d4e <vprintfmt+0x23b>
80003d33:	0f be c0             	movsbl %al,%eax
80003d36:	83 e8 20             	sub    $0x20,%eax
80003d39:	83 f8 5e             	cmp    $0x5e,%eax
80003d3c:	76 10                	jbe    80003d4e <vprintfmt+0x23b>
					putch('?', putdat);
80003d3e:	83 ec 08             	sub    $0x8,%esp
80003d41:	ff 75 0c             	pushl  0xc(%ebp)
80003d44:	6a 3f                	push   $0x3f
80003d46:	ff 55 08             	call   *0x8(%ebp)
80003d49:	83 c4 10             	add    $0x10,%esp
80003d4c:	eb 0d                	jmp    80003d5b <vprintfmt+0x248>
				else
					putch(ch, putdat);
80003d4e:	83 ec 08             	sub    $0x8,%esp
80003d51:	ff 75 0c             	pushl  0xc(%ebp)
80003d54:	52                   	push   %edx
80003d55:	ff 55 08             	call   *0x8(%ebp)
80003d58:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80003d5b:	83 ef 01             	sub    $0x1,%edi
80003d5e:	83 c6 01             	add    $0x1,%esi
80003d61:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80003d65:	0f be d0             	movsbl %al,%edx
80003d68:	85 d2                	test   %edx,%edx
80003d6a:	75 25                	jne    80003d91 <vprintfmt+0x27e>
80003d6c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80003d6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
80003d72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80003d76:	7f 2a                	jg     80003da2 <vprintfmt+0x28f>
80003d78:	e9 a7 fd ff ff       	jmp    80003b24 <vprintfmt+0x11>
80003d7d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80003d80:	89 7d 0c             	mov    %edi,0xc(%ebp)
80003d83:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80003d86:	eb 09                	jmp    80003d91 <vprintfmt+0x27e>
80003d88:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80003d8b:	89 7d 0c             	mov    %edi,0xc(%ebp)
80003d8e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80003d91:	85 db                	test   %ebx,%ebx
80003d93:	78 98                	js     80003d2d <vprintfmt+0x21a>
80003d95:	83 eb 01             	sub    $0x1,%ebx
80003d98:	79 93                	jns    80003d2d <vprintfmt+0x21a>
80003d9a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80003d9d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80003da0:	eb d0                	jmp    80003d72 <vprintfmt+0x25f>
80003da2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80003da5:	8b 75 08             	mov    0x8(%ebp),%esi
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
80003da8:	83 ec 08             	sub    $0x8,%esp
80003dab:	57                   	push   %edi
80003dac:	6a 20                	push   $0x20
80003dae:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
80003db0:	83 c4 10             	add    $0x10,%esp
80003db3:	83 eb 01             	sub    $0x1,%ebx
80003db6:	75 f0                	jne    80003da8 <vprintfmt+0x295>
80003db8:	e9 67 fd ff ff       	jmp    80003b24 <vprintfmt+0x11>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
80003dbd:	83 fa 01             	cmp    $0x1,%edx
80003dc0:	7e 16                	jle    80003dd8 <vprintfmt+0x2c5>
		return va_arg(*ap, long long);
80003dc2:	8b 45 14             	mov    0x14(%ebp),%eax
80003dc5:	8d 50 08             	lea    0x8(%eax),%edx
80003dc8:	89 55 14             	mov    %edx,0x14(%ebp)
80003dcb:	8b 50 04             	mov    0x4(%eax),%edx
80003dce:	8b 00                	mov    (%eax),%eax
80003dd0:	89 45 d8             	mov    %eax,-0x28(%ebp)
80003dd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80003dd6:	eb 32                	jmp    80003e0a <vprintfmt+0x2f7>
	else if (lflag)
80003dd8:	85 d2                	test   %edx,%edx
80003dda:	74 18                	je     80003df4 <vprintfmt+0x2e1>
		return va_arg(*ap, long);
80003ddc:	8b 45 14             	mov    0x14(%ebp),%eax
80003ddf:	8d 50 04             	lea    0x4(%eax),%edx
80003de2:	89 55 14             	mov    %edx,0x14(%ebp)
80003de5:	8b 30                	mov    (%eax),%esi
80003de7:	89 75 d8             	mov    %esi,-0x28(%ebp)
80003dea:	89 f0                	mov    %esi,%eax
80003dec:	c1 f8 1f             	sar    $0x1f,%eax
80003def:	89 45 dc             	mov    %eax,-0x24(%ebp)
80003df2:	eb 16                	jmp    80003e0a <vprintfmt+0x2f7>
	else
		return va_arg(*ap, int);
80003df4:	8b 45 14             	mov    0x14(%ebp),%eax
80003df7:	8d 50 04             	lea    0x4(%eax),%edx
80003dfa:	89 55 14             	mov    %edx,0x14(%ebp)
80003dfd:	8b 30                	mov    (%eax),%esi
80003dff:	89 75 d8             	mov    %esi,-0x28(%ebp)
80003e02:	89 f0                	mov    %esi,%eax
80003e04:	c1 f8 1f             	sar    $0x1f,%eax
80003e07:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
80003e0a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
80003e0d:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
80003e12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80003e16:	79 70                	jns    80003e88 <vprintfmt+0x375>
				putch('-', putdat);
80003e18:	83 ec 08             	sub    $0x8,%esp
80003e1b:	57                   	push   %edi
80003e1c:	6a 2d                	push   $0x2d
80003e1e:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
80003e21:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80003e24:	f7 d9                	neg    %ecx
80003e26:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
80003e29:	b8 0a 00 00 00       	mov    $0xa,%eax
80003e2e:	eb 58                	jmp    80003e88 <vprintfmt+0x375>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
80003e30:	8d 45 14             	lea    0x14(%ebp),%eax
80003e33:	e8 4d fb ff ff       	call   80003985 <getuint>
80003e38:	89 c1                	mov    %eax,%ecx
			base = 10;
80003e3a:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
80003e3f:	eb 47                	jmp    80003e88 <vprintfmt+0x375>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
80003e41:	8d 45 14             	lea    0x14(%ebp),%eax
80003e44:	e8 3c fb ff ff       	call   80003985 <getuint>
80003e49:	89 c1                	mov    %eax,%ecx
			base = 8;
80003e4b:	b8 08 00 00 00       	mov    $0x8,%eax
			goto number;
80003e50:	eb 36                	jmp    80003e88 <vprintfmt+0x375>

		// pointer
		case 'p':
			putch('0', putdat);
80003e52:	83 ec 08             	sub    $0x8,%esp
80003e55:	57                   	push   %edi
80003e56:	6a 30                	push   $0x30
80003e58:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
80003e5b:	83 c4 08             	add    $0x8,%esp
80003e5e:	57                   	push   %edi
80003e5f:	6a 78                	push   $0x78
80003e61:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
80003e64:	8b 45 14             	mov    0x14(%ebp),%eax
80003e67:	8d 50 04             	lea    0x4(%eax),%edx
80003e6a:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
80003e6d:	8b 08                	mov    (%eax),%ecx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
80003e6f:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
80003e72:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
80003e77:	eb 0f                	jmp    80003e88 <vprintfmt+0x375>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
80003e79:	8d 45 14             	lea    0x14(%ebp),%eax
80003e7c:	e8 04 fb ff ff       	call   80003985 <getuint>
80003e81:	89 c1                	mov    %eax,%ecx
			base = 16;
80003e83:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
80003e88:	83 ec 04             	sub    $0x4,%esp
80003e8b:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
80003e8f:	56                   	push   %esi
80003e90:	ff 75 e4             	pushl  -0x1c(%ebp)
80003e93:	50                   	push   %eax
80003e94:	89 fa                	mov    %edi,%edx
80003e96:	8b 45 08             	mov    0x8(%ebp),%eax
80003e99:	e8 21 fb ff ff       	call   800039bf <printnum>
			break;
80003e9e:	83 c4 10             	add    $0x10,%esp
80003ea1:	e9 7e fc ff ff       	jmp    80003b24 <vprintfmt+0x11>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
80003ea6:	83 ec 08             	sub    $0x8,%esp
80003ea9:	57                   	push   %edi
80003eaa:	51                   	push   %ecx
80003eab:	ff 55 08             	call   *0x8(%ebp)
			break;
80003eae:	83 c4 10             	add    $0x10,%esp
80003eb1:	e9 6e fc ff ff       	jmp    80003b24 <vprintfmt+0x11>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
80003eb6:	83 ec 08             	sub    $0x8,%esp
80003eb9:	57                   	push   %edi
80003eba:	6a 25                	push   $0x25
80003ebc:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
80003ebf:	83 c4 10             	add    $0x10,%esp
80003ec2:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
80003ec6:	0f 84 55 fc ff ff    	je     80003b21 <vprintfmt+0xe>
80003ecc:	83 ee 01             	sub    $0x1,%esi
80003ecf:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
80003ed3:	75 f7                	jne    80003ecc <vprintfmt+0x3b9>
80003ed5:	89 75 10             	mov    %esi,0x10(%ebp)
80003ed8:	e9 47 fc ff ff       	jmp    80003b24 <vprintfmt+0x11>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
80003edd:	8b 45 d0             	mov    -0x30(%ebp),%eax
80003ee0:	8d 70 01             	lea    0x1(%eax),%esi
80003ee3:	0f b6 00             	movzbl (%eax),%eax
80003ee6:	0f be d0             	movsbl %al,%edx
80003ee9:	85 d2                	test   %edx,%edx
80003eeb:	0f 85 97 fe ff ff    	jne    80003d88 <vprintfmt+0x275>
80003ef1:	e9 2e fc ff ff       	jmp    80003b24 <vprintfmt+0x11>
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
80003ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003ef9:	5b                   	pop    %ebx
80003efa:	5e                   	pop    %esi
80003efb:	5f                   	pop    %edi
80003efc:	5d                   	pop    %ebp
80003efd:	c3                   	ret    

80003efe <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
80003efe:	55                   	push   %ebp
80003eff:	89 e5                	mov    %esp,%ebp
80003f01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
80003f07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80003f0e:	00 00 00 
	b.cnt = 0;
80003f11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80003f18:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
80003f1b:	ff 75 0c             	pushl  0xc(%ebp)
80003f1e:	ff 75 08             	pushl  0x8(%ebp)
80003f21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
80003f27:	50                   	push   %eax
80003f28:	68 5d 3a 00 80       	push   $0x80003a5d
80003f2d:	e8 e1 fb ff ff       	call   80003b13 <vprintfmt>
	sys_cputs(b.buf, b.idx);
80003f32:	83 c4 08             	add    $0x8,%esp
80003f35:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80003f3b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
80003f41:	50                   	push   %eax
80003f42:	e8 05 de ff ff       	call   80001d4c <sys_cputs>

	return b.cnt;
}
80003f47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80003f4d:	c9                   	leave  
80003f4e:	c3                   	ret    

80003f4f <cprintf>:

int
cprintf(const char *fmt, ...)
{
80003f4f:	55                   	push   %ebp
80003f50:	89 e5                	mov    %esp,%ebp
80003f52:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80003f55:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
80003f58:	50                   	push   %eax
80003f59:	ff 75 08             	pushl  0x8(%ebp)
80003f5c:	e8 9d ff ff ff       	call   80003efe <vcprintf>
	va_end(ap);

	return cnt;
}
80003f61:	c9                   	leave  
80003f62:	c3                   	ret    

80003f63 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
80003f63:	55                   	push   %ebp
80003f64:	89 e5                	mov    %esp,%ebp
80003f66:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct fprintbuf b;

	b.fd = fd;
80003f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80003f6f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
80003f75:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80003f7c:	00 00 00 
	b.result = 0;
80003f7f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80003f86:	00 00 00 
	b.error = 1;
80003f89:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
80003f90:	00 00 00 
	vprintfmt(fputch, &b, fmt, ap);
80003f93:	ff 75 10             	pushl  0x10(%ebp)
80003f96:	ff 75 0c             	pushl  0xc(%ebp)
80003f99:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80003f9f:	50                   	push   %eax
80003fa0:	68 de 3a 00 80       	push   $0x80003ade
80003fa5:	e8 69 fb ff ff       	call   80003b13 <vprintfmt>
	if (b.idx > 0)
80003faa:	83 c4 10             	add    $0x10,%esp
80003fad:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
80003fb4:	7e 0b                	jle    80003fc1 <vfprintf+0x5e>
		writebuf(&b);
80003fb6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80003fbc:	e8 de fa ff ff       	call   80003a9f <writebuf>

	return (b.result ? b.result : b.error);
80003fc1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80003fc7:	85 c0                	test   %eax,%eax
80003fc9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
80003fd0:	c9                   	leave  
80003fd1:	c3                   	ret    

80003fd2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
80003fd2:	55                   	push   %ebp
80003fd3:	89 e5                	mov    %esp,%ebp
80003fd5:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80003fd8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
80003fdb:	50                   	push   %eax
80003fdc:	ff 75 0c             	pushl  0xc(%ebp)
80003fdf:	ff 75 08             	pushl  0x8(%ebp)
80003fe2:	e8 7c ff ff ff       	call   80003f63 <vfprintf>
	va_end(ap);

	return cnt;
}
80003fe7:	c9                   	leave  
80003fe8:	c3                   	ret    

80003fe9 <printf>:

int
printf(const char *fmt, ...)
{
80003fe9:	55                   	push   %ebp
80003fea:	89 e5                	mov    %esp,%ebp
80003fec:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
80003fef:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
80003ff2:	50                   	push   %eax
80003ff3:	ff 75 08             	pushl  0x8(%ebp)
80003ff6:	6a 01                	push   $0x1
80003ff8:	e8 66 ff ff ff       	call   80003f63 <vfprintf>
	va_end(ap);

	return cnt;
}
80003ffd:	c9                   	leave  
80003ffe:	c3                   	ret    

80003fff <printfmt>:
	putch("0123456789abcdef"[num % base], putdat);
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
80003fff:	55                   	push   %ebp
80004000:	89 e5                	mov    %esp,%ebp
80004002:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
80004005:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
80004008:	50                   	push   %eax
80004009:	ff 75 10             	pushl  0x10(%ebp)
8000400c:	ff 75 0c             	pushl  0xc(%ebp)
8000400f:	ff 75 08             	pushl  0x8(%ebp)
80004012:	e8 fc fa ff ff       	call   80003b13 <vprintfmt>
	va_end(ap);
}
80004017:	83 c4 10             	add    $0x10,%esp
8000401a:	c9                   	leave  
8000401b:	c3                   	ret    

8000401c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
8000401c:	55                   	push   %ebp
8000401d:	89 e5                	mov    %esp,%ebp
8000401f:	83 ec 18             	sub    $0x18,%esp
80004022:	8b 45 08             	mov    0x8(%ebp),%eax
80004025:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
80004028:	89 45 ec             	mov    %eax,-0x14(%ebp)
8000402b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
8000402f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80004032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
80004039:	85 c0                	test   %eax,%eax
8000403b:	74 26                	je     80004063 <vsnprintf+0x47>
8000403d:	85 d2                	test   %edx,%edx
8000403f:	7e 22                	jle    80004063 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
80004041:	ff 75 14             	pushl  0x14(%ebp)
80004044:	ff 75 10             	pushl  0x10(%ebp)
80004047:	8d 45 ec             	lea    -0x14(%ebp),%eax
8000404a:	50                   	push   %eax
8000404b:	68 40 3a 00 80       	push   $0x80003a40
80004050:	e8 be fa ff ff       	call   80003b13 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
80004055:	8b 45 ec             	mov    -0x14(%ebp),%eax
80004058:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
8000405b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000405e:	83 c4 10             	add    $0x10,%esp
80004061:	eb 05                	jmp    80004068 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
80004063:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
80004068:	c9                   	leave  
80004069:	c3                   	ret    

8000406a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
8000406a:	55                   	push   %ebp
8000406b:	89 e5                	mov    %esp,%ebp
8000406d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
80004070:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
80004073:	50                   	push   %eax
80004074:	ff 75 10             	pushl  0x10(%ebp)
80004077:	ff 75 0c             	pushl  0xc(%ebp)
8000407a:	ff 75 08             	pushl  0x8(%ebp)
8000407d:	e8 9a ff ff ff       	call   8000401c <vsnprintf>
	va_end(ap);

	return rc;
}
80004082:	c9                   	leave  
80004083:	c3                   	ret    

80004084 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
80004084:	55                   	push   %ebp
80004085:	89 e5                	mov    %esp,%ebp
80004087:	57                   	push   %edi
80004088:	56                   	push   %esi
80004089:	53                   	push   %ebx
8000408a:	83 ec 0c             	sub    $0xc,%esp
8000408d:	8b 45 08             	mov    0x8(%ebp),%eax

#ifndef __FOR_USER__
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
80004090:	85 c0                	test   %eax,%eax
80004092:	74 13                	je     800040a7 <readline+0x23>
		fprintf(1, "%s", prompt);
80004094:	83 ec 04             	sub    $0x4,%esp
80004097:	50                   	push   %eax
80004098:	68 a2 42 00 80       	push   $0x800042a2
8000409d:	6a 01                	push   $0x1
8000409f:	e8 2e ff ff ff       	call   80003fd2 <fprintf>
800040a4:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
800040a7:	83 ec 0c             	sub    $0xc,%esp
800040aa:	6a 00                	push   $0x0
800040ac:	e8 57 e0 ff ff       	call   80002108 <iscons>
800040b1:	89 c7                	mov    %eax,%edi
800040b3:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
800040b6:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
800040bb:	e8 1d e0 ff ff       	call   800020dd <getchar>
800040c0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
800040c2:	85 c0                	test   %eax,%eax
800040c4:	79 29                	jns    800040ef <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
800040c6:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
800040cb:	83 fb f8             	cmp    $0xfffffff8,%ebx
800040ce:	0f 84 9b 00 00 00    	je     8000416f <readline+0xeb>
				cprintf("read error: %e\n", c);
800040d4:	83 ec 08             	sub    $0x8,%esp
800040d7:	53                   	push   %ebx
800040d8:	68 a8 46 00 80       	push   $0x800046a8
800040dd:	e8 6d fe ff ff       	call   80003f4f <cprintf>
800040e2:	83 c4 10             	add    $0x10,%esp
			return NULL;
800040e5:	b8 00 00 00 00       	mov    $0x0,%eax
800040ea:	e9 80 00 00 00       	jmp    8000416f <readline+0xeb>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
800040ef:	83 f8 08             	cmp    $0x8,%eax
800040f2:	0f 94 c2             	sete   %dl
800040f5:	83 f8 7f             	cmp    $0x7f,%eax
800040f8:	0f 94 c0             	sete   %al
800040fb:	08 c2                	or     %al,%dl
800040fd:	74 1a                	je     80004119 <readline+0x95>
800040ff:	85 f6                	test   %esi,%esi
80004101:	7e 16                	jle    80004119 <readline+0x95>
			if (echoing)
80004103:	85 ff                	test   %edi,%edi
80004105:	74 0d                	je     80004114 <readline+0x90>
				cputchar('\b');
80004107:	83 ec 0c             	sub    $0xc,%esp
8000410a:	6a 08                	push   $0x8
8000410c:	e8 b0 df ff ff       	call   800020c1 <cputchar>
80004111:	83 c4 10             	add    $0x10,%esp
			i--;
80004114:	83 ee 01             	sub    $0x1,%esi
80004117:	eb a2                	jmp    800040bb <readline+0x37>
		} else if (c >= ' ' && i < BUFLEN-1) {
80004119:	83 fb 1f             	cmp    $0x1f,%ebx
8000411c:	7e 26                	jle    80004144 <readline+0xc0>
8000411e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
80004124:	7f 1e                	jg     80004144 <readline+0xc0>
			if (echoing)
80004126:	85 ff                	test   %edi,%edi
80004128:	74 0c                	je     80004136 <readline+0xb2>
				cputchar(c);
8000412a:	83 ec 0c             	sub    $0xc,%esp
8000412d:	53                   	push   %ebx
8000412e:	e8 8e df ff ff       	call   800020c1 <cputchar>
80004133:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
80004136:	88 9e 20 60 00 80    	mov    %bl,-0x7fff9fe0(%esi)
8000413c:	8d 76 01             	lea    0x1(%esi),%esi
8000413f:	e9 77 ff ff ff       	jmp    800040bb <readline+0x37>
		} else if (c == '\n' || c == '\r') {
80004144:	83 fb 0a             	cmp    $0xa,%ebx
80004147:	74 09                	je     80004152 <readline+0xce>
80004149:	83 fb 0d             	cmp    $0xd,%ebx
8000414c:	0f 85 69 ff ff ff    	jne    800040bb <readline+0x37>
			if (echoing)
80004152:	85 ff                	test   %edi,%edi
80004154:	74 0d                	je     80004163 <readline+0xdf>
				cputchar('\n');
80004156:	83 ec 0c             	sub    $0xc,%esp
80004159:	6a 0a                	push   $0xa
8000415b:	e8 61 df ff ff       	call   800020c1 <cputchar>
80004160:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
80004163:	c6 86 20 60 00 80 00 	movb   $0x0,-0x7fff9fe0(%esi)
			return buf;
8000416a:	b8 20 60 00 80       	mov    $0x80006020,%eax
		}
	}
}
8000416f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80004172:	5b                   	pop    %ebx
80004173:	5e                   	pop    %esi
80004174:	5f                   	pop    %edi
80004175:	5d                   	pop    %ebp
80004176:	c3                   	ret    

80004177 <_panic>:
 */
#include <syslib.h>

void
_panic(const char *file, int line, const char *fmt, ...)
{
80004177:	55                   	push   %ebp
80004178:	89 e5                	mov    %esp,%ebp
8000417a:	56                   	push   %esi
8000417b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
8000417c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
8000417f:	8b 35 00 50 00 80    	mov    0x80005000,%esi
80004185:	e8 40 dc ff ff       	call   80001dca <sys_getenvid>
8000418a:	83 ec 0c             	sub    $0xc,%esp
8000418d:	ff 75 0c             	pushl  0xc(%ebp)
80004190:	ff 75 08             	pushl  0x8(%ebp)
80004193:	56                   	push   %esi
80004194:	50                   	push   %eax
80004195:	68 88 49 00 80       	push   $0x80004988
8000419a:	e8 b0 fd ff ff       	call   80003f4f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
8000419f:	83 c4 18             	add    $0x18,%esp
800041a2:	53                   	push   %ebx
800041a3:	ff 75 10             	pushl  0x10(%ebp)
800041a6:	e8 53 fd ff ff       	call   80003efe <vcprintf>
	cprintf("\n");
800041ab:	c7 04 24 e0 41 00 80 	movl   $0x800041e0,(%esp)
800041b2:	e8 98 fd ff ff       	call   80003f4f <cprintf>
800041b7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
800041ba:	cc                   	int3   
800041bb:	eb fd                	jmp    800041ba <_panic+0x43>
