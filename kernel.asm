
kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 c0 10 f0       	mov    $0xf010c000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 9c 05 00 00       	call   f01005da <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <boot_alloc>:
f0100040:	83 3d 40 f9 11 f0 00 	cmpl   $0x0,0xf011f940
f0100047:	55                   	push   %ebp
f0100048:	89 e5                	mov    %esp,%ebp
f010004a:	75 11                	jne    f010005d <boot_alloc+0x1d>
f010004c:	ba cf 18 12 f0       	mov    $0xf01218cf,%edx
f0100051:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100057:	89 15 40 f9 11 f0    	mov    %edx,0xf011f940
f010005d:	85 c0                	test   %eax,%eax
f010005f:	8b 0d 40 f9 11 f0    	mov    0xf011f940,%ecx
f0100065:	74 13                	je     f010007a <boot_alloc+0x3a>
f0100067:	8d 94 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edx
f010006e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100074:	89 15 40 f9 11 f0    	mov    %edx,0xf011f940
f010007a:	89 c8                	mov    %ecx,%eax
f010007c:	5d                   	pop    %ebp
f010007d:	c3                   	ret    

f010007e <mc146818_read>:
f010007e:	55                   	push   %ebp
f010007f:	ba 70 00 00 00       	mov    $0x70,%edx
f0100084:	89 e5                	mov    %esp,%ebp
f0100086:	8b 45 08             	mov    0x8(%ebp),%eax
f0100089:	ee                   	out    %al,(%dx)
f010008a:	b2 71                	mov    $0x71,%dl
f010008c:	ec                   	in     (%dx),%al
f010008d:	0f b6 c0             	movzbl %al,%eax
f0100090:	5d                   	pop    %ebp
f0100091:	c3                   	ret    

f0100092 <page_init>:
f0100092:	a1 c0 08 12 f0       	mov    0xf01208c0,%eax
f0100097:	55                   	push   %ebp
f0100098:	89 e5                	mov    %esp,%ebp
f010009a:	56                   	push   %esi
f010009b:	53                   	push   %ebx
f010009c:	8d 70 ff             	lea    -0x1(%eax),%esi
f010009f:	8d 1c c5 f8 ff ff ff 	lea    -0x8(,%eax,8),%ebx
f01000a6:	85 f6                	test   %esi,%esi
f01000a8:	0f 84 aa 00 00 00    	je     f0100158 <page_init+0xc6>
f01000ae:	a1 48 f9 11 f0       	mov    0xf011f948,%eax
f01000b3:	89 c2                	mov    %eax,%edx
f01000b5:	c1 ea 0c             	shr    $0xc,%edx
f01000b8:	39 d6                	cmp    %edx,%esi
f01000ba:	75 0f                	jne    f01000cb <page_init+0x39>
f01000bc:	a1 c8 08 12 f0       	mov    0xf01208c8,%eax
f01000c1:	01 d8                	add    %ebx,%eax
f01000c3:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
f01000c9:	eb 17                	jmp    f01000e2 <page_init+0x50>
f01000cb:	39 c6                	cmp    %eax,%esi
f01000cd:	72 2e                	jb     f01000fd <page_init+0x6b>
f01000cf:	81 fe 00 01 00 00    	cmp    $0x100,%esi
f01000d5:	77 13                	ja     f01000ea <page_init+0x58>
f01000d7:	a1 c8 08 12 f0       	mov    0xf01208c8,%eax
f01000dc:	01 d8                	add    %ebx,%eax
f01000de:	66 ff 40 04          	incw   0x4(%eax)
f01000e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01000e8:	eb 34                	jmp    f010011e <page_init+0x8c>
f01000ea:	31 c0                	xor    %eax,%eax
f01000ec:	e8 4f ff ff ff       	call   f0100040 <boot_alloc>
f01000f1:	05 00 00 00 10       	add    $0x10000000,%eax
f01000f6:	c1 e8 0c             	shr    $0xc,%eax
f01000f9:	39 c6                	cmp    %eax,%esi
f01000fb:	72 da                	jb     f01000d7 <page_init+0x45>
f01000fd:	a1 c8 08 12 f0       	mov    0xf01208c8,%eax
f0100102:	01 d8                	add    %ebx,%eax
f0100104:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
f010010a:	8b 15 44 f9 11 f0    	mov    0xf011f944,%edx
f0100110:	89 10                	mov    %edx,(%eax)
f0100112:	a1 c8 08 12 f0       	mov    0xf01208c8,%eax
f0100117:	01 d8                	add    %ebx,%eax
f0100119:	a3 44 f9 11 f0       	mov    %eax,0xf011f944
f010011e:	89 d8                	mov    %ebx,%eax
f0100120:	8b 15 c8 08 12 f0    	mov    0xf01208c8,%edx
f0100126:	c1 f8 03             	sar    $0x3,%eax
f0100129:	c1 e0 0c             	shl    $0xc,%eax
f010012c:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100131:	74 04                	je     f0100137 <page_init+0xa5>
f0100133:	85 c0                	test   %eax,%eax
f0100135:	75 18                	jne    f010014f <page_init+0xbd>
f0100137:	66 83 7c 1a 04 00    	cmpw   $0x0,0x4(%edx,%ebx,1)
f010013d:	75 10                	jne    f010014f <page_init+0xbd>
f010013f:	50                   	push   %eax
f0100140:	50                   	push   %eax
f0100141:	56                   	push   %esi
f0100142:	68 80 2a 10 f0       	push   $0xf0102a80
f0100147:	e8 1a 23 00 00       	call   f0102466 <cprintf>
f010014c:	83 c4 10             	add    $0x10,%esp
f010014f:	4e                   	dec    %esi
f0100150:	83 eb 08             	sub    $0x8,%ebx
f0100153:	e9 4e ff ff ff       	jmp    f01000a6 <page_init+0x14>
f0100158:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010015b:	5b                   	pop    %ebx
f010015c:	5e                   	pop    %esi
f010015d:	5d                   	pop    %ebp
f010015e:	c3                   	ret    

f010015f <page_alloc>:
f010015f:	55                   	push   %ebp
f0100160:	89 e5                	mov    %esp,%ebp
f0100162:	53                   	push   %ebx
f0100163:	52                   	push   %edx
f0100164:	8b 1d 44 f9 11 f0    	mov    0xf011f944,%ebx
f010016a:	85 db                	test   %ebx,%ebx
f010016c:	74 38                	je     f01001a6 <page_alloc+0x47>
f010016e:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100172:	8b 03                	mov    (%ebx),%eax
f0100174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f010017a:	a3 44 f9 11 f0       	mov    %eax,0xf011f944
f010017f:	74 25                	je     f01001a6 <page_alloc+0x47>
f0100181:	89 da                	mov    %ebx,%edx
f0100183:	2b 15 c8 08 12 f0    	sub    0xf01208c8,%edx
f0100189:	50                   	push   %eax
f010018a:	68 00 10 00 00       	push   $0x1000
f010018f:	6a 00                	push   $0x0
f0100191:	c1 fa 03             	sar    $0x3,%edx
f0100194:	c1 e2 0c             	shl    $0xc,%edx
f0100197:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010019d:	52                   	push   %edx
f010019e:	e8 71 26 00 00       	call   f0102814 <memset>
f01001a3:	83 c4 10             	add    $0x10,%esp
f01001a6:	89 d8                	mov    %ebx,%eax
f01001a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01001ab:	c9                   	leave  
f01001ac:	c3                   	ret    

f01001ad <page_free>:
f01001ad:	55                   	push   %ebp
f01001ae:	89 e5                	mov    %esp,%ebp
f01001b0:	83 ec 08             	sub    $0x8,%esp
f01001b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01001b6:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f01001bb:	74 0d                	je     f01001ca <page_free+0x1d>
f01001bd:	52                   	push   %edx
f01001be:	68 92 2a 10 f0       	push   $0xf0102a92
f01001c3:	68 1a 01 00 00       	push   $0x11a
f01001c8:	eb 10                	jmp    f01001da <page_free+0x2d>
f01001ca:	83 38 00             	cmpl   $0x0,(%eax)
f01001cd:	74 15                	je     f01001e4 <page_free+0x37>
f01001cf:	50                   	push   %eax
f01001d0:	68 bc 2a 10 f0       	push   $0xf0102abc
f01001d5:	68 1c 01 00 00       	push   $0x11c
f01001da:	68 b5 2a 10 f0       	push   $0xf0102ab5
f01001df:	e8 ed 23 00 00       	call   f01025d1 <_panic>
f01001e4:	8b 15 44 f9 11 f0    	mov    0xf011f944,%edx
f01001ea:	a3 44 f9 11 f0       	mov    %eax,0xf011f944
f01001ef:	89 10                	mov    %edx,(%eax)
f01001f1:	c9                   	leave  
f01001f2:	c3                   	ret    

f01001f3 <page_decref>:
f01001f3:	55                   	push   %ebp
f01001f4:	89 e5                	mov    %esp,%ebp
f01001f6:	8b 55 08             	mov    0x8(%ebp),%edx
f01001f9:	66 ff 4a 04          	decw   0x4(%edx)
f01001fd:	75 03                	jne    f0100202 <page_decref+0xf>
f01001ff:	5d                   	pop    %ebp
f0100200:	eb ab                	jmp    f01001ad <page_free>
f0100202:	5d                   	pop    %ebp
f0100203:	c3                   	ret    

f0100204 <pgdir_walk>:
f0100204:	55                   	push   %ebp
f0100205:	89 e5                	mov    %esp,%ebp
f0100207:	53                   	push   %ebx
f0100208:	50                   	push   %eax
f0100209:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010020c:	8b 55 08             	mov    0x8(%ebp),%edx
f010020f:	c1 eb 16             	shr    $0x16,%ebx
f0100212:	8d 1c 9a             	lea    (%edx,%ebx,4),%ebx
f0100215:	8b 13                	mov    (%ebx),%edx
f0100217:	85 d2                	test   %edx,%edx
f0100219:	75 36                	jne    f0100251 <pgdir_walk+0x4d>
f010021b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010021f:	75 04                	jne    f0100225 <pgdir_walk+0x21>
f0100221:	31 c0                	xor    %eax,%eax
f0100223:	eb 45                	jmp    f010026a <pgdir_walk+0x66>
f0100225:	83 ec 0c             	sub    $0xc,%esp
f0100228:	6a 01                	push   $0x1
f010022a:	e8 30 ff ff ff       	call   f010015f <page_alloc>
f010022f:	83 c4 10             	add    $0x10,%esp
f0100232:	85 c0                	test   %eax,%eax
f0100234:	74 eb                	je     f0100221 <pgdir_walk+0x1d>
f0100236:	66 ff 40 04          	incw   0x4(%eax)
f010023a:	2b 05 c8 08 12 f0    	sub    0xf01208c8,%eax
f0100240:	89 c2                	mov    %eax,%edx
f0100242:	c1 fa 03             	sar    $0x3,%edx
f0100245:	c1 e2 0c             	shl    $0xc,%edx
f0100248:	0b 13                	or     (%ebx),%edx
f010024a:	89 d0                	mov    %edx,%eax
f010024c:	83 c8 07             	or     $0x7,%eax
f010024f:	89 03                	mov    %eax,(%ebx)
f0100251:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100254:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010025a:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100260:	c1 e8 0a             	shr    $0xa,%eax
f0100263:	25 fc 0f 00 00       	and    $0xffc,%eax
f0100268:	01 d0                	add    %edx,%eax
f010026a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010026d:	c9                   	leave  
f010026e:	c3                   	ret    

f010026f <boot_map_region>:
f010026f:	55                   	push   %ebp
f0100270:	89 e5                	mov    %esp,%ebp
f0100272:	57                   	push   %edi
f0100273:	56                   	push   %esi
f0100274:	53                   	push   %ebx
f0100275:	89 c7                	mov    %eax,%edi
f0100277:	89 ce                	mov    %ecx,%esi
f0100279:	31 db                	xor    %ebx,%ebx
f010027b:	83 ec 1c             	sub    $0x1c,%esp
f010027e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100281:	83 c8 01             	or     $0x1,%eax
f0100284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100287:	39 f3                	cmp    %esi,%ebx
f0100289:	73 2e                	jae    f01002b9 <boot_map_region+0x4a>
f010028b:	50                   	push   %eax
f010028c:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f010028f:	6a 01                	push   $0x1
f0100291:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100294:	50                   	push   %eax
f0100295:	57                   	push   %edi
f0100296:	e8 69 ff ff ff       	call   f0100204 <pgdir_walk>
f010029b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010029e:	83 c4 10             	add    $0x10,%esp
f01002a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01002a4:	01 d9                	add    %ebx,%ecx
f01002a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01002ac:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01002b2:	0b 4d e4             	or     -0x1c(%ebp),%ecx
f01002b5:	89 08                	mov    %ecx,(%eax)
f01002b7:	eb ce                	jmp    f0100287 <boot_map_region+0x18>
f01002b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01002bc:	5b                   	pop    %ebx
f01002bd:	5e                   	pop    %esi
f01002be:	5f                   	pop    %edi
f01002bf:	5d                   	pop    %ebp
f01002c0:	c3                   	ret    

f01002c1 <mem_init>:
f01002c1:	55                   	push   %ebp
f01002c2:	b0 15                	mov    $0x15,%al
f01002c4:	89 e5                	mov    %esp,%ebp
f01002c6:	57                   	push   %edi
f01002c7:	56                   	push   %esi
f01002c8:	53                   	push   %ebx
f01002c9:	bf 70 00 00 00       	mov    $0x70,%edi
f01002ce:	89 fa                	mov    %edi,%edx
f01002d0:	83 ec 0c             	sub    $0xc,%esp
f01002d3:	ee                   	out    %al,(%dx)
f01002d4:	be 71 00 00 00       	mov    $0x71,%esi
f01002d9:	89 f2                	mov    %esi,%edx
f01002db:	ec                   	in     (%dx),%al
f01002dc:	0f b6 c8             	movzbl %al,%ecx
f01002df:	89 fa                	mov    %edi,%edx
f01002e1:	b0 16                	mov    $0x16,%al
f01002e3:	ee                   	out    %al,(%dx)
f01002e4:	89 f2                	mov    %esi,%edx
f01002e6:	ec                   	in     (%dx),%al
f01002e7:	0f b6 d8             	movzbl %al,%ebx
f01002ea:	89 fa                	mov    %edi,%edx
f01002ec:	b0 17                	mov    $0x17,%al
f01002ee:	c1 e3 08             	shl    $0x8,%ebx
f01002f1:	09 cb                	or     %ecx,%ebx
f01002f3:	c1 fb 02             	sar    $0x2,%ebx
f01002f6:	89 1d 48 f9 11 f0    	mov    %ebx,0xf011f948
f01002fc:	ee                   	out    %al,(%dx)
f01002fd:	89 f2                	mov    %esi,%edx
f01002ff:	ec                   	in     (%dx),%al
f0100300:	0f b6 c8             	movzbl %al,%ecx
f0100303:	89 fa                	mov    %edi,%edx
f0100305:	b0 18                	mov    $0x18,%al
f0100307:	ee                   	out    %al,(%dx)
f0100308:	89 f2                	mov    %esi,%edx
f010030a:	ec                   	in     (%dx),%al
f010030b:	0f b6 c0             	movzbl %al,%eax
f010030e:	c1 e0 08             	shl    $0x8,%eax
f0100311:	09 c8                	or     %ecx,%eax
f0100313:	c1 f8 02             	sar    $0x2,%eax
f0100316:	74 0c                	je     f0100324 <mem_init+0x63>
f0100318:	05 00 01 00 00       	add    $0x100,%eax
f010031d:	a3 c0 08 12 f0       	mov    %eax,0xf01208c0
f0100322:	eb 06                	jmp    f010032a <mem_init+0x69>
f0100324:	89 1d c0 08 12 f0    	mov    %ebx,0xf01208c0
f010032a:	50                   	push   %eax
f010032b:	50                   	push   %eax
f010032c:	a1 c0 08 12 f0       	mov    0xf01208c0,%eax
f0100331:	c1 e0 02             	shl    $0x2,%eax
f0100334:	50                   	push   %eax
f0100335:	68 e1 2a 10 f0       	push   $0xf0102ae1
f010033a:	e8 27 21 00 00       	call   f0102466 <cprintf>
f010033f:	b8 00 10 00 00       	mov    $0x1000,%eax
f0100344:	e8 f7 fc ff ff       	call   f0100040 <boot_alloc>
f0100349:	83 c4 0c             	add    $0xc,%esp
f010034c:	a3 c4 08 12 f0       	mov    %eax,0xf01208c4
f0100351:	68 00 10 00 00       	push   $0x1000
f0100356:	6a 00                	push   $0x0
f0100358:	50                   	push   %eax
f0100359:	e8 b6 24 00 00       	call   f0102814 <memset>
f010035e:	8b 15 c4 08 12 f0    	mov    0xf01208c4,%edx
f0100364:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
f010036a:	83 c8 05             	or     $0x5,%eax
f010036d:	89 82 f4 0e 00 00    	mov    %eax,0xef4(%edx)
f0100373:	a1 c0 08 12 f0       	mov    0xf01208c0,%eax
f0100378:	c1 e0 03             	shl    $0x3,%eax
f010037b:	e8 c0 fc ff ff       	call   f0100040 <boot_alloc>
f0100380:	8b 35 c0 08 12 f0    	mov    0xf01208c0,%esi
f0100386:	83 c4 0c             	add    $0xc,%esp
f0100389:	a3 c8 08 12 f0       	mov    %eax,0xf01208c8
f010038e:	8d 14 f5 00 00 00 00 	lea    0x0(,%esi,8),%edx
f0100395:	52                   	push   %edx
f0100396:	6a 00                	push   $0x0
f0100398:	50                   	push   %eax
f0100399:	e8 76 24 00 00       	call   f0102814 <memset>
f010039e:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01003a3:	e8 98 fc ff ff       	call   f0100040 <boot_alloc>
f01003a8:	a3 b0 04 12 f0       	mov    %eax,0xf01204b0
f01003ad:	e8 e0 fc ff ff       	call   f0100092 <page_init>
f01003b2:	a1 c0 08 12 f0       	mov    0xf01208c0,%eax
f01003b7:	5a                   	pop    %edx
f01003b8:	5b                   	pop    %ebx
f01003b9:	8d 0c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%ecx
f01003c0:	a1 c8 08 12 f0       	mov    0xf01208c8,%eax
f01003c5:	6a 05                	push   $0x5
f01003c7:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01003cc:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01003d2:	05 00 00 00 10       	add    $0x10000000,%eax
f01003d7:	50                   	push   %eax
f01003d8:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f01003dd:	e8 8d fe ff ff       	call   f010026f <boot_map_region>
f01003e2:	a1 b0 04 12 f0       	mov    0xf01204b0,%eax
f01003e7:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01003ec:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01003f1:	5e                   	pop    %esi
f01003f2:	5f                   	pop    %edi
f01003f3:	05 00 00 00 10       	add    $0x10000000,%eax
f01003f8:	6a 05                	push   $0x5
f01003fa:	50                   	push   %eax
f01003fb:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f0100400:	e8 6a fe ff ff       	call   f010026f <boot_map_region>
f0100405:	58                   	pop    %eax
f0100406:	5a                   	pop    %edx
f0100407:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f010040c:	6a 03                	push   $0x3
f010040e:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0100413:	68 00 40 10 00       	push   $0x104000
f0100418:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010041d:	e8 4d fe ff ff       	call   f010026f <boot_map_region>
f0100422:	59                   	pop    %ecx
f0100423:	5b                   	pop    %ebx
f0100424:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f0100429:	6a 03                	push   $0x3
f010042b:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0100430:	6a 00                	push   $0x0
f0100432:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0100437:	e8 33 fe ff ff       	call   f010026f <boot_map_region>
f010043c:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f0100441:	05 00 00 00 10       	add    $0x10000000,%eax
f0100446:	0f 22 d8             	mov    %eax,%cr3
f0100449:	0f 20 c0             	mov    %cr0,%eax
f010044c:	83 e0 f3             	and    $0xfffffff3,%eax
f010044f:	0d 23 00 05 80       	or     $0x80050023,%eax
f0100454:	0f 22 c0             	mov    %eax,%cr0
f0100457:	83 c4 10             	add    $0x10,%esp
f010045a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010045d:	5b                   	pop    %ebx
f010045e:	5e                   	pop    %esi
f010045f:	5f                   	pop    %edi
f0100460:	5d                   	pop    %ebp
f0100461:	c3                   	ret    

f0100462 <page_lookup>:
f0100462:	55                   	push   %ebp
f0100463:	89 e5                	mov    %esp,%ebp
f0100465:	53                   	push   %ebx
f0100466:	83 ec 08             	sub    $0x8,%esp
f0100469:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010046c:	6a 00                	push   $0x0
f010046e:	ff 75 0c             	pushl  0xc(%ebp)
f0100471:	ff 75 08             	pushl  0x8(%ebp)
f0100474:	e8 8b fd ff ff       	call   f0100204 <pgdir_walk>
f0100479:	89 c2                	mov    %eax,%edx
f010047b:	83 c4 10             	add    $0x10,%esp
f010047e:	31 c0                	xor    %eax,%eax
f0100480:	85 d2                	test   %edx,%edx
f0100482:	74 14                	je     f0100498 <page_lookup+0x36>
f0100484:	85 db                	test   %ebx,%ebx
f0100486:	74 02                	je     f010048a <page_lookup+0x28>
f0100488:	89 13                	mov    %edx,(%ebx)
f010048a:	8b 02                	mov    (%edx),%eax
f010048c:	8b 15 c8 08 12 f0    	mov    0xf01208c8,%edx
f0100492:	c1 e8 0c             	shr    $0xc,%eax
f0100495:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0100498:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010049b:	c9                   	leave  
f010049c:	c3                   	ret    

f010049d <tlb_invalidate>:
f010049d:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01004a2:	55                   	push   %ebp
f01004a3:	89 e5                	mov    %esp,%ebp
f01004a5:	85 c0                	test   %eax,%eax
f01004a7:	74 08                	je     f01004b1 <tlb_invalidate+0x14>
f01004a9:	8b 55 08             	mov    0x8(%ebp),%edx
f01004ac:	39 50 60             	cmp    %edx,0x60(%eax)
f01004af:	75 06                	jne    f01004b7 <tlb_invalidate+0x1a>
f01004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
f01004b4:	0f 01 38             	invlpg (%eax)
f01004b7:	5d                   	pop    %ebp
f01004b8:	c3                   	ret    

f01004b9 <page_remove>:
f01004b9:	55                   	push   %ebp
f01004ba:	89 e5                	mov    %esp,%ebp
f01004bc:	56                   	push   %esi
f01004bd:	53                   	push   %ebx
f01004be:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01004c1:	83 ec 14             	sub    $0x14,%esp
f01004c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
f01004ca:	50                   	push   %eax
f01004cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01004d2:	56                   	push   %esi
f01004d3:	53                   	push   %ebx
f01004d4:	e8 89 ff ff ff       	call   f0100462 <page_lookup>
f01004d9:	83 c4 10             	add    $0x10,%esp
f01004dc:	85 c0                	test   %eax,%eax
f01004de:	74 25                	je     f0100505 <page_remove+0x4c>
f01004e0:	83 ec 0c             	sub    $0xc,%esp
f01004e3:	50                   	push   %eax
f01004e4:	e8 0a fd ff ff       	call   f01001f3 <page_decref>
f01004e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01004ec:	83 c4 10             	add    $0x10,%esp
f01004ef:	85 c0                	test   %eax,%eax
f01004f1:	74 06                	je     f01004f9 <page_remove+0x40>
f01004f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01004f9:	50                   	push   %eax
f01004fa:	50                   	push   %eax
f01004fb:	56                   	push   %esi
f01004fc:	53                   	push   %ebx
f01004fd:	e8 9b ff ff ff       	call   f010049d <tlb_invalidate>
f0100502:	83 c4 10             	add    $0x10,%esp
f0100505:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100508:	5b                   	pop    %ebx
f0100509:	5e                   	pop    %esi
f010050a:	5d                   	pop    %ebp
f010050b:	c3                   	ret    

f010050c <page_insert>:
f010050c:	55                   	push   %ebp
f010050d:	89 e5                	mov    %esp,%ebp
f010050f:	57                   	push   %edi
f0100510:	56                   	push   %esi
f0100511:	53                   	push   %ebx
f0100512:	83 ec 20             	sub    $0x20,%esp
f0100515:	8b 75 08             	mov    0x8(%ebp),%esi
f0100518:	8b 7d 10             	mov    0x10(%ebp),%edi
f010051b:	6a 01                	push   $0x1
f010051d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100520:	57                   	push   %edi
f0100521:	56                   	push   %esi
f0100522:	e8 dd fc ff ff       	call   f0100204 <pgdir_walk>
f0100527:	89 c2                	mov    %eax,%edx
f0100529:	83 c4 10             	add    $0x10,%esp
f010052c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0100531:	85 d2                	test   %edx,%edx
f0100533:	74 3f                	je     f0100574 <page_insert+0x68>
f0100535:	66 ff 43 04          	incw   0x4(%ebx)
f0100539:	f7 02 00 f0 ff ff    	testl  $0xfffff000,(%edx)
f010053f:	74 1b                	je     f010055c <page_insert+0x50>
f0100541:	50                   	push   %eax
f0100542:	50                   	push   %eax
f0100543:	57                   	push   %edi
f0100544:	56                   	push   %esi
f0100545:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100548:	e8 6c ff ff ff       	call   f01004b9 <page_remove>
f010054d:	5a                   	pop    %edx
f010054e:	59                   	pop    %ecx
f010054f:	57                   	push   %edi
f0100550:	56                   	push   %esi
f0100551:	e8 47 ff ff ff       	call   f010049d <tlb_invalidate>
f0100556:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0100559:	83 c4 10             	add    $0x10,%esp
f010055c:	2b 1d c8 08 12 f0    	sub    0xf01208c8,%ebx
f0100562:	8b 45 14             	mov    0x14(%ebp),%eax
f0100565:	83 c8 01             	or     $0x1,%eax
f0100568:	c1 fb 03             	sar    $0x3,%ebx
f010056b:	c1 e3 0c             	shl    $0xc,%ebx
f010056e:	09 c3                	or     %eax,%ebx
f0100570:	31 c0                	xor    %eax,%eax
f0100572:	89 1a                	mov    %ebx,(%edx)
f0100574:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100577:	5b                   	pop    %ebx
f0100578:	5e                   	pop    %esi
f0100579:	5f                   	pop    %edi
f010057a:	5d                   	pop    %ebp
f010057b:	c3                   	ret    

f010057c <mmio_map_region>:
f010057c:	55                   	push   %ebp
f010057d:	89 e5                	mov    %esp,%ebp
f010057f:	53                   	push   %ebx
f0100580:	51                   	push   %ecx
f0100581:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100584:	8b 15 00 e0 10 f0    	mov    0xf010e000,%edx
f010058a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0100590:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0100596:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f0100599:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f010059e:	76 15                	jbe    f01005b5 <mmio_map_region+0x39>
f01005a0:	52                   	push   %edx
f01005a1:	68 ee 2a 10 f0       	push   $0xf0102aee
f01005a6:	68 ef 01 00 00       	push   $0x1ef
f01005ab:	68 b5 2a 10 f0       	push   $0xf0102ab5
f01005b0:	e8 1c 20 00 00       	call   f01025d1 <_panic>
f01005b5:	50                   	push   %eax
f01005b6:	50                   	push   %eax
f01005b7:	89 d9                	mov    %ebx,%ecx
f01005b9:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f01005be:	6a 1a                	push   $0x1a
f01005c0:	ff 75 08             	pushl  0x8(%ebp)
f01005c3:	e8 a7 fc ff ff       	call   f010026f <boot_map_region>
f01005c8:	a1 00 e0 10 f0       	mov    0xf010e000,%eax
f01005cd:	01 c3                	add    %eax,%ebx
f01005cf:	89 1d 00 e0 10 f0    	mov    %ebx,0xf010e000
f01005d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01005d8:	c9                   	leave  
f01005d9:	c3                   	ret    

