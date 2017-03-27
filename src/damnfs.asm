
damnfs:     file format elf32-i386


Disassembly of section .text:

80001020 <_start>:
80001020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
80001026:	75 04                	jne    8000102c <args_exist>
80001028:	6a 00                	push   $0x0
8000102a:	6a 00                	push   $0x0

8000102c <args_exist>:
8000102c:	e8 5e 1a 00 00       	call   80002a8f <libmain>
80001031:	eb fe                	jmp    80001031 <args_exist+0x5>

80001033 <check_super>:
80001033:	55                   	push   %ebp
80001034:	89 e5                	mov    %esp,%ebp
80001036:	83 ec 08             	sub    $0x8,%esp
80001039:	a1 44 a4 00 80       	mov    0x8000a444,%eax
8000103e:	8b 10                	mov    (%eax),%edx
80001040:	81 fa ef cd ab 89    	cmp    $0x89abcdef,%edx
80001046:	74 14                	je     8000105c <check_super+0x29>
80001048:	83 ec 04             	sub    $0x4,%esp
8000104b:	68 00 46 00 80       	push   $0x80004600
80001050:	6a 14                	push   $0x14
80001052:	68 1d 46 00 80       	push   $0x8000461d
80001057:	e8 0f 2a 00 00       	call   80003a6b <_panic>
8000105c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80001060:	83 ec 0c             	sub    $0xc,%esp
80001063:	68 26 46 00 80       	push   $0x80004626
80001068:	e8 e2 27 00 00       	call   8000384f <cprintf>
8000106d:	83 c4 10             	add    $0x10,%esp
80001070:	c9                   	leave  
80001071:	c3                   	ret    

80001072 <block_is_free>:
80001072:	55                   	push   %ebp
80001073:	89 e5                	mov    %esp,%ebp
80001075:	53                   	push   %ebx
80001076:	8b 4d 08             	mov    0x8(%ebp),%ecx
80001079:	8b 15 44 a4 00 80    	mov    0x8000a444,%edx
8000107f:	85 d2                	test   %edx,%edx
80001081:	74 29                	je     800010ac <block_is_free+0x3a>
80001083:	0f b7 5a 06          	movzwl 0x6(%edx),%ebx
80001087:	b8 00 00 00 00       	mov    $0x0,%eax
8000108c:	66 39 cb             	cmp    %cx,%bx
8000108f:	76 20                	jbe    800010b1 <block_is_free+0x3f>
80001091:	89 c8                	mov    %ecx,%eax
80001093:	66 c1 e8 05          	shr    $0x5,%ax
80001097:	0f b7 c0             	movzwl %ax,%eax
8000109a:	8b 54 82 10          	mov    0x10(%edx,%eax,4),%edx
8000109e:	b8 01 00 00 00       	mov    $0x1,%eax
800010a3:	d3 e0                	shl    %cl,%eax
800010a5:	85 d0                	test   %edx,%eax
800010a7:	0f 94 c0             	sete   %al
800010aa:	eb 05                	jmp    800010b1 <block_is_free+0x3f>
800010ac:	b8 00 00 00 00       	mov    $0x0,%eax
800010b1:	5b                   	pop    %ebx
800010b2:	5d                   	pop    %ebp
800010b3:	c3                   	ret    

800010b4 <bc_pgfault>:
800010b4:	55                   	push   %ebp
800010b5:	89 e5                	mov    %esp,%ebp
800010b7:	56                   	push   %esi
800010b8:	53                   	push   %ebx
800010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
800010bc:	8b 01                	mov    (%ecx),%eax
800010be:	8d 90 00 00 00 f0    	lea    -0x10000000(%eax),%edx
800010c4:	89 d6                	mov    %edx,%esi
800010c6:	c1 ee 0c             	shr    $0xc,%esi
800010c9:	89 c3                	mov    %eax,%ebx
800010cb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
800010d1:	81 fa ff 1f 00 11    	cmp    $0x11001fff,%edx
800010d7:	76 1e                	jbe    800010f7 <bc_pgfault+0x43>
800010d9:	83 ec 08             	sub    $0x8,%esp
800010dc:	ff 71 04             	pushl  0x4(%ecx)
800010df:	50                   	push   %eax
800010e0:	ff 71 28             	pushl  0x28(%ecx)
800010e3:	68 f0 46 00 80       	push   $0x800046f0
800010e8:	68 76 02 00 00       	push   $0x276
800010ed:	68 1d 46 00 80       	push   $0x8000461d
800010f2:	e8 74 29 00 00       	call   80003a6b <_panic>
800010f7:	a1 44 a4 00 80       	mov    0x8000a444,%eax
800010fc:	85 c0                	test   %eax,%eax
800010fe:	74 20                	je     80001120 <bc_pgfault+0x6c>
80001100:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80001104:	0f b7 c0             	movzwl %ax,%eax
80001107:	39 c6                	cmp    %eax,%esi
80001109:	72 15                	jb     80001120 <bc_pgfault+0x6c>
8000110b:	56                   	push   %esi
8000110c:	68 20 47 00 80       	push   $0x80004720
80001111:	68 7a 02 00 00       	push   $0x27a
80001116:	68 1d 46 00 80       	push   $0x8000461d
8000111b:	e8 4b 29 00 00       	call   80003a6b <_panic>
80001120:	83 ec 04             	sub    $0x4,%esp
80001123:	68 07 0e 00 00       	push   $0xe07
80001128:	53                   	push   %ebx
80001129:	6a 00                	push   $0x0
8000112b:	e8 61 1a 00 00       	call   80002b91 <sys_page_alloc>
80001130:	83 c4 10             	add    $0x10,%esp
80001133:	85 c0                	test   %eax,%eax
80001135:	79 17                	jns    8000114e <bc_pgfault+0x9a>
80001137:	83 ec 04             	sub    $0x4,%esp
8000113a:	68 44 47 00 80       	push   $0x80004744
8000113f:	68 82 02 00 00       	push   $0x282
80001144:	68 1d 46 00 80       	push   $0x8000461d
80001149:	e8 1d 29 00 00       	call   80003a6b <_panic>
8000114e:	83 ec 04             	sub    $0x4,%esp
80001151:	6a 08                	push   $0x8
80001153:	53                   	push   %ebx
80001154:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
8000115b:	50                   	push   %eax
8000115c:	e8 fc 0d 00 00       	call   80001f5d <ide_read>
80001161:	83 c4 10             	add    $0x10,%esp
80001164:	85 c0                	test   %eax,%eax
80001166:	79 17                	jns    8000117f <bc_pgfault+0xcb>
80001168:	83 ec 04             	sub    $0x4,%esp
8000116b:	68 78 47 00 80       	push   $0x80004778
80001170:	68 86 02 00 00       	push   $0x286
80001175:	68 1d 46 00 80       	push   $0x8000461d
8000117a:	e8 ec 28 00 00       	call   80003a6b <_panic>
8000117f:	83 ec 0c             	sub    $0xc,%esp
80001182:	68 07 0e 00 00       	push   $0xe07
80001187:	53                   	push   %ebx
80001188:	6a 00                	push   $0x0
8000118a:	53                   	push   %ebx
8000118b:	6a 00                	push   $0x0
8000118d:	e8 42 1a 00 00       	call   80002bd4 <sys_page_map>
80001192:	83 c4 20             	add    $0x20,%esp
80001195:	85 c0                	test   %eax,%eax
80001197:	79 17                	jns    800011b0 <bc_pgfault+0xfc>
80001199:	83 ec 04             	sub    $0x4,%esp
8000119c:	68 a0 47 00 80       	push   $0x800047a0
800011a1:	68 8a 02 00 00       	push   $0x28a
800011a6:	68 1d 46 00 80       	push   $0x8000461d
800011ab:	e8 bb 28 00 00       	call   80003a6b <_panic>
800011b0:	83 3d 44 a4 00 80 00 	cmpl   $0x0,0x8000a444
800011b7:	74 28                	je     800011e1 <bc_pgfault+0x12d>
800011b9:	83 ec 0c             	sub    $0xc,%esp
800011bc:	0f b7 c6             	movzwl %si,%eax
800011bf:	50                   	push   %eax
800011c0:	e8 ad fe ff ff       	call   80001072 <block_is_free>
800011c5:	83 c4 10             	add    $0x10,%esp
800011c8:	84 c0                	test   %al,%al
800011ca:	74 15                	je     800011e1 <bc_pgfault+0x12d>
800011cc:	56                   	push   %esi
800011cd:	68 3a 46 00 80       	push   $0x8000463a
800011d2:	68 91 02 00 00       	push   $0x291
800011d7:	68 1d 46 00 80       	push   $0x8000461d
800011dc:	e8 8a 28 00 00       	call   80003a6b <_panic>
800011e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
800011e4:	5b                   	pop    %ebx
800011e5:	5e                   	pop    %esi
800011e6:	5d                   	pop    %ebp
800011e7:	c3                   	ret    

800011e8 <inode_is_free>:
800011e8:	55                   	push   %ebp
800011e9:	89 e5                	mov    %esp,%ebp
800011eb:	53                   	push   %ebx
800011ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
800011ef:	8b 15 44 a4 00 80    	mov    0x8000a444,%edx
800011f5:	85 d2                	test   %edx,%edx
800011f7:	74 2c                	je     80001225 <inode_is_free+0x3d>
800011f9:	0f b7 5a 04          	movzwl 0x4(%edx),%ebx
800011fd:	b8 00 00 00 00       	mov    $0x0,%eax
80001202:	66 39 cb             	cmp    %cx,%bx
80001205:	76 23                	jbe    8000122a <inode_is_free+0x42>
80001207:	89 c8                	mov    %ecx,%eax
80001209:	66 c1 e8 05          	shr    $0x5,%ax
8000120d:	0f b7 c0             	movzwl %ax,%eax
80001210:	8b 94 82 10 02 00 00 	mov    0x210(%edx,%eax,4),%edx
80001217:	b8 01 00 00 00       	mov    $0x1,%eax
8000121c:	d3 e0                	shl    %cl,%eax
8000121e:	85 d0                	test   %edx,%eax
80001220:	0f 94 c0             	sete   %al
80001223:	eb 05                	jmp    8000122a <inode_is_free+0x42>
80001225:	b8 00 00 00 00       	mov    $0x0,%eax
8000122a:	5b                   	pop    %ebx
8000122b:	5d                   	pop    %ebp
8000122c:	c3                   	ret    

8000122d <diskaddr>:
8000122d:	55                   	push   %ebp
8000122e:	89 e5                	mov    %esp,%ebp
80001230:	83 ec 08             	sub    $0x8,%esp
80001233:	8b 45 08             	mov    0x8(%ebp),%eax
80001236:	8b 15 44 a4 00 80    	mov    0x8000a444,%edx
8000123c:	85 d2                	test   %edx,%edx
8000123e:	74 20                	je     80001260 <diskaddr+0x33>
80001240:	0f b7 52 06          	movzwl 0x6(%edx),%edx
80001244:	0f b7 d2             	movzwl %dx,%edx
80001247:	39 c2                	cmp    %eax,%edx
80001249:	77 15                	ja     80001260 <diskaddr+0x33>
8000124b:	50                   	push   %eax
8000124c:	68 d4 47 00 80       	push   $0x800047d4
80001251:	68 55 02 00 00       	push   $0x255
80001256:	68 1d 46 00 80       	push   $0x8000461d
8000125b:	e8 0b 28 00 00       	call   80003a6b <_panic>
80001260:	05 00 00 01 00       	add    $0x10000,%eax
80001265:	c1 e0 0c             	shl    $0xc,%eax
80001268:	c9                   	leave  
80001269:	c3                   	ret    

8000126a <va_is_mapped>:
8000126a:	55                   	push   %ebp
8000126b:	89 e5                	mov    %esp,%ebp
8000126d:	8b 55 08             	mov    0x8(%ebp),%edx
80001270:	89 d0                	mov    %edx,%eax
80001272:	c1 e8 16             	shr    $0x16,%eax
80001275:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
8000127c:	b8 00 00 00 00       	mov    $0x0,%eax
80001281:	f6 c1 01             	test   $0x1,%cl
80001284:	74 0d                	je     80001293 <va_is_mapped+0x29>
80001286:	c1 ea 0c             	shr    $0xc,%edx
80001289:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
80001290:	83 e0 01             	and    $0x1,%eax
80001293:	83 e0 01             	and    $0x1,%eax
80001296:	5d                   	pop    %ebp
80001297:	c3                   	ret    

80001298 <va_is_dirty>:
80001298:	55                   	push   %ebp
80001299:	89 e5                	mov    %esp,%ebp
8000129b:	8b 45 08             	mov    0x8(%ebp),%eax
8000129e:	c1 e8 0c             	shr    $0xc,%eax
800012a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
800012a8:	c1 e8 06             	shr    $0x6,%eax
800012ab:	83 e0 01             	and    $0x1,%eax
800012ae:	5d                   	pop    %ebp
800012af:	c3                   	ret    

800012b0 <flush_block>:
800012b0:	55                   	push   %ebp
800012b1:	89 e5                	mov    %esp,%ebp
800012b3:	56                   	push   %esi
800012b4:	53                   	push   %ebx
800012b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
800012b8:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
800012be:	3d ff 1f 00 11       	cmp    $0x11001fff,%eax
800012c3:	76 15                	jbe    800012da <flush_block+0x2a>
800012c5:	53                   	push   %ebx
800012c6:	68 53 46 00 80       	push   $0x80004653
800012cb:	68 a1 02 00 00       	push   $0x2a1
800012d0:	68 1d 46 00 80       	push   $0x8000461d
800012d5:	e8 91 27 00 00       	call   80003a6b <_panic>
800012da:	83 ec 0c             	sub    $0xc,%esp
800012dd:	53                   	push   %ebx
800012de:	e8 87 ff ff ff       	call   8000126a <va_is_mapped>
800012e3:	83 c4 10             	add    $0x10,%esp
800012e6:	84 c0                	test   %al,%al
800012e8:	0f 84 88 00 00 00    	je     80001376 <flush_block+0xc6>
800012ee:	83 ec 0c             	sub    $0xc,%esp
800012f1:	53                   	push   %ebx
800012f2:	e8 a1 ff ff ff       	call   80001298 <va_is_dirty>
800012f7:	83 c4 10             	add    $0x10,%esp
800012fa:	84 c0                	test   %al,%al
800012fc:	74 78                	je     80001376 <flush_block+0xc6>
800012fe:	89 de                	mov    %ebx,%esi
80001300:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80001306:	83 ec 04             	sub    $0x4,%esp
80001309:	6a 08                	push   $0x8
8000130b:	56                   	push   %esi
8000130c:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
80001312:	c1 eb 0c             	shr    $0xc,%ebx
80001315:	c1 e3 03             	shl    $0x3,%ebx
80001318:	53                   	push   %ebx
80001319:	e8 d5 0c 00 00       	call   80001ff3 <ide_write>
8000131e:	83 c4 10             	add    $0x10,%esp
80001321:	85 c0                	test   %eax,%eax
80001323:	79 15                	jns    8000133a <flush_block+0x8a>
80001325:	50                   	push   %eax
80001326:	68 f8 47 00 80       	push   $0x800047f8
8000132b:	68 a8 02 00 00       	push   $0x2a8
80001330:	68 1d 46 00 80       	push   $0x8000461d
80001335:	e8 31 27 00 00       	call   80003a6b <_panic>
8000133a:	89 f0                	mov    %esi,%eax
8000133c:	c1 e8 0c             	shr    $0xc,%eax
8000133f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80001346:	83 ec 0c             	sub    $0xc,%esp
80001349:	25 07 0e 00 00       	and    $0xe07,%eax
8000134e:	50                   	push   %eax
8000134f:	56                   	push   %esi
80001350:	6a 00                	push   $0x0
80001352:	56                   	push   %esi
80001353:	6a 00                	push   $0x0
80001355:	e8 7a 18 00 00       	call   80002bd4 <sys_page_map>
8000135a:	83 c4 20             	add    $0x20,%esp
8000135d:	85 c0                	test   %eax,%eax
8000135f:	79 15                	jns    80001376 <flush_block+0xc6>
80001361:	50                   	push   %eax
80001362:	68 24 48 00 80       	push   $0x80004824
80001367:	68 ab 02 00 00       	push   $0x2ab
8000136c:	68 1d 46 00 80       	push   $0x8000461d
80001371:	e8 f5 26 00 00       	call   80003a6b <_panic>
80001376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80001379:	5b                   	pop    %ebx
8000137a:	5e                   	pop    %esi
8000137b:	5d                   	pop    %ebp
8000137c:	c3                   	ret    

8000137d <free_block>:
8000137d:	55                   	push   %ebp
8000137e:	89 e5                	mov    %esp,%ebp
80001380:	56                   	push   %esi
80001381:	53                   	push   %ebx
80001382:	8b 4d 08             	mov    0x8(%ebp),%ecx
80001385:	66 85 c9             	test   %cx,%cx
80001388:	75 14                	jne    8000139e <free_block+0x21>
8000138a:	83 ec 04             	sub    $0x4,%esp
8000138d:	68 6e 46 00 80       	push   $0x8000466e
80001392:	6a 32                	push   $0x32
80001394:	68 1d 46 00 80       	push   $0x8000461d
80001399:	e8 cd 26 00 00       	call   80003a6b <_panic>
8000139e:	8b 1d 44 a4 00 80    	mov    0x8000a444,%ebx
800013a4:	89 c8                	mov    %ecx,%eax
800013a6:	66 c1 e8 05          	shr    $0x5,%ax
800013aa:	0f b7 c0             	movzwl %ax,%eax
800013ad:	8d 34 83             	lea    (%ebx,%eax,4),%esi
800013b0:	8b 56 10             	mov    0x10(%esi),%edx
800013b3:	b8 01 00 00 00       	mov    $0x1,%eax
800013b8:	d3 e0                	shl    %cl,%eax
800013ba:	f7 d0                	not    %eax
800013bc:	21 d0                	and    %edx,%eax
800013be:	89 46 10             	mov    %eax,0x10(%esi)
800013c1:	83 ec 0c             	sub    $0xc,%esp
800013c4:	53                   	push   %ebx
800013c5:	e8 e6 fe ff ff       	call   800012b0 <flush_block>
800013ca:	83 c4 10             	add    $0x10,%esp
800013cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
800013d0:	5b                   	pop    %ebx
800013d1:	5e                   	pop    %esi
800013d2:	5d                   	pop    %ebp
800013d3:	c3                   	ret    

800013d4 <free_inode>:
800013d4:	55                   	push   %ebp
800013d5:	89 e5                	mov    %esp,%ebp
800013d7:	56                   	push   %esi
800013d8:	53                   	push   %ebx
800013d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
800013dc:	66 85 c9             	test   %cx,%cx
800013df:	75 14                	jne    800013f5 <free_inode+0x21>
800013e1:	83 ec 04             	sub    $0x4,%esp
800013e4:	68 89 46 00 80       	push   $0x80004689
800013e9:	6a 49                	push   $0x49
800013eb:	68 1d 46 00 80       	push   $0x8000461d
800013f0:	e8 76 26 00 00       	call   80003a6b <_panic>
800013f5:	8b 1d 44 a4 00 80    	mov    0x8000a444,%ebx
800013fb:	89 c8                	mov    %ecx,%eax
800013fd:	66 c1 e8 05          	shr    $0x5,%ax
80001401:	0f b7 c0             	movzwl %ax,%eax
80001404:	8d 34 83             	lea    (%ebx,%eax,4),%esi
80001407:	8b 96 10 02 00 00    	mov    0x210(%esi),%edx
8000140d:	b8 01 00 00 00       	mov    $0x1,%eax
80001412:	d3 e0                	shl    %cl,%eax
80001414:	f7 d0                	not    %eax
80001416:	21 d0                	and    %edx,%eax
80001418:	89 86 10 02 00 00    	mov    %eax,0x210(%esi)
8000141e:	83 ec 0c             	sub    $0xc,%esp
80001421:	53                   	push   %ebx
80001422:	e8 89 fe ff ff       	call   800012b0 <flush_block>
80001427:	83 c4 10             	add    $0x10,%esp
8000142a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000142d:	5b                   	pop    %ebx
8000142e:	5e                   	pop    %esi
8000142f:	5d                   	pop    %ebp
80001430:	c3                   	ret    

80001431 <alloc_block>:
80001431:	a1 44 a4 00 80       	mov    0x8000a444,%eax
80001436:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8000143a:	66 85 c0             	test   %ax,%ax
8000143d:	74 7b                	je     800014ba <alloc_block+0x89>
8000143f:	55                   	push   %ebp
80001440:	89 e5                	mov    %esp,%ebp
80001442:	57                   	push   %edi
80001443:	56                   	push   %esi
80001444:	53                   	push   %ebx
80001445:	83 ec 0c             	sub    $0xc,%esp
80001448:	bb 00 00 00 00       	mov    $0x0,%ebx
8000144d:	0f b7 c3             	movzwl %bx,%eax
80001450:	50                   	push   %eax
80001451:	e8 1c fc ff ff       	call   80001072 <block_is_free>
80001456:	83 c4 04             	add    $0x4,%esp
80001459:	84 c0                	test   %al,%al
8000145b:	74 43                	je     800014a0 <alloc_block+0x6f>
8000145d:	8b 35 44 a4 00 80    	mov    0x8000a444,%esi
80001463:	8d 43 1f             	lea    0x1f(%ebx),%eax
80001466:	85 db                	test   %ebx,%ebx
80001468:	0f 49 c3             	cmovns %ebx,%eax
8000146b:	c1 f8 05             	sar    $0x5,%eax
8000146e:	8d 3c 86             	lea    (%esi,%eax,4),%edi
80001471:	8b 47 10             	mov    0x10(%edi),%eax
80001474:	89 da                	mov    %ebx,%edx
80001476:	c1 fa 1f             	sar    $0x1f,%edx
80001479:	c1 ea 1b             	shr    $0x1b,%edx
8000147c:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
8000147f:	83 e1 1f             	and    $0x1f,%ecx
80001482:	29 d1                	sub    %edx,%ecx
80001484:	ba 01 00 00 00       	mov    $0x1,%edx
80001489:	d3 e2                	shl    %cl,%edx
8000148b:	09 d0                	or     %edx,%eax
8000148d:	89 47 10             	mov    %eax,0x10(%edi)
80001490:	83 ec 0c             	sub    $0xc,%esp
80001493:	56                   	push   %esi
80001494:	e8 17 fe ff ff       	call   800012b0 <flush_block>
80001499:	83 c4 10             	add    $0x10,%esp
8000149c:	89 d8                	mov    %ebx,%eax
8000149e:	eb 20                	jmp    800014c0 <alloc_block+0x8f>
800014a0:	83 c3 01             	add    $0x1,%ebx
800014a3:	a1 44 a4 00 80       	mov    0x8000a444,%eax
800014a8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
800014ac:	0f b7 c0             	movzwl %ax,%eax
800014af:	39 d8                	cmp    %ebx,%eax
800014b1:	7f 9a                	jg     8000144d <alloc_block+0x1c>
800014b3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
800014b8:	eb 06                	jmp    800014c0 <alloc_block+0x8f>
800014ba:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
800014bf:	c3                   	ret    
800014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
800014c3:	5b                   	pop    %ebx
800014c4:	5e                   	pop    %esi
800014c5:	5f                   	pop    %edi
800014c6:	5d                   	pop    %ebp
800014c7:	c3                   	ret    

800014c8 <alloc_inode>:
800014c8:	a1 44 a4 00 80       	mov    0x8000a444,%eax
800014cd:	0f b7 40 04          	movzwl 0x4(%eax),%eax
800014d1:	66 85 c0             	test   %ax,%ax
800014d4:	0f 84 81 00 00 00    	je     8000155b <alloc_inode+0x93>
800014da:	55                   	push   %ebp
800014db:	89 e5                	mov    %esp,%ebp
800014dd:	57                   	push   %edi
800014de:	56                   	push   %esi
800014df:	53                   	push   %ebx
800014e0:	83 ec 0c             	sub    $0xc,%esp
800014e3:	bb 00 00 00 00       	mov    $0x0,%ebx
800014e8:	0f b7 c3             	movzwl %bx,%eax
800014eb:	50                   	push   %eax
800014ec:	e8 f7 fc ff ff       	call   800011e8 <inode_is_free>
800014f1:	83 c4 04             	add    $0x4,%esp
800014f4:	84 c0                	test   %al,%al
800014f6:	74 49                	je     80001541 <alloc_inode+0x79>
800014f8:	8b 35 44 a4 00 80    	mov    0x8000a444,%esi
800014fe:	8d 43 1f             	lea    0x1f(%ebx),%eax
80001501:	85 db                	test   %ebx,%ebx
80001503:	0f 49 c3             	cmovns %ebx,%eax
80001506:	c1 f8 05             	sar    $0x5,%eax
80001509:	8d 3c 86             	lea    (%esi,%eax,4),%edi
8000150c:	8b 87 10 02 00 00    	mov    0x210(%edi),%eax
80001512:	89 da                	mov    %ebx,%edx
80001514:	c1 fa 1f             	sar    $0x1f,%edx
80001517:	c1 ea 1b             	shr    $0x1b,%edx
8000151a:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
8000151d:	83 e1 1f             	and    $0x1f,%ecx
80001520:	29 d1                	sub    %edx,%ecx
80001522:	ba 01 00 00 00       	mov    $0x1,%edx
80001527:	d3 e2                	shl    %cl,%edx
80001529:	09 d0                	or     %edx,%eax
8000152b:	89 87 10 02 00 00    	mov    %eax,0x210(%edi)
80001531:	83 ec 0c             	sub    $0xc,%esp
80001534:	56                   	push   %esi
80001535:	e8 76 fd ff ff       	call   800012b0 <flush_block>
8000153a:	83 c4 10             	add    $0x10,%esp
8000153d:	89 d8                	mov    %ebx,%eax
8000153f:	eb 20                	jmp    80001561 <alloc_inode+0x99>
80001541:	83 c3 01             	add    $0x1,%ebx
80001544:	a1 44 a4 00 80       	mov    0x8000a444,%eax
80001549:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8000154d:	0f b7 c0             	movzwl %ax,%eax
80001550:	39 d8                	cmp    %ebx,%eax
80001552:	7f 94                	jg     800014e8 <alloc_inode+0x20>
80001554:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
80001559:	eb 06                	jmp    80001561 <alloc_inode+0x99>
8000155b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
80001560:	c3                   	ret    
80001561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001564:	5b                   	pop    %ebx
80001565:	5e                   	pop    %esi
80001566:	5f                   	pop    %edi
80001567:	5d                   	pop    %ebp
80001568:	c3                   	ret    

80001569 <file_get_block>:
80001569:	55                   	push   %ebp
8000156a:	89 e5                	mov    %esp,%ebp
8000156c:	56                   	push   %esi
8000156d:	53                   	push   %ebx
8000156e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80001571:	8b 45 0c             	mov    0xc(%ebp),%eax
80001574:	66 83 f8 0c          	cmp    $0xc,%ax
80001578:	77 43                	ja     800015bd <file_get_block+0x54>
8000157a:	0f b7 c0             	movzwl %ax,%eax
8000157d:	8d 34 43             	lea    (%ebx,%eax,2),%esi
80001580:	66 83 7e 06 00       	cmpw   $0x0,0x6(%esi)
80001585:	75 12                	jne    80001599 <file_get_block+0x30>
80001587:	e8 a5 fe ff ff       	call   80001431 <alloc_block>
8000158c:	85 c0                	test   %eax,%eax
8000158e:	78 32                	js     800015c2 <file_get_block+0x59>
80001590:	66 89 46 06          	mov    %ax,0x6(%esi)
80001594:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
80001599:	83 ec 0c             	sub    $0xc,%esp
8000159c:	0f b7 46 06          	movzwl 0x6(%esi),%eax
800015a0:	50                   	push   %eax
800015a1:	e8 87 fc ff ff       	call   8000122d <diskaddr>
800015a6:	8b 55 10             	mov    0x10(%ebp),%edx
800015a9:	89 02                	mov    %eax,(%edx)
800015ab:	89 1c 24             	mov    %ebx,(%esp)
800015ae:	e8 fd fc ff ff       	call   800012b0 <flush_block>
800015b3:	83 c4 10             	add    $0x10,%esp
800015b6:	b8 00 00 00 00       	mov    $0x0,%eax
800015bb:	eb 05                	jmp    800015c2 <file_get_block+0x59>
800015bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
800015c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
800015c5:	5b                   	pop    %ebx
800015c6:	5e                   	pop    %esi
800015c7:	5d                   	pop    %ebp
800015c8:	c3                   	ret    

800015c9 <walk_path>:
800015c9:	55                   	push   %ebp
800015ca:	89 e5                	mov    %esp,%ebp
800015cc:	57                   	push   %edi
800015cd:	56                   	push   %esi
800015ce:	53                   	push   %ebx
800015cf:	83 ec 4c             	sub    $0x4c,%esp
800015d2:	89 c7                	mov    %eax,%edi
800015d4:	89 55 b0             	mov    %edx,-0x50(%ebp)
800015d7:	89 4d ac             	mov    %ecx,-0x54(%ebp)
800015da:	80 38 2f             	cmpb   $0x2f,(%eax)
800015dd:	0f 85 a0 01 00 00    	jne    80001783 <walk_path+0x1ba>
800015e3:	83 c7 01             	add    $0x1,%edi
800015e6:	80 3f 2f             	cmpb   $0x2f,(%edi)
800015e9:	74 f8                	je     800015e3 <walk_path+0x1a>
800015eb:	a1 40 a4 00 80       	mov    0x8000a440,%eax
800015f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
800015f3:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
800015f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
800015fa:	85 c0                	test   %eax,%eax
800015fc:	0f 84 96 01 00 00    	je     80001798 <walk_path+0x1cf>
80001602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80001608:	8b 45 ac             	mov    -0x54(%ebp),%eax
8000160b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80001611:	80 3f 00             	cmpb   $0x0,(%edi)
80001614:	0f 85 28 01 00 00    	jne    80001742 <walk_path+0x179>
8000161a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80001621:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
80001628:	e9 3f 01 00 00       	jmp    8000176c <walk_path+0x1a3>
8000162d:	83 c7 01             	add    $0x1,%edi
80001630:	0f b6 07             	movzbl (%edi),%eax
80001633:	84 c0                	test   %al,%al
80001635:	74 04                	je     8000163b <walk_path+0x72>
80001637:	3c 2f                	cmp    $0x2f,%al
80001639:	75 f2                	jne    8000162d <walk_path+0x64>
8000163b:	89 fb                	mov    %edi,%ebx
8000163d:	29 d3                	sub    %edx,%ebx
8000163f:	83 fb 0f             	cmp    $0xf,%ebx
80001642:	0f 8f 42 01 00 00    	jg     8000178a <walk_path+0x1c1>
80001648:	83 ec 04             	sub    $0x4,%esp
8000164b:	53                   	push   %ebx
8000164c:	52                   	push   %edx
8000164d:	56                   	push   %esi
8000164e:	e8 43 12 00 00       	call   80002896 <memmove>
80001653:	c6 44 1d d8 00       	movb   $0x0,-0x28(%ebp,%ebx,1)
80001658:	83 c4 10             	add    $0x10,%esp
8000165b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8000165e:	75 08                	jne    80001668 <walk_path+0x9f>
80001660:	83 c7 01             	add    $0x1,%edi
80001663:	80 3f 2f             	cmpb   $0x2f,(%edi)
80001666:	74 f8                	je     80001660 <walk_path+0x97>
80001668:	8b 45 c0             	mov    -0x40(%ebp),%eax
8000166b:	66 83 38 64          	cmpw   $0x64,(%eax)
8000166f:	0f 85 1c 01 00 00    	jne    80001791 <walk_path+0x1c8>
80001675:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80001679:	66 89 45 b6          	mov    %ax,-0x4a(%ebp)
8000167d:	66 85 c0             	test   %ax,%ax
80001680:	0f 84 81 00 00 00    	je     80001707 <walk_path+0x13e>
80001686:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
8000168d:	89 7d b8             	mov    %edi,-0x48(%ebp)
80001690:	83 ec 04             	sub    $0x4,%esp
80001693:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80001696:	50                   	push   %eax
80001697:	ff 75 bc             	pushl  -0x44(%ebp)
8000169a:	ff 75 c0             	pushl  -0x40(%ebp)
8000169d:	e8 c7 fe ff ff       	call   80001569 <file_get_block>
800016a2:	83 c4 10             	add    $0x10,%esp
800016a5:	85 c0                	test   %eax,%eax
800016a7:	79 10                	jns    800016b9 <walk_path+0xf0>
800016a9:	89 c3                	mov    %eax,%ebx
800016ab:	8b 7d b8             	mov    -0x48(%ebp),%edi
800016ae:	83 f8 f4             	cmp    $0xfffffff4,%eax
800016b1:	0f 85 87 00 00 00    	jne    8000173e <walk_path+0x175>
800016b7:	eb 53                	jmp    8000170c <walk_path+0x143>
800016b9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
800016bc:	8d bb f6 0f 00 00    	lea    0xff6(%ebx),%edi
800016c2:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
800016c5:	83 ec 08             	sub    $0x8,%esp
800016c8:	56                   	push   %esi
800016c9:	53                   	push   %ebx
800016ca:	e8 98 10 00 00       	call   80002767 <strcmp>
800016cf:	83 c4 10             	add    $0x10,%esp
800016d2:	85 c0                	test   %eax,%eax
800016d4:	75 1a                	jne    800016f0 <walk_path+0x127>
800016d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
800016d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
800016dc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
800016e0:	c1 e0 05             	shl    $0x5,%eax
800016e3:	03 05 40 a4 00 80    	add    0x8000a440,%eax
800016e9:	80 3f 00             	cmpb   $0x0,(%edi)
800016ec:	75 5b                	jne    80001749 <walk_path+0x180>
800016ee:	eb 76                	jmp    80001766 <walk_path+0x19d>
800016f0:	83 c3 12             	add    $0x12,%ebx
800016f3:	39 fb                	cmp    %edi,%ebx
800016f5:	75 cb                	jne    800016c2 <walk_path+0xf9>
800016f7:	83 45 bc 01          	addl   $0x1,-0x44(%ebp)
800016fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
800016fe:	66 39 45 b6          	cmp    %ax,-0x4a(%ebp)
80001702:	77 8c                	ja     80001690 <walk_path+0xc7>
80001704:	8b 7d b8             	mov    -0x48(%ebp),%edi
80001707:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
8000170c:	80 3f 00             	cmpb   $0x0,(%edi)
8000170f:	75 2d                	jne    8000173e <walk_path+0x175>
80001711:	8b 45 b0             	mov    -0x50(%ebp),%eax
80001714:	85 c0                	test   %eax,%eax
80001716:	74 05                	je     8000171d <walk_path+0x154>
80001718:	8b 4d c0             	mov    -0x40(%ebp),%ecx
8000171b:	89 08                	mov    %ecx,(%eax)
8000171d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80001721:	74 12                	je     80001735 <walk_path+0x16c>
80001723:	83 ec 08             	sub    $0x8,%esp
80001726:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001729:	50                   	push   %eax
8000172a:	ff 75 08             	pushl  0x8(%ebp)
8000172d:	e8 75 0f 00 00       	call   800026a7 <strcpy>
80001732:	83 c4 10             	add    $0x10,%esp
80001735:	8b 45 ac             	mov    -0x54(%ebp),%eax
80001738:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8000173e:	89 d8                	mov    %ebx,%eax
80001740:	eb 6d                	jmp    800017af <walk_path+0x1e6>
80001742:	89 fa                	mov    %edi,%edx
80001744:	8d 75 d8             	lea    -0x28(%ebp),%esi
80001747:	eb 05                	jmp    8000174e <walk_path+0x185>
80001749:	89 45 c0             	mov    %eax,-0x40(%ebp)
8000174c:	89 fa                	mov    %edi,%edx
8000174e:	0f b6 07             	movzbl (%edi),%eax
80001751:	84 c0                	test   %al,%al
80001753:	0f 84 e2 fe ff ff    	je     8000163b <walk_path+0x72>
80001759:	3c 2f                	cmp    $0x2f,%al
8000175b:	0f 85 cc fe ff ff    	jne    8000162d <walk_path+0x64>
80001761:	e9 d5 fe ff ff       	jmp    8000163b <walk_path+0x72>
80001766:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
8000176a:	74 08                	je     80001774 <walk_path+0x1ab>
8000176c:	8b 45 b0             	mov    -0x50(%ebp),%eax
8000176f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
80001772:	89 08                	mov    %ecx,(%eax)
80001774:	8b 45 ac             	mov    -0x54(%ebp),%eax
80001777:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
8000177a:	89 08                	mov    %ecx,(%eax)
8000177c:	b8 00 00 00 00       	mov    $0x0,%eax
80001781:	eb 2c                	jmp    800017af <walk_path+0x1e6>
80001783:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
80001788:	eb 25                	jmp    800017af <walk_path+0x1e6>
8000178a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
8000178f:	eb 1e                	jmp    800017af <walk_path+0x1e6>
80001791:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
80001796:	eb 17                	jmp    800017af <walk_path+0x1e6>
80001798:	8b 45 ac             	mov    -0x54(%ebp),%eax
8000179b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
800017a1:	80 3f 00             	cmpb   $0x0,(%edi)
800017a4:	75 9c                	jne    80001742 <walk_path+0x179>
800017a6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
800017ad:	eb c5                	jmp    80001774 <walk_path+0x1ab>
800017af:	8d 65 f4             	lea    -0xc(%ebp),%esp
800017b2:	5b                   	pop    %ebx
800017b3:	5e                   	pop    %esi
800017b4:	5f                   	pop    %edi
800017b5:	5d                   	pop    %ebp
800017b6:	c3                   	ret    

