
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	fc                   	cld    
    7c02:	31 c0                	xor    %eax,%eax
    7c04:	8e d8                	mov    %eax,%ds
    7c06:	8e c0                	mov    %eax,%es
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
    7c0a:	e4 64                	in     $0x64,%al
    7c0c:	a8 02                	test   $0x2,%al
    7c0e:	75 fa                	jne    7c0a <seta20.1>
    7c10:	b0 d1                	mov    $0xd1,%al
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:
    7c14:	e4 64                	in     $0x64,%al
    7c16:	a8 02                	test   $0x2,%al
    7c18:	75 fa                	jne    7c14 <seta20.2>
    7c1a:	b0 df                	mov    $0xdf,%al
    7c1c:	e6 60                	out    %al,$0x60
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64 7c 0f             	fs jl  7c33 <protcseg+0x1>
    7c24:	20 c0                	and    %al,%al
    7c26:	66 83 c8 01          	or     $0x1,%ax
    7c2a:	0f 22 c0             	mov    %eax,%cr0
    7c2d:	ea                   	.byte 0xea
    7c2e:	32 7c 08 00          	xor    0x0(%eax,%ecx,1),%bh

00007c32 <protcseg>:
    7c32:	66 b8 10 00          	mov    $0x10,%ax
    7c36:	8e d8                	mov    %eax,%ds
    7c38:	8e c0                	mov    %eax,%es
    7c3a:	8e e0                	mov    %eax,%fs
    7c3c:	8e e8                	mov    %eax,%gs
    7c3e:	8e d0                	mov    %eax,%ss
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c45:	e8 cb 00 00 00       	call   7d15 <bootmain>

00007c4a <spin>:
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00                   	.byte 0x0
    7c61:	92                   	xchg   %eax,%edx
    7c62:	cf                   	iret   
	...

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
	...

00007c6a <waitdisk>:
    7c6a:	55                   	push   %ebp
    7c6b:	89 e5                	mov    %esp,%ebp
    7c6d:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c72:	ec                   	in     (%dx),%al
    7c73:	83 e0 c0             	and    $0xffffffc0,%eax
    7c76:	3c 40                	cmp    $0x40,%al
    7c78:	75 f8                	jne    7c72 <waitdisk+0x8>
    7c7a:	5d                   	pop    %ebp
    7c7b:	c3                   	ret    

00007c7c <readsect>:
    7c7c:	55                   	push   %ebp
    7c7d:	89 e5                	mov    %esp,%ebp
    7c7f:	57                   	push   %edi
    7c80:	53                   	push   %ebx
    7c81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    7c84:	e8 e1 ff ff ff       	call   7c6a <waitdisk>
    7c89:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c8e:	b8 01 00 00 00       	mov    $0x1,%eax
    7c93:	ee                   	out    %al,(%dx)
    7c94:	b2 f3                	mov    $0xf3,%dl
    7c96:	89 d8                	mov    %ebx,%eax
    7c98:	ee                   	out    %al,(%dx)
    7c99:	89 d8                	mov    %ebx,%eax
    7c9b:	c1 e8 08             	shr    $0x8,%eax
    7c9e:	b2 f4                	mov    $0xf4,%dl
    7ca0:	ee                   	out    %al,(%dx)
    7ca1:	89 d8                	mov    %ebx,%eax
    7ca3:	c1 e8 10             	shr    $0x10,%eax
    7ca6:	b2 f5                	mov    $0xf5,%dl
    7ca8:	ee                   	out    %al,(%dx)
    7ca9:	89 d8                	mov    %ebx,%eax
    7cab:	c1 e8 18             	shr    $0x18,%eax
    7cae:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb1:	b2 f6                	mov    $0xf6,%dl
    7cb3:	ee                   	out    %al,(%dx)
    7cb4:	b2 f7                	mov    $0xf7,%dl
    7cb6:	b8 20 00 00 00       	mov    $0x20,%eax
    7cbb:	ee                   	out    %al,(%dx)
    7cbc:	e8 a9 ff ff ff       	call   7c6a <waitdisk>
    7cc1:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cc4:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cc9:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cce:	fc                   	cld    
    7ccf:	f2 6d                	repnz insl (%dx),%es:(%edi)
    7cd1:	5b                   	pop    %ebx
    7cd2:	5f                   	pop    %edi
    7cd3:	5d                   	pop    %ebp
    7cd4:	c3                   	ret    

00007cd5 <readseg>:
    7cd5:	55                   	push   %ebp
    7cd6:	89 e5                	mov    %esp,%ebp
    7cd8:	57                   	push   %edi
    7cd9:	56                   	push   %esi
    7cda:	53                   	push   %ebx
    7cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cde:	89 df                	mov    %ebx,%edi
    7ce0:	03 7d 0c             	add    0xc(%ebp),%edi
    7ce3:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
    7ce9:	8b 75 10             	mov    0x10(%ebp),%esi
    7cec:	c1 ee 09             	shr    $0x9,%esi
    7cef:	83 c6 01             	add    $0x1,%esi
    7cf2:	39 df                	cmp    %ebx,%edi
    7cf4:	76 17                	jbe    7d0d <readseg+0x38>
    7cf6:	56                   	push   %esi
    7cf7:	53                   	push   %ebx
    7cf8:	e8 7f ff ff ff       	call   7c7c <readsect>
    7cfd:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d03:	83 c6 01             	add    $0x1,%esi
    7d06:	83 c4 08             	add    $0x8,%esp
    7d09:	39 df                	cmp    %ebx,%edi
    7d0b:	77 e9                	ja     7cf6 <readseg+0x21>
    7d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d10:	5b                   	pop    %ebx
    7d11:	5e                   	pop    %esi
    7d12:	5f                   	pop    %edi
    7d13:	5d                   	pop    %ebp
    7d14:	c3                   	ret    

00007d15 <bootmain>:
    7d15:	55                   	push   %ebp
    7d16:	89 e5                	mov    %esp,%ebp
    7d18:	56                   	push   %esi
    7d19:	53                   	push   %ebx
    7d1a:	6a 00                	push   $0x0
    7d1c:	68 00 10 00 00       	push   $0x1000
    7d21:	68 00 00 01 00       	push   $0x10000
    7d26:	e8 aa ff ff ff       	call   7cd5 <readseg>
    7d2b:	83 c4 0c             	add    $0xc,%esp
    7d2e:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d35:	45 4c 46 
    7d38:	75 39                	jne    7d73 <bootmain+0x5e>
    7d3a:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d3f:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    7d45:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d4c:	c1 e6 05             	shl    $0x5,%esi
    7d4f:	01 de                	add    %ebx,%esi
    7d51:	39 f3                	cmp    %esi,%ebx
    7d53:	73 18                	jae    7d6d <bootmain+0x58>
    7d55:	ff 73 04             	pushl  0x4(%ebx)
    7d58:	ff 73 14             	pushl  0x14(%ebx)
    7d5b:	ff 73 0c             	pushl  0xc(%ebx)
    7d5e:	e8 72 ff ff ff       	call   7cd5 <readseg>
    7d63:	83 c3 20             	add    $0x20,%ebx
    7d66:	83 c4 0c             	add    $0xc,%esp
    7d69:	39 de                	cmp    %ebx,%esi
    7d6b:	77 e8                	ja     7d55 <bootmain+0x40>
    7d6d:	ff 15 18 00 01 00    	call   *0x10018
    7d73:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7d78:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7d7d:	66 ef                	out    %ax,(%dx)
    7d7f:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7d84:	66 ef                	out    %ax,(%dx)
    7d86:	eb fe                	jmp    7d86 <bootmain+0x71>