f01005da <i386_init>:
f01005da:	55                   	push   %ebp
f01005db:	b8 d0 08 12 f0       	mov    $0xf01208d0,%eax
f01005e0:	2d 28 f9 11 f0       	sub    $0xf011f928,%eax
f01005e5:	89 e5                	mov    %esp,%ebp
f01005e7:	83 ec 0c             	sub    $0xc,%esp
f01005ea:	50                   	push   %eax
f01005eb:	6a 00                	push   $0x0
f01005ed:	68 28 f9 11 f0       	push   $0xf011f928
f01005f2:	e8 1d 22 00 00       	call   f0102814 <memset>
f01005f7:	e8 59 02 00 00       	call   f0100855 <cons_init>
f01005fc:	e8 c0 fc ff ff       	call   f01002c1 <mem_init>
f0100601:	e8 a4 15 00 00       	call   f0101baa <env_init>
f0100606:	e8 71 07 00 00       	call   f0100d7c <trap_init>
f010060b:	e8 31 14 00 00       	call   f0101a41 <pic_init>
f0100610:	58                   	pop    %eax
f0100611:	5a                   	pop    %edx
f0100612:	6a 01                	push   $0x1
f0100614:	68 80 e3 10 f0       	push   $0xf010e380
f0100619:	e8 ff 16 00 00       	call   f0101d1d <env_create>
f010061e:	59                   	pop    %ecx
f010061f:	58                   	pop    %eax
f0100620:	6a 00                	push   $0x0
f0100622:	68 74 87 11 f0       	push   $0xf0118774
f0100627:	e8 f1 16 00 00       	call   f0101d1d <env_create>
f010062c:	e8 3f 13 00 00       	call   f0101970 <sched_yield>

f0100631 <delay>:
f0100631:	55                   	push   %ebp
f0100632:	ba 84 00 00 00       	mov    $0x84,%edx
f0100637:	89 e5                	mov    %esp,%ebp
f0100639:	ec                   	in     (%dx),%al
f010063a:	ec                   	in     (%dx),%al
f010063b:	ec                   	in     (%dx),%al
f010063c:	ec                   	in     (%dx),%al
f010063d:	5d                   	pop    %ebp
f010063e:	c3                   	ret    

f010063f <serial_proc_data>:
f010063f:	55                   	push   %ebp
f0100640:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100645:	89 e5                	mov    %esp,%ebp
f0100647:	ec                   	in     (%dx),%al
f0100648:	83 c9 ff             	or     $0xffffffff,%ecx
f010064b:	a8 01                	test   $0x1,%al
f010064d:	74 06                	je     f0100655 <serial_proc_data+0x16>
f010064f:	b2 f8                	mov    $0xf8,%dl
f0100651:	ec                   	in     (%dx),%al
f0100652:	0f b6 c8             	movzbl %al,%ecx
f0100655:	89 c8                	mov    %ecx,%eax
f0100657:	5d                   	pop    %ebp
f0100658:	c3                   	ret    

f0100659 <cons_intr>:
f0100659:	55                   	push   %ebp
f010065a:	89 e5                	mov    %esp,%ebp
f010065c:	56                   	push   %esi
f010065d:	53                   	push   %ebx
f010065e:	89 c6                	mov    %eax,%esi
f0100660:	ff d6                	call   *%esi
f0100662:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100665:	74 2d                	je     f0100694 <cons_intr+0x3b>
f0100667:	85 c0                	test   %eax,%eax
f0100669:	74 f5                	je     f0100660 <cons_intr+0x7>
f010066b:	8b 1d c4 fb 11 f0    	mov    0xf011fbc4,%ebx
f0100671:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0100674:	88 83 c0 f9 11 f0    	mov    %al,-0xfee0640(%ebx)
f010067a:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100680:	89 0d c4 fb 11 f0    	mov    %ecx,0xf011fbc4
f0100686:	75 d8                	jne    f0100660 <cons_intr+0x7>
f0100688:	c7 05 c4 fb 11 f0 00 	movl   $0x0,0xf011fbc4
f010068f:	00 00 00 
f0100692:	eb cc                	jmp    f0100660 <cons_intr+0x7>
f0100694:	5b                   	pop    %ebx
f0100695:	5e                   	pop    %esi
f0100696:	5d                   	pop    %ebp
f0100697:	c3                   	ret    

f0100698 <cons_putc>:
f0100698:	55                   	push   %ebp
f0100699:	89 e5                	mov    %esp,%ebp
f010069b:	56                   	push   %esi
f010069c:	31 f6                	xor    %esi,%esi
f010069e:	53                   	push   %ebx
f010069f:	89 c3                	mov    %eax,%ebx
f01006a1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006a6:	ec                   	in     (%dx),%al
f01006a7:	a8 20                	test   $0x20,%al
f01006a9:	75 10                	jne    f01006bb <cons_putc+0x23>
f01006ab:	81 fe 00 32 00 00    	cmp    $0x3200,%esi
f01006b1:	74 08                	je     f01006bb <cons_putc+0x23>
f01006b3:	e8 79 ff ff ff       	call   f0100631 <delay>
f01006b8:	46                   	inc    %esi
f01006b9:	eb e6                	jmp    f01006a1 <cons_putc+0x9>
f01006bb:	83 fb 08             	cmp    $0x8,%ebx
f01006be:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006c3:	88 d8                	mov    %bl,%al
f01006c5:	75 4a                	jne    f0100711 <cons_putc+0x79>
f01006c7:	b0 08                	mov    $0x8,%al
f01006c9:	ee                   	out    %al,(%dx)
f01006ca:	31 f6                	xor    %esi,%esi
f01006cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006d1:	ec                   	in     (%dx),%al
f01006d2:	a8 20                	test   $0x20,%al
f01006d4:	75 10                	jne    f01006e6 <cons_putc+0x4e>
f01006d6:	81 fe 00 32 00 00    	cmp    $0x3200,%esi
f01006dc:	74 08                	je     f01006e6 <cons_putc+0x4e>
f01006de:	e8 4e ff ff ff       	call   f0100631 <delay>
f01006e3:	46                   	inc    %esi
f01006e4:	eb e6                	jmp    f01006cc <cons_putc+0x34>
f01006e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01006eb:	b0 20                	mov    $0x20,%al
f01006ed:	ee                   	out    %al,(%dx)
f01006ee:	31 f6                	xor    %esi,%esi
f01006f0:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01006f5:	ec                   	in     (%dx),%al
f01006f6:	a8 20                	test   $0x20,%al
f01006f8:	75 10                	jne    f010070a <cons_putc+0x72>
f01006fa:	81 fe 00 32 00 00    	cmp    $0x3200,%esi
f0100700:	74 08                	je     f010070a <cons_putc+0x72>
f0100702:	e8 2a ff ff ff       	call   f0100631 <delay>
f0100707:	46                   	inc    %esi
f0100708:	eb e6                	jmp    f01006f0 <cons_putc+0x58>
f010070a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010070f:	b0 08                	mov    $0x8,%al
f0100711:	ee                   	out    %al,(%dx)
f0100712:	89 d8                	mov    %ebx,%eax
f0100714:	80 cc 07             	or     $0x7,%ah
f0100717:	f7 c3 00 ff ff ff    	test   $0xffffff00,%ebx
f010071d:	0f 44 d8             	cmove  %eax,%ebx
f0100720:	0f b6 c3             	movzbl %bl,%eax
f0100723:	83 f8 09             	cmp    $0x9,%eax
f0100726:	74 59                	je     f0100781 <cons_putc+0xe9>
f0100728:	7f 07                	jg     f0100731 <cons_putc+0x99>
f010072a:	83 f8 08             	cmp    $0x8,%eax
f010072d:	74 0e                	je     f010073d <cons_putc+0xa5>
f010072f:	eb 7a                	jmp    f01007ab <cons_putc+0x113>
f0100731:	83 f8 0a             	cmp    $0xa,%eax
f0100734:	74 23                	je     f0100759 <cons_putc+0xc1>
f0100736:	83 f8 0d             	cmp    $0xd,%eax
f0100739:	74 26                	je     f0100761 <cons_putc+0xc9>
f010073b:	eb 6e                	jmp    f01007ab <cons_putc+0x113>
f010073d:	66 a1 c8 fb 11 f0    	mov    0xf011fbc8,%ax
f0100743:	66 85 c0             	test   %ax,%ax
f0100746:	74 7e                	je     f01007c6 <cons_putc+0x12e>
f0100748:	48                   	dec    %eax
f0100749:	30 db                	xor    %bl,%bl
f010074b:	66 a3 c8 fb 11 f0    	mov    %ax,0xf011fbc8
f0100751:	83 cb 20             	or     $0x20,%ebx
f0100754:	0f b7 c0             	movzwl %ax,%eax
f0100757:	eb 63                	jmp    f01007bc <cons_putc+0x124>
f0100759:	66 83 05 c8 fb 11 f0 	addw   $0x50,0xf011fbc8
f0100760:	50 
f0100761:	66 a1 c8 fb 11 f0    	mov    0xf011fbc8,%ax
f0100767:	b9 50 00 00 00       	mov    $0x50,%ecx
f010076c:	31 d2                	xor    %edx,%edx
f010076e:	66 f7 f1             	div    %cx
f0100771:	66 a1 c8 fb 11 f0    	mov    0xf011fbc8,%ax
f0100777:	29 d0                	sub    %edx,%eax
f0100779:	66 a3 c8 fb 11 f0    	mov    %ax,0xf011fbc8
f010077f:	eb 45                	jmp    f01007c6 <cons_putc+0x12e>
f0100781:	b8 20 00 00 00       	mov    $0x20,%eax
f0100786:	e8 0d ff ff ff       	call   f0100698 <cons_putc>
f010078b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100790:	e8 03 ff ff ff       	call   f0100698 <cons_putc>
f0100795:	b8 20 00 00 00       	mov    $0x20,%eax
f010079a:	e8 f9 fe ff ff       	call   f0100698 <cons_putc>
f010079f:	b8 20 00 00 00       	mov    $0x20,%eax
f01007a4:	e8 ef fe ff ff       	call   f0100698 <cons_putc>
f01007a9:	eb 1b                	jmp    f01007c6 <cons_putc+0x12e>
f01007ab:	0f b7 05 c8 fb 11 f0 	movzwl 0xf011fbc8,%eax
f01007b2:	8d 50 01             	lea    0x1(%eax),%edx
f01007b5:	66 89 15 c8 fb 11 f0 	mov    %dx,0xf011fbc8
f01007bc:	8b 15 cc fb 11 f0    	mov    0xf011fbcc,%edx
f01007c2:	66 89 1c 42          	mov    %bx,(%edx,%eax,2)
f01007c6:	66 81 3d c8 fb 11 f0 	cmpw   $0x7cf,0xf011fbc8
f01007cd:	cf 07 
f01007cf:	76 3c                	jbe    f010080d <cons_putc+0x175>
f01007d1:	a1 cc fb 11 f0       	mov    0xf011fbcc,%eax
f01007d6:	52                   	push   %edx
f01007d7:	68 00 0f 00 00       	push   $0xf00
f01007dc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01007e2:	52                   	push   %edx
f01007e3:	50                   	push   %eax
f01007e4:	e8 78 20 00 00       	call   f0102861 <memmove>
f01007e9:	8b 15 cc fb 11 f0    	mov    0xf011fbcc,%edx
f01007ef:	83 c4 10             	add    $0x10,%esp
f01007f2:	b8 80 07 00 00       	mov    $0x780,%eax
f01007f7:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
f01007fd:	40                   	inc    %eax
f01007fe:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100803:	75 f2                	jne    f01007f7 <cons_putc+0x15f>
f0100805:	66 83 2d c8 fb 11 f0 	subw   $0x50,0xf011fbc8
f010080c:	50 
f010080d:	8b 0d d0 fb 11 f0    	mov    0xf011fbd0,%ecx
f0100813:	b0 0e                	mov    $0xe,%al
f0100815:	89 ca                	mov    %ecx,%edx
f0100817:	ee                   	out    %al,(%dx)
f0100818:	66 a1 c8 fb 11 f0    	mov    0xf011fbc8,%ax
f010081e:	8d 59 01             	lea    0x1(%ecx),%ebx
f0100821:	89 da                	mov    %ebx,%edx
f0100823:	66 c1 e8 08          	shr    $0x8,%ax
f0100827:	ee                   	out    %al,(%dx)
f0100828:	b0 0f                	mov    $0xf,%al
f010082a:	89 ca                	mov    %ecx,%edx
f010082c:	ee                   	out    %al,(%dx)
f010082d:	a0 c8 fb 11 f0       	mov    0xf011fbc8,%al
f0100832:	89 da                	mov    %ebx,%edx
f0100834:	ee                   	out    %al,(%dx)
f0100835:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100838:	5b                   	pop    %ebx
f0100839:	5e                   	pop    %esi
f010083a:	5d                   	pop    %ebp
f010083b:	c3                   	ret    

f010083c <serial_intr>:
f010083c:	80 3d d4 fb 11 f0 00 	cmpb   $0x0,0xf011fbd4
f0100843:	55                   	push   %ebp
f0100844:	89 e5                	mov    %esp,%ebp
f0100846:	74 0b                	je     f0100853 <serial_intr+0x17>
f0100848:	5d                   	pop    %ebp
f0100849:	b8 3f 06 10 f0       	mov    $0xf010063f,%eax
f010084e:	e9 06 fe ff ff       	jmp    f0100659 <cons_intr>
f0100853:	5d                   	pop    %ebp
f0100854:	c3                   	ret    

f0100855 <cons_init>:
f0100855:	55                   	push   %ebp
f0100856:	89 e5                	mov    %esp,%ebp
f0100858:	57                   	push   %edi
f0100859:	56                   	push   %esi
f010085a:	53                   	push   %ebx
f010085b:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f0100861:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100868:	5a a5 
f010086a:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
f0100871:	66 81 fa 5a a5       	cmp    $0xa55a,%dx
f0100876:	74 11                	je     f0100889 <cons_init+0x34>
f0100878:	c7 05 d0 fb 11 f0 b4 	movl   $0x3b4,0xf011fbd0
f010087f:	03 00 00 
f0100882:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f0100887:	eb 15                	jmp    f010089e <cons_init+0x49>
f0100889:	66 a3 00 80 0b f0    	mov    %ax,0xf00b8000
f010088f:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100894:	c7 05 d0 fb 11 f0 d4 	movl   $0x3d4,0xf011fbd0
f010089b:	03 00 00 
f010089e:	8b 3d d0 fb 11 f0    	mov    0xf011fbd0,%edi
f01008a4:	b0 0e                	mov    $0xe,%al
f01008a6:	89 fa                	mov    %edi,%edx
f01008a8:	ee                   	out    %al,(%dx)
f01008a9:	8d 4f 01             	lea    0x1(%edi),%ecx
f01008ac:	89 ca                	mov    %ecx,%edx
f01008ae:	ec                   	in     (%dx),%al
f01008af:	0f b6 c0             	movzbl %al,%eax
f01008b2:	89 fa                	mov    %edi,%edx
f01008b4:	c1 e0 08             	shl    $0x8,%eax
f01008b7:	89 c3                	mov    %eax,%ebx
f01008b9:	b0 0f                	mov    $0xf,%al
f01008bb:	ee                   	out    %al,(%dx)
f01008bc:	89 ca                	mov    %ecx,%edx
f01008be:	ec                   	in     (%dx),%al
f01008bf:	0f b6 c8             	movzbl %al,%ecx
f01008c2:	89 d8                	mov    %ebx,%eax
f01008c4:	31 db                	xor    %ebx,%ebx
f01008c6:	09 c8                	or     %ecx,%eax
f01008c8:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01008cd:	89 35 cc fb 11 f0    	mov    %esi,0xf011fbcc
f01008d3:	66 a3 c8 fb 11 f0    	mov    %ax,0xf011fbc8
f01008d9:	89 ca                	mov    %ecx,%edx
f01008db:	88 d8                	mov    %bl,%al
f01008dd:	ee                   	out    %al,(%dx)
f01008de:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01008e3:	b0 80                	mov    $0x80,%al
f01008e5:	89 fa                	mov    %edi,%edx
f01008e7:	ee                   	out    %al,(%dx)
f01008e8:	b0 0c                	mov    $0xc,%al
f01008ea:	b2 f8                	mov    $0xf8,%dl
f01008ec:	ee                   	out    %al,(%dx)
f01008ed:	be f9 03 00 00       	mov    $0x3f9,%esi
f01008f2:	88 d8                	mov    %bl,%al
f01008f4:	89 f2                	mov    %esi,%edx
f01008f6:	ee                   	out    %al,(%dx)
f01008f7:	b0 03                	mov    $0x3,%al
f01008f9:	89 fa                	mov    %edi,%edx
f01008fb:	ee                   	out    %al,(%dx)
f01008fc:	b2 fc                	mov    $0xfc,%dl
f01008fe:	88 d8                	mov    %bl,%al
f0100900:	ee                   	out    %al,(%dx)
f0100901:	b0 01                	mov    $0x1,%al
f0100903:	89 f2                	mov    %esi,%edx
f0100905:	ee                   	out    %al,(%dx)
f0100906:	b2 fd                	mov    $0xfd,%dl
f0100908:	ec                   	in     (%dx),%al
f0100909:	fe c0                	inc    %al
f010090b:	89 ca                	mov    %ecx,%edx
f010090d:	0f 95 05 d4 fb 11 f0 	setne  0xf011fbd4
f0100914:	ec                   	in     (%dx),%al
f0100915:	b2 f8                	mov    $0xf8,%dl
f0100917:	ec                   	in     (%dx),%al
f0100918:	5b                   	pop    %ebx
f0100919:	5e                   	pop    %esi
f010091a:	5f                   	pop    %edi
f010091b:	5d                   	pop    %ebp
f010091c:	c3                   	ret    

f010091d <printstr>:
f010091d:	55                   	push   %ebp
f010091e:	89 e5                	mov    %esp,%ebp
f0100920:	53                   	push   %ebx
f0100921:	52                   	push   %edx
f0100922:	31 db                	xor    %ebx,%ebx
f0100924:	8b 45 08             	mov    0x8(%ebp),%eax
f0100927:	0f be 04 18          	movsbl (%eax,%ebx,1),%eax
f010092b:	84 c0                	test   %al,%al
f010092d:	74 0d                	je     f010093c <printstr+0x1f>
f010092f:	43                   	inc    %ebx
f0100930:	83 fb 65             	cmp    $0x65,%ebx
f0100933:	74 07                	je     f010093c <printstr+0x1f>
f0100935:	e8 5e fd ff ff       	call   f0100698 <cons_putc>
f010093a:	eb e8                	jmp    f0100924 <printstr+0x7>
f010093c:	58                   	pop    %eax
f010093d:	5b                   	pop    %ebx
f010093e:	5d                   	pop    %ebp
f010093f:	c3                   	ret    

f0100940 <kbd_proc_data>:
f0100940:	55                   	push   %ebp
f0100941:	ba 64 00 00 00       	mov    $0x64,%edx
f0100946:	89 e5                	mov    %esp,%ebp
f0100948:	53                   	push   %ebx
f0100949:	50                   	push   %eax
f010094a:	ec                   	in     (%dx),%al
f010094b:	83 cb ff             	or     $0xffffffff,%ebx
f010094e:	a8 01                	test   $0x1,%al
f0100950:	0f 84 c9 00 00 00    	je     f0100a1f <kbd_proc_data+0xdf>
f0100956:	b2 60                	mov    $0x60,%dl
f0100958:	ec                   	in     (%dx),%al
f0100959:	3c e0                	cmp    $0xe0,%al
f010095b:	88 c1                	mov    %al,%cl
f010095d:	75 09                	jne    f0100968 <kbd_proc_data+0x28>
f010095f:	83 0d 80 f9 11 f0 40 	orl    $0x40,0xf011f980
f0100966:	eb 2d                	jmp    f0100995 <kbd_proc_data+0x55>
f0100968:	84 c0                	test   %al,%al
f010096a:	8b 1d 80 f9 11 f0    	mov    0xf011f980,%ebx
f0100970:	79 2a                	jns    f010099c <kbd_proc_data+0x5c>
f0100972:	88 c1                	mov    %al,%cl
f0100974:	83 e1 7f             	and    $0x7f,%ecx
f0100977:	f6 c3 40             	test   $0x40,%bl
f010097a:	0f 45 c8             	cmovne %eax,%ecx
f010097d:	0f b6 c9             	movzbl %cl,%ecx
f0100980:	8a 81 80 2c 10 f0    	mov    -0xfefd380(%ecx),%al
f0100986:	83 c8 40             	or     $0x40,%eax
f0100989:	0f b6 c0             	movzbl %al,%eax
f010098c:	f7 d0                	not    %eax
f010098e:	21 d8                	and    %ebx,%eax
f0100990:	a3 80 f9 11 f0       	mov    %eax,0xf011f980
f0100995:	31 db                	xor    %ebx,%ebx
f0100997:	e9 83 00 00 00       	jmp    f0100a1f <kbd_proc_data+0xdf>
f010099c:	f6 c3 40             	test   $0x40,%bl
f010099f:	74 0d                	je     f01009ae <kbd_proc_data+0x6e>
f01009a1:	89 d8                	mov    %ebx,%eax
f01009a3:	83 c9 80             	or     $0xffffff80,%ecx
f01009a6:	83 e0 bf             	and    $0xffffffbf,%eax
f01009a9:	a3 80 f9 11 f0       	mov    %eax,0xf011f980
f01009ae:	0f b6 c9             	movzbl %cl,%ecx
f01009b1:	0f b6 81 80 2c 10 f0 	movzbl -0xfefd380(%ecx),%eax
f01009b8:	0f b6 91 80 2b 10 f0 	movzbl -0xfefd480(%ecx),%edx
f01009bf:	0b 05 80 f9 11 f0    	or     0xf011f980,%eax
f01009c5:	31 d0                	xor    %edx,%eax
f01009c7:	89 c2                	mov    %eax,%edx
f01009c9:	a3 80 f9 11 f0       	mov    %eax,0xf011f980
f01009ce:	83 e2 03             	and    $0x3,%edx
f01009d1:	a8 08                	test   $0x8,%al
f01009d3:	8b 14 95 40 2b 10 f0 	mov    -0xfefd4c0(,%edx,4),%edx
f01009da:	0f b6 1c 0a          	movzbl (%edx,%ecx,1),%ebx
f01009de:	74 19                	je     f01009f9 <kbd_proc_data+0xb9>
f01009e0:	8d 53 9f             	lea    -0x61(%ebx),%edx
f01009e3:	83 fa 19             	cmp    $0x19,%edx
f01009e6:	77 05                	ja     f01009ed <kbd_proc_data+0xad>
f01009e8:	83 eb 20             	sub    $0x20,%ebx
f01009eb:	eb 0c                	jmp    f01009f9 <kbd_proc_data+0xb9>
f01009ed:	8d 4b bf             	lea    -0x41(%ebx),%ecx
f01009f0:	8d 53 20             	lea    0x20(%ebx),%edx
f01009f3:	83 f9 19             	cmp    $0x19,%ecx
f01009f6:	0f 46 da             	cmovbe %edx,%ebx
f01009f9:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01009ff:	75 1e                	jne    f0100a1f <kbd_proc_data+0xdf>
f0100a01:	f7 d0                	not    %eax
f0100a03:	a8 06                	test   $0x6,%al
f0100a05:	75 18                	jne    f0100a1f <kbd_proc_data+0xdf>
f0100a07:	83 ec 0c             	sub    $0xc,%esp
f0100a0a:	68 ff 2a 10 f0       	push   $0xf0102aff
f0100a0f:	e8 09 ff ff ff       	call   f010091d <printstr>
f0100a14:	ba 92 00 00 00       	mov    $0x92,%edx
f0100a19:	b0 03                	mov    $0x3,%al
f0100a1b:	ee                   	out    %al,(%dx)
f0100a1c:	83 c4 10             	add    $0x10,%esp
f0100a1f:	89 d8                	mov    %ebx,%eax
f0100a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100a24:	c9                   	leave  
f0100a25:	c3                   	ret    

f0100a26 <kbd_intr>:
f0100a26:	55                   	push   %ebp
f0100a27:	b8 40 09 10 f0       	mov    $0xf0100940,%eax
f0100a2c:	89 e5                	mov    %esp,%ebp
f0100a2e:	5d                   	pop    %ebp
f0100a2f:	e9 25 fc ff ff       	jmp    f0100659 <cons_intr>

f0100a34 <cons_getc>:
f0100a34:	55                   	push   %ebp
f0100a35:	89 e5                	mov    %esp,%ebp
f0100a37:	83 ec 08             	sub    $0x8,%esp
f0100a3a:	e8 fd fd ff ff       	call   f010083c <serial_intr>
f0100a3f:	e8 e2 ff ff ff       	call   f0100a26 <kbd_intr>
f0100a44:	8b 15 c0 fb 11 f0    	mov    0xf011fbc0,%edx
f0100a4a:	31 c0                	xor    %eax,%eax
f0100a4c:	3b 15 c4 fb 11 f0    	cmp    0xf011fbc4,%edx
f0100a52:	74 22                	je     f0100a76 <cons_getc+0x42>
f0100a54:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100a57:	0f b6 82 c0 f9 11 f0 	movzbl -0xfee0640(%edx),%eax
f0100a5e:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100a64:	89 0d c0 fb 11 f0    	mov    %ecx,0xf011fbc0
f0100a6a:	75 0a                	jne    f0100a76 <cons_getc+0x42>
f0100a6c:	c7 05 c0 fb 11 f0 00 	movl   $0x0,0xf011fbc0
f0100a73:	00 00 00 
f0100a76:	c9                   	leave  
f0100a77:	c3                   	ret    

f0100a78 <cputchar>:
f0100a78:	55                   	push   %ebp
f0100a79:	89 e5                	mov    %esp,%ebp
f0100a7b:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a7e:	5d                   	pop    %ebp
f0100a7f:	e9 14 fc ff ff       	jmp    f0100698 <cons_putc>

f0100a84 <getchar>:
f0100a84:	55                   	push   %ebp
f0100a85:	89 e5                	mov    %esp,%ebp
f0100a87:	83 ec 08             	sub    $0x8,%esp
f0100a8a:	e8 a5 ff ff ff       	call   f0100a34 <cons_getc>
f0100a8f:	85 c0                	test   %eax,%eax
f0100a91:	74 f7                	je     f0100a8a <getchar+0x6>
f0100a93:	c9                   	leave  
f0100a94:	c3                   	ret    

f0100a95 <iscons>:
f0100a95:	55                   	push   %ebp
f0100a96:	b8 01 00 00 00       	mov    $0x1,%eax
f0100a9b:	89 e5                	mov    %esp,%ebp
f0100a9d:	5d                   	pop    %ebp
f0100a9e:	c3                   	ret    

f0100a9f <mon_help>:
f0100a9f:	55                   	push   %ebp
f0100aa0:	89 e5                	mov    %esp,%ebp
f0100aa2:	83 ec 0c             	sub    $0xc,%esp
f0100aa5:	68 80 2d 10 f0       	push   $0xf0102d80
f0100aaa:	68 9e 2d 10 f0       	push   $0xf0102d9e
f0100aaf:	68 a3 2d 10 f0       	push   $0xf0102da3
f0100ab4:	e8 ad 19 00 00       	call   f0102466 <cprintf>
f0100ab9:	83 c4 0c             	add    $0xc,%esp
f0100abc:	68 ac 2d 10 f0       	push   $0xf0102dac
f0100ac1:	68 d1 2d 10 f0       	push   $0xf0102dd1
f0100ac6:	68 a3 2d 10 f0       	push   $0xf0102da3
f0100acb:	e8 96 19 00 00       	call   f0102466 <cprintf>
f0100ad0:	31 c0                	xor    %eax,%eax
f0100ad2:	c9                   	leave  
f0100ad3:	c3                   	ret    

