
init2.o：     文件格式 elf32-littleriscv


Disassembly of section .text.cputch:

00000000 <cputch>:
   0:	000007b7          	lui	a5,0x0
   4:	0007a783          	lw	a5,0(a5) # 0 <cputch>
   8:	ff010113          	addi	sp,sp,-16
   c:	00112623          	sw	ra,12(sp)
  10:	00812423          	sw	s0,8(sp)
  14:	0ff57513          	andi	a0,a0,255
  18:	00058413          	mv	s0,a1
  1c:	000780e7          	jalr	a5
  20:	00042783          	lw	a5,0(s0)
  24:	00c12083          	lw	ra,12(sp)
  28:	00178793          	addi	a5,a5,1
  2c:	00f42023          	sw	a5,0(s0)
  30:	00812403          	lw	s0,8(sp)
  34:	01010113          	addi	sp,sp,16
  38:	00008067          	ret

Disassembly of section .text.printnum:

00000000 <printnum>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00912a23          	sw	s1,20(sp)
   8:	01212823          	sw	s2,16(sp)
   c:	01312623          	sw	s3,12(sp)
  10:	01412423          	sw	s4,8(sp)
  14:	00112e23          	sw	ra,28(sp)
  18:	00812c23          	sw	s0,24(sp)
  1c:	00050493          	mv	s1,a0
  20:	00058913          	mv	s2,a1
  24:	00080993          	mv	s3,a6
  28:	02e67a33          	remu	s4,a2,a4
  2c:	04069e63          	bnez	a3,88 <.L4>
  30:	04e67c63          	bleu	a4,a2,88 <.L4>
  34:	fff78413          	addi	s0,a5,-1
  38:	00805c63          	blez	s0,50 <.L7>

0000003c <.L11>:
  3c:	fff40413          	addi	s0,s0,-1
  40:	00090593          	mv	a1,s2
  44:	00098513          	mv	a0,s3
  48:	000480e7          	jalr	s1
  4c:	fe0418e3          	bnez	s0,3c <.L11>

00000050 <.L7>:
  50:	000007b7          	lui	a5,0x0
  54:	00078793          	mv	a5,a5
  58:	00fa0a33          	add	s4,s4,a5
  5c:	000a4503          	lbu	a0,0(s4)
  60:	00090593          	mv	a1,s2
  64:	00048313          	mv	t1,s1
  68:	01c12083          	lw	ra,28(sp)
  6c:	01812403          	lw	s0,24(sp)
  70:	01412483          	lw	s1,20(sp)
  74:	01012903          	lw	s2,16(sp)
  78:	00c12983          	lw	s3,12(sp)
  7c:	00812a03          	lw	s4,8(sp)
  80:	02010113          	addi	sp,sp,32
  84:	00030067          	jr	t1

00000088 <.L4>:
  88:	02e65633          	divu	a2,a2,a4
  8c:	00098813          	mv	a6,s3
  90:	fff78793          	addi	a5,a5,-1
  94:	00000693          	li	a3,0
  98:	00090593          	mv	a1,s2
  9c:	00048513          	mv	a0,s1
  a0:	00000317          	auipc	t1,0x0
  a4:	000300e7          	jalr	t1
  a8:	fa9ff06f          	j	50 <.L7>

Disassembly of section .text.strnlen:

00000000 <strnlen>:
   0:	00050693          	mv	a3,a0
   4:	02058a63          	beqz	a1,38 <.L19>
   8:	00054703          	lbu	a4,0(a0)
   c:	00150793          	addi	a5,a0,1
  10:	02070463          	beqz	a4,38 <.L19>
  14:	00b505b3          	add	a1,a0,a1
  18:	0100006f          	j	28 <.L17>

0000001c <.L22>:
  1c:	00178793          	addi	a5,a5,1
  20:	fff7c703          	lbu	a4,-1(a5)
  24:	00070863          	beqz	a4,34 <.L21>

00000028 <.L17>:
  28:	40d78533          	sub	a0,a5,a3
  2c:	feb798e3          	bne	a5,a1,1c <.L22>
  30:	00008067          	ret

00000034 <.L21>:
  34:	00008067          	ret

00000038 <.L19>:
  38:	00000513          	li	a0,0
  3c:	00008067          	ret

Disassembly of section .text.memset:

00000000 <memset>:
   0:	00c507b3          	add	a5,a0,a2
   4:	00060863          	beqz	a2,14 <.L23>

00000008 <.L27>:
   8:	00150513          	addi	a0,a0,1
   c:	feb50fa3          	sb	a1,-1(a0)
  10:	fea79ce3          	bne	a5,a0,8 <.L27>

00000014 <.L23>:
  14:	00008067          	ret

Disassembly of section .text.cons_putc:

00000000 <cons_putc>:
   0:	000007b7          	lui	a5,0x0
   4:	0007a303          	lw	t1,0(a5) # 0 <cons_putc>
   8:	0ff57513          	andi	a0,a0,255
   c:	00030067          	jr	t1

Disassembly of section .text.printfmt:

00000000 <printfmt>:
   0:	fc010113          	addi	sp,sp,-64
   4:	02c10313          	addi	t1,sp,44
   8:	02d12623          	sw	a3,44(sp)
   c:	00030693          	mv	a3,t1
  10:	00112e23          	sw	ra,28(sp)
  14:	02e12823          	sw	a4,48(sp)
  18:	02f12a23          	sw	a5,52(sp)
  1c:	03012c23          	sw	a6,56(sp)
  20:	03112e23          	sw	a7,60(sp)
  24:	00612623          	sw	t1,12(sp)
  28:	00000317          	auipc	t1,0x0
  2c:	000300e7          	jalr	t1
  30:	01c12083          	lw	ra,28(sp)
  34:	04010113          	addi	sp,sp,64
  38:	00008067          	ret

Disassembly of section .text.vprintfmt:

00000000 <vprintfmt>:
   0:	fb010113          	addi	sp,sp,-80
   4:	03712623          	sw	s7,44(sp)
   8:	00000bb7          	lui	s7,0x0
   c:	03412c23          	sw	s4,56(sp)
  10:	03612823          	sw	s6,48(sp)
  14:	00000a37          	lui	s4,0x0
  18:	000b8793          	mv	a5,s7
  1c:	00000b37          	lui	s6,0x0
  20:	05212023          	sw	s2,64(sp)
  24:	03312e23          	sw	s3,60(sp)
  28:	03512a23          	sw	s5,52(sp)
  2c:	03912223          	sw	s9,36(sp)
  30:	04112623          	sw	ra,76(sp)
  34:	04812423          	sw	s0,72(sp)
  38:	04912223          	sw	s1,68(sp)
  3c:	03812423          	sw	s8,40(sp)
  40:	03a12023          	sw	s10,32(sp)
  44:	01b12e23          	sw	s11,28(sp)
  48:	00050993          	mv	s3,a0
  4c:	00058913          	mv	s2,a1
  50:	00060c93          	mv	s9,a2
  54:	00068a93          	mv	s5,a3
  58:	000a0a13          	mv	s4,s4
  5c:	00f12023          	sw	a5,0(sp)
  60:	000b0b13          	mv	s6,s6

00000064 <.L33>:
  64:	000cc503          	lbu	a0,0(s9)
  68:	02500493          	li	s1,37
  6c:	001c8413          	addi	s0,s9,1
  70:	00950e63          	beq	a0,s1,8c <.L34>

00000074 <.L38>:
  74:	06050263          	beqz	a0,d8 <.L32>
  78:	00090593          	mv	a1,s2
  7c:	00140413          	addi	s0,s0,1
  80:	000980e7          	jalr	s3
  84:	fff44503          	lbu	a0,-1(s0)
  88:	fe9516e3          	bne	a0,s1,74 <.L38>

0000008c <.L34>:
  8c:	00044e03          	lbu	t3,0(s0)
  90:	fff00c13          	li	s8,-1
  94:	02000d13          	li	s10,32
  98:	00000493          	li	s1,0
  9c:	00000513          	li	a0,0
  a0:	000c0b93          	mv	s7,s8
  a4:	05500613          	li	a2,85
  a8:	00100313          	li	t1,1
  ac:	03000893          	li	a7,48
  b0:	00900593          	li	a1,9
  b4:	02d00813          	li	a6,45