800017b7 <file_open>:
800017b7:	55                   	push   %ebp
800017b8:	89 e5                	mov    %esp,%ebp
800017ba:	83 ec 14             	sub    $0x14,%esp
800017bd:	6a 00                	push   $0x0
800017bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800017c2:	ba 00 00 00 00       	mov    $0x0,%edx
800017c7:	8b 45 08             	mov    0x8(%ebp),%eax
800017ca:	e8 fa fd ff ff       	call   800015c9 <walk_path>
800017cf:	c9                   	leave  
800017d0:	c3                   	ret    

800017d1 <file_read>:
800017d1:	55                   	push   %ebp
800017d2:	89 e5                	mov    %esp,%ebp
800017d4:	57                   	push   %edi
800017d5:	56                   	push   %esi
800017d6:	53                   	push   %ebx
800017d7:	83 ec 2c             	sub    $0x2c,%esp
800017da:	8b 7d 0c             	mov    0xc(%ebp),%edi
800017dd:	8b 75 14             	mov    0x14(%ebp),%esi
800017e0:	8b 45 08             	mov    0x8(%ebp),%eax
800017e3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
800017e7:	c1 e0 05             	shl    $0x5,%eax
800017ea:	03 05 40 a4 00 80    	add    0x8000a440,%eax
800017f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
800017f3:	0f b7 50 02          	movzwl 0x2(%eax),%edx
800017f7:	b8 00 00 00 00       	mov    $0x0,%eax
800017fc:	39 f2                	cmp    %esi,%edx
800017fe:	0f 8e 84 00 00 00    	jle    80001888 <file_read+0xb7>
80001804:	29 f2                	sub    %esi,%edx
80001806:	3b 55 10             	cmp    0x10(%ebp),%edx
80001809:	0f 47 55 10          	cmova  0x10(%ebp),%edx
8000180d:	89 55 cc             	mov    %edx,-0x34(%ebp)
80001810:	89 f3                	mov    %esi,%ebx
80001812:	8d 04 32             	lea    (%edx,%esi,1),%eax
80001815:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80001818:	39 c6                	cmp    %eax,%esi
8000181a:	73 69                	jae    80001885 <file_read+0xb4>
8000181c:	83 ec 04             	sub    $0x4,%esp
8000181f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80001822:	50                   	push   %eax
80001823:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80001829:	85 f6                	test   %esi,%esi
8000182b:	0f 49 c6             	cmovns %esi,%eax
8000182e:	c1 f8 0c             	sar    $0xc,%eax
80001831:	0f b7 c0             	movzwl %ax,%eax
80001834:	50                   	push   %eax
80001835:	ff 75 d0             	pushl  -0x30(%ebp)
80001838:	e8 2c fd ff ff       	call   80001569 <file_get_block>
8000183d:	83 c4 10             	add    $0x10,%esp
80001840:	85 c0                	test   %eax,%eax
80001842:	78 44                	js     80001888 <file_read+0xb7>
80001844:	89 f2                	mov    %esi,%edx
80001846:	c1 fa 1f             	sar    $0x1f,%edx
80001849:	c1 ea 14             	shr    $0x14,%edx
8000184c:	8d 04 16             	lea    (%esi,%edx,1),%eax
8000184f:	25 ff 0f 00 00       	and    $0xfff,%eax
80001854:	29 d0                	sub    %edx,%eax
80001856:	b9 00 10 00 00       	mov    $0x1000,%ecx
8000185b:	29 c1                	sub    %eax,%ecx
8000185d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80001860:	29 da                	sub    %ebx,%edx
80001862:	39 d1                	cmp    %edx,%ecx
80001864:	89 d3                	mov    %edx,%ebx
80001866:	0f 46 d9             	cmovbe %ecx,%ebx
80001869:	83 ec 04             	sub    $0x4,%esp
8000186c:	53                   	push   %ebx
8000186d:	03 45 e4             	add    -0x1c(%ebp),%eax
80001870:	50                   	push   %eax
80001871:	57                   	push   %edi
80001872:	e8 1f 10 00 00       	call   80002896 <memmove>
80001877:	01 de                	add    %ebx,%esi
80001879:	01 df                	add    %ebx,%edi
8000187b:	89 f3                	mov    %esi,%ebx
8000187d:	83 c4 10             	add    $0x10,%esp
80001880:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
80001883:	72 97                	jb     8000181c <file_read+0x4b>
80001885:	8b 45 cc             	mov    -0x34(%ebp),%eax
80001888:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000188b:	5b                   	pop    %ebx
8000188c:	5e                   	pop    %esi
8000188d:	5f                   	pop    %edi
8000188e:	5d                   	pop    %ebp
8000188f:	c3                   	ret    

80001890 <file_set_size>:
80001890:	55                   	push   %ebp
80001891:	89 e5                	mov    %esp,%ebp
80001893:	57                   	push   %edi
80001894:	56                   	push   %esi
80001895:	53                   	push   %ebx
80001896:	83 ec 1c             	sub    $0x1c,%esp
80001899:	8b 7d 08             	mov    0x8(%ebp),%edi
8000189c:	0f b7 47 10          	movzwl 0x10(%edi),%eax
800018a0:	c1 e0 05             	shl    $0x5,%eax
800018a3:	03 05 40 a4 00 80    	add    0x8000a440,%eax
800018a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
800018ac:	0f b7 40 02          	movzwl 0x2(%eax),%eax
800018b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
800018b3:	0f 8e 81 00 00 00    	jle    8000193a <file_set_size+0xaa>
800018b9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
800018bf:	c1 fa 0c             	sar    $0xc,%edx
800018c2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
800018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
800018c9:	05 fe 1f 00 00       	add    $0x1ffe,%eax
800018ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800018d1:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
800018d7:	0f 49 c1             	cmovns %ecx,%eax
800018da:	c1 f8 0c             	sar    $0xc,%eax
800018dd:	89 c6                	mov    %eax,%esi
800018df:	66 39 c2             	cmp    %ax,%dx
800018e2:	76 56                	jbe    8000193a <file_set_size+0xaa>
800018e4:	8b 15 40 a4 00 80    	mov    0x8000a440,%edx
800018ea:	0f b7 47 10          	movzwl 0x10(%edi),%eax
800018ee:	c1 e0 05             	shl    $0x5,%eax
800018f1:	66 83 fe 0c          	cmp    $0xc,%si
800018f5:	77 28                	ja     8000191f <file_set_size+0x8f>
800018f7:	0f b7 ce             	movzwl %si,%ecx
800018fa:	8d 1c 48             	lea    (%eax,%ecx,2),%ebx
800018fd:	01 d3                	add    %edx,%ebx
800018ff:	0f b7 43 06          	movzwl 0x6(%ebx),%eax
80001903:	66 85 c0             	test   %ax,%ax
80001906:	74 29                	je     80001931 <file_set_size+0xa1>
80001908:	83 ec 0c             	sub    $0xc,%esp
8000190b:	0f b7 c0             	movzwl %ax,%eax
8000190e:	50                   	push   %eax
8000190f:	e8 69 fa ff ff       	call   8000137d <free_block>
80001914:	66 c7 43 06 00 00    	movw   $0x0,0x6(%ebx)
8000191a:	83 c4 10             	add    $0x10,%esp
8000191d:	eb 12                	jmp    80001931 <file_set_size+0xa1>
8000191f:	83 ec 08             	sub    $0x8,%esp
80001922:	6a fd                	push   $0xfffffffd
80001924:	68 a4 46 00 80       	push   $0x800046a4
80001929:	e8 21 1f 00 00       	call   8000384f <cprintf>
8000192e:	83 c4 10             	add    $0x10,%esp
80001931:	83 c6 01             	add    $0x1,%esi
80001934:	66 39 75 e6          	cmp    %si,-0x1a(%ebp)
80001938:	77 aa                	ja     800018e4 <file_set_size+0x54>
8000193a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8000193d:	0f b7 4d 0c          	movzwl 0xc(%ebp),%ecx
80001941:	66 89 48 02          	mov    %cx,0x2(%eax)
80001945:	83 ec 0c             	sub    $0xc,%esp
80001948:	57                   	push   %edi
80001949:	e8 62 f9 ff ff       	call   800012b0 <flush_block>
8000194e:	b8 00 00 00 00       	mov    $0x0,%eax
80001953:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001956:	5b                   	pop    %ebx
80001957:	5e                   	pop    %esi
80001958:	5f                   	pop    %edi
80001959:	5d                   	pop    %ebp
8000195a:	c3                   	ret    

8000195b <file_remove>:
8000195b:	55                   	push   %ebp
8000195c:	89 e5                	mov    %esp,%ebp
8000195e:	83 ec 24             	sub    $0x24,%esp
80001961:	6a 00                	push   $0x0
80001963:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80001966:	ba 00 00 00 00       	mov    $0x0,%edx
8000196b:	8b 45 08             	mov    0x8(%ebp),%eax
8000196e:	e8 56 fc ff ff       	call   800015c9 <walk_path>
80001973:	89 c2                	mov    %eax,%edx
80001975:	83 c4 10             	add    $0x10,%esp
80001978:	85 d2                	test   %edx,%edx
8000197a:	78 4a                	js     800019c6 <file_remove+0x6b>
8000197c:	83 ec 08             	sub    $0x8,%esp
8000197f:	6a 00                	push   $0x0
80001981:	ff 75 f4             	pushl  -0xc(%ebp)
80001984:	e8 07 ff ff ff       	call   80001890 <file_set_size>
80001989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000198c:	c6 00 00             	movb   $0x0,(%eax)
8000198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80001992:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80001996:	c1 e0 05             	shl    $0x5,%eax
80001999:	03 05 40 a4 00 80    	add    0x8000a440,%eax
8000199f:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
800019a5:	83 c4 04             	add    $0x4,%esp
800019a8:	ff 75 f4             	pushl  -0xc(%ebp)
800019ab:	e8 00 f9 ff ff       	call   800012b0 <flush_block>
800019b0:	83 c4 04             	add    $0x4,%esp
800019b3:	ff 35 40 a4 00 80    	pushl  0x8000a440
800019b9:	e8 f2 f8 ff ff       	call   800012b0 <flush_block>
800019be:	83 c4 10             	add    $0x10,%esp
800019c1:	b8 00 00 00 00       	mov    $0x0,%eax
800019c6:	c9                   	leave  
800019c7:	c3                   	ret    

800019c8 <file_flush>:
800019c8:	55                   	push   %ebp
800019c9:	89 e5                	mov    %esp,%ebp
800019cb:	57                   	push   %edi
800019cc:	56                   	push   %esi
800019cd:	53                   	push   %ebx
800019ce:	83 ec 0c             	sub    $0xc,%esp
800019d1:	8b 7d 08             	mov    0x8(%ebp),%edi
800019d4:	0f b7 77 10          	movzwl 0x10(%edi),%esi
800019d8:	c1 e6 05             	shl    $0x5,%esi
800019db:	03 35 40 a4 00 80    	add    0x8000a440,%esi
800019e1:	0f b7 46 02          	movzwl 0x2(%esi),%eax
800019e5:	05 ff 0f 00 00       	add    $0xfff,%eax
800019ea:	3d ff 0f 00 00       	cmp    $0xfff,%eax
800019ef:	7e 4a                	jle    80001a3b <file_flush+0x73>
800019f1:	bb 00 00 00 00       	mov    $0x0,%ebx
800019f6:	66 83 fb 0c          	cmp    $0xc,%bx
800019fa:	77 2c                	ja     80001a28 <file_flush+0x60>
800019fc:	0f b7 c3             	movzwl %bx,%eax
800019ff:	8d 54 46 06          	lea    0x6(%esi,%eax,2),%edx
80001a03:	85 d2                	test   %edx,%edx
80001a05:	74 21                	je     80001a28 <file_flush+0x60>
80001a07:	0f b7 44 46 06       	movzwl 0x6(%esi,%eax,2),%eax
80001a0c:	66 85 c0             	test   %ax,%ax
80001a0f:	74 17                	je     80001a28 <file_flush+0x60>
80001a11:	83 ec 0c             	sub    $0xc,%esp
80001a14:	0f b7 c0             	movzwl %ax,%eax
80001a17:	50                   	push   %eax
80001a18:	e8 10 f8 ff ff       	call   8000122d <diskaddr>
80001a1d:	89 04 24             	mov    %eax,(%esp)
80001a20:	e8 8b f8 ff ff       	call   800012b0 <flush_block>
80001a25:	83 c4 10             	add    $0x10,%esp
80001a28:	83 c3 01             	add    $0x1,%ebx
80001a2b:	0f b7 46 02          	movzwl 0x2(%esi),%eax
80001a2f:	05 ff 0f 00 00       	add    $0xfff,%eax
80001a34:	c1 e8 0c             	shr    $0xc,%eax
80001a37:	39 d8                	cmp    %ebx,%eax
80001a39:	7f bb                	jg     800019f6 <file_flush+0x2e>
80001a3b:	83 ec 0c             	sub    $0xc,%esp
80001a3e:	56                   	push   %esi
80001a3f:	e8 6c f8 ff ff       	call   800012b0 <flush_block>
80001a44:	89 3c 24             	mov    %edi,(%esp)
80001a47:	e8 64 f8 ff ff       	call   800012b0 <flush_block>
80001a4c:	83 c4 10             	add    $0x10,%esp
80001a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001a52:	5b                   	pop    %ebx
80001a53:	5e                   	pop    %esi
80001a54:	5f                   	pop    %edi
80001a55:	5d                   	pop    %ebp
80001a56:	c3                   	ret    

80001a57 <file_create>:
80001a57:	55                   	push   %ebp
80001a58:	89 e5                	mov    %esp,%ebp
80001a5a:	57                   	push   %edi
80001a5b:	56                   	push   %esi
80001a5c:	53                   	push   %ebx
80001a5d:	83 ec 48             	sub    $0x48,%esp
80001a60:	8b 75 10             	mov    0x10(%ebp),%esi
80001a63:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001a66:	50                   	push   %eax
80001a67:	8d 4d d0             	lea    -0x30(%ebp),%ecx
80001a6a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
80001a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80001a70:	e8 54 fb ff ff       	call   800015c9 <walk_path>
80001a75:	83 c4 10             	add    $0x10,%esp
80001a78:	85 c0                	test   %eax,%eax
80001a7a:	0f 84 07 02 00 00    	je     80001c87 <file_create+0x230>
80001a80:	89 c3                	mov    %eax,%ebx
80001a82:	83 f8 f4             	cmp    $0xfffffff4,%eax
80001a85:	0f 85 3f 02 00 00    	jne    80001cca <file_create+0x273>
80001a8b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
80001a90:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80001a94:	0f 84 30 02 00 00    	je     80001cca <file_create+0x273>
80001a9a:	83 ec 0c             	sub    $0xc,%esp
80001a9d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001aa0:	50                   	push   %eax
80001aa1:	e8 a6 0b 00 00       	call   8000264c <strlen>
80001aa6:	83 c4 10             	add    $0x10,%esp
80001aa9:	83 f8 0f             	cmp    $0xf,%eax
80001aac:	0f 8f dc 01 00 00    	jg     80001c8e <file_create+0x237>
80001ab2:	83 ec 08             	sub    $0x8,%esp
80001ab5:	68 c1 46 00 80       	push   $0x800046c1
80001aba:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001abd:	50                   	push   %eax
80001abe:	e8 a4 0c 00 00       	call   80002767 <strcmp>
80001ac3:	83 c4 10             	add    $0x10,%esp
80001ac6:	85 c0                	test   %eax,%eax
80001ac8:	0f 84 c0 01 00 00    	je     80001c8e <file_create+0x237>
80001ace:	83 ec 08             	sub    $0x8,%esp
80001ad1:	68 c2 46 00 80       	push   $0x800046c2
80001ad6:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001ad9:	50                   	push   %eax
80001ada:	e8 88 0c 00 00       	call   80002767 <strcmp>
80001adf:	83 c4 10             	add    $0x10,%esp
80001ae2:	85 c0                	test   %eax,%eax
80001ae4:	0f 84 a4 01 00 00    	je     80001c8e <file_create+0x237>
80001aea:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
80001aee:	84 c0                	test   %al,%al
80001af0:	0f 84 9f 01 00 00    	je     80001c95 <file_create+0x23e>
80001af6:	3c 20                	cmp    $0x20,%al
80001af8:	0f 84 90 01 00 00    	je     80001c8e <file_create+0x237>
80001afe:	3c 2f                	cmp    $0x2f,%al
80001b00:	0f 84 88 01 00 00    	je     80001c8e <file_create+0x237>
80001b06:	8d 55 d8             	lea    -0x28(%ebp),%edx
80001b09:	eb 10                	jmp    80001b1b <file_create+0xc4>
80001b0b:	3c 20                	cmp    $0x20,%al
80001b0d:	0f 84 7b 01 00 00    	je     80001c8e <file_create+0x237>
80001b13:	3c 2f                	cmp    $0x2f,%al
80001b15:	0f 84 73 01 00 00    	je     80001c8e <file_create+0x237>
80001b1b:	83 c2 01             	add    $0x1,%edx
80001b1e:	0f b6 02             	movzbl (%edx),%eax
80001b21:	84 c0                	test   %al,%al
80001b23:	75 e6                	jne    80001b0b <file_create+0xb4>
80001b25:	e9 6b 01 00 00       	jmp    80001c95 <file_create+0x23e>
80001b2a:	83 ec 04             	sub    $0x4,%esp
80001b2d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80001b30:	50                   	push   %eax
80001b31:	57                   	push   %edi
80001b32:	53                   	push   %ebx
80001b33:	e8 31 fa ff ff       	call   80001569 <file_get_block>
80001b38:	83 c4 10             	add    $0x10,%esp
80001b3b:	85 c0                	test   %eax,%eax
80001b3d:	0f 88 81 01 00 00    	js     80001cc4 <file_create+0x26d>
80001b43:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80001b46:	80 39 00             	cmpb   $0x0,(%ecx)
80001b49:	74 12                	je     80001b5d <file_create+0x106>
80001b4b:	8d 41 12             	lea    0x12(%ecx),%eax
80001b4e:	81 c1 f6 0f 00 00    	add    $0xff6,%ecx
80001b54:	89 c2                	mov    %eax,%edx
80001b56:	80 38 00             	cmpb   $0x0,(%eax)
80001b59:	75 11                	jne    80001b6c <file_create+0x115>
80001b5b:	eb 02                	jmp    80001b5f <file_create+0x108>
80001b5d:	89 ca                	mov    %ecx,%edx
80001b5f:	89 55 d0             	mov    %edx,-0x30(%ebp)
80001b62:	66 83 43 02 12       	addw   $0x12,0x2(%ebx)
80001b67:	e9 47 01 00 00       	jmp    80001cb3 <file_create+0x25c>
80001b6c:	83 c0 12             	add    $0x12,%eax
80001b6f:	39 c8                	cmp    %ecx,%eax
80001b71:	75 e1                	jne    80001b54 <file_create+0xfd>
80001b73:	8d 47 01             	lea    0x1(%edi),%eax
80001b76:	83 c7 01             	add    $0x1,%edi
80001b79:	66 39 7d c4          	cmp    %di,-0x3c(%ebp)
80001b7d:	77 ab                	ja     80001b2a <file_create+0xd3>
80001b7f:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
80001b84:	66 83 43 02 12       	addw   $0x12,0x2(%ebx)
80001b89:	83 ec 04             	sub    $0x4,%esp
80001b8c:	8d 55 c8             	lea    -0x38(%ebp),%edx
80001b8f:	52                   	push   %edx
80001b90:	0f b7 c0             	movzwl %ax,%eax
80001b93:	50                   	push   %eax
80001b94:	53                   	push   %ebx
80001b95:	e8 cf f9 ff ff       	call   80001569 <file_get_block>
80001b9a:	83 c4 10             	add    $0x10,%esp
80001b9d:	85 c0                	test   %eax,%eax
80001b9f:	0f 88 23 01 00 00    	js     80001cc8 <file_create+0x271>
80001ba5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80001ba8:	89 45 d0             	mov    %eax,-0x30(%ebp)
80001bab:	e9 03 01 00 00       	jmp    80001cb3 <file_create+0x25c>
80001bb0:	66 83 fe 64          	cmp    $0x64,%si
80001bb4:	0f 85 80 00 00 00    	jne    80001c3a <file_create+0x1e3>
80001bba:	0f b7 c3             	movzwl %bx,%eax
80001bbd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80001bc0:	89 c7                	mov    %eax,%edi
80001bc2:	c1 e7 05             	shl    $0x5,%edi
80001bc5:	83 ec 04             	sub    $0x4,%esp
80001bc8:	8d 45 cc             	lea    -0x34(%ebp),%eax
80001bcb:	50                   	push   %eax
80001bcc:	6a 00                	push   $0x0
80001bce:	89 f8                	mov    %edi,%eax
80001bd0:	03 05 40 a4 00 80    	add    0x8000a440,%eax
80001bd6:	50                   	push   %eax
80001bd7:	e8 8d f9 ff ff       	call   80001569 <file_get_block>
80001bdc:	89 45 c0             	mov    %eax,-0x40(%ebp)
80001bdf:	83 c4 10             	add    $0x10,%esp
80001be2:	85 c0                	test   %eax,%eax
80001be4:	79 16                	jns    80001bfc <file_create+0x1a5>
80001be6:	83 ec 0c             	sub    $0xc,%esp
80001be9:	ff 75 c4             	pushl  -0x3c(%ebp)
80001bec:	e8 e3 f7 ff ff       	call   800013d4 <free_inode>
80001bf1:	83 c4 10             	add    $0x10,%esp
80001bf4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
80001bf7:	e9 ce 00 00 00       	jmp    80001cca <file_create+0x273>
80001bfc:	83 ec 08             	sub    $0x8,%esp
80001bff:	68 c1 46 00 80       	push   $0x800046c1
80001c04:	ff 75 cc             	pushl  -0x34(%ebp)
80001c07:	e8 9b 0a 00 00       	call   800026a7 <strcpy>
80001c0c:	83 c4 08             	add    $0x8,%esp
80001c0f:	68 c2 46 00 80       	push   $0x800046c2
80001c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80001c17:	83 c0 12             	add    $0x12,%eax
80001c1a:	50                   	push   %eax
80001c1b:	e8 87 0a 00 00       	call   800026a7 <strcpy>
80001c20:	8b 45 cc             	mov    -0x34(%ebp),%eax
80001c23:	66 89 58 22          	mov    %bx,0x22(%eax)
80001c27:	66 89 58 10          	mov    %bx,0x10(%eax)
80001c2b:	03 3d 40 a4 00 80    	add    0x8000a440,%edi
80001c31:	66 c7 47 02 24 00    	movw   $0x24,0x2(%edi)
80001c37:	83 c4 10             	add    $0x10,%esp
80001c3a:	83 ec 08             	sub    $0x8,%esp
80001c3d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80001c40:	50                   	push   %eax
80001c41:	ff 75 d0             	pushl  -0x30(%ebp)
80001c44:	e8 5e 0a 00 00       	call   800026a7 <strcpy>
80001c49:	8b 45 d0             	mov    -0x30(%ebp),%eax
80001c4c:	66 89 58 10          	mov    %bx,0x10(%eax)
80001c50:	0f b7 db             	movzwl %bx,%ebx
80001c53:	c1 e3 05             	shl    $0x5,%ebx
80001c56:	89 d8                	mov    %ebx,%eax
80001c58:	03 05 40 a4 00 80    	add    0x8000a440,%eax
80001c5e:	66 89 30             	mov    %si,(%eax)
80001c61:	83 c4 10             	add    $0x10,%esp
80001c64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80001c68:	74 08                	je     80001c72 <file_create+0x21b>
80001c6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80001c6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80001c70:	89 07                	mov    %eax,(%edi)
80001c72:	83 ec 0c             	sub    $0xc,%esp
80001c75:	ff 75 d0             	pushl  -0x30(%ebp)
80001c78:	e8 4b fd ff ff       	call   800019c8 <file_flush>
80001c7d:	83 c4 10             	add    $0x10,%esp
80001c80:	bb 00 00 00 00       	mov    $0x0,%ebx
80001c85:	eb 43                	jmp    80001cca <file_create+0x273>
80001c87:	bb f1 ff ff ff       	mov    $0xfffffff1,%ebx
80001c8c:	eb 3c                	jmp    80001cca <file_create+0x273>
80001c8e:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
80001c93:	eb 35                	jmp    80001cca <file_create+0x273>
80001c95:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80001c98:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
80001c9c:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
80001ca0:	bf 00 00 00 00       	mov    $0x0,%edi
80001ca5:	66 85 c0             	test   %ax,%ax
80001ca8:	0f 85 7c fe ff ff    	jne    80001b2a <file_create+0xd3>
80001cae:	e9 cc fe ff ff       	jmp    80001b7f <file_create+0x128>
80001cb3:	e8 10 f8 ff ff       	call   800014c8 <alloc_inode>
80001cb8:	89 c3                	mov    %eax,%ebx
80001cba:	85 c0                	test   %eax,%eax
80001cbc:	0f 89 ee fe ff ff    	jns    80001bb0 <file_create+0x159>
80001cc2:	eb 06                	jmp    80001cca <file_create+0x273>
80001cc4:	89 c3                	mov    %eax,%ebx
80001cc6:	eb 02                	jmp    80001cca <file_create+0x273>
80001cc8:	89 c3                	mov    %eax,%ebx
80001cca:	89 d8                	mov    %ebx,%eax
80001ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001ccf:	5b                   	pop    %ebx
80001cd0:	5e                   	pop    %esi
80001cd1:	5f                   	pop    %edi
80001cd2:	5d                   	pop    %ebp
80001cd3:	c3                   	ret    

80001cd4 <file_write>:
80001cd4:	55                   	push   %ebp
80001cd5:	89 e5                	mov    %esp,%ebp
80001cd7:	57                   	push   %edi
80001cd8:	56                   	push   %esi
80001cd9:	53                   	push   %ebx
80001cda:	83 ec 2c             	sub    $0x2c,%esp
80001cdd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80001ce0:	8b 75 14             	mov    0x14(%ebp),%esi
80001ce3:	8b 45 08             	mov    0x8(%ebp),%eax
80001ce6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80001cea:	c1 e0 05             	shl    $0x5,%eax
80001ced:	03 05 40 a4 00 80    	add    0x8000a440,%eax
80001cf3:	89 45 d0             	mov    %eax,-0x30(%ebp)
80001cf6:	89 f3                	mov    %esi,%ebx
80001cf8:	89 f1                	mov    %esi,%ecx
80001cfa:	03 4d 10             	add    0x10(%ebp),%ecx
80001cfd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80001d00:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80001d04:	39 c1                	cmp    %eax,%ecx
80001d06:	76 13                	jbe    80001d1b <file_write+0x47>
80001d08:	83 ec 08             	sub    $0x8,%esp
80001d0b:	51                   	push   %ecx
80001d0c:	ff 75 08             	pushl  0x8(%ebp)
80001d0f:	e8 7c fb ff ff       	call   80001890 <file_set_size>
80001d14:	83 c4 10             	add    $0x10,%esp
80001d17:	85 c0                	test   %eax,%eax
80001d19:	78 7f                	js     80001d9a <file_write+0xc6>
80001d1b:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
80001d1e:	73 69                	jae    80001d89 <file_write+0xb5>
80001d20:	83 ec 04             	sub    $0x4,%esp
80001d23:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80001d26:	50                   	push   %eax
80001d27:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80001d2d:	85 f6                	test   %esi,%esi
80001d2f:	0f 49 c6             	cmovns %esi,%eax
80001d32:	c1 f8 0c             	sar    $0xc,%eax
80001d35:	0f b7 c0             	movzwl %ax,%eax
80001d38:	50                   	push   %eax
80001d39:	ff 75 d0             	pushl  -0x30(%ebp)
80001d3c:	e8 28 f8 ff ff       	call   80001569 <file_get_block>
80001d41:	83 c4 10             	add    $0x10,%esp
80001d44:	85 c0                	test   %eax,%eax
80001d46:	78 52                	js     80001d9a <file_write+0xc6>
80001d48:	89 f2                	mov    %esi,%edx
80001d4a:	c1 fa 1f             	sar    $0x1f,%edx
80001d4d:	c1 ea 14             	shr    $0x14,%edx
80001d50:	8d 04 16             	lea    (%esi,%edx,1),%eax
80001d53:	25 ff 0f 00 00       	and    $0xfff,%eax
80001d58:	29 d0                	sub    %edx,%eax
80001d5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80001d5f:	29 c1                	sub    %eax,%ecx
80001d61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80001d64:	29 da                	sub    %ebx,%edx
80001d66:	39 d1                	cmp    %edx,%ecx
80001d68:	89 d3                	mov    %edx,%ebx
80001d6a:	0f 46 d9             	cmovbe %ecx,%ebx
80001d6d:	83 ec 04             	sub    $0x4,%esp
80001d70:	53                   	push   %ebx
80001d71:	57                   	push   %edi
80001d72:	03 45 e4             	add    -0x1c(%ebp),%eax
80001d75:	50                   	push   %eax
80001d76:	e8 1b 0b 00 00       	call   80002896 <memmove>
80001d7b:	01 de                	add    %ebx,%esi
80001d7d:	01 df                	add    %ebx,%edi
80001d7f:	89 f3                	mov    %esi,%ebx
80001d81:	83 c4 10             	add    $0x10,%esp
80001d84:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80001d87:	77 97                	ja     80001d20 <file_write+0x4c>
80001d89:	83 ec 0c             	sub    $0xc,%esp
80001d8c:	ff 75 08             	pushl  0x8(%ebp)
80001d8f:	e8 34 fc ff ff       	call   800019c8 <file_flush>
80001d94:	8b 45 10             	mov    0x10(%ebp),%eax
80001d97:	83 c4 10             	add    $0x10,%esp
80001d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80001d9d:	5b                   	pop    %ebx
80001d9e:	5e                   	pop    %esi
80001d9f:	5f                   	pop    %edi
80001da0:	5d                   	pop    %ebp
80001da1:	c3                   	ret    

80001da2 <fs_sync>:
80001da2:	a1 44 a4 00 80       	mov    0x8000a444,%eax
80001da7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80001dab:	0f b7 c0             	movzwl %ax,%eax
80001dae:	83 f8 01             	cmp    $0x1,%eax
80001db1:	7e 37                	jle    80001dea <fs_sync+0x48>
80001db3:	55                   	push   %ebp
80001db4:	89 e5                	mov    %esp,%ebp
80001db6:	53                   	push   %ebx
80001db7:	83 ec 04             	sub    $0x4,%esp
80001dba:	bb 01 00 00 00       	mov    $0x1,%ebx
80001dbf:	83 ec 0c             	sub    $0xc,%esp
80001dc2:	53                   	push   %ebx
80001dc3:	e8 65 f4 ff ff       	call   8000122d <diskaddr>
80001dc8:	89 04 24             	mov    %eax,(%esp)
80001dcb:	e8 e0 f4 ff ff       	call   800012b0 <flush_block>
80001dd0:	83 c3 01             	add    $0x1,%ebx
80001dd3:	a1 44 a4 00 80       	mov    0x8000a444,%eax
80001dd8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80001ddc:	0f b7 c0             	movzwl %ax,%eax
80001ddf:	83 c4 10             	add    $0x10,%esp
80001de2:	39 d8                	cmp    %ebx,%eax
80001de4:	7f d9                	jg     80001dbf <fs_sync+0x1d>
80001de6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001de9:	c9                   	leave  
80001dea:	f3 c3                	repz ret 

80001dec <bc_init>:
80001dec:	55                   	push   %ebp
80001ded:	89 e5                	mov    %esp,%ebp
80001def:	83 ec 24             	sub    $0x24,%esp
80001df2:	68 b4 10 00 80       	push   $0x800010b4
80001df7:	e8 20 14 00 00       	call   8000321c <set_pgfault_handler>
80001dfc:	83 c4 10             	add    $0x10,%esp
80001dff:	b8 00 00 00 00       	mov    $0x0,%eax
80001e04:	89 04 85 80 a4 00 80 	mov    %eax,-0x7fff5b80(,%eax,4)
80001e0b:	83 c0 01             	add    $0x1,%eax
80001e0e:	83 f8 64             	cmp    $0x64,%eax
80001e11:	75 f1                	jne    80001e04 <bc_init+0x18>
80001e13:	83 ec 0c             	sub    $0xc,%esp
80001e16:	6a 00                	push   $0x0
80001e18:	e8 10 f4 ff ff       	call   8000122d <diskaddr>
80001e1d:	83 c4 0c             	add    $0xc,%esp
80001e20:	6a 01                	push   $0x1
80001e22:	50                   	push   %eax
80001e23:	8d 45 f7             	lea    -0x9(%ebp),%eax
80001e26:	50                   	push   %eax
80001e27:	e8 6a 0a 00 00       	call   80002896 <memmove>
80001e2c:	83 c4 10             	add    $0x10,%esp
80001e2f:	c9                   	leave  
80001e30:	c3                   	ret    