f0100ad4 <mon_kerninfo>:
f0100ad4:	55                   	push   %ebp
f0100ad5:	89 e5                	mov    %esp,%ebp
f0100ad7:	83 ec 14             	sub    $0x14,%esp
f0100ada:	68 da 2d 10 f0       	push   $0xf0102dda
f0100adf:	e8 82 19 00 00       	call   f0102466 <cprintf>
f0100ae4:	58                   	pop    %eax
f0100ae5:	5a                   	pop    %edx
f0100ae6:	68 0c 00 10 00       	push   $0x10000c
f0100aeb:	68 f3 2d 10 f0       	push   $0xf0102df3
f0100af0:	e8 71 19 00 00       	call   f0102466 <cprintf>
f0100af5:	83 c4 0c             	add    $0xc,%esp
f0100af8:	68 0c 00 10 00       	push   $0x10000c
f0100afd:	68 0c 00 10 f0       	push   $0xf010000c
f0100b02:	68 1a 2e 10 f0       	push   $0xf0102e1a
f0100b07:	e8 5a 19 00 00       	call   f0102466 <cprintf>
f0100b0c:	83 c4 0c             	add    $0xc,%esp
f0100b0f:	68 5a 2a 10 00       	push   $0x102a5a
f0100b14:	68 5a 2a 10 f0       	push   $0xf0102a5a
f0100b19:	68 3d 2e 10 f0       	push   $0xf0102e3d
f0100b1e:	e8 43 19 00 00       	call   f0102466 <cprintf>
f0100b23:	83 c4 0c             	add    $0xc,%esp
f0100b26:	68 28 f9 11 00       	push   $0x11f928
f0100b2b:	68 28 f9 11 f0       	push   $0xf011f928
f0100b30:	68 60 2e 10 f0       	push   $0xf0102e60
f0100b35:	e8 2c 19 00 00       	call   f0102466 <cprintf>
f0100b3a:	83 c4 0c             	add    $0xc,%esp
f0100b3d:	68 d0 08 12 00       	push   $0x1208d0
f0100b42:	68 d0 08 12 f0       	push   $0xf01208d0
f0100b47:	68 83 2e 10 f0       	push   $0xf0102e83
f0100b4c:	e8 15 19 00 00       	call   f0102466 <cprintf>
f0100b51:	b8 cf 0c 12 f0       	mov    $0xf0120ccf,%eax
f0100b56:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100b5b:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0100b60:	59                   	pop    %ecx
f0100b61:	b9 00 04 00 00       	mov    $0x400,%ecx
f0100b66:	5a                   	pop    %edx
f0100b67:	99                   	cltd   
f0100b68:	f7 f9                	idiv   %ecx
f0100b6a:	50                   	push   %eax
f0100b6b:	68 a6 2e 10 f0       	push   $0xf0102ea6
f0100b70:	e8 f1 18 00 00       	call   f0102466 <cprintf>
f0100b75:	31 c0                	xor    %eax,%eax
f0100b77:	c9                   	leave  
f0100b78:	c3                   	ret    

f0100b79 <monitor>:
f0100b79:	55                   	push   %ebp
f0100b7a:	89 e5                	mov    %esp,%ebp
f0100b7c:	57                   	push   %edi
f0100b7d:	56                   	push   %esi
f0100b7e:	53                   	push   %ebx
f0100b7f:	8d 75 a8             	lea    -0x58(%ebp),%esi
f0100b82:	83 ec 68             	sub    $0x68,%esp
f0100b85:	68 d0 2e 10 f0       	push   $0xf0102ed0
f0100b8a:	e8 d7 18 00 00       	call   f0102466 <cprintf>
f0100b8f:	c7 04 24 f7 2e 10 f0 	movl   $0xf0102ef7,(%esp)
f0100b96:	e8 cb 18 00 00       	call   f0102466 <cprintf>
f0100b9b:	83 c4 10             	add    $0x10,%esp
f0100b9e:	83 ec 0c             	sub    $0xc,%esp
f0100ba1:	68 1c 2f 10 f0       	push   $0xf0102f1c
f0100ba6:	e8 54 19 00 00       	call   f01024ff <readline>
f0100bab:	83 c4 10             	add    $0x10,%esp
f0100bae:	85 c0                	test   %eax,%eax
f0100bb0:	89 c3                	mov    %eax,%ebx
f0100bb2:	74 ea                	je     f0100b9e <monitor+0x25>
f0100bb4:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100bbb:	31 ff                	xor    %edi,%edi
f0100bbd:	0f be 03             	movsbl (%ebx),%eax
f0100bc0:	84 c0                	test   %al,%al
f0100bc2:	75 07                	jne    f0100bcb <monitor+0x52>
f0100bc4:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100bc7:	75 20                	jne    f0100be9 <monitor+0x70>
f0100bc9:	eb 5c                	jmp    f0100c27 <monitor+0xae>
f0100bcb:	52                   	push   %edx
f0100bcc:	52                   	push   %edx
f0100bcd:	50                   	push   %eax
f0100bce:	68 20 2f 10 f0       	push   $0xf0102f20
f0100bd3:	e8 de 1b 00 00       	call   f01027b6 <strchr>
f0100bd8:	83 c4 10             	add    $0x10,%esp
f0100bdb:	85 c0                	test   %eax,%eax
f0100bdd:	74 e5                	je     f0100bc4 <monitor+0x4b>
f0100bdf:	c6 03 00             	movb   $0x0,(%ebx)
f0100be2:	89 fa                	mov    %edi,%edx
f0100be4:	43                   	inc    %ebx
f0100be5:	89 d7                	mov    %edx,%edi
f0100be7:	eb d4                	jmp    f0100bbd <monitor+0x44>
f0100be9:	83 ff 0f             	cmp    $0xf,%edi
f0100bec:	75 0e                	jne    f0100bfc <monitor+0x83>
f0100bee:	51                   	push   %ecx
f0100bef:	51                   	push   %ecx
f0100bf0:	6a 10                	push   $0x10
f0100bf2:	68 25 2f 10 f0       	push   $0xf0102f25
f0100bf7:	e9 9a 00 00 00       	jmp    f0100c96 <monitor+0x11d>
f0100bfc:	8d 57 01             	lea    0x1(%edi),%edx
f0100bff:	89 5c bd a8          	mov    %ebx,-0x58(%ebp,%edi,4)
f0100c03:	0f be 03             	movsbl (%ebx),%eax
f0100c06:	84 c0                	test   %al,%al
f0100c08:	74 db                	je     f0100be5 <monitor+0x6c>
f0100c0a:	89 55 a4             	mov    %edx,-0x5c(%ebp)
f0100c0d:	52                   	push   %edx
f0100c0e:	52                   	push   %edx
f0100c0f:	50                   	push   %eax
f0100c10:	68 20 2f 10 f0       	push   $0xf0102f20
f0100c15:	e8 9c 1b 00 00       	call   f01027b6 <strchr>
f0100c1a:	83 c4 10             	add    $0x10,%esp
f0100c1d:	85 c0                	test   %eax,%eax
f0100c1f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
f0100c22:	75 c1                	jne    f0100be5 <monitor+0x6c>
f0100c24:	43                   	inc    %ebx
f0100c25:	eb dc                	jmp    f0100c03 <monitor+0x8a>
f0100c27:	85 ff                	test   %edi,%edi
f0100c29:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
f0100c30:	00 
f0100c31:	0f 84 67 ff ff ff    	je     f0100b9e <monitor+0x25>
f0100c37:	50                   	push   %eax
f0100c38:	50                   	push   %eax
f0100c39:	68 9e 2d 10 f0       	push   $0xf0102d9e
f0100c3e:	ff 75 a8             	pushl  -0x58(%ebp)
f0100c41:	e8 ec 1a 00 00       	call   f0102732 <strcmp>
f0100c46:	83 c4 10             	add    $0x10,%esp
f0100c49:	31 d2                	xor    %edx,%edx
f0100c4b:	85 c0                	test   %eax,%eax
f0100c4d:	74 1b                	je     f0100c6a <monitor+0xf1>
f0100c4f:	53                   	push   %ebx
f0100c50:	53                   	push   %ebx
f0100c51:	68 d1 2d 10 f0       	push   $0xf0102dd1
f0100c56:	ff 75 a8             	pushl  -0x58(%ebp)
f0100c59:	e8 d4 1a 00 00       	call   f0102732 <strcmp>
f0100c5e:	83 c4 10             	add    $0x10,%esp
f0100c61:	85 c0                	test   %eax,%eax
f0100c63:	75 27                	jne    f0100c8c <monitor+0x113>
f0100c65:	ba 01 00 00 00       	mov    $0x1,%edx
f0100c6a:	6b d2 0c             	imul   $0xc,%edx,%edx
f0100c6d:	51                   	push   %ecx
f0100c6e:	ff 75 08             	pushl  0x8(%ebp)
f0100c71:	56                   	push   %esi
f0100c72:	57                   	push   %edi
f0100c73:	ff 92 60 2f 10 f0    	call   *-0xfefd0a0(%edx)
f0100c79:	83 c4 10             	add    $0x10,%esp
f0100c7c:	85 c0                	test   %eax,%eax
f0100c7e:	0f 89 1a ff ff ff    	jns    f0100b9e <monitor+0x25>
f0100c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c87:	5b                   	pop    %ebx
f0100c88:	5e                   	pop    %esi
f0100c89:	5f                   	pop    %edi
f0100c8a:	5d                   	pop    %ebp
f0100c8b:	c3                   	ret    
f0100c8c:	50                   	push   %eax
f0100c8d:	50                   	push   %eax
f0100c8e:	ff 75 a8             	pushl  -0x58(%ebp)
f0100c91:	68 42 2f 10 f0       	push   $0xf0102f42
f0100c96:	e8 cb 17 00 00       	call   f0102466 <cprintf>
f0100c9b:	83 c4 10             	add    $0x10,%esp
f0100c9e:	e9 fb fe ff ff       	jmp    f0100b9e <monitor+0x25>
f0100ca3:	90                   	nop

f0100ca4 <trap_handle0>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(trap_handle0, 0)
f0100ca4:	6a 00                	push   $0x0
f0100ca6:	6a 00                	push   $0x0
f0100ca8:	eb 64                	jmp    f0100d0e <_alltraps>

f0100caa <trap_handle1>:
TRAPHANDLER_NOEC(trap_handle1, 1)
f0100caa:	6a 00                	push   $0x0
f0100cac:	6a 01                	push   $0x1
f0100cae:	eb 5e                	jmp    f0100d0e <_alltraps>

f0100cb0 <trap_handle2>:
TRAPHANDLER_NOEC(trap_handle2, 2)
f0100cb0:	6a 00                	push   $0x0
f0100cb2:	6a 02                	push   $0x2
f0100cb4:	eb 58                	jmp    f0100d0e <_alltraps>

f0100cb6 <trap_handle3>:
TRAPHANDLER_NOEC(trap_handle3, 3)
f0100cb6:	6a 00                	push   $0x0
f0100cb8:	6a 03                	push   $0x3
f0100cba:	eb 52                	jmp    f0100d0e <_alltraps>

f0100cbc <trap_handle4>:
TRAPHANDLER_NOEC(trap_handle4, 4)
f0100cbc:	6a 00                	push   $0x0
f0100cbe:	6a 04                	push   $0x4
f0100cc0:	eb 4c                	jmp    f0100d0e <_alltraps>

f0100cc2 <trap_handle5>:
TRAPHANDLER_NOEC(trap_handle5, 5)
f0100cc2:	6a 00                	push   $0x0
f0100cc4:	6a 05                	push   $0x5
f0100cc6:	eb 46                	jmp    f0100d0e <_alltraps>

f0100cc8 <trap_handle6>:
TRAPHANDLER_NOEC(trap_handle6, 6)
f0100cc8:	6a 00                	push   $0x0
f0100cca:	6a 06                	push   $0x6
f0100ccc:	eb 40                	jmp    f0100d0e <_alltraps>

f0100cce <trap_handle7>:
TRAPHANDLER_NOEC(trap_handle7, 7)
f0100cce:	6a 00                	push   $0x0
f0100cd0:	6a 07                	push   $0x7
f0100cd2:	eb 3a                	jmp    f0100d0e <_alltraps>

f0100cd4 <trap_handle8>:
TRAPHANDLER(trap_handle8, 8)
f0100cd4:	6a 08                	push   $0x8
f0100cd6:	eb 36                	jmp    f0100d0e <_alltraps>

f0100cd8 <trap_handle10>:
TRAPHANDLER(trap_handle10, 10)
f0100cd8:	6a 0a                	push   $0xa
f0100cda:	eb 32                	jmp    f0100d0e <_alltraps>

f0100cdc <trap_handle11>:
TRAPHANDLER(trap_handle11, 11)
f0100cdc:	6a 0b                	push   $0xb
f0100cde:	eb 2e                	jmp    f0100d0e <_alltraps>

f0100ce0 <trap_handle12>:
TRAPHANDLER(trap_handle12, 12)
f0100ce0:	6a 0c                	push   $0xc
f0100ce2:	eb 2a                	jmp    f0100d0e <_alltraps>

f0100ce4 <trap_handle13>:
TRAPHANDLER(trap_handle13, 13)
f0100ce4:	6a 0d                	push   $0xd
f0100ce6:	eb 26                	jmp    f0100d0e <_alltraps>

f0100ce8 <trap_handle14>:
TRAPHANDLER(trap_handle14, 14)
f0100ce8:	6a 0e                	push   $0xe
f0100cea:	eb 22                	jmp    f0100d0e <_alltraps>

f0100cec <trap_handle16>:
TRAPHANDLER_NOEC(trap_handle16, 16)
f0100cec:	6a 00                	push   $0x0
f0100cee:	6a 10                	push   $0x10
f0100cf0:	eb 1c                	jmp    f0100d0e <_alltraps>

f0100cf2 <trap_handle17>:
TRAPHANDLER(trap_handle17, 17)
f0100cf2:	6a 11                	push   $0x11
f0100cf4:	eb 18                	jmp    f0100d0e <_alltraps>

f0100cf6 <trap_handle18>:
TRAPHANDLER_NOEC(trap_handle18, 18)
f0100cf6:	6a 00                	push   $0x0
f0100cf8:	6a 12                	push   $0x12
f0100cfa:	eb 12                	jmp    f0100d0e <_alltraps>

f0100cfc <trap_handle19>:
TRAPHANDLER_NOEC(trap_handle19, 19)
f0100cfc:	6a 00                	push   $0x0
f0100cfe:	6a 13                	push   $0x13
f0100d00:	eb 0c                	jmp    f0100d0e <_alltraps>

f0100d02 <trap_handle_syscall>:

TRAPHANDLER_NOEC(trap_handle_syscall, T_SYSCALL)
f0100d02:	6a 00                	push   $0x0
f0100d04:	6a 30                	push   $0x30
f0100d06:	eb 06                	jmp    f0100d0e <_alltraps>

f0100d08 <trap_handle_timer>:

TRAPHANDLER_NOEC(trap_handle_timer, IRQ_OFFSET + IRQ_TIMER)
f0100d08:	6a 00                	push   $0x0
f0100d0a:	6a 20                	push   $0x20
f0100d0c:	eb 00                	jmp    f0100d0e <_alltraps>

f0100d0e <_alltraps>:



_alltraps:
	pushl %ds
f0100d0e:	1e                   	push   %ds
	pushl %es
f0100d0f:	06                   	push   %es
	pushal
f0100d10:	60                   	pusha  

	movw $(GD_KD), %ax
f0100d11:	66 b8 10 00          	mov    $0x10,%ax
	movw %ax, %ds
f0100d15:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f0100d17:	8e c0                	mov    %eax,%es

	pushl %esp
f0100d19:	54                   	push   %esp
	call trap
f0100d1a:	e8 ac 0a 00 00       	call   f01017cb <trap>

f0100d1f <trap_init_percpu>:
f0100d1f:	b8 40 04 12 f0       	mov    $0xf0120440,%eax
f0100d24:	55                   	push   %ebp
f0100d25:	c7 05 44 04 12 f0 00 	movl   $0xf0000000,0xf0120444
f0100d2c:	00 00 f0 
f0100d2f:	89 c2                	mov    %eax,%edx
f0100d31:	66 a3 7a e3 10 f0    	mov    %ax,0xf010e37a
f0100d37:	c1 e8 18             	shr    $0x18,%eax
f0100d3a:	c1 ea 10             	shr    $0x10,%edx
f0100d3d:	a2 7f e3 10 f0       	mov    %al,0xf010e37f
f0100d42:	89 e5                	mov    %esp,%ebp
f0100d44:	66 c7 05 48 04 12 f0 	movw   $0x10,0xf0120448
f0100d4b:	10 00 
f0100d4d:	66 c7 05 78 e3 10 f0 	movw   $0x68,0xf010e378
f0100d54:	68 00 
f0100d56:	b8 28 00 00 00       	mov    $0x28,%eax
f0100d5b:	88 15 7c e3 10 f0    	mov    %dl,0xf010e37c
f0100d61:	c6 05 7e e3 10 f0 40 	movb   $0x40,0xf010e37e
f0100d68:	c6 05 7d e3 10 f0 89 	movb   $0x89,0xf010e37d
f0100d6f:	0f 00 d8             	ltr    %ax
f0100d72:	b8 40 e3 10 f0       	mov    $0xf010e340,%eax
f0100d77:	0f 01 18             	lidtl  (%eax)
f0100d7a:	5d                   	pop    %ebp
f0100d7b:	c3                   	ret    

f0100d7c <trap_init>:
f0100d7c:	b8 a4 0c 10 f0       	mov    $0xf0100ca4,%eax
f0100d81:	55                   	push   %ebp
f0100d82:	66 c7 05 02 fc 11 f0 	movw   $0x8,0xf011fc02
f0100d89:	08 00 
f0100d8b:	66 a3 00 fc 11 f0    	mov    %ax,0xf011fc00
f0100d91:	c1 e8 10             	shr    $0x10,%eax
f0100d94:	c6 05 04 fc 11 f0 00 	movb   $0x0,0xf011fc04
f0100d9b:	66 a3 06 fc 11 f0    	mov    %ax,0xf011fc06
f0100da1:	b8 aa 0c 10 f0       	mov    $0xf0100caa,%eax
f0100da6:	c6 05 05 fc 11 f0 8e 	movb   $0x8e,0xf011fc05
f0100dad:	66 a3 08 fc 11 f0    	mov    %ax,0xf011fc08
f0100db3:	c1 e8 10             	shr    $0x10,%eax
f0100db6:	66 c7 05 0a fc 11 f0 	movw   $0x8,0xf011fc0a
f0100dbd:	08 00 
f0100dbf:	66 a3 0e fc 11 f0    	mov    %ax,0xf011fc0e
f0100dc5:	b8 b0 0c 10 f0       	mov    $0xf0100cb0,%eax
f0100dca:	c6 05 0c fc 11 f0 00 	movb   $0x0,0xf011fc0c
f0100dd1:	66 a3 10 fc 11 f0    	mov    %ax,0xf011fc10
f0100dd7:	c1 e8 10             	shr    $0x10,%eax
f0100dda:	c6 05 0d fc 11 f0 8e 	movb   $0x8e,0xf011fc0d
f0100de1:	66 a3 16 fc 11 f0    	mov    %ax,0xf011fc16
f0100de7:	b8 b6 0c 10 f0       	mov    $0xf0100cb6,%eax
f0100dec:	66 c7 05 12 fc 11 f0 	movw   $0x8,0xf011fc12
f0100df3:	08 00 
f0100df5:	66 a3 18 fc 11 f0    	mov    %ax,0xf011fc18
f0100dfb:	c1 e8 10             	shr    $0x10,%eax
f0100dfe:	c6 05 14 fc 11 f0 00 	movb   $0x0,0xf011fc14
f0100e05:	66 a3 1e fc 11 f0    	mov    %ax,0xf011fc1e
f0100e0b:	b8 bc 0c 10 f0       	mov    $0xf0100cbc,%eax
f0100e10:	c6 05 15 fc 11 f0 8e 	movb   $0x8e,0xf011fc15
f0100e17:	66 a3 20 fc 11 f0    	mov    %ax,0xf011fc20
f0100e1d:	c1 e8 10             	shr    $0x10,%eax
f0100e20:	66 c7 05 1a fc 11 f0 	movw   $0x8,0xf011fc1a
f0100e27:	08 00 
f0100e29:	66 a3 26 fc 11 f0    	mov    %ax,0xf011fc26
f0100e2f:	b8 c2 0c 10 f0       	mov    $0xf0100cc2,%eax
f0100e34:	c6 05 1c fc 11 f0 00 	movb   $0x0,0xf011fc1c
f0100e3b:	66 a3 28 fc 11 f0    	mov    %ax,0xf011fc28
f0100e41:	c1 e8 10             	shr    $0x10,%eax
f0100e44:	c6 05 1d fc 11 f0 ee 	movb   $0xee,0xf011fc1d
f0100e4b:	66 a3 2e fc 11 f0    	mov    %ax,0xf011fc2e
f0100e51:	b8 c8 0c 10 f0       	mov    $0xf0100cc8,%eax
f0100e56:	66 c7 05 22 fc 11 f0 	movw   $0x8,0xf011fc22
f0100e5d:	08 00 
f0100e5f:	66 a3 30 fc 11 f0    	mov    %ax,0xf011fc30
f0100e65:	c1 e8 10             	shr    $0x10,%eax
f0100e68:	c6 05 24 fc 11 f0 00 	movb   $0x0,0xf011fc24
f0100e6f:	c6 05 25 fc 11 f0 8e 	movb   $0x8e,0xf011fc25
f0100e76:	66 c7 05 2a fc 11 f0 	movw   $0x8,0xf011fc2a
f0100e7d:	08 00 
f0100e7f:	89 e5                	mov    %esp,%ebp
f0100e81:	c6 05 2c fc 11 f0 00 	movb   $0x0,0xf011fc2c
f0100e88:	c6 05 2d fc 11 f0 8e 	movb   $0x8e,0xf011fc2d
f0100e8f:	66 c7 05 32 fc 11 f0 	movw   $0x8,0xf011fc32
f0100e96:	08 00 
f0100e98:	c6 05 34 fc 11 f0 00 	movb   $0x0,0xf011fc34
f0100e9f:	66 a3 36 fc 11 f0    	mov    %ax,0xf011fc36
f0100ea5:	b8 ce 0c 10 f0       	mov    $0xf0100cce,%eax
f0100eaa:	c6 05 35 fc 11 f0 8e 	movb   $0x8e,0xf011fc35
f0100eb1:	66 a3 38 fc 11 f0    	mov    %ax,0xf011fc38
f0100eb7:	c1 e8 10             	shr    $0x10,%eax
f0100eba:	66 c7 05 3a fc 11 f0 	movw   $0x8,0xf011fc3a
f0100ec1:	08 00 
f0100ec3:	66 a3 3e fc 11 f0    	mov    %ax,0xf011fc3e
f0100ec9:	b8 d4 0c 10 f0       	mov    $0xf0100cd4,%eax
f0100ece:	c6 05 3c fc 11 f0 00 	movb   $0x0,0xf011fc3c
f0100ed5:	66 a3 40 fc 11 f0    	mov    %ax,0xf011fc40
f0100edb:	c1 e8 10             	shr    $0x10,%eax
f0100ede:	c6 05 3d fc 11 f0 8e 	movb   $0x8e,0xf011fc3d
f0100ee5:	66 a3 46 fc 11 f0    	mov    %ax,0xf011fc46
f0100eeb:	b8 d8 0c 10 f0       	mov    $0xf0100cd8,%eax
f0100ef0:	66 c7 05 42 fc 11 f0 	movw   $0x8,0xf011fc42
f0100ef7:	08 00 
f0100ef9:	66 a3 50 fc 11 f0    	mov    %ax,0xf011fc50
f0100eff:	c1 e8 10             	shr    $0x10,%eax
f0100f02:	c6 05 44 fc 11 f0 00 	movb   $0x0,0xf011fc44
f0100f09:	66 a3 56 fc 11 f0    	mov    %ax,0xf011fc56
f0100f0f:	b8 dc 0c 10 f0       	mov    $0xf0100cdc,%eax
f0100f14:	c6 05 45 fc 11 f0 8e 	movb   $0x8e,0xf011fc45
f0100f1b:	66 a3 58 fc 11 f0    	mov    %ax,0xf011fc58
f0100f21:	c1 e8 10             	shr    $0x10,%eax
f0100f24:	66 c7 05 52 fc 11 f0 	movw   $0x8,0xf011fc52
f0100f2b:	08 00 
f0100f2d:	66 a3 5e fc 11 f0    	mov    %ax,0xf011fc5e
f0100f33:	b8 e0 0c 10 f0       	mov    $0xf0100ce0,%eax
f0100f38:	c6 05 54 fc 11 f0 00 	movb   $0x0,0xf011fc54
f0100f3f:	66 a3 60 fc 11 f0    	mov    %ax,0xf011fc60
f0100f45:	c1 e8 10             	shr    $0x10,%eax
f0100f48:	c6 05 55 fc 11 f0 8e 	movb   $0x8e,0xf011fc55
f0100f4f:	66 a3 66 fc 11 f0    	mov    %ax,0xf011fc66
f0100f55:	b8 e4 0c 10 f0       	mov    $0xf0100ce4,%eax
f0100f5a:	66 c7 05 5a fc 11 f0 	movw   $0x8,0xf011fc5a
f0100f61:	08 00 
f0100f63:	66 a3 68 fc 11 f0    	mov    %ax,0xf011fc68
f0100f69:	c1 e8 10             	shr    $0x10,%eax
f0100f6c:	c6 05 5c fc 11 f0 00 	movb   $0x0,0xf011fc5c
f0100f73:	66 a3 6e fc 11 f0    	mov    %ax,0xf011fc6e
f0100f79:	b8 e8 0c 10 f0       	mov    $0xf0100ce8,%eax
f0100f7e:	c6 05 5d fc 11 f0 8e 	movb   $0x8e,0xf011fc5d
f0100f85:	66 a3 70 fc 11 f0    	mov    %ax,0xf011fc70
f0100f8b:	c1 e8 10             	shr    $0x10,%eax
f0100f8e:	66 c7 05 62 fc 11 f0 	movw   $0x8,0xf011fc62
f0100f95:	08 00 
f0100f97:	c6 05 64 fc 11 f0 00 	movb   $0x0,0xf011fc64
f0100f9e:	c6 05 65 fc 11 f0 8e 	movb   $0x8e,0xf011fc65
f0100fa5:	66 c7 05 6a fc 11 f0 	movw   $0x8,0xf011fc6a
f0100fac:	08 00 
f0100fae:	c6 05 6c fc 11 f0 00 	movb   $0x0,0xf011fc6c
f0100fb5:	c6 05 6d fc 11 f0 8e 	movb   $0x8e,0xf011fc6d
f0100fbc:	66 c7 05 72 fc 11 f0 	movw   $0x8,0xf011fc72
f0100fc3:	08 00 
f0100fc5:	66 a3 76 fc 11 f0    	mov    %ax,0xf011fc76
f0100fcb:	b8 ec 0c 10 f0       	mov    $0xf0100cec,%eax
f0100fd0:	c6 05 74 fc 11 f0 00 	movb   $0x0,0xf011fc74
f0100fd7:	66 a3 80 fc 11 f0    	mov    %ax,0xf011fc80
f0100fdd:	c1 e8 10             	shr    $0x10,%eax
f0100fe0:	c6 05 75 fc 11 f0 8e 	movb   $0x8e,0xf011fc75
f0100fe7:	66 a3 86 fc 11 f0    	mov    %ax,0xf011fc86
f0100fed:	b8 f2 0c 10 f0       	mov    $0xf0100cf2,%eax
f0100ff2:	66 c7 05 82 fc 11 f0 	movw   $0x8,0xf011fc82
f0100ff9:	08 00 
f0100ffb:	66 a3 88 fc 11 f0    	mov    %ax,0xf011fc88
f0101001:	c1 e8 10             	shr    $0x10,%eax
f0101004:	c6 05 84 fc 11 f0 00 	movb   $0x0,0xf011fc84
f010100b:	66 a3 8e fc 11 f0    	mov    %ax,0xf011fc8e
f0101011:	b8 f6 0c 10 f0       	mov    $0xf0100cf6,%eax
f0101016:	c6 05 85 fc 11 f0 8e 	movb   $0x8e,0xf011fc85
f010101d:	66 a3 90 fc 11 f0    	mov    %ax,0xf011fc90
f0101023:	c1 e8 10             	shr    $0x10,%eax
f0101026:	66 c7 05 8a fc 11 f0 	movw   $0x8,0xf011fc8a
f010102d:	08 00 
f010102f:	66 a3 96 fc 11 f0    	mov    %ax,0xf011fc96
f0101035:	b8 fc 0c 10 f0       	mov    $0xf0100cfc,%eax
f010103a:	c6 05 8c fc 11 f0 00 	movb   $0x0,0xf011fc8c
f0101041:	66 a3 98 fc 11 f0    	mov    %ax,0xf011fc98
f0101047:	c1 e8 10             	shr    $0x10,%eax
f010104a:	c6 05 8d fc 11 f0 8e 	movb   $0x8e,0xf011fc8d
f0101051:	66 a3 9e fc 11 f0    	mov    %ax,0xf011fc9e
f0101057:	b8 02 0d 10 f0       	mov    $0xf0100d02,%eax
f010105c:	66 c7 05 92 fc 11 f0 	movw   $0x8,0xf011fc92
f0101063:	08 00 
f0101065:	66 a3 80 fd 11 f0    	mov    %ax,0xf011fd80
f010106b:	c1 e8 10             	shr    $0x10,%eax
f010106e:	c6 05 94 fc 11 f0 00 	movb   $0x0,0xf011fc94
f0101075:	66 a3 86 fd 11 f0    	mov    %ax,0xf011fd86
f010107b:	b8 08 0d 10 f0       	mov    $0xf0100d08,%eax
f0101080:	c6 05 95 fc 11 f0 8e 	movb   $0x8e,0xf011fc95
f0101087:	66 a3 00 fd 11 f0    	mov    %ax,0xf011fd00
f010108d:	c1 e8 10             	shr    $0x10,%eax
f0101090:	66 c7 05 9a fc 11 f0 	movw   $0x8,0xf011fc9a
f0101097:	08 00 
f0101099:	c6 05 9c fc 11 f0 00 	movb   $0x0,0xf011fc9c
f01010a0:	c6 05 9d fc 11 f0 8e 	movb   $0x8e,0xf011fc9d
f01010a7:	66 c7 05 82 fd 11 f0 	movw   $0x8,0xf011fd82
f01010ae:	08 00 
f01010b0:	c6 05 84 fd 11 f0 00 	movb   $0x0,0xf011fd84
f01010b7:	c6 05 85 fd 11 f0 ef 	movb   $0xef,0xf011fd85
f01010be:	66 c7 05 02 fd 11 f0 	movw   $0x8,0xf011fd02
f01010c5:	08 00 
f01010c7:	c6 05 04 fd 11 f0 00 	movb   $0x0,0xf011fd04
f01010ce:	c6 05 05 fd 11 f0 8e 	movb   $0x8e,0xf011fd05
f01010d5:	66 a3 06 fd 11 f0    	mov    %ax,0xf011fd06
f01010db:	5d                   	pop    %ebp
f01010dc:	e9 3e fc ff ff       	jmp    f0100d1f <trap_init_percpu>