000000b8 <.L39>:
  b8:	fdde0713          	addi	a4,t3,-35
  bc:	0ff77713          	andi	a4,a4,255
  c0:	00140c93          	addi	s9,s0,1
  c4:	32e66863          	bltu	a2,a4,3f4 <.L41>
  c8:	00271713          	slli	a4,a4,0x2
  cc:	01470733          	add	a4,a4,s4
  d0:	00072703          	lw	a4,0(a4)
  d4:	00070067          	jr	a4

000000d8 <.L32>:
  d8:	04c12083          	lw	ra,76(sp)
  dc:	04812403          	lw	s0,72(sp)
  e0:	04412483          	lw	s1,68(sp)
  e4:	04012903          	lw	s2,64(sp)
  e8:	03c12983          	lw	s3,60(sp)
  ec:	03812a03          	lw	s4,56(sp)
  f0:	03412a83          	lw	s5,52(sp)
  f4:	03012b03          	lw	s6,48(sp)
  f8:	02c12b83          	lw	s7,44(sp)
  fc:	02812c03          	lw	s8,40(sp)
 100:	02412c83          	lw	s9,36(sp)
 104:	02012d03          	lw	s10,32(sp)
 108:	01c12d83          	lw	s11,28(sp)
 10c:	05010113          	addi	sp,sp,80
 110:	00008067          	ret

00000114 <.L57>:
 114:	00100713          	li	a4,1
 118:	30a74a63          	blt	a4,a0,42c <.L125>
 11c:	000aa603          	lw	a2,0(s5)
 120:	00000693          	li	a3,0
 124:	004a8a93          	addi	s5,s5,4
 128:	01000713          	li	a4,16

0000012c <.L85>:
 12c:	000d0813          	mv	a6,s10
 130:	000b8793          	mv	a5,s7
 134:	00090593          	mv	a1,s2
 138:	00098513          	mv	a0,s3
 13c:	00000317          	auipc	t1,0x0
 140:	000300e7          	jalr	t1
 144:	f21ff06f          	j	64 <.L33>

00000148 <.L42>:
 148:	00144e03          	lbu	t3,1(s0)
 14c:	00030493          	mv	s1,t1
 150:	000c8413          	mv	s0,s9
 154:	f65ff06f          	j	b8 <.L39>

00000158 <.L49>:
 158:	000aa503          	lw	a0,0(s5)
 15c:	00090593          	mv	a1,s2
 160:	004a8a93          	addi	s5,s5,4
 164:	000980e7          	jalr	s3
 168:	efdff06f          	j	64 <.L33>

0000016c <.L50>:
 16c:	00100713          	li	a4,1
 170:	30a74863          	blt	a4,a0,480 <.L126>
 174:	000aa603          	lw	a2,0(s5)
 178:	004a8a93          	addi	s5,s5,4
 17c:	41f65693          	srai	a3,a2,0x1f

00000180 <.L83>:
 180:	00a00713          	li	a4,10
 184:	fa06d4e3          	bgez	a3,12c <.L85>
 188:	00090593          	mv	a1,s2
 18c:	02d00513          	li	a0,45
 190:	00d12623          	sw	a3,12(sp)
 194:	00c12423          	sw	a2,8(sp)
 198:	00e12223          	sw	a4,4(sp)
 19c:	000980e7          	jalr	s3
 1a0:	00812603          	lw	a2,8(sp)
 1a4:	00c12683          	lw	a3,12(sp)
 1a8:	00412703          	lw	a4,4(sp)
 1ac:	40c00633          	neg	a2,a2
 1b0:	00c035b3          	snez	a1,a2
 1b4:	40d006b3          	neg	a3,a3
 1b8:	40b686b3          	sub	a3,a3,a1
 1bc:	f71ff06f          	j	12c <.L85>

000001c0 <.L51>:
 1c0:	000aa783          	lw	a5,0(s5)
 1c4:	00600693          	li	a3,6
 1c8:	004a8a93          	addi	s5,s5,4
 1cc:	41f7d713          	srai	a4,a5,0x1f
 1d0:	00f747b3          	xor	a5,a4,a5
 1d4:	40e787b3          	sub	a5,a5,a4
 1d8:	2cf6c063          	blt	a3,a5,498 <.L64>
 1dc:	00279713          	slli	a4,a5,0x2
 1e0:	00eb0733          	add	a4,s6,a4
 1e4:	00072683          	lw	a3,0(a4)
 1e8:	2a068863          	beqz	a3,498 <.L64>
 1ec:	00000637          	lui	a2,0x0
 1f0:	00060613          	mv	a2,a2
 1f4:	00090593          	mv	a1,s2
 1f8:	00098513          	mv	a0,s3
 1fc:	00000317          	auipc	t1,0x0
 200:	000300e7          	jalr	t1
 204:	e61ff06f          	j	64 <.L33>