80001e31 <fs_init>:
80001e31:	55                   	push   %ebp
80001e32:	89 e5                	mov    %esp,%ebp
80001e34:	83 ec 08             	sub    $0x8,%esp
80001e37:	e8 90 00 00 00       	call   80001ecc <ide_probe_disk1>
80001e3c:	84 c0                	test   %al,%al
80001e3e:	74 0f                	je     80001e4f <fs_init+0x1e>
80001e40:	83 ec 0c             	sub    $0xc,%esp
80001e43:	6a 01                	push   $0x1
80001e45:	e8 ea 00 00 00       	call   80001f34 <ide_set_disk>
80001e4a:	83 c4 10             	add    $0x10,%esp
80001e4d:	eb 0d                	jmp    80001e5c <fs_init+0x2b>
80001e4f:	83 ec 0c             	sub    $0xc,%esp
80001e52:	6a 00                	push   $0x0
80001e54:	e8 db 00 00 00       	call   80001f34 <ide_set_disk>
80001e59:	83 c4 10             	add    $0x10,%esp
80001e5c:	e8 8b ff ff ff       	call   80001dec <bc_init>
80001e61:	83 ec 0c             	sub    $0xc,%esp
80001e64:	6a 00                	push   $0x0
80001e66:	e8 c2 f3 ff ff       	call   8000122d <diskaddr>
80001e6b:	a3 44 a4 00 80       	mov    %eax,0x8000a444
80001e70:	8b 00                	mov    (%eax),%eax
80001e72:	c7 04 24 c4 46 00 80 	movl   $0x800046c4,(%esp)
80001e79:	e8 d1 19 00 00       	call   8000384f <cprintf>
80001e7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80001e85:	e8 a3 f3 ff ff       	call   8000122d <diskaddr>
80001e8a:	a3 40 a4 00 80       	mov    %eax,0x8000a440
80001e8f:	c7 04 24 dc 46 00 80 	movl   $0x800046dc,(%esp)
80001e96:	e8 b4 19 00 00       	call   8000384f <cprintf>
80001e9b:	83 c4 10             	add    $0x10,%esp
80001e9e:	c9                   	leave  
80001e9f:	c3                   	ret    

80001ea0 <ide_wait_ready>:
80001ea0:	55                   	push   %ebp
80001ea1:	89 e5                	mov    %esp,%ebp
80001ea3:	53                   	push   %ebx
80001ea4:	89 c1                	mov    %eax,%ecx
80001ea6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80001eab:	ec                   	in     (%dx),%al
80001eac:	89 c3                	mov    %eax,%ebx
80001eae:	83 e0 c0             	and    $0xffffffc0,%eax
80001eb1:	3c 40                	cmp    $0x40,%al
80001eb3:	75 f6                	jne    80001eab <ide_wait_ready+0xb>
80001eb5:	b8 00 00 00 00       	mov    $0x0,%eax
80001eba:	84 c9                	test   %cl,%cl
80001ebc:	74 0b                	je     80001ec9 <ide_wait_ready+0x29>
80001ebe:	f6 c3 21             	test   $0x21,%bl
80001ec1:	0f 95 c0             	setne  %al
80001ec4:	0f b6 c0             	movzbl %al,%eax
80001ec7:	f7 d8                	neg    %eax
80001ec9:	5b                   	pop    %ebx
80001eca:	5d                   	pop    %ebp
80001ecb:	c3                   	ret    

80001ecc <ide_probe_disk1>:
80001ecc:	55                   	push   %ebp
80001ecd:	89 e5                	mov    %esp,%ebp
80001ecf:	53                   	push   %ebx
80001ed0:	83 ec 04             	sub    $0x4,%esp
80001ed3:	b8 00 00 00 00       	mov    $0x0,%eax
80001ed8:	e8 c3 ff ff ff       	call   80001ea0 <ide_wait_ready>
80001edd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80001ee2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80001ee7:	ee                   	out    %al,(%dx)
80001ee8:	b2 f7                	mov    $0xf7,%dl
80001eea:	ec                   	in     (%dx),%al
80001eeb:	b9 01 00 00 00       	mov    $0x1,%ecx
80001ef0:	a8 a1                	test   $0xa1,%al
80001ef2:	75 0f                	jne    80001f03 <ide_probe_disk1+0x37>
80001ef4:	b1 00                	mov    $0x0,%cl
80001ef6:	eb 10                	jmp    80001f08 <ide_probe_disk1+0x3c>
80001ef8:	83 c1 01             	add    $0x1,%ecx
80001efb:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
80001f01:	74 05                	je     80001f08 <ide_probe_disk1+0x3c>
80001f03:	ec                   	in     (%dx),%al
80001f04:	a8 a1                	test   $0xa1,%al
80001f06:	75 f0                	jne    80001ef8 <ide_probe_disk1+0x2c>
80001f08:	ba f6 01 00 00       	mov    $0x1f6,%edx
80001f0d:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80001f12:	ee                   	out    %al,(%dx)
80001f13:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80001f19:	0f 9e c3             	setle  %bl
80001f1c:	83 ec 08             	sub    $0x8,%esp
80001f1f:	0f b6 c3             	movzbl %bl,%eax
80001f22:	50                   	push   %eax
80001f23:	68 44 48 00 80       	push   $0x80004844
80001f28:	e8 22 19 00 00       	call   8000384f <cprintf>
80001f2d:	89 d8                	mov    %ebx,%eax
80001f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80001f32:	c9                   	leave  
80001f33:	c3                   	ret    

80001f34 <ide_set_disk>:
80001f34:	55                   	push   %ebp
80001f35:	89 e5                	mov    %esp,%ebp
80001f37:	83 ec 08             	sub    $0x8,%esp
80001f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80001f3d:	83 f8 01             	cmp    $0x1,%eax
80001f40:	76 14                	jbe    80001f56 <ide_set_disk+0x22>
80001f42:	83 ec 04             	sub    $0x4,%esp
80001f45:	68 5f 48 00 80       	push   $0x8000485f
80001f4a:	6a 33                	push   $0x33
80001f4c:	68 6f 48 00 80       	push   $0x8000486f
80001f51:	e8 15 1b 00 00       	call   80003a6b <_panic>
80001f56:	a3 00 50 00 80       	mov    %eax,0x80005000
80001f5b:	c9                   	leave  
80001f5c:	c3                   	ret    

80001f5d <ide_read>:
80001f5d:	55                   	push   %ebp
80001f5e:	89 e5                	mov    %esp,%ebp
80001f60:	57                   	push   %edi
80001f61:	56                   	push   %esi
80001f62:	53                   	push   %ebx
80001f63:	8b 7d 08             	mov    0x8(%ebp),%edi
80001f66:	8b 75 0c             	mov    0xc(%ebp),%esi
80001f69:	8b 5d 10             	mov    0x10(%ebp),%ebx
80001f6c:	b8 00 00 00 00       	mov    $0x0,%eax
80001f71:	e8 2a ff ff ff       	call   80001ea0 <ide_wait_ready>
80001f76:	ba f2 01 00 00       	mov    $0x1f2,%edx
80001f7b:	89 d8                	mov    %ebx,%eax
80001f7d:	ee                   	out    %al,(%dx)
80001f7e:	b2 f3                	mov    $0xf3,%dl
80001f80:	89 f8                	mov    %edi,%eax
80001f82:	ee                   	out    %al,(%dx)
80001f83:	89 f8                	mov    %edi,%eax
80001f85:	c1 e8 08             	shr    $0x8,%eax
80001f88:	b2 f4                	mov    $0xf4,%dl
80001f8a:	ee                   	out    %al,(%dx)
80001f8b:	89 f8                	mov    %edi,%eax
80001f8d:	c1 e8 10             	shr    $0x10,%eax
80001f90:	b2 f5                	mov    $0xf5,%dl
80001f92:	ee                   	out    %al,(%dx)
80001f93:	0f b6 05 00 50 00 80 	movzbl 0x80005000,%eax
80001f9a:	83 e0 01             	and    $0x1,%eax
80001f9d:	c1 e0 04             	shl    $0x4,%eax
80001fa0:	83 c8 e0             	or     $0xffffffe0,%eax
80001fa3:	c1 ef 18             	shr    $0x18,%edi
80001fa6:	83 e7 0f             	and    $0xf,%edi
80001fa9:	09 f8                	or     %edi,%eax
80001fab:	b2 f6                	mov    $0xf6,%dl
80001fad:	ee                   	out    %al,(%dx)
80001fae:	b2 f7                	mov    $0xf7,%dl
80001fb0:	b8 20 00 00 00       	mov    $0x20,%eax
80001fb5:	ee                   	out    %al,(%dx)
80001fb6:	85 db                	test   %ebx,%ebx
80001fb8:	74 2f                	je     80001fe9 <ide_read+0x8c>
80001fba:	b8 01 00 00 00       	mov    $0x1,%eax
80001fbf:	e8 dc fe ff ff       	call   80001ea0 <ide_wait_ready>
80001fc4:	85 c0                	test   %eax,%eax
80001fc6:	78 26                	js     80001fee <ide_read+0x91>
80001fc8:	89 f7                	mov    %esi,%edi
80001fca:	b9 80 00 00 00       	mov    $0x80,%ecx
80001fcf:	ba f0 01 00 00       	mov    $0x1f0,%edx
80001fd4:	fc                   	cld    
80001fd5:	f2 6d                	repnz insl (%dx),%es:(%edi)
80001fd7:	81 c6 00 02 00 00    	add    $0x200,%esi
80001fdd:	83 eb 01             	sub    $0x1,%ebx
80001fe0:	75 d8                	jne    80001fba <ide_read+0x5d>
80001fe2:	b8 00 00 00 00       	mov    $0x0,%eax
80001fe7:	eb 05                	jmp    80001fee <ide_read+0x91>
80001fe9:	b8 00 00 00 00       	mov    $0x0,%eax
80001fee:	5b                   	pop    %ebx
80001fef:	5e                   	pop    %esi
80001ff0:	5f                   	pop    %edi
80001ff1:	5d                   	pop    %ebp
80001ff2:	c3                   	ret    

80001ff3 <ide_write>:
80001ff3:	55                   	push   %ebp
80001ff4:	89 e5                	mov    %esp,%ebp
80001ff6:	57                   	push   %edi
80001ff7:	56                   	push   %esi
80001ff8:	53                   	push   %ebx
80001ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80001ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80001fff:	8b 5d 10             	mov    0x10(%ebp),%ebx
80002002:	b8 00 00 00 00       	mov    $0x0,%eax
80002007:	e8 94 fe ff ff       	call   80001ea0 <ide_wait_ready>
8000200c:	ba f2 01 00 00       	mov    $0x1f2,%edx
80002011:	89 d8                	mov    %ebx,%eax
80002013:	ee                   	out    %al,(%dx)
80002014:	b2 f3                	mov    $0xf3,%dl
80002016:	89 f0                	mov    %esi,%eax
80002018:	ee                   	out    %al,(%dx)
80002019:	89 f0                	mov    %esi,%eax
8000201b:	c1 e8 08             	shr    $0x8,%eax
8000201e:	b2 f4                	mov    $0xf4,%dl
80002020:	ee                   	out    %al,(%dx)
80002021:	89 f0                	mov    %esi,%eax
80002023:	c1 e8 10             	shr    $0x10,%eax
80002026:	b2 f5                	mov    $0xf5,%dl
80002028:	ee                   	out    %al,(%dx)
80002029:	0f b6 05 00 50 00 80 	movzbl 0x80005000,%eax
80002030:	83 e0 01             	and    $0x1,%eax
80002033:	c1 e0 04             	shl    $0x4,%eax
80002036:	83 c8 e0             	or     $0xffffffe0,%eax
80002039:	c1 ee 18             	shr    $0x18,%esi
8000203c:	83 e6 0f             	and    $0xf,%esi
8000203f:	09 f0                	or     %esi,%eax
80002041:	b2 f6                	mov    $0xf6,%dl
80002043:	ee                   	out    %al,(%dx)
80002044:	b2 f7                	mov    $0xf7,%dl
80002046:	b8 30 00 00 00       	mov    $0x30,%eax
8000204b:	ee                   	out    %al,(%dx)
8000204c:	85 db                	test   %ebx,%ebx
8000204e:	74 2f                	je     8000207f <ide_write+0x8c>
80002050:	b8 01 00 00 00       	mov    $0x1,%eax
80002055:	e8 46 fe ff ff       	call   80001ea0 <ide_wait_ready>
8000205a:	85 c0                	test   %eax,%eax
8000205c:	78 26                	js     80002084 <ide_write+0x91>
8000205e:	89 fe                	mov    %edi,%esi
80002060:	b9 80 00 00 00       	mov    $0x80,%ecx
80002065:	ba f0 01 00 00       	mov    $0x1f0,%edx
8000206a:	fc                   	cld    
8000206b:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
8000206d:	81 c7 00 02 00 00    	add    $0x200,%edi
80002073:	83 eb 01             	sub    $0x1,%ebx
80002076:	75 d8                	jne    80002050 <ide_write+0x5d>
80002078:	b8 00 00 00 00       	mov    $0x0,%eax
8000207d:	eb 05                	jmp    80002084 <ide_write+0x91>
8000207f:	b8 00 00 00 00       	mov    $0x0,%eax
80002084:	5b                   	pop    %ebx
80002085:	5e                   	pop    %esi
80002086:	5f                   	pop    %edi
80002087:	5d                   	pop    %ebp
80002088:	c3                   	ret    

80002089 <serve_mkdir>:
80002089:	55                   	push   %ebp
8000208a:	89 e5                	mov    %esp,%ebp
8000208c:	53                   	push   %ebx
8000208d:	81 ec 88 00 00 00    	sub    $0x88,%esp
80002093:	68 80 00 00 00       	push   $0x80
80002098:	ff 75 0c             	pushl  0xc(%ebp)
8000209b:	8d 9d 78 ff ff ff    	lea    -0x88(%ebp),%ebx
800020a1:	53                   	push   %ebx
800020a2:	e8 ef 07 00 00       	call   80002896 <memmove>
800020a7:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
800020ab:	83 c4 0c             	add    $0xc,%esp
800020ae:	6a 64                	push   $0x64
800020b0:	6a 00                	push   $0x0
800020b2:	53                   	push   %ebx
800020b3:	e8 9f f9 ff ff       	call   80001a57 <file_create>
800020b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800020bb:	c9                   	leave  
800020bc:	c3                   	ret    

800020bd <serve_remove>:
800020bd:	55                   	push   %ebp
800020be:	89 e5                	mov    %esp,%ebp
800020c0:	53                   	push   %ebx
800020c1:	81 ec 88 00 00 00    	sub    $0x88,%esp
800020c7:	68 80 00 00 00       	push   $0x80
800020cc:	ff 75 0c             	pushl  0xc(%ebp)
800020cf:	8d 9d 78 ff ff ff    	lea    -0x88(%ebp),%ebx
800020d5:	53                   	push   %ebx
800020d6:	e8 bb 07 00 00       	call   80002896 <memmove>
800020db:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
800020df:	89 1c 24             	mov    %ebx,(%esp)
800020e2:	e8 74 f8 ff ff       	call   8000195b <file_remove>
800020e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800020ea:	c9                   	leave  
800020eb:	c3                   	ret    

800020ec <serve_sync>:
800020ec:	55                   	push   %ebp
800020ed:	89 e5                	mov    %esp,%ebp
800020ef:	83 ec 08             	sub    $0x8,%esp
800020f2:	e8 ab fc ff ff       	call   80001da2 <fs_sync>
800020f7:	b8 00 00 00 00       	mov    $0x0,%eax
800020fc:	c9                   	leave  
800020fd:	c3                   	ret    

800020fe <serve_init>:
800020fe:	55                   	push   %ebp
800020ff:	89 e5                	mov    %esp,%ebp
80002101:	ba 80 50 00 80       	mov    $0x80005080,%edx
80002106:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
8000210b:	b8 00 00 00 00       	mov    $0x0,%eax
80002110:	89 02                	mov    %eax,(%edx)
80002112:	89 4a 0c             	mov    %ecx,0xc(%edx)
80002115:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8000211b:	83 c0 01             	add    $0x1,%eax
8000211e:	83 c2 10             	add    $0x10,%edx
80002121:	3d 00 04 00 00       	cmp    $0x400,%eax
80002126:	75 e8                	jne    80002110 <serve_init+0x12>
80002128:	5d                   	pop    %ebp
80002129:	c3                   	ret    

8000212a <openfile_alloc>:
8000212a:	55                   	push   %ebp
8000212b:	89 e5                	mov    %esp,%ebp
8000212d:	56                   	push   %esi
8000212e:	53                   	push   %ebx
8000212f:	8b 75 08             	mov    0x8(%ebp),%esi
80002132:	bb 00 00 00 00       	mov    $0x0,%ebx
80002137:	83 ec 0c             	sub    $0xc,%esp
8000213a:	89 d8                	mov    %ebx,%eax
8000213c:	c1 e0 04             	shl    $0x4,%eax
8000213f:	ff b0 8c 50 00 80    	pushl  -0x7fffaf74(%eax)
80002145:	e8 97 10 00 00       	call   800031e1 <pageref>
8000214a:	83 c4 10             	add    $0x10,%esp
8000214d:	85 c0                	test   %eax,%eax
8000214f:	74 07                	je     80002158 <openfile_alloc+0x2e>
80002151:	83 f8 01             	cmp    $0x1,%eax
80002154:	74 22                	je     80002178 <openfile_alloc+0x4e>
80002156:	eb 53                	jmp    800021ab <openfile_alloc+0x81>
80002158:	83 ec 04             	sub    $0x4,%esp
8000215b:	6a 07                	push   $0x7
8000215d:	89 d8                	mov    %ebx,%eax
8000215f:	c1 e0 04             	shl    $0x4,%eax
80002162:	ff b0 8c 50 00 80    	pushl  -0x7fffaf74(%eax)
80002168:	6a 00                	push   $0x0
8000216a:	e8 22 0a 00 00       	call   80002b91 <sys_page_alloc>
8000216f:	89 c2                	mov    %eax,%edx
80002171:	83 c4 10             	add    $0x10,%esp
80002174:	85 d2                	test   %edx,%edx
80002176:	78 43                	js     800021bb <openfile_alloc+0x91>
80002178:	c1 e3 04             	shl    $0x4,%ebx
8000217b:	8d 83 80 50 00 80    	lea    -0x7fffaf80(%ebx),%eax
80002181:	81 83 80 50 00 80 00 	addl   $0x400,-0x7fffaf80(%ebx)
80002188:	04 00 00 
8000218b:	89 06                	mov    %eax,(%esi)
8000218d:	83 ec 04             	sub    $0x4,%esp
80002190:	68 00 10 00 00       	push   $0x1000
80002195:	6a 00                	push   $0x0
80002197:	ff b3 8c 50 00 80    	pushl  -0x7fffaf74(%ebx)
8000219d:	e8 a7 06 00 00       	call   80002849 <memset>
800021a2:	8b 06                	mov    (%esi),%eax
800021a4:	8b 00                	mov    (%eax),%eax
800021a6:	83 c4 10             	add    $0x10,%esp
800021a9:	eb 10                	jmp    800021bb <openfile_alloc+0x91>
800021ab:	83 c3 01             	add    $0x1,%ebx
800021ae:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
800021b4:	75 81                	jne    80002137 <openfile_alloc+0xd>
800021b6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
800021bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
800021be:	5b                   	pop    %ebx
800021bf:	5e                   	pop    %esi
800021c0:	5d                   	pop    %ebp
800021c1:	c3                   	ret    

800021c2 <openfile_lookup>:
800021c2:	55                   	push   %ebp
800021c3:	89 e5                	mov    %esp,%ebp
800021c5:	57                   	push   %edi
800021c6:	56                   	push   %esi
800021c7:	53                   	push   %ebx
800021c8:	83 ec 18             	sub    $0x18,%esp
800021cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
800021ce:	89 fb                	mov    %edi,%ebx
800021d0:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
800021d6:	89 de                	mov    %ebx,%esi
800021d8:	c1 e6 04             	shl    $0x4,%esi
800021db:	ff b6 8c 50 00 80    	pushl  -0x7fffaf74(%esi)
800021e1:	81 c6 80 50 00 80    	add    $0x80005080,%esi
800021e7:	e8 f5 0f 00 00       	call   800031e1 <pageref>
800021ec:	83 c4 10             	add    $0x10,%esp
800021ef:	83 f8 01             	cmp    $0x1,%eax
800021f2:	7e 17                	jle    8000220b <openfile_lookup+0x49>
800021f4:	c1 e3 04             	shl    $0x4,%ebx
800021f7:	39 bb 80 50 00 80    	cmp    %edi,-0x7fffaf80(%ebx)
800021fd:	75 13                	jne    80002212 <openfile_lookup+0x50>
800021ff:	8b 45 10             	mov    0x10(%ebp),%eax
80002202:	89 30                	mov    %esi,(%eax)
80002204:	b8 00 00 00 00       	mov    $0x0,%eax
80002209:	eb 0c                	jmp    80002217 <openfile_lookup+0x55>
8000220b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80002210:	eb 05                	jmp    80002217 <openfile_lookup+0x55>
80002212:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80002217:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000221a:	5b                   	pop    %ebx
8000221b:	5e                   	pop    %esi
8000221c:	5f                   	pop    %edi
8000221d:	5d                   	pop    %ebp
8000221e:	c3                   	ret    

8000221f <serve_set_size>:
8000221f:	55                   	push   %ebp
80002220:	89 e5                	mov    %esp,%ebp
80002222:	53                   	push   %ebx
80002223:	83 ec 18             	sub    $0x18,%esp
80002226:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80002229:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000222c:	50                   	push   %eax
8000222d:	ff 33                	pushl  (%ebx)
8000222f:	ff 75 08             	pushl  0x8(%ebp)
80002232:	e8 8b ff ff ff       	call   800021c2 <openfile_lookup>
80002237:	89 c2                	mov    %eax,%edx
80002239:	83 c4 10             	add    $0x10,%esp
8000223c:	85 d2                	test   %edx,%edx
8000223e:	78 14                	js     80002254 <serve_set_size+0x35>
80002240:	83 ec 08             	sub    $0x8,%esp
80002243:	ff 73 04             	pushl  0x4(%ebx)
80002246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002249:	ff 70 04             	pushl  0x4(%eax)
8000224c:	e8 3f f6 ff ff       	call   80001890 <file_set_size>
80002251:	83 c4 10             	add    $0x10,%esp
80002254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002257:	c9                   	leave  
80002258:	c3                   	ret    

80002259 <serve_read>:
80002259:	55                   	push   %ebp
8000225a:	89 e5                	mov    %esp,%ebp
8000225c:	53                   	push   %ebx
8000225d:	83 ec 18             	sub    $0x18,%esp
80002260:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80002263:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002266:	50                   	push   %eax
80002267:	ff 33                	pushl  (%ebx)
80002269:	ff 75 08             	pushl  0x8(%ebp)
8000226c:	e8 51 ff ff ff       	call   800021c2 <openfile_lookup>
80002271:	83 c4 10             	add    $0x10,%esp
80002274:	89 c2                	mov    %eax,%edx
80002276:	85 c0                	test   %eax,%eax
80002278:	78 29                	js     800022a3 <serve_read+0x4a>
8000227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000227d:	8b 50 0c             	mov    0xc(%eax),%edx
80002280:	ff 72 04             	pushl  0x4(%edx)
80002283:	ff 73 04             	pushl  0x4(%ebx)
80002286:	53                   	push   %ebx
80002287:	ff 70 04             	pushl  0x4(%eax)
8000228a:	e8 42 f5 ff ff       	call   800017d1 <file_read>
8000228f:	83 c4 10             	add    $0x10,%esp
80002292:	89 c2                	mov    %eax,%edx
80002294:	85 c0                	test   %eax,%eax
80002296:	78 0b                	js     800022a3 <serve_read+0x4a>
80002298:	8b 55 f4             	mov    -0xc(%ebp),%edx
8000229b:	8b 52 0c             	mov    0xc(%edx),%edx
8000229e:	01 42 04             	add    %eax,0x4(%edx)
800022a1:	89 c2                	mov    %eax,%edx
800022a3:	89 d0                	mov    %edx,%eax
800022a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800022a8:	c9                   	leave  
800022a9:	c3                   	ret    

800022aa <serve_write>:
800022aa:	55                   	push   %ebp
800022ab:	89 e5                	mov    %esp,%ebp
800022ad:	53                   	push   %ebx
800022ae:	83 ec 18             	sub    $0x18,%esp
800022b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
800022b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
800022b7:	50                   	push   %eax
800022b8:	ff 33                	pushl  (%ebx)
800022ba:	ff 75 08             	pushl  0x8(%ebp)
800022bd:	e8 00 ff ff ff       	call   800021c2 <openfile_lookup>
800022c2:	83 c4 10             	add    $0x10,%esp
800022c5:	89 c2                	mov    %eax,%edx
800022c7:	85 c0                	test   %eax,%eax
800022c9:	78 2c                	js     800022f7 <serve_write+0x4d>
800022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
800022ce:	8b 50 0c             	mov    0xc(%eax),%edx
800022d1:	ff 72 04             	pushl  0x4(%edx)
800022d4:	ff 73 04             	pushl  0x4(%ebx)
800022d7:	83 c3 08             	add    $0x8,%ebx
800022da:	53                   	push   %ebx
800022db:	ff 70 04             	pushl  0x4(%eax)
800022de:	e8 f1 f9 ff ff       	call   80001cd4 <file_write>
800022e3:	83 c4 10             	add    $0x10,%esp
800022e6:	89 c2                	mov    %eax,%edx
800022e8:	85 c0                	test   %eax,%eax
800022ea:	78 0b                	js     800022f7 <serve_write+0x4d>
800022ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
800022ef:	8b 52 0c             	mov    0xc(%edx),%edx
800022f2:	01 42 04             	add    %eax,0x4(%edx)
800022f5:	89 c2                	mov    %eax,%edx
800022f7:	89 d0                	mov    %edx,%eax
800022f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800022fc:	c9                   	leave  
800022fd:	c3                   	ret    

800022fe <serve_stat>:
800022fe:	55                   	push   %ebp
800022ff:	89 e5                	mov    %esp,%ebp
80002301:	56                   	push   %esi
80002302:	53                   	push   %ebx
80002303:	83 ec 14             	sub    $0x14,%esp
80002306:	8b 75 0c             	mov    0xc(%ebp),%esi
80002309:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000230c:	50                   	push   %eax
8000230d:	ff 36                	pushl  (%esi)
8000230f:	ff 75 08             	pushl  0x8(%ebp)
80002312:	e8 ab fe ff ff       	call   800021c2 <openfile_lookup>
80002317:	83 c4 10             	add    $0x10,%esp
8000231a:	85 c0                	test   %eax,%eax
8000231c:	78 56                	js     80002374 <serve_stat+0x76>
8000231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80002321:	8b 40 04             	mov    0x4(%eax),%eax
80002324:	85 c0                	test   %eax,%eax
80002326:	75 19                	jne    80002341 <serve_stat+0x43>
80002328:	8b 1d 40 a4 00 80    	mov    0x8000a440,%ebx
8000232e:	83 ec 08             	sub    $0x8,%esp
80002331:	68 75 48 00 80       	push   $0x80004875
80002336:	56                   	push   %esi
80002337:	e8 6b 03 00 00       	call   800026a7 <strcpy>
8000233c:	83 c4 10             	add    $0x10,%esp
8000233f:	eb 1a                	jmp    8000235b <serve_stat+0x5d>
80002341:	0f b7 58 10          	movzwl 0x10(%eax),%ebx
80002345:	c1 e3 05             	shl    $0x5,%ebx
80002348:	03 1d 40 a4 00 80    	add    0x8000a440,%ebx
8000234e:	83 ec 08             	sub    $0x8,%esp
80002351:	50                   	push   %eax
80002352:	56                   	push   %esi
80002353:	e8 4f 03 00 00       	call   800026a7 <strcpy>
80002358:	83 c4 10             	add    $0x10,%esp
8000235b:	0f b7 43 02          	movzwl 0x2(%ebx),%eax
8000235f:	89 46 10             	mov    %eax,0x10(%esi)
80002362:	66 83 3b 64          	cmpw   $0x64,(%ebx)
80002366:	0f 94 c0             	sete   %al
80002369:	0f b6 c0             	movzbl %al,%eax
8000236c:	89 46 14             	mov    %eax,0x14(%esi)
8000236f:	b8 00 00 00 00       	mov    $0x0,%eax
80002374:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002377:	5b                   	pop    %ebx
80002378:	5e                   	pop    %esi
80002379:	5d                   	pop    %ebp
8000237a:	c3                   	ret    

8000237b <serve_flush>:
8000237b:	55                   	push   %ebp
8000237c:	89 e5                	mov    %esp,%ebp
8000237e:	83 ec 1c             	sub    $0x1c,%esp
80002381:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002384:	50                   	push   %eax
80002385:	8b 45 0c             	mov    0xc(%ebp),%eax
80002388:	ff 30                	pushl  (%eax)
8000238a:	ff 75 08             	pushl  0x8(%ebp)
8000238d:	e8 30 fe ff ff       	call   800021c2 <openfile_lookup>
80002392:	83 c4 10             	add    $0x10,%esp
80002395:	85 c0                	test   %eax,%eax
80002397:	78 36                	js     800023cf <serve_flush+0x54>
80002399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000239c:	8b 40 04             	mov    0x4(%eax),%eax
8000239f:	66 83 78 10 00       	cmpw   $0x0,0x10(%eax)
800023a4:	74 13                	je     800023b9 <serve_flush+0x3e>
800023a6:	83 ec 0c             	sub    $0xc,%esp
800023a9:	50                   	push   %eax
800023aa:	e8 19 f6 ff ff       	call   800019c8 <file_flush>
800023af:	83 c4 10             	add    $0x10,%esp
800023b2:	b8 00 00 00 00       	mov    $0x0,%eax
800023b7:	eb 16                	jmp    800023cf <serve_flush+0x54>
800023b9:	83 ec 0c             	sub    $0xc,%esp
800023bc:	ff 35 40 a4 00 80    	pushl  0x8000a440
800023c2:	e8 01 f6 ff ff       	call   800019c8 <file_flush>
800023c7:	83 c4 10             	add    $0x10,%esp
800023ca:	b8 00 00 00 00       	mov    $0x0,%eax
800023cf:	c9                   	leave  
800023d0:	c3                   	ret    

800023d1 <serve_open>:
800023d1:	55                   	push   %ebp
800023d2:	89 e5                	mov    %esp,%ebp
800023d4:	53                   	push   %ebx
800023d5:	81 ec 98 00 00 00    	sub    $0x98,%esp
800023db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
800023de:	68 80 00 00 00       	push   $0x80
800023e3:	53                   	push   %ebx
800023e4:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
800023ea:	50                   	push   %eax
800023eb:	e8 a6 04 00 00       	call   80002896 <memmove>
800023f0:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
800023f4:	83 c4 10             	add    $0x10,%esp
800023f7:	f6 83 81 00 00 00 08 	testb  $0x8,0x81(%ebx)
800023fe:	74 26                	je     80002426 <serve_open+0x55>
80002400:	83 ec 04             	sub    $0x4,%esp
80002403:	6a 64                	push   $0x64
80002405:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
8000240b:	50                   	push   %eax
8000240c:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
80002412:	50                   	push   %eax
80002413:	e8 3f f6 ff ff       	call   80001a57 <file_create>
80002418:	c1 e8 1f             	shr    $0x1f,%eax
8000241b:	83 c4 10             	add    $0x10,%esp
8000241e:	85 c0                	test   %eax,%eax
80002420:	0f 85 16 01 00 00    	jne    8000253c <serve_open+0x16b>
80002426:	83 ec 0c             	sub    $0xc,%esp
80002429:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8000242f:	50                   	push   %eax
80002430:	e8 f5 fc ff ff       	call   8000212a <openfile_alloc>
80002435:	83 c4 10             	add    $0x10,%esp
80002438:	85 c0                	test   %eax,%eax
8000243a:	0f 88 fc 00 00 00    	js     8000253c <serve_open+0x16b>
80002440:	f6 83 81 00 00 00 01 	testb  $0x1,0x81(%ebx)
80002447:	74 35                	je     8000247e <serve_open+0xad>
80002449:	83 ec 04             	sub    $0x4,%esp
8000244c:	6a 66                	push   $0x66
8000244e:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80002454:	50                   	push   %eax
80002455:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
8000245b:	50                   	push   %eax
8000245c:	e8 f6 f5 ff ff       	call   80001a57 <file_create>
80002461:	83 c4 10             	add    $0x10,%esp
80002464:	85 c0                	test   %eax,%eax
80002466:	79 37                	jns    8000249f <serve_open+0xce>
80002468:	83 f8 f1             	cmp    $0xfffffff1,%eax
8000246b:	0f 85 cb 00 00 00    	jne    8000253c <serve_open+0x16b>
80002471:	f6 83 81 00 00 00 04 	testb  $0x4,0x81(%ebx)
80002478:	0f 85 be 00 00 00    	jne    8000253c <serve_open+0x16b>
8000247e:	83 ec 08             	sub    $0x8,%esp
80002481:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80002487:	50                   	push   %eax
80002488:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
8000248e:	50                   	push   %eax
8000248f:	e8 23 f3 ff ff       	call   800017b7 <file_open>
80002494:	83 c4 10             	add    $0x10,%esp
80002497:	85 c0                	test   %eax,%eax
80002499:	0f 88 9d 00 00 00    	js     8000253c <serve_open+0x16b>
8000249f:	f6 83 81 00 00 00 02 	testb  $0x2,0x81(%ebx)
800024a6:	74 17                	je     800024bf <serve_open+0xee>
800024a8:	83 ec 08             	sub    $0x8,%esp
800024ab:	6a 00                	push   $0x0
800024ad:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
800024b3:	e8 d8 f3 ff ff       	call   80001890 <file_set_size>
800024b8:	83 c4 10             	add    $0x10,%esp
800024bb:	85 c0                	test   %eax,%eax
800024bd:	78 7d                	js     8000253c <serve_open+0x16b>
800024bf:	83 ec 08             	sub    $0x8,%esp
800024c2:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
800024c8:	50                   	push   %eax
800024c9:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
800024cf:	50                   	push   %eax
800024d0:	e8 e2 f2 ff ff       	call   800017b7 <file_open>
800024d5:	83 c4 10             	add    $0x10,%esp
800024d8:	85 c0                	test   %eax,%eax
800024da:	78 60                	js     8000253c <serve_open+0x16b>
800024dc:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
800024e2:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
800024e8:	85 d2                	test   %edx,%edx
800024ea:	b9 80 90 00 80       	mov    $0x80009080,%ecx
800024ef:	0f 44 d1             	cmove  %ecx,%edx
800024f2:	89 50 04             	mov    %edx,0x4(%eax)
800024f5:	8b 50 0c             	mov    0xc(%eax),%edx
800024f8:	8b 08                	mov    (%eax),%ecx
800024fa:	89 4a 0c             	mov    %ecx,0xc(%edx)
800024fd:	8b 48 0c             	mov    0xc(%eax),%ecx
80002500:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80002506:	83 e2 03             	and    $0x3,%edx
80002509:	89 51 08             	mov    %edx,0x8(%ecx)
8000250c:	8b 40 0c             	mov    0xc(%eax),%eax
8000250f:	8b 15 98 90 00 80    	mov    0x80009098,%edx
80002515:	89 10                	mov    %edx,(%eax)
80002517:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
8000251d:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
80002523:	89 50 08             	mov    %edx,0x8(%eax)
80002526:	8b 50 0c             	mov    0xc(%eax),%edx
80002529:	8b 45 10             	mov    0x10(%ebp),%eax
8000252c:	89 10                	mov    %edx,(%eax)
8000252e:	8b 45 14             	mov    0x14(%ebp),%eax
80002531:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
80002537:	b8 00 00 00 00       	mov    $0x0,%eax
8000253c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000253f:	c9                   	leave  
80002540:	c3                   	ret    