f01010e1 <print_regs>:
f01010e1:	55                   	push   %ebp
f01010e2:	89 e5                	mov    %esp,%ebp
f01010e4:	53                   	push   %ebx
f01010e5:	83 ec 0c             	sub    $0xc,%esp
f01010e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01010eb:	ff 33                	pushl  (%ebx)
f01010ed:	68 70 2f 10 f0       	push   $0xf0102f70
f01010f2:	e8 6f 13 00 00       	call   f0102466 <cprintf>
f01010f7:	58                   	pop    %eax
f01010f8:	5a                   	pop    %edx
f01010f9:	ff 73 04             	pushl  0x4(%ebx)
f01010fc:	68 7f 2f 10 f0       	push   $0xf0102f7f
f0101101:	e8 60 13 00 00       	call   f0102466 <cprintf>
f0101106:	59                   	pop    %ecx
f0101107:	58                   	pop    %eax
f0101108:	ff 73 08             	pushl  0x8(%ebx)
f010110b:	68 8e 2f 10 f0       	push   $0xf0102f8e
f0101110:	e8 51 13 00 00       	call   f0102466 <cprintf>
f0101115:	58                   	pop    %eax
f0101116:	5a                   	pop    %edx
f0101117:	ff 73 0c             	pushl  0xc(%ebx)
f010111a:	68 9d 2f 10 f0       	push   $0xf0102f9d
f010111f:	e8 42 13 00 00       	call   f0102466 <cprintf>
f0101124:	59                   	pop    %ecx
f0101125:	58                   	pop    %eax
f0101126:	ff 73 10             	pushl  0x10(%ebx)
f0101129:	68 ac 2f 10 f0       	push   $0xf0102fac
f010112e:	e8 33 13 00 00       	call   f0102466 <cprintf>
f0101133:	58                   	pop    %eax
f0101134:	5a                   	pop    %edx
f0101135:	ff 73 14             	pushl  0x14(%ebx)
f0101138:	68 bb 2f 10 f0       	push   $0xf0102fbb
f010113d:	e8 24 13 00 00       	call   f0102466 <cprintf>
f0101142:	59                   	pop    %ecx
f0101143:	58                   	pop    %eax
f0101144:	ff 73 18             	pushl  0x18(%ebx)
f0101147:	68 ca 2f 10 f0       	push   $0xf0102fca
f010114c:	e8 15 13 00 00       	call   f0102466 <cprintf>
f0101151:	58                   	pop    %eax
f0101152:	5a                   	pop    %edx
f0101153:	ff 73 1c             	pushl  0x1c(%ebx)
f0101156:	68 d9 2f 10 f0       	push   $0xf0102fd9
f010115b:	e8 06 13 00 00       	call   f0102466 <cprintf>
f0101160:	83 c4 10             	add    $0x10,%esp
f0101163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101166:	c9                   	leave  
f0101167:	c3                   	ret    

f0101168 <print_trapframe>:
f0101168:	55                   	push   %ebp
f0101169:	89 e5                	mov    %esp,%ebp
f010116b:	56                   	push   %esi
f010116c:	53                   	push   %ebx
f010116d:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101170:	56                   	push   %esi
f0101171:	56                   	push   %esi
f0101172:	53                   	push   %ebx
f0101173:	68 3d 30 10 f0       	push   $0xf010303d
f0101178:	e8 e9 12 00 00       	call   f0102466 <cprintf>
f010117d:	89 1c 24             	mov    %ebx,(%esp)
f0101180:	e8 5c ff ff ff       	call   f01010e1 <print_regs>
f0101185:	58                   	pop    %eax
f0101186:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f010118a:	5a                   	pop    %edx
f010118b:	50                   	push   %eax
f010118c:	68 4f 30 10 f0       	push   $0xf010304f
f0101191:	e8 d0 12 00 00       	call   f0102466 <cprintf>
f0101196:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f010119a:	59                   	pop    %ecx
f010119b:	5e                   	pop    %esi
f010119c:	50                   	push   %eax
f010119d:	68 62 30 10 f0       	push   $0xf0103062
f01011a2:	e8 bf 12 00 00       	call   f0102466 <cprintf>
f01011a7:	8b 43 28             	mov    0x28(%ebx),%eax
f01011aa:	83 c4 10             	add    $0x10,%esp
f01011ad:	83 f8 13             	cmp    $0x13,%eax
f01011b0:	77 09                	ja     f01011bb <print_trapframe+0x53>
f01011b2:	8b 14 85 40 33 10 f0 	mov    -0xfefccc0(,%eax,4),%edx
f01011b9:	eb 1d                	jmp    f01011d8 <print_trapframe+0x70>
f01011bb:	83 f8 30             	cmp    $0x30,%eax
f01011be:	ba e8 2f 10 f0       	mov    $0xf0102fe8,%edx
f01011c3:	74 13                	je     f01011d8 <print_trapframe+0x70>
f01011c5:	8d 50 e0             	lea    -0x20(%eax),%edx
f01011c8:	b9 07 30 10 f0       	mov    $0xf0103007,%ecx
f01011cd:	83 fa 10             	cmp    $0x10,%edx
f01011d0:	ba f4 2f 10 f0       	mov    $0xf0102ff4,%edx
f01011d5:	0f 43 d1             	cmovae %ecx,%edx
f01011d8:	51                   	push   %ecx
f01011d9:	52                   	push   %edx
f01011da:	50                   	push   %eax
f01011db:	68 75 30 10 f0       	push   $0xf0103075
f01011e0:	e8 81 12 00 00       	call   f0102466 <cprintf>
f01011e5:	83 c4 10             	add    $0x10,%esp
f01011e8:	3b 1d 00 04 12 f0    	cmp    0xf0120400,%ebx
f01011ee:	75 19                	jne    f0101209 <print_trapframe+0xa1>
f01011f0:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01011f4:	75 13                	jne    f0101209 <print_trapframe+0xa1>
f01011f6:	0f 20 d0             	mov    %cr2,%eax
f01011f9:	52                   	push   %edx
f01011fa:	52                   	push   %edx
f01011fb:	50                   	push   %eax
f01011fc:	68 87 30 10 f0       	push   $0xf0103087
f0101201:	e8 60 12 00 00       	call   f0102466 <cprintf>
f0101206:	83 c4 10             	add    $0x10,%esp
f0101209:	50                   	push   %eax
f010120a:	50                   	push   %eax
f010120b:	ff 73 2c             	pushl  0x2c(%ebx)
f010120e:	68 96 30 10 f0       	push   $0xf0103096
f0101213:	e8 4e 12 00 00       	call   f0102466 <cprintf>
f0101218:	83 c4 10             	add    $0x10,%esp
f010121b:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010121f:	75 3a                	jne    f010125b <print_trapframe+0xf3>
f0101221:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0101224:	ba 21 30 10 f0       	mov    $0xf0103021,%edx
f0101229:	b9 16 30 10 f0       	mov    $0xf0103016,%ecx
f010122e:	be 2d 30 10 f0       	mov    $0xf010302d,%esi
f0101233:	a8 01                	test   $0x1,%al
f0101235:	0f 44 ca             	cmove  %edx,%ecx
f0101238:	a8 02                	test   $0x2,%al
f010123a:	ba 33 30 10 f0       	mov    $0xf0103033,%edx
f010123f:	0f 45 d6             	cmovne %esi,%edx
f0101242:	a8 04                	test   $0x4,%al
f0101244:	be ca 2d 10 f0       	mov    $0xf0102dca,%esi
f0101249:	b8 38 30 10 f0       	mov    $0xf0103038,%eax
f010124e:	51                   	push   %ecx
f010124f:	52                   	push   %edx
f0101250:	0f 44 c6             	cmove  %esi,%eax
f0101253:	50                   	push   %eax
f0101254:	68 a4 30 10 f0       	push   $0xf01030a4
f0101259:	eb 08                	jmp    f0101263 <print_trapframe+0xfb>
f010125b:	83 ec 0c             	sub    $0xc,%esp
f010125e:	68 09 2b 10 f0       	push   $0xf0102b09
f0101263:	e8 fe 11 00 00       	call   f0102466 <cprintf>
f0101268:	83 c4 10             	add    $0x10,%esp
f010126b:	56                   	push   %esi
f010126c:	56                   	push   %esi
f010126d:	ff 73 30             	pushl  0x30(%ebx)
f0101270:	68 b3 30 10 f0       	push   $0xf01030b3
f0101275:	e8 ec 11 00 00       	call   f0102466 <cprintf>
f010127a:	58                   	pop    %eax
f010127b:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010127f:	5a                   	pop    %edx
f0101280:	50                   	push   %eax
f0101281:	68 c2 30 10 f0       	push   $0xf01030c2
f0101286:	e8 db 11 00 00       	call   f0102466 <cprintf>
f010128b:	59                   	pop    %ecx
f010128c:	5e                   	pop    %esi
f010128d:	ff 73 38             	pushl  0x38(%ebx)
f0101290:	68 d5 30 10 f0       	push   $0xf01030d5
f0101295:	e8 cc 11 00 00       	call   f0102466 <cprintf>
f010129a:	83 c4 10             	add    $0x10,%esp
f010129d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01012a1:	74 23                	je     f01012c6 <print_trapframe+0x15e>
f01012a3:	50                   	push   %eax
f01012a4:	50                   	push   %eax
f01012a5:	ff 73 3c             	pushl  0x3c(%ebx)
f01012a8:	68 e4 30 10 f0       	push   $0xf01030e4
f01012ad:	e8 b4 11 00 00       	call   f0102466 <cprintf>
f01012b2:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f01012b6:	5a                   	pop    %edx
f01012b7:	59                   	pop    %ecx
f01012b8:	50                   	push   %eax
f01012b9:	68 f3 30 10 f0       	push   $0xf01030f3
f01012be:	e8 a3 11 00 00       	call   f0102466 <cprintf>
f01012c3:	83 c4 10             	add    $0x10,%esp
f01012c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01012c9:	5b                   	pop    %ebx
f01012ca:	5e                   	pop    %esi
f01012cb:	5d                   	pop    %ebp
f01012cc:	c3                   	ret    

f01012cd <page_fault_handler>:
f01012cd:	55                   	push   %ebp
f01012ce:	89 e5                	mov    %esp,%ebp
f01012d0:	57                   	push   %edi
f01012d1:	56                   	push   %esi
f01012d2:	53                   	push   %ebx
f01012d3:	83 ec 0c             	sub    $0xc,%esp
f01012d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01012d9:	0f 20 d2             	mov    %cr2,%edx
f01012dc:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01012e0:	75 15                	jne    f01012f7 <page_fault_handler+0x2a>
f01012e2:	50                   	push   %eax
f01012e3:	68 06 31 10 f0       	push   $0xf0103106
f01012e8:	68 38 01 00 00       	push   $0x138
f01012ed:	68 1e 31 10 f0       	push   $0xf010311e
f01012f2:	e8 da 12 00 00       	call   f01025d1 <_panic>
f01012f7:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01012fc:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0101300:	74 58                	je     f010135a <page_fault_handler+0x8d>
f0101302:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0101305:	89 de                	mov    %ebx,%esi
f0101307:	8d 88 00 10 40 11    	lea    0x11401000(%eax),%ecx
f010130d:	83 e8 38             	sub    $0x38,%eax
f0101310:	81 f9 ff 0f 00 00    	cmp    $0xfff,%ecx
f0101316:	b9 cc ff bf ee       	mov    $0xeebfffcc,%ecx
f010131b:	0f 47 c1             	cmova  %ecx,%eax
f010131e:	b9 08 00 00 00       	mov    $0x8,%ecx
f0101323:	83 ec 0c             	sub    $0xc,%esp
f0101326:	89 10                	mov    %edx,(%eax)
f0101328:	8b 53 2c             	mov    0x2c(%ebx),%edx
f010132b:	8d 78 08             	lea    0x8(%eax),%edi
f010132e:	89 50 04             	mov    %edx,0x4(%eax)
f0101331:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0101333:	8b 53 30             	mov    0x30(%ebx),%edx
f0101336:	89 50 28             	mov    %edx,0x28(%eax)
f0101339:	8b 53 38             	mov    0x38(%ebx),%edx
f010133c:	89 50 2c             	mov    %edx,0x2c(%eax)
f010133f:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0101342:	89 50 30             	mov    %edx,0x30(%eax)
f0101345:	8b 15 ac 04 12 f0    	mov    0xf01204ac,%edx
f010134b:	8b 4a 64             	mov    0x64(%edx),%ecx
f010134e:	89 42 3c             	mov    %eax,0x3c(%edx)
f0101351:	89 4a 30             	mov    %ecx,0x30(%edx)
f0101354:	52                   	push   %edx
f0101355:	e8 04 0c 00 00       	call   f0101f5e <env_run>
f010135a:	ff 73 30             	pushl  0x30(%ebx)
f010135d:	52                   	push   %edx
f010135e:	ff 70 48             	pushl  0x48(%eax)
f0101361:	68 25 31 10 f0       	push   $0xf0103125
f0101366:	e8 fb 10 00 00       	call   f0102466 <cprintf>
f010136b:	89 1c 24             	mov    %ebx,(%esp)
f010136e:	e8 f5 fd ff ff       	call   f0101168 <print_trapframe>
f0101373:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f0101378:	83 c4 10             	add    $0x10,%esp
f010137b:	89 45 08             	mov    %eax,0x8(%ebp)
f010137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101381:	5b                   	pop    %ebx
f0101382:	5e                   	pop    %esi
f0101383:	5f                   	pop    %edi
f0101384:	5d                   	pop    %ebp
f0101385:	e9 69 0b 00 00       	jmp    f0101ef3 <env_destroy>

f010138a <syscall>:
f010138a:	55                   	push   %ebp
f010138b:	89 e5                	mov    %esp,%ebp
f010138d:	57                   	push   %edi
f010138e:	56                   	push   %esi
f010138f:	53                   	push   %ebx
f0101390:	83 ec 1c             	sub    $0x1c,%esp
f0101393:	8b 55 08             	mov    0x8(%ebp),%edx
f0101396:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101399:	8b 75 10             	mov    0x10(%ebp),%esi
f010139c:	8b 7d 18             	mov    0x18(%ebp),%edi
f010139f:	83 fa 0d             	cmp    $0xd,%edx
f01013a2:	0f 87 14 04 00 00    	ja     f01017bc <syscall+0x432>
f01013a8:	ff 24 95 00 33 10 f0 	jmp    *-0xfefcd00(,%edx,4)
f01013af:	57                   	push   %edi
f01013b0:	50                   	push   %eax
f01013b1:	56                   	push   %esi
f01013b2:	68 48 31 10 f0       	push   $0xf0103148
f01013b7:	e8 aa 10 00 00       	call   f0102466 <cprintf>
f01013bc:	eb 3c                	jmp    f01013fa <syscall+0x70>
f01013be:	e8 71 f6 ff ff       	call   f0100a34 <cons_getc>
f01013c3:	e9 6b 03 00 00       	jmp    f0101733 <syscall+0x3a9>
f01013c8:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01013cd:	8b 58 48             	mov    0x48(%eax),%ebx
f01013d0:	e9 ec 03 00 00       	jmp    f01017c1 <syscall+0x437>
f01013d5:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01013d8:	53                   	push   %ebx
f01013d9:	6a 01                	push   $0x1
f01013db:	52                   	push   %edx
f01013dc:	50                   	push   %eax
f01013dd:	e8 43 07 00 00       	call   f0101b25 <envid2env>
f01013e2:	83 c4 10             	add    $0x10,%esp
f01013e5:	85 c0                	test   %eax,%eax
f01013e7:	89 c3                	mov    %eax,%ebx
f01013e9:	0f 88 d2 03 00 00    	js     f01017c1 <syscall+0x437>
f01013ef:	83 ec 0c             	sub    $0xc,%esp
f01013f2:	ff 75 e4             	pushl  -0x1c(%ebp)
f01013f5:	e8 f9 0a 00 00       	call   f0101ef3 <env_destroy>
f01013fa:	83 c4 10             	add    $0x10,%esp
f01013fd:	e9 b6 03 00 00       	jmp    f01017b8 <syscall+0x42e>
f0101402:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f0101407:	51                   	push   %ecx
f0101408:	51                   	push   %ecx
f0101409:	ff 70 48             	pushl  0x48(%eax)
f010140c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010140f:	50                   	push   %eax
f0101410:	e8 d6 07 00 00       	call   f0101beb <env_alloc>
f0101415:	83 c4 10             	add    $0x10,%esp
f0101418:	85 c0                	test   %eax,%eax
f010141a:	89 c3                	mov    %eax,%ebx
f010141c:	0f 88 9f 03 00 00    	js     f01017c1 <syscall+0x437>
f0101422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101425:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
f010142c:	52                   	push   %edx
f010142d:	6a 44                	push   $0x44
f010142f:	ff 35 ac 04 12 f0    	pushl  0xf01204ac
f0101435:	50                   	push   %eax
f0101436:	e8 8e 14 00 00       	call   f01028c9 <memcpy>
f010143b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010143e:	83 c4 10             	add    $0x10,%esp
f0101441:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
f0101448:	8b 58 48             	mov    0x48(%eax),%ebx
f010144b:	e9 71 03 00 00       	jmp    f01017c1 <syscall+0x437>
f0101450:	8d 4e fe             	lea    -0x2(%esi),%ecx
f0101453:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0101458:	83 e1 fd             	and    $0xfffffffd,%ecx
f010145b:	0f 85 60 03 00 00    	jne    f01017c1 <syscall+0x437>
f0101461:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0101464:	57                   	push   %edi
f0101465:	6a 01                	push   $0x1
f0101467:	b3 fe                	mov    $0xfe,%bl
f0101469:	52                   	push   %edx
f010146a:	50                   	push   %eax
f010146b:	e8 b5 06 00 00       	call   f0101b25 <envid2env>
f0101470:	83 c4 10             	add    $0x10,%esp
f0101473:	85 c0                	test   %eax,%eax
f0101475:	0f 88 46 03 00 00    	js     f01017c1 <syscall+0x437>
f010147b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010147e:	89 70 54             	mov    %esi,0x54(%eax)
f0101481:	e9 32 03 00 00       	jmp    f01017b8 <syscall+0x42e>
f0101486:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0101489:	51                   	push   %ecx
f010148a:	6a 01                	push   $0x1
f010148c:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0101491:	52                   	push   %edx
f0101492:	50                   	push   %eax
f0101493:	e8 8d 06 00 00       	call   f0101b25 <envid2env>
f0101498:	83 c4 10             	add    $0x10,%esp
f010149b:	85 c0                	test   %eax,%eax
f010149d:	0f 88 1e 03 00 00    	js     f01017c1 <syscall+0x437>
f01014a3:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f01014a9:	b3 fd                	mov    $0xfd,%bl
f01014ab:	0f 87 10 03 00 00    	ja     f01017c1 <syscall+0x437>
f01014b1:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f01014b7:	0f 85 04 03 00 00    	jne    f01017c1 <syscall+0x437>
f01014bd:	8b 45 14             	mov    0x14(%ebp),%eax
f01014c0:	83 e0 05             	and    $0x5,%eax
f01014c3:	83 f8 05             	cmp    $0x5,%eax
f01014c6:	0f 85 f5 02 00 00    	jne    f01017c1 <syscall+0x437>
f01014cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01014cf:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f01014d5:	0f 85 e1 02 00 00    	jne    f01017bc <syscall+0x432>
f01014db:	83 ec 0c             	sub    $0xc,%esp
f01014de:	6a 01                	push   $0x1
f01014e0:	e8 7a ec ff ff       	call   f010015f <page_alloc>
f01014e5:	83 c4 10             	add    $0x10,%esp
f01014e8:	85 c0                	test   %eax,%eax
f01014ea:	89 c7                	mov    %eax,%edi
f01014ec:	75 16                	jne    f0101504 <syscall+0x17a>
f01014ee:	83 ec 0c             	sub    $0xc,%esp
f01014f1:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01014f6:	57                   	push   %edi
f01014f7:	e8 b1 ec ff ff       	call   f01001ad <page_free>
f01014fc:	83 c4 10             	add    $0x10,%esp
f01014ff:	e9 bd 02 00 00       	jmp    f01017c1 <syscall+0x437>
f0101504:	ff 75 14             	pushl  0x14(%ebp)
f0101507:	56                   	push   %esi
f0101508:	50                   	push   %eax
f0101509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010150c:	ff 70 60             	pushl  0x60(%eax)
f010150f:	e8 f8 ef ff ff       	call   f010050c <page_insert>
f0101514:	83 c4 10             	add    $0x10,%esp
f0101517:	85 c0                	test   %eax,%eax
f0101519:	0f 89 a2 02 00 00    	jns    f01017c1 <syscall+0x437>
f010151f:	eb cd                	jmp    f01014ee <syscall+0x164>
f0101521:	52                   	push   %edx
f0101522:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101525:	6a 01                	push   $0x1
f0101527:	52                   	push   %edx
f0101528:	50                   	push   %eax
f0101529:	e8 f7 05 00 00       	call   f0101b25 <envid2env>
f010152e:	83 c4 10             	add    $0x10,%esp
f0101531:	85 c0                	test   %eax,%eax
f0101533:	79 0a                	jns    f010153f <syscall+0x1b5>
f0101535:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010153a:	e9 82 02 00 00       	jmp    f01017c1 <syscall+0x437>
f010153f:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0101542:	53                   	push   %ebx
f0101543:	6a 01                	push   $0x1
f0101545:	50                   	push   %eax
f0101546:	ff 75 14             	pushl  0x14(%ebp)
f0101549:	e8 d7 05 00 00       	call   f0101b25 <envid2env>
f010154e:	83 c4 10             	add    $0x10,%esp
f0101551:	85 c0                	test   %eax,%eax
f0101553:	78 e0                	js     f0101535 <syscall+0x1ab>
f0101555:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f010155b:	0f 87 5b 02 00 00    	ja     f01017bc <syscall+0x432>
f0101561:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f0101567:	0f 87 4f 02 00 00    	ja     f01017bc <syscall+0x432>
f010156d:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f0101573:	0f 85 43 02 00 00    	jne    f01017bc <syscall+0x432>
f0101579:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f010157f:	0f 85 37 02 00 00    	jne    f01017bc <syscall+0x432>
f0101585:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0101588:	83 e0 05             	and    $0x5,%eax
f010158b:	83 f8 05             	cmp    $0x5,%eax
f010158e:	0f 85 28 02 00 00    	jne    f01017bc <syscall+0x432>
f0101594:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
f0101597:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f010159d:	0f 85 19 02 00 00    	jne    f01017bc <syscall+0x432>
f01015a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01015a6:	51                   	push   %ecx
f01015a7:	50                   	push   %eax
f01015a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01015ab:	56                   	push   %esi
f01015ac:	ff 70 60             	pushl  0x60(%eax)
f01015af:	e8 ae ee ff ff       	call   f0100462 <page_lookup>
f01015b4:	83 c4 10             	add    $0x10,%esp
f01015b7:	85 c0                	test   %eax,%eax
f01015b9:	0f 84 fd 01 00 00    	je     f01017bc <syscall+0x432>
f01015bf:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f01015c3:	74 0a                	je     f01015cf <syscall+0x245>
f01015c5:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
f01015c9:	0f 85 ed 01 00 00    	jne    f01017bc <syscall+0x432>
f01015cf:	ff 75 1c             	pushl  0x1c(%ebp)
f01015d2:	57                   	push   %edi
f01015d3:	50                   	push   %eax
f01015d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01015d7:	ff 70 60             	pushl  0x60(%eax)
f01015da:	e8 2d ef ff ff       	call   f010050c <page_insert>
f01015df:	83 c4 10             	add    $0x10,%esp
f01015e2:	85 c0                	test   %eax,%eax
f01015e4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01015e9:	0f 48 d8             	cmovs  %eax,%ebx
f01015ec:	e9 d0 01 00 00       	jmp    f01017c1 <syscall+0x437>
f01015f1:	52                   	push   %edx
f01015f2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01015f5:	6a 01                	push   $0x1
f01015f7:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01015fc:	52                   	push   %edx
f01015fd:	50                   	push   %eax
f01015fe:	e8 22 05 00 00       	call   f0101b25 <envid2env>
f0101603:	83 c4 10             	add    $0x10,%esp
f0101606:	85 c0                	test   %eax,%eax
f0101608:	0f 88 b3 01 00 00    	js     f01017c1 <syscall+0x437>
f010160e:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0101614:	b3 fd                	mov    $0xfd,%bl
f0101616:	0f 87 a5 01 00 00    	ja     f01017c1 <syscall+0x437>
f010161c:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f0101622:	0f 85 99 01 00 00    	jne    f01017c1 <syscall+0x437>
f0101628:	50                   	push   %eax
f0101629:	50                   	push   %eax
f010162a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010162d:	56                   	push   %esi
f010162e:	ff 70 60             	pushl  0x60(%eax)
f0101631:	e8 83 ee ff ff       	call   f01004b9 <page_remove>
f0101636:	e9 bf fd ff ff       	jmp    f01013fa <syscall+0x70>
f010163b:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010163e:	57                   	push   %edi
f010163f:	6a 01                	push   $0x1
f0101641:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0101646:	52                   	push   %edx
f0101647:	50                   	push   %eax
f0101648:	e8 d8 04 00 00       	call   f0101b25 <envid2env>
f010164d:	83 c4 10             	add    $0x10,%esp
f0101650:	85 c0                	test   %eax,%eax
f0101652:	0f 88 69 01 00 00    	js     f01017c1 <syscall+0x437>
f0101658:	85 f6                	test   %esi,%esi
f010165a:	b3 fd                	mov    $0xfd,%bl
f010165c:	0f 84 5f 01 00 00    	je     f01017c1 <syscall+0x437>
f0101662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101665:	89 70 64             	mov    %esi,0x64(%eax)
f0101668:	e9 4b 01 00 00       	jmp    f01017b8 <syscall+0x42e>
f010166d:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0101670:	53                   	push   %ebx
f0101671:	6a 00                	push   $0x0
f0101673:	52                   	push   %edx
f0101674:	50                   	push   %eax
f0101675:	e8 ab 04 00 00       	call   f0101b25 <envid2env>
f010167a:	83 c4 10             	add    $0x10,%esp
f010167d:	85 c0                	test   %eax,%eax
f010167f:	89 c3                	mov    %eax,%ebx
f0101681:	0f 88 3a 01 00 00    	js     f01017c1 <syscall+0x437>
f0101687:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010168a:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f010168f:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0101693:	0f 84 28 01 00 00    	je     f01017c1 <syscall+0x437>
f0101699:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01016a0:	c6 40 68 00          	movb   $0x0,0x68(%eax)
f01016a4:	0f 87 93 00 00 00    	ja     f010173d <syscall+0x3b3>
f01016aa:	8b 45 14             	mov    0x14(%ebp),%eax
f01016ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01016b2:	39 45 14             	cmp    %eax,0x14(%ebp)
f01016b5:	0f 85 01 01 00 00    	jne    f01017bc <syscall+0x432>
f01016bb:	89 f8                	mov    %edi,%eax
f01016bd:	83 e0 05             	and    $0x5,%eax
f01016c0:	83 f8 05             	cmp    $0x5,%eax
f01016c3:	0f 85 f3 00 00 00    	jne    f01017bc <syscall+0x432>
f01016c9:	f7 c7 f8 f1 ff ff    	test   $0xfffff1f8,%edi
f01016cf:	0f 85 e7 00 00 00    	jne    f01017bc <syscall+0x432>
f01016d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01016d8:	51                   	push   %ecx
f01016d9:	50                   	push   %eax
f01016da:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01016df:	ff 75 14             	pushl  0x14(%ebp)
f01016e2:	ff 70 60             	pushl  0x60(%eax)
f01016e5:	e8 78 ed ff ff       	call   f0100462 <page_lookup>
f01016ea:	83 c4 10             	add    $0x10,%esp
f01016ed:	85 c0                	test   %eax,%eax
f01016ef:	0f 84 c7 00 00 00    	je     f01017bc <syscall+0x432>
f01016f5:	f7 c7 02 00 00 00    	test   $0x2,%edi
f01016fb:	74 0c                	je     f0101709 <syscall+0x37f>
f01016fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101700:	f6 02 02             	testb  $0x2,(%edx)
f0101703:	0f 84 b3 00 00 00    	je     f01017bc <syscall+0x432>
f0101709:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010170c:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f010170f:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0101715:	77 26                	ja     f010173d <syscall+0x3b3>
f0101717:	57                   	push   %edi
f0101718:	51                   	push   %ecx
f0101719:	50                   	push   %eax
f010171a:	ff 72 60             	pushl  0x60(%edx)
f010171d:	e8 ea ed ff ff       	call   f010050c <page_insert>
f0101722:	83 c4 10             	add    $0x10,%esp
f0101725:	85 c0                	test   %eax,%eax
f0101727:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010172a:	79 0e                	jns    f010173a <syscall+0x3b0>
f010172c:	c7 41 78 00 00 00 00 	movl   $0x0,0x78(%ecx)
f0101733:	89 c3                	mov    %eax,%ebx
f0101735:	e9 87 00 00 00       	jmp    f01017c1 <syscall+0x437>
f010173a:	89 79 78             	mov    %edi,0x78(%ecx)
f010173d:	8b 15 ac 04 12 f0    	mov    0xf01204ac,%edx
f0101743:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101746:	8b 52 48             	mov    0x48(%edx),%edx
f0101749:	89 70 70             	mov    %esi,0x70(%eax)
f010174c:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0101753:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
f010175a:	89 50 74             	mov    %edx,0x74(%eax)
f010175d:	eb 59                	jmp    f01017b8 <syscall+0x42e>
f010175f:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
f0101764:	77 0c                	ja     f0101772 <syscall+0x3e8>
f0101766:	a9 ff 0f 00 00       	test   $0xfff,%eax
f010176b:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0101770:	75 4f                	jne    f01017c1 <syscall+0x437>
f0101772:	8b 15 ac 04 12 f0    	mov    0xf01204ac,%edx
f0101778:	c6 42 68 01          	movb   $0x1,0x68(%edx)
f010177c:	89 42 6c             	mov    %eax,0x6c(%edx)
f010177f:	c7 42 54 04 00 00 00 	movl   $0x4,0x54(%edx)
f0101786:	e8 e5 01 00 00       	call   f0101970 <sched_yield>
f010178b:	52                   	push   %edx
f010178c:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f010178f:	6a 01                	push   $0x1
f0101791:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0101796:	52                   	push   %edx
f0101797:	50                   	push   %eax
f0101798:	e8 88 03 00 00       	call   f0101b25 <envid2env>
f010179d:	83 c4 10             	add    $0x10,%esp
f01017a0:	85 c0                	test   %eax,%eax
f01017a2:	78 1d                	js     f01017c1 <syscall+0x437>
f01017a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01017a7:	b9 11 00 00 00       	mov    $0x11,%ecx
f01017ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01017ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01017b1:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
f01017b8:	31 db                	xor    %ebx,%ebx
f01017ba:	eb 05                	jmp    f01017c1 <syscall+0x437>
f01017bc:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01017c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01017c4:	89 d8                	mov    %ebx,%eax
f01017c6:	5b                   	pop    %ebx
f01017c7:	5e                   	pop    %esi
f01017c8:	5f                   	pop    %edi
f01017c9:	5d                   	pop    %ebp
f01017ca:	c3                   	ret    