00000208 <.L52>:
 208:	00144e03          	lbu	t3,1(s0)
 20c:	00150513          	addi	a0,a0,1
 210:	000c8413          	mv	s0,s9
 214:	ea5ff06f          	j	b8 <.L39>

00000218 <.L53>:
 218:	00100713          	li	a4,1
 21c:	24a74463          	blt	a4,a0,464 <.L127>
 220:	000aa603          	lw	a2,0(s5)
 224:	00000693          	li	a3,0
 228:	004a8a93          	addi	s5,s5,4
 22c:	00800713          	li	a4,8
 230:	efdff06f          	j	12c <.L85>

00000234 <.L54>:
 234:	03000513          	li	a0,48
 238:	00090593          	mv	a1,s2
 23c:	000980e7          	jalr	s3
 240:	00090593          	mv	a1,s2
 244:	07800513          	li	a0,120
 248:	000980e7          	jalr	s3
 24c:	000aa603          	lw	a2,0(s5)
 250:	00000693          	li	a3,0
 254:	01000713          	li	a4,16
 258:	004a8a93          	addi	s5,s5,4
 25c:	ed1ff06f          	j	12c <.L85>

00000260 <.L55>:
 260:	000aad83          	lw	s11,0(s5)
 264:	004a8793          	addi	a5,s5,4
 268:	00f12223          	sw	a5,4(sp)
 26c:	240d8663          	beqz	s11,4b8 <.L128>

00000270 <.L66>:
 270:	25705863          	blez	s7,4c0 <.L67>
 274:	02d00713          	li	a4,45
 278:	24ed0863          	beq	s10,a4,4c8 <.L68>
 27c:	000c0513          	mv	a0,s8
 280:	001d8a93          	addi	s5,s11,1
 284:	020c0863          	beqz	s8,2b4 <.L70>
 288:	000dc603          	lbu	a2,0(s11)
 28c:	001d8a93          	addi	s5,s11,1
 290:	02060663          	beqz	a2,2bc <.L74>
 294:	018d88b3          	add	a7,s11,s8
 298:	000a8613          	mv	a2,s5
 29c:	0100006f          	j	2ac <.L72>

000002a0 <.L129>:
 2a0:	00160613          	addi	a2,a2,1 # 1 <vprintfmt+0x1>
 2a4:	fff64583          	lbu	a1,-1(a2)
 2a8:	00058663          	beqz	a1,2b4 <.L70>

000002ac <.L72>:
 2ac:	41b60533          	sub	a0,a2,s11
 2b0:	fec898e3          	bne	a7,a2,2a0 <.L129>

000002b4 <.L70>:
 2b4:	40ab8bb3          	sub	s7,s7,a0
 2b8:	01705c63          	blez	s7,2d0 <.L73>

000002bc <.L74>:
 2bc:	fffb8b93          	addi	s7,s7,-1
 2c0:	00090593          	mv	a1,s2
 2c4:	000d0513          	mv	a0,s10
 2c8:	000980e7          	jalr	s3
 2cc:	fe0b98e3          	bnez	s7,2bc <.L74>

000002d0 <.L73>:
 2d0:	000dc503          	lbu	a0,0(s11)
 2d4:	04050e63          	beqz	a0,330 <.L122>

000002d8 <.L94>:
 2d8:	fff00413          	li	s0,-1
 2dc:	05e00d93          	li	s11,94
 2e0:	03f00d13          	li	s10,63

000002e4 <.L77>:
 2e4:	000c4663          	bltz	s8,2f0 <.L79>
 2e8:	fffc0c13          	addi	s8,s8,-1
 2ec:	028c0463          	beq	s8,s0,314 <.L80>

000002f0 <.L79>:
 2f0:	00090593          	mv	a1,s2
 2f4:	00048663          	beqz	s1,300 <.L75>
 2f8:	fe050613          	addi	a2,a0,-32
 2fc:	12cde263          	bltu	s11,a2,420 <.L130>