80002541 <serve>:
80002541:	55                   	push   %ebp
80002542:	89 e5                	mov    %esp,%ebp
80002544:	56                   	push   %esi
80002545:	53                   	push   %ebx
80002546:	83 ec 10             	sub    $0x10,%esp
80002549:	8d 5d f0             	lea    -0x10(%ebp),%ebx
8000254c:	8d 75 f4             	lea    -0xc(%ebp),%esi
8000254f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80002556:	83 ec 04             	sub    $0x4,%esp
80002559:	53                   	push   %ebx
8000255a:	ff 35 68 50 00 80    	pushl  0x80005068
80002560:	56                   	push   %esi
80002561:	e8 4a 0b 00 00       	call   800030b0 <ipc_recv>
80002566:	83 c4 10             	add    $0x10,%esp
80002569:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
8000256d:	75 15                	jne    80002584 <serve+0x43>
8000256f:	83 ec 08             	sub    $0x8,%esp
80002572:	ff 75 f4             	pushl  -0xc(%ebp)
80002575:	68 9c 48 00 80       	push   $0x8000489c
8000257a:	e8 d0 12 00 00       	call   8000384f <cprintf>
8000257f:	83 c4 10             	add    $0x10,%esp
80002582:	eb cb                	jmp    8000254f <serve+0xe>
80002584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8000258b:	83 f8 01             	cmp    $0x1,%eax
8000258e:	75 18                	jne    800025a8 <serve+0x67>
80002590:	53                   	push   %ebx
80002591:	8d 45 ec             	lea    -0x14(%ebp),%eax
80002594:	50                   	push   %eax
80002595:	ff 35 68 50 00 80    	pushl  0x80005068
8000259b:	ff 75 f4             	pushl  -0xc(%ebp)
8000259e:	e8 2e fe ff ff       	call   800023d1 <serve_open>
800025a3:	83 c4 10             	add    $0x10,%esp
800025a6:	eb 3c                	jmp    800025e4 <serve+0xa3>
800025a8:	83 f8 09             	cmp    $0x9,%eax
800025ab:	77 1e                	ja     800025cb <serve+0x8a>
800025ad:	8b 14 85 40 50 00 80 	mov    -0x7fffafc0(,%eax,4),%edx
800025b4:	85 d2                	test   %edx,%edx
800025b6:	74 13                	je     800025cb <serve+0x8a>
800025b8:	83 ec 08             	sub    $0x8,%esp
800025bb:	ff 35 68 50 00 80    	pushl  0x80005068
800025c1:	ff 75 f4             	pushl  -0xc(%ebp)
800025c4:	ff d2                	call   *%edx
800025c6:	83 c4 10             	add    $0x10,%esp
800025c9:	eb 19                	jmp    800025e4 <serve+0xa3>
800025cb:	83 ec 04             	sub    $0x4,%esp
800025ce:	ff 75 f4             	pushl  -0xc(%ebp)
800025d1:	50                   	push   %eax
800025d2:	68 cc 48 00 80       	push   $0x800048cc
800025d7:	e8 73 12 00 00       	call   8000384f <cprintf>
800025dc:	83 c4 10             	add    $0x10,%esp
800025df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
800025e4:	ff 75 f0             	pushl  -0x10(%ebp)
800025e7:	ff 75 ec             	pushl  -0x14(%ebp)
800025ea:	50                   	push   %eax
800025eb:	ff 75 f4             	pushl  -0xc(%ebp)
800025ee:	e8 38 0b 00 00       	call   8000312b <ipc_send>
800025f3:	83 c4 08             	add    $0x8,%esp
800025f6:	ff 35 68 50 00 80    	pushl  0x80005068
800025fc:	6a 00                	push   $0x0
800025fe:	e8 13 06 00 00       	call   80002c16 <sys_page_unmap>
80002603:	83 c4 10             	add    $0x10,%esp
80002606:	e9 44 ff ff ff       	jmp    8000254f <serve+0xe>

8000260b <umain>:
8000260b:	55                   	push   %ebp
8000260c:	89 e5                	mov    %esp,%ebp
8000260e:	83 ec 14             	sub    $0x14,%esp
80002611:	c7 05 94 90 00 80 77 	movl   $0x80004877,0x80009094
80002618:	48 00 80 
8000261b:	68 7a 48 00 80       	push   $0x8000487a
80002620:	e8 2a 12 00 00       	call   8000384f <cprintf>
80002625:	ba 00 8a 00 00       	mov    $0x8a00,%edx
8000262a:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
8000262f:	66 ef                	out    %ax,(%dx)
80002631:	c7 04 24 8a 48 00 80 	movl   $0x8000488a,(%esp)
80002638:	e8 12 12 00 00       	call   8000384f <cprintf>
8000263d:	e8 bc fa ff ff       	call   800020fe <serve_init>
80002642:	e8 ea f7 ff ff       	call   80001e31 <fs_init>
80002647:	e8 f5 fe ff ff       	call   80002541 <serve>

8000264c <strlen>:
8000264c:	55                   	push   %ebp
8000264d:	89 e5                	mov    %esp,%ebp
8000264f:	8b 55 08             	mov    0x8(%ebp),%edx
80002652:	80 3a 00             	cmpb   $0x0,(%edx)
80002655:	74 10                	je     80002667 <strlen+0x1b>
80002657:	b8 00 00 00 00       	mov    $0x0,%eax
8000265c:	83 c0 01             	add    $0x1,%eax
8000265f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80002663:	75 f7                	jne    8000265c <strlen+0x10>
80002665:	eb 05                	jmp    8000266c <strlen+0x20>
80002667:	b8 00 00 00 00       	mov    $0x0,%eax
8000266c:	5d                   	pop    %ebp
8000266d:	c3                   	ret    

8000266e <strnlen>:
8000266e:	55                   	push   %ebp
8000266f:	89 e5                	mov    %esp,%ebp
80002671:	53                   	push   %ebx
80002672:	8b 5d 08             	mov    0x8(%ebp),%ebx
80002675:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002678:	85 c9                	test   %ecx,%ecx
8000267a:	74 1c                	je     80002698 <strnlen+0x2a>
8000267c:	80 3b 00             	cmpb   $0x0,(%ebx)
8000267f:	74 1e                	je     8000269f <strnlen+0x31>
80002681:	ba 01 00 00 00       	mov    $0x1,%edx
80002686:	89 d0                	mov    %edx,%eax
80002688:	39 ca                	cmp    %ecx,%edx
8000268a:	74 18                	je     800026a4 <strnlen+0x36>
8000268c:	83 c2 01             	add    $0x1,%edx
8000268f:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
80002694:	75 f0                	jne    80002686 <strnlen+0x18>
80002696:	eb 0c                	jmp    800026a4 <strnlen+0x36>
80002698:	b8 00 00 00 00       	mov    $0x0,%eax
8000269d:	eb 05                	jmp    800026a4 <strnlen+0x36>
8000269f:	b8 00 00 00 00       	mov    $0x0,%eax
800026a4:	5b                   	pop    %ebx
800026a5:	5d                   	pop    %ebp
800026a6:	c3                   	ret    

800026a7 <strcpy>:
800026a7:	55                   	push   %ebp
800026a8:	89 e5                	mov    %esp,%ebp
800026aa:	53                   	push   %ebx
800026ab:	8b 45 08             	mov    0x8(%ebp),%eax
800026ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800026b1:	89 c2                	mov    %eax,%edx
800026b3:	83 c2 01             	add    $0x1,%edx
800026b6:	83 c1 01             	add    $0x1,%ecx
800026b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
800026bd:	88 5a ff             	mov    %bl,-0x1(%edx)
800026c0:	84 db                	test   %bl,%bl
800026c2:	75 ef                	jne    800026b3 <strcpy+0xc>
800026c4:	5b                   	pop    %ebx
800026c5:	5d                   	pop    %ebp
800026c6:	c3                   	ret    

800026c7 <strcat>:
800026c7:	55                   	push   %ebp
800026c8:	89 e5                	mov    %esp,%ebp
800026ca:	53                   	push   %ebx
800026cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
800026ce:	53                   	push   %ebx
800026cf:	e8 78 ff ff ff       	call   8000264c <strlen>
800026d4:	83 c4 04             	add    $0x4,%esp
800026d7:	ff 75 0c             	pushl  0xc(%ebp)
800026da:	01 d8                	add    %ebx,%eax
800026dc:	50                   	push   %eax
800026dd:	e8 c5 ff ff ff       	call   800026a7 <strcpy>
800026e2:	89 d8                	mov    %ebx,%eax
800026e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800026e7:	c9                   	leave  
800026e8:	c3                   	ret    

800026e9 <strncpy>:
800026e9:	55                   	push   %ebp
800026ea:	89 e5                	mov    %esp,%ebp
800026ec:	56                   	push   %esi
800026ed:	53                   	push   %ebx
800026ee:	8b 75 08             	mov    0x8(%ebp),%esi
800026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
800026f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
800026f7:	85 db                	test   %ebx,%ebx
800026f9:	74 17                	je     80002712 <strncpy+0x29>
800026fb:	01 f3                	add    %esi,%ebx
800026fd:	89 f1                	mov    %esi,%ecx
800026ff:	83 c1 01             	add    $0x1,%ecx
80002702:	0f b6 02             	movzbl (%edx),%eax
80002705:	88 41 ff             	mov    %al,-0x1(%ecx)
80002708:	80 3a 01             	cmpb   $0x1,(%edx)
8000270b:	83 da ff             	sbb    $0xffffffff,%edx
8000270e:	39 d9                	cmp    %ebx,%ecx
80002710:	75 ed                	jne    800026ff <strncpy+0x16>
80002712:	89 f0                	mov    %esi,%eax
80002714:	5b                   	pop    %ebx
80002715:	5e                   	pop    %esi
80002716:	5d                   	pop    %ebp
80002717:	c3                   	ret    

80002718 <strlcpy>:
80002718:	55                   	push   %ebp
80002719:	89 e5                	mov    %esp,%ebp
8000271b:	56                   	push   %esi
8000271c:	53                   	push   %ebx
8000271d:	8b 75 08             	mov    0x8(%ebp),%esi
80002720:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80002723:	8b 55 10             	mov    0x10(%ebp),%edx
80002726:	89 f0                	mov    %esi,%eax
80002728:	85 d2                	test   %edx,%edx
8000272a:	74 35                	je     80002761 <strlcpy+0x49>
8000272c:	89 d0                	mov    %edx,%eax
8000272e:	83 e8 01             	sub    $0x1,%eax
80002731:	74 25                	je     80002758 <strlcpy+0x40>
80002733:	0f b6 0b             	movzbl (%ebx),%ecx
80002736:	84 c9                	test   %cl,%cl
80002738:	74 22                	je     8000275c <strlcpy+0x44>
8000273a:	8d 53 01             	lea    0x1(%ebx),%edx
8000273d:	01 c3                	add    %eax,%ebx
8000273f:	89 f0                	mov    %esi,%eax
80002741:	83 c0 01             	add    $0x1,%eax
80002744:	88 48 ff             	mov    %cl,-0x1(%eax)
80002747:	39 da                	cmp    %ebx,%edx
80002749:	74 13                	je     8000275e <strlcpy+0x46>
8000274b:	83 c2 01             	add    $0x1,%edx
8000274e:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
80002752:	84 c9                	test   %cl,%cl
80002754:	75 eb                	jne    80002741 <strlcpy+0x29>
80002756:	eb 06                	jmp    8000275e <strlcpy+0x46>
80002758:	89 f0                	mov    %esi,%eax
8000275a:	eb 02                	jmp    8000275e <strlcpy+0x46>
8000275c:	89 f0                	mov    %esi,%eax
8000275e:	c6 00 00             	movb   $0x0,(%eax)
80002761:	29 f0                	sub    %esi,%eax
80002763:	5b                   	pop    %ebx
80002764:	5e                   	pop    %esi
80002765:	5d                   	pop    %ebp
80002766:	c3                   	ret    

80002767 <strcmp>:
80002767:	55                   	push   %ebp
80002768:	89 e5                	mov    %esp,%ebp
8000276a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8000276d:	8b 55 0c             	mov    0xc(%ebp),%edx
80002770:	0f b6 01             	movzbl (%ecx),%eax
80002773:	84 c0                	test   %al,%al
80002775:	74 15                	je     8000278c <strcmp+0x25>
80002777:	3a 02                	cmp    (%edx),%al
80002779:	75 11                	jne    8000278c <strcmp+0x25>
8000277b:	83 c1 01             	add    $0x1,%ecx
8000277e:	83 c2 01             	add    $0x1,%edx
80002781:	0f b6 01             	movzbl (%ecx),%eax
80002784:	84 c0                	test   %al,%al
80002786:	74 04                	je     8000278c <strcmp+0x25>
80002788:	3a 02                	cmp    (%edx),%al
8000278a:	74 ef                	je     8000277b <strcmp+0x14>
8000278c:	0f b6 c0             	movzbl %al,%eax
8000278f:	0f b6 12             	movzbl (%edx),%edx
80002792:	29 d0                	sub    %edx,%eax
80002794:	5d                   	pop    %ebp
80002795:	c3                   	ret    

80002796 <strncmp>:
80002796:	55                   	push   %ebp
80002797:	89 e5                	mov    %esp,%ebp
80002799:	56                   	push   %esi
8000279a:	53                   	push   %ebx
8000279b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000279e:	8b 55 0c             	mov    0xc(%ebp),%edx
800027a1:	8b 75 10             	mov    0x10(%ebp),%esi
800027a4:	85 f6                	test   %esi,%esi
800027a6:	74 29                	je     800027d1 <strncmp+0x3b>
800027a8:	0f b6 03             	movzbl (%ebx),%eax
800027ab:	84 c0                	test   %al,%al
800027ad:	74 30                	je     800027df <strncmp+0x49>
800027af:	3a 02                	cmp    (%edx),%al
800027b1:	75 2c                	jne    800027df <strncmp+0x49>
800027b3:	8d 43 01             	lea    0x1(%ebx),%eax
800027b6:	01 de                	add    %ebx,%esi
800027b8:	89 c3                	mov    %eax,%ebx
800027ba:	83 c2 01             	add    $0x1,%edx
800027bd:	39 f0                	cmp    %esi,%eax
800027bf:	74 17                	je     800027d8 <strncmp+0x42>
800027c1:	0f b6 08             	movzbl (%eax),%ecx
800027c4:	84 c9                	test   %cl,%cl
800027c6:	74 17                	je     800027df <strncmp+0x49>
800027c8:	83 c0 01             	add    $0x1,%eax
800027cb:	3a 0a                	cmp    (%edx),%cl
800027cd:	74 e9                	je     800027b8 <strncmp+0x22>
800027cf:	eb 0e                	jmp    800027df <strncmp+0x49>
800027d1:	b8 00 00 00 00       	mov    $0x0,%eax
800027d6:	eb 0f                	jmp    800027e7 <strncmp+0x51>
800027d8:	b8 00 00 00 00       	mov    $0x0,%eax
800027dd:	eb 08                	jmp    800027e7 <strncmp+0x51>
800027df:	0f b6 03             	movzbl (%ebx),%eax
800027e2:	0f b6 12             	movzbl (%edx),%edx
800027e5:	29 d0                	sub    %edx,%eax
800027e7:	5b                   	pop    %ebx
800027e8:	5e                   	pop    %esi
800027e9:	5d                   	pop    %ebp
800027ea:	c3                   	ret    

800027eb <strchr>:
800027eb:	55                   	push   %ebp
800027ec:	89 e5                	mov    %esp,%ebp
800027ee:	53                   	push   %ebx
800027ef:	8b 45 08             	mov    0x8(%ebp),%eax
800027f2:	8b 55 0c             	mov    0xc(%ebp),%edx
800027f5:	0f b6 18             	movzbl (%eax),%ebx
800027f8:	84 db                	test   %bl,%bl
800027fa:	74 1d                	je     80002819 <strchr+0x2e>
800027fc:	89 d1                	mov    %edx,%ecx
800027fe:	38 d3                	cmp    %dl,%bl
80002800:	75 06                	jne    80002808 <strchr+0x1d>
80002802:	eb 1a                	jmp    8000281e <strchr+0x33>
80002804:	38 ca                	cmp    %cl,%dl
80002806:	74 16                	je     8000281e <strchr+0x33>
80002808:	83 c0 01             	add    $0x1,%eax
8000280b:	0f b6 10             	movzbl (%eax),%edx
8000280e:	84 d2                	test   %dl,%dl
80002810:	75 f2                	jne    80002804 <strchr+0x19>
80002812:	b8 00 00 00 00       	mov    $0x0,%eax
80002817:	eb 05                	jmp    8000281e <strchr+0x33>
80002819:	b8 00 00 00 00       	mov    $0x0,%eax
8000281e:	5b                   	pop    %ebx
8000281f:	5d                   	pop    %ebp
80002820:	c3                   	ret    

80002821 <strfind>:
80002821:	55                   	push   %ebp
80002822:	89 e5                	mov    %esp,%ebp
80002824:	53                   	push   %ebx
80002825:	8b 45 08             	mov    0x8(%ebp),%eax
80002828:	8b 55 0c             	mov    0xc(%ebp),%edx
8000282b:	0f b6 18             	movzbl (%eax),%ebx
8000282e:	84 db                	test   %bl,%bl
80002830:	74 14                	je     80002846 <strfind+0x25>
80002832:	89 d1                	mov    %edx,%ecx
80002834:	38 d3                	cmp    %dl,%bl
80002836:	74 0e                	je     80002846 <strfind+0x25>
80002838:	83 c0 01             	add    $0x1,%eax
8000283b:	0f b6 10             	movzbl (%eax),%edx
8000283e:	38 ca                	cmp    %cl,%dl
80002840:	74 04                	je     80002846 <strfind+0x25>
80002842:	84 d2                	test   %dl,%dl
80002844:	75 f2                	jne    80002838 <strfind+0x17>
80002846:	5b                   	pop    %ebx
80002847:	5d                   	pop    %ebp
80002848:	c3                   	ret    

80002849 <memset>:
80002849:	55                   	push   %ebp
8000284a:	89 e5                	mov    %esp,%ebp
8000284c:	57                   	push   %edi
8000284d:	56                   	push   %esi
8000284e:	53                   	push   %ebx
8000284f:	8b 7d 08             	mov    0x8(%ebp),%edi
80002852:	8b 4d 10             	mov    0x10(%ebp),%ecx
80002855:	85 c9                	test   %ecx,%ecx
80002857:	74 36                	je     8000288f <memset+0x46>
80002859:	f7 c7 03 00 00 00    	test   $0x3,%edi
8000285f:	75 28                	jne    80002889 <memset+0x40>
80002861:	f6 c1 03             	test   $0x3,%cl
80002864:	75 23                	jne    80002889 <memset+0x40>
80002866:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
8000286a:	89 d3                	mov    %edx,%ebx
8000286c:	c1 e3 08             	shl    $0x8,%ebx
8000286f:	89 d6                	mov    %edx,%esi
80002871:	c1 e6 18             	shl    $0x18,%esi
80002874:	89 d0                	mov    %edx,%eax
80002876:	c1 e0 10             	shl    $0x10,%eax
80002879:	09 f0                	or     %esi,%eax
8000287b:	09 c2                	or     %eax,%edx
8000287d:	89 d0                	mov    %edx,%eax
8000287f:	09 d8                	or     %ebx,%eax
80002881:	c1 e9 02             	shr    $0x2,%ecx
80002884:	fc                   	cld    
80002885:	f3 ab                	rep stos %eax,%es:(%edi)
80002887:	eb 06                	jmp    8000288f <memset+0x46>
80002889:	8b 45 0c             	mov    0xc(%ebp),%eax
8000288c:	fc                   	cld    
8000288d:	f3 aa                	rep stos %al,%es:(%edi)
8000288f:	89 f8                	mov    %edi,%eax
80002891:	5b                   	pop    %ebx
80002892:	5e                   	pop    %esi
80002893:	5f                   	pop    %edi
80002894:	5d                   	pop    %ebp
80002895:	c3                   	ret    

80002896 <memmove>:
80002896:	55                   	push   %ebp
80002897:	89 e5                	mov    %esp,%ebp
80002899:	57                   	push   %edi
8000289a:	56                   	push   %esi
8000289b:	8b 45 08             	mov    0x8(%ebp),%eax
8000289e:	8b 75 0c             	mov    0xc(%ebp),%esi
800028a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
800028a4:	39 c6                	cmp    %eax,%esi
800028a6:	73 35                	jae    800028dd <memmove+0x47>
800028a8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
800028ab:	39 d0                	cmp    %edx,%eax
800028ad:	73 2e                	jae    800028dd <memmove+0x47>
800028af:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
800028b2:	89 d6                	mov    %edx,%esi
800028b4:	09 fe                	or     %edi,%esi
800028b6:	f7 c6 03 00 00 00    	test   $0x3,%esi
800028bc:	75 13                	jne    800028d1 <memmove+0x3b>
800028be:	f6 c1 03             	test   $0x3,%cl
800028c1:	75 0e                	jne    800028d1 <memmove+0x3b>
800028c3:	83 ef 04             	sub    $0x4,%edi
800028c6:	8d 72 fc             	lea    -0x4(%edx),%esi
800028c9:	c1 e9 02             	shr    $0x2,%ecx
800028cc:	fd                   	std    
800028cd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
800028cf:	eb 09                	jmp    800028da <memmove+0x44>
800028d1:	83 ef 01             	sub    $0x1,%edi
800028d4:	8d 72 ff             	lea    -0x1(%edx),%esi
800028d7:	fd                   	std    
800028d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
800028da:	fc                   	cld    
800028db:	eb 1d                	jmp    800028fa <memmove+0x64>
800028dd:	89 f2                	mov    %esi,%edx
800028df:	09 c2                	or     %eax,%edx
800028e1:	f6 c2 03             	test   $0x3,%dl
800028e4:	75 0f                	jne    800028f5 <memmove+0x5f>
800028e6:	f6 c1 03             	test   $0x3,%cl
800028e9:	75 0a                	jne    800028f5 <memmove+0x5f>
800028eb:	c1 e9 02             	shr    $0x2,%ecx
800028ee:	89 c7                	mov    %eax,%edi
800028f0:	fc                   	cld    
800028f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
800028f3:	eb 05                	jmp    800028fa <memmove+0x64>
800028f5:	89 c7                	mov    %eax,%edi
800028f7:	fc                   	cld    
800028f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
800028fa:	5e                   	pop    %esi
800028fb:	5f                   	pop    %edi
800028fc:	5d                   	pop    %ebp
800028fd:	c3                   	ret    

800028fe <memcpy>:
800028fe:	55                   	push   %ebp
800028ff:	89 e5                	mov    %esp,%ebp
80002901:	ff 75 10             	pushl  0x10(%ebp)
80002904:	ff 75 0c             	pushl  0xc(%ebp)
80002907:	ff 75 08             	pushl  0x8(%ebp)
8000290a:	e8 87 ff ff ff       	call   80002896 <memmove>
8000290f:	c9                   	leave  
80002910:	c3                   	ret    

80002911 <memcmp>:
80002911:	55                   	push   %ebp
80002912:	89 e5                	mov    %esp,%ebp
80002914:	57                   	push   %edi
80002915:	56                   	push   %esi
80002916:	53                   	push   %ebx
80002917:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000291a:	8b 75 0c             	mov    0xc(%ebp),%esi
8000291d:	8b 45 10             	mov    0x10(%ebp),%eax
80002920:	8d 78 ff             	lea    -0x1(%eax),%edi
80002923:	85 c0                	test   %eax,%eax
80002925:	74 36                	je     8000295d <memcmp+0x4c>
80002927:	0f b6 13             	movzbl (%ebx),%edx
8000292a:	0f b6 0e             	movzbl (%esi),%ecx
8000292d:	38 ca                	cmp    %cl,%dl
8000292f:	75 17                	jne    80002948 <memcmp+0x37>
80002931:	b8 00 00 00 00       	mov    $0x0,%eax
80002936:	eb 1a                	jmp    80002952 <memcmp+0x41>
80002938:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8000293d:	83 c0 01             	add    $0x1,%eax
80002940:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80002944:	38 ca                	cmp    %cl,%dl
80002946:	74 0a                	je     80002952 <memcmp+0x41>
80002948:	0f b6 c2             	movzbl %dl,%eax
8000294b:	0f b6 c9             	movzbl %cl,%ecx
8000294e:	29 c8                	sub    %ecx,%eax
80002950:	eb 10                	jmp    80002962 <memcmp+0x51>
80002952:	39 f8                	cmp    %edi,%eax
80002954:	75 e2                	jne    80002938 <memcmp+0x27>
80002956:	b8 00 00 00 00       	mov    $0x0,%eax
8000295b:	eb 05                	jmp    80002962 <memcmp+0x51>
8000295d:	b8 00 00 00 00       	mov    $0x0,%eax
80002962:	5b                   	pop    %ebx
80002963:	5e                   	pop    %esi
80002964:	5f                   	pop    %edi
80002965:	5d                   	pop    %ebp
80002966:	c3                   	ret    

80002967 <memfind>:
80002967:	55                   	push   %ebp
80002968:	89 e5                	mov    %esp,%ebp
8000296a:	53                   	push   %ebx
8000296b:	8b 55 08             	mov    0x8(%ebp),%edx
8000296e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80002971:	89 d0                	mov    %edx,%eax
80002973:	03 45 10             	add    0x10(%ebp),%eax
80002976:	39 c2                	cmp    %eax,%edx
80002978:	73 15                	jae    8000298f <memfind+0x28>
8000297a:	89 d9                	mov    %ebx,%ecx
8000297c:	38 1a                	cmp    %bl,(%edx)
8000297e:	75 06                	jne    80002986 <memfind+0x1f>
80002980:	eb 11                	jmp    80002993 <memfind+0x2c>
80002982:	38 0a                	cmp    %cl,(%edx)
80002984:	74 11                	je     80002997 <memfind+0x30>
80002986:	83 c2 01             	add    $0x1,%edx
80002989:	39 c2                	cmp    %eax,%edx
8000298b:	75 f5                	jne    80002982 <memfind+0x1b>
8000298d:	eb 0a                	jmp    80002999 <memfind+0x32>
8000298f:	89 d0                	mov    %edx,%eax
80002991:	eb 06                	jmp    80002999 <memfind+0x32>
80002993:	89 d0                	mov    %edx,%eax
80002995:	eb 02                	jmp    80002999 <memfind+0x32>
80002997:	89 d0                	mov    %edx,%eax
80002999:	5b                   	pop    %ebx
8000299a:	5d                   	pop    %ebp
8000299b:	c3                   	ret    

8000299c <strtol>:
8000299c:	55                   	push   %ebp
8000299d:	89 e5                	mov    %esp,%ebp
8000299f:	57                   	push   %edi
800029a0:	56                   	push   %esi
800029a1:	53                   	push   %ebx
800029a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
800029a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
800029a8:	0f b6 01             	movzbl (%ecx),%eax
800029ab:	3c 09                	cmp    $0x9,%al
800029ad:	74 04                	je     800029b3 <strtol+0x17>
800029af:	3c 20                	cmp    $0x20,%al
800029b1:	75 0e                	jne    800029c1 <strtol+0x25>
800029b3:	83 c1 01             	add    $0x1,%ecx
800029b6:	0f b6 01             	movzbl (%ecx),%eax
800029b9:	3c 09                	cmp    $0x9,%al
800029bb:	74 f6                	je     800029b3 <strtol+0x17>
800029bd:	3c 20                	cmp    $0x20,%al
800029bf:	74 f2                	je     800029b3 <strtol+0x17>
800029c1:	3c 2b                	cmp    $0x2b,%al
800029c3:	75 0a                	jne    800029cf <strtol+0x33>
800029c5:	83 c1 01             	add    $0x1,%ecx
800029c8:	bf 00 00 00 00       	mov    $0x0,%edi
800029cd:	eb 10                	jmp    800029df <strtol+0x43>
800029cf:	bf 00 00 00 00       	mov    $0x0,%edi
800029d4:	3c 2d                	cmp    $0x2d,%al
800029d6:	75 07                	jne    800029df <strtol+0x43>
800029d8:	83 c1 01             	add    $0x1,%ecx
800029db:	66 bf 01 00          	mov    $0x1,%di
800029df:	85 db                	test   %ebx,%ebx
800029e1:	0f 94 c0             	sete   %al
800029e4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
800029ea:	75 19                	jne    80002a05 <strtol+0x69>
800029ec:	80 39 30             	cmpb   $0x30,(%ecx)
800029ef:	75 14                	jne    80002a05 <strtol+0x69>
800029f1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
800029f5:	0f 85 82 00 00 00    	jne    80002a7d <strtol+0xe1>
800029fb:	83 c1 02             	add    $0x2,%ecx
800029fe:	bb 10 00 00 00       	mov    $0x10,%ebx
80002a03:	eb 16                	jmp    80002a1b <strtol+0x7f>
80002a05:	84 c0                	test   %al,%al
80002a07:	74 12                	je     80002a1b <strtol+0x7f>
80002a09:	bb 0a 00 00 00       	mov    $0xa,%ebx
80002a0e:	80 39 30             	cmpb   $0x30,(%ecx)
80002a11:	75 08                	jne    80002a1b <strtol+0x7f>
80002a13:	83 c1 01             	add    $0x1,%ecx
80002a16:	bb 08 00 00 00       	mov    $0x8,%ebx
80002a1b:	b8 00 00 00 00       	mov    $0x0,%eax
80002a20:	89 5d 10             	mov    %ebx,0x10(%ebp)
80002a23:	0f b6 11             	movzbl (%ecx),%edx
80002a26:	8d 72 d0             	lea    -0x30(%edx),%esi
80002a29:	89 f3                	mov    %esi,%ebx
80002a2b:	80 fb 09             	cmp    $0x9,%bl
80002a2e:	77 08                	ja     80002a38 <strtol+0x9c>
80002a30:	0f be d2             	movsbl %dl,%edx
80002a33:	83 ea 30             	sub    $0x30,%edx
80002a36:	eb 22                	jmp    80002a5a <strtol+0xbe>
80002a38:	8d 72 9f             	lea    -0x61(%edx),%esi
80002a3b:	89 f3                	mov    %esi,%ebx
80002a3d:	80 fb 19             	cmp    $0x19,%bl
80002a40:	77 08                	ja     80002a4a <strtol+0xae>
80002a42:	0f be d2             	movsbl %dl,%edx
80002a45:	83 ea 57             	sub    $0x57,%edx
80002a48:	eb 10                	jmp    80002a5a <strtol+0xbe>
80002a4a:	8d 72 bf             	lea    -0x41(%edx),%esi
80002a4d:	89 f3                	mov    %esi,%ebx
80002a4f:	80 fb 19             	cmp    $0x19,%bl
80002a52:	77 16                	ja     80002a6a <strtol+0xce>
80002a54:	0f be d2             	movsbl %dl,%edx
80002a57:	83 ea 37             	sub    $0x37,%edx
80002a5a:	3b 55 10             	cmp    0x10(%ebp),%edx
80002a5d:	7d 0f                	jge    80002a6e <strtol+0xd2>
80002a5f:	83 c1 01             	add    $0x1,%ecx
80002a62:	0f af 45 10          	imul   0x10(%ebp),%eax
80002a66:	01 d0                	add    %edx,%eax
80002a68:	eb b9                	jmp    80002a23 <strtol+0x87>
80002a6a:	89 c2                	mov    %eax,%edx
80002a6c:	eb 02                	jmp    80002a70 <strtol+0xd4>
80002a6e:	89 c2                	mov    %eax,%edx
80002a70:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80002a74:	74 0d                	je     80002a83 <strtol+0xe7>
80002a76:	8b 75 0c             	mov    0xc(%ebp),%esi
80002a79:	89 0e                	mov    %ecx,(%esi)
80002a7b:	eb 06                	jmp    80002a83 <strtol+0xe7>
80002a7d:	84 c0                	test   %al,%al
80002a7f:	75 92                	jne    80002a13 <strtol+0x77>
80002a81:	eb 98                	jmp    80002a1b <strtol+0x7f>
80002a83:	f7 da                	neg    %edx
80002a85:	85 ff                	test   %edi,%edi
80002a87:	0f 45 c2             	cmovne %edx,%eax
80002a8a:	5b                   	pop    %ebx
80002a8b:	5e                   	pop    %esi
80002a8c:	5f                   	pop    %edi
80002a8d:	5d                   	pop    %ebp
80002a8e:	c3                   	ret    

80002a8f <libmain>:
80002a8f:	55                   	push   %ebp
80002a90:	89 e5                	mov    %esp,%ebp
80002a92:	56                   	push   %esi
80002a93:	53                   	push   %ebx
80002a94:	8b 5d 08             	mov    0x8(%ebp),%ebx
80002a97:	8b 75 0c             	mov    0xc(%ebp),%esi
80002a9a:	e8 b4 00 00 00       	call   80002b53 <sys_getenvid>
80002a9f:	25 ff 03 00 00       	and    $0x3ff,%eax
80002aa4:	6b c0 7c             	imul   $0x7c,%eax,%eax
80002aa7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
80002aac:	a3 10 a6 00 80       	mov    %eax,0x8000a610
80002ab1:	85 db                	test   %ebx,%ebx
80002ab3:	7e 07                	jle    80002abc <libmain+0x2d>
80002ab5:	8b 06                	mov    (%esi),%eax
80002ab7:	a3 94 90 00 80       	mov    %eax,0x80009094
80002abc:	83 ec 08             	sub    $0x8,%esp
80002abf:	56                   	push   %esi
80002ac0:	53                   	push   %ebx
80002ac1:	e8 45 fb ff ff       	call   8000260b <umain>
80002ac6:	e8 fc 06 00 00       	call   800031c7 <exit>
80002acb:	83 c4 10             	add    $0x10,%esp
80002ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002ad1:	5b                   	pop    %ebx
80002ad2:	5e                   	pop    %esi
80002ad3:	5d                   	pop    %ebp
80002ad4:	c3                   	ret    

80002ad5 <sys_cputs>:
80002ad5:	55                   	push   %ebp
80002ad6:	89 e5                	mov    %esp,%ebp
80002ad8:	57                   	push   %edi
80002ad9:	56                   	push   %esi
80002ada:	53                   	push   %ebx
80002adb:	b8 00 00 00 00       	mov    $0x0,%eax
80002ae0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80002ae6:	89 c3                	mov    %eax,%ebx
80002ae8:	89 c7                	mov    %eax,%edi
80002aea:	89 c6                	mov    %eax,%esi
80002aec:	cd 30                	int    $0x30
80002aee:	5b                   	pop    %ebx
80002aef:	5e                   	pop    %esi
80002af0:	5f                   	pop    %edi
80002af1:	5d                   	pop    %ebp
80002af2:	c3                   	ret    

80002af3 <sys_cgetc>:
80002af3:	55                   	push   %ebp
80002af4:	89 e5                	mov    %esp,%ebp
80002af6:	57                   	push   %edi
80002af7:	56                   	push   %esi
80002af8:	53                   	push   %ebx
80002af9:	ba 00 00 00 00       	mov    $0x0,%edx
80002afe:	b8 01 00 00 00       	mov    $0x1,%eax
80002b03:	89 d1                	mov    %edx,%ecx
80002b05:	89 d3                	mov    %edx,%ebx
80002b07:	89 d7                	mov    %edx,%edi
80002b09:	89 d6                	mov    %edx,%esi
80002b0b:	cd 30                	int    $0x30
80002b0d:	5b                   	pop    %ebx
80002b0e:	5e                   	pop    %esi
80002b0f:	5f                   	pop    %edi
80002b10:	5d                   	pop    %ebp
80002b11:	c3                   	ret    