f01017cb <trap>:
f01017cb:	55                   	push   %ebp
f01017cc:	89 e5                	mov    %esp,%ebp
f01017ce:	57                   	push   %edi
f01017cf:	56                   	push   %esi
f01017d0:	8b 75 08             	mov    0x8(%ebp),%esi
f01017d3:	fc                   	cld    
f01017d4:	66 8b 46 34          	mov    0x34(%esi),%ax
f01017d8:	83 e0 03             	and    $0x3,%eax
f01017db:	66 83 f8 03          	cmp    $0x3,%ax
f01017df:	75 42                	jne    f0101823 <trap+0x58>
f01017e1:	83 ec 0c             	sub    $0xc,%esp
f01017e4:	68 cc 08 12 f0       	push   $0xf01208cc
f01017e9:	e8 d2 07 00 00       	call   f0101fc0 <spin_lock>
f01017ee:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01017f3:	83 c4 10             	add    $0x10,%esp
f01017f6:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01017fa:	75 18                	jne    f0101814 <trap+0x49>
f01017fc:	83 ec 0c             	sub    $0xc,%esp
f01017ff:	50                   	push   %eax
f0101800:	e8 e3 05 00 00       	call   f0101de8 <env_free>
f0101805:	c7 05 ac 04 12 f0 00 	movl   $0x0,0xf01204ac
f010180c:	00 00 00 
f010180f:	e8 5c 01 00 00       	call   f0101970 <sched_yield>
f0101814:	b9 11 00 00 00       	mov    $0x11,%ecx
f0101819:	89 c7                	mov    %eax,%edi
f010181b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010181d:	8b 35 ac 04 12 f0    	mov    0xf01204ac,%esi
f0101823:	8b 46 28             	mov    0x28(%esi),%eax
f0101826:	89 35 00 04 12 f0    	mov    %esi,0xf0120400
f010182c:	83 f8 0e             	cmp    $0xe,%eax
f010182f:	75 0e                	jne    f010183f <trap+0x74>
f0101831:	83 ec 0c             	sub    $0xc,%esp
f0101834:	56                   	push   %esi
f0101835:	e8 93 fa ff ff       	call   f01012cd <page_fault_handler>
f010183a:	e9 ac 00 00 00       	jmp    f01018eb <trap+0x120>
f010183f:	83 f8 03             	cmp    $0x3,%eax
f0101842:	75 0e                	jne    f0101852 <trap+0x87>
f0101844:	83 ec 0c             	sub    $0xc,%esp
f0101847:	56                   	push   %esi
f0101848:	e8 2c f3 ff ff       	call   f0100b79 <monitor>
f010184d:	e9 99 00 00 00       	jmp    f01018eb <trap+0x120>
f0101852:	83 f8 30             	cmp    $0x30,%eax
f0101855:	75 20                	jne    f0101877 <trap+0xac>
f0101857:	52                   	push   %edx
f0101858:	52                   	push   %edx
f0101859:	ff 76 04             	pushl  0x4(%esi)
f010185c:	ff 36                	pushl  (%esi)
f010185e:	ff 76 10             	pushl  0x10(%esi)
f0101861:	ff 76 18             	pushl  0x18(%esi)
f0101864:	ff 76 14             	pushl  0x14(%esi)
f0101867:	ff 76 1c             	pushl  0x1c(%esi)
f010186a:	e8 1b fb ff ff       	call   f010138a <syscall>
f010186f:	83 c4 20             	add    $0x20,%esp
f0101872:	89 46 1c             	mov    %eax,0x1c(%esi)
f0101875:	eb 77                	jmp    f01018ee <trap+0x123>
f0101877:	83 f8 27             	cmp    $0x27,%eax
f010187a:	75 17                	jne    f0101893 <trap+0xc8>
f010187c:	83 ec 0c             	sub    $0xc,%esp
f010187f:	68 4d 31 10 f0       	push   $0xf010314d
f0101884:	e8 dd 0b 00 00       	call   f0102466 <cprintf>
f0101889:	89 34 24             	mov    %esi,(%esp)
f010188c:	e8 d7 f8 ff ff       	call   f0101168 <print_trapframe>
f0101891:	eb 58                	jmp    f01018eb <trap+0x120>
f0101893:	83 f8 20             	cmp    $0x20,%eax
f0101896:	75 05                	jne    f010189d <trap+0xd2>
f0101898:	e8 d3 00 00 00       	call   f0101970 <sched_yield>
f010189d:	83 f8 21             	cmp    $0x21,%eax
f01018a0:	75 07                	jne    f01018a9 <trap+0xde>
f01018a2:	e8 7f f1 ff ff       	call   f0100a26 <kbd_intr>
f01018a7:	eb 45                	jmp    f01018ee <trap+0x123>
f01018a9:	83 f8 24             	cmp    $0x24,%eax
f01018ac:	75 07                	jne    f01018b5 <trap+0xea>
f01018ae:	e8 89 ef ff ff       	call   f010083c <serial_intr>
f01018b3:	eb 39                	jmp    f01018ee <trap+0x123>
f01018b5:	83 ec 0c             	sub    $0xc,%esp
f01018b8:	56                   	push   %esi
f01018b9:	e8 aa f8 ff ff       	call   f0101168 <print_trapframe>
f01018be:	83 c4 10             	add    $0x10,%esp
f01018c1:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f01018c6:	75 15                	jne    f01018dd <trap+0x112>
f01018c8:	50                   	push   %eax
f01018c9:	68 6a 31 10 f0       	push   $0xf010316a
f01018ce:	68 f6 00 00 00       	push   $0xf6
f01018d3:	68 1e 31 10 f0       	push   $0xf010311e
f01018d8:	e8 f4 0c 00 00       	call   f01025d1 <_panic>
f01018dd:	83 ec 0c             	sub    $0xc,%esp
f01018e0:	ff 35 ac 04 12 f0    	pushl  0xf01204ac
f01018e6:	e8 08 06 00 00       	call   f0101ef3 <env_destroy>
f01018eb:	83 c4 10             	add    $0x10,%esp
f01018ee:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f01018f3:	85 c0                	test   %eax,%eax
f01018f5:	74 a1                	je     f0101898 <trap+0xcd>
f01018f7:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01018fb:	75 9b                	jne    f0101898 <trap+0xcd>
f01018fd:	83 ec 0c             	sub    $0xc,%esp
f0101900:	50                   	push   %eax
f0101901:	e8 58 06 00 00       	call   f0101f5e <env_run>

f0101906 <sched_halt>:
f0101906:	8b 0d b0 04 12 f0    	mov    0xf01204b0,%ecx
f010190c:	31 c0                	xor    %eax,%eax
f010190e:	8b 54 01 54          	mov    0x54(%ecx,%eax,1),%edx
f0101912:	4a                   	dec    %edx
f0101913:	83 fa 02             	cmp    $0x2,%edx
f0101916:	76 2c                	jbe    f0101944 <sched_halt+0x3e>
f0101918:	83 c0 7c             	add    $0x7c,%eax
f010191b:	3d 00 f0 01 00       	cmp    $0x1f000,%eax
f0101920:	75 ec                	jne    f010190e <sched_halt+0x8>
f0101922:	55                   	push   %ebp
f0101923:	89 e5                	mov    %esp,%ebp
f0101925:	83 ec 08             	sub    $0x8,%esp
f0101928:	83 ec 0c             	sub    $0xc,%esp
f010192b:	68 90 33 10 f0       	push   $0xf0103390
f0101930:	e8 31 0b 00 00       	call   f0102466 <cprintf>
f0101935:	83 c4 10             	add    $0x10,%esp
f0101938:	83 ec 0c             	sub    $0xc,%esp
f010193b:	6a 00                	push   $0x0
f010193d:	e8 37 f2 ff ff       	call   f0100b79 <monitor>
f0101942:	eb f1                	jmp    f0101935 <sched_halt+0x2f>
f0101944:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f0101949:	c7 05 ac 04 12 f0 00 	movl   $0x0,0xf01204ac
f0101950:	00 00 00 
f0101953:	05 00 00 00 10       	add    $0x10000000,%eax
f0101958:	0f 22 d8             	mov    %eax,%cr3
f010195b:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f0101960:	bd 00 00 00 00       	mov    $0x0,%ebp
f0101965:	89 c4                	mov    %eax,%esp
f0101967:	6a 00                	push   $0x0
f0101969:	6a 00                	push   $0x0
f010196b:	fb                   	sti    
f010196c:	f4                   	hlt    
f010196d:	eb fd                	jmp    f010196c <sched_halt+0x66>
f010196f:	c3                   	ret    

f0101970 <sched_yield>:
f0101970:	8b 15 ac 04 12 f0    	mov    0xf01204ac,%edx
f0101976:	55                   	push   %ebp
f0101977:	89 e5                	mov    %esp,%ebp
f0101979:	56                   	push   %esi
f010197a:	53                   	push   %ebx
f010197b:	31 db                	xor    %ebx,%ebx
f010197d:	85 d2                	test   %edx,%edx
f010197f:	74 09                	je     f010198a <sched_yield+0x1a>
f0101981:	8b 5a 48             	mov    0x48(%edx),%ebx
f0101984:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010198a:	8b 35 b0 04 12 f0    	mov    0xf01204b0,%esi
f0101990:	31 c9                	xor    %ecx,%ecx
f0101992:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f0101995:	25 ff 03 00 00       	and    $0x3ff,%eax
f010199a:	6b c0 7c             	imul   $0x7c,%eax,%eax
f010199d:	01 f0                	add    %esi,%eax
f010199f:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01019a3:	75 06                	jne    f01019ab <sched_yield+0x3b>
f01019a5:	83 ec 0c             	sub    $0xc,%esp
f01019a8:	50                   	push   %eax
f01019a9:	eb 17                	jmp    f01019c2 <sched_yield+0x52>
f01019ab:	41                   	inc    %ecx
f01019ac:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01019b2:	75 de                	jne    f0101992 <sched_yield+0x22>
f01019b4:	85 d2                	test   %edx,%edx
f01019b6:	74 0f                	je     f01019c7 <sched_yield+0x57>
f01019b8:	83 7a 54 03          	cmpl   $0x3,0x54(%edx)
f01019bc:	75 09                	jne    f01019c7 <sched_yield+0x57>
f01019be:	83 ec 0c             	sub    $0xc,%esp
f01019c1:	52                   	push   %edx
f01019c2:	e8 97 05 00 00       	call   f0101f5e <env_run>
f01019c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01019ca:	5b                   	pop    %ebx
f01019cb:	5e                   	pop    %esi
f01019cc:	5d                   	pop    %ebp
f01019cd:	e9 34 ff ff ff       	jmp    f0101906 <sched_halt>

f01019d2 <irq_setmask_8259A>:
f01019d2:	55                   	push   %ebp
f01019d3:	80 3d a8 04 12 f0 00 	cmpb   $0x0,0xf01204a8
f01019da:	89 e5                	mov    %esp,%ebp
f01019dc:	56                   	push   %esi
f01019dd:	53                   	push   %ebx
f01019de:	8b 45 08             	mov    0x8(%ebp),%eax
f01019e1:	0f b7 d8             	movzwl %ax,%ebx
f01019e4:	66 a3 46 e3 10 f0    	mov    %ax,0xf010e346
f01019ea:	74 4e                	je     f0101a3a <irq_setmask_8259A+0x68>
f01019ec:	ba 21 00 00 00       	mov    $0x21,%edx
f01019f1:	ee                   	out    %al,(%dx)
f01019f2:	66 c1 e8 08          	shr    $0x8,%ax
f01019f6:	b2 a1                	mov    $0xa1,%dl
f01019f8:	ee                   	out    %al,(%dx)
f01019f9:	83 ec 0c             	sub    $0xc,%esp
f01019fc:	31 f6                	xor    %esi,%esi
f01019fe:	f7 d3                	not    %ebx
f0101a00:	68 b9 33 10 f0       	push   $0xf01033b9
f0101a05:	e8 5c 0a 00 00       	call   f0102466 <cprintf>
f0101a0a:	83 c4 10             	add    $0x10,%esp
f0101a0d:	0f a3 f3             	bt     %esi,%ebx
f0101a10:	73 10                	jae    f0101a22 <irq_setmask_8259A+0x50>
f0101a12:	50                   	push   %eax
f0101a13:	50                   	push   %eax
f0101a14:	56                   	push   %esi
f0101a15:	68 48 34 10 f0       	push   $0xf0103448
f0101a1a:	e8 47 0a 00 00       	call   f0102466 <cprintf>
f0101a1f:	83 c4 10             	add    $0x10,%esp
f0101a22:	46                   	inc    %esi
f0101a23:	83 fe 10             	cmp    $0x10,%esi
f0101a26:	75 e5                	jne    f0101a0d <irq_setmask_8259A+0x3b>
f0101a28:	c7 45 08 09 2b 10 f0 	movl   $0xf0102b09,0x8(%ebp)
f0101a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101a32:	5b                   	pop    %ebx
f0101a33:	5e                   	pop    %esi
f0101a34:	5d                   	pop    %ebp
f0101a35:	e9 2c 0a 00 00       	jmp    f0102466 <cprintf>
f0101a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101a3d:	5b                   	pop    %ebx
f0101a3e:	5e                   	pop    %esi
f0101a3f:	5d                   	pop    %ebp
f0101a40:	c3                   	ret    

f0101a41 <pic_init>:
f0101a41:	55                   	push   %ebp
f0101a42:	b0 ff                	mov    $0xff,%al
f0101a44:	89 e5                	mov    %esp,%ebp
f0101a46:	57                   	push   %edi
f0101a47:	56                   	push   %esi
f0101a48:	53                   	push   %ebx
f0101a49:	bb 21 00 00 00       	mov    $0x21,%ebx
f0101a4e:	89 da                	mov    %ebx,%edx
f0101a50:	83 ec 0c             	sub    $0xc,%esp
f0101a53:	c6 05 a8 04 12 f0 01 	movb   $0x1,0xf01204a8
f0101a5a:	ee                   	out    %al,(%dx)
f0101a5b:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f0101a60:	89 ca                	mov    %ecx,%edx
f0101a62:	ee                   	out    %al,(%dx)
f0101a63:	bf 11 00 00 00       	mov    $0x11,%edi
f0101a68:	be 20 00 00 00       	mov    $0x20,%esi
f0101a6d:	89 f8                	mov    %edi,%eax
f0101a6f:	89 f2                	mov    %esi,%edx
f0101a71:	ee                   	out    %al,(%dx)
f0101a72:	b0 20                	mov    $0x20,%al
f0101a74:	89 da                	mov    %ebx,%edx
f0101a76:	ee                   	out    %al,(%dx)
f0101a77:	b0 04                	mov    $0x4,%al
f0101a79:	ee                   	out    %al,(%dx)
f0101a7a:	b0 03                	mov    $0x3,%al
f0101a7c:	ee                   	out    %al,(%dx)
f0101a7d:	b3 a0                	mov    $0xa0,%bl
f0101a7f:	89 f8                	mov    %edi,%eax
f0101a81:	89 da                	mov    %ebx,%edx
f0101a83:	ee                   	out    %al,(%dx)
f0101a84:	b0 28                	mov    $0x28,%al
f0101a86:	89 ca                	mov    %ecx,%edx
f0101a88:	ee                   	out    %al,(%dx)
f0101a89:	b0 02                	mov    $0x2,%al
f0101a8b:	ee                   	out    %al,(%dx)
f0101a8c:	b0 01                	mov    $0x1,%al
f0101a8e:	ee                   	out    %al,(%dx)
f0101a8f:	bf 68 00 00 00       	mov    $0x68,%edi
f0101a94:	89 f2                	mov    %esi,%edx
f0101a96:	89 f8                	mov    %edi,%eax
f0101a98:	ee                   	out    %al,(%dx)
f0101a99:	b1 0a                	mov    $0xa,%cl
f0101a9b:	88 c8                	mov    %cl,%al
f0101a9d:	ee                   	out    %al,(%dx)
f0101a9e:	89 f8                	mov    %edi,%eax
f0101aa0:	89 da                	mov    %ebx,%edx
f0101aa2:	ee                   	out    %al,(%dx)
f0101aa3:	88 c8                	mov    %cl,%al
f0101aa5:	ee                   	out    %al,(%dx)
f0101aa6:	0f b7 05 46 e3 10 f0 	movzwl 0xf010e346,%eax
f0101aad:	66 83 f8 ff          	cmp    $0xffff,%ax
f0101ab1:	74 0c                	je     f0101abf <pic_init+0x7e>
f0101ab3:	83 ec 0c             	sub    $0xc,%esp
f0101ab6:	50                   	push   %eax
f0101ab7:	e8 16 ff ff ff       	call   f01019d2 <irq_setmask_8259A>
f0101abc:	83 c4 10             	add    $0x10,%esp
f0101abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101ac2:	5b                   	pop    %ebx
f0101ac3:	5e                   	pop    %esi
f0101ac4:	5f                   	pop    %edi
f0101ac5:	5d                   	pop    %ebp
f0101ac6:	c3                   	ret    

f0101ac7 <region_alloc.isra.1>:
f0101ac7:	55                   	push   %ebp
f0101ac8:	89 e5                	mov    %esp,%ebp
f0101aca:	57                   	push   %edi
f0101acb:	56                   	push   %esi
f0101acc:	53                   	push   %ebx
f0101acd:	89 c6                	mov    %eax,%esi
f0101acf:	89 d7                	mov    %edx,%edi
f0101ad1:	31 db                	xor    %ebx,%ebx
f0101ad3:	83 ec 1c             	sub    $0x1c,%esp
f0101ad6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101ad9:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101adc:	73 3f                	jae    f0101b1d <region_alloc.isra.1+0x56>
f0101ade:	83 ec 0c             	sub    $0xc,%esp
f0101ae1:	6a 00                	push   $0x0
f0101ae3:	e8 77 e6 ff ff       	call   f010015f <page_alloc>
f0101ae8:	83 c4 10             	add    $0x10,%esp
f0101aeb:	85 c0                	test   %eax,%eax
f0101aed:	75 15                	jne    f0101b04 <region_alloc.isra.1+0x3d>
f0101aef:	50                   	push   %eax
f0101af0:	68 cd 33 10 f0       	push   $0xf01033cd
f0101af5:	68 28 01 00 00       	push   $0x128
f0101afa:	68 ee 33 10 f0       	push   $0xf01033ee
f0101aff:	e8 cd 0a 00 00       	call   f01025d1 <_panic>
f0101b04:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
f0101b07:	6a 07                	push   $0x7
f0101b09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101b0f:	52                   	push   %edx
f0101b10:	50                   	push   %eax
f0101b11:	ff 36                	pushl  (%esi)
f0101b13:	e8 f4 e9 ff ff       	call   f010050c <page_insert>
f0101b18:	83 c4 10             	add    $0x10,%esp
f0101b1b:	eb bc                	jmp    f0101ad9 <region_alloc.isra.1+0x12>
f0101b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101b20:	5b                   	pop    %ebx
f0101b21:	5e                   	pop    %esi
f0101b22:	5f                   	pop    %edi
f0101b23:	5d                   	pop    %ebp
f0101b24:	c3                   	ret    

f0101b25 <envid2env>:
f0101b25:	55                   	push   %ebp
f0101b26:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f0101b2b:	89 e5                	mov    %esp,%ebp
f0101b2d:	53                   	push   %ebx
f0101b2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101b31:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101b34:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0101b37:	85 c9                	test   %ecx,%ecx
f0101b39:	74 3e                	je     f0101b79 <envid2env+0x54>
f0101b3b:	89 c8                	mov    %ecx,%eax
f0101b3d:	25 ff 03 00 00       	and    $0x3ff,%eax
f0101b42:	6b c0 7c             	imul   $0x7c,%eax,%eax
f0101b45:	03 05 b0 04 12 f0    	add    0xf01204b0,%eax
f0101b4b:	83 78 54 00          	cmpl   $0x0,0x54(%eax)
f0101b4f:	74 05                	je     f0101b56 <envid2env+0x31>
f0101b51:	39 48 48             	cmp    %ecx,0x48(%eax)
f0101b54:	74 0d                	je     f0101b63 <envid2env+0x3e>
f0101b56:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f0101b5c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0101b61:	eb 1a                	jmp    f0101b7d <envid2env+0x58>
f0101b63:	84 db                	test   %bl,%bl
f0101b65:	74 12                	je     f0101b79 <envid2env+0x54>
f0101b67:	8b 0d ac 04 12 f0    	mov    0xf01204ac,%ecx
f0101b6d:	39 c8                	cmp    %ecx,%eax
f0101b6f:	74 08                	je     f0101b79 <envid2env+0x54>
f0101b71:	8b 59 48             	mov    0x48(%ecx),%ebx
f0101b74:	39 58 4c             	cmp    %ebx,0x4c(%eax)
f0101b77:	75 dd                	jne    f0101b56 <envid2env+0x31>
f0101b79:	89 02                	mov    %eax,(%edx)
f0101b7b:	31 c0                	xor    %eax,%eax
f0101b7d:	5b                   	pop    %ebx
f0101b7e:	5d                   	pop    %ebp
f0101b7f:	c3                   	ret    