00000300 <.L75>:
 300:	000980e7          	jalr	s3

00000304 <.L76>:
 304:	001a8a93          	addi	s5,s5,1
 308:	fffac503          	lbu	a0,-1(s5)
 30c:	fffb8b93          	addi	s7,s7,-1
 310:	fc051ae3          	bnez	a0,2e4 <.L77>

00000314 <.L80>:
 314:	01705e63          	blez	s7,330 <.L122>

00000318 <.L78>:
 318:	02000413          	li	s0,32

0000031c <.L81>:
 31c:	fffb8b93          	addi	s7,s7,-1
 320:	00090593          	mv	a1,s2
 324:	00040513          	mv	a0,s0
 328:	000980e7          	jalr	s3
 32c:	fe0b98e3          	bnez	s7,31c <.L81>

00000330 <.L122>:
 330:	00412a83          	lw	s5,4(sp)
 334:	d31ff06f          	j	64 <.L33>

00000338 <.L56>:
 338:	00100713          	li	a4,1
 33c:	10a74663          	blt	a4,a0,448 <.L131>
 340:	000aa603          	lw	a2,0(s5)
 344:	00000693          	li	a3,0
 348:	004a8a93          	addi	s5,s5,4
 34c:	00a00713          	li	a4,10
 350:	dddff06f          	j	12c <.L85>

00000354 <.L40>:
 354:	00144e03          	lbu	t3,1(s0)
 358:	00080d13          	mv	s10,a6
 35c:	000c8413          	mv	s0,s9
 360:	d59ff06f          	j	b8 <.L39>

00000364 <.L44>:
 364:	00090593          	mv	a1,s2
 368:	02500513          	li	a0,37
 36c:	000980e7          	jalr	s3
 370:	cf5ff06f          	j	64 <.L33>

00000374 <.L45>:
 374:	000aac03          	lw	s8,0(s5)
 378:	00144e03          	lbu	t3,1(s0)
 37c:	004a8a93          	addi	s5,s5,4
 380:	000c8413          	mv	s0,s9

00000384 <.L58>:
 384:	d20bdae3          	bgez	s7,b8 <.L39>
 388:	000c0b93          	mv	s7,s8
 38c:	fff00c13          	li	s8,-1
 390:	d29ff06f          	j	b8 <.L39>

00000394 <.L47>:
 394:	00144e03          	lbu	t3,1(s0)
 398:	00088d13          	mv	s10,a7
 39c:	000c8413          	mv	s0,s9
 3a0:	d19ff06f          	j	b8 <.L39>

000003a4 <.L48>:
 3a4:	00144e83          	lbu	t4,1(s0)
 3a8:	fd0e0c13          	addi	s8,t3,-48
 3ac:	fd0e8713          	addi	a4,t4,-48
 3b0:	12e5e863          	bltu	a1,a4,4e0 <.L96>
 3b4:	000c8413          	mv	s0,s9

000003b8 <.L61>:
 3b8:	002c1713          	slli	a4,s8,0x2
 3bc:	018706b3          	add	a3,a4,s8
 3c0:	00140413          	addi	s0,s0,1
 3c4:	00169693          	slli	a3,a3,0x1
 3c8:	01d686b3          	add	a3,a3,t4
 3cc:	00044e83          	lbu	t4,0(s0)
 3d0:	fd068c13          	addi	s8,a3,-48
 3d4:	fd0e8713          	addi	a4,t4,-48
 3d8:	fee5f0e3          	bleu	a4,a1,3b8 <.L61>
 3dc:	000e8e13          	mv	t3,t4
 3e0:	fa5ff06f          	j	384 <.L58>

000003e4 <.L46>:
 3e4:	0e0bca63          	bltz	s7,4d8 <.L132>

000003e8 <.L62>:
 3e8:	00144e03          	lbu	t3,1(s0)
 3ec:	000c8413          	mv	s0,s9
 3f0:	cc9ff06f          	j	b8 <.L39>

000003f4 <.L41>:
 3f4:	00090593          	mv	a1,s2
 3f8:	02500513          	li	a0,37
 3fc:	000980e7          	jalr	s3
 400:	fff44783          	lbu	a5,-1(s0)
 404:	02500713          	li	a4,37
 408:	00040c93          	mv	s9,s0
 40c:	c4e78ce3          	beq	a5,a4,64 <.L33>