80002b12 <sys_env_destroy>:
80002b12:	55                   	push   %ebp
80002b13:	89 e5                	mov    %esp,%ebp
80002b15:	57                   	push   %edi
80002b16:	56                   	push   %esi
80002b17:	53                   	push   %ebx
80002b18:	83 ec 0c             	sub    $0xc,%esp
80002b1b:	b9 00 00 00 00       	mov    $0x0,%ecx
80002b20:	b8 03 00 00 00       	mov    $0x3,%eax
80002b25:	8b 55 08             	mov    0x8(%ebp),%edx
80002b28:	89 cb                	mov    %ecx,%ebx
80002b2a:	89 cf                	mov    %ecx,%edi
80002b2c:	89 ce                	mov    %ecx,%esi
80002b2e:	cd 30                	int    $0x30
80002b30:	85 c0                	test   %eax,%eax
80002b32:	7e 17                	jle    80002b4b <sys_env_destroy+0x39>
80002b34:	83 ec 0c             	sub    $0xc,%esp
80002b37:	50                   	push   %eax
80002b38:	6a 03                	push   $0x3
80002b3a:	68 f9 48 00 80       	push   $0x800048f9
80002b3f:	6a 21                	push   $0x21
80002b41:	68 16 49 00 80       	push   $0x80004916
80002b46:	e8 20 0f 00 00       	call   80003a6b <_panic>
80002b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002b4e:	5b                   	pop    %ebx
80002b4f:	5e                   	pop    %esi
80002b50:	5f                   	pop    %edi
80002b51:	5d                   	pop    %ebp
80002b52:	c3                   	ret    

80002b53 <sys_getenvid>:
80002b53:	55                   	push   %ebp
80002b54:	89 e5                	mov    %esp,%ebp
80002b56:	57                   	push   %edi
80002b57:	56                   	push   %esi
80002b58:	53                   	push   %ebx
80002b59:	ba 00 00 00 00       	mov    $0x0,%edx
80002b5e:	b8 02 00 00 00       	mov    $0x2,%eax
80002b63:	89 d1                	mov    %edx,%ecx
80002b65:	89 d3                	mov    %edx,%ebx
80002b67:	89 d7                	mov    %edx,%edi
80002b69:	89 d6                	mov    %edx,%esi
80002b6b:	cd 30                	int    $0x30
80002b6d:	5b                   	pop    %ebx
80002b6e:	5e                   	pop    %esi
80002b6f:	5f                   	pop    %edi
80002b70:	5d                   	pop    %ebp
80002b71:	c3                   	ret    

80002b72 <sys_yield>:
80002b72:	55                   	push   %ebp
80002b73:	89 e5                	mov    %esp,%ebp
80002b75:	57                   	push   %edi
80002b76:	56                   	push   %esi
80002b77:	53                   	push   %ebx
80002b78:	ba 00 00 00 00       	mov    $0x0,%edx
80002b7d:	b8 0b 00 00 00       	mov    $0xb,%eax
80002b82:	89 d1                	mov    %edx,%ecx
80002b84:	89 d3                	mov    %edx,%ebx
80002b86:	89 d7                	mov    %edx,%edi
80002b88:	89 d6                	mov    %edx,%esi
80002b8a:	cd 30                	int    $0x30
80002b8c:	5b                   	pop    %ebx
80002b8d:	5e                   	pop    %esi
80002b8e:	5f                   	pop    %edi
80002b8f:	5d                   	pop    %ebp
80002b90:	c3                   	ret    

80002b91 <sys_page_alloc>:
80002b91:	55                   	push   %ebp
80002b92:	89 e5                	mov    %esp,%ebp
80002b94:	57                   	push   %edi
80002b95:	56                   	push   %esi
80002b96:	53                   	push   %ebx
80002b97:	83 ec 0c             	sub    $0xc,%esp
80002b9a:	be 00 00 00 00       	mov    $0x0,%esi
80002b9f:	b8 04 00 00 00       	mov    $0x4,%eax
80002ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002ba7:	8b 55 08             	mov    0x8(%ebp),%edx
80002baa:	8b 5d 10             	mov    0x10(%ebp),%ebx
80002bad:	89 f7                	mov    %esi,%edi
80002baf:	cd 30                	int    $0x30
80002bb1:	85 c0                	test   %eax,%eax
80002bb3:	7e 17                	jle    80002bcc <sys_page_alloc+0x3b>
80002bb5:	83 ec 0c             	sub    $0xc,%esp
80002bb8:	50                   	push   %eax
80002bb9:	6a 04                	push   $0x4
80002bbb:	68 f9 48 00 80       	push   $0x800048f9
80002bc0:	6a 21                	push   $0x21
80002bc2:	68 16 49 00 80       	push   $0x80004916
80002bc7:	e8 9f 0e 00 00       	call   80003a6b <_panic>
80002bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002bcf:	5b                   	pop    %ebx
80002bd0:	5e                   	pop    %esi
80002bd1:	5f                   	pop    %edi
80002bd2:	5d                   	pop    %ebp
80002bd3:	c3                   	ret    

80002bd4 <sys_page_map>:
80002bd4:	55                   	push   %ebp
80002bd5:	89 e5                	mov    %esp,%ebp
80002bd7:	57                   	push   %edi
80002bd8:	56                   	push   %esi
80002bd9:	53                   	push   %ebx
80002bda:	83 ec 0c             	sub    $0xc,%esp
80002bdd:	b8 05 00 00 00       	mov    $0x5,%eax
80002be2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002be5:	8b 55 08             	mov    0x8(%ebp),%edx
80002be8:	8b 5d 10             	mov    0x10(%ebp),%ebx
80002beb:	8b 7d 14             	mov    0x14(%ebp),%edi
80002bee:	8b 75 18             	mov    0x18(%ebp),%esi
80002bf1:	cd 30                	int    $0x30
80002bf3:	85 c0                	test   %eax,%eax
80002bf5:	7e 17                	jle    80002c0e <sys_page_map+0x3a>
80002bf7:	83 ec 0c             	sub    $0xc,%esp
80002bfa:	50                   	push   %eax
80002bfb:	6a 05                	push   $0x5
80002bfd:	68 f9 48 00 80       	push   $0x800048f9
80002c02:	6a 21                	push   $0x21
80002c04:	68 16 49 00 80       	push   $0x80004916
80002c09:	e8 5d 0e 00 00       	call   80003a6b <_panic>
80002c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002c11:	5b                   	pop    %ebx
80002c12:	5e                   	pop    %esi
80002c13:	5f                   	pop    %edi
80002c14:	5d                   	pop    %ebp
80002c15:	c3                   	ret    

80002c16 <sys_page_unmap>:
80002c16:	55                   	push   %ebp
80002c17:	89 e5                	mov    %esp,%ebp
80002c19:	57                   	push   %edi
80002c1a:	56                   	push   %esi
80002c1b:	53                   	push   %ebx
80002c1c:	83 ec 0c             	sub    $0xc,%esp
80002c1f:	bb 00 00 00 00       	mov    $0x0,%ebx
80002c24:	b8 06 00 00 00       	mov    $0x6,%eax
80002c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002c2c:	8b 55 08             	mov    0x8(%ebp),%edx
80002c2f:	89 df                	mov    %ebx,%edi
80002c31:	89 de                	mov    %ebx,%esi
80002c33:	cd 30                	int    $0x30
80002c35:	85 c0                	test   %eax,%eax
80002c37:	7e 17                	jle    80002c50 <sys_page_unmap+0x3a>
80002c39:	83 ec 0c             	sub    $0xc,%esp
80002c3c:	50                   	push   %eax
80002c3d:	6a 06                	push   $0x6
80002c3f:	68 f9 48 00 80       	push   $0x800048f9
80002c44:	6a 21                	push   $0x21
80002c46:	68 16 49 00 80       	push   $0x80004916
80002c4b:	e8 1b 0e 00 00       	call   80003a6b <_panic>
80002c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002c53:	5b                   	pop    %ebx
80002c54:	5e                   	pop    %esi
80002c55:	5f                   	pop    %edi
80002c56:	5d                   	pop    %ebp
80002c57:	c3                   	ret    

80002c58 <sys_env_set_status>:
80002c58:	55                   	push   %ebp
80002c59:	89 e5                	mov    %esp,%ebp
80002c5b:	57                   	push   %edi
80002c5c:	56                   	push   %esi
80002c5d:	53                   	push   %ebx
80002c5e:	83 ec 0c             	sub    $0xc,%esp
80002c61:	bb 00 00 00 00       	mov    $0x0,%ebx
80002c66:	b8 08 00 00 00       	mov    $0x8,%eax
80002c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002c6e:	8b 55 08             	mov    0x8(%ebp),%edx
80002c71:	89 df                	mov    %ebx,%edi
80002c73:	89 de                	mov    %ebx,%esi
80002c75:	cd 30                	int    $0x30
80002c77:	85 c0                	test   %eax,%eax
80002c79:	7e 17                	jle    80002c92 <sys_env_set_status+0x3a>
80002c7b:	83 ec 0c             	sub    $0xc,%esp
80002c7e:	50                   	push   %eax
80002c7f:	6a 08                	push   $0x8
80002c81:	68 f9 48 00 80       	push   $0x800048f9
80002c86:	6a 21                	push   $0x21
80002c88:	68 16 49 00 80       	push   $0x80004916
80002c8d:	e8 d9 0d 00 00       	call   80003a6b <_panic>
80002c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002c95:	5b                   	pop    %ebx
80002c96:	5e                   	pop    %esi
80002c97:	5f                   	pop    %edi
80002c98:	5d                   	pop    %ebp
80002c99:	c3                   	ret    

80002c9a <sys_env_set_trapframe>:
80002c9a:	55                   	push   %ebp
80002c9b:	89 e5                	mov    %esp,%ebp
80002c9d:	57                   	push   %edi
80002c9e:	56                   	push   %esi
80002c9f:	53                   	push   %ebx
80002ca0:	83 ec 0c             	sub    $0xc,%esp
80002ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
80002ca8:	b8 09 00 00 00       	mov    $0x9,%eax
80002cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80002cb3:	89 df                	mov    %ebx,%edi
80002cb5:	89 de                	mov    %ebx,%esi
80002cb7:	cd 30                	int    $0x30
80002cb9:	85 c0                	test   %eax,%eax
80002cbb:	7e 17                	jle    80002cd4 <sys_env_set_trapframe+0x3a>
80002cbd:	83 ec 0c             	sub    $0xc,%esp
80002cc0:	50                   	push   %eax
80002cc1:	6a 09                	push   $0x9
80002cc3:	68 f9 48 00 80       	push   $0x800048f9
80002cc8:	6a 21                	push   $0x21
80002cca:	68 16 49 00 80       	push   $0x80004916
80002ccf:	e8 97 0d 00 00       	call   80003a6b <_panic>
80002cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002cd7:	5b                   	pop    %ebx
80002cd8:	5e                   	pop    %esi
80002cd9:	5f                   	pop    %edi
80002cda:	5d                   	pop    %ebp
80002cdb:	c3                   	ret    

80002cdc <sys_env_set_pgfault_upcall>:
80002cdc:	55                   	push   %ebp
80002cdd:	89 e5                	mov    %esp,%ebp
80002cdf:	57                   	push   %edi
80002ce0:	56                   	push   %esi
80002ce1:	53                   	push   %ebx
80002ce2:	83 ec 0c             	sub    $0xc,%esp
80002ce5:	bb 00 00 00 00       	mov    $0x0,%ebx
80002cea:	b8 0a 00 00 00       	mov    $0xa,%eax
80002cef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002cf2:	8b 55 08             	mov    0x8(%ebp),%edx
80002cf5:	89 df                	mov    %ebx,%edi
80002cf7:	89 de                	mov    %ebx,%esi
80002cf9:	cd 30                	int    $0x30
80002cfb:	85 c0                	test   %eax,%eax
80002cfd:	7e 17                	jle    80002d16 <sys_env_set_pgfault_upcall+0x3a>
80002cff:	83 ec 0c             	sub    $0xc,%esp
80002d02:	50                   	push   %eax
80002d03:	6a 0a                	push   $0xa
80002d05:	68 f9 48 00 80       	push   $0x800048f9
80002d0a:	6a 21                	push   $0x21
80002d0c:	68 16 49 00 80       	push   $0x80004916
80002d11:	e8 55 0d 00 00       	call   80003a6b <_panic>
80002d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002d19:	5b                   	pop    %ebx
80002d1a:	5e                   	pop    %esi
80002d1b:	5f                   	pop    %edi
80002d1c:	5d                   	pop    %ebp
80002d1d:	c3                   	ret    

80002d1e <sys_ipc_try_send>:
80002d1e:	55                   	push   %ebp
80002d1f:	89 e5                	mov    %esp,%ebp
80002d21:	57                   	push   %edi
80002d22:	56                   	push   %esi
80002d23:	53                   	push   %ebx
80002d24:	be 00 00 00 00       	mov    $0x0,%esi
80002d29:	b8 0c 00 00 00       	mov    $0xc,%eax
80002d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80002d31:	8b 55 08             	mov    0x8(%ebp),%edx
80002d34:	8b 5d 10             	mov    0x10(%ebp),%ebx
80002d37:	8b 7d 14             	mov    0x14(%ebp),%edi
80002d3a:	cd 30                	int    $0x30
80002d3c:	5b                   	pop    %ebx
80002d3d:	5e                   	pop    %esi
80002d3e:	5f                   	pop    %edi
80002d3f:	5d                   	pop    %ebp
80002d40:	c3                   	ret    

80002d41 <sys_ipc_recv>:
80002d41:	55                   	push   %ebp
80002d42:	89 e5                	mov    %esp,%ebp
80002d44:	57                   	push   %edi
80002d45:	56                   	push   %esi
80002d46:	53                   	push   %ebx
80002d47:	83 ec 0c             	sub    $0xc,%esp
80002d4a:	b9 00 00 00 00       	mov    $0x0,%ecx
80002d4f:	b8 0d 00 00 00       	mov    $0xd,%eax
80002d54:	8b 55 08             	mov    0x8(%ebp),%edx
80002d57:	89 cb                	mov    %ecx,%ebx
80002d59:	89 cf                	mov    %ecx,%edi
80002d5b:	89 ce                	mov    %ecx,%esi
80002d5d:	cd 30                	int    $0x30
80002d5f:	85 c0                	test   %eax,%eax
80002d61:	7e 17                	jle    80002d7a <sys_ipc_recv+0x39>
80002d63:	83 ec 0c             	sub    $0xc,%esp
80002d66:	50                   	push   %eax
80002d67:	6a 0d                	push   $0xd
80002d69:	68 f9 48 00 80       	push   $0x800048f9
80002d6e:	6a 21                	push   $0x21
80002d70:	68 16 49 00 80       	push   $0x80004916
80002d75:	e8 f1 0c 00 00       	call   80003a6b <_panic>
80002d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80002d7d:	5b                   	pop    %ebx
80002d7e:	5e                   	pop    %esi
80002d7f:	5f                   	pop    %edi
80002d80:	5d                   	pop    %ebp
80002d81:	c3                   	ret    

80002d82 <fsipc>:
80002d82:	55                   	push   %ebp
80002d83:	89 e5                	mov    %esp,%ebp
80002d85:	56                   	push   %esi
80002d86:	53                   	push   %ebx
80002d87:	89 c6                	mov    %eax,%esi
80002d89:	89 d3                	mov    %edx,%ebx
80002d8b:	83 3d 00 a0 00 80 00 	cmpl   $0x0,0x8000a000
80002d92:	75 12                	jne    80002da6 <fsipc+0x24>
80002d94:	83 ec 0c             	sub    $0xc,%esp
80002d97:	6a 01                	push   $0x1
80002d99:	e8 e1 03 00 00       	call   8000317f <ipc_find_env>
80002d9e:	a3 00 a0 00 80       	mov    %eax,0x8000a000
80002da3:	83 c4 10             	add    $0x10,%esp
80002da6:	6a 07                	push   $0x7
80002da8:	68 00 b0 00 80       	push   $0x8000b000
80002dad:	56                   	push   %esi
80002dae:	ff 35 00 a0 00 80    	pushl  0x8000a000
80002db4:	e8 72 03 00 00       	call   8000312b <ipc_send>
80002db9:	83 c4 0c             	add    $0xc,%esp
80002dbc:	6a 00                	push   $0x0
80002dbe:	53                   	push   %ebx
80002dbf:	6a 00                	push   $0x0
80002dc1:	e8 ea 02 00 00       	call   800030b0 <ipc_recv>
80002dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80002dc9:	5b                   	pop    %ebx
80002dca:	5e                   	pop    %esi
80002dcb:	5d                   	pop    %ebp
80002dcc:	c3                   	ret    

80002dcd <devfile_trunc>:
80002dcd:	55                   	push   %ebp
80002dce:	89 e5                	mov    %esp,%ebp
80002dd0:	83 ec 08             	sub    $0x8,%esp
80002dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80002dd6:	8b 40 0c             	mov    0xc(%eax),%eax
80002dd9:	a3 00 b0 00 80       	mov    %eax,0x8000b000
80002dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80002de1:	a3 04 b0 00 80       	mov    %eax,0x8000b004
80002de6:	ba 00 00 00 00       	mov    $0x0,%edx
80002deb:	b8 02 00 00 00       	mov    $0x2,%eax
80002df0:	e8 8d ff ff ff       	call   80002d82 <fsipc>
80002df5:	c9                   	leave  
80002df6:	c3                   	ret    

80002df7 <devfile_flush>:
80002df7:	55                   	push   %ebp
80002df8:	89 e5                	mov    %esp,%ebp
80002dfa:	83 ec 08             	sub    $0x8,%esp
80002dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80002e00:	8b 40 0c             	mov    0xc(%eax),%eax
80002e03:	a3 00 b0 00 80       	mov    %eax,0x8000b000
80002e08:	ba 00 00 00 00       	mov    $0x0,%edx
80002e0d:	b8 06 00 00 00       	mov    $0x6,%eax
80002e12:	e8 6b ff ff ff       	call   80002d82 <fsipc>
80002e17:	c9                   	leave  
80002e18:	c3                   	ret    

80002e19 <devfile_stat>:
80002e19:	55                   	push   %ebp
80002e1a:	89 e5                	mov    %esp,%ebp
80002e1c:	53                   	push   %ebx
80002e1d:	83 ec 04             	sub    $0x4,%esp
80002e20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80002e23:	8b 45 08             	mov    0x8(%ebp),%eax
80002e26:	8b 40 0c             	mov    0xc(%eax),%eax
80002e29:	a3 00 b0 00 80       	mov    %eax,0x8000b000
80002e2e:	ba 00 00 00 00       	mov    $0x0,%edx
80002e33:	b8 05 00 00 00       	mov    $0x5,%eax
80002e38:	e8 45 ff ff ff       	call   80002d82 <fsipc>
80002e3d:	89 c2                	mov    %eax,%edx
80002e3f:	85 d2                	test   %edx,%edx
80002e41:	78 26                	js     80002e69 <devfile_stat+0x50>
80002e43:	83 ec 08             	sub    $0x8,%esp
80002e46:	68 00 b0 00 80       	push   $0x8000b000
80002e4b:	53                   	push   %ebx
80002e4c:	e8 56 f8 ff ff       	call   800026a7 <strcpy>
80002e51:	a1 10 b0 00 80       	mov    0x8000b010,%eax
80002e56:	89 43 10             	mov    %eax,0x10(%ebx)
80002e59:	a1 14 b0 00 80       	mov    0x8000b014,%eax
80002e5e:	89 43 14             	mov    %eax,0x14(%ebx)
80002e61:	83 c4 10             	add    $0x10,%esp
80002e64:	b8 00 00 00 00       	mov    $0x0,%eax
80002e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002e6c:	c9                   	leave  
80002e6d:	c3                   	ret    

80002e6e <devfile_write>:
80002e6e:	55                   	push   %ebp
80002e6f:	89 e5                	mov    %esp,%ebp
80002e71:	83 ec 0c             	sub    $0xc,%esp
80002e74:	8b 45 10             	mov    0x10(%ebp),%eax
80002e77:	3d f8 0f 00 00       	cmp    $0xff8,%eax
80002e7c:	ba f8 0f 00 00       	mov    $0xff8,%edx
80002e81:	0f 47 c2             	cmova  %edx,%eax
80002e84:	8b 55 08             	mov    0x8(%ebp),%edx
80002e87:	8b 52 0c             	mov    0xc(%edx),%edx
80002e8a:	89 15 00 b0 00 80    	mov    %edx,0x8000b000
80002e90:	a3 04 b0 00 80       	mov    %eax,0x8000b004
80002e95:	50                   	push   %eax
80002e96:	ff 75 0c             	pushl  0xc(%ebp)
80002e99:	68 08 b0 00 80       	push   $0x8000b008
80002e9e:	e8 f3 f9 ff ff       	call   80002896 <memmove>
80002ea3:	ba 00 00 00 00       	mov    $0x0,%edx
80002ea8:	b8 04 00 00 00       	mov    $0x4,%eax
80002ead:	e8 d0 fe ff ff       	call   80002d82 <fsipc>
80002eb2:	c9                   	leave  
80002eb3:	c3                   	ret    

80002eb4 <devfile_read>:
80002eb4:	55                   	push   %ebp
80002eb5:	89 e5                	mov    %esp,%ebp
80002eb7:	53                   	push   %ebx
80002eb8:	83 ec 04             	sub    $0x4,%esp
80002ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80002ebe:	8b 40 0c             	mov    0xc(%eax),%eax
80002ec1:	a3 00 b0 00 80       	mov    %eax,0x8000b000
80002ec6:	8b 45 10             	mov    0x10(%ebp),%eax
80002ec9:	a3 04 b0 00 80       	mov    %eax,0x8000b004
80002ece:	ba 00 00 00 00       	mov    $0x0,%edx
80002ed3:	b8 03 00 00 00       	mov    $0x3,%eax
80002ed8:	e8 a5 fe ff ff       	call   80002d82 <fsipc>
80002edd:	89 c3                	mov    %eax,%ebx
80002edf:	85 c0                	test   %eax,%eax
80002ee1:	78 14                	js     80002ef7 <devfile_read+0x43>
80002ee3:	83 ec 04             	sub    $0x4,%esp
80002ee6:	50                   	push   %eax
80002ee7:	68 00 b0 00 80       	push   $0x8000b000
80002eec:	ff 75 0c             	pushl  0xc(%ebp)
80002eef:	e8 a2 f9 ff ff       	call   80002896 <memmove>
80002ef4:	83 c4 10             	add    $0x10,%esp
80002ef7:	89 d8                	mov    %ebx,%eax
80002ef9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002efc:	c9                   	leave  
80002efd:	c3                   	ret    

80002efe <open>:
80002efe:	55                   	push   %ebp
80002eff:	89 e5                	mov    %esp,%ebp
80002f01:	53                   	push   %ebx
80002f02:	83 ec 20             	sub    $0x20,%esp
80002f05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80002f08:	53                   	push   %ebx
80002f09:	e8 3e f7 ff ff       	call   8000264c <strlen>
80002f0e:	83 c4 10             	add    $0x10,%esp
80002f11:	83 f8 7f             	cmp    $0x7f,%eax
80002f14:	7f 67                	jg     80002f7d <open+0x7f>
80002f16:	83 ec 0c             	sub    $0xc,%esp
80002f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002f1c:	50                   	push   %eax
80002f1d:	e8 4c 0d 00 00       	call   80003c6e <fd_alloc>
80002f22:	83 c4 10             	add    $0x10,%esp
80002f25:	89 c2                	mov    %eax,%edx
80002f27:	85 c0                	test   %eax,%eax
80002f29:	78 57                	js     80002f82 <open+0x84>
80002f2b:	83 ec 08             	sub    $0x8,%esp
80002f2e:	53                   	push   %ebx
80002f2f:	68 00 b0 00 80       	push   $0x8000b000
80002f34:	e8 6e f7 ff ff       	call   800026a7 <strcpy>
80002f39:	8b 45 0c             	mov    0xc(%ebp),%eax
80002f3c:	a3 80 b0 00 80       	mov    %eax,0x8000b080
80002f41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80002f44:	b8 01 00 00 00       	mov    $0x1,%eax
80002f49:	e8 34 fe ff ff       	call   80002d82 <fsipc>
80002f4e:	89 c3                	mov    %eax,%ebx
80002f50:	83 c4 10             	add    $0x10,%esp
80002f53:	85 c0                	test   %eax,%eax
80002f55:	79 14                	jns    80002f6b <open+0x6d>
80002f57:	83 ec 08             	sub    $0x8,%esp
80002f5a:	6a 00                	push   $0x0
80002f5c:	ff 75 f4             	pushl  -0xc(%ebp)
80002f5f:	e8 42 0e 00 00       	call   80003da6 <fd_close>
80002f64:	83 c4 10             	add    $0x10,%esp
80002f67:	89 da                	mov    %ebx,%edx
80002f69:	eb 17                	jmp    80002f82 <open+0x84>
80002f6b:	83 ec 0c             	sub    $0xc,%esp
80002f6e:	ff 75 f4             	pushl  -0xc(%ebp)
80002f71:	e8 d0 0c 00 00       	call   80003c46 <fd2num>
80002f76:	89 c2                	mov    %eax,%edx
80002f78:	83 c4 10             	add    $0x10,%esp
80002f7b:	eb 05                	jmp    80002f82 <open+0x84>
80002f7d:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
80002f82:	89 d0                	mov    %edx,%eax
80002f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80002f87:	c9                   	leave  
80002f88:	c3                   	ret    

80002f89 <makedir>:
80002f89:	55                   	push   %ebp
80002f8a:	89 e5                	mov    %esp,%ebp
80002f8c:	53                   	push   %ebx
80002f8d:	83 ec 20             	sub    $0x20,%esp
80002f90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80002f93:	53                   	push   %ebx
80002f94:	e8 b3 f6 ff ff       	call   8000264c <strlen>
80002f99:	83 c4 10             	add    $0x10,%esp
80002f9c:	83 f8 7f             	cmp    $0x7f,%eax
80002f9f:	7f 64                	jg     80003005 <makedir+0x7c>
80002fa1:	83 ec 0c             	sub    $0xc,%esp
80002fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80002fa7:	50                   	push   %eax
80002fa8:	e8 c1 0c 00 00       	call   80003c6e <fd_alloc>
80002fad:	83 c4 10             	add    $0x10,%esp
80002fb0:	89 c2                	mov    %eax,%edx
80002fb2:	85 c0                	test   %eax,%eax
80002fb4:	78 54                	js     8000300a <makedir+0x81>
80002fb6:	83 ec 08             	sub    $0x8,%esp
80002fb9:	53                   	push   %ebx
80002fba:	68 00 b0 00 80       	push   $0x8000b000
80002fbf:	e8 e3 f6 ff ff       	call   800026a7 <strcpy>
80002fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80002fc7:	b8 07 00 00 00       	mov    $0x7,%eax
80002fcc:	e8 b1 fd ff ff       	call   80002d82 <fsipc>
80002fd1:	89 c3                	mov    %eax,%ebx
80002fd3:	83 c4 10             	add    $0x10,%esp
80002fd6:	85 c0                	test   %eax,%eax
80002fd8:	79 14                	jns    80002fee <makedir+0x65>
80002fda:	83 ec 08             	sub    $0x8,%esp
80002fdd:	6a 00                	push   $0x0
80002fdf:	ff 75 f4             	pushl  -0xc(%ebp)
80002fe2:	e8 bf 0d 00 00       	call   80003da6 <fd_close>
80002fe7:	83 c4 10             	add    $0x10,%esp
80002fea:	89 da                	mov    %ebx,%edx
80002fec:	eb 1c                	jmp    8000300a <makedir+0x81>
80002fee:	83 ec 08             	sub    $0x8,%esp
80002ff1:	6a 00                	push   $0x0
80002ff3:	ff 75 f4             	pushl  -0xc(%ebp)
80002ff6:	e8 ab 0d 00 00       	call   80003da6 <fd_close>
80002ffb:	83 c4 10             	add    $0x10,%esp
80002ffe:	ba 00 00 00 00       	mov    $0x0,%edx
80003003:	eb 05                	jmp    8000300a <makedir+0x81>
80003005:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
8000300a:	89 d0                	mov    %edx,%eax
8000300c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000300f:	c9                   	leave  
80003010:	c3                   	ret    

80003011 <remove>:
80003011:	55                   	push   %ebp
80003012:	89 e5                	mov    %esp,%ebp
80003014:	53                   	push   %ebx
80003015:	83 ec 20             	sub    $0x20,%esp
80003018:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000301b:	53                   	push   %ebx
8000301c:	e8 2b f6 ff ff       	call   8000264c <strlen>
80003021:	83 c4 10             	add    $0x10,%esp
80003024:	83 f8 7f             	cmp    $0x7f,%eax
80003027:	7f 64                	jg     8000308d <remove+0x7c>
80003029:	83 ec 0c             	sub    $0xc,%esp
8000302c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000302f:	50                   	push   %eax
80003030:	e8 39 0c 00 00       	call   80003c6e <fd_alloc>
80003035:	83 c4 10             	add    $0x10,%esp
80003038:	89 c2                	mov    %eax,%edx
8000303a:	85 c0                	test   %eax,%eax
8000303c:	78 54                	js     80003092 <remove+0x81>
8000303e:	83 ec 08             	sub    $0x8,%esp
80003041:	53                   	push   %ebx
80003042:	68 00 b0 00 80       	push   $0x8000b000
80003047:	e8 5b f6 ff ff       	call   800026a7 <strcpy>
8000304c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8000304f:	b8 08 00 00 00       	mov    $0x8,%eax
80003054:	e8 29 fd ff ff       	call   80002d82 <fsipc>
80003059:	89 c3                	mov    %eax,%ebx
8000305b:	83 c4 10             	add    $0x10,%esp
8000305e:	85 c0                	test   %eax,%eax
80003060:	79 14                	jns    80003076 <remove+0x65>
80003062:	83 ec 08             	sub    $0x8,%esp
80003065:	6a 00                	push   $0x0
80003067:	ff 75 f4             	pushl  -0xc(%ebp)
8000306a:	e8 37 0d 00 00       	call   80003da6 <fd_close>
8000306f:	83 c4 10             	add    $0x10,%esp
80003072:	89 da                	mov    %ebx,%edx
80003074:	eb 1c                	jmp    80003092 <remove+0x81>
80003076:	83 ec 08             	sub    $0x8,%esp
80003079:	6a 00                	push   $0x0
8000307b:	ff 75 f4             	pushl  -0xc(%ebp)
8000307e:	e8 23 0d 00 00       	call   80003da6 <fd_close>
80003083:	83 c4 10             	add    $0x10,%esp
80003086:	ba 00 00 00 00       	mov    $0x0,%edx
8000308b:	eb 05                	jmp    80003092 <remove+0x81>
8000308d:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
80003092:	89 d0                	mov    %edx,%eax
80003094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003097:	c9                   	leave  
80003098:	c3                   	ret    

80003099 <sync>:
80003099:	55                   	push   %ebp
8000309a:	89 e5                	mov    %esp,%ebp
8000309c:	83 ec 08             	sub    $0x8,%esp
8000309f:	ba 00 00 00 00       	mov    $0x0,%edx
800030a4:	b8 09 00 00 00       	mov    $0x9,%eax
800030a9:	e8 d4 fc ff ff       	call   80002d82 <fsipc>
800030ae:	c9                   	leave  
800030af:	c3                   	ret    

800030b0 <ipc_recv>:
800030b0:	55                   	push   %ebp
800030b1:	89 e5                	mov    %esp,%ebp
800030b3:	56                   	push   %esi
800030b4:	53                   	push   %ebx
800030b5:	8b 75 08             	mov    0x8(%ebp),%esi
800030b8:	8b 45 0c             	mov    0xc(%ebp),%eax
800030bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
800030be:	85 c0                	test   %eax,%eax
800030c0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
800030c5:	0f 44 c2             	cmove  %edx,%eax
800030c8:	83 ec 0c             	sub    $0xc,%esp
800030cb:	50                   	push   %eax
800030cc:	e8 70 fc ff ff       	call   80002d41 <sys_ipc_recv>
800030d1:	83 c4 10             	add    $0x10,%esp
800030d4:	85 c0                	test   %eax,%eax
800030d6:	79 16                	jns    800030ee <ipc_recv+0x3e>
800030d8:	85 f6                	test   %esi,%esi
800030da:	74 0c                	je     800030e8 <ipc_recv+0x38>
800030dc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
800030e2:	85 db                	test   %ebx,%ebx
800030e4:	75 26                	jne    8000310c <ipc_recv+0x5c>
800030e6:	eb 0a                	jmp    800030f2 <ipc_recv+0x42>
800030e8:	85 db                	test   %ebx,%ebx
800030ea:	75 28                	jne    80003114 <ipc_recv+0x64>
800030ec:	eb 2e                	jmp    8000311c <ipc_recv+0x6c>
800030ee:	85 f6                	test   %esi,%esi
800030f0:	74 0a                	je     800030fc <ipc_recv+0x4c>
800030f2:	a1 10 a6 00 80       	mov    0x8000a610,%eax
800030f7:	8b 40 74             	mov    0x74(%eax),%eax
800030fa:	89 06                	mov    %eax,(%esi)
800030fc:	85 db                	test   %ebx,%ebx
800030fe:	74 1c                	je     8000311c <ipc_recv+0x6c>
80003100:	a1 10 a6 00 80       	mov    0x8000a610,%eax
80003105:	8b 40 78             	mov    0x78(%eax),%eax
80003108:	89 03                	mov    %eax,(%ebx)
8000310a:	eb 10                	jmp    8000311c <ipc_recv+0x6c>
8000310c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80003112:	eb de                	jmp    800030f2 <ipc_recv+0x42>
80003114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8000311a:	eb e4                	jmp    80003100 <ipc_recv+0x50>
8000311c:	a1 10 a6 00 80       	mov    0x8000a610,%eax
80003121:	8b 40 70             	mov    0x70(%eax),%eax
80003124:	8d 65 f8             	lea    -0x8(%ebp),%esp
80003127:	5b                   	pop    %ebx
80003128:	5e                   	pop    %esi
80003129:	5d                   	pop    %ebp
8000312a:	c3                   	ret    

8000312b <ipc_send>:
8000312b:	55                   	push   %ebp
8000312c:	89 e5                	mov    %esp,%ebp
8000312e:	57                   	push   %edi
8000312f:	56                   	push   %esi
80003130:	53                   	push   %ebx
80003131:	83 ec 0c             	sub    $0xc,%esp
80003134:	8b 7d 08             	mov    0x8(%ebp),%edi
80003137:	8b 75 0c             	mov    0xc(%ebp),%esi
8000313a:	8b 5d 10             	mov    0x10(%ebp),%ebx
8000313d:	85 db                	test   %ebx,%ebx
8000313f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80003144:	0f 44 d8             	cmove  %eax,%ebx
80003147:	eb 1c                	jmp    80003165 <ipc_send+0x3a>
80003149:	83 f8 f9             	cmp    $0xfffffff9,%eax
8000314c:	74 12                	je     80003160 <ipc_send+0x35>
8000314e:	50                   	push   %eax
8000314f:	68 20 49 00 80       	push   $0x80004920
80003154:	6a 3f                	push   $0x3f
80003156:	68 2e 49 00 80       	push   $0x8000492e
8000315b:	e8 0b 09 00 00       	call   80003a6b <_panic>
80003160:	e8 0d fa ff ff       	call   80002b72 <sys_yield>
80003165:	ff 75 14             	pushl  0x14(%ebp)
80003168:	53                   	push   %ebx
80003169:	56                   	push   %esi
8000316a:	57                   	push   %edi
8000316b:	e8 ae fb ff ff       	call   80002d1e <sys_ipc_try_send>
80003170:	83 c4 10             	add    $0x10,%esp
80003173:	85 c0                	test   %eax,%eax
80003175:	75 d2                	jne    80003149 <ipc_send+0x1e>
80003177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000317a:	5b                   	pop    %ebx
8000317b:	5e                   	pop    %esi
8000317c:	5f                   	pop    %edi
8000317d:	5d                   	pop    %ebp
8000317e:	c3                   	ret    