f0101b80 <env_init_percpu>:
f0101b80:	55                   	push   %ebp
f0101b81:	b8 48 e3 10 f0       	mov    $0xf010e348,%eax
f0101b86:	89 e5                	mov    %esp,%ebp
f0101b88:	0f 01 10             	lgdtl  (%eax)
f0101b8b:	b8 23 00 00 00       	mov    $0x23,%eax
f0101b90:	8e e8                	mov    %eax,%gs
f0101b92:	8e e0                	mov    %eax,%fs
f0101b94:	b0 10                	mov    $0x10,%al
f0101b96:	8e c0                	mov    %eax,%es
f0101b98:	8e d8                	mov    %eax,%ds
f0101b9a:	8e d0                	mov    %eax,%ss
f0101b9c:	ea a3 1b 10 f0 08 00 	ljmp   $0x8,$0xf0101ba3
f0101ba3:	30 c0                	xor    %al,%al
f0101ba5:	0f 00 d0             	lldt   %ax
f0101ba8:	5d                   	pop    %ebp
f0101ba9:	c3                   	ret    

f0101baa <env_init>:
f0101baa:	8b 15 b0 04 12 f0    	mov    0xf01204b0,%edx
f0101bb0:	55                   	push   %ebp
f0101bb1:	8b 0d b4 04 12 f0    	mov    0xf01204b4,%ecx
f0101bb7:	89 e5                	mov    %esp,%ebp
f0101bb9:	56                   	push   %esi
f0101bba:	53                   	push   %ebx
f0101bbb:	8d 82 84 ef 01 00    	lea    0x1ef84(%edx),%eax
f0101bc1:	8d 5a 84             	lea    -0x7c(%edx),%ebx
f0101bc4:	89 48 44             	mov    %ecx,0x44(%eax)
f0101bc7:	89 c6                	mov    %eax,%esi
f0101bc9:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
f0101bd0:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
f0101bd7:	83 e8 7c             	sub    $0x7c,%eax
f0101bda:	89 f1                	mov    %esi,%ecx
f0101bdc:	39 d8                	cmp    %ebx,%eax
f0101bde:	75 e4                	jne    f0101bc4 <env_init+0x1a>
f0101be0:	5b                   	pop    %ebx
f0101be1:	5e                   	pop    %esi
f0101be2:	5d                   	pop    %ebp
f0101be3:	89 15 b4 04 12 f0    	mov    %edx,0xf01204b4
f0101be9:	eb 95                	jmp    f0101b80 <env_init_percpu>

f0101beb <env_alloc>:
f0101beb:	55                   	push   %ebp
f0101bec:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0101bf1:	89 e5                	mov    %esp,%ebp
f0101bf3:	56                   	push   %esi
f0101bf4:	53                   	push   %ebx
f0101bf5:	8b 1d b4 04 12 f0    	mov    0xf01204b4,%ebx
f0101bfb:	85 db                	test   %ebx,%ebx
f0101bfd:	0f 84 13 01 00 00    	je     f0101d16 <env_alloc+0x12b>
f0101c03:	83 ec 0c             	sub    $0xc,%esp
f0101c06:	6a 01                	push   $0x1
f0101c08:	e8 52 e5 ff ff       	call   f010015f <page_alloc>
f0101c0d:	89 c6                	mov    %eax,%esi
f0101c0f:	83 c4 10             	add    $0x10,%esp
f0101c12:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101c17:	85 f6                	test   %esi,%esi
f0101c19:	0f 84 f7 00 00 00    	je     f0101d16 <env_alloc+0x12b>
f0101c1f:	89 f2                	mov    %esi,%edx
f0101c21:	2b 15 c8 08 12 f0    	sub    0xf01208c8,%edx
f0101c27:	c1 fa 03             	sar    $0x3,%edx
f0101c2a:	c1 e2 0c             	shl    $0xc,%edx
f0101c2d:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101c33:	89 53 60             	mov    %edx,0x60(%ebx)
f0101c36:	51                   	push   %ecx
f0101c37:	68 00 10 00 00       	push   $0x1000
f0101c3c:	ff 35 c4 08 12 f0    	pushl  0xf01208c4
f0101c42:	52                   	push   %edx
f0101c43:	e8 81 0c 00 00       	call   f01028c9 <memcpy>
f0101c48:	66 ff 46 04          	incw   0x4(%esi)
f0101c4c:	83 c4 0c             	add    $0xc,%esp
f0101c4f:	8b 53 60             	mov    0x60(%ebx),%edx
f0101c52:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
f0101c58:	83 c8 05             	or     $0x5,%eax
f0101c5b:	89 82 f4 0e 00 00    	mov    %eax,0xef4(%edx)
f0101c61:	8b 43 48             	mov    0x48(%ebx),%eax
f0101c64:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c69:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
f0101c70:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
f0101c77:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
f0101c7e:	05 00 10 00 00       	add    $0x1000,%eax
f0101c83:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0101c88:	0f 4e c2             	cmovle %edx,%eax
f0101c8b:	89 da                	mov    %ebx,%edx
f0101c8d:	2b 15 b0 04 12 f0    	sub    0xf01204b0,%edx
f0101c93:	c1 fa 02             	sar    $0x2,%edx
f0101c96:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0101c9c:	09 d0                	or     %edx,%eax
f0101c9e:	89 43 48             	mov    %eax,0x48(%ebx)
f0101ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101ca4:	89 43 4c             	mov    %eax,0x4c(%ebx)
f0101ca7:	6a 44                	push   $0x44
f0101ca9:	6a 00                	push   $0x0
f0101cab:	53                   	push   %ebx
f0101cac:	e8 63 0b 00 00       	call   f0102814 <memset>
f0101cb1:	8b 43 44             	mov    0x44(%ebx),%eax
f0101cb4:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
f0101cbb:	83 c4 10             	add    $0x10,%esp
f0101cbe:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
f0101cc4:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
f0101cca:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
f0101cd0:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
f0101cd7:	a3 b4 04 12 f0       	mov    %eax,0xf01204b4
f0101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
f0101cdf:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
f0101ce5:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
f0101cec:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
f0101cf0:	89 18                	mov    %ebx,(%eax)
f0101cf2:	8b 15 ac 04 12 f0    	mov    0xf01204ac,%edx
f0101cf8:	31 c0                	xor    %eax,%eax
f0101cfa:	8b 4b 48             	mov    0x48(%ebx),%ecx
f0101cfd:	85 d2                	test   %edx,%edx
f0101cff:	74 03                	je     f0101d04 <env_alloc+0x119>
f0101d01:	8b 42 48             	mov    0x48(%edx),%eax
f0101d04:	52                   	push   %edx
f0101d05:	51                   	push   %ecx
f0101d06:	50                   	push   %eax
f0101d07:	68 f4 33 10 f0       	push   $0xf01033f4
f0101d0c:	e8 55 07 00 00       	call   f0102466 <cprintf>
f0101d11:	83 c4 10             	add    $0x10,%esp
f0101d14:	31 c0                	xor    %eax,%eax
f0101d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101d19:	5b                   	pop    %ebx
f0101d1a:	5e                   	pop    %esi
f0101d1b:	5d                   	pop    %ebp
f0101d1c:	c3                   	ret    

f0101d1d <env_create>:
f0101d1d:	55                   	push   %ebp
f0101d1e:	89 e5                	mov    %esp,%ebp
f0101d20:	57                   	push   %edi
f0101d21:	56                   	push   %esi
f0101d22:	53                   	push   %ebx
f0101d23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d26:	83 ec 34             	sub    $0x34,%esp
f0101d29:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101d2c:	6a 00                	push   $0x0
f0101d2e:	50                   	push   %eax
f0101d2f:	e8 b7 fe ff ff       	call   f0101beb <env_alloc>
f0101d34:	83 c4 10             	add    $0x10,%esp
f0101d37:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0101d3b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0101d3e:	75 07                	jne    f0101d47 <env_create+0x2a>
f0101d40:	81 4e 38 00 30 00 00 	orl    $0x3000,0x38(%esi)
f0101d47:	81 76 38 00 02 00 00 	xorl   $0x200,0x38(%esi)
f0101d4e:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f0101d52:	8b 5f 1c             	mov    0x1c(%edi),%ebx
f0101d55:	01 fb                	add    %edi,%ebx
f0101d57:	c1 e0 05             	shl    $0x5,%eax
f0101d5a:	01 d8                	add    %ebx,%eax
f0101d5c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101d5f:	8b 46 60             	mov    0x60(%esi),%eax
f0101d62:	05 00 00 00 10       	add    $0x10000000,%eax
f0101d67:	0f 22 d8             	mov    %eax,%cr3
f0101d6a:	8d 46 60             	lea    0x60(%esi),%eax
f0101d6d:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101d70:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0101d73:	73 3d                	jae    f0101db2 <env_create+0x95>
f0101d75:	83 3b 01             	cmpl   $0x1,(%ebx)
f0101d78:	75 33                	jne    f0101dad <env_create+0x90>
f0101d7a:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101d7d:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0101d80:	8b 53 08             	mov    0x8(%ebx),%edx
f0101d83:	e8 3f fd ff ff       	call   f0101ac7 <region_alloc.isra.1>
f0101d88:	50                   	push   %eax
f0101d89:	ff 73 14             	pushl  0x14(%ebx)
f0101d8c:	6a 00                	push   $0x0
f0101d8e:	ff 73 08             	pushl  0x8(%ebx)
f0101d91:	e8 7e 0a 00 00       	call   f0102814 <memset>
f0101d96:	83 c4 0c             	add    $0xc,%esp
f0101d99:	ff 73 10             	pushl  0x10(%ebx)
f0101d9c:	8b 43 04             	mov    0x4(%ebx),%eax
f0101d9f:	01 f8                	add    %edi,%eax
f0101da1:	50                   	push   %eax
f0101da2:	ff 73 08             	pushl  0x8(%ebx)
f0101da5:	e8 1f 0b 00 00       	call   f01028c9 <memcpy>
f0101daa:	83 c4 10             	add    $0x10,%esp
f0101dad:	83 c3 20             	add    $0x20,%ebx
f0101db0:	eb be                	jmp    f0101d70 <env_create+0x53>
f0101db2:	a1 c4 08 12 f0       	mov    0xf01208c4,%eax
f0101db7:	05 00 00 00 10       	add    $0x10000000,%eax
f0101dbc:	0f 22 d8             	mov    %eax,%cr3
f0101dbf:	8b 47 18             	mov    0x18(%edi),%eax
f0101dc2:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0101dc7:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0101dcc:	89 46 30             	mov    %eax,0x30(%esi)
f0101dcf:	8d 46 60             	lea    0x60(%esi),%eax
f0101dd2:	e8 f0 fc ff ff       	call   f0101ac7 <region_alloc.isra.1>
f0101dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101dda:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101ddd:	89 50 50             	mov    %edx,0x50(%eax)
f0101de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101de3:	5b                   	pop    %ebx
f0101de4:	5e                   	pop    %esi
f0101de5:	5f                   	pop    %edi
f0101de6:	5d                   	pop    %ebp
f0101de7:	c3                   	ret    

f0101de8 <env_free>:
f0101de8:	55                   	push   %ebp
f0101de9:	89 e5                	mov    %esp,%ebp
f0101deb:	57                   	push   %edi
f0101dec:	56                   	push   %esi
f0101ded:	53                   	push   %ebx
f0101dee:	83 ec 1c             	sub    $0x1c,%esp
f0101df1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101df4:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f0101df9:	39 c3                	cmp    %eax,%ebx
f0101dfb:	75 0f                	jne    f0101e0c <env_free+0x24>
f0101dfd:	8b 0d c4 08 12 f0    	mov    0xf01208c4,%ecx
f0101e03:	8d 91 00 00 00 10    	lea    0x10000000(%ecx),%edx
f0101e09:	0f 22 da             	mov    %edx,%cr3
f0101e0c:	31 d2                	xor    %edx,%edx
f0101e0e:	85 c0                	test   %eax,%eax
f0101e10:	8b 4b 48             	mov    0x48(%ebx),%ecx
f0101e13:	74 03                	je     f0101e18 <env_free+0x30>
f0101e15:	8b 50 48             	mov    0x48(%eax),%edx
f0101e18:	56                   	push   %esi
f0101e19:	51                   	push   %ecx
f0101e1a:	31 ff                	xor    %edi,%edi
f0101e1c:	52                   	push   %edx
f0101e1d:	68 09 34 10 f0       	push   $0xf0103409
f0101e22:	e8 3f 06 00 00       	call   f0102466 <cprintf>
f0101e27:	83 c4 10             	add    $0x10,%esp
f0101e2a:	8b 43 60             	mov    0x60(%ebx),%eax
f0101e2d:	8d 0c bd 00 00 00 00 	lea    0x0(,%edi,4),%ecx
f0101e34:	8b 34 b8             	mov    (%eax,%edi,4),%esi
f0101e37:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0101e3d:	74 63                	je     f0101ea2 <env_free+0xba>
f0101e3f:	89 f8                	mov    %edi,%eax
f0101e41:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f0101e47:	c1 e0 16             	shl    $0x16,%eax
f0101e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101e4d:	31 c0                	xor    %eax,%eax
f0101e4f:	f6 84 86 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%eax,4)
f0101e56:	01 
f0101e57:	74 22                	je     f0101e7b <env_free+0x93>
f0101e59:	52                   	push   %edx
f0101e5a:	52                   	push   %edx
f0101e5b:	89 c2                	mov    %eax,%edx
f0101e5d:	c1 e2 0c             	shl    $0xc,%edx
f0101e60:	0b 55 e4             	or     -0x1c(%ebp),%edx
f0101e63:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0101e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101e69:	52                   	push   %edx
f0101e6a:	ff 73 60             	pushl  0x60(%ebx)
f0101e6d:	e8 47 e6 ff ff       	call   f01004b9 <page_remove>
f0101e72:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101e78:	83 c4 10             	add    $0x10,%esp
f0101e7b:	40                   	inc    %eax
f0101e7c:	3d 00 04 00 00       	cmp    $0x400,%eax
f0101e81:	75 cc                	jne    f0101e4f <env_free+0x67>
f0101e83:	8b 43 60             	mov    0x60(%ebx),%eax
f0101e86:	c1 ee 09             	shr    $0x9,%esi
f0101e89:	83 ec 0c             	sub    $0xc,%esp
f0101e8c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
f0101e93:	03 35 c8 08 12 f0    	add    0xf01208c8,%esi
f0101e99:	56                   	push   %esi
f0101e9a:	e8 54 e3 ff ff       	call   f01001f3 <page_decref>
f0101e9f:	83 c4 10             	add    $0x10,%esp
f0101ea2:	47                   	inc    %edi
f0101ea3:	81 ff bb 03 00 00    	cmp    $0x3bb,%edi
f0101ea9:	0f 85 7b ff ff ff    	jne    f0101e2a <env_free+0x42>
f0101eaf:	8b 43 60             	mov    0x60(%ebx),%eax
f0101eb2:	8b 15 c8 08 12 f0    	mov    0xf01208c8,%edx
f0101eb8:	83 ec 0c             	sub    $0xc,%esp
f0101ebb:	c7 43 60 00 00 00 00 	movl   $0x0,0x60(%ebx)
f0101ec2:	05 00 00 00 10       	add    $0x10000000,%eax
f0101ec7:	c1 e8 0c             	shr    $0xc,%eax
f0101eca:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0101ecd:	50                   	push   %eax
f0101ece:	e8 20 e3 ff ff       	call   f01001f3 <page_decref>
f0101ed3:	a1 b4 04 12 f0       	mov    0xf01204b4,%eax
f0101ed8:	c7 43 54 00 00 00 00 	movl   $0x0,0x54(%ebx)
f0101edf:	83 c4 10             	add    $0x10,%esp
f0101ee2:	89 1d b4 04 12 f0    	mov    %ebx,0xf01204b4
f0101ee8:	89 43 44             	mov    %eax,0x44(%ebx)
f0101eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101eee:	5b                   	pop    %ebx
f0101eef:	5e                   	pop    %esi
f0101ef0:	5f                   	pop    %edi
f0101ef1:	5d                   	pop    %ebp
f0101ef2:	c3                   	ret    

f0101ef3 <env_destroy>:
f0101ef3:	55                   	push   %ebp
f0101ef4:	89 e5                	mov    %esp,%ebp
f0101ef6:	53                   	push   %ebx
f0101ef7:	50                   	push   %eax
f0101ef8:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101efb:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0101eff:	75 11                	jne    f0101f12 <env_destroy+0x1f>
f0101f01:	39 1d ac 04 12 f0    	cmp    %ebx,0xf01204ac
f0101f07:	74 09                	je     f0101f12 <env_destroy+0x1f>
f0101f09:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
f0101f10:	eb 23                	jmp    f0101f35 <env_destroy+0x42>
f0101f12:	83 ec 0c             	sub    $0xc,%esp
f0101f15:	53                   	push   %ebx
f0101f16:	e8 cd fe ff ff       	call   f0101de8 <env_free>
f0101f1b:	83 c4 10             	add    $0x10,%esp
f0101f1e:	39 1d ac 04 12 f0    	cmp    %ebx,0xf01204ac
f0101f24:	75 0f                	jne    f0101f35 <env_destroy+0x42>
f0101f26:	c7 05 ac 04 12 f0 00 	movl   $0x0,0xf01204ac
f0101f2d:	00 00 00 
f0101f30:	e8 3b fa ff ff       	call   f0101970 <sched_yield>
f0101f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101f38:	c9                   	leave  
f0101f39:	c3                   	ret    

f0101f3a <env_pop_tf>:
f0101f3a:	55                   	push   %ebp
f0101f3b:	89 e5                	mov    %esp,%ebp
f0101f3d:	83 ec 0c             	sub    $0xc,%esp
f0101f40:	8b 65 08             	mov    0x8(%ebp),%esp
f0101f43:	61                   	popa   
f0101f44:	07                   	pop    %es
f0101f45:	1f                   	pop    %ds
f0101f46:	83 c4 08             	add    $0x8,%esp
f0101f49:	cf                   	iret   
f0101f4a:	68 1f 34 10 f0       	push   $0xf010341f
f0101f4f:	68 e6 01 00 00       	push   $0x1e6
f0101f54:	68 ee 33 10 f0       	push   $0xf01033ee
f0101f59:	e8 73 06 00 00       	call   f01025d1 <_panic>

f0101f5e <env_run>:
f0101f5e:	55                   	push   %ebp
f0101f5f:	89 e5                	mov    %esp,%ebp
f0101f61:	53                   	push   %ebx
f0101f62:	50                   	push   %eax
f0101f63:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101f66:	a1 ac 04 12 f0       	mov    0xf01204ac,%eax
f0101f6b:	39 d8                	cmp    %ebx,%eax
f0101f6d:	74 2c                	je     f0101f9b <env_run+0x3d>
f0101f6f:	85 c0                	test   %eax,%eax
f0101f71:	74 0d                	je     f0101f80 <env_run+0x22>
f0101f73:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0101f77:	75 07                	jne    f0101f80 <env_run+0x22>
f0101f79:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0101f80:	8b 43 60             	mov    0x60(%ebx),%eax
f0101f83:	89 1d ac 04 12 f0    	mov    %ebx,0xf01204ac
f0101f89:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
f0101f90:	ff 43 58             	incl   0x58(%ebx)
f0101f93:	05 00 00 00 10       	add    $0x10000000,%eax
f0101f98:	0f 22 d8             	mov    %eax,%cr3
f0101f9b:	83 ec 0c             	sub    $0xc,%esp
f0101f9e:	68 cc 08 12 f0       	push   $0xf01208cc
f0101fa3:	e8 32 00 00 00       	call   f0101fda <spin_unlock>
f0101fa8:	f3 90                	pause  
f0101faa:	89 1c 24             	mov    %ebx,(%esp)
f0101fad:	e8 88 ff ff ff       	call   f0101f3a <env_pop_tf>

f0101fb2 <__spin_initlock>:
f0101fb2:	55                   	push   %ebp
f0101fb3:	89 e5                	mov    %esp,%ebp
f0101fb5:	8b 45 08             	mov    0x8(%ebp),%eax
f0101fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101fbe:	5d                   	pop    %ebp
f0101fbf:	c3                   	ret    

f0101fc0 <spin_lock>:
f0101fc0:	55                   	push   %ebp
f0101fc1:	b9 01 00 00 00       	mov    $0x1,%ecx
f0101fc6:	89 e5                	mov    %esp,%ebp
f0101fc8:	8b 55 08             	mov    0x8(%ebp),%edx
f0101fcb:	89 c8                	mov    %ecx,%eax
f0101fcd:	f0 87 02             	lock xchg %eax,(%edx)
f0101fd0:	85 c0                	test   %eax,%eax
f0101fd2:	74 04                	je     f0101fd8 <spin_lock+0x18>
f0101fd4:	f3 90                	pause  
f0101fd6:	eb f3                	jmp    f0101fcb <spin_lock+0xb>
f0101fd8:	5d                   	pop    %ebp
f0101fd9:	c3                   	ret    

f0101fda <spin_unlock>:
f0101fda:	55                   	push   %ebp
f0101fdb:	31 c0                	xor    %eax,%eax
f0101fdd:	89 e5                	mov    %esp,%ebp
f0101fdf:	8b 55 08             	mov    0x8(%ebp),%edx
f0101fe2:	f0 87 02             	lock xchg %eax,(%edx)
f0101fe5:	5d                   	pop    %ebp
f0101fe6:	c3                   	ret    

f0101fe7 <printnum>:
f0101fe7:	55                   	push   %ebp
f0101fe8:	89 e5                	mov    %esp,%ebp
f0101fea:	57                   	push   %edi
f0101feb:	56                   	push   %esi
f0101fec:	53                   	push   %ebx
f0101fed:	89 d7                	mov    %edx,%edi
f0101fef:	83 ec 1c             	sub    $0x1c,%esp
f0101ff2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101ff8:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
f0101ffb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101ffe:	8b 75 0c             	mov    0xc(%ebp),%esi
f0102001:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0102004:	72 1d                	jb     f0102023 <printnum+0x3c>
f0102006:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102009:	31 d2                	xor    %edx,%edx
f010200b:	4e                   	dec    %esi
f010200c:	f7 f3                	div    %ebx
f010200e:	52                   	push   %edx
f010200f:	51                   	push   %ecx
f0102010:	89 c1                	mov    %eax,%ecx
f0102012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102015:	56                   	push   %esi
f0102016:	89 fa                	mov    %edi,%edx
f0102018:	53                   	push   %ebx
f0102019:	e8 c9 ff ff ff       	call   f0101fe7 <printnum>
f010201e:	83 c4 10             	add    $0x10,%esp
f0102021:	eb 19                	jmp    f010203c <printnum+0x55>
f0102023:	4e                   	dec    %esi
f0102024:	85 f6                	test   %esi,%esi
f0102026:	7e 14                	jle    f010203c <printnum+0x55>
f0102028:	50                   	push   %eax
f0102029:	50                   	push   %eax
f010202a:	57                   	push   %edi
f010202b:	51                   	push   %ecx
f010202c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010202f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102032:	ff d0                	call   *%eax
f0102034:	83 c4 10             	add    $0x10,%esp
f0102037:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010203a:	eb e7                	jmp    f0102023 <printnum+0x3c>
f010203c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010203f:	31 d2                	xor    %edx,%edx
f0102041:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0102044:	f7 f3                	div    %ebx
f0102046:	0f be 82 2b 34 10 f0 	movsbl -0xfefcbd5(%edx),%eax
f010204d:	89 45 08             	mov    %eax,0x8(%ebp)
f0102050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102053:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102056:	5b                   	pop    %ebx
f0102057:	5e                   	pop    %esi
f0102058:	5f                   	pop    %edi
f0102059:	5d                   	pop    %ebp
f010205a:	ff e0                	jmp    *%eax

f010205c <sprintputch>:
f010205c:	55                   	push   %ebp
f010205d:	89 e5                	mov    %esp,%ebp
f010205f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102062:	ff 40 08             	incl   0x8(%eax)
f0102065:	8b 10                	mov    (%eax),%edx
f0102067:	3b 50 04             	cmp    0x4(%eax),%edx
f010206a:	73 0a                	jae    f0102076 <sprintputch+0x1a>
f010206c:	8d 4a 01             	lea    0x1(%edx),%ecx
f010206f:	89 08                	mov    %ecx,(%eax)
f0102071:	8b 45 08             	mov    0x8(%ebp),%eax
f0102074:	88 02                	mov    %al,(%edx)
f0102076:	5d                   	pop    %ebp
f0102077:	c3                   	ret    

f0102078 <putch>:
f0102078:	55                   	push   %ebp
f0102079:	89 e5                	mov    %esp,%ebp
f010207b:	53                   	push   %ebx
f010207c:	83 ec 10             	sub    $0x10,%esp
f010207f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102082:	ff 75 08             	pushl  0x8(%ebp)
f0102085:	e8 ee e9 ff ff       	call   f0100a78 <cputchar>
f010208a:	ff 03                	incl   (%ebx)
f010208c:	83 c4 10             	add    $0x10,%esp
f010208f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102092:	c9                   	leave  
f0102093:	c3                   	ret    

f0102094 <getuint>:
f0102094:	55                   	push   %ebp
f0102095:	83 fa 01             	cmp    $0x1,%edx
f0102098:	8b 08                	mov    (%eax),%ecx
f010209a:	89 e5                	mov    %esp,%ebp
f010209c:	7e 0c                	jle    f01020aa <getuint+0x16>
f010209e:	8d 51 08             	lea    0x8(%ecx),%edx
f01020a1:	89 10                	mov    %edx,(%eax)
f01020a3:	8b 01                	mov    (%ecx),%eax
f01020a5:	8b 51 04             	mov    0x4(%ecx),%edx
f01020a8:	eb 09                	jmp    f01020b3 <getuint+0x1f>
f01020aa:	8d 51 04             	lea    0x4(%ecx),%edx
f01020ad:	89 10                	mov    %edx,(%eax)
f01020af:	8b 01                	mov    (%ecx),%eax
f01020b1:	31 d2                	xor    %edx,%edx
f01020b3:	5d                   	pop    %ebp
f01020b4:	c3                   	ret    