00000410 <.L93>:
 410:	fffc8c93          	addi	s9,s9,-1
 414:	fffcc783          	lbu	a5,-1(s9)
 418:	fee79ce3          	bne	a5,a4,410 <.L93>
 41c:	c49ff06f          	j	64 <.L33>

00000420 <.L130>:
 420:	000d0513          	mv	a0,s10
 424:	000980e7          	jalr	s3
 428:	eddff06f          	j	304 <.L76>

0000042c <.L125>:
 42c:	007a8713          	addi	a4,s5,7
 430:	ff877713          	andi	a4,a4,-8
 434:	00870a93          	addi	s5,a4,8
 438:	00072603          	lw	a2,0(a4)
 43c:	00472683          	lw	a3,4(a4)
 440:	01000713          	li	a4,16
 444:	ce9ff06f          	j	12c <.L85>

00000448 <.L131>:
 448:	007a8713          	addi	a4,s5,7
 44c:	ff877713          	andi	a4,a4,-8
 450:	00870a93          	addi	s5,a4,8
 454:	00072603          	lw	a2,0(a4)
 458:	00472683          	lw	a3,4(a4)
 45c:	00a00713          	li	a4,10
 460:	ccdff06f          	j	12c <.L85>

00000464 <.L127>:
 464:	007a8713          	addi	a4,s5,7
 468:	ff877713          	andi	a4,a4,-8
 46c:	00870a93          	addi	s5,a4,8
 470:	00072603          	lw	a2,0(a4)
 474:	00472683          	lw	a3,4(a4)
 478:	00800713          	li	a4,8
 47c:	cb1ff06f          	j	12c <.L85>

00000480 <.L126>:
 480:	007a8713          	addi	a4,s5,7
 484:	ff877713          	andi	a4,a4,-8
 488:	00870a93          	addi	s5,a4,8
 48c:	00072603          	lw	a2,0(a4)
 490:	00472683          	lw	a3,4(a4)
 494:	cedff06f          	j	180 <.L83>

00000498 <.L64>:
 498:	00078693          	mv	a3,a5
 49c:	000007b7          	lui	a5,0x0
 4a0:	00078613          	mv	a2,a5
 4a4:	00090593          	mv	a1,s2
 4a8:	00098513          	mv	a0,s3
 4ac:	00000317          	auipc	t1,0x0
 4b0:	000300e7          	jalr	t1
 4b4:	bb1ff06f          	j	64 <.L33>

000004b8 <.L128>:
 4b8:	00012d83          	lw	s11,0(sp)
 4bc:	db5ff06f          	j	270 <.L66>

000004c0 <.L67>:
 4c0:	001d8a93          	addi	s5,s11,1
 4c4:	e0dff06f          	j	2d0 <.L73>

000004c8 <.L68>:
 4c8:	000dc503          	lbu	a0,0(s11)
 4cc:	001d8a93          	addi	s5,s11,1
 4d0:	e00514e3          	bnez	a0,2d8 <.L94>
 4d4:	e45ff06f          	j	318 <.L78>

000004d8 <.L132>:
 4d8:	00000b93          	li	s7,0
 4dc:	f0dff06f          	j	3e8 <.L62>

000004e0 <.L96>:
 4e0:	000e8e13          	mv	t3,t4
 4e4:	000c8413          	mv	s0,s9
 4e8:	e9dff06f          	j	384 <.L58>

Disassembly of section .text.vcprintf:

00000000 <vcprintf>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00050613          	mv	a2,a0
   8:	00000537          	lui	a0,0x0
   c:	00058693          	mv	a3,a1
  10:	00050513          	mv	a0,a0
  14:	00c10593          	addi	a1,sp,12
  18:	00112e23          	sw	ra,28(sp)
  1c:	00012623          	sw	zero,12(sp)
  20:	00000317          	auipc	t1,0x0
  24:	000300e7          	jalr	t1
  28:	01c12083          	lw	ra,28(sp)
  2c:	00c12503          	lw	a0,12(sp)
  30:	02010113          	addi	sp,sp,32
  34:	00008067          	ret

Disassembly of section .text.cprintf:

00000000 <cprintf>:
   0:	fc010113          	addi	sp,sp,-64
   4:	02410313          	addi	t1,sp,36
   8:	02c12423          	sw	a2,40(sp)
   c:	00050613          	mv	a2,a0
  10:	00000537          	lui	a0,0x0
  14:	02b12223          	sw	a1,36(sp)
  18:	02d12623          	sw	a3,44(sp)
  1c:	00050513          	mv	a0,a0
  20:	00c10593          	addi	a1,sp,12
  24:	00030693          	mv	a3,t1
  28:	00112e23          	sw	ra,28(sp)
  2c:	02e12823          	sw	a4,48(sp)
  30:	02f12a23          	sw	a5,52(sp)
  34:	03012c23          	sw	a6,56(sp)
  38:	03112e23          	sw	a7,60(sp)
  3c:	00612423          	sw	t1,8(sp)
  40:	00012623          	sw	zero,12(sp)
  44:	00000317          	auipc	t1,0x0
  48:	000300e7          	jalr	t1
  4c:	01c12083          	lw	ra,28(sp)
  50:	00c12503          	lw	a0,12(sp)
  54:	04010113          	addi	sp,sp,64
  58:	00008067          	ret

Disassembly of section .text.cputs:

00000000 <cputs>:
   0:	ff010113          	addi	sp,sp,-16
   4:	00912223          	sw	s1,4(sp)
   8:	00112623          	sw	ra,12(sp)
   c:	00812423          	sw	s0,8(sp)
  10:	01212023          	sw	s2,0(sp)
  14:	00050493          	mv	s1,a0
  18:	00054503          	lbu	a0,0(a0) # 0 <cputs>
  1c:	04050863          	beqz	a0,6c <.L140>
  20:	00148413          	addi	s0,s1,1
  24:	00000937          	lui	s2,0x0

00000028 <.L139>:
  28:	00092783          	lw	a5,0(s2) # 0 <cputs>
  2c:	000780e7          	jalr	a5
  30:	409407b3          	sub	a5,s0,s1
  34:	00140413          	addi	s0,s0,1
  38:	fff44503          	lbu	a0,-1(s0)
  3c:	fe0516e3          	bnez	a0,28 <.L139>
  40:	00178413          	addi	s0,a5,1 # 1 <cputs+0x1>

00000044 <.L138>:
  44:	00092783          	lw	a5,0(s2)
  48:	00a00513          	li	a0,10
  4c:	000780e7          	jalr	a5
  50:	00c12083          	lw	ra,12(sp)
  54:	00040513          	mv	a0,s0
  58:	00412483          	lw	s1,4(sp)
  5c:	00812403          	lw	s0,8(sp)
  60:	00012903          	lw	s2,0(sp)
  64:	01010113          	addi	sp,sp,16
  68:	00008067          	ret

0000006c <.L140>:
  6c:	00100413          	li	s0,1
  70:	00000937          	lui	s2,0x0
  74:	fd1ff06f          	j	44 <.L138>

Disassembly of section .text.kern_init:

00000000 <kern_init>:
   0:	ff010113          	addi	sp,sp,-16
   4:	00112623          	sw	ra,12(sp)
   8:	000007b7          	lui	a5,0x0

0000000c <.L0 >:
   c:	00000117          	auipc	sp,0x0
  10:	00010113          	mv	sp,sp
  14:	83000693          	li	a3,-2000
  18:	00000737          	lui	a4,0x0
  1c:	000007b7          	lui	a5,0x0
  20:	00d72023          	sw	a3,0(a4) # 0 <kern_init>
  24:	00000737          	lui	a4,0x0
  28:	00078693          	mv	a3,a5
  2c:	00070713          	mv	a4,a4
  30:	00078793          	mv	a5,a5
  34:	00d70863          	beq	a4,a3,44 <.L146>

00000038 <.L148>:
  38:	00178793          	addi	a5,a5,1 # 1 <kern_init+0x1>
  3c:	fe078fa3          	sb	zero,-1(a5)
  40:	fee79ce3          	bne	a5,a4,38 <.L148>

00000044 <.L146>:
  44:	000005b7          	lui	a1,0x0
  48:	00000537          	lui	a0,0x0
  4c:	00058593          	mv	a1,a1
  50:	00050513          	mv	a0,a0
  54:	00000317          	auipc	t1,0x0
  58:	000300e7          	jalr	t1

0000005c <.L145>:
  5c:	0000006f          	j	5c <.L145>