8000317f <ipc_find_env>:
8000317f:	55                   	push   %ebp
80003180:	89 e5                	mov    %esp,%ebp
80003182:	8b 4d 08             	mov    0x8(%ebp),%ecx
80003185:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
8000318a:	39 c8                	cmp    %ecx,%eax
8000318c:	74 17                	je     800031a5 <ipc_find_env+0x26>
8000318e:	b8 01 00 00 00       	mov    $0x1,%eax
80003193:	6b d0 7c             	imul   $0x7c,%eax,%edx
80003196:	83 c2 50             	add    $0x50,%edx
80003199:	8b 92 00 00 c0 ee    	mov    -0x11400000(%edx),%edx
8000319f:	39 ca                	cmp    %ecx,%edx
800031a1:	75 14                	jne    800031b7 <ipc_find_env+0x38>
800031a3:	eb 05                	jmp    800031aa <ipc_find_env+0x2b>
800031a5:	b8 00 00 00 00       	mov    $0x0,%eax
800031aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
800031ad:	05 40 00 c0 ee       	add    $0xeec00040,%eax
800031b2:	8b 40 08             	mov    0x8(%eax),%eax
800031b5:	eb 0e                	jmp    800031c5 <ipc_find_env+0x46>
800031b7:	83 c0 01             	add    $0x1,%eax
800031ba:	3d 00 04 00 00       	cmp    $0x400,%eax
800031bf:	75 d2                	jne    80003193 <ipc_find_env+0x14>
800031c1:	66 b8 00 00          	mov    $0x0,%ax
800031c5:	5d                   	pop    %ebp
800031c6:	c3                   	ret    

800031c7 <exit>:
800031c7:	55                   	push   %ebp
800031c8:	89 e5                	mov    %esp,%ebp
800031ca:	83 ec 08             	sub    $0x8,%esp
800031cd:	e8 82 0c 00 00       	call   80003e54 <close_all>
800031d2:	83 ec 0c             	sub    $0xc,%esp
800031d5:	6a 00                	push   $0x0
800031d7:	e8 36 f9 ff ff       	call   80002b12 <sys_env_destroy>
800031dc:	83 c4 10             	add    $0x10,%esp
800031df:	c9                   	leave  
800031e0:	c3                   	ret    

800031e1 <pageref>:
800031e1:	55                   	push   %ebp
800031e2:	89 e5                	mov    %esp,%ebp
800031e4:	8b 55 08             	mov    0x8(%ebp),%edx
800031e7:	89 d0                	mov    %edx,%eax
800031e9:	c1 e8 16             	shr    $0x16,%eax
800031ec:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
800031f3:	b8 00 00 00 00       	mov    $0x0,%eax
800031f8:	f6 c1 01             	test   $0x1,%cl
800031fb:	74 1d                	je     8000321a <pageref+0x39>
800031fd:	c1 ea 0c             	shr    $0xc,%edx
80003200:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
80003207:	f6 c2 01             	test   $0x1,%dl
8000320a:	74 0e                	je     8000321a <pageref+0x39>
8000320c:	c1 ea 0c             	shr    $0xc,%edx
8000320f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
80003216:	ef 
80003217:	0f b7 c0             	movzwl %ax,%eax
8000321a:	5d                   	pop    %ebp
8000321b:	c3                   	ret    

8000321c <set_pgfault_handler>:
8000321c:	55                   	push   %ebp
8000321d:	89 e5                	mov    %esp,%ebp
8000321f:	83 ec 08             	sub    $0x8,%esp
80003222:	83 3d 00 c0 00 80 00 	cmpl   $0x0,0x8000c000
80003229:	75 52                	jne    8000327d <set_pgfault_handler+0x61>
8000322b:	83 ec 04             	sub    $0x4,%esp
8000322e:	6a 07                	push   $0x7
80003230:	68 00 f0 bf ee       	push   $0xeebff000
80003235:	6a 00                	push   $0x0
80003237:	e8 55 f9 ff ff       	call   80002b91 <sys_page_alloc>
8000323c:	83 c4 10             	add    $0x10,%esp
8000323f:	85 c0                	test   %eax,%eax
80003241:	79 12                	jns    80003255 <set_pgfault_handler+0x39>
80003243:	50                   	push   %eax
80003244:	68 34 49 00 80       	push   $0x80004934
80003249:	6a 1f                	push   $0x1f
8000324b:	68 4d 49 00 80       	push   $0x8000494d
80003250:	e8 16 08 00 00       	call   80003a6b <_panic>
80003255:	83 ec 08             	sub    $0x8,%esp
80003258:	68 ac 45 00 80       	push   $0x800045ac
8000325d:	6a 00                	push   $0x0
8000325f:	e8 78 fa ff ff       	call   80002cdc <sys_env_set_pgfault_upcall>
80003264:	83 c4 10             	add    $0x10,%esp
80003267:	85 c0                	test   %eax,%eax
80003269:	79 12                	jns    8000327d <set_pgfault_handler+0x61>
8000326b:	50                   	push   %eax
8000326c:	68 34 49 00 80       	push   $0x80004934
80003271:	6a 21                	push   $0x21
80003273:	68 4d 49 00 80       	push   $0x8000494d
80003278:	e8 ee 07 00 00       	call   80003a6b <_panic>
8000327d:	8b 45 08             	mov    0x8(%ebp),%eax
80003280:	a3 00 c0 00 80       	mov    %eax,0x8000c000
80003285:	c9                   	leave  
80003286:	c3                   	ret    

80003287 <getuint>:
80003287:	55                   	push   %ebp
80003288:	89 e5                	mov    %esp,%ebp
8000328a:	83 fa 01             	cmp    $0x1,%edx
8000328d:	7e 0e                	jle    8000329d <getuint+0x16>
8000328f:	8b 10                	mov    (%eax),%edx
80003291:	8d 4a 08             	lea    0x8(%edx),%ecx
80003294:	89 08                	mov    %ecx,(%eax)
80003296:	8b 02                	mov    (%edx),%eax
80003298:	8b 52 04             	mov    0x4(%edx),%edx
8000329b:	eb 22                	jmp    800032bf <getuint+0x38>
8000329d:	85 d2                	test   %edx,%edx
8000329f:	74 10                	je     800032b1 <getuint+0x2a>
800032a1:	8b 10                	mov    (%eax),%edx
800032a3:	8d 4a 04             	lea    0x4(%edx),%ecx
800032a6:	89 08                	mov    %ecx,(%eax)
800032a8:	8b 02                	mov    (%edx),%eax
800032aa:	ba 00 00 00 00       	mov    $0x0,%edx
800032af:	eb 0e                	jmp    800032bf <getuint+0x38>
800032b1:	8b 10                	mov    (%eax),%edx
800032b3:	8d 4a 04             	lea    0x4(%edx),%ecx
800032b6:	89 08                	mov    %ecx,(%eax)
800032b8:	8b 02                	mov    (%edx),%eax
800032ba:	ba 00 00 00 00       	mov    $0x0,%edx
800032bf:	5d                   	pop    %ebp
800032c0:	c3                   	ret    

800032c1 <printnum>:
800032c1:	55                   	push   %ebp
800032c2:	89 e5                	mov    %esp,%ebp
800032c4:	57                   	push   %edi
800032c5:	56                   	push   %esi
800032c6:	53                   	push   %ebx
800032c7:	83 ec 1c             	sub    $0x1c,%esp
800032ca:	89 c7                	mov    %eax,%edi
800032cc:	89 d6                	mov    %edx,%esi
800032ce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
800032d1:	3b 4d 08             	cmp    0x8(%ebp),%ecx
800032d4:	73 0c                	jae    800032e2 <printnum+0x21>
800032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
800032d9:	8d 58 ff             	lea    -0x1(%eax),%ebx
800032dc:	85 db                	test   %ebx,%ebx
800032de:	7f 2d                	jg     8000330d <printnum+0x4c>
800032e0:	eb 3c                	jmp    8000331e <printnum+0x5d>
800032e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
800032e5:	ba 00 00 00 00       	mov    $0x0,%edx
800032ea:	f7 75 08             	divl   0x8(%ebp)
800032ed:	89 c1                	mov    %eax,%ecx
800032ef:	83 ec 04             	sub    $0x4,%esp
800032f2:	ff 75 10             	pushl  0x10(%ebp)
800032f5:	8b 45 0c             	mov    0xc(%ebp),%eax
800032f8:	8d 50 ff             	lea    -0x1(%eax),%edx
800032fb:	52                   	push   %edx
800032fc:	ff 75 08             	pushl  0x8(%ebp)
800032ff:	89 f2                	mov    %esi,%edx
80003301:	89 f8                	mov    %edi,%eax
80003303:	e8 b9 ff ff ff       	call   800032c1 <printnum>
80003308:	83 c4 10             	add    $0x10,%esp
8000330b:	eb 11                	jmp    8000331e <printnum+0x5d>
8000330d:	83 ec 08             	sub    $0x8,%esp
80003310:	56                   	push   %esi
80003311:	ff 75 10             	pushl  0x10(%ebp)
80003314:	ff d7                	call   *%edi
80003316:	83 c4 10             	add    $0x10,%esp
80003319:	83 eb 01             	sub    $0x1,%ebx
8000331c:	75 ef                	jne    8000330d <printnum+0x4c>
8000331e:	83 ec 08             	sub    $0x8,%esp
80003321:	56                   	push   %esi
80003322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80003325:	ba 00 00 00 00       	mov    $0x0,%edx
8000332a:	f7 75 08             	divl   0x8(%ebp)
8000332d:	0f be 82 57 49 00 80 	movsbl -0x7fffb6a9(%edx),%eax
80003334:	50                   	push   %eax
80003335:	ff d7                	call   *%edi
80003337:	83 c4 10             	add    $0x10,%esp
8000333a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000333d:	5b                   	pop    %ebx
8000333e:	5e                   	pop    %esi
8000333f:	5f                   	pop    %edi
80003340:	5d                   	pop    %ebp
80003341:	c3                   	ret    

80003342 <sprintputch>:
80003342:	55                   	push   %ebp
80003343:	89 e5                	mov    %esp,%ebp
80003345:	8b 45 0c             	mov    0xc(%ebp),%eax
80003348:	83 40 08 01          	addl   $0x1,0x8(%eax)
8000334c:	8b 10                	mov    (%eax),%edx
8000334e:	3b 50 04             	cmp    0x4(%eax),%edx
80003351:	73 0a                	jae    8000335d <sprintputch+0x1b>
80003353:	8d 4a 01             	lea    0x1(%edx),%ecx
80003356:	89 08                	mov    %ecx,(%eax)
80003358:	8b 45 08             	mov    0x8(%ebp),%eax
8000335b:	88 02                	mov    %al,(%edx)
8000335d:	5d                   	pop    %ebp
8000335e:	c3                   	ret    

8000335f <putch>:
8000335f:	55                   	push   %ebp
80003360:	89 e5                	mov    %esp,%ebp
80003362:	53                   	push   %ebx
80003363:	83 ec 04             	sub    $0x4,%esp
80003366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80003369:	8b 13                	mov    (%ebx),%edx
8000336b:	8d 42 01             	lea    0x1(%edx),%eax
8000336e:	89 03                	mov    %eax,(%ebx)
80003370:	8b 4d 08             	mov    0x8(%ebp),%ecx
80003373:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
80003377:	3d ff 00 00 00       	cmp    $0xff,%eax
8000337c:	75 1a                	jne    80003398 <putch+0x39>
8000337e:	83 ec 08             	sub    $0x8,%esp
80003381:	68 ff 00 00 00       	push   $0xff
80003386:	8d 43 08             	lea    0x8(%ebx),%eax
80003389:	50                   	push   %eax
8000338a:	e8 46 f7 ff ff       	call   80002ad5 <sys_cputs>
8000338f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80003395:	83 c4 10             	add    $0x10,%esp
80003398:	83 43 04 01          	addl   $0x1,0x4(%ebx)
8000339c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8000339f:	c9                   	leave  
800033a0:	c3                   	ret    

800033a1 <writebuf>:
800033a1:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
800033a5:	7e 37                	jle    800033de <writebuf+0x3d>
800033a7:	55                   	push   %ebp
800033a8:	89 e5                	mov    %esp,%ebp
800033aa:	53                   	push   %ebx
800033ab:	83 ec 08             	sub    $0x8,%esp
800033ae:	89 c3                	mov    %eax,%ebx
800033b0:	ff 70 04             	pushl  0x4(%eax)
800033b3:	8d 40 10             	lea    0x10(%eax),%eax
800033b6:	50                   	push   %eax
800033b7:	ff 33                	pushl  (%ebx)
800033b9:	e8 8b 0c 00 00       	call   80004049 <write>
800033be:	83 c4 10             	add    $0x10,%esp
800033c1:	85 c0                	test   %eax,%eax
800033c3:	7e 03                	jle    800033c8 <writebuf+0x27>
800033c5:	01 43 08             	add    %eax,0x8(%ebx)
800033c8:	39 43 04             	cmp    %eax,0x4(%ebx)
800033cb:	74 0d                	je     800033da <writebuf+0x39>
800033cd:	85 c0                	test   %eax,%eax
800033cf:	ba 00 00 00 00       	mov    $0x0,%edx
800033d4:	0f 4f c2             	cmovg  %edx,%eax
800033d7:	89 43 0c             	mov    %eax,0xc(%ebx)
800033da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800033dd:	c9                   	leave  
800033de:	f3 c3                	repz ret 

800033e0 <fputch>:
800033e0:	55                   	push   %ebp
800033e1:	89 e5                	mov    %esp,%ebp
800033e3:	53                   	push   %ebx
800033e4:	83 ec 04             	sub    $0x4,%esp
800033e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
800033ea:	8b 53 04             	mov    0x4(%ebx),%edx
800033ed:	8d 42 01             	lea    0x1(%edx),%eax
800033f0:	89 43 04             	mov    %eax,0x4(%ebx)
800033f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
800033f6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
800033fa:	3d 00 01 00 00       	cmp    $0x100,%eax
800033ff:	75 0e                	jne    8000340f <fputch+0x2f>
80003401:	89 d8                	mov    %ebx,%eax
80003403:	e8 99 ff ff ff       	call   800033a1 <writebuf>
80003408:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
8000340f:	83 c4 04             	add    $0x4,%esp
80003412:	5b                   	pop    %ebx
80003413:	5d                   	pop    %ebp
80003414:	c3                   	ret    

80003415 <vprintfmt>:
80003415:	55                   	push   %ebp
80003416:	89 e5                	mov    %esp,%ebp
80003418:	57                   	push   %edi
80003419:	56                   	push   %esi
8000341a:	53                   	push   %ebx
8000341b:	83 ec 2c             	sub    $0x2c,%esp
8000341e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80003421:	eb 03                	jmp    80003426 <vprintfmt+0x11>
80003423:	89 75 10             	mov    %esi,0x10(%ebp)
80003426:	8b 45 10             	mov    0x10(%ebp),%eax
80003429:	8d 70 01             	lea    0x1(%eax),%esi
8000342c:	0f b6 00             	movzbl (%eax),%eax
8000342f:	83 f8 25             	cmp    $0x25,%eax
80003432:	74 2c                	je     80003460 <vprintfmt+0x4b>
80003434:	85 c0                	test   %eax,%eax
80003436:	75 0f                	jne    80003447 <vprintfmt+0x32>
80003438:	e9 b9 03 00 00       	jmp    800037f6 <vprintfmt+0x3e1>
8000343d:	85 c0                	test   %eax,%eax
8000343f:	0f 84 b1 03 00 00    	je     800037f6 <vprintfmt+0x3e1>
80003445:	eb 03                	jmp    8000344a <vprintfmt+0x35>
80003447:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000344a:	83 ec 08             	sub    $0x8,%esp
8000344d:	57                   	push   %edi
8000344e:	50                   	push   %eax
8000344f:	ff d3                	call   *%ebx
80003451:	83 c6 01             	add    $0x1,%esi
80003454:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80003458:	83 c4 10             	add    $0x10,%esp
8000345b:	83 f8 25             	cmp    $0x25,%eax
8000345e:	75 dd                	jne    8000343d <vprintfmt+0x28>
80003460:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
80003464:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
8000346b:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
80003472:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80003479:	ba 00 00 00 00       	mov    $0x0,%edx
8000347e:	bb 00 00 00 00       	mov    $0x0,%ebx
80003483:	eb 07                	jmp    8000348c <vprintfmt+0x77>
80003485:	8b 75 10             	mov    0x10(%ebp),%esi
80003488:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
8000348c:	8d 46 01             	lea    0x1(%esi),%eax
8000348f:	89 45 10             	mov    %eax,0x10(%ebp)
80003492:	0f b6 06             	movzbl (%esi),%eax
80003495:	0f b6 c8             	movzbl %al,%ecx
80003498:	83 e8 23             	sub    $0x23,%eax
8000349b:	3c 55                	cmp    $0x55,%al
8000349d:	0f 87 13 03 00 00    	ja     800037b6 <vprintfmt+0x3a1>
800034a3:	0f b6 c0             	movzbl %al,%eax
800034a6:	ff 24 85 00 4b 00 80 	jmp    *-0x7fffb500(,%eax,4)
800034ad:	8b 75 10             	mov    0x10(%ebp),%esi
800034b0:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
800034b4:	eb d6                	jmp    8000348c <vprintfmt+0x77>
800034b6:	8d 41 d0             	lea    -0x30(%ecx),%eax
800034b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
800034bc:	0f be 46 01          	movsbl 0x1(%esi),%eax
800034c0:	8d 48 d0             	lea    -0x30(%eax),%ecx
800034c3:	83 f9 09             	cmp    $0x9,%ecx
800034c6:	77 5b                	ja     80003523 <vprintfmt+0x10e>
800034c8:	8b 75 10             	mov    0x10(%ebp),%esi
800034cb:	89 55 d0             	mov    %edx,-0x30(%ebp)
800034ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
800034d1:	83 c6 01             	add    $0x1,%esi
800034d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
800034d7:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
800034db:	0f be 06             	movsbl (%esi),%eax
800034de:	8d 48 d0             	lea    -0x30(%eax),%ecx
800034e1:	83 f9 09             	cmp    $0x9,%ecx
800034e4:	76 eb                	jbe    800034d1 <vprintfmt+0xbc>
800034e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
800034e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
800034ec:	eb 38                	jmp    80003526 <vprintfmt+0x111>
800034ee:	8b 45 14             	mov    0x14(%ebp),%eax
800034f1:	8d 48 04             	lea    0x4(%eax),%ecx
800034f4:	89 4d 14             	mov    %ecx,0x14(%ebp)
800034f7:	8b 00                	mov    (%eax),%eax
800034f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
800034fc:	8b 75 10             	mov    0x10(%ebp),%esi
800034ff:	eb 25                	jmp    80003526 <vprintfmt+0x111>
80003501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80003504:	85 c0                	test   %eax,%eax
80003506:	0f 48 c3             	cmovs  %ebx,%eax
80003509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8000350c:	8b 75 10             	mov    0x10(%ebp),%esi
8000350f:	e9 78 ff ff ff       	jmp    8000348c <vprintfmt+0x77>
80003514:	8b 75 10             	mov    0x10(%ebp),%esi
80003517:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
8000351e:	e9 69 ff ff ff       	jmp    8000348c <vprintfmt+0x77>
80003523:	8b 75 10             	mov    0x10(%ebp),%esi
80003526:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8000352a:	0f 89 5c ff ff ff    	jns    8000348c <vprintfmt+0x77>
80003530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80003533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80003536:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
8000353d:	e9 4a ff ff ff       	jmp    8000348c <vprintfmt+0x77>
80003542:	83 c2 01             	add    $0x1,%edx
80003545:	8b 75 10             	mov    0x10(%ebp),%esi
80003548:	e9 3f ff ff ff       	jmp    8000348c <vprintfmt+0x77>
8000354d:	8b 45 14             	mov    0x14(%ebp),%eax
80003550:	8d 50 04             	lea    0x4(%eax),%edx
80003553:	89 55 14             	mov    %edx,0x14(%ebp)
80003556:	83 ec 08             	sub    $0x8,%esp
80003559:	57                   	push   %edi
8000355a:	ff 30                	pushl  (%eax)
8000355c:	ff 55 08             	call   *0x8(%ebp)
8000355f:	83 c4 10             	add    $0x10,%esp
80003562:	e9 bf fe ff ff       	jmp    80003426 <vprintfmt+0x11>
80003567:	8b 45 14             	mov    0x14(%ebp),%eax
8000356a:	8d 50 04             	lea    0x4(%eax),%edx
8000356d:	89 55 14             	mov    %edx,0x14(%ebp)
80003570:	8b 00                	mov    (%eax),%eax
80003572:	99                   	cltd   
80003573:	31 d0                	xor    %edx,%eax
80003575:	29 d0                	sub    %edx,%eax
80003577:	83 f8 11             	cmp    $0x11,%eax
8000357a:	7f 0b                	jg     80003587 <vprintfmt+0x172>
8000357c:	8b 14 85 80 4c 00 80 	mov    -0x7fffb380(,%eax,4),%edx
80003583:	85 d2                	test   %edx,%edx
80003585:	75 17                	jne    8000359e <vprintfmt+0x189>
80003587:	50                   	push   %eax
80003588:	68 6f 49 00 80       	push   $0x8000496f
8000358d:	57                   	push   %edi
8000358e:	ff 75 08             	pushl  0x8(%ebp)
80003591:	e8 69 03 00 00       	call   800038ff <printfmt>
80003596:	83 c4 10             	add    $0x10,%esp
80003599:	e9 88 fe ff ff       	jmp    80003426 <vprintfmt+0x11>
8000359e:	52                   	push   %edx
8000359f:	68 78 49 00 80       	push   $0x80004978
800035a4:	57                   	push   %edi
800035a5:	ff 75 08             	pushl  0x8(%ebp)
800035a8:	e8 52 03 00 00       	call   800038ff <printfmt>
800035ad:	83 c4 10             	add    $0x10,%esp
800035b0:	e9 71 fe ff ff       	jmp    80003426 <vprintfmt+0x11>
800035b5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
800035b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
800035bb:	8b 45 14             	mov    0x14(%ebp),%eax
800035be:	8d 50 04             	lea    0x4(%eax),%edx
800035c1:	89 55 14             	mov    %edx,0x14(%ebp)
800035c4:	8b 00                	mov    (%eax),%eax
800035c6:	85 c0                	test   %eax,%eax
800035c8:	ba 68 49 00 80       	mov    $0x80004968,%edx
800035cd:	0f 45 d0             	cmovne %eax,%edx
800035d0:	89 55 d0             	mov    %edx,-0x30(%ebp)
800035d3:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
800035d7:	74 04                	je     800035dd <vprintfmt+0x1c8>
800035d9:	85 f6                	test   %esi,%esi
800035db:	7f 16                	jg     800035f3 <vprintfmt+0x1de>
800035dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
800035e0:	8d 70 01             	lea    0x1(%eax),%esi
800035e3:	0f b6 00             	movzbl (%eax),%eax
800035e6:	0f be d0             	movsbl %al,%edx
800035e9:	85 d2                	test   %edx,%edx
800035eb:	0f 85 8c 00 00 00    	jne    8000367d <vprintfmt+0x268>
800035f1:	eb 7f                	jmp    80003672 <vprintfmt+0x25d>
800035f3:	83 ec 08             	sub    $0x8,%esp
800035f6:	51                   	push   %ecx
800035f7:	ff 75 d0             	pushl  -0x30(%ebp)
800035fa:	e8 6f f0 ff ff       	call   8000266e <strnlen>
800035ff:	29 c6                	sub    %eax,%esi
80003601:	89 f3                	mov    %esi,%ebx
80003603:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80003606:	83 c4 10             	add    $0x10,%esp
80003609:	85 f6                	test   %esi,%esi
8000360b:	0f 8e cc 01 00 00    	jle    800037dd <vprintfmt+0x3c8>
80003611:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
80003615:	83 ec 08             	sub    $0x8,%esp
80003618:	57                   	push   %edi
80003619:	56                   	push   %esi
8000361a:	ff 55 08             	call   *0x8(%ebp)
8000361d:	83 c4 10             	add    $0x10,%esp
80003620:	83 eb 01             	sub    $0x1,%ebx
80003623:	75 f0                	jne    80003615 <vprintfmt+0x200>
80003625:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80003628:	e9 b0 01 00 00       	jmp    800037dd <vprintfmt+0x3c8>
8000362d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80003631:	74 1b                	je     8000364e <vprintfmt+0x239>
80003633:	0f be c0             	movsbl %al,%eax
80003636:	83 e8 20             	sub    $0x20,%eax
80003639:	83 f8 5e             	cmp    $0x5e,%eax
8000363c:	76 10                	jbe    8000364e <vprintfmt+0x239>
8000363e:	83 ec 08             	sub    $0x8,%esp
80003641:	ff 75 0c             	pushl  0xc(%ebp)
80003644:	6a 3f                	push   $0x3f
80003646:	ff 55 08             	call   *0x8(%ebp)
80003649:	83 c4 10             	add    $0x10,%esp
8000364c:	eb 0d                	jmp    8000365b <vprintfmt+0x246>
8000364e:	83 ec 08             	sub    $0x8,%esp
80003651:	ff 75 0c             	pushl  0xc(%ebp)
80003654:	52                   	push   %edx
80003655:	ff 55 08             	call   *0x8(%ebp)
80003658:	83 c4 10             	add    $0x10,%esp
8000365b:	83 ef 01             	sub    $0x1,%edi
8000365e:	83 c6 01             	add    $0x1,%esi
80003661:	0f b6 46 ff          	movzbl -0x1(%esi),%eax
80003665:	0f be d0             	movsbl %al,%edx
80003668:	85 d2                	test   %edx,%edx
8000366a:	75 25                	jne    80003691 <vprintfmt+0x27c>
8000366c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8000366f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80003672:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80003676:	7f 2a                	jg     800036a2 <vprintfmt+0x28d>
80003678:	e9 a9 fd ff ff       	jmp    80003426 <vprintfmt+0x11>
8000367d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80003680:	89 7d 0c             	mov    %edi,0xc(%ebp)
80003683:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80003686:	eb 09                	jmp    80003691 <vprintfmt+0x27c>
80003688:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
8000368b:	89 7d 0c             	mov    %edi,0xc(%ebp)
8000368e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80003691:	85 db                	test   %ebx,%ebx
80003693:	78 98                	js     8000362d <vprintfmt+0x218>
80003695:	83 eb 01             	sub    $0x1,%ebx
80003698:	79 93                	jns    8000362d <vprintfmt+0x218>
8000369a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8000369d:	8b 7d 0c             	mov    0xc(%ebp),%edi
800036a0:	eb d0                	jmp    80003672 <vprintfmt+0x25d>
800036a2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
800036a5:	8b 75 08             	mov    0x8(%ebp),%esi
800036a8:	83 ec 08             	sub    $0x8,%esp
800036ab:	57                   	push   %edi
800036ac:	6a 20                	push   $0x20
800036ae:	ff d6                	call   *%esi
800036b0:	83 c4 10             	add    $0x10,%esp
800036b3:	83 eb 01             	sub    $0x1,%ebx
800036b6:	75 f0                	jne    800036a8 <vprintfmt+0x293>
800036b8:	e9 69 fd ff ff       	jmp    80003426 <vprintfmt+0x11>
800036bd:	83 fa 01             	cmp    $0x1,%edx
800036c0:	7e 16                	jle    800036d8 <vprintfmt+0x2c3>
800036c2:	8b 45 14             	mov    0x14(%ebp),%eax
800036c5:	8d 50 08             	lea    0x8(%eax),%edx
800036c8:	89 55 14             	mov    %edx,0x14(%ebp)
800036cb:	8b 50 04             	mov    0x4(%eax),%edx
800036ce:	8b 00                	mov    (%eax),%eax
800036d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
800036d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
800036d6:	eb 32                	jmp    8000370a <vprintfmt+0x2f5>
800036d8:	85 d2                	test   %edx,%edx
800036da:	74 18                	je     800036f4 <vprintfmt+0x2df>
800036dc:	8b 45 14             	mov    0x14(%ebp),%eax
800036df:	8d 50 04             	lea    0x4(%eax),%edx
800036e2:	89 55 14             	mov    %edx,0x14(%ebp)
800036e5:	8b 30                	mov    (%eax),%esi
800036e7:	89 75 d8             	mov    %esi,-0x28(%ebp)
800036ea:	89 f0                	mov    %esi,%eax
800036ec:	c1 f8 1f             	sar    $0x1f,%eax
800036ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
800036f2:	eb 16                	jmp    8000370a <vprintfmt+0x2f5>
800036f4:	8b 45 14             	mov    0x14(%ebp),%eax
800036f7:	8d 50 04             	lea    0x4(%eax),%edx
800036fa:	89 55 14             	mov    %edx,0x14(%ebp)
800036fd:	8b 30                	mov    (%eax),%esi
800036ff:	89 75 d8             	mov    %esi,-0x28(%ebp)
80003702:	89 f0                	mov    %esi,%eax
80003704:	c1 f8 1f             	sar    $0x1f,%eax
80003707:	89 45 dc             	mov    %eax,-0x24(%ebp)
8000370a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8000370d:	b8 0a 00 00 00       	mov    $0xa,%eax
80003712:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80003716:	79 70                	jns    80003788 <vprintfmt+0x373>
80003718:	83 ec 08             	sub    $0x8,%esp
8000371b:	57                   	push   %edi
8000371c:	6a 2d                	push   $0x2d
8000371e:	ff 55 08             	call   *0x8(%ebp)
80003721:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80003724:	f7 d9                	neg    %ecx
80003726:	83 c4 10             	add    $0x10,%esp
80003729:	b8 0a 00 00 00       	mov    $0xa,%eax
8000372e:	eb 58                	jmp    80003788 <vprintfmt+0x373>
80003730:	8d 45 14             	lea    0x14(%ebp),%eax
80003733:	e8 4f fb ff ff       	call   80003287 <getuint>
80003738:	89 c1                	mov    %eax,%ecx
8000373a:	b8 0a 00 00 00       	mov    $0xa,%eax
8000373f:	eb 47                	jmp    80003788 <vprintfmt+0x373>
80003741:	8d 45 14             	lea    0x14(%ebp),%eax
80003744:	e8 3e fb ff ff       	call   80003287 <getuint>
80003749:	89 c1                	mov    %eax,%ecx
8000374b:	b8 08 00 00 00       	mov    $0x8,%eax
80003750:	eb 36                	jmp    80003788 <vprintfmt+0x373>
80003752:	83 ec 08             	sub    $0x8,%esp
80003755:	57                   	push   %edi
80003756:	6a 30                	push   $0x30
80003758:	ff 55 08             	call   *0x8(%ebp)
8000375b:	83 c4 08             	add    $0x8,%esp
8000375e:	57                   	push   %edi
8000375f:	6a 78                	push   $0x78
80003761:	ff 55 08             	call   *0x8(%ebp)
80003764:	8b 45 14             	mov    0x14(%ebp),%eax
80003767:	8d 50 04             	lea    0x4(%eax),%edx
8000376a:	89 55 14             	mov    %edx,0x14(%ebp)
8000376d:	8b 08                	mov    (%eax),%ecx
8000376f:	83 c4 10             	add    $0x10,%esp
80003772:	b8 10 00 00 00       	mov    $0x10,%eax
80003777:	eb 0f                	jmp    80003788 <vprintfmt+0x373>
80003779:	8d 45 14             	lea    0x14(%ebp),%eax
8000377c:	e8 06 fb ff ff       	call   80003287 <getuint>
80003781:	89 c1                	mov    %eax,%ecx
80003783:	b8 10 00 00 00       	mov    $0x10,%eax
80003788:	83 ec 04             	sub    $0x4,%esp
8000378b:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
8000378f:	56                   	push   %esi
80003790:	ff 75 e4             	pushl  -0x1c(%ebp)
80003793:	50                   	push   %eax
80003794:	89 fa                	mov    %edi,%edx
80003796:	8b 45 08             	mov    0x8(%ebp),%eax
80003799:	e8 23 fb ff ff       	call   800032c1 <printnum>
8000379e:	83 c4 10             	add    $0x10,%esp
800037a1:	e9 80 fc ff ff       	jmp    80003426 <vprintfmt+0x11>
800037a6:	83 ec 08             	sub    $0x8,%esp
800037a9:	57                   	push   %edi
800037aa:	51                   	push   %ecx
800037ab:	ff 55 08             	call   *0x8(%ebp)
800037ae:	83 c4 10             	add    $0x10,%esp
800037b1:	e9 70 fc ff ff       	jmp    80003426 <vprintfmt+0x11>
800037b6:	83 ec 08             	sub    $0x8,%esp
800037b9:	57                   	push   %edi
800037ba:	6a 25                	push   $0x25
800037bc:	ff 55 08             	call   *0x8(%ebp)
800037bf:	83 c4 10             	add    $0x10,%esp
800037c2:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
800037c6:	0f 84 57 fc ff ff    	je     80003423 <vprintfmt+0xe>
800037cc:	83 ee 01             	sub    $0x1,%esi
800037cf:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
800037d3:	75 f7                	jne    800037cc <vprintfmt+0x3b7>
800037d5:	89 75 10             	mov    %esi,0x10(%ebp)
800037d8:	e9 49 fc ff ff       	jmp    80003426 <vprintfmt+0x11>
800037dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
800037e0:	8d 70 01             	lea    0x1(%eax),%esi
800037e3:	0f b6 00             	movzbl (%eax),%eax
800037e6:	0f be d0             	movsbl %al,%edx
800037e9:	85 d2                	test   %edx,%edx
800037eb:	0f 85 97 fe ff ff    	jne    80003688 <vprintfmt+0x273>
800037f1:	e9 30 fc ff ff       	jmp    80003426 <vprintfmt+0x11>
800037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
800037f9:	5b                   	pop    %ebx
800037fa:	5e                   	pop    %esi
800037fb:	5f                   	pop    %edi
800037fc:	5d                   	pop    %ebp
800037fd:	c3                   	ret    

800037fe <vcprintf>:
800037fe:	55                   	push   %ebp
800037ff:	89 e5                	mov    %esp,%ebp
80003801:	81 ec 18 01 00 00    	sub    $0x118,%esp
80003807:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8000380e:	00 00 00 
80003811:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80003818:	00 00 00 
8000381b:	ff 75 0c             	pushl  0xc(%ebp)
8000381e:	ff 75 08             	pushl  0x8(%ebp)
80003821:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
80003827:	50                   	push   %eax
80003828:	68 5f 33 00 80       	push   $0x8000335f
8000382d:	e8 e3 fb ff ff       	call   80003415 <vprintfmt>
80003832:	83 c4 08             	add    $0x8,%esp
80003835:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8000383b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
80003841:	50                   	push   %eax
80003842:	e8 8e f2 ff ff       	call   80002ad5 <sys_cputs>
80003847:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
8000384d:	c9                   	leave  
8000384e:	c3                   	ret    

8000384f <cprintf>:
8000384f:	55                   	push   %ebp
80003850:	89 e5                	mov    %esp,%ebp
80003852:	83 ec 10             	sub    $0x10,%esp
80003855:	8d 45 0c             	lea    0xc(%ebp),%eax
80003858:	50                   	push   %eax
80003859:	ff 75 08             	pushl  0x8(%ebp)
8000385c:	e8 9d ff ff ff       	call   800037fe <vcprintf>
80003861:	c9                   	leave  
80003862:	c3                   	ret    

80003863 <vfprintf>:
80003863:	55                   	push   %ebp
80003864:	89 e5                	mov    %esp,%ebp
80003866:	81 ec 18 01 00 00    	sub    $0x118,%esp
8000386c:	8b 45 08             	mov    0x8(%ebp),%eax
8000386f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80003875:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
8000387c:	00 00 00 
8000387f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80003886:	00 00 00 
80003889:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
80003890:	00 00 00 
80003893:	ff 75 10             	pushl  0x10(%ebp)
80003896:	ff 75 0c             	pushl  0xc(%ebp)
80003899:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
8000389f:	50                   	push   %eax
800038a0:	68 e0 33 00 80       	push   $0x800033e0
800038a5:	e8 6b fb ff ff       	call   80003415 <vprintfmt>
800038aa:	83 c4 10             	add    $0x10,%esp
800038ad:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
800038b4:	7e 0b                	jle    800038c1 <vfprintf+0x5e>
800038b6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
800038bc:	e8 e0 fa ff ff       	call   800033a1 <writebuf>
800038c1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
800038c7:	85 c0                	test   %eax,%eax
800038c9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
800038d0:	c9                   	leave  
800038d1:	c3                   	ret    