f01020b5 <vprintfmt>:
f01020b5:	55                   	push   %ebp
f01020b6:	89 e5                	mov    %esp,%ebp
f01020b8:	57                   	push   %edi
f01020b9:	56                   	push   %esi
f01020ba:	53                   	push   %ebx
f01020bb:	83 ec 2c             	sub    $0x2c,%esp
f01020be:	8b 7d 08             	mov    0x8(%ebp),%edi
f01020c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01020c4:	8b 75 10             	mov    0x10(%ebp),%esi
f01020c7:	46                   	inc    %esi
f01020c8:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
f01020cc:	83 f8 25             	cmp    $0x25,%eax
f01020cf:	74 13                	je     f01020e4 <vprintfmt+0x2f>
f01020d1:	85 c0                	test   %eax,%eax
f01020d3:	0f 84 5f 03 00 00    	je     f0102438 <vprintfmt+0x383>
f01020d9:	51                   	push   %ecx
f01020da:	51                   	push   %ecx
f01020db:	53                   	push   %ebx
f01020dc:	50                   	push   %eax
f01020dd:	ff d7                	call   *%edi
f01020df:	83 c4 10             	add    $0x10,%esp
f01020e2:	eb e3                	jmp    f01020c7 <vprintfmt+0x12>
f01020e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f01020e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f01020ef:	31 d2                	xor    %edx,%edx
f01020f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f01020f8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f01020ff:	0f b6 0e             	movzbl (%esi),%ecx
f0102102:	8d 46 01             	lea    0x1(%esi),%eax
f0102105:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0102108:	80 f9 63             	cmp    $0x63,%cl
f010210b:	0f 84 4d 01 00 00    	je     f010225e <vprintfmt+0x1a9>
f0102111:	77 6f                	ja     f0102182 <vprintfmt+0xcd>
f0102113:	80 f9 2d             	cmp    $0x2d,%cl
f0102116:	75 09                	jne    f0102121 <vprintfmt+0x6c>
f0102118:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f010211c:	8b 75 e0             	mov    -0x20(%ebp),%esi
f010211f:	eb de                	jmp    f01020ff <vprintfmt+0x4a>
f0102121:	77 24                	ja     f0102147 <vprintfmt+0x92>
f0102123:	80 f9 25             	cmp    $0x25,%cl
f0102126:	0f 84 df 02 00 00    	je     f010240b <vprintfmt+0x356>
f010212c:	80 f9 2a             	cmp    $0x2a,%cl
f010212f:	0f 84 ff 00 00 00    	je     f0102234 <vprintfmt+0x17f>
f0102135:	80 f9 23             	cmp    $0x23,%cl
f0102138:	0f 85 db 02 00 00    	jne    f0102419 <vprintfmt+0x364>
f010213e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
f0102145:	eb d5                	jmp    f010211c <vprintfmt+0x67>
f0102147:	80 f9 30             	cmp    $0x30,%cl
f010214a:	0f 84 bd 00 00 00    	je     f010220d <vprintfmt+0x158>
f0102150:	77 1b                	ja     f010216d <vprintfmt+0xb8>
f0102152:	80 f9 2e             	cmp    $0x2e,%cl
f0102155:	0f 85 be 02 00 00    	jne    f0102419 <vprintfmt+0x364>
f010215b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010215f:	b8 00 00 00 00       	mov    $0x0,%eax
f0102164:	0f 49 45 e4          	cmovns -0x1c(%ebp),%eax
f0102168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010216b:	eb af                	jmp    f010211c <vprintfmt+0x67>
f010216d:	80 f9 39             	cmp    $0x39,%cl
f0102170:	0f 87 a3 02 00 00    	ja     f0102419 <vprintfmt+0x364>
f0102176:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f010217d:	e9 94 00 00 00       	jmp    f0102216 <vprintfmt+0x161>
f0102182:	80 f9 6f             	cmp    $0x6f,%cl
f0102185:	0f 84 4e 02 00 00    	je     f01023d9 <vprintfmt+0x324>
f010218b:	77 1e                	ja     f01021ab <vprintfmt+0xf6>
f010218d:	80 f9 65             	cmp    $0x65,%cl
f0102190:	0f 84 db 00 00 00    	je     f0102271 <vprintfmt+0x1bc>
f0102196:	0f 82 e5 01 00 00    	jb     f0102381 <vprintfmt+0x2cc>
f010219c:	80 f9 6c             	cmp    $0x6c,%cl
f010219f:	0f 85 74 02 00 00    	jne    f0102419 <vprintfmt+0x364>
f01021a5:	42                   	inc    %edx
f01021a6:	e9 71 ff ff ff       	jmp    f010211c <vprintfmt+0x67>
f01021ab:	80 f9 73             	cmp    $0x73,%cl
f01021ae:	0f 84 f7 00 00 00    	je     f01022ab <vprintfmt+0x1f6>
f01021b4:	77 32                	ja     f01021e8 <vprintfmt+0x133>
f01021b6:	80 f9 70             	cmp    $0x70,%cl
f01021b9:	0f 85 5a 02 00 00    	jne    f0102419 <vprintfmt+0x364>
f01021bf:	56                   	push   %esi
f01021c0:	56                   	push   %esi
f01021c1:	53                   	push   %ebx
f01021c2:	6a 30                	push   $0x30
f01021c4:	ff d7                	call   *%edi
f01021c6:	58                   	pop    %eax
f01021c7:	5a                   	pop    %edx
f01021c8:	53                   	push   %ebx
f01021c9:	6a 78                	push   $0x78
f01021cb:	ff d7                	call   *%edi
f01021cd:	8b 45 14             	mov    0x14(%ebp),%eax
f01021d0:	83 c4 10             	add    $0x10,%esp
f01021d3:	8d 50 04             	lea    0x4(%eax),%edx
f01021d6:	89 55 14             	mov    %edx,0x14(%ebp)
f01021d9:	8b 00                	mov    (%eax),%eax
f01021db:	31 d2                	xor    %edx,%edx
f01021dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01021e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01021e3:	e9 06 02 00 00       	jmp    f01023ee <vprintfmt+0x339>
f01021e8:	80 f9 75             	cmp    $0x75,%cl
f01021eb:	0f 84 d3 01 00 00    	je     f01023c4 <vprintfmt+0x30f>
f01021f1:	80 f9 78             	cmp    $0x78,%cl
f01021f4:	0f 85 1f 02 00 00    	jne    f0102419 <vprintfmt+0x364>
f01021fa:	8d 45 14             	lea    0x14(%ebp),%eax
f01021fd:	e8 92 fe ff ff       	call   f0102094 <getuint>
f0102202:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102205:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0102208:	e9 e1 01 00 00       	jmp    f01023ee <vprintfmt+0x339>
f010220d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0102211:	e9 06 ff ff ff       	jmp    f010211c <vprintfmt+0x67>
f0102216:	6b 45 d8 0a          	imul   $0xa,-0x28(%ebp),%eax
f010221a:	8d 44 01 d0          	lea    -0x30(%ecx,%eax,1),%eax
f010221e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102221:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102224:	0f be 08             	movsbl (%eax),%ecx
f0102227:	8d 41 d0             	lea    -0x30(%ecx),%eax
f010222a:	83 f8 09             	cmp    $0x9,%eax
f010222d:	77 13                	ja     f0102242 <vprintfmt+0x18d>
f010222f:	ff 45 e0             	incl   -0x20(%ebp)
f0102232:	eb e2                	jmp    f0102216 <vprintfmt+0x161>
f0102234:	8b 45 14             	mov    0x14(%ebp),%eax
f0102237:	8d 48 04             	lea    0x4(%eax),%ecx
f010223a:	89 4d 14             	mov    %ecx,0x14(%ebp)
f010223d:	8b 00                	mov    (%eax),%eax
f010223f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102242:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0102246:	0f 89 d0 fe ff ff    	jns    f010211c <vprintfmt+0x67>
f010224c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010224f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0102256:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102259:	e9 be fe ff ff       	jmp    f010211c <vprintfmt+0x67>
f010225e:	8b 45 14             	mov    0x14(%ebp),%eax
f0102261:	8d 50 04             	lea    0x4(%eax),%edx
f0102264:	89 55 14             	mov    %edx,0x14(%ebp)
f0102267:	52                   	push   %edx
f0102268:	52                   	push   %edx
f0102269:	53                   	push   %ebx
f010226a:	ff 30                	pushl  (%eax)
f010226c:	e9 9e 01 00 00       	jmp    f010240f <vprintfmt+0x35a>
f0102271:	8b 45 14             	mov    0x14(%ebp),%eax
f0102274:	8d 50 04             	lea    0x4(%eax),%edx
f0102277:	89 55 14             	mov    %edx,0x14(%ebp)
f010227a:	8b 00                	mov    (%eax),%eax
f010227c:	99                   	cltd   
f010227d:	31 d0                	xor    %edx,%eax
f010227f:	29 d0                	sub    %edx,%eax
f0102281:	83 f8 11             	cmp    $0x11,%eax
f0102284:	7f 0b                	jg     f0102291 <vprintfmt+0x1dc>
f0102286:	8b 14 85 00 36 10 f0 	mov    -0xfefca00(,%eax,4),%edx
f010228d:	85 d2                	test   %edx,%edx
f010228f:	75 08                	jne    f0102299 <vprintfmt+0x1e4>
f0102291:	50                   	push   %eax
f0102292:	68 43 34 10 f0       	push   $0xf0103443
f0102297:	eb 06                	jmp    f010229f <vprintfmt+0x1ea>
f0102299:	52                   	push   %edx
f010229a:	68 4c 34 10 f0       	push   $0xf010344c
f010229f:	53                   	push   %ebx
f01022a0:	57                   	push   %edi
f01022a1:	e8 d4 01 00 00       	call   f010247a <printfmt>
f01022a6:	e9 66 01 00 00       	jmp    f0102411 <vprintfmt+0x35c>
f01022ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01022ae:	8d 50 04             	lea    0x4(%eax),%edx
f01022b1:	89 55 14             	mov    %edx,0x14(%ebp)
f01022b4:	8b 30                	mov    (%eax),%esi
f01022b6:	b8 3c 34 10 f0       	mov    $0xf010343c,%eax
f01022bb:	85 f6                	test   %esi,%esi
f01022bd:	0f 44 f0             	cmove  %eax,%esi
f01022c0:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f01022c4:	74 06                	je     f01022cc <vprintfmt+0x217>
f01022c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01022ca:	7f 05                	jg     f01022d1 <vprintfmt+0x21c>
f01022cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f01022cf:	eb 6a                	jmp    f010233b <vprintfmt+0x286>
f01022d1:	50                   	push   %eax
f01022d2:	50                   	push   %eax
f01022d3:	ff 75 d8             	pushl  -0x28(%ebp)
f01022d6:	56                   	push   %esi
f01022d7:	e8 5d 03 00 00       	call   f0102639 <strnlen>
f01022dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01022df:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
f01022e3:	83 c4 10             	add    $0x10,%esp
f01022e6:	29 c2                	sub    %eax,%edx
f01022e8:	89 d0                	mov    %edx,%eax
f01022ea:	85 c0                	test   %eax,%eax
f01022ec:	7e 1e                	jle    f010230c <vprintfmt+0x257>
f01022ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01022f1:	89 55 cc             	mov    %edx,-0x34(%ebp)
f01022f4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f01022f7:	50                   	push   %eax
f01022f8:	50                   	push   %eax
f01022f9:	53                   	push   %ebx
f01022fa:	51                   	push   %ecx
f01022fb:	ff d7                	call   *%edi
f01022fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102300:	83 c4 10             	add    $0x10,%esp
f0102303:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102306:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102309:	48                   	dec    %eax
f010230a:	eb de                	jmp    f01022ea <vprintfmt+0x235>
f010230c:	85 d2                	test   %edx,%edx
f010230e:	b8 00 00 00 00       	mov    $0x0,%eax
f0102313:	0f 49 c2             	cmovns %edx,%eax
f0102316:	29 c2                	sub    %eax,%edx
f0102318:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010231b:	eb af                	jmp    f01022cc <vprintfmt+0x217>
f010231d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0102321:	79 36                	jns    f0102359 <vprintfmt+0x2a4>
f0102323:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0102327:	74 2a                	je     f0102353 <vprintfmt+0x29e>
f0102329:	8d 42 e0             	lea    -0x20(%edx),%eax
f010232c:	83 f8 5e             	cmp    $0x5e,%eax
f010232f:	76 22                	jbe    f0102353 <vprintfmt+0x29e>
f0102331:	50                   	push   %eax
f0102332:	50                   	push   %eax
f0102333:	53                   	push   %ebx
f0102334:	6a 3f                	push   $0x3f
f0102336:	ff d7                	call   *%edi
f0102338:	83 c4 10             	add    $0x10,%esp
f010233b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010233e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
f0102341:	ff 45 d4             	incl   -0x2c(%ebp)
f0102344:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102347:	01 f0                	add    %esi,%eax
f0102349:	0f be 51 ff          	movsbl -0x1(%ecx),%edx
f010234d:	85 d2                	test   %edx,%edx
f010234f:	75 cc                	jne    f010231d <vprintfmt+0x268>
f0102351:	eb 22                	jmp    f0102375 <vprintfmt+0x2c0>
f0102353:	50                   	push   %eax
f0102354:	50                   	push   %eax
f0102355:	53                   	push   %ebx
f0102356:	52                   	push   %edx
f0102357:	eb dd                	jmp    f0102336 <vprintfmt+0x281>
f0102359:	ff 4d d8             	decl   -0x28(%ebp)
f010235c:	83 7d d8 ff          	cmpl   $0xffffffff,-0x28(%ebp)
f0102360:	75 c1                	jne    f0102323 <vprintfmt+0x26e>
f0102362:	eb 11                	jmp    f0102375 <vprintfmt+0x2c0>
f0102364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102367:	56                   	push   %esi
f0102368:	56                   	push   %esi
f0102369:	53                   	push   %ebx
f010236a:	6a 20                	push   $0x20
f010236c:	ff d7                	call   *%edi
f010236e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102371:	83 c4 10             	add    $0x10,%esp
f0102374:	48                   	dec    %eax
f0102375:	85 c0                	test   %eax,%eax
f0102377:	7f eb                	jg     f0102364 <vprintfmt+0x2af>
f0102379:	8b 75 e0             	mov    -0x20(%ebp),%esi
f010237c:	e9 46 fd ff ff       	jmp    f01020c7 <vprintfmt+0x12>
f0102381:	4a                   	dec    %edx
f0102382:	8b 45 14             	mov    0x14(%ebp),%eax
f0102385:	7e 0d                	jle    f0102394 <vprintfmt+0x2df>
f0102387:	8d 50 08             	lea    0x8(%eax),%edx
f010238a:	89 55 14             	mov    %edx,0x14(%ebp)
f010238d:	8b 50 04             	mov    0x4(%eax),%edx
f0102390:	8b 00                	mov    (%eax),%eax
f0102392:	eb 09                	jmp    f010239d <vprintfmt+0x2e8>
f0102394:	8d 50 04             	lea    0x4(%eax),%edx
f0102397:	89 55 14             	mov    %edx,0x14(%ebp)
f010239a:	8b 00                	mov    (%eax),%eax
f010239c:	99                   	cltd   
f010239d:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01023a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01023a4:	be 0a 00 00 00       	mov    $0xa,%esi
f01023a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01023ac:	79 45                	jns    f01023f3 <vprintfmt+0x33e>
f01023ae:	51                   	push   %ecx
f01023af:	51                   	push   %ecx
f01023b0:	53                   	push   %ebx
f01023b1:	6a 2d                	push   $0x2d
f01023b3:	ff d7                	call   *%edi
f01023b5:	f7 5d d8             	negl   -0x28(%ebp)
f01023b8:	83 55 dc 00          	adcl   $0x0,-0x24(%ebp)
f01023bc:	83 c4 10             	add    $0x10,%esp
f01023bf:	f7 5d dc             	negl   -0x24(%ebp)
f01023c2:	eb 2f                	jmp    f01023f3 <vprintfmt+0x33e>
f01023c4:	8d 45 14             	lea    0x14(%ebp),%eax
f01023c7:	be 0a 00 00 00       	mov    $0xa,%esi
f01023cc:	e8 c3 fc ff ff       	call   f0102094 <getuint>
f01023d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01023d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01023d7:	eb 1a                	jmp    f01023f3 <vprintfmt+0x33e>
f01023d9:	8d 45 14             	lea    0x14(%ebp),%eax
f01023dc:	be 08 00 00 00       	mov    $0x8,%esi
f01023e1:	e8 ae fc ff ff       	call   f0102094 <getuint>
f01023e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01023e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01023ec:	eb 05                	jmp    f01023f3 <vprintfmt+0x33e>
f01023ee:	be 10 00 00 00       	mov    $0x10,%esi
f01023f3:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
f01023f7:	51                   	push   %ecx
f01023f8:	89 f8                	mov    %edi,%eax
f01023fa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01023fd:	52                   	push   %edx
f01023fe:	ff 75 e4             	pushl  -0x1c(%ebp)
f0102401:	89 da                	mov    %ebx,%edx
f0102403:	56                   	push   %esi
f0102404:	e8 de fb ff ff       	call   f0101fe7 <printnum>
f0102409:	eb 06                	jmp    f0102411 <vprintfmt+0x35c>
f010240b:	52                   	push   %edx
f010240c:	52                   	push   %edx
f010240d:	53                   	push   %ebx
f010240e:	51                   	push   %ecx
f010240f:	ff d7                	call   *%edi
f0102411:	83 c4 10             	add    $0x10,%esp
f0102414:	e9 60 ff ff ff       	jmp    f0102379 <vprintfmt+0x2c4>
f0102419:	50                   	push   %eax
f010241a:	50                   	push   %eax
f010241b:	53                   	push   %ebx
f010241c:	6a 25                	push   $0x25
f010241e:	ff d7                	call   *%edi
f0102420:	83 c4 10             	add    $0x10,%esp
f0102423:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0102426:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102429:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010242d:	0f 84 46 ff ff ff    	je     f0102379 <vprintfmt+0x2c4>
f0102433:	ff 4d e0             	decl   -0x20(%ebp)
f0102436:	eb ee                	jmp    f0102426 <vprintfmt+0x371>
f0102438:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010243b:	5b                   	pop    %ebx
f010243c:	5e                   	pop    %esi
f010243d:	5f                   	pop    %edi
f010243e:	5d                   	pop    %ebp
f010243f:	c3                   	ret    

f0102440 <vcprintf>:
f0102440:	55                   	push   %ebp
f0102441:	89 e5                	mov    %esp,%ebp
f0102443:	83 ec 18             	sub    $0x18,%esp
f0102446:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102449:	ff 75 0c             	pushl  0xc(%ebp)
f010244c:	ff 75 08             	pushl  0x8(%ebp)
f010244f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f0102456:	50                   	push   %eax
f0102457:	68 78 20 10 f0       	push   $0xf0102078
f010245c:	e8 54 fc ff ff       	call   f01020b5 <vprintfmt>
f0102461:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102464:	c9                   	leave  
f0102465:	c3                   	ret    

f0102466 <cprintf>:
f0102466:	55                   	push   %ebp
f0102467:	89 e5                	mov    %esp,%ebp
f0102469:	83 ec 10             	sub    $0x10,%esp
f010246c:	8d 45 0c             	lea    0xc(%ebp),%eax
f010246f:	50                   	push   %eax
f0102470:	ff 75 08             	pushl  0x8(%ebp)
f0102473:	e8 c8 ff ff ff       	call   f0102440 <vcprintf>
f0102478:	c9                   	leave  
f0102479:	c3                   	ret    

f010247a <printfmt>:
f010247a:	55                   	push   %ebp
f010247b:	89 e5                	mov    %esp,%ebp
f010247d:	83 ec 08             	sub    $0x8,%esp
f0102480:	8d 45 14             	lea    0x14(%ebp),%eax
f0102483:	50                   	push   %eax
f0102484:	ff 75 10             	pushl  0x10(%ebp)
f0102487:	ff 75 0c             	pushl  0xc(%ebp)
f010248a:	ff 75 08             	pushl  0x8(%ebp)
f010248d:	e8 23 fc ff ff       	call   f01020b5 <vprintfmt>
f0102492:	83 c4 10             	add    $0x10,%esp
f0102495:	c9                   	leave  
f0102496:	c3                   	ret    

f0102497 <vsnprintf>:
f0102497:	55                   	push   %ebp
f0102498:	89 e5                	mov    %esp,%ebp
f010249a:	83 ec 18             	sub    $0x18,%esp
f010249d:	8b 45 08             	mov    0x8(%ebp),%eax
f01024a0:	8b 55 0c             	mov    0xc(%ebp),%edx
f01024a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
f01024aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01024ae:	85 c0                	test   %eax,%eax
f01024b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01024b3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01024b6:	74 26                	je     f01024de <vsnprintf+0x47>
f01024b8:	85 d2                	test   %edx,%edx
f01024ba:	7e 22                	jle    f01024de <vsnprintf+0x47>
f01024bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01024bf:	ff 75 14             	pushl  0x14(%ebp)
f01024c2:	ff 75 10             	pushl  0x10(%ebp)
f01024c5:	50                   	push   %eax
f01024c6:	68 5c 20 10 f0       	push   $0xf010205c
f01024cb:	e8 e5 fb ff ff       	call   f01020b5 <vprintfmt>
f01024d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01024d3:	83 c4 10             	add    $0x10,%esp
f01024d6:	c6 00 00             	movb   $0x0,(%eax)
f01024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01024dc:	eb 05                	jmp    f01024e3 <vsnprintf+0x4c>
f01024de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01024e3:	c9                   	leave  
f01024e4:	c3                   	ret    

f01024e5 <snprintf>:
f01024e5:	55                   	push   %ebp
f01024e6:	89 e5                	mov    %esp,%ebp
f01024e8:	83 ec 08             	sub    $0x8,%esp
f01024eb:	8d 45 14             	lea    0x14(%ebp),%eax
f01024ee:	50                   	push   %eax
f01024ef:	ff 75 10             	pushl  0x10(%ebp)
f01024f2:	ff 75 0c             	pushl  0xc(%ebp)
f01024f5:	ff 75 08             	pushl  0x8(%ebp)
f01024f8:	e8 9a ff ff ff       	call   f0102497 <vsnprintf>
f01024fd:	c9                   	leave  
f01024fe:	c3                   	ret    

f01024ff <readline>:
f01024ff:	55                   	push   %ebp
f0102500:	89 e5                	mov    %esp,%ebp
f0102502:	57                   	push   %edi
f0102503:	56                   	push   %esi
f0102504:	53                   	push   %ebx
f0102505:	83 ec 0c             	sub    $0xc,%esp
f0102508:	8b 45 08             	mov    0x8(%ebp),%eax
f010250b:	85 c0                	test   %eax,%eax
f010250d:	74 10                	je     f010251f <readline+0x20>
f010250f:	52                   	push   %edx
f0102510:	52                   	push   %edx
f0102511:	50                   	push   %eax
f0102512:	68 4c 34 10 f0       	push   $0xf010344c
f0102517:	e8 4a ff ff ff       	call   f0102466 <cprintf>
f010251c:	83 c4 10             	add    $0x10,%esp
f010251f:	83 ec 0c             	sub    $0xc,%esp
f0102522:	31 f6                	xor    %esi,%esi
f0102524:	6a 00                	push   $0x0
f0102526:	e8 6a e5 ff ff       	call   f0100a95 <iscons>
f010252b:	83 c4 10             	add    $0x10,%esp
f010252e:	89 c7                	mov    %eax,%edi
f0102530:	e8 4f e5 ff ff       	call   f0100a84 <getchar>
f0102535:	85 c0                	test   %eax,%eax
f0102537:	89 c3                	mov    %eax,%ebx
f0102539:	79 1d                	jns    f0102558 <readline+0x59>
f010253b:	31 f6                	xor    %esi,%esi
f010253d:	83 f8 f8             	cmp    $0xfffffff8,%eax
f0102540:	0f 84 81 00 00 00    	je     f01025c7 <readline+0xc8>
f0102546:	50                   	push   %eax
f0102547:	50                   	push   %eax
f0102548:	53                   	push   %ebx
f0102549:	68 4f 34 10 f0       	push   $0xf010344f
f010254e:	e8 13 ff ff ff       	call   f0102466 <cprintf>
f0102553:	83 c4 10             	add    $0x10,%esp
f0102556:	eb 6f                	jmp    f01025c7 <readline+0xc8>
f0102558:	83 f8 7f             	cmp    $0x7f,%eax
f010255b:	74 05                	je     f0102562 <readline+0x63>
f010255d:	83 f8 08             	cmp    $0x8,%eax
f0102560:	75 18                	jne    f010257a <readline+0x7b>
f0102562:	85 f6                	test   %esi,%esi
f0102564:	74 ca                	je     f0102530 <readline+0x31>
f0102566:	85 ff                	test   %edi,%edi
f0102568:	74 0d                	je     f0102577 <readline+0x78>
f010256a:	83 ec 0c             	sub    $0xc,%esp
f010256d:	6a 08                	push   $0x8
f010256f:	e8 04 e5 ff ff       	call   f0100a78 <cputchar>
f0102574:	83 c4 10             	add    $0x10,%esp
f0102577:	4e                   	dec    %esi
f0102578:	eb b6                	jmp    f0102530 <readline+0x31>
f010257a:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0102580:	7f 1e                	jg     f01025a0 <readline+0xa1>
f0102582:	83 f8 1f             	cmp    $0x1f,%eax
f0102585:	7e 19                	jle    f01025a0 <readline+0xa1>
f0102587:	85 ff                	test   %edi,%edi
f0102589:	74 0c                	je     f0102597 <readline+0x98>
f010258b:	83 ec 0c             	sub    $0xc,%esp
f010258e:	50                   	push   %eax
f010258f:	e8 e4 e4 ff ff       	call   f0100a78 <cputchar>
f0102594:	83 c4 10             	add    $0x10,%esp
f0102597:	88 9e c0 04 12 f0    	mov    %bl,-0xfedfb40(%esi)
f010259d:	46                   	inc    %esi
f010259e:	eb 90                	jmp    f0102530 <readline+0x31>
f01025a0:	83 fb 0d             	cmp    $0xd,%ebx
f01025a3:	74 05                	je     f01025aa <readline+0xab>
f01025a5:	83 fb 0a             	cmp    $0xa,%ebx
f01025a8:	75 86                	jne    f0102530 <readline+0x31>
f01025aa:	85 ff                	test   %edi,%edi
f01025ac:	74 0d                	je     f01025bb <readline+0xbc>
f01025ae:	83 ec 0c             	sub    $0xc,%esp
f01025b1:	6a 0a                	push   $0xa
f01025b3:	e8 c0 e4 ff ff       	call   f0100a78 <cputchar>
f01025b8:	83 c4 10             	add    $0x10,%esp
f01025bb:	c6 86 c0 04 12 f0 00 	movb   $0x0,-0xfedfb40(%esi)
f01025c2:	be c0 04 12 f0       	mov    $0xf01204c0,%esi
f01025c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01025ca:	89 f0                	mov    %esi,%eax
f01025cc:	5b                   	pop    %ebx
f01025cd:	5e                   	pop    %esi
f01025ce:	5f                   	pop    %edi
f01025cf:	5d                   	pop    %ebp
f01025d0:	c3                   	ret    

f01025d1 <_panic>:
f01025d1:	55                   	push   %ebp
f01025d2:	89 e5                	mov    %esp,%ebp
f01025d4:	56                   	push   %esi
f01025d5:	53                   	push   %ebx
f01025d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01025d9:	85 db                	test   %ebx,%ebx
f01025db:	74 2e                	je     f010260b <_panic+0x3a>
f01025dd:	fa                   	cli    
f01025de:	fc                   	cld    
f01025df:	50                   	push   %eax
f01025e0:	ff 75 0c             	pushl  0xc(%ebp)
f01025e3:	8d 75 14             	lea    0x14(%ebp),%esi
f01025e6:	ff 75 08             	pushl  0x8(%ebp)
f01025e9:	68 5f 34 10 f0       	push   $0xf010345f
f01025ee:	e8 73 fe ff ff       	call   f0102466 <cprintf>
f01025f3:	5a                   	pop    %edx
f01025f4:	59                   	pop    %ecx
f01025f5:	56                   	push   %esi
f01025f6:	53                   	push   %ebx
f01025f7:	e8 44 fe ff ff       	call   f0102440 <vcprintf>
f01025fc:	c7 04 24 09 2b 10 f0 	movl   $0xf0102b09,(%esp)
f0102603:	e8 5e fe ff ff       	call   f0102466 <cprintf>
f0102608:	83 c4 10             	add    $0x10,%esp
f010260b:	83 ec 0c             	sub    $0xc,%esp
f010260e:	6a 00                	push   $0x0
f0102610:	e8 64 e5 ff ff       	call   f0100b79 <monitor>
f0102615:	eb f1                	jmp    f0102608 <_panic+0x37>