800038d2 <fprintf>:
800038d2:	55                   	push   %ebp
800038d3:	89 e5                	mov    %esp,%ebp
800038d5:	83 ec 0c             	sub    $0xc,%esp
800038d8:	8d 45 10             	lea    0x10(%ebp),%eax
800038db:	50                   	push   %eax
800038dc:	ff 75 0c             	pushl  0xc(%ebp)
800038df:	ff 75 08             	pushl  0x8(%ebp)
800038e2:	e8 7c ff ff ff       	call   80003863 <vfprintf>
800038e7:	c9                   	leave  
800038e8:	c3                   	ret    

800038e9 <printf>:
800038e9:	55                   	push   %ebp
800038ea:	89 e5                	mov    %esp,%ebp
800038ec:	83 ec 0c             	sub    $0xc,%esp
800038ef:	8d 45 0c             	lea    0xc(%ebp),%eax
800038f2:	50                   	push   %eax
800038f3:	ff 75 08             	pushl  0x8(%ebp)
800038f6:	6a 01                	push   $0x1
800038f8:	e8 66 ff ff ff       	call   80003863 <vfprintf>
800038fd:	c9                   	leave  
800038fe:	c3                   	ret    

800038ff <printfmt>:
800038ff:	55                   	push   %ebp
80003900:	89 e5                	mov    %esp,%ebp
80003902:	83 ec 08             	sub    $0x8,%esp
80003905:	8d 45 14             	lea    0x14(%ebp),%eax
80003908:	50                   	push   %eax
80003909:	ff 75 10             	pushl  0x10(%ebp)
8000390c:	ff 75 0c             	pushl  0xc(%ebp)
8000390f:	ff 75 08             	pushl  0x8(%ebp)
80003912:	e8 fe fa ff ff       	call   80003415 <vprintfmt>
80003917:	83 c4 10             	add    $0x10,%esp
8000391a:	c9                   	leave  
8000391b:	c3                   	ret    

8000391c <vsnprintf>:
8000391c:	55                   	push   %ebp
8000391d:	89 e5                	mov    %esp,%ebp
8000391f:	83 ec 18             	sub    $0x18,%esp
80003922:	8b 45 08             	mov    0x8(%ebp),%eax
80003925:	8b 55 0c             	mov    0xc(%ebp),%edx
80003928:	89 45 ec             	mov    %eax,-0x14(%ebp)
8000392b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
8000392f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80003932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80003939:	85 c0                	test   %eax,%eax
8000393b:	74 26                	je     80003963 <vsnprintf+0x47>
8000393d:	85 d2                	test   %edx,%edx
8000393f:	7e 22                	jle    80003963 <vsnprintf+0x47>
80003941:	ff 75 14             	pushl  0x14(%ebp)
80003944:	ff 75 10             	pushl  0x10(%ebp)
80003947:	8d 45 ec             	lea    -0x14(%ebp),%eax
8000394a:	50                   	push   %eax
8000394b:	68 42 33 00 80       	push   $0x80003342
80003950:	e8 c0 fa ff ff       	call   80003415 <vprintfmt>
80003955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80003958:	c6 00 00             	movb   $0x0,(%eax)
8000395b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8000395e:	83 c4 10             	add    $0x10,%esp
80003961:	eb 05                	jmp    80003968 <vsnprintf+0x4c>
80003963:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80003968:	c9                   	leave  
80003969:	c3                   	ret    

8000396a <snprintf>:
8000396a:	55                   	push   %ebp
8000396b:	89 e5                	mov    %esp,%ebp
8000396d:	83 ec 08             	sub    $0x8,%esp
80003970:	8d 45 14             	lea    0x14(%ebp),%eax
80003973:	50                   	push   %eax
80003974:	ff 75 10             	pushl  0x10(%ebp)
80003977:	ff 75 0c             	pushl  0xc(%ebp)
8000397a:	ff 75 08             	pushl  0x8(%ebp)
8000397d:	e8 9a ff ff ff       	call   8000391c <vsnprintf>
80003982:	c9                   	leave  
80003983:	c3                   	ret    

80003984 <readline>:
80003984:	55                   	push   %ebp
80003985:	89 e5                	mov    %esp,%ebp
80003987:	57                   	push   %edi
80003988:	56                   	push   %esi
80003989:	53                   	push   %ebx
8000398a:	83 ec 0c             	sub    $0xc,%esp
8000398d:	8b 45 08             	mov    0x8(%ebp),%eax
80003990:	85 c0                	test   %eax,%eax
80003992:	74 13                	je     800039a7 <readline+0x23>
80003994:	83 ec 04             	sub    $0x4,%esp
80003997:	50                   	push   %eax
80003998:	68 78 49 00 80       	push   $0x80004978
8000399d:	6a 01                	push   $0x1
8000399f:	e8 2e ff ff ff       	call   800038d2 <fprintf>
800039a4:	83 c4 10             	add    $0x10,%esp
800039a7:	83 ec 0c             	sub    $0xc,%esp
800039aa:	6a 00                	push   $0x0
800039ac:	e8 0f 02 00 00       	call   80003bc0 <iscons>
800039b1:	89 c7                	mov    %eax,%edi
800039b3:	83 c4 10             	add    $0x10,%esp
800039b6:	be 00 00 00 00       	mov    $0x0,%esi
800039bb:	e8 d5 01 00 00       	call   80003b95 <getchar>
800039c0:	89 c3                	mov    %eax,%ebx
800039c2:	85 c0                	test   %eax,%eax
800039c4:	79 26                	jns    800039ec <readline+0x68>
800039c6:	b8 00 00 00 00       	mov    $0x0,%eax
800039cb:	83 fb f8             	cmp    $0xfffffff8,%ebx
800039ce:	0f 84 8f 00 00 00    	je     80003a63 <readline+0xdf>
800039d4:	83 ec 08             	sub    $0x8,%esp
800039d7:	53                   	push   %ebx
800039d8:	68 7b 49 00 80       	push   $0x8000497b
800039dd:	e8 6d fe ff ff       	call   8000384f <cprintf>
800039e2:	83 c4 10             	add    $0x10,%esp
800039e5:	b8 00 00 00 00       	mov    $0x0,%eax
800039ea:	eb 77                	jmp    80003a63 <readline+0xdf>
800039ec:	83 f8 7f             	cmp    $0x7f,%eax
800039ef:	74 05                	je     800039f6 <readline+0x72>
800039f1:	83 f8 08             	cmp    $0x8,%eax
800039f4:	75 1a                	jne    80003a10 <readline+0x8c>
800039f6:	85 f6                	test   %esi,%esi
800039f8:	7e c1                	jle    800039bb <readline+0x37>
800039fa:	85 ff                	test   %edi,%edi
800039fc:	74 0d                	je     80003a0b <readline+0x87>
800039fe:	83 ec 0c             	sub    $0xc,%esp
80003a01:	6a 08                	push   $0x8
80003a03:	e8 71 01 00 00       	call   80003b79 <cputchar>
80003a08:	83 c4 10             	add    $0x10,%esp
80003a0b:	83 ee 01             	sub    $0x1,%esi
80003a0e:	eb ab                	jmp    800039bb <readline+0x37>
80003a10:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
80003a16:	7f 20                	jg     80003a38 <readline+0xb4>
80003a18:	83 f8 1f             	cmp    $0x1f,%eax
80003a1b:	7e 1b                	jle    80003a38 <readline+0xb4>
80003a1d:	85 ff                	test   %edi,%edi
80003a1f:	74 0c                	je     80003a2d <readline+0xa9>
80003a21:	83 ec 0c             	sub    $0xc,%esp
80003a24:	50                   	push   %eax
80003a25:	e8 4f 01 00 00       	call   80003b79 <cputchar>
80003a2a:	83 c4 10             	add    $0x10,%esp
80003a2d:	88 9e 40 a0 00 80    	mov    %bl,-0x7fff5fc0(%esi)
80003a33:	8d 76 01             	lea    0x1(%esi),%esi
80003a36:	eb 83                	jmp    800039bb <readline+0x37>
80003a38:	83 fb 0d             	cmp    $0xd,%ebx
80003a3b:	74 09                	je     80003a46 <readline+0xc2>
80003a3d:	83 fb 0a             	cmp    $0xa,%ebx
80003a40:	0f 85 75 ff ff ff    	jne    800039bb <readline+0x37>
80003a46:	85 ff                	test   %edi,%edi
80003a48:	74 0d                	je     80003a57 <readline+0xd3>
80003a4a:	83 ec 0c             	sub    $0xc,%esp
80003a4d:	6a 0a                	push   $0xa
80003a4f:	e8 25 01 00 00       	call   80003b79 <cputchar>
80003a54:	83 c4 10             	add    $0x10,%esp
80003a57:	c6 86 40 a0 00 80 00 	movb   $0x0,-0x7fff5fc0(%esi)
80003a5e:	b8 40 a0 00 80       	mov    $0x8000a040,%eax
80003a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003a66:	5b                   	pop    %ebx
80003a67:	5e                   	pop    %esi
80003a68:	5f                   	pop    %edi
80003a69:	5d                   	pop    %ebp
80003a6a:	c3                   	ret    

80003a6b <_panic>:
80003a6b:	55                   	push   %ebp
80003a6c:	89 e5                	mov    %esp,%ebp
80003a6e:	56                   	push   %esi
80003a6f:	53                   	push   %ebx
80003a70:	8d 5d 14             	lea    0x14(%ebp),%ebx
80003a73:	8b 35 94 90 00 80    	mov    0x80009094,%esi
80003a79:	e8 d5 f0 ff ff       	call   80002b53 <sys_getenvid>
80003a7e:	83 ec 0c             	sub    $0xc,%esp
80003a81:	ff 75 0c             	pushl  0xc(%ebp)
80003a84:	ff 75 08             	pushl  0x8(%ebp)
80003a87:	56                   	push   %esi
80003a88:	50                   	push   %eax
80003a89:	68 c8 4c 00 80       	push   $0x80004cc8
80003a8e:	e8 bc fd ff ff       	call   8000384f <cprintf>
80003a93:	83 c4 18             	add    $0x18,%esp
80003a96:	53                   	push   %ebx
80003a97:	ff 75 10             	pushl  0x10(%ebp)
80003a9a:	e8 5f fd ff ff       	call   800037fe <vcprintf>
80003a9f:	c7 04 24 da 46 00 80 	movl   $0x800046da,(%esp)
80003aa6:	e8 a4 fd ff ff       	call   8000384f <cprintf>
80003aab:	83 c4 10             	add    $0x10,%esp
80003aae:	cc                   	int3   
80003aaf:	eb fd                	jmp    80003aae <_panic+0x43>

80003ab1 <devcons_close>:
80003ab1:	55                   	push   %ebp
80003ab2:	89 e5                	mov    %esp,%ebp
80003ab4:	b8 00 00 00 00       	mov    $0x0,%eax
80003ab9:	5d                   	pop    %ebp
80003aba:	c3                   	ret    

80003abb <devcons_stat>:
80003abb:	55                   	push   %ebp
80003abc:	89 e5                	mov    %esp,%ebp
80003abe:	83 ec 10             	sub    $0x10,%esp
80003ac1:	68 0b 4d 00 80       	push   $0x80004d0b
80003ac6:	ff 75 0c             	pushl  0xc(%ebp)
80003ac9:	e8 d9 eb ff ff       	call   800026a7 <strcpy>
80003ace:	b8 00 00 00 00       	mov    $0x0,%eax
80003ad3:	c9                   	leave  
80003ad4:	c3                   	ret    

80003ad5 <devcons_write>:
80003ad5:	55                   	push   %ebp
80003ad6:	89 e5                	mov    %esp,%ebp
80003ad8:	57                   	push   %edi
80003ad9:	56                   	push   %esi
80003ada:	53                   	push   %ebx
80003adb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
80003ae1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80003ae5:	74 46                	je     80003b2d <devcons_write+0x58>
80003ae7:	b8 00 00 00 00       	mov    $0x0,%eax
80003aec:	be 00 00 00 00       	mov    $0x0,%esi
80003af1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80003af7:	8b 5d 10             	mov    0x10(%ebp),%ebx
80003afa:	29 c3                	sub    %eax,%ebx
80003afc:	83 fb 7f             	cmp    $0x7f,%ebx
80003aff:	ba 7f 00 00 00       	mov    $0x7f,%edx
80003b04:	0f 47 da             	cmova  %edx,%ebx
80003b07:	83 ec 04             	sub    $0x4,%esp
80003b0a:	53                   	push   %ebx
80003b0b:	03 45 0c             	add    0xc(%ebp),%eax
80003b0e:	50                   	push   %eax
80003b0f:	57                   	push   %edi
80003b10:	e8 81 ed ff ff       	call   80002896 <memmove>
80003b15:	83 c4 08             	add    $0x8,%esp
80003b18:	53                   	push   %ebx
80003b19:	57                   	push   %edi
80003b1a:	e8 b6 ef ff ff       	call   80002ad5 <sys_cputs>
80003b1f:	01 de                	add    %ebx,%esi
80003b21:	89 f0                	mov    %esi,%eax
80003b23:	83 c4 10             	add    $0x10,%esp
80003b26:	3b 75 10             	cmp    0x10(%ebp),%esi
80003b29:	72 cc                	jb     80003af7 <devcons_write+0x22>
80003b2b:	eb 05                	jmp    80003b32 <devcons_write+0x5d>
80003b2d:	be 00 00 00 00       	mov    $0x0,%esi
80003b32:	89 f0                	mov    %esi,%eax
80003b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003b37:	5b                   	pop    %ebx
80003b38:	5e                   	pop    %esi
80003b39:	5f                   	pop    %edi
80003b3a:	5d                   	pop    %ebp
80003b3b:	c3                   	ret    

80003b3c <devcons_read>:
80003b3c:	55                   	push   %ebp
80003b3d:	89 e5                	mov    %esp,%ebp
80003b3f:	83 ec 08             	sub    $0x8,%esp
80003b42:	b8 00 00 00 00       	mov    $0x0,%eax
80003b47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80003b4b:	75 07                	jne    80003b54 <devcons_read+0x18>
80003b4d:	eb 28                	jmp    80003b77 <devcons_read+0x3b>
80003b4f:	e8 1e f0 ff ff       	call   80002b72 <sys_yield>
80003b54:	e8 9a ef ff ff       	call   80002af3 <sys_cgetc>
80003b59:	85 c0                	test   %eax,%eax
80003b5b:	74 f2                	je     80003b4f <devcons_read+0x13>
80003b5d:	85 c0                	test   %eax,%eax
80003b5f:	78 16                	js     80003b77 <devcons_read+0x3b>
80003b61:	83 f8 04             	cmp    $0x4,%eax
80003b64:	74 0c                	je     80003b72 <devcons_read+0x36>
80003b66:	8b 55 0c             	mov    0xc(%ebp),%edx
80003b69:	88 02                	mov    %al,(%edx)
80003b6b:	b8 01 00 00 00       	mov    $0x1,%eax
80003b70:	eb 05                	jmp    80003b77 <devcons_read+0x3b>
80003b72:	b8 00 00 00 00       	mov    $0x0,%eax
80003b77:	c9                   	leave  
80003b78:	c3                   	ret    

80003b79 <cputchar>:
80003b79:	55                   	push   %ebp
80003b7a:	89 e5                	mov    %esp,%ebp
80003b7c:	83 ec 20             	sub    $0x20,%esp
80003b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80003b82:	88 45 f7             	mov    %al,-0x9(%ebp)
80003b85:	6a 01                	push   $0x1
80003b87:	8d 45 f7             	lea    -0x9(%ebp),%eax
80003b8a:	50                   	push   %eax
80003b8b:	e8 45 ef ff ff       	call   80002ad5 <sys_cputs>
80003b90:	83 c4 10             	add    $0x10,%esp
80003b93:	c9                   	leave  
80003b94:	c3                   	ret    

80003b95 <getchar>:
80003b95:	55                   	push   %ebp
80003b96:	89 e5                	mov    %esp,%ebp
80003b98:	83 ec 1c             	sub    $0x1c,%esp
80003b9b:	6a 01                	push   $0x1
80003b9d:	8d 45 f7             	lea    -0x9(%ebp),%eax
80003ba0:	50                   	push   %eax
80003ba1:	6a 00                	push   $0x0
80003ba3:	e8 bd 03 00 00       	call   80003f65 <read>
80003ba8:	83 c4 10             	add    $0x10,%esp
80003bab:	85 c0                	test   %eax,%eax
80003bad:	78 0f                	js     80003bbe <getchar+0x29>
80003baf:	85 c0                	test   %eax,%eax
80003bb1:	7e 06                	jle    80003bb9 <getchar+0x24>
80003bb3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80003bb7:	eb 05                	jmp    80003bbe <getchar+0x29>
80003bb9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
80003bbe:	c9                   	leave  
80003bbf:	c3                   	ret    

80003bc0 <iscons>:
80003bc0:	55                   	push   %ebp
80003bc1:	89 e5                	mov    %esp,%ebp
80003bc3:	83 ec 20             	sub    $0x20,%esp
80003bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80003bc9:	50                   	push   %eax
80003bca:	ff 75 08             	pushl  0x8(%ebp)
80003bcd:	e8 10 01 00 00       	call   80003ce2 <fd_lookup>
80003bd2:	83 c4 10             	add    $0x10,%esp
80003bd5:	85 c0                	test   %eax,%eax
80003bd7:	78 11                	js     80003bea <iscons+0x2a>
80003bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003bdc:	8b 15 b4 90 00 80    	mov    0x800090b4,%edx
80003be2:	39 10                	cmp    %edx,(%eax)
80003be4:	0f 94 c0             	sete   %al
80003be7:	0f b6 c0             	movzbl %al,%eax
80003bea:	c9                   	leave  
80003beb:	c3                   	ret    

80003bec <opencons>:
80003bec:	55                   	push   %ebp
80003bed:	89 e5                	mov    %esp,%ebp
80003bef:	83 ec 24             	sub    $0x24,%esp
80003bf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80003bf5:	50                   	push   %eax
80003bf6:	e8 73 00 00 00       	call   80003c6e <fd_alloc>
80003bfb:	83 c4 10             	add    $0x10,%esp
80003bfe:	89 c2                	mov    %eax,%edx
80003c00:	85 c0                	test   %eax,%eax
80003c02:	78 3e                	js     80003c42 <opencons+0x56>
80003c04:	83 ec 04             	sub    $0x4,%esp
80003c07:	68 07 04 00 00       	push   $0x407
80003c0c:	ff 75 f4             	pushl  -0xc(%ebp)
80003c0f:	6a 00                	push   $0x0
80003c11:	e8 7b ef ff ff       	call   80002b91 <sys_page_alloc>
80003c16:	83 c4 10             	add    $0x10,%esp
80003c19:	89 c2                	mov    %eax,%edx
80003c1b:	85 c0                	test   %eax,%eax
80003c1d:	78 23                	js     80003c42 <opencons+0x56>
80003c1f:	8b 15 b4 90 00 80    	mov    0x800090b4,%edx
80003c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003c28:	89 10                	mov    %edx,(%eax)
80003c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003c2d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
80003c34:	83 ec 0c             	sub    $0xc,%esp
80003c37:	50                   	push   %eax
80003c38:	e8 09 00 00 00       	call   80003c46 <fd2num>
80003c3d:	89 c2                	mov    %eax,%edx
80003c3f:	83 c4 10             	add    $0x10,%esp
80003c42:	89 d0                	mov    %edx,%eax
80003c44:	c9                   	leave  
80003c45:	c3                   	ret    

80003c46 <fd2num>:
80003c46:	55                   	push   %ebp
80003c47:	89 e5                	mov    %esp,%ebp
80003c49:	8b 45 08             	mov    0x8(%ebp),%eax
80003c4c:	2d 00 00 00 20       	sub    $0x20000000,%eax
80003c51:	c1 e8 0c             	shr    $0xc,%eax
80003c54:	5d                   	pop    %ebp
80003c55:	c3                   	ret    

80003c56 <fd2data>:
80003c56:	55                   	push   %ebp
80003c57:	89 e5                	mov    %esp,%ebp
80003c59:	8b 45 08             	mov    0x8(%ebp),%eax
80003c5c:	2d 00 00 00 20       	sub    $0x20000000,%eax
80003c61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80003c66:	8d 80 00 00 02 20    	lea    0x20020000(%eax),%eax
80003c6c:	5d                   	pop    %ebp
80003c6d:	c3                   	ret    

80003c6e <fd_alloc>:
80003c6e:	55                   	push   %ebp
80003c6f:	89 e5                	mov    %esp,%ebp
80003c71:	a1 00 d2 7b ef       	mov    0xef7bd200,%eax
80003c76:	a8 01                	test   $0x1,%al
80003c78:	74 34                	je     80003cae <fd_alloc+0x40>
80003c7a:	a1 00 00 48 ef       	mov    0xef480000,%eax
80003c7f:	a8 01                	test   $0x1,%al
80003c81:	74 32                	je     80003cb5 <fd_alloc+0x47>
80003c83:	b8 00 10 00 20       	mov    $0x20001000,%eax
80003c88:	89 c1                	mov    %eax,%ecx
80003c8a:	89 c2                	mov    %eax,%edx
80003c8c:	c1 ea 16             	shr    $0x16,%edx
80003c8f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
80003c96:	f6 c2 01             	test   $0x1,%dl
80003c99:	74 1f                	je     80003cba <fd_alloc+0x4c>
80003c9b:	89 c2                	mov    %eax,%edx
80003c9d:	c1 ea 0c             	shr    $0xc,%edx
80003ca0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
80003ca7:	f6 c2 01             	test   $0x1,%dl
80003caa:	75 1a                	jne    80003cc6 <fd_alloc+0x58>
80003cac:	eb 0c                	jmp    80003cba <fd_alloc+0x4c>
80003cae:	b9 00 00 00 20       	mov    $0x20000000,%ecx
80003cb3:	eb 05                	jmp    80003cba <fd_alloc+0x4c>
80003cb5:	b9 00 00 00 20       	mov    $0x20000000,%ecx
80003cba:	8b 45 08             	mov    0x8(%ebp),%eax
80003cbd:	89 08                	mov    %ecx,(%eax)
80003cbf:	b8 00 00 00 00       	mov    $0x0,%eax
80003cc4:	eb 1a                	jmp    80003ce0 <fd_alloc+0x72>
80003cc6:	05 00 10 00 00       	add    $0x1000,%eax
80003ccb:	3d 00 00 02 20       	cmp    $0x20020000,%eax
80003cd0:	75 b6                	jne    80003c88 <fd_alloc+0x1a>
80003cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80003cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80003cdb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
80003ce0:	5d                   	pop    %ebp
80003ce1:	c3                   	ret    

80003ce2 <fd_lookup>:
80003ce2:	55                   	push   %ebp
80003ce3:	89 e5                	mov    %esp,%ebp
80003ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80003ce8:	83 f8 1f             	cmp    $0x1f,%eax
80003ceb:	77 36                	ja     80003d23 <fd_lookup+0x41>
80003ced:	05 00 00 02 00       	add    $0x20000,%eax
80003cf2:	c1 e0 0c             	shl    $0xc,%eax
80003cf5:	89 c2                	mov    %eax,%edx
80003cf7:	c1 ea 16             	shr    $0x16,%edx
80003cfa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
80003d01:	f6 c2 01             	test   $0x1,%dl
80003d04:	74 24                	je     80003d2a <fd_lookup+0x48>
80003d06:	89 c2                	mov    %eax,%edx
80003d08:	c1 ea 0c             	shr    $0xc,%edx
80003d0b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
80003d12:	f6 c2 01             	test   $0x1,%dl
80003d15:	74 1a                	je     80003d31 <fd_lookup+0x4f>
80003d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80003d1a:	89 02                	mov    %eax,(%edx)
80003d1c:	b8 00 00 00 00       	mov    $0x0,%eax
80003d21:	eb 13                	jmp    80003d36 <fd_lookup+0x54>
80003d23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80003d28:	eb 0c                	jmp    80003d36 <fd_lookup+0x54>
80003d2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80003d2f:	eb 05                	jmp    80003d36 <fd_lookup+0x54>
80003d31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80003d36:	5d                   	pop    %ebp
80003d37:	c3                   	ret    

80003d38 <dev_lookup>:
80003d38:	55                   	push   %ebp
80003d39:	89 e5                	mov    %esp,%ebp
80003d3b:	53                   	push   %ebx
80003d3c:	83 ec 04             	sub    $0x4,%esp
80003d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80003d42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80003d45:	39 05 98 90 00 80    	cmp    %eax,0x80009098
80003d4b:	75 1e                	jne    80003d6b <dev_lookup+0x33>
80003d4d:	eb 0e                	jmp    80003d5d <dev_lookup+0x25>
80003d4f:	b8 d0 90 00 80       	mov    $0x800090d0,%eax
80003d54:	eb 0c                	jmp    80003d62 <dev_lookup+0x2a>
80003d56:	b8 b4 90 00 80       	mov    $0x800090b4,%eax
80003d5b:	eb 05                	jmp    80003d62 <dev_lookup+0x2a>
80003d5d:	b8 98 90 00 80       	mov    $0x80009098,%eax
80003d62:	89 03                	mov    %eax,(%ebx)
80003d64:	b8 00 00 00 00       	mov    $0x0,%eax
80003d69:	eb 36                	jmp    80003da1 <dev_lookup+0x69>
80003d6b:	39 05 d0 90 00 80    	cmp    %eax,0x800090d0
80003d71:	74 dc                	je     80003d4f <dev_lookup+0x17>
80003d73:	39 05 b4 90 00 80    	cmp    %eax,0x800090b4
80003d79:	74 db                	je     80003d56 <dev_lookup+0x1e>
80003d7b:	8b 15 10 a6 00 80    	mov    0x8000a610,%edx
80003d81:	8b 52 48             	mov    0x48(%edx),%edx
80003d84:	83 ec 04             	sub    $0x4,%esp
80003d87:	50                   	push   %eax
80003d88:	52                   	push   %edx
80003d89:	68 18 4d 00 80       	push   $0x80004d18
80003d8e:	e8 bc fa ff ff       	call   8000384f <cprintf>
80003d93:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80003d99:	83 c4 10             	add    $0x10,%esp
80003d9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80003da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003da4:	c9                   	leave  
80003da5:	c3                   	ret    

80003da6 <fd_close>:
80003da6:	55                   	push   %ebp
80003da7:	89 e5                	mov    %esp,%ebp
80003da9:	56                   	push   %esi
80003daa:	53                   	push   %ebx
80003dab:	83 ec 10             	sub    $0x10,%esp
80003dae:	8b 75 08             	mov    0x8(%ebp),%esi
80003db1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80003db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80003db7:	50                   	push   %eax
80003db8:	8d 86 00 00 00 e0    	lea    -0x20000000(%esi),%eax
80003dbe:	c1 e8 0c             	shr    $0xc,%eax
80003dc1:	50                   	push   %eax
80003dc2:	e8 1b ff ff ff       	call   80003ce2 <fd_lookup>
80003dc7:	83 c4 08             	add    $0x8,%esp
80003dca:	85 c0                	test   %eax,%eax
80003dcc:	78 05                	js     80003dd3 <fd_close+0x2d>
80003dce:	3b 75 f4             	cmp    -0xc(%ebp),%esi
80003dd1:	74 0c                	je     80003ddf <fd_close+0x39>
80003dd3:	84 db                	test   %bl,%bl
80003dd5:	ba 00 00 00 00       	mov    $0x0,%edx
80003dda:	0f 44 c2             	cmove  %edx,%eax
80003ddd:	eb 41                	jmp    80003e20 <fd_close+0x7a>
80003ddf:	83 ec 08             	sub    $0x8,%esp
80003de2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80003de5:	50                   	push   %eax
80003de6:	ff 36                	pushl  (%esi)
80003de8:	e8 4b ff ff ff       	call   80003d38 <dev_lookup>
80003ded:	89 c3                	mov    %eax,%ebx
80003def:	83 c4 10             	add    $0x10,%esp
80003df2:	85 c0                	test   %eax,%eax
80003df4:	78 1a                	js     80003e10 <fd_close+0x6a>
80003df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80003df9:	8b 40 10             	mov    0x10(%eax),%eax
80003dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
80003e01:	85 c0                	test   %eax,%eax
80003e03:	74 0b                	je     80003e10 <fd_close+0x6a>
80003e05:	83 ec 0c             	sub    $0xc,%esp
80003e08:	56                   	push   %esi
80003e09:	ff d0                	call   *%eax
80003e0b:	89 c3                	mov    %eax,%ebx
80003e0d:	83 c4 10             	add    $0x10,%esp
80003e10:	83 ec 08             	sub    $0x8,%esp
80003e13:	56                   	push   %esi
80003e14:	6a 00                	push   $0x0
80003e16:	e8 fb ed ff ff       	call   80002c16 <sys_page_unmap>
80003e1b:	83 c4 10             	add    $0x10,%esp
80003e1e:	89 d8                	mov    %ebx,%eax
80003e20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80003e23:	5b                   	pop    %ebx
80003e24:	5e                   	pop    %esi
80003e25:	5d                   	pop    %ebp
80003e26:	c3                   	ret    

80003e27 <close>:
80003e27:	55                   	push   %ebp
80003e28:	89 e5                	mov    %esp,%ebp
80003e2a:	83 ec 18             	sub    $0x18,%esp
80003e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80003e30:	50                   	push   %eax
80003e31:	ff 75 08             	pushl  0x8(%ebp)
80003e34:	e8 a9 fe ff ff       	call   80003ce2 <fd_lookup>
80003e39:	89 c2                	mov    %eax,%edx
80003e3b:	83 c4 08             	add    $0x8,%esp
80003e3e:	85 d2                	test   %edx,%edx
80003e40:	78 10                	js     80003e52 <close+0x2b>
80003e42:	83 ec 08             	sub    $0x8,%esp
80003e45:	6a 01                	push   $0x1
80003e47:	ff 75 f4             	pushl  -0xc(%ebp)
80003e4a:	e8 57 ff ff ff       	call   80003da6 <fd_close>
80003e4f:	83 c4 10             	add    $0x10,%esp
80003e52:	c9                   	leave  
80003e53:	c3                   	ret    

80003e54 <close_all>:
80003e54:	55                   	push   %ebp
80003e55:	89 e5                	mov    %esp,%ebp
80003e57:	53                   	push   %ebx
80003e58:	83 ec 04             	sub    $0x4,%esp
80003e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
80003e60:	83 ec 0c             	sub    $0xc,%esp
80003e63:	53                   	push   %ebx
80003e64:	e8 be ff ff ff       	call   80003e27 <close>
80003e69:	83 c3 01             	add    $0x1,%ebx
80003e6c:	83 c4 10             	add    $0x10,%esp
80003e6f:	83 fb 20             	cmp    $0x20,%ebx
80003e72:	75 ec                	jne    80003e60 <close_all+0xc>
80003e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003e77:	c9                   	leave  
80003e78:	c3                   	ret    

80003e79 <dup>:
80003e79:	55                   	push   %ebp
80003e7a:	89 e5                	mov    %esp,%ebp
80003e7c:	57                   	push   %edi
80003e7d:	56                   	push   %esi
80003e7e:	53                   	push   %ebx
80003e7f:	83 ec 2c             	sub    $0x2c,%esp
80003e82:	8b 75 0c             	mov    0xc(%ebp),%esi
80003e85:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80003e88:	50                   	push   %eax
80003e89:	ff 75 08             	pushl  0x8(%ebp)
80003e8c:	e8 51 fe ff ff       	call   80003ce2 <fd_lookup>
80003e91:	89 c2                	mov    %eax,%edx
80003e93:	83 c4 08             	add    $0x8,%esp
80003e96:	85 d2                	test   %edx,%edx
80003e98:	0f 88 bf 00 00 00    	js     80003f5d <dup+0xe4>
80003e9e:	83 ec 0c             	sub    $0xc,%esp
80003ea1:	56                   	push   %esi
80003ea2:	e8 80 ff ff ff       	call   80003e27 <close>
80003ea7:	8d 9e 00 00 02 00    	lea    0x20000(%esi),%ebx
80003ead:	c1 e3 0c             	shl    $0xc,%ebx
80003eb0:	83 c4 04             	add    $0x4,%esp
80003eb3:	ff 75 e4             	pushl  -0x1c(%ebp)
80003eb6:	e8 9b fd ff ff       	call   80003c56 <fd2data>
80003ebb:	89 c7                	mov    %eax,%edi
80003ebd:	89 1c 24             	mov    %ebx,(%esp)
80003ec0:	e8 91 fd ff ff       	call   80003c56 <fd2data>
80003ec5:	83 c4 10             	add    $0x10,%esp
80003ec8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80003ecb:	89 f8                	mov    %edi,%eax
80003ecd:	c1 e8 16             	shr    $0x16,%eax
80003ed0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
80003ed7:	a8 01                	test   $0x1,%al
80003ed9:	74 37                	je     80003f12 <dup+0x99>
80003edb:	89 f8                	mov    %edi,%eax
80003edd:	c1 e8 0c             	shr    $0xc,%eax
80003ee0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
80003ee7:	f6 c2 01             	test   $0x1,%dl
80003eea:	74 26                	je     80003f12 <dup+0x99>
80003eec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80003ef3:	83 ec 0c             	sub    $0xc,%esp
80003ef6:	25 07 0e 00 00       	and    $0xe07,%eax
80003efb:	50                   	push   %eax
80003efc:	ff 75 d4             	pushl  -0x2c(%ebp)
80003eff:	6a 00                	push   $0x0
80003f01:	57                   	push   %edi
80003f02:	6a 00                	push   $0x0
80003f04:	e8 cb ec ff ff       	call   80002bd4 <sys_page_map>
80003f09:	89 c7                	mov    %eax,%edi
80003f0b:	83 c4 20             	add    $0x20,%esp
80003f0e:	85 c0                	test   %eax,%eax
80003f10:	78 2e                	js     80003f40 <dup+0xc7>
80003f12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80003f15:	89 d0                	mov    %edx,%eax
80003f17:	c1 e8 0c             	shr    $0xc,%eax
80003f1a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
80003f21:	83 ec 0c             	sub    $0xc,%esp
80003f24:	25 07 0e 00 00       	and    $0xe07,%eax
80003f29:	50                   	push   %eax
80003f2a:	53                   	push   %ebx
80003f2b:	6a 00                	push   $0x0
80003f2d:	52                   	push   %edx
80003f2e:	6a 00                	push   $0x0
80003f30:	e8 9f ec ff ff       	call   80002bd4 <sys_page_map>
80003f35:	89 c7                	mov    %eax,%edi
80003f37:	83 c4 20             	add    $0x20,%esp
80003f3a:	89 f0                	mov    %esi,%eax
80003f3c:	85 ff                	test   %edi,%edi
80003f3e:	79 1d                	jns    80003f5d <dup+0xe4>
80003f40:	83 ec 08             	sub    $0x8,%esp
80003f43:	53                   	push   %ebx
80003f44:	6a 00                	push   $0x0
80003f46:	e8 cb ec ff ff       	call   80002c16 <sys_page_unmap>
80003f4b:	83 c4 08             	add    $0x8,%esp
80003f4e:	ff 75 d4             	pushl  -0x2c(%ebp)
80003f51:	6a 00                	push   $0x0
80003f53:	e8 be ec ff ff       	call   80002c16 <sys_page_unmap>
80003f58:	83 c4 10             	add    $0x10,%esp
80003f5b:	89 f8                	mov    %edi,%eax
80003f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80003f60:	5b                   	pop    %ebx
80003f61:	5e                   	pop    %esi
80003f62:	5f                   	pop    %edi
80003f63:	5d                   	pop    %ebp
80003f64:	c3                   	ret    

80003f65 <read>:
80003f65:	55                   	push   %ebp
80003f66:	89 e5                	mov    %esp,%ebp
80003f68:	53                   	push   %ebx
80003f69:	83 ec 14             	sub    $0x14,%esp
80003f6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80003f6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80003f72:	50                   	push   %eax
80003f73:	53                   	push   %ebx
80003f74:	e8 69 fd ff ff       	call   80003ce2 <fd_lookup>
80003f79:	83 c4 08             	add    $0x8,%esp
80003f7c:	89 c2                	mov    %eax,%edx
80003f7e:	85 c0                	test   %eax,%eax
80003f80:	78 6d                	js     80003fef <read+0x8a>
80003f82:	83 ec 08             	sub    $0x8,%esp
80003f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80003f88:	50                   	push   %eax
80003f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80003f8c:	ff 30                	pushl  (%eax)
80003f8e:	e8 a5 fd ff ff       	call   80003d38 <dev_lookup>
80003f93:	83 c4 10             	add    $0x10,%esp
80003f96:	85 c0                	test   %eax,%eax
80003f98:	78 4c                	js     80003fe6 <read+0x81>
80003f9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80003f9d:	8b 42 08             	mov    0x8(%edx),%eax
80003fa0:	83 e0 03             	and    $0x3,%eax
80003fa3:	83 f8 01             	cmp    $0x1,%eax
80003fa6:	75 21                	jne    80003fc9 <read+0x64>
80003fa8:	a1 10 a6 00 80       	mov    0x8000a610,%eax
80003fad:	8b 40 48             	mov    0x48(%eax),%eax
80003fb0:	83 ec 04             	sub    $0x4,%esp
80003fb3:	53                   	push   %ebx
80003fb4:	50                   	push   %eax
80003fb5:	68 5c 4d 00 80       	push   $0x80004d5c
80003fba:	e8 90 f8 ff ff       	call   8000384f <cprintf>
80003fbf:	83 c4 10             	add    $0x10,%esp
80003fc2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
80003fc7:	eb 26                	jmp    80003fef <read+0x8a>
80003fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80003fcc:	8b 40 08             	mov    0x8(%eax),%eax
80003fcf:	85 c0                	test   %eax,%eax
80003fd1:	74 17                	je     80003fea <read+0x85>
80003fd3:	83 ec 04             	sub    $0x4,%esp
80003fd6:	ff 75 10             	pushl  0x10(%ebp)
80003fd9:	ff 75 0c             	pushl  0xc(%ebp)
80003fdc:	52                   	push   %edx
80003fdd:	ff d0                	call   *%eax
80003fdf:	89 c2                	mov    %eax,%edx
80003fe1:	83 c4 10             	add    $0x10,%esp
80003fe4:	eb 09                	jmp    80003fef <read+0x8a>
80003fe6:	89 c2                	mov    %eax,%edx
80003fe8:	eb 05                	jmp    80003fef <read+0x8a>
80003fea:	ba ef ff ff ff       	mov    $0xffffffef,%edx
80003fef:	89 d0                	mov    %edx,%eax
80003ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80003ff4:	c9                   	leave  
80003ff5:	c3                   	ret    

80003ff6 <readn>:
80003ff6:	55                   	push   %ebp
80003ff7:	89 e5                	mov    %esp,%ebp
80003ff9:	57                   	push   %edi
80003ffa:	56                   	push   %esi
80003ffb:	53                   	push   %ebx
80003ffc:	83 ec 0c             	sub    $0xc,%esp
80003fff:	8b 7d 08             	mov    0x8(%ebp),%edi
80004002:	8b 75 10             	mov    0x10(%ebp),%esi
80004005:	85 f6                	test   %esi,%esi
80004007:	74 31                	je     8000403a <readn+0x44>
80004009:	b8 00 00 00 00       	mov    $0x0,%eax
8000400e:	bb 00 00 00 00       	mov    $0x0,%ebx
80004013:	83 ec 04             	sub    $0x4,%esp
80004016:	89 f2                	mov    %esi,%edx
80004018:	29 c2                	sub    %eax,%edx
8000401a:	52                   	push   %edx
8000401b:	03 45 0c             	add    0xc(%ebp),%eax
8000401e:	50                   	push   %eax
8000401f:	57                   	push   %edi
80004020:	e8 40 ff ff ff       	call   80003f65 <read>
80004025:	83 c4 10             	add    $0x10,%esp
80004028:	85 c0                	test   %eax,%eax
8000402a:	78 15                	js     80004041 <readn+0x4b>
8000402c:	85 c0                	test   %eax,%eax
8000402e:	74 0f                	je     8000403f <readn+0x49>
80004030:	01 c3                	add    %eax,%ebx
80004032:	89 d8                	mov    %ebx,%eax
80004034:	39 f3                	cmp    %esi,%ebx
80004036:	72 db                	jb     80004013 <readn+0x1d>
80004038:	eb 05                	jmp    8000403f <readn+0x49>
8000403a:	bb 00 00 00 00       	mov    $0x0,%ebx
8000403f:	89 d8                	mov    %ebx,%eax
80004041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80004044:	5b                   	pop    %ebx
80004045:	5e                   	pop    %esi
80004046:	5f                   	pop    %edi
80004047:	5d                   	pop    %ebp
80004048:	c3                   	ret    

80004049 <write>:
80004049:	55                   	push   %ebp
8000404a:	89 e5                	mov    %esp,%ebp
8000404c:	53                   	push   %ebx
8000404d:	83 ec 14             	sub    $0x14,%esp
80004050:	8b 5d 08             	mov    0x8(%ebp),%ebx
80004053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80004056:	50                   	push   %eax
80004057:	53                   	push   %ebx
80004058:	e8 85 fc ff ff       	call   80003ce2 <fd_lookup>
8000405d:	83 c4 08             	add    $0x8,%esp
80004060:	89 c2                	mov    %eax,%edx
80004062:	85 c0                	test   %eax,%eax
80004064:	78 68                	js     800040ce <write+0x85>
80004066:	83 ec 08             	sub    $0x8,%esp
80004069:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000406c:	50                   	push   %eax
8000406d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80004070:	ff 30                	pushl  (%eax)
80004072:	e8 c1 fc ff ff       	call   80003d38 <dev_lookup>
80004077:	83 c4 10             	add    $0x10,%esp
8000407a:	85 c0                	test   %eax,%eax
8000407c:	78 47                	js     800040c5 <write+0x7c>
8000407e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80004081:	f6 40 08 03          	testb  $0x3,0x8(%eax)
80004085:	75 21                	jne    800040a8 <write+0x5f>
80004087:	a1 10 a6 00 80       	mov    0x8000a610,%eax
8000408c:	8b 40 48             	mov    0x48(%eax),%eax
8000408f:	83 ec 04             	sub    $0x4,%esp
80004092:	53                   	push   %ebx
80004093:	50                   	push   %eax
80004094:	68 78 4d 00 80       	push   $0x80004d78
80004099:	e8 b1 f7 ff ff       	call   8000384f <cprintf>
8000409e:	83 c4 10             	add    $0x10,%esp
800040a1:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
800040a6:	eb 26                	jmp    800040ce <write+0x85>
800040a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
800040ab:	8b 52 0c             	mov    0xc(%edx),%edx
800040ae:	85 d2                	test   %edx,%edx
800040b0:	74 17                	je     800040c9 <write+0x80>
800040b2:	83 ec 04             	sub    $0x4,%esp
800040b5:	ff 75 10             	pushl  0x10(%ebp)
800040b8:	ff 75 0c             	pushl  0xc(%ebp)
800040bb:	50                   	push   %eax
800040bc:	ff d2                	call   *%edx
800040be:	89 c2                	mov    %eax,%edx
800040c0:	83 c4 10             	add    $0x10,%esp
800040c3:	eb 09                	jmp    800040ce <write+0x85>
800040c5:	89 c2                	mov    %eax,%edx
800040c7:	eb 05                	jmp    800040ce <write+0x85>
800040c9:	ba ef ff ff ff       	mov    $0xffffffef,%edx
800040ce:	89 d0                	mov    %edx,%eax
800040d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800040d3:	c9                   	leave  
800040d4:	c3                   	ret    

800040d5 <seek>:
800040d5:	55                   	push   %ebp
800040d6:	89 e5                	mov    %esp,%ebp
800040d8:	83 ec 10             	sub    $0x10,%esp
800040db:	8d 45 fc             	lea    -0x4(%ebp),%eax
800040de:	50                   	push   %eax
800040df:	ff 75 08             	pushl  0x8(%ebp)
800040e2:	e8 fb fb ff ff       	call   80003ce2 <fd_lookup>
800040e7:	83 c4 08             	add    $0x8,%esp
800040ea:	85 c0                	test   %eax,%eax
800040ec:	78 0e                	js     800040fc <seek+0x27>
800040ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
800040f1:	8b 55 0c             	mov    0xc(%ebp),%edx
800040f4:	89 50 04             	mov    %edx,0x4(%eax)
800040f7:	b8 00 00 00 00       	mov    $0x0,%eax
800040fc:	c9                   	leave  
800040fd:	c3                   	ret    

800040fe <ftruncate>:
800040fe:	55                   	push   %ebp
800040ff:	89 e5                	mov    %esp,%ebp
80004101:	53                   	push   %ebx
80004102:	83 ec 14             	sub    $0x14,%esp
80004105:	8b 5d 08             	mov    0x8(%ebp),%ebx
80004108:	8d 45 f0             	lea    -0x10(%ebp),%eax
8000410b:	50                   	push   %eax
8000410c:	53                   	push   %ebx
8000410d:	e8 d0 fb ff ff       	call   80003ce2 <fd_lookup>
80004112:	83 c4 08             	add    $0x8,%esp
80004115:	89 c2                	mov    %eax,%edx
80004117:	85 c0                	test   %eax,%eax
80004119:	78 65                	js     80004180 <ftruncate+0x82>
8000411b:	83 ec 08             	sub    $0x8,%esp
8000411e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80004121:	50                   	push   %eax
80004122:	8b 45 f0             	mov    -0x10(%ebp),%eax
80004125:	ff 30                	pushl  (%eax)
80004127:	e8 0c fc ff ff       	call   80003d38 <dev_lookup>
8000412c:	83 c4 10             	add    $0x10,%esp
8000412f:	85 c0                	test   %eax,%eax
80004131:	78 44                	js     80004177 <ftruncate+0x79>
80004133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80004136:	f6 40 08 03          	testb  $0x3,0x8(%eax)
8000413a:	75 21                	jne    8000415d <ftruncate+0x5f>
8000413c:	a1 10 a6 00 80       	mov    0x8000a610,%eax
80004141:	8b 40 48             	mov    0x48(%eax),%eax
80004144:	83 ec 04             	sub    $0x4,%esp
80004147:	53                   	push   %ebx
80004148:	50                   	push   %eax
80004149:	68 38 4d 00 80       	push   $0x80004d38
8000414e:	e8 fc f6 ff ff       	call   8000384f <cprintf>
80004153:	83 c4 10             	add    $0x10,%esp
80004156:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
8000415b:	eb 23                	jmp    80004180 <ftruncate+0x82>
8000415d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80004160:	8b 52 18             	mov    0x18(%edx),%edx
80004163:	85 d2                	test   %edx,%edx
80004165:	74 14                	je     8000417b <ftruncate+0x7d>
80004167:	83 ec 08             	sub    $0x8,%esp
8000416a:	ff 75 0c             	pushl  0xc(%ebp)
8000416d:	50                   	push   %eax
8000416e:	ff d2                	call   *%edx
80004170:	89 c2                	mov    %eax,%edx
80004172:	83 c4 10             	add    $0x10,%esp
80004175:	eb 09                	jmp    80004180 <ftruncate+0x82>
80004177:	89 c2                	mov    %eax,%edx
80004179:	eb 05                	jmp    80004180 <ftruncate+0x82>
8000417b:	ba ef ff ff ff       	mov    $0xffffffef,%edx
80004180:	89 d0                	mov    %edx,%eax
80004182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80004185:	c9                   	leave  
80004186:	c3                   	ret    

80004187 <fstat>:
80004187:	55                   	push   %ebp
80004188:	89 e5                	mov    %esp,%ebp
8000418a:	53                   	push   %ebx
8000418b:	83 ec 14             	sub    $0x14,%esp
8000418e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80004191:	8d 45 f0             	lea    -0x10(%ebp),%eax
80004194:	50                   	push   %eax
80004195:	ff 75 08             	pushl  0x8(%ebp)
80004198:	e8 45 fb ff ff       	call   80003ce2 <fd_lookup>
8000419d:	83 c4 08             	add    $0x8,%esp
800041a0:	89 c2                	mov    %eax,%edx
800041a2:	85 c0                	test   %eax,%eax
800041a4:	78 4f                	js     800041f5 <fstat+0x6e>
800041a6:	83 ec 08             	sub    $0x8,%esp
800041a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
800041ac:	50                   	push   %eax
800041ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
800041b0:	ff 30                	pushl  (%eax)
800041b2:	e8 81 fb ff ff       	call   80003d38 <dev_lookup>
800041b7:	83 c4 10             	add    $0x10,%esp
800041ba:	85 c0                	test   %eax,%eax
800041bc:	78 2e                	js     800041ec <fstat+0x65>
800041be:	8b 45 f4             	mov    -0xc(%ebp),%eax
800041c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
800041c5:	74 29                	je     800041f0 <fstat+0x69>
800041c7:	c6 03 00             	movb   $0x0,(%ebx)
800041ca:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
800041d1:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
800041d8:	89 43 18             	mov    %eax,0x18(%ebx)
800041db:	83 ec 08             	sub    $0x8,%esp
800041de:	53                   	push   %ebx
800041df:	ff 75 f0             	pushl  -0x10(%ebp)
800041e2:	ff 50 14             	call   *0x14(%eax)
800041e5:	89 c2                	mov    %eax,%edx
800041e7:	83 c4 10             	add    $0x10,%esp
800041ea:	eb 09                	jmp    800041f5 <fstat+0x6e>
800041ec:	89 c2                	mov    %eax,%edx
800041ee:	eb 05                	jmp    800041f5 <fstat+0x6e>
800041f0:	ba ef ff ff ff       	mov    $0xffffffef,%edx
800041f5:	89 d0                	mov    %edx,%eax
800041f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800041fa:	c9                   	leave  
800041fb:	c3                   	ret    

800041fc <stat>:
800041fc:	55                   	push   %ebp
800041fd:	89 e5                	mov    %esp,%ebp
800041ff:	56                   	push   %esi
80004200:	53                   	push   %ebx
80004201:	83 ec 08             	sub    $0x8,%esp
80004204:	6a 00                	push   $0x0
80004206:	ff 75 08             	pushl  0x8(%ebp)
80004209:	e8 f0 ec ff ff       	call   80002efe <open>
8000420e:	89 c3                	mov    %eax,%ebx
80004210:	83 c4 10             	add    $0x10,%esp
80004213:	85 db                	test   %ebx,%ebx
80004215:	78 1b                	js     80004232 <stat+0x36>
80004217:	83 ec 08             	sub    $0x8,%esp
8000421a:	ff 75 0c             	pushl  0xc(%ebp)
8000421d:	53                   	push   %ebx
8000421e:	e8 64 ff ff ff       	call   80004187 <fstat>
80004223:	89 c6                	mov    %eax,%esi
80004225:	89 1c 24             	mov    %ebx,(%esp)
80004228:	e8 fa fb ff ff       	call   80003e27 <close>
8000422d:	83 c4 10             	add    $0x10,%esp
80004230:	89 f0                	mov    %esi,%eax
80004232:	8d 65 f8             	lea    -0x8(%ebp),%esp
80004235:	5b                   	pop    %ebx
80004236:	5e                   	pop    %esi
80004237:	5d                   	pop    %ebp
80004238:	c3                   	ret    

80004239 <devpipe_stat>:
80004239:	55                   	push   %ebp
8000423a:	89 e5                	mov    %esp,%ebp
8000423c:	56                   	push   %esi
8000423d:	53                   	push   %ebx
8000423e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80004241:	83 ec 0c             	sub    $0xc,%esp
80004244:	ff 75 08             	pushl  0x8(%ebp)
80004247:	e8 0a fa ff ff       	call   80003c56 <fd2data>
8000424c:	89 c6                	mov    %eax,%esi
8000424e:	83 c4 08             	add    $0x8,%esp
80004251:	68 95 4d 00 80       	push   $0x80004d95
80004256:	53                   	push   %ebx
80004257:	e8 4b e4 ff ff       	call   800026a7 <strcpy>
8000425c:	8b 56 04             	mov    0x4(%esi),%edx
8000425f:	89 d0                	mov    %edx,%eax
80004261:	2b 06                	sub    (%esi),%eax
80004263:	89 43 10             	mov    %eax,0x10(%ebx)
80004266:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
8000426d:	c7 43 18 d0 90 00 80 	movl   $0x800090d0,0x18(%ebx)
80004274:	b8 00 00 00 00       	mov    $0x0,%eax
80004279:	8d 65 f8             	lea    -0x8(%ebp),%esp
8000427c:	5b                   	pop    %ebx
8000427d:	5e                   	pop    %esi
8000427e:	5d                   	pop    %ebp
8000427f:	c3                   	ret    

80004280 <devpipe_close>:
80004280:	55                   	push   %ebp
80004281:	89 e5                	mov    %esp,%ebp
80004283:	53                   	push   %ebx
80004284:	83 ec 0c             	sub    $0xc,%esp
80004287:	8b 5d 08             	mov    0x8(%ebp),%ebx
8000428a:	53                   	push   %ebx
8000428b:	6a 00                	push   $0x0
8000428d:	e8 84 e9 ff ff       	call   80002c16 <sys_page_unmap>
80004292:	89 1c 24             	mov    %ebx,(%esp)
80004295:	e8 bc f9 ff ff       	call   80003c56 <fd2data>
8000429a:	83 c4 08             	add    $0x8,%esp
8000429d:	50                   	push   %eax
8000429e:	6a 00                	push   $0x0
800042a0:	e8 71 e9 ff ff       	call   80002c16 <sys_page_unmap>
800042a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
800042a8:	c9                   	leave  
800042a9:	c3                   	ret    

800042aa <_pipeisclosed>:
800042aa:	55                   	push   %ebp
800042ab:	89 e5                	mov    %esp,%ebp
800042ad:	57                   	push   %edi
800042ae:	56                   	push   %esi
800042af:	53                   	push   %ebx
800042b0:	83 ec 1c             	sub    $0x1c,%esp
800042b3:	89 c6                	mov    %eax,%esi
800042b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
800042b8:	a1 10 a6 00 80       	mov    0x8000a610,%eax
800042bd:	8b 58 58             	mov    0x58(%eax),%ebx
800042c0:	83 ec 0c             	sub    $0xc,%esp
800042c3:	56                   	push   %esi
800042c4:	e8 18 ef ff ff       	call   800031e1 <pageref>
800042c9:	89 c7                	mov    %eax,%edi
800042cb:	83 c4 04             	add    $0x4,%esp
800042ce:	ff 75 e4             	pushl  -0x1c(%ebp)
800042d1:	e8 0b ef ff ff       	call   800031e1 <pageref>
800042d6:	83 c4 10             	add    $0x10,%esp
800042d9:	39 c7                	cmp    %eax,%edi
800042db:	0f 94 c2             	sete   %dl
800042de:	0f b6 c2             	movzbl %dl,%eax
800042e1:	8b 0d 10 a6 00 80    	mov    0x8000a610,%ecx
800042e7:	8b 79 58             	mov    0x58(%ecx),%edi
800042ea:	39 fb                	cmp    %edi,%ebx
800042ec:	74 19                	je     80004307 <_pipeisclosed+0x5d>
800042ee:	84 d2                	test   %dl,%dl
800042f0:	74 c6                	je     800042b8 <_pipeisclosed+0xe>
800042f2:	8b 51 58             	mov    0x58(%ecx),%edx
800042f5:	50                   	push   %eax
800042f6:	52                   	push   %edx
800042f7:	53                   	push   %ebx
800042f8:	68 9c 4d 00 80       	push   $0x80004d9c
800042fd:	e8 4d f5 ff ff       	call   8000384f <cprintf>
80004302:	83 c4 10             	add    $0x10,%esp
80004305:	eb b1                	jmp    800042b8 <_pipeisclosed+0xe>
80004307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000430a:	5b                   	pop    %ebx
8000430b:	5e                   	pop    %esi
8000430c:	5f                   	pop    %edi
8000430d:	5d                   	pop    %ebp
8000430e:	c3                   	ret    

8000430f <devpipe_write>:
8000430f:	55                   	push   %ebp
80004310:	89 e5                	mov    %esp,%ebp
80004312:	57                   	push   %edi
80004313:	56                   	push   %esi
80004314:	53                   	push   %ebx
80004315:	83 ec 28             	sub    $0x28,%esp
80004318:	8b 75 08             	mov    0x8(%ebp),%esi
8000431b:	56                   	push   %esi
8000431c:	e8 35 f9 ff ff       	call   80003c56 <fd2data>
80004321:	89 c3                	mov    %eax,%ebx
80004323:	83 c4 10             	add    $0x10,%esp
80004326:	bf 00 00 00 00       	mov    $0x0,%edi
8000432b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8000432f:	75 52                	jne    80004383 <devpipe_write+0x74>
80004331:	eb 5e                	jmp    80004391 <devpipe_write+0x82>
80004333:	89 da                	mov    %ebx,%edx
80004335:	89 f0                	mov    %esi,%eax
80004337:	e8 6e ff ff ff       	call   800042aa <_pipeisclosed>
8000433c:	85 c0                	test   %eax,%eax
8000433e:	75 56                	jne    80004396 <devpipe_write+0x87>
80004340:	e8 2d e8 ff ff       	call   80002b72 <sys_yield>
80004345:	8b 43 04             	mov    0x4(%ebx),%eax
80004348:	8b 0b                	mov    (%ebx),%ecx
8000434a:	8d 51 20             	lea    0x20(%ecx),%edx
8000434d:	39 d0                	cmp    %edx,%eax
8000434f:	73 e2                	jae    80004333 <devpipe_write+0x24>
80004351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80004354:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
80004358:	88 4d e7             	mov    %cl,-0x19(%ebp)
8000435b:	89 c2                	mov    %eax,%edx
8000435d:	c1 fa 1f             	sar    $0x1f,%edx
80004360:	89 d1                	mov    %edx,%ecx
80004362:	c1 e9 1b             	shr    $0x1b,%ecx
80004365:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80004368:	83 e2 1f             	and    $0x1f,%edx
8000436b:	29 ca                	sub    %ecx,%edx
8000436d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
80004371:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
80004375:	83 c0 01             	add    $0x1,%eax
80004378:	89 43 04             	mov    %eax,0x4(%ebx)
8000437b:	83 c7 01             	add    $0x1,%edi
8000437e:	3b 7d 10             	cmp    0x10(%ebp),%edi
80004381:	74 0e                	je     80004391 <devpipe_write+0x82>
80004383:	8b 43 04             	mov    0x4(%ebx),%eax
80004386:	8b 0b                	mov    (%ebx),%ecx
80004388:	8d 51 20             	lea    0x20(%ecx),%edx
8000438b:	39 d0                	cmp    %edx,%eax
8000438d:	73 a4                	jae    80004333 <devpipe_write+0x24>
8000438f:	eb c0                	jmp    80004351 <devpipe_write+0x42>
80004391:	8b 45 10             	mov    0x10(%ebp),%eax
80004394:	eb 05                	jmp    8000439b <devpipe_write+0x8c>
80004396:	b8 00 00 00 00       	mov    $0x0,%eax
8000439b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000439e:	5b                   	pop    %ebx
8000439f:	5e                   	pop    %esi
800043a0:	5f                   	pop    %edi
800043a1:	5d                   	pop    %ebp
800043a2:	c3                   	ret    

800043a3 <devpipe_read>:
800043a3:	55                   	push   %ebp
800043a4:	89 e5                	mov    %esp,%ebp
800043a6:	57                   	push   %edi
800043a7:	56                   	push   %esi
800043a8:	53                   	push   %ebx
800043a9:	83 ec 18             	sub    $0x18,%esp
800043ac:	8b 7d 08             	mov    0x8(%ebp),%edi
800043af:	57                   	push   %edi
800043b0:	e8 a1 f8 ff ff       	call   80003c56 <fd2data>
800043b5:	89 c3                	mov    %eax,%ebx
800043b7:	83 c4 10             	add    $0x10,%esp
800043ba:	be 00 00 00 00       	mov    $0x0,%esi
800043bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
800043c3:	75 40                	jne    80004405 <devpipe_read+0x62>
800043c5:	eb 4b                	jmp    80004412 <devpipe_read+0x6f>
800043c7:	89 f0                	mov    %esi,%eax
800043c9:	eb 51                	jmp    8000441c <devpipe_read+0x79>
800043cb:	89 da                	mov    %ebx,%edx
800043cd:	89 f8                	mov    %edi,%eax
800043cf:	e8 d6 fe ff ff       	call   800042aa <_pipeisclosed>
800043d4:	85 c0                	test   %eax,%eax
800043d6:	75 3f                	jne    80004417 <devpipe_read+0x74>
800043d8:	e8 95 e7 ff ff       	call   80002b72 <sys_yield>
800043dd:	8b 03                	mov    (%ebx),%eax
800043df:	3b 43 04             	cmp    0x4(%ebx),%eax
800043e2:	74 e7                	je     800043cb <devpipe_read+0x28>
800043e4:	99                   	cltd   
800043e5:	c1 ea 1b             	shr    $0x1b,%edx
800043e8:	01 d0                	add    %edx,%eax
800043ea:	83 e0 1f             	and    $0x1f,%eax
800043ed:	29 d0                	sub    %edx,%eax
800043ef:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
800043f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
800043f7:	88 04 31             	mov    %al,(%ecx,%esi,1)
800043fa:	83 03 01             	addl   $0x1,(%ebx)
800043fd:	83 c6 01             	add    $0x1,%esi
80004400:	3b 75 10             	cmp    0x10(%ebp),%esi
80004403:	74 0d                	je     80004412 <devpipe_read+0x6f>
80004405:	8b 03                	mov    (%ebx),%eax
80004407:	3b 43 04             	cmp    0x4(%ebx),%eax
8000440a:	75 d8                	jne    800043e4 <devpipe_read+0x41>
8000440c:	85 f6                	test   %esi,%esi
8000440e:	75 b7                	jne    800043c7 <devpipe_read+0x24>
80004410:	eb b9                	jmp    800043cb <devpipe_read+0x28>
80004412:	8b 45 10             	mov    0x10(%ebp),%eax
80004415:	eb 05                	jmp    8000441c <devpipe_read+0x79>
80004417:	b8 00 00 00 00       	mov    $0x0,%eax
8000441c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8000441f:	5b                   	pop    %ebx
80004420:	5e                   	pop    %esi
80004421:	5f                   	pop    %edi
80004422:	5d                   	pop    %ebp
80004423:	c3                   	ret    

80004424 <pipe>:
80004424:	55                   	push   %ebp
80004425:	89 e5                	mov    %esp,%ebp
80004427:	56                   	push   %esi
80004428:	53                   	push   %ebx
80004429:	83 ec 1c             	sub    $0x1c,%esp
8000442c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8000442f:	50                   	push   %eax
80004430:	e8 39 f8 ff ff       	call   80003c6e <fd_alloc>
80004435:	83 c4 10             	add    $0x10,%esp
80004438:	89 c2                	mov    %eax,%edx
8000443a:	85 c0                	test   %eax,%eax
8000443c:	0f 88 2c 01 00 00    	js     8000456e <pipe+0x14a>
80004442:	83 ec 04             	sub    $0x4,%esp
80004445:	68 07 04 00 00       	push   $0x407
8000444a:	ff 75 f4             	pushl  -0xc(%ebp)
8000444d:	6a 00                	push   $0x0
8000444f:	e8 3d e7 ff ff       	call   80002b91 <sys_page_alloc>
80004454:	83 c4 10             	add    $0x10,%esp
80004457:	89 c2                	mov    %eax,%edx
80004459:	85 c0                	test   %eax,%eax
8000445b:	0f 88 0d 01 00 00    	js     8000456e <pipe+0x14a>
80004461:	83 ec 0c             	sub    $0xc,%esp
80004464:	8d 45 f0             	lea    -0x10(%ebp),%eax
80004467:	50                   	push   %eax
80004468:	e8 01 f8 ff ff       	call   80003c6e <fd_alloc>
8000446d:	89 c3                	mov    %eax,%ebx
8000446f:	83 c4 10             	add    $0x10,%esp
80004472:	85 c0                	test   %eax,%eax
80004474:	0f 88 e2 00 00 00    	js     8000455c <pipe+0x138>
8000447a:	83 ec 04             	sub    $0x4,%esp
8000447d:	68 07 04 00 00       	push   $0x407
80004482:	ff 75 f0             	pushl  -0x10(%ebp)
80004485:	6a 00                	push   $0x0
80004487:	e8 05 e7 ff ff       	call   80002b91 <sys_page_alloc>
8000448c:	89 c3                	mov    %eax,%ebx
8000448e:	83 c4 10             	add    $0x10,%esp
80004491:	85 c0                	test   %eax,%eax
80004493:	0f 88 c3 00 00 00    	js     8000455c <pipe+0x138>
80004499:	83 ec 0c             	sub    $0xc,%esp
8000449c:	ff 75 f4             	pushl  -0xc(%ebp)
8000449f:	e8 b2 f7 ff ff       	call   80003c56 <fd2data>
800044a4:	89 c6                	mov    %eax,%esi
800044a6:	83 c4 0c             	add    $0xc,%esp
800044a9:	68 07 04 00 00       	push   $0x407
800044ae:	50                   	push   %eax
800044af:	6a 00                	push   $0x0
800044b1:	e8 db e6 ff ff       	call   80002b91 <sys_page_alloc>
800044b6:	89 c3                	mov    %eax,%ebx
800044b8:	83 c4 10             	add    $0x10,%esp
800044bb:	85 c0                	test   %eax,%eax
800044bd:	0f 88 89 00 00 00    	js     8000454c <pipe+0x128>
800044c3:	83 ec 0c             	sub    $0xc,%esp
800044c6:	ff 75 f0             	pushl  -0x10(%ebp)
800044c9:	e8 88 f7 ff ff       	call   80003c56 <fd2data>
800044ce:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
800044d5:	50                   	push   %eax
800044d6:	6a 00                	push   $0x0
800044d8:	56                   	push   %esi
800044d9:	6a 00                	push   $0x0
800044db:	e8 f4 e6 ff ff       	call   80002bd4 <sys_page_map>
800044e0:	89 c3                	mov    %eax,%ebx
800044e2:	83 c4 20             	add    $0x20,%esp
800044e5:	85 c0                	test   %eax,%eax
800044e7:	78 55                	js     8000453e <pipe+0x11a>
800044e9:	8b 15 d0 90 00 80    	mov    0x800090d0,%edx
800044ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
800044f2:	89 10                	mov    %edx,(%eax)
800044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
800044f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
800044fe:	8b 15 d0 90 00 80    	mov    0x800090d0,%edx
80004504:	8b 45 f0             	mov    -0x10(%ebp),%eax
80004507:	89 10                	mov    %edx,(%eax)
80004509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8000450c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
80004513:	83 ec 0c             	sub    $0xc,%esp
80004516:	ff 75 f4             	pushl  -0xc(%ebp)
80004519:	e8 28 f7 ff ff       	call   80003c46 <fd2num>
8000451e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80004521:	89 01                	mov    %eax,(%ecx)
80004523:	83 c4 04             	add    $0x4,%esp
80004526:	ff 75 f0             	pushl  -0x10(%ebp)
80004529:	e8 18 f7 ff ff       	call   80003c46 <fd2num>
8000452e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80004531:	89 41 04             	mov    %eax,0x4(%ecx)
80004534:	83 c4 10             	add    $0x10,%esp
80004537:	ba 00 00 00 00       	mov    $0x0,%edx
8000453c:	eb 30                	jmp    8000456e <pipe+0x14a>
8000453e:	83 ec 08             	sub    $0x8,%esp
80004541:	56                   	push   %esi
80004542:	6a 00                	push   $0x0
80004544:	e8 cd e6 ff ff       	call   80002c16 <sys_page_unmap>
80004549:	83 c4 10             	add    $0x10,%esp
8000454c:	83 ec 08             	sub    $0x8,%esp
8000454f:	ff 75 f0             	pushl  -0x10(%ebp)
80004552:	6a 00                	push   $0x0
80004554:	e8 bd e6 ff ff       	call   80002c16 <sys_page_unmap>
80004559:	83 c4 10             	add    $0x10,%esp
8000455c:	83 ec 08             	sub    $0x8,%esp
8000455f:	ff 75 f4             	pushl  -0xc(%ebp)
80004562:	6a 00                	push   $0x0
80004564:	e8 ad e6 ff ff       	call   80002c16 <sys_page_unmap>
80004569:	83 c4 10             	add    $0x10,%esp
8000456c:	89 da                	mov    %ebx,%edx
8000456e:	89 d0                	mov    %edx,%eax
80004570:	8d 65 f8             	lea    -0x8(%ebp),%esp
80004573:	5b                   	pop    %ebx
80004574:	5e                   	pop    %esi
80004575:	5d                   	pop    %ebp
80004576:	c3                   	ret    

80004577 <pipeisclosed>:
80004577:	55                   	push   %ebp
80004578:	89 e5                	mov    %esp,%ebp
8000457a:	83 ec 20             	sub    $0x20,%esp
8000457d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80004580:	50                   	push   %eax
80004581:	ff 75 08             	pushl  0x8(%ebp)
80004584:	e8 59 f7 ff ff       	call   80003ce2 <fd_lookup>
80004589:	89 c2                	mov    %eax,%edx
8000458b:	83 c4 10             	add    $0x10,%esp
8000458e:	85 d2                	test   %edx,%edx
80004590:	78 18                	js     800045aa <pipeisclosed+0x33>
80004592:	83 ec 0c             	sub    $0xc,%esp
80004595:	ff 75 f4             	pushl  -0xc(%ebp)
80004598:	e8 b9 f6 ff ff       	call   80003c56 <fd2data>
8000459d:	89 c2                	mov    %eax,%edx
8000459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
800045a2:	e8 03 fd ff ff       	call   800042aa <_pipeisclosed>
800045a7:	83 c4 10             	add    $0x10,%esp
800045aa:	c9                   	leave  
800045ab:	c3                   	ret    

800045ac <_pgfault_upcall>:
800045ac:	54                   	push   %esp
800045ad:	a1 00 c0 00 80       	mov    0x8000c000,%eax
800045b2:	ff d0                	call   *%eax
800045b4:	83 c4 04             	add    $0x4,%esp
800045b7:	83 c4 08             	add    $0x8,%esp
800045ba:	8b 44 24 20          	mov    0x20(%esp),%eax
800045be:	8b 54 24 28          	mov    0x28(%esp),%edx
800045c2:	89 42 fc             	mov    %eax,-0x4(%edx)
800045c5:	83 6c 24 28 04       	subl   $0x4,0x28(%esp)
800045ca:	61                   	popa   
800045cb:	83 c4 04             	add    $0x4,%esp
800045ce:	9d                   	popf   
800045cf:	5c                   	pop    %esp
800045d0:	c3                   	ret    