f0102617 <strlen>:
f0102617:	55                   	push   %ebp
f0102618:	89 e5                	mov    %esp,%ebp
f010261a:	8b 55 08             	mov    0x8(%ebp),%edx
f010261d:	80 3a 00             	cmpb   $0x0,(%edx)
f0102620:	74 10                	je     f0102632 <strlen+0x1b>
f0102622:	b8 00 00 00 00       	mov    $0x0,%eax
f0102627:	83 c0 01             	add    $0x1,%eax
f010262a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010262e:	75 f7                	jne    f0102627 <strlen+0x10>
f0102630:	eb 05                	jmp    f0102637 <strlen+0x20>
f0102632:	b8 00 00 00 00       	mov    $0x0,%eax
f0102637:	5d                   	pop    %ebp
f0102638:	c3                   	ret    

f0102639 <strnlen>:
f0102639:	55                   	push   %ebp
f010263a:	89 e5                	mov    %esp,%ebp
f010263c:	53                   	push   %ebx
f010263d:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0102640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0102643:	85 c9                	test   %ecx,%ecx
f0102645:	74 1c                	je     f0102663 <strnlen+0x2a>
f0102647:	80 3b 00             	cmpb   $0x0,(%ebx)
f010264a:	74 1e                	je     f010266a <strnlen+0x31>
f010264c:	ba 01 00 00 00       	mov    $0x1,%edx
f0102651:	89 d0                	mov    %edx,%eax
f0102653:	39 ca                	cmp    %ecx,%edx
f0102655:	74 18                	je     f010266f <strnlen+0x36>
f0102657:	83 c2 01             	add    $0x1,%edx
f010265a:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
f010265f:	75 f0                	jne    f0102651 <strnlen+0x18>
f0102661:	eb 0c                	jmp    f010266f <strnlen+0x36>
f0102663:	b8 00 00 00 00       	mov    $0x0,%eax
f0102668:	eb 05                	jmp    f010266f <strnlen+0x36>
f010266a:	b8 00 00 00 00       	mov    $0x0,%eax
f010266f:	5b                   	pop    %ebx
f0102670:	5d                   	pop    %ebp
f0102671:	c3                   	ret    

f0102672 <strcpy>:
f0102672:	55                   	push   %ebp
f0102673:	89 e5                	mov    %esp,%ebp
f0102675:	53                   	push   %ebx
f0102676:	8b 45 08             	mov    0x8(%ebp),%eax
f0102679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010267c:	89 c2                	mov    %eax,%edx
f010267e:	83 c2 01             	add    $0x1,%edx
f0102681:	83 c1 01             	add    $0x1,%ecx
f0102684:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0102688:	88 5a ff             	mov    %bl,-0x1(%edx)
f010268b:	84 db                	test   %bl,%bl
f010268d:	75 ef                	jne    f010267e <strcpy+0xc>
f010268f:	5b                   	pop    %ebx
f0102690:	5d                   	pop    %ebp
f0102691:	c3                   	ret    

f0102692 <strcat>:
f0102692:	55                   	push   %ebp
f0102693:	89 e5                	mov    %esp,%ebp
f0102695:	53                   	push   %ebx
f0102696:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0102699:	53                   	push   %ebx
f010269a:	e8 78 ff ff ff       	call   f0102617 <strlen>
f010269f:	83 c4 04             	add    $0x4,%esp
f01026a2:	ff 75 0c             	pushl  0xc(%ebp)
f01026a5:	01 d8                	add    %ebx,%eax
f01026a7:	50                   	push   %eax
f01026a8:	e8 c5 ff ff ff       	call   f0102672 <strcpy>
f01026ad:	89 d8                	mov    %ebx,%eax
f01026af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01026b2:	c9                   	leave  
f01026b3:	c3                   	ret    

f01026b4 <strncpy>:
f01026b4:	55                   	push   %ebp
f01026b5:	89 e5                	mov    %esp,%ebp
f01026b7:	56                   	push   %esi
f01026b8:	53                   	push   %ebx
f01026b9:	8b 75 08             	mov    0x8(%ebp),%esi
f01026bc:	8b 55 0c             	mov    0xc(%ebp),%edx
f01026bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01026c2:	85 db                	test   %ebx,%ebx
f01026c4:	74 17                	je     f01026dd <strncpy+0x29>
f01026c6:	01 f3                	add    %esi,%ebx
f01026c8:	89 f1                	mov    %esi,%ecx
f01026ca:	83 c1 01             	add    $0x1,%ecx
f01026cd:	0f b6 02             	movzbl (%edx),%eax
f01026d0:	88 41 ff             	mov    %al,-0x1(%ecx)
f01026d3:	80 3a 01             	cmpb   $0x1,(%edx)
f01026d6:	83 da ff             	sbb    $0xffffffff,%edx
f01026d9:	39 d9                	cmp    %ebx,%ecx
f01026db:	75 ed                	jne    f01026ca <strncpy+0x16>
f01026dd:	89 f0                	mov    %esi,%eax
f01026df:	5b                   	pop    %ebx
f01026e0:	5e                   	pop    %esi
f01026e1:	5d                   	pop    %ebp
f01026e2:	c3                   	ret    

f01026e3 <strlcpy>:
f01026e3:	55                   	push   %ebp
f01026e4:	89 e5                	mov    %esp,%ebp
f01026e6:	56                   	push   %esi
f01026e7:	53                   	push   %ebx
f01026e8:	8b 75 08             	mov    0x8(%ebp),%esi
f01026eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01026ee:	8b 55 10             	mov    0x10(%ebp),%edx
f01026f1:	89 f0                	mov    %esi,%eax
f01026f3:	85 d2                	test   %edx,%edx
f01026f5:	74 35                	je     f010272c <strlcpy+0x49>
f01026f7:	89 d0                	mov    %edx,%eax
f01026f9:	83 e8 01             	sub    $0x1,%eax
f01026fc:	74 25                	je     f0102723 <strlcpy+0x40>
f01026fe:	0f b6 0b             	movzbl (%ebx),%ecx
f0102701:	84 c9                	test   %cl,%cl
f0102703:	74 22                	je     f0102727 <strlcpy+0x44>
f0102705:	8d 53 01             	lea    0x1(%ebx),%edx
f0102708:	01 c3                	add    %eax,%ebx
f010270a:	89 f0                	mov    %esi,%eax
f010270c:	83 c0 01             	add    $0x1,%eax
f010270f:	88 48 ff             	mov    %cl,-0x1(%eax)
f0102712:	39 da                	cmp    %ebx,%edx
f0102714:	74 13                	je     f0102729 <strlcpy+0x46>
f0102716:	83 c2 01             	add    $0x1,%edx
f0102719:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
f010271d:	84 c9                	test   %cl,%cl
f010271f:	75 eb                	jne    f010270c <strlcpy+0x29>
f0102721:	eb 06                	jmp    f0102729 <strlcpy+0x46>
f0102723:	89 f0                	mov    %esi,%eax
f0102725:	eb 02                	jmp    f0102729 <strlcpy+0x46>
f0102727:	89 f0                	mov    %esi,%eax
f0102729:	c6 00 00             	movb   $0x0,(%eax)
f010272c:	29 f0                	sub    %esi,%eax
f010272e:	5b                   	pop    %ebx
f010272f:	5e                   	pop    %esi
f0102730:	5d                   	pop    %ebp
f0102731:	c3                   	ret    

f0102732 <strcmp>:
f0102732:	55                   	push   %ebp
f0102733:	89 e5                	mov    %esp,%ebp
f0102735:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0102738:	8b 55 0c             	mov    0xc(%ebp),%edx
f010273b:	0f b6 01             	movzbl (%ecx),%eax
f010273e:	84 c0                	test   %al,%al
f0102740:	74 15                	je     f0102757 <strcmp+0x25>
f0102742:	3a 02                	cmp    (%edx),%al
f0102744:	75 11                	jne    f0102757 <strcmp+0x25>
f0102746:	83 c1 01             	add    $0x1,%ecx
f0102749:	83 c2 01             	add    $0x1,%edx
f010274c:	0f b6 01             	movzbl (%ecx),%eax
f010274f:	84 c0                	test   %al,%al
f0102751:	74 04                	je     f0102757 <strcmp+0x25>
f0102753:	3a 02                	cmp    (%edx),%al
f0102755:	74 ef                	je     f0102746 <strcmp+0x14>
f0102757:	0f b6 c0             	movzbl %al,%eax
f010275a:	0f b6 12             	movzbl (%edx),%edx
f010275d:	29 d0                	sub    %edx,%eax
f010275f:	5d                   	pop    %ebp
f0102760:	c3                   	ret    

f0102761 <strncmp>:
f0102761:	55                   	push   %ebp
f0102762:	89 e5                	mov    %esp,%ebp
f0102764:	56                   	push   %esi
f0102765:	53                   	push   %ebx
f0102766:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0102769:	8b 55 0c             	mov    0xc(%ebp),%edx
f010276c:	8b 75 10             	mov    0x10(%ebp),%esi
f010276f:	85 f6                	test   %esi,%esi
f0102771:	74 29                	je     f010279c <strncmp+0x3b>
f0102773:	0f b6 03             	movzbl (%ebx),%eax
f0102776:	84 c0                	test   %al,%al
f0102778:	74 30                	je     f01027aa <strncmp+0x49>
f010277a:	3a 02                	cmp    (%edx),%al
f010277c:	75 2c                	jne    f01027aa <strncmp+0x49>
f010277e:	8d 43 01             	lea    0x1(%ebx),%eax
f0102781:	01 de                	add    %ebx,%esi
f0102783:	89 c3                	mov    %eax,%ebx
f0102785:	83 c2 01             	add    $0x1,%edx
f0102788:	39 f0                	cmp    %esi,%eax
f010278a:	74 17                	je     f01027a3 <strncmp+0x42>
f010278c:	0f b6 08             	movzbl (%eax),%ecx
f010278f:	84 c9                	test   %cl,%cl
f0102791:	74 17                	je     f01027aa <strncmp+0x49>
f0102793:	83 c0 01             	add    $0x1,%eax
f0102796:	3a 0a                	cmp    (%edx),%cl
f0102798:	74 e9                	je     f0102783 <strncmp+0x22>
f010279a:	eb 0e                	jmp    f01027aa <strncmp+0x49>
f010279c:	b8 00 00 00 00       	mov    $0x0,%eax
f01027a1:	eb 0f                	jmp    f01027b2 <strncmp+0x51>
f01027a3:	b8 00 00 00 00       	mov    $0x0,%eax
f01027a8:	eb 08                	jmp    f01027b2 <strncmp+0x51>
f01027aa:	0f b6 03             	movzbl (%ebx),%eax
f01027ad:	0f b6 12             	movzbl (%edx),%edx
f01027b0:	29 d0                	sub    %edx,%eax
f01027b2:	5b                   	pop    %ebx
f01027b3:	5e                   	pop    %esi
f01027b4:	5d                   	pop    %ebp
f01027b5:	c3                   	ret    

f01027b6 <strchr>:
f01027b6:	55                   	push   %ebp
f01027b7:	89 e5                	mov    %esp,%ebp
f01027b9:	53                   	push   %ebx
f01027ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01027bd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01027c0:	0f b6 18             	movzbl (%eax),%ebx
f01027c3:	84 db                	test   %bl,%bl
f01027c5:	74 1d                	je     f01027e4 <strchr+0x2e>
f01027c7:	89 d1                	mov    %edx,%ecx
f01027c9:	38 d3                	cmp    %dl,%bl
f01027cb:	75 06                	jne    f01027d3 <strchr+0x1d>
f01027cd:	eb 1a                	jmp    f01027e9 <strchr+0x33>
f01027cf:	38 ca                	cmp    %cl,%dl
f01027d1:	74 16                	je     f01027e9 <strchr+0x33>
f01027d3:	83 c0 01             	add    $0x1,%eax
f01027d6:	0f b6 10             	movzbl (%eax),%edx
f01027d9:	84 d2                	test   %dl,%dl
f01027db:	75 f2                	jne    f01027cf <strchr+0x19>
f01027dd:	b8 00 00 00 00       	mov    $0x0,%eax
f01027e2:	eb 05                	jmp    f01027e9 <strchr+0x33>
f01027e4:	b8 00 00 00 00       	mov    $0x0,%eax
f01027e9:	5b                   	pop    %ebx
f01027ea:	5d                   	pop    %ebp
f01027eb:	c3                   	ret    

f01027ec <strfind>:
f01027ec:	55                   	push   %ebp
f01027ed:	89 e5                	mov    %esp,%ebp
f01027ef:	53                   	push   %ebx
f01027f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01027f3:	8b 55 0c             	mov    0xc(%ebp),%edx
f01027f6:	0f b6 18             	movzbl (%eax),%ebx
f01027f9:	84 db                	test   %bl,%bl
f01027fb:	74 14                	je     f0102811 <strfind+0x25>
f01027fd:	89 d1                	mov    %edx,%ecx
f01027ff:	38 d3                	cmp    %dl,%bl
f0102801:	74 0e                	je     f0102811 <strfind+0x25>
f0102803:	83 c0 01             	add    $0x1,%eax
f0102806:	0f b6 10             	movzbl (%eax),%edx
f0102809:	38 ca                	cmp    %cl,%dl
f010280b:	74 04                	je     f0102811 <strfind+0x25>
f010280d:	84 d2                	test   %dl,%dl
f010280f:	75 f2                	jne    f0102803 <strfind+0x17>
f0102811:	5b                   	pop    %ebx
f0102812:	5d                   	pop    %ebp
f0102813:	c3                   	ret    

f0102814 <memset>:
f0102814:	55                   	push   %ebp
f0102815:	89 e5                	mov    %esp,%ebp
f0102817:	57                   	push   %edi
f0102818:	56                   	push   %esi
f0102819:	53                   	push   %ebx
f010281a:	8b 7d 08             	mov    0x8(%ebp),%edi
f010281d:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0102820:	85 c9                	test   %ecx,%ecx
f0102822:	74 36                	je     f010285a <memset+0x46>
f0102824:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010282a:	75 28                	jne    f0102854 <memset+0x40>
f010282c:	f6 c1 03             	test   $0x3,%cl
f010282f:	75 23                	jne    f0102854 <memset+0x40>
f0102831:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
f0102835:	89 d3                	mov    %edx,%ebx
f0102837:	c1 e3 08             	shl    $0x8,%ebx
f010283a:	89 d6                	mov    %edx,%esi
f010283c:	c1 e6 18             	shl    $0x18,%esi
f010283f:	89 d0                	mov    %edx,%eax
f0102841:	c1 e0 10             	shl    $0x10,%eax
f0102844:	09 f0                	or     %esi,%eax
f0102846:	09 c2                	or     %eax,%edx
f0102848:	89 d0                	mov    %edx,%eax
f010284a:	09 d8                	or     %ebx,%eax
f010284c:	c1 e9 02             	shr    $0x2,%ecx
f010284f:	fc                   	cld    
f0102850:	f3 ab                	rep stos %eax,%es:(%edi)
f0102852:	eb 06                	jmp    f010285a <memset+0x46>
f0102854:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102857:	fc                   	cld    
f0102858:	f3 aa                	rep stos %al,%es:(%edi)
f010285a:	89 f8                	mov    %edi,%eax
f010285c:	5b                   	pop    %ebx
f010285d:	5e                   	pop    %esi
f010285e:	5f                   	pop    %edi
f010285f:	5d                   	pop    %ebp
f0102860:	c3                   	ret    

f0102861 <memmove>:
f0102861:	55                   	push   %ebp
f0102862:	89 e5                	mov    %esp,%ebp
f0102864:	57                   	push   %edi
f0102865:	56                   	push   %esi
f0102866:	8b 45 08             	mov    0x8(%ebp),%eax
f0102869:	8b 75 0c             	mov    0xc(%ebp),%esi
f010286c:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010286f:	39 c6                	cmp    %eax,%esi
f0102871:	73 35                	jae    f01028a8 <memmove+0x47>
f0102873:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0102876:	39 d0                	cmp    %edx,%eax
f0102878:	73 2e                	jae    f01028a8 <memmove+0x47>
f010287a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f010287d:	89 d6                	mov    %edx,%esi
f010287f:	09 fe                	or     %edi,%esi
f0102881:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0102887:	75 13                	jne    f010289c <memmove+0x3b>
f0102889:	f6 c1 03             	test   $0x3,%cl
f010288c:	75 0e                	jne    f010289c <memmove+0x3b>
f010288e:	83 ef 04             	sub    $0x4,%edi
f0102891:	8d 72 fc             	lea    -0x4(%edx),%esi
f0102894:	c1 e9 02             	shr    $0x2,%ecx
f0102897:	fd                   	std    
f0102898:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010289a:	eb 09                	jmp    f01028a5 <memmove+0x44>
f010289c:	83 ef 01             	sub    $0x1,%edi
f010289f:	8d 72 ff             	lea    -0x1(%edx),%esi
f01028a2:	fd                   	std    
f01028a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f01028a5:	fc                   	cld    
f01028a6:	eb 1d                	jmp    f01028c5 <memmove+0x64>
f01028a8:	89 f2                	mov    %esi,%edx
f01028aa:	09 c2                	or     %eax,%edx
f01028ac:	f6 c2 03             	test   $0x3,%dl
f01028af:	75 0f                	jne    f01028c0 <memmove+0x5f>
f01028b1:	f6 c1 03             	test   $0x3,%cl
f01028b4:	75 0a                	jne    f01028c0 <memmove+0x5f>
f01028b6:	c1 e9 02             	shr    $0x2,%ecx
f01028b9:	89 c7                	mov    %eax,%edi
f01028bb:	fc                   	cld    
f01028bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01028be:	eb 05                	jmp    f01028c5 <memmove+0x64>
f01028c0:	89 c7                	mov    %eax,%edi
f01028c2:	fc                   	cld    
f01028c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
f01028c5:	5e                   	pop    %esi
f01028c6:	5f                   	pop    %edi
f01028c7:	5d                   	pop    %ebp
f01028c8:	c3                   	ret    

f01028c9 <memcpy>:
f01028c9:	55                   	push   %ebp
f01028ca:	89 e5                	mov    %esp,%ebp
f01028cc:	ff 75 10             	pushl  0x10(%ebp)
f01028cf:	ff 75 0c             	pushl  0xc(%ebp)
f01028d2:	ff 75 08             	pushl  0x8(%ebp)
f01028d5:	e8 87 ff ff ff       	call   f0102861 <memmove>
f01028da:	c9                   	leave  
f01028db:	c3                   	ret    

f01028dc <memcmp>:
f01028dc:	55                   	push   %ebp
f01028dd:	89 e5                	mov    %esp,%ebp
f01028df:	57                   	push   %edi
f01028e0:	56                   	push   %esi
f01028e1:	53                   	push   %ebx
f01028e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01028e5:	8b 75 0c             	mov    0xc(%ebp),%esi
f01028e8:	8b 45 10             	mov    0x10(%ebp),%eax
f01028eb:	8d 78 ff             	lea    -0x1(%eax),%edi
f01028ee:	85 c0                	test   %eax,%eax
f01028f0:	74 36                	je     f0102928 <memcmp+0x4c>
f01028f2:	0f b6 13             	movzbl (%ebx),%edx
f01028f5:	0f b6 0e             	movzbl (%esi),%ecx
f01028f8:	38 ca                	cmp    %cl,%dl
f01028fa:	75 17                	jne    f0102913 <memcmp+0x37>
f01028fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0102901:	eb 1a                	jmp    f010291d <memcmp+0x41>
f0102903:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
f0102908:	83 c0 01             	add    $0x1,%eax
f010290b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
f010290f:	38 ca                	cmp    %cl,%dl
f0102911:	74 0a                	je     f010291d <memcmp+0x41>
f0102913:	0f b6 c2             	movzbl %dl,%eax
f0102916:	0f b6 c9             	movzbl %cl,%ecx
f0102919:	29 c8                	sub    %ecx,%eax
f010291b:	eb 10                	jmp    f010292d <memcmp+0x51>
f010291d:	39 f8                	cmp    %edi,%eax
f010291f:	75 e2                	jne    f0102903 <memcmp+0x27>
f0102921:	b8 00 00 00 00       	mov    $0x0,%eax
f0102926:	eb 05                	jmp    f010292d <memcmp+0x51>
f0102928:	b8 00 00 00 00       	mov    $0x0,%eax
f010292d:	5b                   	pop    %ebx
f010292e:	5e                   	pop    %esi
f010292f:	5f                   	pop    %edi
f0102930:	5d                   	pop    %ebp
f0102931:	c3                   	ret    

f0102932 <memfind>:
f0102932:	55                   	push   %ebp
f0102933:	89 e5                	mov    %esp,%ebp
f0102935:	53                   	push   %ebx
f0102936:	8b 55 08             	mov    0x8(%ebp),%edx
f0102939:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010293c:	89 d0                	mov    %edx,%eax
f010293e:	03 45 10             	add    0x10(%ebp),%eax
f0102941:	39 c2                	cmp    %eax,%edx
f0102943:	73 15                	jae    f010295a <memfind+0x28>
f0102945:	89 d9                	mov    %ebx,%ecx
f0102947:	38 1a                	cmp    %bl,(%edx)
f0102949:	75 06                	jne    f0102951 <memfind+0x1f>
f010294b:	eb 11                	jmp    f010295e <memfind+0x2c>
f010294d:	38 0a                	cmp    %cl,(%edx)
f010294f:	74 11                	je     f0102962 <memfind+0x30>
f0102951:	83 c2 01             	add    $0x1,%edx
f0102954:	39 c2                	cmp    %eax,%edx
f0102956:	75 f5                	jne    f010294d <memfind+0x1b>
f0102958:	eb 0a                	jmp    f0102964 <memfind+0x32>
f010295a:	89 d0                	mov    %edx,%eax
f010295c:	eb 06                	jmp    f0102964 <memfind+0x32>
f010295e:	89 d0                	mov    %edx,%eax
f0102960:	eb 02                	jmp    f0102964 <memfind+0x32>
f0102962:	89 d0                	mov    %edx,%eax
f0102964:	5b                   	pop    %ebx
f0102965:	5d                   	pop    %ebp
f0102966:	c3                   	ret    

f0102967 <strtol>:
f0102967:	55                   	push   %ebp
f0102968:	89 e5                	mov    %esp,%ebp
f010296a:	57                   	push   %edi
f010296b:	56                   	push   %esi
f010296c:	53                   	push   %ebx
f010296d:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0102970:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0102973:	0f b6 01             	movzbl (%ecx),%eax
f0102976:	3c 09                	cmp    $0x9,%al
f0102978:	74 04                	je     f010297e <strtol+0x17>
f010297a:	3c 20                	cmp    $0x20,%al
f010297c:	75 0e                	jne    f010298c <strtol+0x25>
f010297e:	83 c1 01             	add    $0x1,%ecx
f0102981:	0f b6 01             	movzbl (%ecx),%eax
f0102984:	3c 09                	cmp    $0x9,%al
f0102986:	74 f6                	je     f010297e <strtol+0x17>
f0102988:	3c 20                	cmp    $0x20,%al
f010298a:	74 f2                	je     f010297e <strtol+0x17>
f010298c:	3c 2b                	cmp    $0x2b,%al
f010298e:	75 0a                	jne    f010299a <strtol+0x33>
f0102990:	83 c1 01             	add    $0x1,%ecx
f0102993:	bf 00 00 00 00       	mov    $0x0,%edi
f0102998:	eb 10                	jmp    f01029aa <strtol+0x43>
f010299a:	bf 00 00 00 00       	mov    $0x0,%edi
f010299f:	3c 2d                	cmp    $0x2d,%al
f01029a1:	75 07                	jne    f01029aa <strtol+0x43>
f01029a3:	83 c1 01             	add    $0x1,%ecx
f01029a6:	66 bf 01 00          	mov    $0x1,%di
f01029aa:	85 db                	test   %ebx,%ebx
f01029ac:	0f 94 c0             	sete   %al
f01029af:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f01029b5:	75 19                	jne    f01029d0 <strtol+0x69>
f01029b7:	80 39 30             	cmpb   $0x30,(%ecx)
f01029ba:	75 14                	jne    f01029d0 <strtol+0x69>
f01029bc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01029c0:	0f 85 82 00 00 00    	jne    f0102a48 <strtol+0xe1>
f01029c6:	83 c1 02             	add    $0x2,%ecx
f01029c9:	bb 10 00 00 00       	mov    $0x10,%ebx
f01029ce:	eb 16                	jmp    f01029e6 <strtol+0x7f>
f01029d0:	84 c0                	test   %al,%al
f01029d2:	74 12                	je     f01029e6 <strtol+0x7f>
f01029d4:	bb 0a 00 00 00       	mov    $0xa,%ebx
f01029d9:	80 39 30             	cmpb   $0x30,(%ecx)
f01029dc:	75 08                	jne    f01029e6 <strtol+0x7f>
f01029de:	83 c1 01             	add    $0x1,%ecx
f01029e1:	bb 08 00 00 00       	mov    $0x8,%ebx
f01029e6:	b8 00 00 00 00       	mov    $0x0,%eax
f01029eb:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01029ee:	0f b6 11             	movzbl (%ecx),%edx
f01029f1:	8d 72 d0             	lea    -0x30(%edx),%esi
f01029f4:	89 f3                	mov    %esi,%ebx
f01029f6:	80 fb 09             	cmp    $0x9,%bl
f01029f9:	77 08                	ja     f0102a03 <strtol+0x9c>
f01029fb:	0f be d2             	movsbl %dl,%edx
f01029fe:	83 ea 30             	sub    $0x30,%edx
f0102a01:	eb 22                	jmp    f0102a25 <strtol+0xbe>
f0102a03:	8d 72 9f             	lea    -0x61(%edx),%esi
f0102a06:	89 f3                	mov    %esi,%ebx
f0102a08:	80 fb 19             	cmp    $0x19,%bl
f0102a0b:	77 08                	ja     f0102a15 <strtol+0xae>
f0102a0d:	0f be d2             	movsbl %dl,%edx
f0102a10:	83 ea 57             	sub    $0x57,%edx
f0102a13:	eb 10                	jmp    f0102a25 <strtol+0xbe>
f0102a15:	8d 72 bf             	lea    -0x41(%edx),%esi
f0102a18:	89 f3                	mov    %esi,%ebx
f0102a1a:	80 fb 19             	cmp    $0x19,%bl
f0102a1d:	77 16                	ja     f0102a35 <strtol+0xce>
f0102a1f:	0f be d2             	movsbl %dl,%edx
f0102a22:	83 ea 37             	sub    $0x37,%edx
f0102a25:	3b 55 10             	cmp    0x10(%ebp),%edx
f0102a28:	7d 0f                	jge    f0102a39 <strtol+0xd2>
f0102a2a:	83 c1 01             	add    $0x1,%ecx
f0102a2d:	0f af 45 10          	imul   0x10(%ebp),%eax
f0102a31:	01 d0                	add    %edx,%eax
f0102a33:	eb b9                	jmp    f01029ee <strtol+0x87>
f0102a35:	89 c2                	mov    %eax,%edx
f0102a37:	eb 02                	jmp    f0102a3b <strtol+0xd4>
f0102a39:	89 c2                	mov    %eax,%edx
f0102a3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0102a3f:	74 0d                	je     f0102a4e <strtol+0xe7>
f0102a41:	8b 75 0c             	mov    0xc(%ebp),%esi
f0102a44:	89 0e                	mov    %ecx,(%esi)
f0102a46:	eb 06                	jmp    f0102a4e <strtol+0xe7>
f0102a48:	84 c0                	test   %al,%al
f0102a4a:	75 92                	jne    f01029de <strtol+0x77>
f0102a4c:	eb 98                	jmp    f01029e6 <strtol+0x7f>
f0102a4e:	f7 da                	neg    %edx
f0102a50:	85 ff                	test   %edi,%edi
f0102a52:	0f 45 c2             	cmovne %edx,%eax
f0102a55:	5b                   	pop    %ebx
f0102a56:	5e                   	pop    %esi
f0102a57:	5f                   	pop    %edi
f0102a58:	5d                   	pop    %ebp
f0102a59:	c3                   	ret    
