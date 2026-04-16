
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00064117          	auipc	sp,0x64
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	65c000ef          	jal	ra,80200664 <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00001097          	auipc	ra,0x1
    80200018:	0dc080e7          	jalr	220(ra) # 802010f0 <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
}
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <consgetc>:

int consgetc()
{
    80200030:	1141                	addi	sp,sp,-16
    80200032:	e406                	sd	ra,8(sp)
    80200034:	e022                	sd	s0,0(sp)
    80200036:	0800                	addi	s0,sp,16
	return console_getchar();
    80200038:	00001097          	auipc	ra,0x1
    8020003c:	0ce080e7          	jalr	206(ra) # 80201106 <console_getchar>
    80200040:	60a2                	ld	ra,8(sp)
    80200042:	6402                	ld	s0,0(sp)
    80200044:	0141                	addi	sp,sp,16
    80200046:	8082                	ret

0000000080200048 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80200048:	1101                	addi	sp,sp,-32
    8020004a:	ec06                	sd	ra,24(sp)
    8020004c:	e822                	sd	s0,16(sp)
    8020004e:	e426                	sd	s1,8(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	84aa                	mv	s1,a0
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    80200054:	03451793          	slli	a5,a0,0x34
    80200058:	eb99                	bnez	a5,8020006e <kfree+0x26>
    8020005a:	0058e797          	auipc	a5,0x58e
    8020005e:	fa678793          	addi	a5,a5,-90 # 8078e000 <e_bss>
    80200062:	00f56663          	bltu	a0,a5,8020006e <kfree+0x26>
    80200066:	47c5                	li	a5,17
    80200068:	07ee                	slli	a5,a5,0x1b
    8020006a:	02f56e63          	bltu	a0,a5,802000a6 <kfree+0x5e>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
    8020006e:	00001097          	auipc	ra,0x1
    80200072:	8d8080e7          	jalr	-1832(ra) # 80200946 <threadid>
    80200076:	86aa                	mv	a3,a0
    80200078:	02500793          	li	a5,37
    8020007c:	00004717          	auipc	a4,0x4
    80200080:	f8470713          	addi	a4,a4,-124 # 80204000 <e_text>
    80200084:	00004617          	auipc	a2,0x4
    80200088:	f8c60613          	addi	a2,a2,-116 # 80204010 <e_text+0x10>
    8020008c:	45fd                	li	a1,31
    8020008e:	00004517          	auipc	a0,0x4
    80200092:	f8a50513          	addi	a0,a0,-118 # 80204018 <e_text+0x18>
    80200096:	00000097          	auipc	ra,0x0
    8020009a:	6da080e7          	jalr	1754(ra) # 80200770 <printf>
    8020009e:	00001097          	auipc	ra,0x1
    802000a2:	082080e7          	jalr	130(ra) # 80201120 <shutdown>
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    802000a6:	6605                	lui	a2,0x1
    802000a8:	4585                	li	a1,1
    802000aa:	8526                	mv	a0,s1
    802000ac:	00001097          	auipc	ra,0x1
    802000b0:	0a2080e7          	jalr	162(ra) # 8020114e <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    802000b4:	0058d797          	auipc	a5,0x58d
    802000b8:	f4c78793          	addi	a5,a5,-180 # 8078d000 <kmem>
    802000bc:	6398                	ld	a4,0(a5)
    802000be:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    802000c0:	e384                	sd	s1,0(a5)
}
    802000c2:	60e2                	ld	ra,24(sp)
    802000c4:	6442                	ld	s0,16(sp)
    802000c6:	64a2                	ld	s1,8(sp)
    802000c8:	6105                	addi	sp,sp,32
    802000ca:	8082                	ret

00000000802000cc <freerange>:
{
    802000cc:	7179                	addi	sp,sp,-48
    802000ce:	f406                	sd	ra,40(sp)
    802000d0:	f022                	sd	s0,32(sp)
    802000d2:	ec26                	sd	s1,24(sp)
    802000d4:	e84a                	sd	s2,16(sp)
    802000d6:	e44e                	sd	s3,8(sp)
    802000d8:	e052                	sd	s4,0(sp)
    802000da:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    802000dc:	6785                	lui	a5,0x1
    802000de:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    802000e2:	94aa                	add	s1,s1,a0
    802000e4:	757d                	lui	a0,0xfffff
    802000e6:	8ce9                	and	s1,s1,a0
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000e8:	94be                	add	s1,s1,a5
    802000ea:	0095ee63          	bltu	a1,s1,80200106 <freerange+0x3a>
    802000ee:	892e                	mv	s2,a1
		kfree(p);
    802000f0:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000f2:	6985                	lui	s3,0x1
		kfree(p);
    802000f4:	01448533          	add	a0,s1,s4
    802000f8:	00000097          	auipc	ra,0x0
    802000fc:	f50080e7          	jalr	-176(ra) # 80200048 <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80200100:	94ce                	add	s1,s1,s3
    80200102:	fe9979e3          	bgeu	s2,s1,802000f4 <freerange+0x28>
}
    80200106:	70a2                	ld	ra,40(sp)
    80200108:	7402                	ld	s0,32(sp)
    8020010a:	64e2                	ld	s1,24(sp)
    8020010c:	6942                	ld	s2,16(sp)
    8020010e:	69a2                	ld	s3,8(sp)
    80200110:	6a02                	ld	s4,0(sp)
    80200112:	6145                	addi	sp,sp,48
    80200114:	8082                	ret

0000000080200116 <kinit>:
{
    80200116:	1141                	addi	sp,sp,-16
    80200118:	e406                	sd	ra,8(sp)
    8020011a:	e022                	sd	s0,0(sp)
    8020011c:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    8020011e:	45c5                	li	a1,17
    80200120:	05ee                	slli	a1,a1,0x1b
    80200122:	0058e517          	auipc	a0,0x58e
    80200126:	ede50513          	addi	a0,a0,-290 # 8078e000 <e_bss>
    8020012a:	00000097          	auipc	ra,0x0
    8020012e:	fa2080e7          	jalr	-94(ra) # 802000cc <freerange>
}
    80200132:	60a2                	ld	ra,8(sp)
    80200134:	6402                	ld	s0,0(sp)
    80200136:	0141                	addi	sp,sp,16
    80200138:	8082                	ret

000000008020013a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc()
{
    8020013a:	1101                	addi	sp,sp,-32
    8020013c:	ec06                	sd	ra,24(sp)
    8020013e:	e822                	sd	s0,16(sp)
    80200140:	e426                	sd	s1,8(sp)
    80200142:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    80200144:	0058d497          	auipc	s1,0x58d
    80200148:	ebc4b483          	ld	s1,-324(s1) # 8078d000 <kmem>
	if (l) {
    8020014c:	cc89                	beqz	s1,80200166 <kalloc+0x2c>
		kmem.freelist = l->next;
    8020014e:	609c                	ld	a5,0(s1)
    80200150:	0058d717          	auipc	a4,0x58d
    80200154:	eaf73823          	sd	a5,-336(a4) # 8078d000 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    80200158:	6605                	lui	a2,0x1
    8020015a:	4595                	li	a1,5
    8020015c:	8526                	mv	a0,s1
    8020015e:	00001097          	auipc	ra,0x1
    80200162:	ff0080e7          	jalr	-16(ra) # 8020114e <memset>
	}
	return (void *)l;
    80200166:	8526                	mv	a0,s1
    80200168:	60e2                	ld	ra,24(sp)
    8020016a:	6442                	ld	s0,16(sp)
    8020016c:	64a2                	ld	s1,8(sp)
    8020016e:	6105                	addi	sp,sp,32
    80200170:	8082                	ret

0000000080200172 <loader_init>:
extern char _app_num[], _app_names[], INIT_PROC[];
char names[MAX_APP_NUM][MAX_STR_LEN];

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void loader_init()
{
    80200172:	7139                	addi	sp,sp,-64
    80200174:	fc06                	sd	ra,56(sp)
    80200176:	f822                	sd	s0,48(sp)
    80200178:	f426                	sd	s1,40(sp)
    8020017a:	f04a                	sd	s2,32(sp)
    8020017c:	ec4e                	sd	s3,24(sp)
    8020017e:	e852                	sd	s4,16(sp)
    80200180:	e456                	sd	s5,8(sp)
    80200182:	e05a                	sd	s6,0(sp)
    80200184:	0080                	addi	s0,sp,64
	char *s;
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    80200186:	0058d497          	auipc	s1,0x58d
    8020018a:	e8a48493          	addi	s1,s1,-374 # 8078d010 <app_num>
    8020018e:	00005697          	auipc	a3,0x5
    80200192:	e7268693          	addi	a3,a3,-398 # 80205000 <_app_num>
    80200196:	0006c783          	lbu	a5,0(a3)
    8020019a:	0016c703          	lbu	a4,1(a3)
    8020019e:	0722                	slli	a4,a4,0x8
    802001a0:	8f5d                	or	a4,a4,a5
    802001a2:	0026c783          	lbu	a5,2(a3)
    802001a6:	07c2                	slli	a5,a5,0x10
    802001a8:	8f5d                	or	a4,a4,a5
    802001aa:	0036c783          	lbu	a5,3(a3)
    802001ae:	07e2                	slli	a5,a5,0x18
    802001b0:	8fd9                	or	a5,a5,a4
    802001b2:	c09c                	sw	a5,0(s1)
	app_info_ptr++;
    802001b4:	00005797          	auipc	a5,0x5
    802001b8:	e5478793          	addi	a5,a5,-428 # 80205008 <_app_num+0x8>
    802001bc:	0058d717          	auipc	a4,0x58d
    802001c0:	e4f73623          	sd	a5,-436(a4) # 8078d008 <app_info_ptr>
	s = _app_names;
	printf("app list:\n");
    802001c4:	00004517          	auipc	a0,0x4
    802001c8:	e7450513          	addi	a0,a0,-396 # 80204038 <e_text+0x38>
    802001cc:	00000097          	auipc	ra,0x0
    802001d0:	5a4080e7          	jalr	1444(ra) # 80200770 <printf>
	for (int i = 0; i < app_num; ++i) {
    802001d4:	409c                	lw	a5,0(s1)
    802001d6:	04f05c63          	blez	a5,8020022e <loader_init+0xbc>
    802001da:	00064997          	auipc	s3,0x64
    802001de:	e2698993          	addi	s3,s3,-474 # 80264000 <names>
    802001e2:	4a01                	li	s4,0
	s = _app_names;
    802001e4:	00005917          	auipc	s2,0x5
    802001e8:	f5c90913          	addi	s2,s2,-164 # 80205140 <_app_names>
		int len = strlen(s);
		strncpy(names[i], (const char *)s, len);
		s += len + 1;
		printf("%s\n", names[i]);
    802001ec:	00004b17          	auipc	s6,0x4
    802001f0:	e5cb0b13          	addi	s6,s6,-420 # 80204048 <e_text+0x48>
	for (int i = 0; i < app_num; ++i) {
    802001f4:	8aa6                	mv	s5,s1
		int len = strlen(s);
    802001f6:	854a                	mv	a0,s2
    802001f8:	00001097          	auipc	ra,0x1
    802001fc:	0da080e7          	jalr	218(ra) # 802012d2 <strlen>
    80200200:	84aa                	mv	s1,a0
		strncpy(names[i], (const char *)s, len);
    80200202:	862a                	mv	a2,a0
    80200204:	85ca                	mv	a1,s2
    80200206:	854e                	mv	a0,s3
    80200208:	00001097          	auipc	ra,0x1
    8020020c:	05a080e7          	jalr	90(ra) # 80201262 <strncpy>
		s += len + 1;
    80200210:	0485                	addi	s1,s1,1
    80200212:	9926                	add	s2,s2,s1
		printf("%s\n", names[i]);
    80200214:	85ce                	mv	a1,s3
    80200216:	855a                	mv	a0,s6
    80200218:	00000097          	auipc	ra,0x0
    8020021c:	558080e7          	jalr	1368(ra) # 80200770 <printf>
	for (int i = 0; i < app_num; ++i) {
    80200220:	2a05                	addiw	s4,s4,1
    80200222:	0c898993          	addi	s3,s3,200
    80200226:	000aa783          	lw	a5,0(s5)
    8020022a:	fcfa46e3          	blt	s4,a5,802001f6 <loader_init+0x84>
	}
}
    8020022e:	70e2                	ld	ra,56(sp)
    80200230:	7442                	ld	s0,48(sp)
    80200232:	74a2                	ld	s1,40(sp)
    80200234:	7902                	ld	s2,32(sp)
    80200236:	69e2                	ld	s3,24(sp)
    80200238:	6a42                	ld	s4,16(sp)
    8020023a:	6aa2                	ld	s5,8(sp)
    8020023c:	6b02                	ld	s6,0(sp)
    8020023e:	6121                	addi	sp,sp,64
    80200240:	8082                	ret

0000000080200242 <get_id_by_name>:

int get_id_by_name(char *name)
{
    80200242:	7179                	addi	sp,sp,-48
    80200244:	f406                	sd	ra,40(sp)
    80200246:	f022                	sd	s0,32(sp)
    80200248:	ec26                	sd	s1,24(sp)
    8020024a:	e84a                	sd	s2,16(sp)
    8020024c:	e44e                	sd	s3,8(sp)
    8020024e:	e052                	sd	s4,0(sp)
    80200250:	1800                	addi	s0,sp,48
    80200252:	89aa                	mv	s3,a0
	for (int i = 0; i < app_num; ++i) {
    80200254:	0058d797          	auipc	a5,0x58d
    80200258:	dbc7a783          	lw	a5,-580(a5) # 8078d010 <app_num>
    8020025c:	02f05b63          	blez	a5,80200292 <get_id_by_name+0x50>
    80200260:	00064917          	auipc	s2,0x64
    80200264:	da090913          	addi	s2,s2,-608 # 80264000 <names>
    80200268:	4481                	li	s1,0
    8020026a:	0058da17          	auipc	s4,0x58d
    8020026e:	da6a0a13          	addi	s4,s4,-602 # 8078d010 <app_num>
		if (strncmp(name, names[i], 100) == 0)
    80200272:	06400613          	li	a2,100
    80200276:	85ca                	mv	a1,s2
    80200278:	854e                	mv	a0,s3
    8020027a:	00001097          	auipc	ra,0x1
    8020027e:	fac080e7          	jalr	-84(ra) # 80201226 <strncmp>
    80200282:	cd19                	beqz	a0,802002a0 <get_id_by_name+0x5e>
	for (int i = 0; i < app_num; ++i) {
    80200284:	2485                	addiw	s1,s1,1
    80200286:	0c890913          	addi	s2,s2,200
    8020028a:	000a2783          	lw	a5,0(s4)
    8020028e:	fef4c2e3          	blt	s1,a5,80200272 <get_id_by_name+0x30>
			return i;
	}
	warnf("Cannot find such app %s", name);
    80200292:	85ce                	mv	a1,s3
    80200294:	4501                	li	a0,0
    80200296:	00001097          	auipc	ra,0x1
    8020029a:	066080e7          	jalr	102(ra) # 802012fc <dummy>
	return -1;
    8020029e:	54fd                	li	s1,-1
}
    802002a0:	8526                	mv	a0,s1
    802002a2:	70a2                	ld	ra,40(sp)
    802002a4:	7402                	ld	s0,32(sp)
    802002a6:	64e2                	ld	s1,24(sp)
    802002a8:	6942                	ld	s2,16(sp)
    802002aa:	69a2                	ld	s3,8(sp)
    802002ac:	6a02                	ld	s4,0(sp)
    802002ae:	6145                	addi	sp,sp,48
    802002b0:	8082                	ret

00000000802002b2 <bin_loader>:

int bin_loader(uint64 start, uint64 end, struct proc *p)
{
    802002b2:	7119                	addi	sp,sp,-128
    802002b4:	fc86                	sd	ra,120(sp)
    802002b6:	f8a2                	sd	s0,112(sp)
    802002b8:	f4a6                	sd	s1,104(sp)
    802002ba:	f0ca                	sd	s2,96(sp)
    802002bc:	ecce                	sd	s3,88(sp)
    802002be:	e8d2                	sd	s4,80(sp)
    802002c0:	e4d6                	sd	s5,72(sp)
    802002c2:	e0da                	sd	s6,64(sp)
    802002c4:	fc5e                	sd	s7,56(sp)
    802002c6:	f862                	sd	s8,48(sp)
    802002c8:	f466                	sd	s9,40(sp)
    802002ca:	f06a                	sd	s10,32(sp)
    802002cc:	ec6e                	sd	s11,24(sp)
    802002ce:	0100                	addi	s0,sp,128
    802002d0:	8caa                	mv	s9,a0
    802002d2:	8c2e                	mv	s8,a1
    802002d4:	8a32                	mv	s4,a2
	if (p == NULL || p->state == UNUSED)
    802002d6:	c219                	beqz	a2,802002dc <bin_loader+0x2a>
    802002d8:	421c                	lw	a5,0(a2)
    802002da:	ef8d                	bnez	a5,80200314 <bin_loader+0x62>
		panic("...");
    802002dc:	00000097          	auipc	ra,0x0
    802002e0:	66a080e7          	jalr	1642(ra) # 80200946 <threadid>
    802002e4:	86aa                	mv	a3,a0
    802002e6:	02900793          	li	a5,41
    802002ea:	00004717          	auipc	a4,0x4
    802002ee:	d6670713          	addi	a4,a4,-666 # 80204050 <e_text+0x50>
    802002f2:	00004617          	auipc	a2,0x4
    802002f6:	d1e60613          	addi	a2,a2,-738 # 80204010 <e_text+0x10>
    802002fa:	45fd                	li	a1,31
    802002fc:	00004517          	auipc	a0,0x4
    80200300:	d6450513          	addi	a0,a0,-668 # 80204060 <e_text+0x60>
    80200304:	00000097          	auipc	ra,0x0
    80200308:	46c080e7          	jalr	1132(ra) # 80200770 <printf>
    8020030c:	00001097          	auipc	ra,0x1
    80200310:	e14080e7          	jalr	-492(ra) # 80201120 <shutdown>
	void *page;
	uint64 pa_start = PGROUNDDOWN(start);
    80200314:	77fd                	lui	a5,0xfffff
    80200316:	00fcf9b3          	and	s3,s9,a5
	uint64 pa_end = PGROUNDUP(end);
    8020031a:	6b05                	lui	s6,0x1
    8020031c:	1b7d                	addi	s6,s6,-1
    8020031e:	9b62                	add	s6,s6,s8
    80200320:	00fb7b33          	and	s6,s6,a5
	uint64 length = pa_end - pa_start;
    80200324:	6789                	lui	a5,0x2
    80200326:	97da                	add	a5,a5,s6
    80200328:	f8f43023          	sd	a5,-128(s0)
	uint64 va_start = BASE_ADDRESS;
	uint64 va_end = BASE_ADDRESS + length;
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    8020032c:	1169f563          	bgeu	s3,s6,80200436 <bin_loader+0x184>
    80200330:	84ce                	mv	s1,s3
    80200332:	6a85                	lui	s5,0x1
    80200334:	413a8d33          	sub	s10,s5,s3
	     va += PGSIZE, pa += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    80200338:	00004d97          	auipc	s11,0x4
    8020033c:	d18d8d93          	addi	s11,s11,-744 # 80204050 <e_text+0x50>
		}
		memmove(page, (const void *)pa, PGSIZE);
		if (pa < start) {
			memset(page, 0, start - va);
		} else if (pa + PAGE_SIZE > end) {
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    80200340:	6785                	lui	a5,0x1
    80200342:	418787bb          	subw	a5,a5,s8
    80200346:	f8f42623          	sw	a5,-116(s0)
			memset(page, 0, start - va);
    8020034a:	77fd                	lui	a5,0xfffff
    8020034c:	019787bb          	addw	a5,a5,s9
    80200350:	013787bb          	addw	a5,a5,s3
    80200354:	f8f42423          	sw	a5,-120(s0)
    80200358:	a09d                	j	802003be <bin_loader+0x10c>
			panic("...");
    8020035a:	00000097          	auipc	ra,0x0
    8020035e:	5ec080e7          	jalr	1516(ra) # 80200946 <threadid>
    80200362:	86aa                	mv	a3,a0
    80200364:	03400793          	li	a5,52
    80200368:	876e                	mv	a4,s11
    8020036a:	00004617          	auipc	a2,0x4
    8020036e:	ca660613          	addi	a2,a2,-858 # 80204010 <e_text+0x10>
    80200372:	45fd                	li	a1,31
    80200374:	00004517          	auipc	a0,0x4
    80200378:	cec50513          	addi	a0,a0,-788 # 80204060 <e_text+0x60>
    8020037c:	00000097          	auipc	ra,0x0
    80200380:	3f4080e7          	jalr	1012(ra) # 80200770 <printf>
    80200384:	00001097          	auipc	ra,0x1
    80200388:	d9c080e7          	jalr	-612(ra) # 80201120 <shutdown>
    8020038c:	a089                	j	802003ce <bin_loader+0x11c>
			memset(page, 0, start - va);
    8020038e:	f8842783          	lw	a5,-120(s0)
    80200392:	4097863b          	subw	a2,a5,s1
    80200396:	4581                	li	a1,0
    80200398:	854a                	mv	a0,s2
    8020039a:	00001097          	auipc	ra,0x1
    8020039e:	db4080e7          	jalr	-588(ra) # 8020114e <memset>
		}
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802003a2:	4779                	li	a4,30
    802003a4:	86ca                	mv	a3,s2
    802003a6:	8656                	mv	a2,s5
    802003a8:	85de                	mv	a1,s7
    802003aa:	008a3503          	ld	a0,8(s4)
    802003ae:	00002097          	auipc	ra,0x2
    802003b2:	c06080e7          	jalr	-1018(ra) # 80201fb4 <mappages>
    802003b6:	e531                	bnez	a0,80200402 <bin_loader+0x150>
	     va += PGSIZE, pa += PGSIZE) {
    802003b8:	94d6                	add	s1,s1,s5
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    802003ba:	0764fe63          	bgeu	s1,s6,80200436 <bin_loader+0x184>
    802003be:	009d0bb3          	add	s7,s10,s1
		page = kalloc();
    802003c2:	00000097          	auipc	ra,0x0
    802003c6:	d78080e7          	jalr	-648(ra) # 8020013a <kalloc>
    802003ca:	892a                	mv	s2,a0
		if (page == 0) {
    802003cc:	d559                	beqz	a0,8020035a <bin_loader+0xa8>
		memmove(page, (const void *)pa, PGSIZE);
    802003ce:	8656                	mv	a2,s5
    802003d0:	85a6                	mv	a1,s1
    802003d2:	854a                	mv	a0,s2
    802003d4:	00001097          	auipc	ra,0x1
    802003d8:	dd6080e7          	jalr	-554(ra) # 802011aa <memmove>
		if (pa < start) {
    802003dc:	fb94e9e3          	bltu	s1,s9,8020038e <bin_loader+0xdc>
		} else if (pa + PAGE_SIZE > end) {
    802003e0:	015487b3          	add	a5,s1,s5
    802003e4:	fafc7fe3          	bgeu	s8,a5,802003a2 <bin_loader+0xf0>
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    802003e8:	409c0533          	sub	a0,s8,s1
    802003ec:	f8c42783          	lw	a5,-116(s0)
    802003f0:	0097863b          	addw	a2,a5,s1
    802003f4:	4581                	li	a1,0
    802003f6:	954a                	add	a0,a0,s2
    802003f8:	00001097          	auipc	ra,0x1
    802003fc:	d56080e7          	jalr	-682(ra) # 8020114e <memset>
    80200400:	b74d                	j	802003a2 <bin_loader+0xf0>
			     PTE_U | PTE_R | PTE_W | PTE_X) != 0)
			panic("...");
    80200402:	00000097          	auipc	ra,0x0
    80200406:	544080e7          	jalr	1348(ra) # 80200946 <threadid>
    8020040a:	86aa                	mv	a3,a0
    8020040c:	03e00793          	li	a5,62
    80200410:	876e                	mv	a4,s11
    80200412:	00004617          	auipc	a2,0x4
    80200416:	bfe60613          	addi	a2,a2,-1026 # 80204010 <e_text+0x10>
    8020041a:	45fd                	li	a1,31
    8020041c:	00004517          	auipc	a0,0x4
    80200420:	c4450513          	addi	a0,a0,-956 # 80204060 <e_text+0x60>
    80200424:	00000097          	auipc	ra,0x0
    80200428:	34c080e7          	jalr	844(ra) # 80200770 <printf>
    8020042c:	00001097          	auipc	ra,0x1
    80200430:	cf4080e7          	jalr	-780(ra) # 80201120 <shutdown>
    80200434:	b751                	j	802003b8 <bin_loader+0x106>
	}
	// map ustack
	p->ustack = va_end + PAGE_SIZE;
    80200436:	f8043783          	ld	a5,-128(s0)
    8020043a:	413789b3          	sub	s3,a5,s3
    8020043e:	013a3823          	sd	s3,16(s4)
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200442:	6785                	lui	a5,0x1
    80200444:	97ce                	add	a5,a5,s3
    80200446:	0af9f663          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
	     va += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    8020044a:	00004b17          	auipc	s6,0x4
    8020044e:	c06b0b13          	addi	s6,s6,-1018 # 80204050 <e_text+0x50>
    80200452:	00004a97          	auipc	s5,0x4
    80200456:	bbea8a93          	addi	s5,s5,-1090 # 80204010 <e_text+0x10>
    8020045a:	00004917          	auipc	s2,0x4
    8020045e:	c0690913          	addi	s2,s2,-1018 # 80204060 <e_text+0x60>
    80200462:	a825                	j	8020049a <bin_loader+0x1e8>
    80200464:	00000097          	auipc	ra,0x0
    80200468:	4e2080e7          	jalr	1250(ra) # 80200946 <threadid>
    8020046c:	86aa                	mv	a3,a0
    8020046e:	04600793          	li	a5,70
    80200472:	875a                	mv	a4,s6
    80200474:	8656                	mv	a2,s5
    80200476:	45fd                	li	a1,31
    80200478:	854a                	mv	a0,s2
    8020047a:	00000097          	auipc	ra,0x0
    8020047e:	2f6080e7          	jalr	758(ra) # 80200770 <printf>
    80200482:	00001097          	auipc	ra,0x1
    80200486:	c9e080e7          	jalr	-866(ra) # 80201120 <shutdown>
    8020048a:	a831                	j	802004a6 <bin_loader+0x1f4>
	     va += PGSIZE) {
    8020048c:	6785                	lui	a5,0x1
    8020048e:	99be                	add	s3,s3,a5
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200490:	010a3703          	ld	a4,16(s4)
    80200494:	97ba                	add	a5,a5,a4
    80200496:	04f9fe63          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
		page = kalloc();
    8020049a:	00000097          	auipc	ra,0x0
    8020049e:	ca0080e7          	jalr	-864(ra) # 8020013a <kalloc>
    802004a2:	84aa                	mv	s1,a0
		if (page == 0) {
    802004a4:	d161                	beqz	a0,80200464 <bin_loader+0x1b2>
		}
		memset(page, 0, PGSIZE);
    802004a6:	6605                	lui	a2,0x1
    802004a8:	4581                	li	a1,0
    802004aa:	8526                	mv	a0,s1
    802004ac:	00001097          	auipc	ra,0x1
    802004b0:	ca2080e7          	jalr	-862(ra) # 8020114e <memset>
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802004b4:	4759                	li	a4,22
    802004b6:	86a6                	mv	a3,s1
    802004b8:	6605                	lui	a2,0x1
    802004ba:	85ce                	mv	a1,s3
    802004bc:	008a3503          	ld	a0,8(s4)
    802004c0:	00002097          	auipc	ra,0x2
    802004c4:	af4080e7          	jalr	-1292(ra) # 80201fb4 <mappages>
    802004c8:	d171                	beqz	a0,8020048c <bin_loader+0x1da>
			     PTE_U | PTE_R | PTE_W) != 0)
			panic("...");
    802004ca:	00000097          	auipc	ra,0x0
    802004ce:	47c080e7          	jalr	1148(ra) # 80200946 <threadid>
    802004d2:	86aa                	mv	a3,a0
    802004d4:	04b00793          	li	a5,75
    802004d8:	875a                	mv	a4,s6
    802004da:	8656                	mv	a2,s5
    802004dc:	45fd                	li	a1,31
    802004de:	854a                	mv	a0,s2
    802004e0:	00000097          	auipc	ra,0x0
    802004e4:	290080e7          	jalr	656(ra) # 80200770 <printf>
    802004e8:	00001097          	auipc	ra,0x1
    802004ec:	c38080e7          	jalr	-968(ra) # 80201120 <shutdown>
    802004f0:	bf71                	j	8020048c <bin_loader+0x1da>
	}
	p->trapframe->sp = p->ustack + USTACK_SIZE;
    802004f2:	020a3703          	ld	a4,32(s4)
    802004f6:	fb1c                	sd	a5,48(a4)
	p->trapframe->epc = va_start;
    802004f8:	020a3783          	ld	a5,32(s4)
    802004fc:	6705                	lui	a4,0x1
    802004fe:	ef98                	sd	a4,24(a5)
	p->max_page = PGROUNDUP(p->ustack + USTACK_SIZE - 1) / PAGE_SIZE;
    80200500:	010a3783          	ld	a5,16(s4)
    80200504:	6709                	lui	a4,0x2
    80200506:	1779                	addi	a4,a4,-2
    80200508:	97ba                	add	a5,a5,a4
    8020050a:	83b1                	srli	a5,a5,0xc
    8020050c:	08fa3c23          	sd	a5,152(s4)
	p->state = RUNNABLE;
    80200510:	478d                	li	a5,3
    80200512:	00fa2023          	sw	a5,0(s4)
	return 0;
}
    80200516:	4501                	li	a0,0
    80200518:	70e6                	ld	ra,120(sp)
    8020051a:	7446                	ld	s0,112(sp)
    8020051c:	74a6                	ld	s1,104(sp)
    8020051e:	7906                	ld	s2,96(sp)
    80200520:	69e6                	ld	s3,88(sp)
    80200522:	6a46                	ld	s4,80(sp)
    80200524:	6aa6                	ld	s5,72(sp)
    80200526:	6b06                	ld	s6,64(sp)
    80200528:	7be2                	ld	s7,56(sp)
    8020052a:	7c42                	ld	s8,48(sp)
    8020052c:	7ca2                	ld	s9,40(sp)
    8020052e:	7d02                	ld	s10,32(sp)
    80200530:	6de2                	ld	s11,24(sp)
    80200532:	6109                	addi	sp,sp,128
    80200534:	8082                	ret

0000000080200536 <loader>:

int loader(int app_id, struct proc *p)
{
    80200536:	1141                	addi	sp,sp,-16
    80200538:	e406                	sd	ra,8(sp)
    8020053a:	e022                	sd	s0,0(sp)
    8020053c:	0800                	addi	s0,sp,16
    8020053e:	862e                	mv	a2,a1
	return bin_loader(app_info_ptr[app_id], app_info_ptr[app_id + 1], p);
    80200540:	00351793          	slli	a5,a0,0x3
    80200544:	0058d517          	auipc	a0,0x58d
    80200548:	ac453503          	ld	a0,-1340(a0) # 8078d008 <app_info_ptr>
    8020054c:	953e                	add	a0,a0,a5
    8020054e:	650c                	ld	a1,8(a0)
    80200550:	6108                	ld	a0,0(a0)
    80200552:	00000097          	auipc	ra,0x0
    80200556:	d60080e7          	jalr	-672(ra) # 802002b2 <bin_loader>
}
    8020055a:	60a2                	ld	ra,8(sp)
    8020055c:	6402                	ld	s0,0(sp)
    8020055e:	0141                	addi	sp,sp,16
    80200560:	8082                	ret

0000000080200562 <load_init_app>:

// load all apps and init the corresponding `proc` structure.
int load_init_app()
{
    80200562:	1101                	addi	sp,sp,-32
    80200564:	ec06                	sd	ra,24(sp)
    80200566:	e822                	sd	s0,16(sp)
    80200568:	e426                	sd	s1,8(sp)
    8020056a:	e04a                	sd	s2,0(sp)
    8020056c:	1000                	addi	s0,sp,32
	int id = get_id_by_name(INIT_PROC);
    8020056e:	00005517          	auipc	a0,0x5
    80200572:	da050513          	addi	a0,a0,-608 # 8020530e <INIT_PROC>
    80200576:	00000097          	auipc	ra,0x0
    8020057a:	ccc080e7          	jalr	-820(ra) # 80200242 <get_id_by_name>
    8020057e:	84aa                	mv	s1,a0
	if (id < 0)
    80200580:	02054e63          	bltz	a0,802005bc <load_init_app+0x5a>
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
	struct proc *p = allocproc();
    80200584:	00000097          	auipc	ra,0x0
    80200588:	55e080e7          	jalr	1374(ra) # 80200ae2 <allocproc>
    8020058c:	892a                	mv	s2,a0
	if (p == NULL) {
    8020058e:	c925                	beqz	a0,802005fe <load_init_app+0x9c>
		panic("allocproc\n");
	}
	debugf("load init proc %s", INIT_PROC);
    80200590:	00005597          	auipc	a1,0x5
    80200594:	d7e58593          	addi	a1,a1,-642 # 8020530e <INIT_PROC>
    80200598:	4501                	li	a0,0
    8020059a:	00001097          	auipc	ra,0x1
    8020059e:	d62080e7          	jalr	-670(ra) # 802012fc <dummy>
	loader(id, p);
    802005a2:	85ca                	mv	a1,s2
    802005a4:	8526                	mv	a0,s1
    802005a6:	00000097          	auipc	ra,0x0
    802005aa:	f90080e7          	jalr	-112(ra) # 80200536 <loader>
	return 0;
    802005ae:	4501                	li	a0,0
    802005b0:	60e2                	ld	ra,24(sp)
    802005b2:	6442                	ld	s0,16(sp)
    802005b4:	64a2                	ld	s1,8(sp)
    802005b6:	6902                	ld	s2,0(sp)
    802005b8:	6105                	addi	sp,sp,32
    802005ba:	8082                	ret
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
    802005bc:	00000097          	auipc	ra,0x0
    802005c0:	38a080e7          	jalr	906(ra) # 80200946 <threadid>
    802005c4:	86aa                	mv	a3,a0
    802005c6:	00005817          	auipc	a6,0x5
    802005ca:	d4880813          	addi	a6,a6,-696 # 8020530e <INIT_PROC>
    802005ce:	05e00793          	li	a5,94
    802005d2:	00004717          	auipc	a4,0x4
    802005d6:	a7e70713          	addi	a4,a4,-1410 # 80204050 <e_text+0x50>
    802005da:	00004617          	auipc	a2,0x4
    802005de:	a3660613          	addi	a2,a2,-1482 # 80204010 <e_text+0x10>
    802005e2:	45fd                	li	a1,31
    802005e4:	00004517          	auipc	a0,0x4
    802005e8:	a9c50513          	addi	a0,a0,-1380 # 80204080 <e_text+0x80>
    802005ec:	00000097          	auipc	ra,0x0
    802005f0:	184080e7          	jalr	388(ra) # 80200770 <printf>
    802005f4:	00001097          	auipc	ra,0x1
    802005f8:	b2c080e7          	jalr	-1236(ra) # 80201120 <shutdown>
    802005fc:	b761                	j	80200584 <load_init_app+0x22>
		panic("allocproc\n");
    802005fe:	00000097          	auipc	ra,0x0
    80200602:	348080e7          	jalr	840(ra) # 80200946 <threadid>
    80200606:	86aa                	mv	a3,a0
    80200608:	06100793          	li	a5,97
    8020060c:	00004717          	auipc	a4,0x4
    80200610:	a4470713          	addi	a4,a4,-1468 # 80204050 <e_text+0x50>
    80200614:	00004617          	auipc	a2,0x4
    80200618:	9fc60613          	addi	a2,a2,-1540 # 80204010 <e_text+0x10>
    8020061c:	45fd                	li	a1,31
    8020061e:	00004517          	auipc	a0,0x4
    80200622:	a9a50513          	addi	a0,a0,-1382 # 802040b8 <e_text+0xb8>
    80200626:	00000097          	auipc	ra,0x0
    8020062a:	14a080e7          	jalr	330(ra) # 80200770 <printf>
    8020062e:	00001097          	auipc	ra,0x1
    80200632:	af2080e7          	jalr	-1294(ra) # 80201120 <shutdown>
    80200636:	bfa9                	j	80200590 <load_init_app+0x2e>

0000000080200638 <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    80200638:	1141                	addi	sp,sp,-16
    8020063a:	e406                	sd	ra,8(sp)
    8020063c:	e022                	sd	s0,0(sp)
    8020063e:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    80200640:	00064517          	auipc	a0,0x64
    80200644:	9c050513          	addi	a0,a0,-1600 # 80264000 <names>
    80200648:	0058e617          	auipc	a2,0x58e
    8020064c:	9b860613          	addi	a2,a2,-1608 # 8078e000 <e_bss>
    80200650:	9e09                	subw	a2,a2,a0
    80200652:	4581                	li	a1,0
    80200654:	00001097          	auipc	ra,0x1
    80200658:	afa080e7          	jalr	-1286(ra) # 8020114e <memset>
}
    8020065c:	60a2                	ld	ra,8(sp)
    8020065e:	6402                	ld	s0,0(sp)
    80200660:	0141                	addi	sp,sp,16
    80200662:	8082                	ret

0000000080200664 <main>:

void main()
{
    80200664:	1141                	addi	sp,sp,-16
    80200666:	e406                	sd	ra,8(sp)
    80200668:	e022                	sd	s0,0(sp)
    8020066a:	0800                	addi	s0,sp,16
	clean_bss();
    8020066c:	00000097          	auipc	ra,0x0
    80200670:	fcc080e7          	jalr	-52(ra) # 80200638 <clean_bss>
	printf("hello world!\n");
    80200674:	00004517          	auipc	a0,0x4
    80200678:	a6c50513          	addi	a0,a0,-1428 # 802040e0 <e_text+0xe0>
    8020067c:	00000097          	auipc	ra,0x0
    80200680:	0f4080e7          	jalr	244(ra) # 80200770 <printf>
	proc_init();
    80200684:	00000097          	auipc	ra,0x0
    80200688:	2ec080e7          	jalr	748(ra) # 80200970 <proc_init>
	kinit();
    8020068c:	00000097          	auipc	ra,0x0
    80200690:	a8a080e7          	jalr	-1398(ra) # 80200116 <kinit>
	kvm_init();
    80200694:	00002097          	auipc	ra,0x2
    80200698:	ad0080e7          	jalr	-1328(ra) # 80202164 <kvm_init>
	loader_init();
    8020069c:	00000097          	auipc	ra,0x0
    802006a0:	ad6080e7          	jalr	-1322(ra) # 80200172 <loader_init>
	trap_init();
    802006a4:	00001097          	auipc	ra,0x1
    802006a8:	53c080e7          	jalr	1340(ra) # 80201be0 <trap_init>
	timer_init();
    802006ac:	00001097          	auipc	ra,0x1
    802006b0:	440080e7          	jalr	1088(ra) # 80201aec <timer_init>
	load_init_app();
    802006b4:	00000097          	auipc	ra,0x0
    802006b8:	eae080e7          	jalr	-338(ra) # 80200562 <load_init_app>
	infof("start scheduler!");
    802006bc:	4501                	li	a0,0
    802006be:	00001097          	auipc	ra,0x1
    802006c2:	c3e080e7          	jalr	-962(ra) # 802012fc <dummy>
	scheduler();
    802006c6:	00000097          	auipc	ra,0x0
    802006ca:	4dc080e7          	jalr	1244(ra) # 80200ba2 <scheduler>

00000000802006ce <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802006ce:	7179                	addi	sp,sp,-48
    802006d0:	f406                	sd	ra,40(sp)
    802006d2:	f022                	sd	s0,32(sp)
    802006d4:	ec26                	sd	s1,24(sp)
    802006d6:	e84a                	sd	s2,16(sp)
    802006d8:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    802006da:	c219                	beqz	a2,802006e0 <printint+0x12>
    802006dc:	08054663          	bltz	a0,80200768 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    802006e0:	2501                	sext.w	a0,a0
    802006e2:	4881                	li	a7,0
    802006e4:	fd040693          	addi	a3,s0,-48

	i = 0;
    802006e8:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    802006ea:	2581                	sext.w	a1,a1
    802006ec:	00004617          	auipc	a2,0x4
    802006f0:	a4460613          	addi	a2,a2,-1468 # 80204130 <digits>
    802006f4:	883a                	mv	a6,a4
    802006f6:	2705                	addiw	a4,a4,1
    802006f8:	02b577bb          	remuw	a5,a0,a1
    802006fc:	1782                	slli	a5,a5,0x20
    802006fe:	9381                	srli	a5,a5,0x20
    80200700:	97b2                	add	a5,a5,a2
    80200702:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x801ff000>
    80200706:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    8020070a:	0005079b          	sext.w	a5,a0
    8020070e:	02b5553b          	divuw	a0,a0,a1
    80200712:	0685                	addi	a3,a3,1
    80200714:	feb7f0e3          	bgeu	a5,a1,802006f4 <printint+0x26>

	if (sign)
    80200718:	00088b63          	beqz	a7,8020072e <printint+0x60>
		buf[i++] = '-';
    8020071c:	fe040793          	addi	a5,s0,-32
    80200720:	973e                	add	a4,a4,a5
    80200722:	02d00793          	li	a5,45
    80200726:	fef70823          	sb	a5,-16(a4)
    8020072a:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    8020072e:	02e05763          	blez	a4,8020075c <printint+0x8e>
    80200732:	fd040793          	addi	a5,s0,-48
    80200736:	00e784b3          	add	s1,a5,a4
    8020073a:	fff78913          	addi	s2,a5,-1
    8020073e:	993a                	add	s2,s2,a4
    80200740:	377d                	addiw	a4,a4,-1
    80200742:	1702                	slli	a4,a4,0x20
    80200744:	9301                	srli	a4,a4,0x20
    80200746:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    8020074a:	fff4c503          	lbu	a0,-1(s1)
    8020074e:	00000097          	auipc	ra,0x0
    80200752:	8be080e7          	jalr	-1858(ra) # 8020000c <consputc>
	while (--i >= 0)
    80200756:	14fd                	addi	s1,s1,-1
    80200758:	ff2499e3          	bne	s1,s2,8020074a <printint+0x7c>
}
    8020075c:	70a2                	ld	ra,40(sp)
    8020075e:	7402                	ld	s0,32(sp)
    80200760:	64e2                	ld	s1,24(sp)
    80200762:	6942                	ld	s2,16(sp)
    80200764:	6145                	addi	sp,sp,48
    80200766:	8082                	ret
		x = -xx;
    80200768:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    8020076c:	4885                	li	a7,1
		x = -xx;
    8020076e:	bf9d                	j	802006e4 <printint+0x16>

0000000080200770 <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    80200770:	7131                	addi	sp,sp,-192
    80200772:	fc86                	sd	ra,120(sp)
    80200774:	f8a2                	sd	s0,112(sp)
    80200776:	f4a6                	sd	s1,104(sp)
    80200778:	f0ca                	sd	s2,96(sp)
    8020077a:	ecce                	sd	s3,88(sp)
    8020077c:	e8d2                	sd	s4,80(sp)
    8020077e:	e4d6                	sd	s5,72(sp)
    80200780:	e0da                	sd	s6,64(sp)
    80200782:	fc5e                	sd	s7,56(sp)
    80200784:	f862                	sd	s8,48(sp)
    80200786:	f466                	sd	s9,40(sp)
    80200788:	f06a                	sd	s10,32(sp)
    8020078a:	ec6e                	sd	s11,24(sp)
    8020078c:	0100                	addi	s0,sp,128
    8020078e:	8a2a                	mv	s4,a0
    80200790:	e40c                	sd	a1,8(s0)
    80200792:	e810                	sd	a2,16(s0)
    80200794:	ec14                	sd	a3,24(s0)
    80200796:	f018                	sd	a4,32(s0)
    80200798:	f41c                	sd	a5,40(s0)
    8020079a:	03043823          	sd	a6,48(s0)
    8020079e:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802007a2:	c915                	beqz	a0,802007d6 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    802007a4:	00840793          	addi	a5,s0,8
    802007a8:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802007ac:	000a4503          	lbu	a0,0(s4)
    802007b0:	16050c63          	beqz	a0,80200928 <printf+0x1b8>
    802007b4:	4981                	li	s3,0
		if (c != '%') {
    802007b6:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    802007ba:	07000b93          	li	s7,112
	consputc('x');
    802007be:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802007c0:	00004b17          	auipc	s6,0x4
    802007c4:	970b0b13          	addi	s6,s6,-1680 # 80204130 <digits>
		switch (c) {
    802007c8:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802007cc:	02800d93          	li	s11,40
		switch (c) {
    802007d0:	06400c13          	li	s8,100
    802007d4:	a889                	j	80200826 <printf+0xb6>
		panic("null fmt");
    802007d6:	00000097          	auipc	ra,0x0
    802007da:	170080e7          	jalr	368(ra) # 80200946 <threadid>
    802007de:	86aa                	mv	a3,a0
    802007e0:	02e00793          	li	a5,46
    802007e4:	00004717          	auipc	a4,0x4
    802007e8:	91470713          	addi	a4,a4,-1772 # 802040f8 <e_text+0xf8>
    802007ec:	00004617          	auipc	a2,0x4
    802007f0:	82460613          	addi	a2,a2,-2012 # 80204010 <e_text+0x10>
    802007f4:	45fd                	li	a1,31
    802007f6:	00004517          	auipc	a0,0x4
    802007fa:	91250513          	addi	a0,a0,-1774 # 80204108 <e_text+0x108>
    802007fe:	00000097          	auipc	ra,0x0
    80200802:	f72080e7          	jalr	-142(ra) # 80200770 <printf>
    80200806:	00001097          	auipc	ra,0x1
    8020080a:	91a080e7          	jalr	-1766(ra) # 80201120 <shutdown>
    8020080e:	bf59                	j	802007a4 <printf+0x34>
			consputc(c);
    80200810:	fffff097          	auipc	ra,0xfffff
    80200814:	7fc080e7          	jalr	2044(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200818:	2985                	addiw	s3,s3,1
    8020081a:	013a07b3          	add	a5,s4,s3
    8020081e:	0007c503          	lbu	a0,0(a5)
    80200822:	10050363          	beqz	a0,80200928 <printf+0x1b8>
		if (c != '%') {
    80200826:	ff5515e3          	bne	a0,s5,80200810 <printf+0xa0>
		c = fmt[++i] & 0xff;
    8020082a:	2985                	addiw	s3,s3,1
    8020082c:	013a07b3          	add	a5,s4,s3
    80200830:	0007c783          	lbu	a5,0(a5)
    80200834:	0007849b          	sext.w	s1,a5
		if (c == 0)
    80200838:	cbe5                	beqz	a5,80200928 <printf+0x1b8>
		switch (c) {
    8020083a:	05778a63          	beq	a5,s7,8020088e <printf+0x11e>
    8020083e:	02fbf663          	bgeu	s7,a5,8020086a <printf+0xfa>
    80200842:	09978863          	beq	a5,s9,802008d2 <printf+0x162>
    80200846:	07800713          	li	a4,120
    8020084a:	0ce79463          	bne	a5,a4,80200912 <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    8020084e:	f8843783          	ld	a5,-120(s0)
    80200852:	00878713          	addi	a4,a5,8
    80200856:	f8e43423          	sd	a4,-120(s0)
    8020085a:	4605                	li	a2,1
    8020085c:	85ea                	mv	a1,s10
    8020085e:	4388                	lw	a0,0(a5)
    80200860:	00000097          	auipc	ra,0x0
    80200864:	e6e080e7          	jalr	-402(ra) # 802006ce <printint>
			break;
    80200868:	bf45                	j	80200818 <printf+0xa8>
		switch (c) {
    8020086a:	09578e63          	beq	a5,s5,80200906 <printf+0x196>
    8020086e:	0b879263          	bne	a5,s8,80200912 <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    80200872:	f8843783          	ld	a5,-120(s0)
    80200876:	00878713          	addi	a4,a5,8
    8020087a:	f8e43423          	sd	a4,-120(s0)
    8020087e:	4605                	li	a2,1
    80200880:	45a9                	li	a1,10
    80200882:	4388                	lw	a0,0(a5)
    80200884:	00000097          	auipc	ra,0x0
    80200888:	e4a080e7          	jalr	-438(ra) # 802006ce <printint>
			break;
    8020088c:	b771                	j	80200818 <printf+0xa8>
			printptr(va_arg(ap, uint64));
    8020088e:	f8843783          	ld	a5,-120(s0)
    80200892:	00878713          	addi	a4,a5,8
    80200896:	f8e43423          	sd	a4,-120(s0)
    8020089a:	0007b903          	ld	s2,0(a5)
	consputc('0');
    8020089e:	03000513          	li	a0,48
    802008a2:	fffff097          	auipc	ra,0xfffff
    802008a6:	76a080e7          	jalr	1898(ra) # 8020000c <consputc>
	consputc('x');
    802008aa:	07800513          	li	a0,120
    802008ae:	fffff097          	auipc	ra,0xfffff
    802008b2:	75e080e7          	jalr	1886(ra) # 8020000c <consputc>
    802008b6:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802008b8:	03c95793          	srli	a5,s2,0x3c
    802008bc:	97da                	add	a5,a5,s6
    802008be:	0007c503          	lbu	a0,0(a5)
    802008c2:	fffff097          	auipc	ra,0xfffff
    802008c6:	74a080e7          	jalr	1866(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    802008ca:	0912                	slli	s2,s2,0x4
    802008cc:	34fd                	addiw	s1,s1,-1
    802008ce:	f4ed                	bnez	s1,802008b8 <printf+0x148>
    802008d0:	b7a1                	j	80200818 <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    802008d2:	f8843783          	ld	a5,-120(s0)
    802008d6:	00878713          	addi	a4,a5,8
    802008da:	f8e43423          	sd	a4,-120(s0)
    802008de:	6384                	ld	s1,0(a5)
    802008e0:	cc89                	beqz	s1,802008fa <printf+0x18a>
			for (; *s; s++)
    802008e2:	0004c503          	lbu	a0,0(s1)
    802008e6:	d90d                	beqz	a0,80200818 <printf+0xa8>
				consputc(*s);
    802008e8:	fffff097          	auipc	ra,0xfffff
    802008ec:	724080e7          	jalr	1828(ra) # 8020000c <consputc>
			for (; *s; s++)
    802008f0:	0485                	addi	s1,s1,1
    802008f2:	0004c503          	lbu	a0,0(s1)
    802008f6:	f96d                	bnez	a0,802008e8 <printf+0x178>
    802008f8:	b705                	j	80200818 <printf+0xa8>
				s = "(null)";
    802008fa:	00003497          	auipc	s1,0x3
    802008fe:	7f648493          	addi	s1,s1,2038 # 802040f0 <e_text+0xf0>
			for (; *s; s++)
    80200902:	856e                	mv	a0,s11
    80200904:	b7d5                	j	802008e8 <printf+0x178>
			break;
		case '%':
			consputc('%');
    80200906:	8556                	mv	a0,s5
    80200908:	fffff097          	auipc	ra,0xfffff
    8020090c:	704080e7          	jalr	1796(ra) # 8020000c <consputc>
			break;
    80200910:	b721                	j	80200818 <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    80200912:	8556                	mv	a0,s5
    80200914:	fffff097          	auipc	ra,0xfffff
    80200918:	6f8080e7          	jalr	1784(ra) # 8020000c <consputc>
			consputc(c);
    8020091c:	8526                	mv	a0,s1
    8020091e:	fffff097          	auipc	ra,0xfffff
    80200922:	6ee080e7          	jalr	1774(ra) # 8020000c <consputc>
			break;
    80200926:	bdcd                	j	80200818 <printf+0xa8>
		}
	}
    80200928:	70e6                	ld	ra,120(sp)
    8020092a:	7446                	ld	s0,112(sp)
    8020092c:	74a6                	ld	s1,104(sp)
    8020092e:	7906                	ld	s2,96(sp)
    80200930:	69e6                	ld	s3,88(sp)
    80200932:	6a46                	ld	s4,80(sp)
    80200934:	6aa6                	ld	s5,72(sp)
    80200936:	6b06                	ld	s6,64(sp)
    80200938:	7be2                	ld	s7,56(sp)
    8020093a:	7c42                	ld	s8,48(sp)
    8020093c:	7ca2                	ld	s9,40(sp)
    8020093e:	7d02                	ld	s10,32(sp)
    80200940:	6de2                	ld	s11,24(sp)
    80200942:	6129                	addi	sp,sp,192
    80200944:	8082                	ret

0000000080200946 <threadid>:
struct proc *current_proc;
struct proc idle;
struct queue task_queue;

int threadid()
{
    80200946:	1141                	addi	sp,sp,-16
    80200948:	e422                	sd	s0,8(sp)
    8020094a:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    8020094c:	0058c797          	auipc	a5,0x58c
    80200950:	6cc7b783          	ld	a5,1740(a5) # 8078d018 <current_proc>
    80200954:	43c8                	lw	a0,4(a5)
    80200956:	6422                	ld	s0,8(sp)
    80200958:	0141                	addi	sp,sp,16
    8020095a:	8082                	ret

000000008020095c <curr_proc>:

struct proc *curr_proc()
{
    8020095c:	1141                	addi	sp,sp,-16
    8020095e:	e422                	sd	s0,8(sp)
    80200960:	0800                	addi	s0,sp,16
	return current_proc;
}
    80200962:	0058c517          	auipc	a0,0x58c
    80200966:	6b653503          	ld	a0,1718(a0) # 8078d018 <current_proc>
    8020096a:	6422                	ld	s0,8(sp)
    8020096c:	0141                	addi	sp,sp,16
    8020096e:	8082                	ret

0000000080200970 <proc_init>:

// initialize the proc table at boot time.
void proc_init()
{
    80200970:	1141                	addi	sp,sp,-16
    80200972:	e406                	sd	ra,8(sp)
    80200974:	e022                	sd	s0,0(sp)
    80200976:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200978:	00562717          	auipc	a4,0x562
    8020097c:	68870713          	addi	a4,a4,1672 # 80763000 <pool>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    80200980:	8eba                	mv	t4,a4
    80200982:	00004e17          	auipc	t3,0x4
    80200986:	caee3e03          	ld	t3,-850(t3) # 80204630 <digits+0x500>
    8020098a:	00362317          	auipc	t1,0x362
    8020098e:	67630313          	addi	t1,t1,1654 # 80563000 <kstack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    80200992:	00162897          	auipc	a7,0x162
    80200996:	66e88893          	addi	a7,a7,1646 # 80363000 <trapframe>
		p->info = &ti_pool[p-pool];
    8020099a:	7d800813          	li	a6,2008
    8020099e:	00066517          	auipc	a0,0x66
    802009a2:	7c250513          	addi	a0,a0,1986 # 80267160 <ti_pool>
	for (p = pool; p < &pool[NPROC]; p++) {
    802009a6:	0058c597          	auipc	a1,0x58c
    802009aa:	65a58593          	addi	a1,a1,1626 # 8078d000 <kmem>
		p->state = UNUSED;
    802009ae:	00072023          	sw	zero,0(a4)
		p->kstack = (uint64)kstack[p - pool];
    802009b2:	41d707b3          	sub	a5,a4,t4
    802009b6:	8791                	srai	a5,a5,0x4
    802009b8:	03c787b3          	mul	a5,a5,t3
    802009bc:	00c79693          	slli	a3,a5,0xc
    802009c0:	00668633          	add	a2,a3,t1
    802009c4:	ef10                	sd	a2,24(a4)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802009c6:	96c6                	add	a3,a3,a7
    802009c8:	f314                	sd	a3,32(a4)
		p->info = &ti_pool[p-pool];
    802009ca:	030787b3          	mul	a5,a5,a6
    802009ce:	97aa                	add	a5,a5,a0
    802009d0:	12f73823          	sd	a5,304(a4)
		p->info->status = UnInit;
    802009d4:	0007a023          	sw	zero,0(a5)
	for (p = pool; p < &pool[NPROC]; p++) {
    802009d8:	15070713          	addi	a4,a4,336
    802009dc:	fcb719e3          	bne	a4,a1,802009ae <proc_init+0x3e>
	}
	idle.kstack = (uint64)boot_stack_top;
    802009e0:	00065797          	auipc	a5,0x65
    802009e4:	62078793          	addi	a5,a5,1568 # 80266000 <idle>
    802009e8:	00063717          	auipc	a4,0x63
    802009ec:	61870713          	addi	a4,a4,1560 # 80264000 <names>
    802009f0:	ef98                	sd	a4,24(a5)
	idle.pid = IDLE_PID;
    802009f2:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    802009f6:	0058c717          	auipc	a4,0x58c
    802009fa:	62f73123          	sd	a5,1570(a4) # 8078d018 <current_proc>
	init_queue(&task_queue);
    802009fe:	00065517          	auipc	a0,0x65
    80200a02:	75250513          	addi	a0,a0,1874 # 80266150 <task_queue>
    80200a06:	00000097          	auipc	ra,0x0
    80200a0a:	5f2080e7          	jalr	1522(ra) # 80200ff8 <init_queue>
}
    80200a0e:	60a2                	ld	ra,8(sp)
    80200a10:	6402                	ld	s0,0(sp)
    80200a12:	0141                	addi	sp,sp,16
    80200a14:	8082                	ret

0000000080200a16 <allocpid>:

int allocpid()
{
    80200a16:	1141                	addi	sp,sp,-16
    80200a18:	e422                	sd	s0,8(sp)
    80200a1a:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    80200a1c:	00052797          	auipc	a5,0x52
    80200a20:	5e478793          	addi	a5,a5,1508 # 80253000 <PID.0>
    80200a24:	4388                	lw	a0,0(a5)
    80200a26:	0015071b          	addiw	a4,a0,1
    80200a2a:	c398                	sw	a4,0(a5)
}
    80200a2c:	6422                	ld	s0,8(sp)
    80200a2e:	0141                	addi	sp,sp,16
    80200a30:	8082                	ret

0000000080200a32 <fetch_task>:

struct proc *fetch_task()
{
    80200a32:	1101                	addi	sp,sp,-32
    80200a34:	ec06                	sd	ra,24(sp)
    80200a36:	e822                	sd	s0,16(sp)
    80200a38:	e426                	sd	s1,8(sp)
    80200a3a:	1000                	addi	s0,sp,32
	int index = pop_queue(&task_queue);
    80200a3c:	00065517          	auipc	a0,0x65
    80200a40:	71450513          	addi	a0,a0,1812 # 80266150 <task_queue>
    80200a44:	00000097          	auipc	ra,0x0
    80200a48:	660080e7          	jalr	1632(ra) # 802010a4 <pop_queue>
	if (index < 0) {
    80200a4c:	02054863          	bltz	a0,80200a7c <fetch_task+0x4a>
    80200a50:	85aa                	mv	a1,a0
		debugf("No task to fetch\n");
		return NULL;
	}
	debugf("fetch task %d(pid=%d) to task queue\n", index, pool[index].pid);
    80200a52:	15000493          	li	s1,336
    80200a56:	02950533          	mul	a0,a0,s1
    80200a5a:	00562497          	auipc	s1,0x562
    80200a5e:	5a648493          	addi	s1,s1,1446 # 80763000 <pool>
    80200a62:	94aa                	add	s1,s1,a0
    80200a64:	40d0                	lw	a2,4(s1)
    80200a66:	4501                	li	a0,0
    80200a68:	00001097          	auipc	ra,0x1
    80200a6c:	894080e7          	jalr	-1900(ra) # 802012fc <dummy>
	return pool + index;
    80200a70:	8526                	mv	a0,s1
}
    80200a72:	60e2                	ld	ra,24(sp)
    80200a74:	6442                	ld	s0,16(sp)
    80200a76:	64a2                	ld	s1,8(sp)
    80200a78:	6105                	addi	sp,sp,32
    80200a7a:	8082                	ret
		debugf("No task to fetch\n");
    80200a7c:	4501                	li	a0,0
    80200a7e:	00001097          	auipc	ra,0x1
    80200a82:	87e080e7          	jalr	-1922(ra) # 802012fc <dummy>
		return NULL;
    80200a86:	4501                	li	a0,0
    80200a88:	b7ed                	j	80200a72 <fetch_task+0x40>

0000000080200a8a <add_task>:

void add_task(struct proc *p)
{
    80200a8a:	1101                	addi	sp,sp,-32
    80200a8c:	ec06                	sd	ra,24(sp)
    80200a8e:	e822                	sd	s0,16(sp)
    80200a90:	e426                	sd	s1,8(sp)
    80200a92:	e04a                	sd	s2,0(sp)
    80200a94:	1000                	addi	s0,sp,32
    80200a96:	892a                	mv	s2,a0
	push_queue(&task_queue, p - pool);
    80200a98:	00562497          	auipc	s1,0x562
    80200a9c:	56848493          	addi	s1,s1,1384 # 80763000 <pool>
    80200aa0:	409504b3          	sub	s1,a0,s1
    80200aa4:	8491                	srai	s1,s1,0x4
    80200aa6:	00004797          	auipc	a5,0x4
    80200aaa:	b8a7b783          	ld	a5,-1142(a5) # 80204630 <digits+0x500>
    80200aae:	02f484b3          	mul	s1,s1,a5
    80200ab2:	0004859b          	sext.w	a1,s1
    80200ab6:	00065517          	auipc	a0,0x65
    80200aba:	69a50513          	addi	a0,a0,1690 # 80266150 <task_queue>
    80200abe:	00000097          	auipc	ra,0x0
    80200ac2:	556080e7          	jalr	1366(ra) # 80201014 <push_queue>
	debugf("add task %d(pid=%d) to task queue\n", p - pool, p->pid);
    80200ac6:	00492603          	lw	a2,4(s2)
    80200aca:	85a6                	mv	a1,s1
    80200acc:	4501                	li	a0,0
    80200ace:	00001097          	auipc	ra,0x1
    80200ad2:	82e080e7          	jalr	-2002(ra) # 802012fc <dummy>
}
    80200ad6:	60e2                	ld	ra,24(sp)
    80200ad8:	6442                	ld	s0,16(sp)
    80200ada:	64a2                	ld	s1,8(sp)
    80200adc:	6902                	ld	s2,0(sp)
    80200ade:	6105                	addi	sp,sp,32
    80200ae0:	8082                	ret

0000000080200ae2 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc()
{
    80200ae2:	1101                	addi	sp,sp,-32
    80200ae4:	ec06                	sd	ra,24(sp)
    80200ae6:	e822                	sd	s0,16(sp)
    80200ae8:	e426                	sd	s1,8(sp)
    80200aea:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200aec:	00562497          	auipc	s1,0x562
    80200af0:	51448493          	addi	s1,s1,1300 # 80763000 <pool>
    80200af4:	0058c717          	auipc	a4,0x58c
    80200af8:	50c70713          	addi	a4,a4,1292 # 8078d000 <kmem>
		if (p->state == UNUSED) {
    80200afc:	409c                	lw	a5,0(s1)
    80200afe:	c799                	beqz	a5,80200b0c <allocproc+0x2a>
	for (p = pool; p < &pool[NPROC]; p++) {
    80200b00:	15048493          	addi	s1,s1,336
    80200b04:	fee49ce3          	bne	s1,a4,80200afc <allocproc+0x1a>
			goto found;
		}
	}
	return 0;
    80200b08:	4481                	li	s1,0
    80200b0a:	a071                	j	80200b96 <allocproc+0xb4>

found:
	// init proc
	p->pid = allocpid();
    80200b0c:	00000097          	auipc	ra,0x0
    80200b10:	f0a080e7          	jalr	-246(ra) # 80200a16 <allocpid>
    80200b14:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    80200b16:	4785                	li	a5,1
    80200b18:	c09c                	sw	a5,0(s1)
	p->ustack = 0;
    80200b1a:	0004b823          	sd	zero,16(s1)
	p->max_page = 0;
    80200b1e:	0804bc23          	sd	zero,152(s1)
	p->parent = NULL;
    80200b22:	0a04b023          	sd	zero,160(s1)
	p->exit_code = 0;
    80200b26:	0a04b423          	sd	zero,168(s1)
	p->pagetable = uvmcreate((uint64)p->trapframe);
    80200b2a:	7088                	ld	a0,32(s1)
    80200b2c:	00001097          	auipc	ra,0x1
    80200b30:	784080e7          	jalr	1924(ra) # 802022b0 <uvmcreate>
    80200b34:	e488                	sd	a0,8(s1)
	memset(&p->context, 0, sizeof(p->context));
    80200b36:	07000613          	li	a2,112
    80200b3a:	4581                	li	a1,0
    80200b3c:	02848513          	addi	a0,s1,40
    80200b40:	00000097          	auipc	ra,0x0
    80200b44:	60e080e7          	jalr	1550(ra) # 8020114e <memset>
	memset((void *)p->kstack, 0, KSTACK_SIZE);
    80200b48:	6605                	lui	a2,0x1
    80200b4a:	4581                	li	a1,0
    80200b4c:	6c88                	ld	a0,24(s1)
    80200b4e:	00000097          	auipc	ra,0x0
    80200b52:	600080e7          	jalr	1536(ra) # 8020114e <memset>
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
    80200b56:	6605                	lui	a2,0x1
    80200b58:	4581                	li	a1,0
    80200b5a:	7088                	ld	a0,32(s1)
    80200b5c:	00000097          	auipc	ra,0x0
    80200b60:	5f2080e7          	jalr	1522(ra) # 8020114e <memset>
	p->context.ra = (uint64)usertrapret;
    80200b64:	00001797          	auipc	a5,0x1
    80200b68:	0dc78793          	addi	a5,a5,220 # 80201c40 <usertrapret>
    80200b6c:	f49c                	sd	a5,40(s1)
	p->context.sp = p->kstack + KSTACK_SIZE;
    80200b6e:	6c9c                	ld	a5,24(s1)
    80200b70:	6705                	lui	a4,0x1
    80200b72:	97ba                	add	a5,a5,a4
    80200b74:	f89c                	sd	a5,48(s1)

	// CH5: Set process priority to 16, stride to 0, and pass to "big stride" / priority
	p->priority = 16;		// Process with smallest priority selected to run
    80200b76:	47c1                	li	a5,16
    80200b78:	12f4bc23          	sd	a5,312(s1)
	p->stride = 0;			// Process stride starts as 0 and increases to give other processes chance to run
    80200b7c:	1404b023          	sd	zero,320(s1)
	p->pass = BIG_STRIDE / p->priority;		// Proof not given, ensures each process gets reasonable time to shine each
    80200b80:	00052717          	auipc	a4,0x52
    80200b84:	48472703          	lw	a4,1156(a4) # 80253004 <BIG_STRIDE>
    80200b88:	43f75793          	srai	a5,a4,0x3f
    80200b8c:	8bbd                	andi	a5,a5,15
    80200b8e:	97ba                	add	a5,a5,a4
    80200b90:	8791                	srai	a5,a5,0x4
    80200b92:	14f4b423          	sd	a5,328(s1)

	return p;
}
    80200b96:	8526                	mv	a0,s1
    80200b98:	60e2                	ld	ra,24(sp)
    80200b9a:	6442                	ld	s0,16(sp)
    80200b9c:	64a2                	ld	s1,8(sp)
    80200b9e:	6105                	addi	sp,sp,32
    80200ba0:	8082                	ret

0000000080200ba2 <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler()
{
    80200ba2:	711d                	addi	sp,sp,-96
    80200ba4:	ec86                	sd	ra,88(sp)
    80200ba6:	e8a2                	sd	s0,80(sp)
    80200ba8:	e4a6                	sd	s1,72(sp)
    80200baa:	e0ca                	sd	s2,64(sp)
    80200bac:	fc4e                	sd	s3,56(sp)
    80200bae:	f852                	sd	s4,48(sp)
    80200bb0:	f456                	sd	s5,40(sp)
    80200bb2:	f05a                	sd	s6,32(sp)
    80200bb4:	ec5e                	sd	s7,24(sp)
    80200bb6:	e862                	sd	s8,16(sp)
    80200bb8:	e466                	sd	s9,8(sp)
    80200bba:	1080                	addi	s0,sp,96
	struct proc *p;
	for (;;) {
		// CH5: 
		struct proc *smallest_p = 0;
    80200bbc:	4a01                	li	s4,0
		for (p = pool; p < &pool[NPROC]; p++) {
			if (p->state == RUNNABLE) {
    80200bbe:	490d                	li	s2,3
		for (p = pool; p < &pool[NPROC]; p++) {
    80200bc0:	0058c497          	auipc	s1,0x58c
    80200bc4:	44048493          	addi	s1,s1,1088 # 8078d000 <kmem>
	return curr_proc()->pid;
    80200bc8:	0058ca97          	auipc	s5,0x58c
    80200bcc:	450a8a93          	addi	s5,s5,1104 # 8078d018 <current_proc>
				}
			}
		}

		if (smallest_p == 0) {
			panic("all app are over!\n");
    80200bd0:	00003c97          	auipc	s9,0x3
    80200bd4:	578c8c93          	addi	s9,s9,1400 # 80204148 <digits+0x18>
		}

		tracef("swtich to proc %d", smallest_p - pool);
    80200bd8:	00562c17          	auipc	s8,0x562
    80200bdc:	428c0c13          	addi	s8,s8,1064 # 80763000 <pool>
    80200be0:	00004b97          	auipc	s7,0x4
    80200be4:	a50b8b93          	addi	s7,s7,-1456 # 80204630 <digits+0x500>
		smallest_p->state = RUNNING;
		current_proc = smallest_p;
		smallest_p->stride += smallest_p->pass;
		swtch(&idle.context, &smallest_p->context);
    80200be8:	00065b17          	auipc	s6,0x65
    80200bec:	440b0b13          	addi	s6,s6,1088 # 80266028 <idle+0x28>
    80200bf0:	a0a5                	j	80200c58 <scheduler+0xb6>
    80200bf2:	89be                	mv	s3,a5
		for (p = pool; p < &pool[NPROC]; p++) {
    80200bf4:	15078793          	addi	a5,a5,336
    80200bf8:	00978f63          	beq	a5,s1,80200c16 <scheduler+0x74>
			if (p->state == RUNNABLE) {
    80200bfc:	4398                	lw	a4,0(a5)
    80200bfe:	ff271be3          	bne	a4,s2,80200bf4 <scheduler+0x52>
				if (smallest_p == 0 || p->stride < smallest_p->stride) { 
    80200c02:	fe0988e3          	beqz	s3,80200bf2 <scheduler+0x50>
    80200c06:	1407b683          	ld	a3,320(a5)
    80200c0a:	1409b703          	ld	a4,320(s3)
    80200c0e:	fee6d3e3          	bge	a3,a4,80200bf4 <scheduler+0x52>
    80200c12:	89be                	mv	s3,a5
    80200c14:	b7c5                	j	80200bf4 <scheduler+0x52>
		if (smallest_p == 0) {
    80200c16:	04098763          	beqz	s3,80200c64 <scheduler+0xc2>
		tracef("swtich to proc %d", smallest_p - pool);
    80200c1a:	418987b3          	sub	a5,s3,s8
    80200c1e:	8791                	srai	a5,a5,0x4
    80200c20:	000bb583          	ld	a1,0(s7)
    80200c24:	02b785b3          	mul	a1,a5,a1
    80200c28:	8552                	mv	a0,s4
    80200c2a:	00000097          	auipc	ra,0x0
    80200c2e:	6d2080e7          	jalr	1746(ra) # 802012fc <dummy>
		smallest_p->state = RUNNING;
    80200c32:	4791                	li	a5,4
    80200c34:	00f9a023          	sw	a5,0(s3)
		current_proc = smallest_p;
    80200c38:	013ab023          	sd	s3,0(s5)
		smallest_p->stride += smallest_p->pass;
    80200c3c:	1409b783          	ld	a5,320(s3)
    80200c40:	1489b703          	ld	a4,328(s3)
    80200c44:	97ba                	add	a5,a5,a4
    80200c46:	14f9b023          	sd	a5,320(s3)
		swtch(&idle.context, &smallest_p->context);
    80200c4a:	02898593          	addi	a1,s3,40
    80200c4e:	855a                	mv	a0,s6
    80200c50:	00002097          	auipc	ra,0x2
    80200c54:	a74080e7          	jalr	-1420(ra) # 802026c4 <swtch>
		struct proc *smallest_p = 0;
    80200c58:	89d2                	mv	s3,s4
		for (p = pool; p < &pool[NPROC]; p++) {
    80200c5a:	00562797          	auipc	a5,0x562
    80200c5e:	3a678793          	addi	a5,a5,934 # 80763000 <pool>
    80200c62:	bf69                	j	80200bfc <scheduler+0x5a>
	return curr_proc()->pid;
    80200c64:	000ab683          	ld	a3,0(s5)
			panic("all app are over!\n");
    80200c68:	07e00793          	li	a5,126
    80200c6c:	8766                	mv	a4,s9
    80200c6e:	42d4                	lw	a3,4(a3)
    80200c70:	00003617          	auipc	a2,0x3
    80200c74:	3a060613          	addi	a2,a2,928 # 80204010 <e_text+0x10>
    80200c78:	45fd                	li	a1,31
    80200c7a:	00003517          	auipc	a0,0x3
    80200c7e:	4de50513          	addi	a0,a0,1246 # 80204158 <digits+0x28>
    80200c82:	00000097          	auipc	ra,0x0
    80200c86:	aee080e7          	jalr	-1298(ra) # 80200770 <printf>
    80200c8a:	00000097          	auipc	ra,0x0
    80200c8e:	496080e7          	jalr	1174(ra) # 80201120 <shutdown>
    80200c92:	b761                	j	80200c1a <scheduler+0x78>

0000000080200c94 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched()
{
    80200c94:	1101                	addi	sp,sp,-32
    80200c96:	ec06                	sd	ra,24(sp)
    80200c98:	e822                	sd	s0,16(sp)
    80200c9a:	e426                	sd	s1,8(sp)
    80200c9c:	1000                	addi	s0,sp,32
	return current_proc;
    80200c9e:	0058c497          	auipc	s1,0x58c
    80200ca2:	37a4b483          	ld	s1,890(s1) # 8078d018 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    80200ca6:	4098                	lw	a4,0(s1)
    80200ca8:	4791                	li	a5,4
    80200caa:	02f70163          	beq	a4,a5,80200ccc <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    80200cae:	00065597          	auipc	a1,0x65
    80200cb2:	37a58593          	addi	a1,a1,890 # 80266028 <idle+0x28>
    80200cb6:	02848513          	addi	a0,s1,40
    80200cba:	00002097          	auipc	ra,0x2
    80200cbe:	a0a080e7          	jalr	-1526(ra) # 802026c4 <swtch>
}
    80200cc2:	60e2                	ld	ra,24(sp)
    80200cc4:	6442                	ld	s0,16(sp)
    80200cc6:	64a2                	ld	s1,8(sp)
    80200cc8:	6105                	addi	sp,sp,32
    80200cca:	8082                	ret
		panic("sched running");
    80200ccc:	09400793          	li	a5,148
    80200cd0:	00003717          	auipc	a4,0x3
    80200cd4:	47870713          	addi	a4,a4,1144 # 80204148 <digits+0x18>
    80200cd8:	40d4                	lw	a3,4(s1)
    80200cda:	00003617          	auipc	a2,0x3
    80200cde:	33660613          	addi	a2,a2,822 # 80204010 <e_text+0x10>
    80200ce2:	45fd                	li	a1,31
    80200ce4:	00003517          	auipc	a0,0x3
    80200ce8:	4a450513          	addi	a0,a0,1188 # 80204188 <digits+0x58>
    80200cec:	00000097          	auipc	ra,0x0
    80200cf0:	a84080e7          	jalr	-1404(ra) # 80200770 <printf>
    80200cf4:	00000097          	auipc	ra,0x0
    80200cf8:	42c080e7          	jalr	1068(ra) # 80201120 <shutdown>
    80200cfc:	bf4d                	j	80200cae <sched+0x1a>

0000000080200cfe <yield>:

// Give up the CPU for one scheduling round.
void yield()
{
    80200cfe:	1141                	addi	sp,sp,-16
    80200d00:	e406                	sd	ra,8(sp)
    80200d02:	e022                	sd	s0,0(sp)
    80200d04:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    80200d06:	0058c797          	auipc	a5,0x58c
    80200d0a:	3127b783          	ld	a5,786(a5) # 8078d018 <current_proc>
    80200d0e:	470d                	li	a4,3
    80200d10:	c398                	sw	a4,0(a5)
	// add_task(current_proc);
	sched();
    80200d12:	00000097          	auipc	ra,0x0
    80200d16:	f82080e7          	jalr	-126(ra) # 80200c94 <sched>
}
    80200d1a:	60a2                	ld	ra,8(sp)
    80200d1c:	6402                	ld	s0,0(sp)
    80200d1e:	0141                	addi	sp,sp,16
    80200d20:	8082                	ret

0000000080200d22 <freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void freepagetable(pagetable_t pagetable, uint64 max_page)
{
    80200d22:	1101                	addi	sp,sp,-32
    80200d24:	ec06                	sd	ra,24(sp)
    80200d26:	e822                	sd	s0,16(sp)
    80200d28:	e426                	sd	s1,8(sp)
    80200d2a:	e04a                	sd	s2,0(sp)
    80200d2c:	1000                	addi	s0,sp,32
    80200d2e:	84aa                	mv	s1,a0
    80200d30:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80200d32:	4681                	li	a3,0
    80200d34:	4605                	li	a2,1
    80200d36:	040005b7          	lui	a1,0x4000
    80200d3a:	15fd                	addi	a1,a1,-1
    80200d3c:	05b2                	slli	a1,a1,0xc
    80200d3e:	00001097          	auipc	ra,0x1
    80200d42:	464080e7          	jalr	1124(ra) # 802021a2 <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80200d46:	4681                	li	a3,0
    80200d48:	4605                	li	a2,1
    80200d4a:	020005b7          	lui	a1,0x2000
    80200d4e:	15fd                	addi	a1,a1,-1
    80200d50:	05b6                	slli	a1,a1,0xd
    80200d52:	8526                	mv	a0,s1
    80200d54:	00001097          	auipc	ra,0x1
    80200d58:	44e080e7          	jalr	1102(ra) # 802021a2 <uvmunmap>
	uvmfree(pagetable, max_page);
    80200d5c:	85ca                	mv	a1,s2
    80200d5e:	8526                	mv	a0,s1
    80200d60:	00001097          	auipc	ra,0x1
    80200d64:	6b4080e7          	jalr	1716(ra) # 80202414 <uvmfree>
}
    80200d68:	60e2                	ld	ra,24(sp)
    80200d6a:	6442                	ld	s0,16(sp)
    80200d6c:	64a2                	ld	s1,8(sp)
    80200d6e:	6902                	ld	s2,0(sp)
    80200d70:	6105                	addi	sp,sp,32
    80200d72:	8082                	ret

0000000080200d74 <freeproc>:

void freeproc(struct proc *p)
{
    80200d74:	1101                	addi	sp,sp,-32
    80200d76:	ec06                	sd	ra,24(sp)
    80200d78:	e822                	sd	s0,16(sp)
    80200d7a:	e426                	sd	s1,8(sp)
    80200d7c:	1000                	addi	s0,sp,32
    80200d7e:	84aa                	mv	s1,a0
	if (p->pagetable)
    80200d80:	6508                	ld	a0,8(a0)
    80200d82:	c511                	beqz	a0,80200d8e <freeproc+0x1a>
		freepagetable(p->pagetable, p->max_page);
    80200d84:	6ccc                	ld	a1,152(s1)
    80200d86:	00000097          	auipc	ra,0x0
    80200d8a:	f9c080e7          	jalr	-100(ra) # 80200d22 <freepagetable>
	p->pagetable = 0;
    80200d8e:	0004b423          	sd	zero,8(s1)
	p->state = UNUSED;
    80200d92:	0004a023          	sw	zero,0(s1)
}
    80200d96:	60e2                	ld	ra,24(sp)
    80200d98:	6442                	ld	s0,16(sp)
    80200d9a:	64a2                	ld	s1,8(sp)
    80200d9c:	6105                	addi	sp,sp,32
    80200d9e:	8082                	ret

0000000080200da0 <fork>:

int fork()
{
    80200da0:	1101                	addi	sp,sp,-32
    80200da2:	ec06                	sd	ra,24(sp)
    80200da4:	e822                	sd	s0,16(sp)
    80200da6:	e426                	sd	s1,8(sp)
    80200da8:	e04a                	sd	s2,0(sp)
    80200daa:	1000                	addi	s0,sp,32
	return current_proc;
    80200dac:	0058c917          	auipc	s2,0x58c
    80200db0:	26c93903          	ld	s2,620(s2) # 8078d018 <current_proc>
	struct proc *np;
	struct proc *p = curr_proc();
	// Allocate process.
	if ((np = allocproc()) == 0) {
    80200db4:	00000097          	auipc	ra,0x0
    80200db8:	d2e080e7          	jalr	-722(ra) # 80200ae2 <allocproc>
    80200dbc:	84aa                	mv	s1,a0
    80200dbe:	c13d                	beqz	a0,80200e24 <fork+0x84>
		panic("allocproc\n");
	}
	// Copy user memory from parent to child.
	if (uvmcopy(p->pagetable, np->pagetable, p->max_page) < 0) {
    80200dc0:	09893603          	ld	a2,152(s2)
    80200dc4:	648c                	ld	a1,8(s1)
    80200dc6:	00893503          	ld	a0,8(s2)
    80200dca:	00001097          	auipc	ra,0x1
    80200dce:	67c080e7          	jalr	1660(ra) # 80202446 <uvmcopy>
    80200dd2:	08054663          	bltz	a0,80200e5e <fork+0xbe>
		panic("uvmcopy\n");
	}
	np->max_page = p->max_page;
    80200dd6:	09893783          	ld	a5,152(s2)
    80200dda:	ecdc                	sd	a5,152(s1)
	// copy saved user registers.
	*(np->trapframe) = *(p->trapframe);
    80200ddc:	02093683          	ld	a3,32(s2)
    80200de0:	87b6                	mv	a5,a3
    80200de2:	7098                	ld	a4,32(s1)
    80200de4:	12068693          	addi	a3,a3,288
    80200de8:	0007b803          	ld	a6,0(a5)
    80200dec:	6788                	ld	a0,8(a5)
    80200dee:	6b8c                	ld	a1,16(a5)
    80200df0:	6f90                	ld	a2,24(a5)
    80200df2:	01073023          	sd	a6,0(a4)
    80200df6:	e708                	sd	a0,8(a4)
    80200df8:	eb0c                	sd	a1,16(a4)
    80200dfa:	ef10                	sd	a2,24(a4)
    80200dfc:	02078793          	addi	a5,a5,32
    80200e00:	02070713          	addi	a4,a4,32
    80200e04:	fed792e3          	bne	a5,a3,80200de8 <fork+0x48>
	// Cause fork to return 0 in the child.
	np->trapframe->a0 = 0;
    80200e08:	709c                	ld	a5,32(s1)
    80200e0a:	0607b823          	sd	zero,112(a5)
	np->parent = p;
    80200e0e:	0b24b023          	sd	s2,160(s1)
	np->state = RUNNABLE;
    80200e12:	478d                	li	a5,3
    80200e14:	c09c                	sw	a5,0(s1)
	// add_task(np);
	return np->pid;
}
    80200e16:	40c8                	lw	a0,4(s1)
    80200e18:	60e2                	ld	ra,24(sp)
    80200e1a:	6442                	ld	s0,16(sp)
    80200e1c:	64a2                	ld	s1,8(sp)
    80200e1e:	6902                	ld	s2,0(sp)
    80200e20:	6105                	addi	sp,sp,32
    80200e22:	8082                	ret
		panic("allocproc\n");
    80200e24:	0b700793          	li	a5,183
    80200e28:	00003717          	auipc	a4,0x3
    80200e2c:	32070713          	addi	a4,a4,800 # 80204148 <digits+0x18>
    80200e30:	0058c697          	auipc	a3,0x58c
    80200e34:	1e86b683          	ld	a3,488(a3) # 8078d018 <current_proc>
    80200e38:	42d4                	lw	a3,4(a3)
    80200e3a:	00003617          	auipc	a2,0x3
    80200e3e:	1d660613          	addi	a2,a2,470 # 80204010 <e_text+0x10>
    80200e42:	45fd                	li	a1,31
    80200e44:	00003517          	auipc	a0,0x3
    80200e48:	27450513          	addi	a0,a0,628 # 802040b8 <e_text+0xb8>
    80200e4c:	00000097          	auipc	ra,0x0
    80200e50:	924080e7          	jalr	-1756(ra) # 80200770 <printf>
    80200e54:	00000097          	auipc	ra,0x0
    80200e58:	2cc080e7          	jalr	716(ra) # 80201120 <shutdown>
    80200e5c:	b795                	j	80200dc0 <fork+0x20>
		panic("uvmcopy\n");
    80200e5e:	0bb00793          	li	a5,187
    80200e62:	00003717          	auipc	a4,0x3
    80200e66:	2e670713          	addi	a4,a4,742 # 80204148 <digits+0x18>
    80200e6a:	0058c697          	auipc	a3,0x58c
    80200e6e:	1ae6b683          	ld	a3,430(a3) # 8078d018 <current_proc>
    80200e72:	42d4                	lw	a3,4(a3)
    80200e74:	00003617          	auipc	a2,0x3
    80200e78:	19c60613          	addi	a2,a2,412 # 80204010 <e_text+0x10>
    80200e7c:	45fd                	li	a1,31
    80200e7e:	00003517          	auipc	a0,0x3
    80200e82:	33250513          	addi	a0,a0,818 # 802041b0 <digits+0x80>
    80200e86:	00000097          	auipc	ra,0x0
    80200e8a:	8ea080e7          	jalr	-1814(ra) # 80200770 <printf>
    80200e8e:	00000097          	auipc	ra,0x0
    80200e92:	292080e7          	jalr	658(ra) # 80201120 <shutdown>
    80200e96:	b781                	j	80200dd6 <fork+0x36>

0000000080200e98 <exec>:

int exec(char *name)
{
    80200e98:	1101                	addi	sp,sp,-32
    80200e9a:	ec06                	sd	ra,24(sp)
    80200e9c:	e822                	sd	s0,16(sp)
    80200e9e:	e426                	sd	s1,8(sp)
    80200ea0:	e04a                	sd	s2,0(sp)
    80200ea2:	1000                	addi	s0,sp,32
	int id = get_id_by_name(name);
    80200ea4:	fffff097          	auipc	ra,0xfffff
    80200ea8:	39e080e7          	jalr	926(ra) # 80200242 <get_id_by_name>
	if (id < 0)
    80200eac:	04054063          	bltz	a0,80200eec <exec+0x54>
    80200eb0:	84aa                	mv	s1,a0
	return current_proc;
    80200eb2:	0058c917          	auipc	s2,0x58c
    80200eb6:	16693903          	ld	s2,358(s2) # 8078d018 <current_proc>
		return -1;
	struct proc *p = curr_proc();
	uvmunmap(p->pagetable, 0, p->max_page, 1);
    80200eba:	4685                	li	a3,1
    80200ebc:	09893603          	ld	a2,152(s2)
    80200ec0:	4581                	li	a1,0
    80200ec2:	00893503          	ld	a0,8(s2)
    80200ec6:	00001097          	auipc	ra,0x1
    80200eca:	2dc080e7          	jalr	732(ra) # 802021a2 <uvmunmap>
	p->max_page = 0;
    80200ece:	08093c23          	sd	zero,152(s2)
	loader(id, p);
    80200ed2:	85ca                	mv	a1,s2
    80200ed4:	8526                	mv	a0,s1
    80200ed6:	fffff097          	auipc	ra,0xfffff
    80200eda:	660080e7          	jalr	1632(ra) # 80200536 <loader>
	return 0;
    80200ede:	4501                	li	a0,0
}
    80200ee0:	60e2                	ld	ra,24(sp)
    80200ee2:	6442                	ld	s0,16(sp)
    80200ee4:	64a2                	ld	s1,8(sp)
    80200ee6:	6902                	ld	s2,0(sp)
    80200ee8:	6105                	addi	sp,sp,32
    80200eea:	8082                	ret
		return -1;
    80200eec:	557d                	li	a0,-1
    80200eee:	bfcd                	j	80200ee0 <exec+0x48>

0000000080200ef0 <wait>:

int wait(int pid, int *code)
{
    80200ef0:	715d                	addi	sp,sp,-80
    80200ef2:	e486                	sd	ra,72(sp)
    80200ef4:	e0a2                	sd	s0,64(sp)
    80200ef6:	fc26                	sd	s1,56(sp)
    80200ef8:	f84a                	sd	s2,48(sp)
    80200efa:	f44e                	sd	s3,40(sp)
    80200efc:	f052                	sd	s4,32(sp)
    80200efe:	ec56                	sd	s5,24(sp)
    80200f00:	e85a                	sd	s6,16(sp)
    80200f02:	e45e                	sd	s7,8(sp)
    80200f04:	e062                	sd	s8,0(sp)
    80200f06:	0880                	addi	s0,sp,80
    80200f08:	89aa                	mv	s3,a0
    80200f0a:	8b2e                	mv	s6,a1
	return current_proc;
    80200f0c:	0058c917          	auipc	s2,0x58c
    80200f10:	10c93903          	ld	s2,268(s2) # 8078d018 <current_proc>
	int havekids;
	struct proc *p = curr_proc();

	for (;;) {
		// Scan through table looking for exited children.
		havekids = 0;
    80200f14:	4b81                	li	s7,0
		for (np = pool; np < &pool[NPROC]; np++) {
			if (np->state != UNUSED && np->parent == p &&
			    (pid <= 0 || np->pid == pid)) {
				havekids = 1;
				if (np->state == ZOMBIE) {
    80200f16:	4a15                	li	s4,5
				havekids = 1;
    80200f18:	4a85                	li	s5,1
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f1a:	0058c497          	auipc	s1,0x58c
    80200f1e:	0e648493          	addi	s1,s1,230 # 8078d000 <kmem>
			}
		}
		if (!havekids) {
			return -1;
		}
		p->state = RUNNABLE;
    80200f22:	4c0d                	li	s8,3
		havekids = 0;
    80200f24:	865e                	mv	a2,s7
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f26:	00562797          	auipc	a5,0x562
    80200f2a:	0da78793          	addi	a5,a5,218 # 80763000 <pool>
    80200f2e:	a801                	j	80200f3e <wait+0x4e>
				if (np->state == ZOMBIE) {
    80200f30:	03470263          	beq	a4,s4,80200f54 <wait+0x64>
				havekids = 1;
    80200f34:	8656                	mv	a2,s5
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f36:	15078793          	addi	a5,a5,336
    80200f3a:	02978463          	beq	a5,s1,80200f62 <wait+0x72>
			if (np->state != UNUSED && np->parent == p &&
    80200f3e:	4398                	lw	a4,0(a5)
    80200f40:	db7d                	beqz	a4,80200f36 <wait+0x46>
    80200f42:	73d4                	ld	a3,160(a5)
    80200f44:	ff2699e3          	bne	a3,s2,80200f36 <wait+0x46>
    80200f48:	ff3054e3          	blez	s3,80200f30 <wait+0x40>
			    (pid <= 0 || np->pid == pid)) {
    80200f4c:	43d4                	lw	a3,4(a5)
    80200f4e:	ff3694e3          	bne	a3,s3,80200f36 <wait+0x46>
    80200f52:	bff9                	j	80200f30 <wait+0x40>
					np->state = UNUSED;
    80200f54:	0007a023          	sw	zero,0(a5)
					pid = np->pid;
    80200f58:	43c8                	lw	a0,4(a5)
					*code = np->exit_code;
    80200f5a:	77dc                	ld	a5,168(a5)
    80200f5c:	00fb2023          	sw	a5,0(s6)
					return pid;
    80200f60:	a019                	j	80200f66 <wait+0x76>
		if (!havekids) {
    80200f62:	ee11                	bnez	a2,80200f7e <wait+0x8e>
			return -1;
    80200f64:	557d                	li	a0,-1
		// add_task(p);
		sched();
	}
}
    80200f66:	60a6                	ld	ra,72(sp)
    80200f68:	6406                	ld	s0,64(sp)
    80200f6a:	74e2                	ld	s1,56(sp)
    80200f6c:	7942                	ld	s2,48(sp)
    80200f6e:	79a2                	ld	s3,40(sp)
    80200f70:	7a02                	ld	s4,32(sp)
    80200f72:	6ae2                	ld	s5,24(sp)
    80200f74:	6b42                	ld	s6,16(sp)
    80200f76:	6ba2                	ld	s7,8(sp)
    80200f78:	6c02                	ld	s8,0(sp)
    80200f7a:	6161                	addi	sp,sp,80
    80200f7c:	8082                	ret
		p->state = RUNNABLE;
    80200f7e:	01892023          	sw	s8,0(s2)
		sched();
    80200f82:	00000097          	auipc	ra,0x0
    80200f86:	d12080e7          	jalr	-750(ra) # 80200c94 <sched>
		havekids = 0;
    80200f8a:	bf69                	j	80200f24 <wait+0x34>

0000000080200f8c <exit>:

// Exit the current process.
void exit(int code)
{
    80200f8c:	1101                	addi	sp,sp,-32
    80200f8e:	ec06                	sd	ra,24(sp)
    80200f90:	e822                	sd	s0,16(sp)
    80200f92:	e426                	sd	s1,8(sp)
    80200f94:	1000                	addi	s0,sp,32
    80200f96:	862a                	mv	a2,a0
	return current_proc;
    80200f98:	0058c497          	auipc	s1,0x58c
    80200f9c:	0804b483          	ld	s1,128(s1) # 8078d018 <current_proc>
	struct proc *p = curr_proc();
	p->exit_code = code;
    80200fa0:	f4c8                	sd	a0,168(s1)
	debugf("proc %d exit with %d\n", p->pid, code);
    80200fa2:	40cc                	lw	a1,4(s1)
    80200fa4:	4501                	li	a0,0
    80200fa6:	00000097          	auipc	ra,0x0
    80200faa:	356080e7          	jalr	854(ra) # 802012fc <dummy>
	freeproc(p);
    80200fae:	8526                	mv	a0,s1
    80200fb0:	00000097          	auipc	ra,0x0
    80200fb4:	dc4080e7          	jalr	-572(ra) # 80200d74 <freeproc>
	if (p->parent != NULL) {
    80200fb8:	70dc                	ld	a5,160(s1)
    80200fba:	c399                	beqz	a5,80200fc0 <exit+0x34>
		// Parent should `wait`
		p->state = ZOMBIE;
    80200fbc:	4795                	li	a5,5
    80200fbe:	c09c                	sw	a5,0(s1)
{
    80200fc0:	00562797          	auipc	a5,0x562
    80200fc4:	04078793          	addi	a5,a5,64 # 80763000 <pool>
	}
	// Set the `parent` of all children to NULL
	struct proc *np;
	for (np = pool; np < &pool[NPROC]; np++) {
    80200fc8:	0058c697          	auipc	a3,0x58c
    80200fcc:	03868693          	addi	a3,a3,56 # 8078d000 <kmem>
    80200fd0:	a029                	j	80200fda <exit+0x4e>
    80200fd2:	15078793          	addi	a5,a5,336
    80200fd6:	00d78863          	beq	a5,a3,80200fe6 <exit+0x5a>
		if (np->parent == p) {
    80200fda:	73d8                	ld	a4,160(a5)
    80200fdc:	fe971be3          	bne	a4,s1,80200fd2 <exit+0x46>
			np->parent = NULL;
    80200fe0:	0a07b023          	sd	zero,160(a5)
    80200fe4:	b7fd                	j	80200fd2 <exit+0x46>
		}
	}
	sched();
    80200fe6:	00000097          	auipc	ra,0x0
    80200fea:	cae080e7          	jalr	-850(ra) # 80200c94 <sched>
    80200fee:	60e2                	ld	ra,24(sp)
    80200ff0:	6442                	ld	s0,16(sp)
    80200ff2:	64a2                	ld	s1,8(sp)
    80200ff4:	6105                	addi	sp,sp,32
    80200ff6:	8082                	ret

0000000080200ff8 <init_queue>:
#include "queue.h"
#include "defs.h"

void init_queue(struct queue *q)
{
    80200ff8:	1141                	addi	sp,sp,-16
    80200ffa:	e422                	sd	s0,8(sp)
    80200ffc:	0800                	addi	s0,sp,16
	q->front = q->tail = 0;
    80200ffe:	6785                	lui	a5,0x1
    80201000:	953e                	add	a0,a0,a5
    80201002:	00052223          	sw	zero,4(a0)
    80201006:	00052023          	sw	zero,0(a0)
	q->empty = 1;
    8020100a:	4785                	li	a5,1
    8020100c:	c51c                	sw	a5,8(a0)
}
    8020100e:	6422                	ld	s0,8(sp)
    80201010:	0141                	addi	sp,sp,16
    80201012:	8082                	ret

0000000080201014 <push_queue>:

void push_queue(struct queue *q, int value)
{
    80201014:	1101                	addi	sp,sp,-32
    80201016:	ec06                	sd	ra,24(sp)
    80201018:	e822                	sd	s0,16(sp)
    8020101a:	e426                	sd	s1,8(sp)
    8020101c:	e04a                	sd	s2,0(sp)
    8020101e:	1000                	addi	s0,sp,32
    80201020:	84aa                	mv	s1,a0
    80201022:	892e                	mv	s2,a1
	if (!q->empty && q->front == q->tail) {
    80201024:	6785                	lui	a5,0x1
    80201026:	97aa                	add	a5,a5,a0
    80201028:	479c                	lw	a5,8(a5)
    8020102a:	e799                	bnez	a5,80201038 <push_queue+0x24>
    8020102c:	6785                	lui	a5,0x1
    8020102e:	97aa                	add	a5,a5,a0
    80201030:	4398                	lw	a4,0(a5)
    80201032:	43dc                	lw	a5,4(a5)
    80201034:	02f70c63          	beq	a4,a5,8020106c <push_queue+0x58>
		panic("queue shouldn't be overflow");
	}
	q->empty = 0;
    80201038:	6705                	lui	a4,0x1
    8020103a:	9726                	add	a4,a4,s1
    8020103c:	00072423          	sw	zero,8(a4) # 1008 <_entry-0x801feff8>
	q->data[q->tail] = value;
    80201040:	435c                	lw	a5,4(a4)
    80201042:	00279513          	slli	a0,a5,0x2
    80201046:	94aa                	add	s1,s1,a0
    80201048:	0124a023          	sw	s2,0(s1)
	q->tail = (q->tail + 1) % NPROC;
    8020104c:	2785                	addiw	a5,a5,1
    8020104e:	41f7d69b          	sraiw	a3,a5,0x1f
    80201052:	0176d69b          	srliw	a3,a3,0x17
    80201056:	9fb5                	addw	a5,a5,a3
    80201058:	1ff7f793          	andi	a5,a5,511
    8020105c:	9f95                	subw	a5,a5,a3
    8020105e:	c35c                	sw	a5,4(a4)
}
    80201060:	60e2                	ld	ra,24(sp)
    80201062:	6442                	ld	s0,16(sp)
    80201064:	64a2                	ld	s1,8(sp)
    80201066:	6902                	ld	s2,0(sp)
    80201068:	6105                	addi	sp,sp,32
    8020106a:	8082                	ret
		panic("queue shouldn't be overflow");
    8020106c:	00000097          	auipc	ra,0x0
    80201070:	8da080e7          	jalr	-1830(ra) # 80200946 <threadid>
    80201074:	86aa                	mv	a3,a0
    80201076:	47b5                	li	a5,13
    80201078:	00003717          	auipc	a4,0x3
    8020107c:	16070713          	addi	a4,a4,352 # 802041d8 <digits+0xa8>
    80201080:	00003617          	auipc	a2,0x3
    80201084:	f9060613          	addi	a2,a2,-112 # 80204010 <e_text+0x10>
    80201088:	45fd                	li	a1,31
    8020108a:	00003517          	auipc	a0,0x3
    8020108e:	15e50513          	addi	a0,a0,350 # 802041e8 <digits+0xb8>
    80201092:	fffff097          	auipc	ra,0xfffff
    80201096:	6de080e7          	jalr	1758(ra) # 80200770 <printf>
    8020109a:	00000097          	auipc	ra,0x0
    8020109e:	086080e7          	jalr	134(ra) # 80201120 <shutdown>
    802010a2:	bf59                	j	80201038 <push_queue+0x24>

00000000802010a4 <pop_queue>:

int pop_queue(struct queue *q)
{
    802010a4:	1141                	addi	sp,sp,-16
    802010a6:	e422                	sd	s0,8(sp)
    802010a8:	0800                	addi	s0,sp,16
	if (q->empty)
    802010aa:	6785                	lui	a5,0x1
    802010ac:	97aa                	add	a5,a5,a0
    802010ae:	479c                	lw	a5,8(a5)
    802010b0:	ef95                	bnez	a5,802010ec <pop_queue+0x48>
		return -1;
	int value = q->data[q->front];
    802010b2:	6605                	lui	a2,0x1
    802010b4:	962a                	add	a2,a2,a0
    802010b6:	4218                	lw	a4,0(a2)
    802010b8:	00271793          	slli	a5,a4,0x2
    802010bc:	97aa                	add	a5,a5,a0
    802010be:	4388                	lw	a0,0(a5)
	q->front = (q->front + 1) % NPROC;
    802010c0:	2705                	addiw	a4,a4,1
    802010c2:	41f7579b          	sraiw	a5,a4,0x1f
    802010c6:	0177d59b          	srliw	a1,a5,0x17
    802010ca:	00b707bb          	addw	a5,a4,a1
    802010ce:	1ff7f793          	andi	a5,a5,511
    802010d2:	9f8d                	subw	a5,a5,a1
    802010d4:	0007871b          	sext.w	a4,a5
    802010d8:	c21c                	sw	a5,0(a2)
	if (q->front == q->tail)
    802010da:	425c                	lw	a5,4(a2)
    802010dc:	00e78563          	beq	a5,a4,802010e6 <pop_queue+0x42>
		q->empty = 1;
	return value;
}
    802010e0:	6422                	ld	s0,8(sp)
    802010e2:	0141                	addi	sp,sp,16
    802010e4:	8082                	ret
		q->empty = 1;
    802010e6:	4785                	li	a5,1
    802010e8:	c61c                	sw	a5,8(a2)
    802010ea:	bfdd                	j	802010e0 <pop_queue+0x3c>
		return -1;
    802010ec:	557d                	li	a0,-1
    802010ee:	bfcd                	j	802010e0 <pop_queue+0x3c>

00000000802010f0 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    802010f0:	1141                	addi	sp,sp,-16
    802010f2:	e422                	sd	s0,8(sp)
    802010f4:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802010f6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802010f8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802010fa:	4885                	li	a7,1
	asm volatile("ecall"
    802010fc:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80201100:	6422                	ld	s0,8(sp)
    80201102:	0141                	addi	sp,sp,16
    80201104:	8082                	ret

0000000080201106 <console_getchar>:

int console_getchar()
{
    80201106:	1141                	addi	sp,sp,-16
    80201108:	e422                	sd	s0,8(sp)
    8020110a:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    8020110c:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    8020110e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80201110:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80201112:	4889                	li	a7,2
	asm volatile("ecall"
    80201114:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    80201118:	2501                	sext.w	a0,a0
    8020111a:	6422                	ld	s0,8(sp)
    8020111c:	0141                	addi	sp,sp,16
    8020111e:	8082                	ret

0000000080201120 <shutdown>:

void shutdown()
{
    80201120:	1141                	addi	sp,sp,-16
    80201122:	e422                	sd	s0,8(sp)
    80201124:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    80201126:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    80201128:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    8020112a:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    8020112c:	48a1                	li	a7,8
	asm volatile("ecall"
    8020112e:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    80201132:	6422                	ld	s0,8(sp)
    80201134:	0141                	addi	sp,sp,16
    80201136:	8082                	ret

0000000080201138 <set_timer>:

void set_timer(uint64 stime)
{
    80201138:	1141                	addi	sp,sp,-16
    8020113a:	e422                	sd	s0,8(sp)
    8020113c:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    8020113e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80201140:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80201142:	4881                	li	a7,0
	asm volatile("ecall"
    80201144:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    80201148:	6422                	ld	s0,8(sp)
    8020114a:	0141                	addi	sp,sp,16
    8020114c:	8082                	ret

000000008020114e <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    8020114e:	1141                	addi	sp,sp,-16
    80201150:	e422                	sd	s0,8(sp)
    80201152:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    80201154:	ca19                	beqz	a2,8020116a <memset+0x1c>
    80201156:	87aa                	mv	a5,a0
    80201158:	1602                	slli	a2,a2,0x20
    8020115a:	9201                	srli	a2,a2,0x20
    8020115c:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    80201160:	00b78023          	sb	a1,0(a5) # 1000 <_entry-0x801ff000>
	for (i = 0; i < n; i++) {
    80201164:	0785                	addi	a5,a5,1
    80201166:	fee79de3          	bne	a5,a4,80201160 <memset+0x12>
	}
	return dst;
}
    8020116a:	6422                	ld	s0,8(sp)
    8020116c:	0141                	addi	sp,sp,16
    8020116e:	8082                	ret

0000000080201170 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80201170:	1141                	addi	sp,sp,-16
    80201172:	e422                	sd	s0,8(sp)
    80201174:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    80201176:	ca05                	beqz	a2,802011a6 <memcmp+0x36>
    80201178:	fff6069b          	addiw	a3,a2,-1
    8020117c:	1682                	slli	a3,a3,0x20
    8020117e:	9281                	srli	a3,a3,0x20
    80201180:	0685                	addi	a3,a3,1
    80201182:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    80201184:	00054783          	lbu	a5,0(a0)
    80201188:	0005c703          	lbu	a4,0(a1) # 2000000 <_entry-0x7e200000>
    8020118c:	00e79863          	bne	a5,a4,8020119c <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    80201190:	0505                	addi	a0,a0,1
    80201192:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    80201194:	fed518e3          	bne	a0,a3,80201184 <memcmp+0x14>
	}

	return 0;
    80201198:	4501                	li	a0,0
    8020119a:	a019                	j	802011a0 <memcmp+0x30>
			return *s1 - *s2;
    8020119c:	40e7853b          	subw	a0,a5,a4
}
    802011a0:	6422                	ld	s0,8(sp)
    802011a2:	0141                	addi	sp,sp,16
    802011a4:	8082                	ret
	return 0;
    802011a6:	4501                	li	a0,0
    802011a8:	bfe5                	j	802011a0 <memcmp+0x30>

00000000802011aa <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    802011aa:	1141                	addi	sp,sp,-16
    802011ac:	e422                	sd	s0,8(sp)
    802011ae:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    802011b0:	02a5e563          	bltu	a1,a0,802011da <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    802011b4:	fff6069b          	addiw	a3,a2,-1
    802011b8:	ce11                	beqz	a2,802011d4 <memmove+0x2a>
    802011ba:	1682                	slli	a3,a3,0x20
    802011bc:	9281                	srli	a3,a3,0x20
    802011be:	0685                	addi	a3,a3,1
    802011c0:	96ae                	add	a3,a3,a1
    802011c2:	87aa                	mv	a5,a0
			*d++ = *s++;
    802011c4:	0585                	addi	a1,a1,1
    802011c6:	0785                	addi	a5,a5,1
    802011c8:	fff5c703          	lbu	a4,-1(a1)
    802011cc:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    802011d0:	fed59ae3          	bne	a1,a3,802011c4 <memmove+0x1a>

	return dst;
}
    802011d4:	6422                	ld	s0,8(sp)
    802011d6:	0141                	addi	sp,sp,16
    802011d8:	8082                	ret
	if (s < d && s + n > d) {
    802011da:	02061713          	slli	a4,a2,0x20
    802011de:	9301                	srli	a4,a4,0x20
    802011e0:	00e587b3          	add	a5,a1,a4
    802011e4:	fcf578e3          	bgeu	a0,a5,802011b4 <memmove+0xa>
		d += n;
    802011e8:	972a                	add	a4,a4,a0
		while (n-- > 0)
    802011ea:	fff6069b          	addiw	a3,a2,-1
    802011ee:	d27d                	beqz	a2,802011d4 <memmove+0x2a>
    802011f0:	02069613          	slli	a2,a3,0x20
    802011f4:	9201                	srli	a2,a2,0x20
    802011f6:	fff64613          	not	a2,a2
    802011fa:	963e                	add	a2,a2,a5
			*--d = *--s;
    802011fc:	17fd                	addi	a5,a5,-1
    802011fe:	177d                	addi	a4,a4,-1
    80201200:	0007c683          	lbu	a3,0(a5)
    80201204:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    80201208:	fef61ae3          	bne	a2,a5,802011fc <memmove+0x52>
    8020120c:	b7e1                	j	802011d4 <memmove+0x2a>

000000008020120e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    8020120e:	1141                	addi	sp,sp,-16
    80201210:	e406                	sd	ra,8(sp)
    80201212:	e022                	sd	s0,0(sp)
    80201214:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    80201216:	00000097          	auipc	ra,0x0
    8020121a:	f94080e7          	jalr	-108(ra) # 802011aa <memmove>
}
    8020121e:	60a2                	ld	ra,8(sp)
    80201220:	6402                	ld	s0,0(sp)
    80201222:	0141                	addi	sp,sp,16
    80201224:	8082                	ret

0000000080201226 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80201226:	1141                	addi	sp,sp,-16
    80201228:	e422                	sd	s0,8(sp)
    8020122a:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    8020122c:	ce11                	beqz	a2,80201248 <strncmp+0x22>
    8020122e:	00054783          	lbu	a5,0(a0)
    80201232:	cf89                	beqz	a5,8020124c <strncmp+0x26>
    80201234:	0005c703          	lbu	a4,0(a1)
    80201238:	00f71a63          	bne	a4,a5,8020124c <strncmp+0x26>
		n--, p++, q++;
    8020123c:	367d                	addiw	a2,a2,-1
    8020123e:	0505                	addi	a0,a0,1
    80201240:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    80201242:	f675                	bnez	a2,8020122e <strncmp+0x8>
	if (n == 0)
		return 0;
    80201244:	4501                	li	a0,0
    80201246:	a809                	j	80201258 <strncmp+0x32>
    80201248:	4501                	li	a0,0
    8020124a:	a039                	j	80201258 <strncmp+0x32>
	if (n == 0)
    8020124c:	ca09                	beqz	a2,8020125e <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    8020124e:	00054503          	lbu	a0,0(a0)
    80201252:	0005c783          	lbu	a5,0(a1)
    80201256:	9d1d                	subw	a0,a0,a5
}
    80201258:	6422                	ld	s0,8(sp)
    8020125a:	0141                	addi	sp,sp,16
    8020125c:	8082                	ret
		return 0;
    8020125e:	4501                	li	a0,0
    80201260:	bfe5                	j	80201258 <strncmp+0x32>

0000000080201262 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    80201262:	1141                	addi	sp,sp,-16
    80201264:	e422                	sd	s0,8(sp)
    80201266:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80201268:	872a                	mv	a4,a0
    8020126a:	8832                	mv	a6,a2
    8020126c:	367d                	addiw	a2,a2,-1
    8020126e:	01005963          	blez	a6,80201280 <strncpy+0x1e>
    80201272:	0705                	addi	a4,a4,1
    80201274:	0005c783          	lbu	a5,0(a1)
    80201278:	fef70fa3          	sb	a5,-1(a4)
    8020127c:	0585                	addi	a1,a1,1
    8020127e:	f7f5                	bnez	a5,8020126a <strncpy+0x8>
		;
	while (n-- > 0)
    80201280:	86ba                	mv	a3,a4
    80201282:	00c05c63          	blez	a2,8020129a <strncpy+0x38>
		*s++ = 0;
    80201286:	0685                	addi	a3,a3,1
    80201288:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    8020128c:	fff6c793          	not	a5,a3
    80201290:	9fb9                	addw	a5,a5,a4
    80201292:	010787bb          	addw	a5,a5,a6
    80201296:	fef048e3          	bgtz	a5,80201286 <strncpy+0x24>
	return os;
}
    8020129a:	6422                	ld	s0,8(sp)
    8020129c:	0141                	addi	sp,sp,16
    8020129e:	8082                	ret

00000000802012a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    802012a0:	1141                	addi	sp,sp,-16
    802012a2:	e422                	sd	s0,8(sp)
    802012a4:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    802012a6:	02c05363          	blez	a2,802012cc <safestrcpy+0x2c>
    802012aa:	fff6069b          	addiw	a3,a2,-1
    802012ae:	1682                	slli	a3,a3,0x20
    802012b0:	9281                	srli	a3,a3,0x20
    802012b2:	96ae                	add	a3,a3,a1
    802012b4:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    802012b6:	00d58963          	beq	a1,a3,802012c8 <safestrcpy+0x28>
    802012ba:	0585                	addi	a1,a1,1
    802012bc:	0785                	addi	a5,a5,1
    802012be:	fff5c703          	lbu	a4,-1(a1)
    802012c2:	fee78fa3          	sb	a4,-1(a5)
    802012c6:	fb65                	bnez	a4,802012b6 <safestrcpy+0x16>
		;
	*s = 0;
    802012c8:	00078023          	sb	zero,0(a5)
	return os;
}
    802012cc:	6422                	ld	s0,8(sp)
    802012ce:	0141                	addi	sp,sp,16
    802012d0:	8082                	ret

00000000802012d2 <strlen>:

int strlen(const char *s)
{
    802012d2:	1141                	addi	sp,sp,-16
    802012d4:	e422                	sd	s0,8(sp)
    802012d6:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    802012d8:	00054783          	lbu	a5,0(a0)
    802012dc:	cf91                	beqz	a5,802012f8 <strlen+0x26>
    802012de:	0505                	addi	a0,a0,1
    802012e0:	87aa                	mv	a5,a0
    802012e2:	4685                	li	a3,1
    802012e4:	9e89                	subw	a3,a3,a0
    802012e6:	00f6853b          	addw	a0,a3,a5
    802012ea:	0785                	addi	a5,a5,1
    802012ec:	fff7c703          	lbu	a4,-1(a5)
    802012f0:	fb7d                	bnez	a4,802012e6 <strlen+0x14>
		;
	return n;
}
    802012f2:	6422                	ld	s0,8(sp)
    802012f4:	0141                	addi	sp,sp,16
    802012f6:	8082                	ret
	for (n = 0; s[n]; n++)
    802012f8:	4501                	li	a0,0
    802012fa:	bfe5                	j	802012f2 <strlen+0x20>

00000000802012fc <dummy>:

void dummy(int _, ...)
{
    802012fc:	715d                	addi	sp,sp,-80
    802012fe:	e422                	sd	s0,8(sp)
    80201300:	0800                	addi	s0,sp,16
    80201302:	e40c                	sd	a1,8(s0)
    80201304:	e810                	sd	a2,16(s0)
    80201306:	ec14                	sd	a3,24(s0)
    80201308:	f018                	sd	a4,32(s0)
    8020130a:	f41c                	sd	a5,40(s0)
    8020130c:	03043823          	sd	a6,48(s0)
    80201310:	03143c23          	sd	a7,56(s0)
    80201314:	6422                	ld	s0,8(sp)
    80201316:	6161                	addi	sp,sp,80
    80201318:	8082                	ret

000000008020131a <sys_write>:
#include "vm.h"

#define MAX_MMAP_SIZE (1024 * 1024 * 1024)

uint64 sys_write(int fd, uint64 va, uint len)
{
    8020131a:	7111                	addi	sp,sp,-256
    8020131c:	fd86                	sd	ra,248(sp)
    8020131e:	f9a2                	sd	s0,240(sp)
    80201320:	f5a6                	sd	s1,232(sp)
    80201322:	f1ca                	sd	s2,224(sp)
    80201324:	edce                	sd	s3,216(sp)
    80201326:	0200                	addi	s0,sp,256
    80201328:	84aa                	mv	s1,a0
    8020132a:	89ae                	mv	s3,a1
    8020132c:	8932                	mv	s2,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
    8020132e:	86b2                	mv	a3,a2
    80201330:	862e                	mv	a2,a1
    80201332:	85aa                	mv	a1,a0
    80201334:	4501                	li	a0,0
    80201336:	00000097          	auipc	ra,0x0
    8020133a:	fc6080e7          	jalr	-58(ra) # 802012fc <dummy>
	if (fd != STDOUT)
    8020133e:	4785                	li	a5,1
		return -1;
    80201340:	557d                	li	a0,-1
	if (fd != STDOUT)
    80201342:	00f48963          	beq	s1,a5,80201354 <sys_write+0x3a>
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}
    80201346:	70ee                	ld	ra,248(sp)
    80201348:	744e                	ld	s0,240(sp)
    8020134a:	74ae                	ld	s1,232(sp)
    8020134c:	790e                	ld	s2,224(sp)
    8020134e:	69ee                	ld	s3,216(sp)
    80201350:	6111                	addi	sp,sp,256
    80201352:	8082                	ret
	struct proc *p = curr_proc();
    80201354:	fffff097          	auipc	ra,0xfffff
    80201358:	608080e7          	jalr	1544(ra) # 8020095c <curr_proc>
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    8020135c:	86ca                	mv	a3,s2
    8020135e:	0c800793          	li	a5,200
    80201362:	0127f463          	bgeu	a5,s2,8020136a <sys_write+0x50>
    80201366:	0c800693          	li	a3,200
    8020136a:	1682                	slli	a3,a3,0x20
    8020136c:	9281                	srli	a3,a3,0x20
    8020136e:	864e                	mv	a2,s3
    80201370:	f0840593          	addi	a1,s0,-248
    80201374:	6508                	ld	a0,8(a0)
    80201376:	00001097          	auipc	ra,0x1
    8020137a:	2a4080e7          	jalr	676(ra) # 8020261a <copyinstr>
    8020137e:	892a                	mv	s2,a0
	debugf("size = %d", size);
    80201380:	85aa                	mv	a1,a0
    80201382:	4501                	li	a0,0
    80201384:	00000097          	auipc	ra,0x0
    80201388:	f78080e7          	jalr	-136(ra) # 802012fc <dummy>
	for (int i = 0; i < size; ++i) {
    8020138c:	03205563          	blez	s2,802013b6 <sys_write+0x9c>
    80201390:	f0840493          	addi	s1,s0,-248
    80201394:	fff9099b          	addiw	s3,s2,-1
    80201398:	1982                	slli	s3,s3,0x20
    8020139a:	0209d993          	srli	s3,s3,0x20
    8020139e:	f0940793          	addi	a5,s0,-247
    802013a2:	99be                	add	s3,s3,a5
		console_putchar(str[i]);
    802013a4:	0004c503          	lbu	a0,0(s1)
    802013a8:	00000097          	auipc	ra,0x0
    802013ac:	d48080e7          	jalr	-696(ra) # 802010f0 <console_putchar>
	for (int i = 0; i < size; ++i) {
    802013b0:	0485                	addi	s1,s1,1
    802013b2:	ff3499e3          	bne	s1,s3,802013a4 <sys_write+0x8a>
	return size;
    802013b6:	854a                	mv	a0,s2
    802013b8:	b779                	j	80201346 <sys_write+0x2c>

00000000802013ba <sys_read>:

uint64 sys_read(int fd, uint64 va, uint64 len)
{
    802013ba:	716d                	addi	sp,sp,-272
    802013bc:	e606                	sd	ra,264(sp)
    802013be:	e222                	sd	s0,256(sp)
    802013c0:	fda6                	sd	s1,248(sp)
    802013c2:	f9ca                	sd	s2,240(sp)
    802013c4:	f5ce                	sd	s3,232(sp)
    802013c6:	f1d2                	sd	s4,224(sp)
    802013c8:	edd6                	sd	s5,216(sp)
    802013ca:	0a00                	addi	s0,sp,272
    802013cc:	84aa                	mv	s1,a0
    802013ce:	8a2e                	mv	s4,a1
    802013d0:	8932                	mv	s2,a2
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
    802013d2:	86b2                	mv	a3,a2
    802013d4:	862e                	mv	a2,a1
    802013d6:	85aa                	mv	a1,a0
    802013d8:	4501                	li	a0,0
    802013da:	00000097          	auipc	ra,0x0
    802013de:	f22080e7          	jalr	-222(ra) # 802012fc <dummy>
	if (fd != STDIN)
		return -1;
    802013e2:	557d                	li	a0,-1
	if (fd != STDIN)
    802013e4:	e0a1                	bnez	s1,80201424 <sys_read+0x6a>
	struct proc *p = curr_proc();
    802013e6:	fffff097          	auipc	ra,0xfffff
    802013ea:	576080e7          	jalr	1398(ra) # 8020095c <curr_proc>
    802013ee:	8aaa                	mv	s5,a0
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
    802013f0:	00090f63          	beqz	s2,8020140e <sys_read+0x54>
    802013f4:	ef840493          	addi	s1,s0,-264
    802013f8:	009909b3          	add	s3,s2,s1
		int c = consgetc();
    802013fc:	fffff097          	auipc	ra,0xfffff
    80201400:	c34080e7          	jalr	-972(ra) # 80200030 <consgetc>
		str[i] = c;
    80201404:	00a48023          	sb	a0,0(s1)
	for (int i = 0; i < len; ++i) {
    80201408:	0485                	addi	s1,s1,1
    8020140a:	ff3499e3          	bne	s1,s3,802013fc <sys_read+0x42>
	}
	copyout(p->pagetable, va, str, len);
    8020140e:	86ca                	mv	a3,s2
    80201410:	ef840613          	addi	a2,s0,-264
    80201414:	85d2                	mv	a1,s4
    80201416:	008ab503          	ld	a0,8(s5)
    8020141a:	00001097          	auipc	ra,0x1
    8020141e:	0e6080e7          	jalr	230(ra) # 80202500 <copyout>
	return len;
    80201422:	854a                	mv	a0,s2
}
    80201424:	60b2                	ld	ra,264(sp)
    80201426:	6412                	ld	s0,256(sp)
    80201428:	74ee                	ld	s1,248(sp)
    8020142a:	794e                	ld	s2,240(sp)
    8020142c:	79ae                	ld	s3,232(sp)
    8020142e:	7a0e                	ld	s4,224(sp)
    80201430:	6aee                	ld	s5,216(sp)
    80201432:	6151                	addi	sp,sp,272
    80201434:	8082                	ret

0000000080201436 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80201436:	1141                	addi	sp,sp,-16
    80201438:	e406                	sd	ra,8(sp)
    8020143a:	e022                	sd	s0,0(sp)
    8020143c:	0800                	addi	s0,sp,16
	exit(code);
    8020143e:	00000097          	auipc	ra,0x0
    80201442:	b4e080e7          	jalr	-1202(ra) # 80200f8c <exit>

0000000080201446 <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    80201446:	1141                	addi	sp,sp,-16
    80201448:	e406                	sd	ra,8(sp)
    8020144a:	e022                	sd	s0,0(sp)
    8020144c:	0800                	addi	s0,sp,16
	yield();
    8020144e:	00000097          	auipc	ra,0x0
    80201452:	8b0080e7          	jalr	-1872(ra) # 80200cfe <yield>
	return 0;
}
    80201456:	4501                	li	a0,0
    80201458:	60a2                	ld	ra,8(sp)
    8020145a:	6402                	ld	s0,0(sp)
    8020145c:	0141                	addi	sp,sp,16
    8020145e:	8082                	ret

0000000080201460 <sys_gettimeofday>:

uint64 sys_gettimeofday(uint64 va, int _tz) 
{
    80201460:	1101                	addi	sp,sp,-32
    80201462:	ec06                	sd	ra,24(sp)
    80201464:	e822                	sd	s0,16(sp)
    80201466:	e426                	sd	s1,8(sp)
    80201468:	1000                	addi	s0,sp,32
    8020146a:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    8020146c:	fffff097          	auipc	ra,0xfffff
    80201470:	4f0080e7          	jalr	1264(ra) # 8020095c <curr_proc>

	uint64 pa = useraddr(p->pagetable, va);
    80201474:	85a6                	mv	a1,s1
    80201476:	6508                	ld	a0,8(a0)
    80201478:	00001097          	auipc	ra,0x1
    8020147c:	b14080e7          	jalr	-1260(ra) # 80201f8c <useraddr>
	if (pa == 0) {
    80201480:	cd15                	beqz	a0,802014bc <sys_gettimeofday+0x5c>
    80201482:	84aa                	mv	s1,a0
		return -1;
	}

	TimeVal *val = (TimeVal *)pa;

	uint64 cycle = get_cycle();
    80201484:	00000097          	auipc	ra,0x0
    80201488:	634080e7          	jalr	1588(ra) # 80201ab8 <get_cycle>
	val->sec = cycle / CPU_FREQ;
    8020148c:	00bec7b7          	lui	a5,0xbec
    80201490:	c2078713          	addi	a4,a5,-992 # bebc20 <_entry-0x7f6143e0>
    80201494:	02e557b3          	divu	a5,a0,a4
    80201498:	e09c                	sd	a5,0(s1)
	val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    8020149a:	02e577b3          	remu	a5,a0,a4
    8020149e:	000f4537          	lui	a0,0xf4
    802014a2:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    802014a6:	02a787b3          	mul	a5,a5,a0
    802014aa:	02e7d7b3          	divu	a5,a5,a4
    802014ae:	e49c                	sd	a5,8(s1)
	return 0;
    802014b0:	4501                	li	a0,0
}
    802014b2:	60e2                	ld	ra,24(sp)
    802014b4:	6442                	ld	s0,16(sp)
    802014b6:	64a2                	ld	s1,8(sp)
    802014b8:	6105                	addi	sp,sp,32
    802014ba:	8082                	ret
		return -1;
    802014bc:	557d                	li	a0,-1
    802014be:	bfd5                	j	802014b2 <sys_gettimeofday+0x52>

00000000802014c0 <sys_mmap>:

uint64 sys_mmap(uint64 start, uint64 len, int port, int flag, int fd) {
    802014c0:	715d                	addi	sp,sp,-80
    802014c2:	e486                	sd	ra,72(sp)
    802014c4:	e0a2                	sd	s0,64(sp)
    802014c6:	fc26                	sd	s1,56(sp)
    802014c8:	f84a                	sd	s2,48(sp)
    802014ca:	f44e                	sd	s3,40(sp)
    802014cc:	f052                	sd	s4,32(sp)
    802014ce:	ec56                	sd	s5,24(sp)
    802014d0:	e85a                	sd	s6,16(sp)
    802014d2:	e45e                	sd	s7,8(sp)
    802014d4:	0880                	addi	s0,sp,80
    802014d6:	892e                	mv	s2,a1
	if (len == 0) return 0;
    802014d8:	8b2e                	mv	s6,a1
    802014da:	c5f9                	beqz	a1,802015a8 <sys_mmap+0xe8>
    802014dc:	84aa                	mv	s1,a0
    802014de:	8a32                	mv	s4,a2
	if (len > MAX_MMAP_SIZE) return -1;
    802014e0:	400007b7          	lui	a5,0x40000
    802014e4:	5b7d                	li	s6,-1
    802014e6:	0cb7e163          	bltu	a5,a1,802015a8 <sys_mmap+0xe8>
	if (start % PGSIZE != 0) return -1;
    802014ea:	03451793          	slli	a5,a0,0x34
    802014ee:	0347db13          	srli	s6,a5,0x34
    802014f2:	e7d5                	bnez	a5,8020159e <sys_mmap+0xde>
	if ((port & ~0x7) != 0) return -1;
    802014f4:	ff867793          	andi	a5,a2,-8
    802014f8:	e7cd                	bnez	a5,802015a2 <sys_mmap+0xe2>
	if ((port & 0x7) == 0) return -1;
    802014fa:	00767793          	andi	a5,a2,7
    802014fe:	c7c5                	beqz	a5,802015a6 <sys_mmap+0xe6>

	struct proc *p = curr_proc();
    80201500:	fffff097          	auipc	ra,0xfffff
    80201504:	45c080e7          	jalr	1116(ra) # 8020095c <curr_proc>
    80201508:	8aaa                	mv	s5,a0
	uint64 aligned_len = PGROUNDUP(len);
    8020150a:	6985                	lui	s3,0x1
    8020150c:	19fd                	addi	s3,s3,-1
    8020150e:	99ca                	add	s3,s3,s2
    80201510:	797d                	lui	s2,0xfffff
    80201512:	0129f9b3          	and	s3,s3,s2

	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
    80201516:	99a6                	add	s3,s3,s1
    80201518:	0134ff63          	bgeu	s1,s3,80201536 <sys_mmap+0x76>
    8020151c:	8926                	mv	s2,s1
    8020151e:	6b85                	lui	s7,0x1
		if (useraddr(p->pagetable, addr) != 0) {
    80201520:	85ca                	mv	a1,s2
    80201522:	008ab503          	ld	a0,8(s5)
    80201526:	00001097          	auipc	ra,0x1
    8020152a:	a66080e7          	jalr	-1434(ra) # 80201f8c <useraddr>
    8020152e:	e949                	bnez	a0,802015c0 <sys_mmap+0x100>
	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
    80201530:	995e                	add	s2,s2,s7
    80201532:	ff3967e3          	bltu	s2,s3,80201520 <sys_mmap+0x60>
			return -1;
		}
	}

	int perm = PTE_U;
	if (port & 1) perm |= PTE_R;
    80201536:	001a7793          	andi	a5,s4,1
	int perm = PTE_U;
    8020153a:	4bc1                	li	s7,16
	if (port & 1) perm |= PTE_R;
    8020153c:	c391                	beqz	a5,80201540 <sys_mmap+0x80>
    8020153e:	4bc9                	li	s7,18
	if (port & 2) perm |= PTE_W;
    80201540:	002a7793          	andi	a5,s4,2
    80201544:	c399                	beqz	a5,8020154a <sys_mmap+0x8a>
    80201546:	004beb93          	ori	s7,s7,4
	if (port & 4) perm |= PTE_X;
    8020154a:	004a7793          	andi	a5,s4,4
    8020154e:	c399                	beqz	a5,80201554 <sys_mmap+0x94>
    80201550:	008beb93          	ori	s7,s7,8

	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
    80201554:	0534fa63          	bgeu	s1,s3,802015a8 <sys_mmap+0xe8>
		void *pa = kalloc();
    80201558:	fffff097          	auipc	ra,0xfffff
    8020155c:	be2080e7          	jalr	-1054(ra) # 8020013a <kalloc>
    80201560:	892a                	mv	s2,a0
		if (pa == 0) return -1;
    80201562:	c12d                	beqz	a0,802015c4 <sys_mmap+0x104>
		memset(pa, 0, PGSIZE);
    80201564:	6605                	lui	a2,0x1
    80201566:	4581                	li	a1,0
    80201568:	00000097          	auipc	ra,0x0
    8020156c:	be6080e7          	jalr	-1050(ra) # 8020114e <memset>

		if (mappages(p->pagetable, addr, PGSIZE, (uint64)pa, perm) != 0) {
    80201570:	875e                	mv	a4,s7
    80201572:	86ca                	mv	a3,s2
    80201574:	6605                	lui	a2,0x1
    80201576:	85a6                	mv	a1,s1
    80201578:	008ab503          	ld	a0,8(s5)
    8020157c:	00001097          	auipc	ra,0x1
    80201580:	a38080e7          	jalr	-1480(ra) # 80201fb4 <mappages>
    80201584:	e511                	bnez	a0,80201590 <sys_mmap+0xd0>
	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
    80201586:	6785                	lui	a5,0x1
    80201588:	94be                	add	s1,s1,a5
    8020158a:	fd34e7e3          	bltu	s1,s3,80201558 <sys_mmap+0x98>
    8020158e:	a829                	j	802015a8 <sys_mmap+0xe8>
			kfree(pa);
    80201590:	854a                	mv	a0,s2
    80201592:	fffff097          	auipc	ra,0xfffff
    80201596:	ab6080e7          	jalr	-1354(ra) # 80200048 <kfree>
			return -1;
    8020159a:	5b7d                	li	s6,-1
    8020159c:	a031                	j	802015a8 <sys_mmap+0xe8>
	if (start % PGSIZE != 0) return -1;
    8020159e:	5b7d                	li	s6,-1
    802015a0:	a021                	j	802015a8 <sys_mmap+0xe8>
	if ((port & ~0x7) != 0) return -1;
    802015a2:	5b7d                	li	s6,-1
    802015a4:	a011                	j	802015a8 <sys_mmap+0xe8>
	if ((port & 0x7) == 0) return -1;
    802015a6:	5b7d                	li	s6,-1
		}
	}

	return 0;
}
    802015a8:	855a                	mv	a0,s6
    802015aa:	60a6                	ld	ra,72(sp)
    802015ac:	6406                	ld	s0,64(sp)
    802015ae:	74e2                	ld	s1,56(sp)
    802015b0:	7942                	ld	s2,48(sp)
    802015b2:	79a2                	ld	s3,40(sp)
    802015b4:	7a02                	ld	s4,32(sp)
    802015b6:	6ae2                	ld	s5,24(sp)
    802015b8:	6b42                	ld	s6,16(sp)
    802015ba:	6ba2                	ld	s7,8(sp)
    802015bc:	6161                	addi	sp,sp,80
    802015be:	8082                	ret
			return -1;
    802015c0:	5b7d                	li	s6,-1
    802015c2:	b7dd                	j	802015a8 <sys_mmap+0xe8>
		if (pa == 0) return -1;
    802015c4:	5b7d                	li	s6,-1
    802015c6:	b7cd                	j	802015a8 <sys_mmap+0xe8>

00000000802015c8 <sys_munmap>:

uint64 sys_munmap(uint64 start, uint64 len) {
    802015c8:	715d                	addi	sp,sp,-80
    802015ca:	e486                	sd	ra,72(sp)
    802015cc:	e0a2                	sd	s0,64(sp)
    802015ce:	fc26                	sd	s1,56(sp)
    802015d0:	f84a                	sd	s2,48(sp)
    802015d2:	f44e                	sd	s3,40(sp)
    802015d4:	f052                	sd	s4,32(sp)
    802015d6:	ec56                	sd	s5,24(sp)
    802015d8:	e85a                	sd	s6,16(sp)
    802015da:	e45e                	sd	s7,8(sp)
    802015dc:	0880                	addi	s0,sp,80
	if (start % PGSIZE != 0) { return -1; }
    802015de:	03451793          	slli	a5,a0,0x34
    802015e2:	5bfd                	li	s7,-1
    802015e4:	ebb1                	bnez	a5,80201638 <sys_munmap+0x70>
    802015e6:	8a2a                	mv	s4,a0
    802015e8:	84ae                	mv	s1,a1
    802015ea:	0347db93          	srli	s7,a5,0x34
	
	struct proc *p = curr_proc();
    802015ee:	fffff097          	auipc	ra,0xfffff
    802015f2:	36e080e7          	jalr	878(ra) # 8020095c <curr_proc>
    802015f6:	89aa                	mv	s3,a0
	uint64 aligned_len = PGROUNDUP(len);
    802015f8:	6b05                	lui	s6,0x1
    802015fa:	1b7d                	addi	s6,s6,-1
    802015fc:	9b26                	add	s6,s6,s1
    802015fe:	797d                	lui	s2,0xfffff
    80201600:	012b7933          	and	s2,s6,s2

	for (uint64 addr = start; addr < start + aligned_len;  addr += PGSIZE) {
    80201604:	9952                	add	s2,s2,s4
    80201606:	012a7f63          	bgeu	s4,s2,80201624 <sys_munmap+0x5c>
    8020160a:	84d2                	mv	s1,s4
    8020160c:	6a85                	lui	s5,0x1
		if (useraddr(p->pagetable, addr) == 0) {
    8020160e:	85a6                	mv	a1,s1
    80201610:	0089b503          	ld	a0,8(s3) # 1008 <_entry-0x801feff8>
    80201614:	00001097          	auipc	ra,0x1
    80201618:	978080e7          	jalr	-1672(ra) # 80201f8c <useraddr>
    8020161c:	c915                	beqz	a0,80201650 <sys_munmap+0x88>
	for (uint64 addr = start; addr < start + aligned_len;  addr += PGSIZE) {
    8020161e:	94d6                	add	s1,s1,s5
    80201620:	ff24e7e3          	bltu	s1,s2,8020160e <sys_munmap+0x46>
			return -1;
		}
	}

	uvmunmap(p->pagetable, start, aligned_len / PGSIZE, 1);
    80201624:	4685                	li	a3,1
    80201626:	00cb5613          	srli	a2,s6,0xc
    8020162a:	85d2                	mv	a1,s4
    8020162c:	0089b503          	ld	a0,8(s3)
    80201630:	00001097          	auipc	ra,0x1
    80201634:	b72080e7          	jalr	-1166(ra) # 802021a2 <uvmunmap>

	return 0;
}
    80201638:	855e                	mv	a0,s7
    8020163a:	60a6                	ld	ra,72(sp)
    8020163c:	6406                	ld	s0,64(sp)
    8020163e:	74e2                	ld	s1,56(sp)
    80201640:	7942                	ld	s2,48(sp)
    80201642:	79a2                	ld	s3,40(sp)
    80201644:	7a02                	ld	s4,32(sp)
    80201646:	6ae2                	ld	s5,24(sp)
    80201648:	6b42                	ld	s6,16(sp)
    8020164a:	6ba2                	ld	s7,8(sp)
    8020164c:	6161                	addi	sp,sp,80
    8020164e:	8082                	ret
			return -1;
    80201650:	5bfd                	li	s7,-1
    80201652:	b7dd                	j	80201638 <sys_munmap+0x70>

0000000080201654 <sys_getpid>:

uint64 sys_getpid()
{
    80201654:	1141                	addi	sp,sp,-16
    80201656:	e406                	sd	ra,8(sp)
    80201658:	e022                	sd	s0,0(sp)
    8020165a:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
    8020165c:	fffff097          	auipc	ra,0xfffff
    80201660:	300080e7          	jalr	768(ra) # 8020095c <curr_proc>
}
    80201664:	4148                	lw	a0,4(a0)
    80201666:	60a2                	ld	ra,8(sp)
    80201668:	6402                	ld	s0,0(sp)
    8020166a:	0141                	addi	sp,sp,16
    8020166c:	8082                	ret

000000008020166e <sys_getppid>:

uint64 sys_getppid()
{
    8020166e:	1141                	addi	sp,sp,-16
    80201670:	e406                	sd	ra,8(sp)
    80201672:	e022                	sd	s0,0(sp)
    80201674:	0800                	addi	s0,sp,16
	struct proc *p = curr_proc();
    80201676:	fffff097          	auipc	ra,0xfffff
    8020167a:	2e6080e7          	jalr	742(ra) # 8020095c <curr_proc>
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
    8020167e:	715c                	ld	a5,160(a0)
    80201680:	4501                	li	a0,0
    80201682:	c391                	beqz	a5,80201686 <sys_getppid+0x18>
    80201684:	43c8                	lw	a0,4(a5)
}
    80201686:	60a2                	ld	ra,8(sp)
    80201688:	6402                	ld	s0,0(sp)
    8020168a:	0141                	addi	sp,sp,16
    8020168c:	8082                	ret

000000008020168e <sys_task_info>:

int sys_task_info(uint64 va) {
    8020168e:	1101                	addi	sp,sp,-32
    80201690:	ec06                	sd	ra,24(sp)
    80201692:	e822                	sd	s0,16(sp)
    80201694:	e426                	sd	s1,8(sp)
    80201696:	e04a                	sd	s2,0(sp)
    80201698:	1000                	addi	s0,sp,32
    8020169a:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    8020169c:	fffff097          	auipc	ra,0xfffff
    802016a0:	2c0080e7          	jalr	704(ra) # 8020095c <curr_proc>
    802016a4:	84aa                	mv	s1,a0

	uint64 pa = useraddr(p->pagetable, va);
    802016a6:	85ca                	mv	a1,s2
    802016a8:	6508                	ld	a0,8(a0)
    802016aa:	00001097          	auipc	ra,0x1
    802016ae:	8e2080e7          	jalr	-1822(ra) # 80201f8c <useraddr>
	if (pa == 0) { return -1; }
    802016b2:	cd29                	beqz	a0,8020170c <sys_task_info+0x7e>
    802016b4:	892a                	mv	s2,a0

	TaskInfo *ti = (TaskInfo *)pa;

	ti->status = p->info->status;
    802016b6:	1304b783          	ld	a5,304(s1)
    802016ba:	439c                	lw	a5,0(a5)
    802016bc:	c11c                	sw	a5,0(a0)

	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    802016be:	00450693          	addi	a3,a0,4
    802016c2:	4781                	li	a5,0
    802016c4:	1f400593          	li	a1,500
        ti->syscall_times[i] = p->info->syscall_times[i];
    802016c8:	1304b703          	ld	a4,304(s1)
    802016cc:	00279613          	slli	a2,a5,0x2
    802016d0:	9732                	add	a4,a4,a2
    802016d2:	4358                	lw	a4,4(a4)
    802016d4:	c298                	sw	a4,0(a3)
	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    802016d6:	2785                	addiw	a5,a5,1
    802016d8:	0691                	addi	a3,a3,4
    802016da:	feb797e3          	bne	a5,a1,802016c8 <sys_task_info+0x3a>
    }

	uint64 now = get_cycle() / (CPU_FREQ / 1000);
    802016de:	00000097          	auipc	ra,0x0
    802016e2:	3da080e7          	jalr	986(ra) # 80201ab8 <get_cycle>
    802016e6:	678d                	lui	a5,0x3
    802016e8:	0d478793          	addi	a5,a5,212 # 30d4 <_entry-0x801fcf2c>
    802016ec:	02f557b3          	divu	a5,a0,a5
	ti->time = now - p->info->time;
    802016f0:	1304b703          	ld	a4,304(s1)
    802016f4:	7d472703          	lw	a4,2004(a4)
    802016f8:	9f99                	subw	a5,a5,a4
    802016fa:	7cf92a23          	sw	a5,2004(s2) # fffffffffffff7d4 <e_bss+0xffffffff7f8717d4>

	return 0;
    802016fe:	4501                	li	a0,0
}
    80201700:	60e2                	ld	ra,24(sp)
    80201702:	6442                	ld	s0,16(sp)
    80201704:	64a2                	ld	s1,8(sp)
    80201706:	6902                	ld	s2,0(sp)
    80201708:	6105                	addi	sp,sp,32
    8020170a:	8082                	ret
	if (pa == 0) { return -1; }
    8020170c:	557d                	li	a0,-1
    8020170e:	bfcd                	j	80201700 <sys_task_info+0x72>

0000000080201710 <sys_clone>:


uint64 sys_clone()
{
    80201710:	1141                	addi	sp,sp,-16
    80201712:	e406                	sd	ra,8(sp)
    80201714:	e022                	sd	s0,0(sp)
    80201716:	0800                	addi	s0,sp,16
	debugf("fork!\n");
    80201718:	4501                	li	a0,0
    8020171a:	00000097          	auipc	ra,0x0
    8020171e:	be2080e7          	jalr	-1054(ra) # 802012fc <dummy>
	return fork();
    80201722:	fffff097          	auipc	ra,0xfffff
    80201726:	67e080e7          	jalr	1662(ra) # 80200da0 <fork>
}
    8020172a:	60a2                	ld	ra,8(sp)
    8020172c:	6402                	ld	s0,0(sp)
    8020172e:	0141                	addi	sp,sp,16
    80201730:	8082                	ret

0000000080201732 <sys_exec>:

uint64 sys_exec(uint64 va)
{
    80201732:	7151                	addi	sp,sp,-240
    80201734:	f586                	sd	ra,232(sp)
    80201736:	f1a2                	sd	s0,224(sp)
    80201738:	eda6                	sd	s1,216(sp)
    8020173a:	1980                	addi	s0,sp,240
    8020173c:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    8020173e:	fffff097          	auipc	ra,0xfffff
    80201742:	21e080e7          	jalr	542(ra) # 8020095c <curr_proc>
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201746:	0c800693          	li	a3,200
    8020174a:	8626                	mv	a2,s1
    8020174c:	f1840593          	addi	a1,s0,-232
    80201750:	6508                	ld	a0,8(a0)
    80201752:	00001097          	auipc	ra,0x1
    80201756:	ec8080e7          	jalr	-312(ra) # 8020261a <copyinstr>
	debugf("sys_exec %s\n", name);
    8020175a:	f1840593          	addi	a1,s0,-232
    8020175e:	4501                	li	a0,0
    80201760:	00000097          	auipc	ra,0x0
    80201764:	b9c080e7          	jalr	-1124(ra) # 802012fc <dummy>
	return exec(name);
    80201768:	f1840513          	addi	a0,s0,-232
    8020176c:	fffff097          	auipc	ra,0xfffff
    80201770:	72c080e7          	jalr	1836(ra) # 80200e98 <exec>
}
    80201774:	70ae                	ld	ra,232(sp)
    80201776:	740e                	ld	s0,224(sp)
    80201778:	64ee                	ld	s1,216(sp)
    8020177a:	616d                	addi	sp,sp,240
    8020177c:	8082                	ret

000000008020177e <sys_wait>:

uint64 sys_wait(int pid, uint64 va)
{
    8020177e:	1101                	addi	sp,sp,-32
    80201780:	ec06                	sd	ra,24(sp)
    80201782:	e822                	sd	s0,16(sp)
    80201784:	e426                	sd	s1,8(sp)
    80201786:	e04a                	sd	s2,0(sp)
    80201788:	1000                	addi	s0,sp,32
    8020178a:	84aa                	mv	s1,a0
    8020178c:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    8020178e:	fffff097          	auipc	ra,0xfffff
    80201792:	1ce080e7          	jalr	462(ra) # 8020095c <curr_proc>
	int *code = (int *)useraddr(p->pagetable, va);
    80201796:	85ca                	mv	a1,s2
    80201798:	6508                	ld	a0,8(a0)
    8020179a:	00000097          	auipc	ra,0x0
    8020179e:	7f2080e7          	jalr	2034(ra) # 80201f8c <useraddr>
    802017a2:	85aa                	mv	a1,a0
	return wait(pid, code);
    802017a4:	8526                	mv	a0,s1
    802017a6:	fffff097          	auipc	ra,0xfffff
    802017aa:	74a080e7          	jalr	1866(ra) # 80200ef0 <wait>
}
    802017ae:	60e2                	ld	ra,24(sp)
    802017b0:	6442                	ld	s0,16(sp)
    802017b2:	64a2                	ld	s1,8(sp)
    802017b4:	6902                	ld	s2,0(sp)
    802017b6:	6105                	addi	sp,sp,32
    802017b8:	8082                	ret

00000000802017ba <sys_spawn>:

uint64 sys_spawn(uint64 va)
{
    802017ba:	7111                	addi	sp,sp,-256
    802017bc:	fd86                	sd	ra,248(sp)
    802017be:	f9a2                	sd	s0,240(sp)
    802017c0:	f5a6                	sd	s1,232(sp)
    802017c2:	f1ca                	sd	s2,224(sp)
    802017c4:	edce                	sd	s3,216(sp)
    802017c6:	0200                	addi	s0,sp,256
    802017c8:	84aa                	mv	s1,a0
	// TODO: your job is to complete the sys call

	struct proc *p = curr_proc();
    802017ca:	fffff097          	auipc	ra,0xfffff
    802017ce:	192080e7          	jalr	402(ra) # 8020095c <curr_proc>
    802017d2:	892a                	mv	s2,a0

	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    802017d4:	0c800693          	li	a3,200
    802017d8:	8626                	mv	a2,s1
    802017da:	f0840593          	addi	a1,s0,-248
    802017de:	6508                	ld	a0,8(a0)
    802017e0:	00001097          	auipc	ra,0x1
    802017e4:	e3a080e7          	jalr	-454(ra) # 8020261a <copyinstr>
	int id = get_id_by_name(name);
    802017e8:	f0840513          	addi	a0,s0,-248
    802017ec:	fffff097          	auipc	ra,0xfffff
    802017f0:	a56080e7          	jalr	-1450(ra) # 80200242 <get_id_by_name>
	if (id < 0) { return -1; }
    802017f4:	02054b63          	bltz	a0,8020182a <sys_spawn+0x70>
    802017f8:	89aa                	mv	s3,a0

	struct proc *child_p = allocproc();
    802017fa:	fffff097          	auipc	ra,0xfffff
    802017fe:	2e8080e7          	jalr	744(ra) # 80200ae2 <allocproc>
    80201802:	84aa                	mv	s1,a0
	if (child_p == 0) { return -1; }
    80201804:	c50d                	beqz	a0,8020182e <sys_spawn+0x74>
	loader(id, child_p);
    80201806:	85aa                	mv	a1,a0
    80201808:	854e                	mv	a0,s3
    8020180a:	fffff097          	auipc	ra,0xfffff
    8020180e:	d2c080e7          	jalr	-724(ra) # 80200536 <loader>

	child_p->parent = p;
    80201812:	0b24b023          	sd	s2,160(s1)
	child_p->state = RUNNABLE;
    80201816:	478d                	li	a5,3
    80201818:	c09c                	sw	a5,0(s1)
	
	return child_p->pid;
    8020181a:	40c8                	lw	a0,4(s1)
}
    8020181c:	70ee                	ld	ra,248(sp)
    8020181e:	744e                	ld	s0,240(sp)
    80201820:	74ae                	ld	s1,232(sp)
    80201822:	790e                	ld	s2,224(sp)
    80201824:	69ee                	ld	s3,216(sp)
    80201826:	6111                	addi	sp,sp,256
    80201828:	8082                	ret
	if (id < 0) { return -1; }
    8020182a:	557d                	li	a0,-1
    8020182c:	bfc5                	j	8020181c <sys_spawn+0x62>
	if (child_p == 0) { return -1; }
    8020182e:	557d                	li	a0,-1
    80201830:	b7f5                	j	8020181c <sys_spawn+0x62>

0000000080201832 <sys_set_priority>:

uint64 sys_set_priority(long long prio){
    // TODO: your job is to complete the sys call
	if (prio < 2) { return -1; }
    80201832:	4785                	li	a5,1
    80201834:	02a7d963          	bge	a5,a0,80201866 <sys_set_priority+0x34>
uint64 sys_set_priority(long long prio){
    80201838:	1101                	addi	sp,sp,-32
    8020183a:	ec06                	sd	ra,24(sp)
    8020183c:	e822                	sd	s0,16(sp)
    8020183e:	e426                	sd	s1,8(sp)
    80201840:	1000                	addi	s0,sp,32
    80201842:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    80201844:	fffff097          	auipc	ra,0xfffff
    80201848:	118080e7          	jalr	280(ra) # 8020095c <curr_proc>
	p->priority = prio;
    8020184c:	12953c23          	sd	s1,312(a0)
	p->pass = 65536 / prio;
    80201850:	67c1                	lui	a5,0x10
    80201852:	0297c7b3          	div	a5,a5,s1
    80201856:	14f53423          	sd	a5,328(a0)
	return prio;
    8020185a:	8526                	mv	a0,s1
}
    8020185c:	60e2                	ld	ra,24(sp)
    8020185e:	6442                	ld	s0,16(sp)
    80201860:	64a2                	ld	s1,8(sp)
    80201862:	6105                	addi	sp,sp,32
    80201864:	8082                	ret
	if (prio < 2) { return -1; }
    80201866:	557d                	li	a0,-1
}
    80201868:	8082                	ret

000000008020186a <syscall>:


extern char trap_page[];

void syscall()
{
    8020186a:	715d                	addi	sp,sp,-80
    8020186c:	e486                	sd	ra,72(sp)
    8020186e:	e0a2                	sd	s0,64(sp)
    80201870:	fc26                	sd	s1,56(sp)
    80201872:	f84a                	sd	s2,48(sp)
    80201874:	f44e                	sd	s3,40(sp)
    80201876:	f052                	sd	s4,32(sp)
    80201878:	ec56                	sd	s5,24(sp)
    8020187a:	e85a                	sd	s6,16(sp)
    8020187c:	e45e                	sd	s7,8(sp)
    8020187e:	e062                	sd	s8,0(sp)
    80201880:	0880                	addi	s0,sp,80
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201882:	fffff097          	auipc	ra,0xfffff
    80201886:	0da080e7          	jalr	218(ra) # 8020095c <curr_proc>
    8020188a:	02053903          	ld	s2,32(a0)
	int id = trapframe->a7, ret;
    8020188e:	0a893983          	ld	s3,168(s2)
    80201892:	0009849b          	sext.w	s1,s3
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80201896:	07093a03          	ld	s4,112(s2)
    8020189a:	07893a83          	ld	s5,120(s2)
    8020189e:	08093b03          	ld	s6,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    802018a2:	08893b83          	ld	s7,136(s2)
    802018a6:	09093c03          	ld	s8,144(s2)
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    802018aa:	09893883          	ld	a7,152(s2)
    802018ae:	8862                	mv	a6,s8
    802018b0:	87de                	mv	a5,s7
    802018b2:	875a                	mv	a4,s6
    802018b4:	86d6                	mv	a3,s5
    802018b6:	8652                	mv	a2,s4
    802018b8:	85a6                	mv	a1,s1
    802018ba:	4501                	li	a0,0
    802018bc:	00000097          	auipc	ra,0x0
    802018c0:	a40080e7          	jalr	-1472(ra) # 802012fc <dummy>
	       args[1], args[2], args[3], args[4], args[5]);

	if (id > 0 && id < MAX_SYSCALL_NUM) {
    802018c4:	39fd                	addiw	s3,s3,-1
    802018c6:	1f200793          	li	a5,498
    802018ca:	0537f063          	bgeu	a5,s3,8020190a <syscall+0xa0>
		curr_proc()->info->syscall_times[id]++;
	}

	switch (id) {
    802018ce:	0de00793          	li	a5,222
    802018d2:	0c97c363          	blt	a5,s1,80201998 <syscall+0x12e>
    802018d6:	0a800793          	li	a5,168
    802018da:	0897cb63          	blt	a5,s1,80201970 <syscall+0x106>
    802018de:	05d00793          	li	a5,93
    802018e2:	10f48363          	beq	s1,a5,802019e8 <syscall+0x17e>
    802018e6:	0297df63          	bge	a5,s1,80201924 <syscall+0xba>
    802018ea:	07c00793          	li	a5,124
    802018ee:	10f48363          	beq	s1,a5,802019f4 <syscall+0x18a>
    802018f2:	08c00793          	li	a5,140
    802018f6:	18f49c63          	bne	s1,a5,80201a8e <syscall+0x224>
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
    802018fa:	8552                	mv	a0,s4
    802018fc:	00000097          	auipc	ra,0x0
    80201900:	f36080e7          	jalr	-202(ra) # 80201832 <sys_set_priority>
    80201904:	0005059b          	sext.w	a1,a0
		break;
    80201908:	a089                	j	8020194a <syscall+0xe0>
		curr_proc()->info->syscall_times[id]++;
    8020190a:	fffff097          	auipc	ra,0xfffff
    8020190e:	052080e7          	jalr	82(ra) # 8020095c <curr_proc>
    80201912:	00249793          	slli	a5,s1,0x2
    80201916:	13053703          	ld	a4,304(a0)
    8020191a:	97ba                	add	a5,a5,a4
    8020191c:	43d8                	lw	a4,4(a5)
    8020191e:	2705                	addiw	a4,a4,1
    80201920:	c3d8                	sw	a4,4(a5)
    80201922:	b775                	j	802018ce <syscall+0x64>
	switch (id) {
    80201924:	03f00793          	li	a5,63
    80201928:	0af48563          	beq	s1,a5,802019d2 <syscall+0x168>
    8020192c:	04000793          	li	a5,64
    80201930:	14f49f63          	bne	s1,a5,80201a8e <syscall+0x224>
		ret = sys_write(args[0], args[1], args[2]);
    80201934:	000b061b          	sext.w	a2,s6
    80201938:	85d6                	mv	a1,s5
    8020193a:	000a051b          	sext.w	a0,s4
    8020193e:	00000097          	auipc	ra,0x0
    80201942:	9dc080e7          	jalr	-1572(ra) # 8020131a <sys_write>
    80201946:	0005059b          	sext.w	a1,a0
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
    8020194a:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    8020194e:	4501                	li	a0,0
    80201950:	00000097          	auipc	ra,0x0
    80201954:	9ac080e7          	jalr	-1620(ra) # 802012fc <dummy>
}
    80201958:	60a6                	ld	ra,72(sp)
    8020195a:	6406                	ld	s0,64(sp)
    8020195c:	74e2                	ld	s1,56(sp)
    8020195e:	7942                	ld	s2,48(sp)
    80201960:	79a2                	ld	s3,40(sp)
    80201962:	7a02                	ld	s4,32(sp)
    80201964:	6ae2                	ld	s5,24(sp)
    80201966:	6b42                	ld	s6,16(sp)
    80201968:	6ba2                	ld	s7,8(sp)
    8020196a:	6c02                	ld	s8,0(sp)
    8020196c:	6161                	addi	sp,sp,80
    8020196e:	8082                	ret
    80201970:	f574879b          	addiw	a5,s1,-169
    80201974:	0007869b          	sext.w	a3,a5
    80201978:	03500713          	li	a4,53
    8020197c:	10d76963          	bltu	a4,a3,80201a8e <syscall+0x224>
    80201980:	02079713          	slli	a4,a5,0x20
    80201984:	01e75793          	srli	a5,a4,0x1e
    80201988:	00003717          	auipc	a4,0x3
    8020198c:	8c470713          	addi	a4,a4,-1852 # 8020424c <digits+0x11c>
    80201990:	97ba                	add	a5,a5,a4
    80201992:	439c                	lw	a5,0(a5)
    80201994:	97ba                	add	a5,a5,a4
    80201996:	8782                	jr	a5
	switch (id) {
    80201998:	19000793          	li	a5,400
    8020199c:	0af48963          	beq	s1,a5,80201a4e <syscall+0x1e4>
    802019a0:	19a00793          	li	a5,410
    802019a4:	00f49963          	bne	s1,a5,802019b6 <syscall+0x14c>
		ret = sys_task_info(args[0]);
    802019a8:	8552                	mv	a0,s4
    802019aa:	00000097          	auipc	ra,0x0
    802019ae:	ce4080e7          	jalr	-796(ra) # 8020168e <sys_task_info>
    802019b2:	85aa                	mv	a1,a0
		break;
    802019b4:	bf59                	j	8020194a <syscall+0xe0>
	switch (id) {
    802019b6:	10400793          	li	a5,260
    802019ba:	0cf49a63          	bne	s1,a5,80201a8e <syscall+0x224>
		ret = sys_wait(args[0], args[1]);
    802019be:	85d6                	mv	a1,s5
    802019c0:	000a051b          	sext.w	a0,s4
    802019c4:	00000097          	auipc	ra,0x0
    802019c8:	dba080e7          	jalr	-582(ra) # 8020177e <sys_wait>
    802019cc:	0005059b          	sext.w	a1,a0
		break;
    802019d0:	bfad                	j	8020194a <syscall+0xe0>
		ret = sys_read(args[0], args[1], args[2]);
    802019d2:	865a                	mv	a2,s6
    802019d4:	85d6                	mv	a1,s5
    802019d6:	000a051b          	sext.w	a0,s4
    802019da:	00000097          	auipc	ra,0x0
    802019de:	9e0080e7          	jalr	-1568(ra) # 802013ba <sys_read>
    802019e2:	0005059b          	sext.w	a1,a0
		break;
    802019e6:	b795                	j	8020194a <syscall+0xe0>
	exit(code);
    802019e8:	000a051b          	sext.w	a0,s4
    802019ec:	fffff097          	auipc	ra,0xfffff
    802019f0:	5a0080e7          	jalr	1440(ra) # 80200f8c <exit>
	yield();
    802019f4:	fffff097          	auipc	ra,0xfffff
    802019f8:	30a080e7          	jalr	778(ra) # 80200cfe <yield>
		ret = sys_sched_yield();
    802019fc:	4581                	li	a1,0
		break;
    802019fe:	b7b1                	j	8020194a <syscall+0xe0>
		ret = sys_gettimeofday(args[0], args[1]);
    80201a00:	000a859b          	sext.w	a1,s5
    80201a04:	8552                	mv	a0,s4
    80201a06:	00000097          	auipc	ra,0x0
    80201a0a:	a5a080e7          	jalr	-1446(ra) # 80201460 <sys_gettimeofday>
    80201a0e:	0005059b          	sext.w	a1,a0
		break;
    80201a12:	bf25                	j	8020194a <syscall+0xe0>
		ret = sys_getpid();
    80201a14:	00000097          	auipc	ra,0x0
    80201a18:	c40080e7          	jalr	-960(ra) # 80201654 <sys_getpid>
    80201a1c:	0005059b          	sext.w	a1,a0
		break;
    80201a20:	b72d                	j	8020194a <syscall+0xe0>
		ret = sys_getppid();
    80201a22:	00000097          	auipc	ra,0x0
    80201a26:	c4c080e7          	jalr	-948(ra) # 8020166e <sys_getppid>
    80201a2a:	0005059b          	sext.w	a1,a0
		break;
    80201a2e:	bf31                	j	8020194a <syscall+0xe0>
		ret = sys_clone();
    80201a30:	00000097          	auipc	ra,0x0
    80201a34:	ce0080e7          	jalr	-800(ra) # 80201710 <sys_clone>
    80201a38:	0005059b          	sext.w	a1,a0
		break;
    80201a3c:	b739                	j	8020194a <syscall+0xe0>
		ret = sys_exec(args[0]);
    80201a3e:	8552                	mv	a0,s4
    80201a40:	00000097          	auipc	ra,0x0
    80201a44:	cf2080e7          	jalr	-782(ra) # 80201732 <sys_exec>
    80201a48:	0005059b          	sext.w	a1,a0
		break;
    80201a4c:	bdfd                	j	8020194a <syscall+0xe0>
		ret = sys_spawn(args[0]);
    80201a4e:	8552                	mv	a0,s4
    80201a50:	00000097          	auipc	ra,0x0
    80201a54:	d6a080e7          	jalr	-662(ra) # 802017ba <sys_spawn>
    80201a58:	0005059b          	sext.w	a1,a0
		break;
    80201a5c:	b5fd                	j	8020194a <syscall+0xe0>
		ret = sys_mmap(args[0], args[1], (int)args[2], (int)args[3], (int)args[4]);
    80201a5e:	000c071b          	sext.w	a4,s8
    80201a62:	000b869b          	sext.w	a3,s7
    80201a66:	000b061b          	sext.w	a2,s6
    80201a6a:	85d6                	mv	a1,s5
    80201a6c:	8552                	mv	a0,s4
    80201a6e:	00000097          	auipc	ra,0x0
    80201a72:	a52080e7          	jalr	-1454(ra) # 802014c0 <sys_mmap>
    80201a76:	0005059b          	sext.w	a1,a0
		break;
    80201a7a:	bdc1                	j	8020194a <syscall+0xe0>
		ret = sys_munmap(args[0], args[1]);
    80201a7c:	85d6                	mv	a1,s5
    80201a7e:	8552                	mv	a0,s4
    80201a80:	00000097          	auipc	ra,0x0
    80201a84:	b48080e7          	jalr	-1208(ra) # 802015c8 <sys_munmap>
    80201a88:	0005059b          	sext.w	a1,a0
		break;
    80201a8c:	bd7d                	j	8020194a <syscall+0xe0>
		errorf("unknown syscall %d", id);
    80201a8e:	fffff097          	auipc	ra,0xfffff
    80201a92:	eb8080e7          	jalr	-328(ra) # 80200946 <threadid>
    80201a96:	86aa                	mv	a3,a0
    80201a98:	8726                	mv	a4,s1
    80201a9a:	00002617          	auipc	a2,0x2
    80201a9e:	78660613          	addi	a2,a2,1926 # 80204220 <digits+0xf0>
    80201aa2:	45fd                	li	a1,31
    80201aa4:	00002517          	auipc	a0,0x2
    80201aa8:	78450513          	addi	a0,a0,1924 # 80204228 <digits+0xf8>
    80201aac:	fffff097          	auipc	ra,0xfffff
    80201ab0:	cc4080e7          	jalr	-828(ra) # 80200770 <printf>
		ret = -1;
    80201ab4:	55fd                	li	a1,-1
    80201ab6:	bd51                	j	8020194a <syscall+0xe0>

0000000080201ab8 <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    80201ab8:	1141                	addi	sp,sp,-16
    80201aba:	e422                	sd	s0,8(sp)
    80201abc:	0800                	addi	s0,sp,16

// machine-mode cycle counter
static inline uint64 r_time()
{
	uint64 x;
	asm volatile("csrr %0, time" : "=r"(x));
    80201abe:	c0102573          	rdtime	a0
	return r_time();
}
    80201ac2:	6422                	ld	s0,8(sp)
    80201ac4:	0141                	addi	sp,sp,16
    80201ac6:	8082                	ret

0000000080201ac8 <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    80201ac8:	1141                	addi	sp,sp,-16
    80201aca:	e406                	sd	ra,8(sp)
    80201acc:	e022                	sd	s0,0(sp)
    80201ace:	0800                	addi	s0,sp,16
    80201ad0:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80201ad4:	67fd                	lui	a5,0x1f
    80201ad6:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    80201ada:	953e                	add	a0,a0,a5
    80201adc:	fffff097          	auipc	ra,0xfffff
    80201ae0:	65c080e7          	jalr	1628(ra) # 80201138 <set_timer>
    80201ae4:	60a2                	ld	ra,8(sp)
    80201ae6:	6402                	ld	s0,0(sp)
    80201ae8:	0141                	addi	sp,sp,16
    80201aea:	8082                	ret

0000000080201aec <timer_init>:
{
    80201aec:	1141                	addi	sp,sp,-16
    80201aee:	e406                	sd	ra,8(sp)
    80201af0:	e022                	sd	s0,0(sp)
    80201af2:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80201af4:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    80201af8:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80201afc:	10479073          	csrw	sie,a5
	set_next_timer();
    80201b00:	00000097          	auipc	ra,0x0
    80201b04:	fc8080e7          	jalr	-56(ra) # 80201ac8 <set_next_timer>
}
    80201b08:	60a2                	ld	ra,8(sp)
    80201b0a:	6402                	ld	s0,0(sp)
    80201b0c:	0141                	addi	sp,sp,16
    80201b0e:	8082                	ret

0000000080201b10 <kerneltrap>:

extern char trampoline[], uservec[];
extern char userret[];

void kerneltrap()
{
    80201b10:	1141                	addi	sp,sp,-16
    80201b12:	e406                	sd	ra,8(sp)
    80201b14:	e022                	sd	s0,0(sp)
    80201b16:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201b18:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    80201b1c:	1007f793          	andi	a5,a5,256
    80201b20:	c3a1                	beqz	a5,80201b60 <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kerne");
    80201b22:	fffff097          	auipc	ra,0xfffff
    80201b26:	e24080e7          	jalr	-476(ra) # 80200946 <threadid>
    80201b2a:	86aa                	mv	a3,a0
    80201b2c:	47b9                	li	a5,14
    80201b2e:	00002717          	auipc	a4,0x2
    80201b32:	7fa70713          	addi	a4,a4,2042 # 80204328 <digits+0x1f8>
    80201b36:	00002617          	auipc	a2,0x2
    80201b3a:	4da60613          	addi	a2,a2,1242 # 80204010 <e_text+0x10>
    80201b3e:	45fd                	li	a1,31
    80201b40:	00003517          	auipc	a0,0x3
    80201b44:	83850513          	addi	a0,a0,-1992 # 80204378 <digits+0x248>
    80201b48:	fffff097          	auipc	ra,0xfffff
    80201b4c:	c28080e7          	jalr	-984(ra) # 80200770 <printf>
    80201b50:	fffff097          	auipc	ra,0xfffff
    80201b54:	5d0080e7          	jalr	1488(ra) # 80201120 <shutdown>
}
    80201b58:	60a2                	ld	ra,8(sp)
    80201b5a:	6402                	ld	s0,0(sp)
    80201b5c:	0141                	addi	sp,sp,16
    80201b5e:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80201b60:	fffff097          	auipc	ra,0xfffff
    80201b64:	de6080e7          	jalr	-538(ra) # 80200946 <threadid>
    80201b68:	86aa                	mv	a3,a0
    80201b6a:	47b5                	li	a5,13
    80201b6c:	00002717          	auipc	a4,0x2
    80201b70:	7bc70713          	addi	a4,a4,1980 # 80204328 <digits+0x1f8>
    80201b74:	00002617          	auipc	a2,0x2
    80201b78:	49c60613          	addi	a2,a2,1180 # 80204010 <e_text+0x10>
    80201b7c:	45fd                	li	a1,31
    80201b7e:	00002517          	auipc	a0,0x2
    80201b82:	7ba50513          	addi	a0,a0,1978 # 80204338 <digits+0x208>
    80201b86:	fffff097          	auipc	ra,0xfffff
    80201b8a:	bea080e7          	jalr	-1046(ra) # 80200770 <printf>
    80201b8e:	fffff097          	auipc	ra,0xfffff
    80201b92:	592080e7          	jalr	1426(ra) # 80201120 <shutdown>
    80201b96:	b771                	j	80201b22 <kerneltrap+0x12>

0000000080201b98 <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void set_usertrap()
{
    80201b98:	1141                	addi	sp,sp,-16
    80201b9a:	e422                	sd	s0,8(sp)
    80201b9c:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201b9e:	04000737          	lui	a4,0x4000
    80201ba2:	00001797          	auipc	a5,0x1
    80201ba6:	45e78793          	addi	a5,a5,1118 # 80203000 <trampoline>
    80201baa:	00001697          	auipc	a3,0x1
    80201bae:	45668693          	addi	a3,a3,1110 # 80203000 <trampoline>
    80201bb2:	8f95                	sub	a5,a5,a3
    80201bb4:	177d                	addi	a4,a4,-1
    80201bb6:	0732                	slli	a4,a4,0xc
    80201bb8:	97ba                	add	a5,a5,a4
    80201bba:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201bbc:	10579073          	csrw	stvec,a5
}
    80201bc0:	6422                	ld	s0,8(sp)
    80201bc2:	0141                	addi	sp,sp,16
    80201bc4:	8082                	ret

0000000080201bc6 <set_kerneltrap>:

void set_kerneltrap()
{
    80201bc6:	1141                	addi	sp,sp,-16
    80201bc8:	e422                	sd	s0,8(sp)
    80201bca:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201bcc:	00000797          	auipc	a5,0x0
    80201bd0:	f4478793          	addi	a5,a5,-188 # 80201b10 <kerneltrap>
    80201bd4:	9bf1                	andi	a5,a5,-4
    80201bd6:	10579073          	csrw	stvec,a5
}
    80201bda:	6422                	ld	s0,8(sp)
    80201bdc:	0141                	addi	sp,sp,16
    80201bde:	8082                	ret

0000000080201be0 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init()
{
    80201be0:	1141                	addi	sp,sp,-16
    80201be2:	e422                	sd	s0,8(sp)
    80201be4:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201be6:	00000797          	auipc	a5,0x0
    80201bea:	f2a78793          	addi	a5,a5,-214 # 80201b10 <kerneltrap>
    80201bee:	9bf1                	andi	a5,a5,-4
    80201bf0:	10579073          	csrw	stvec,a5
	// intr_on();
	set_kerneltrap();
}
    80201bf4:	6422                	ld	s0,8(sp)
    80201bf6:	0141                	addi	sp,sp,16
    80201bf8:	8082                	ret

0000000080201bfa <unknown_trap>:

void unknown_trap()
{
    80201bfa:	1141                	addi	sp,sp,-16
    80201bfc:	e406                	sd	ra,8(sp)
    80201bfe:	e022                	sd	s0,0(sp)
    80201c00:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    80201c02:	fffff097          	auipc	ra,0xfffff
    80201c06:	d44080e7          	jalr	-700(ra) # 80200946 <threadid>
    80201c0a:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80201c0c:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80201c10:	143027f3          	csrr	a5,stval
    80201c14:	00002617          	auipc	a2,0x2
    80201c18:	60c60613          	addi	a2,a2,1548 # 80204220 <digits+0xf0>
    80201c1c:	45fd                	li	a1,31
    80201c1e:	00002517          	auipc	a0,0x2
    80201c22:	78a50513          	addi	a0,a0,1930 # 802043a8 <digits+0x278>
    80201c26:	fffff097          	auipc	ra,0xfffff
    80201c2a:	b4a080e7          	jalr	-1206(ra) # 80200770 <printf>
	exit(-1);
    80201c2e:	557d                	li	a0,-1
    80201c30:	fffff097          	auipc	ra,0xfffff
    80201c34:	35c080e7          	jalr	860(ra) # 80200f8c <exit>
}
    80201c38:	60a2                	ld	ra,8(sp)
    80201c3a:	6402                	ld	s0,0(sp)
    80201c3c:	0141                	addi	sp,sp,16
    80201c3e:	8082                	ret

0000000080201c40 <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    80201c40:	7179                	addi	sp,sp,-48
    80201c42:	f406                	sd	ra,40(sp)
    80201c44:	f022                	sd	s0,32(sp)
    80201c46:	ec26                	sd	s1,24(sp)
    80201c48:	e84a                	sd	s2,16(sp)
    80201c4a:	e44e                	sd	s3,8(sp)
    80201c4c:	e052                	sd	s4,0(sp)
    80201c4e:	1800                	addi	s0,sp,48
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201c50:	00001a17          	auipc	s4,0x1
    80201c54:	3b0a0a13          	addi	s4,s4,944 # 80203000 <trampoline>
    80201c58:	00001797          	auipc	a5,0x1
    80201c5c:	3a878793          	addi	a5,a5,936 # 80203000 <trampoline>
    80201c60:	414787b3          	sub	a5,a5,s4
    80201c64:	040004b7          	lui	s1,0x4000
    80201c68:	14fd                	addi	s1,s1,-1
    80201c6a:	04b2                	slli	s1,s1,0xc
    80201c6c:	97a6                	add	a5,a5,s1
    80201c6e:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201c70:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201c74:	fffff097          	auipc	ra,0xfffff
    80201c78:	ce8080e7          	jalr	-792(ra) # 8020095c <curr_proc>
    80201c7c:	02053903          	ld	s2,32(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    80201c80:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80201c84:	00f93023          	sd	a5,0(s2)
	trapframe->kernel_sp =
		curr_proc()->kstack + KSTACK_SIZE; // process's kernel stack
    80201c88:	fffff097          	auipc	ra,0xfffff
    80201c8c:	cd4080e7          	jalr	-812(ra) # 8020095c <curr_proc>
    80201c90:	6d1c                	ld	a5,24(a0)
    80201c92:	6705                	lui	a4,0x1
    80201c94:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80201c96:	00f93423          	sd	a5,8(s2)
	trapframe->kernel_trap = (uint64)usertrap;
    80201c9a:	00000797          	auipc	a5,0x0
    80201c9e:	07a78793          	addi	a5,a5,122 # 80201d14 <usertrap>
    80201ca2:	00f93823          	sd	a5,16(s2)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80201ca6:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    80201ca8:	02f93023          	sd	a5,32(s2)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80201cac:	01893783          	ld	a5,24(s2)
    80201cb0:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201cb4:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80201cb8:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80201cbc:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80201cc0:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80201cc4:	fffff097          	auipc	ra,0xfffff
    80201cc8:	c98080e7          	jalr	-872(ra) # 8020095c <curr_proc>
    80201ccc:	00853983          	ld	s3,8(a0)
    80201cd0:	00c9d993          	srli	s3,s3,0xc
    80201cd4:	57fd                	li	a5,-1
    80201cd6:	17fe                	slli	a5,a5,0x3f
    80201cd8:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	tracef("return to user @ %p", trapframe->epc);
    80201cdc:	01893583          	ld	a1,24(s2)
    80201ce0:	4501                	li	a0,0
    80201ce2:	fffff097          	auipc	ra,0xfffff
    80201ce6:	61a080e7          	jalr	1562(ra) # 802012fc <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    80201cea:	00001797          	auipc	a5,0x1
    80201cee:	3ae78793          	addi	a5,a5,942 # 80203098 <userret>
    80201cf2:	414787b3          	sub	a5,a5,s4
    80201cf6:	94be                	add	s1,s1,a5
	((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80201cf8:	85ce                	mv	a1,s3
    80201cfa:	02000537          	lui	a0,0x2000
    80201cfe:	157d                	addi	a0,a0,-1
    80201d00:	0536                	slli	a0,a0,0xd
    80201d02:	9482                	jalr	s1
    80201d04:	70a2                	ld	ra,40(sp)
    80201d06:	7402                	ld	s0,32(sp)
    80201d08:	64e2                	ld	s1,24(sp)
    80201d0a:	6942                	ld	s2,16(sp)
    80201d0c:	69a2                	ld	s3,8(sp)
    80201d0e:	6a02                	ld	s4,0(sp)
    80201d10:	6145                	addi	sp,sp,48
    80201d12:	8082                	ret

0000000080201d14 <usertrap>:
{
    80201d14:	1101                	addi	sp,sp,-32
    80201d16:	ec06                	sd	ra,24(sp)
    80201d18:	e822                	sd	s0,16(sp)
    80201d1a:	e426                	sd	s1,8(sp)
    80201d1c:	e04a                	sd	s2,0(sp)
    80201d1e:	1000                	addi	s0,sp,32
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201d20:	00000797          	auipc	a5,0x0
    80201d24:	df078793          	addi	a5,a5,-528 # 80201b10 <kerneltrap>
    80201d28:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201d2a:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201d2e:	fffff097          	auipc	ra,0xfffff
    80201d32:	c2e080e7          	jalr	-978(ra) # 8020095c <curr_proc>
    80201d36:	02053903          	ld	s2,32(a0) # 2000020 <_entry-0x7e1fffe0>
	tracef("trap from user epc = %p", trapframe->epc);
    80201d3a:	01893583          	ld	a1,24(s2)
    80201d3e:	4501                	li	a0,0
    80201d40:	fffff097          	auipc	ra,0xfffff
    80201d44:	5bc080e7          	jalr	1468(ra) # 802012fc <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201d48:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80201d4c:	1007f793          	andi	a5,a5,256
    80201d50:	e395                	bnez	a5,80201d74 <usertrap+0x60>
	asm volatile("csrr %0, scause" : "=r"(x));
    80201d52:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    80201d56:	0404cc63          	bltz	s1,80201dae <usertrap+0x9a>
		switch (cause) {
    80201d5a:	47bd                	li	a5,15
    80201d5c:	1097e963          	bltu	a5,s1,80201e6e <usertrap+0x15a>
    80201d60:	00249713          	slli	a4,s1,0x2
    80201d64:	00002697          	auipc	a3,0x2
    80201d68:	74868693          	addi	a3,a3,1864 # 802044ac <digits+0x37c>
    80201d6c:	9736                	add	a4,a4,a3
    80201d6e:	431c                	lw	a5,0(a4)
    80201d70:	97b6                	add	a5,a5,a3
    80201d72:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80201d74:	fffff097          	auipc	ra,0xfffff
    80201d78:	bd2080e7          	jalr	-1070(ra) # 80200946 <threadid>
    80201d7c:	86aa                	mv	a3,a0
    80201d7e:	03300793          	li	a5,51
    80201d82:	00002717          	auipc	a4,0x2
    80201d86:	5a670713          	addi	a4,a4,1446 # 80204328 <digits+0x1f8>
    80201d8a:	00002617          	auipc	a2,0x2
    80201d8e:	28660613          	addi	a2,a2,646 # 80204010 <e_text+0x10>
    80201d92:	45fd                	li	a1,31
    80201d94:	00002517          	auipc	a0,0x2
    80201d98:	64450513          	addi	a0,a0,1604 # 802043d8 <digits+0x2a8>
    80201d9c:	fffff097          	auipc	ra,0xfffff
    80201da0:	9d4080e7          	jalr	-1580(ra) # 80200770 <printf>
    80201da4:	fffff097          	auipc	ra,0xfffff
    80201da8:	37c080e7          	jalr	892(ra) # 80201120 <shutdown>
    80201dac:	b75d                	j	80201d52 <usertrap+0x3e>
		cause &= ~(1ULL << 63);
    80201dae:	0486                	slli	s1,s1,0x1
    80201db0:	8085                	srli	s1,s1,0x1
		switch (cause) {
    80201db2:	4795                	li	a5,5
    80201db4:	02f48063          	beq	s1,a5,80201dd4 <usertrap+0xc0>
			unknown_trap();
    80201db8:	00000097          	auipc	ra,0x0
    80201dbc:	e42080e7          	jalr	-446(ra) # 80201bfa <unknown_trap>
	usertrapret();
    80201dc0:	00000097          	auipc	ra,0x0
    80201dc4:	e80080e7          	jalr	-384(ra) # 80201c40 <usertrapret>
}
    80201dc8:	60e2                	ld	ra,24(sp)
    80201dca:	6442                	ld	s0,16(sp)
    80201dcc:	64a2                	ld	s1,8(sp)
    80201dce:	6902                	ld	s2,0(sp)
    80201dd0:	6105                	addi	sp,sp,32
    80201dd2:	8082                	ret
			tracef("time interrupt!");
    80201dd4:	4501                	li	a0,0
    80201dd6:	fffff097          	auipc	ra,0xfffff
    80201dda:	526080e7          	jalr	1318(ra) # 802012fc <dummy>
			set_next_timer();
    80201dde:	00000097          	auipc	ra,0x0
    80201de2:	cea080e7          	jalr	-790(ra) # 80201ac8 <set_next_timer>
			yield();
    80201de6:	fffff097          	auipc	ra,0xfffff
    80201dea:	f18080e7          	jalr	-232(ra) # 80200cfe <yield>
			break;
    80201dee:	bfc9                	j	80201dc0 <usertrap+0xac>
			trapframe->epc += 4;
    80201df0:	01893783          	ld	a5,24(s2)
    80201df4:	0791                	addi	a5,a5,4
    80201df6:	00f93c23          	sd	a5,24(s2)
			syscall();
    80201dfa:	00000097          	auipc	ra,0x0
    80201dfe:	a70080e7          	jalr	-1424(ra) # 8020186a <syscall>
			break;
    80201e02:	bf7d                	j	80201dc0 <usertrap+0xac>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    80201e04:	fffff097          	auipc	ra,0xfffff
    80201e08:	b42080e7          	jalr	-1214(ra) # 80200946 <threadid>
    80201e0c:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80201e0e:	143027f3          	csrr	a5,stval
    80201e12:	01893803          	ld	a6,24(s2)
    80201e16:	8726                	mv	a4,s1
    80201e18:	00002617          	auipc	a2,0x2
    80201e1c:	40860613          	addi	a2,a2,1032 # 80204220 <digits+0xf0>
    80201e20:	45fd                	li	a1,31
    80201e22:	00002517          	auipc	a0,0x2
    80201e26:	5ee50513          	addi	a0,a0,1518 # 80204410 <digits+0x2e0>
    80201e2a:	fffff097          	auipc	ra,0xfffff
    80201e2e:	946080e7          	jalr	-1722(ra) # 80200770 <printf>
			exit(-2);
    80201e32:	5579                	li	a0,-2
    80201e34:	fffff097          	auipc	ra,0xfffff
    80201e38:	158080e7          	jalr	344(ra) # 80200f8c <exit>
			break;
    80201e3c:	b751                	j	80201dc0 <usertrap+0xac>
			errorf("IllegalInstruction in application, core dumped.");
    80201e3e:	fffff097          	auipc	ra,0xfffff
    80201e42:	b08080e7          	jalr	-1272(ra) # 80200946 <threadid>
    80201e46:	86aa                	mv	a3,a0
    80201e48:	00002617          	auipc	a2,0x2
    80201e4c:	3d860613          	addi	a2,a2,984 # 80204220 <digits+0xf0>
    80201e50:	45fd                	li	a1,31
    80201e52:	00002517          	auipc	a0,0x2
    80201e56:	61650513          	addi	a0,a0,1558 # 80204468 <digits+0x338>
    80201e5a:	fffff097          	auipc	ra,0xfffff
    80201e5e:	916080e7          	jalr	-1770(ra) # 80200770 <printf>
			exit(-3);
    80201e62:	5575                	li	a0,-3
    80201e64:	fffff097          	auipc	ra,0xfffff
    80201e68:	128080e7          	jalr	296(ra) # 80200f8c <exit>
			break;
    80201e6c:	bf91                	j	80201dc0 <usertrap+0xac>
			unknown_trap();
    80201e6e:	00000097          	auipc	ra,0x0
    80201e72:	d8c080e7          	jalr	-628(ra) # 80201bfa <unknown_trap>
			break;
    80201e76:	b7a9                	j	80201dc0 <usertrap+0xac>

0000000080201e78 <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80201e78:	7139                	addi	sp,sp,-64
    80201e7a:	fc06                	sd	ra,56(sp)
    80201e7c:	f822                	sd	s0,48(sp)
    80201e7e:	f426                	sd	s1,40(sp)
    80201e80:	f04a                	sd	s2,32(sp)
    80201e82:	ec4e                	sd	s3,24(sp)
    80201e84:	e852                	sd	s4,16(sp)
    80201e86:	e456                	sd	s5,8(sp)
    80201e88:	e05a                	sd	s6,0(sp)
    80201e8a:	0080                	addi	s0,sp,64
    80201e8c:	84aa                	mv	s1,a0
    80201e8e:	89ae                	mv	s3,a1
    80201e90:	8ab2                	mv	s5,a2
	if (va >= MAXVA)
    80201e92:	57fd                	li	a5,-1
    80201e94:	83e9                	srli	a5,a5,0x1a
    80201e96:	00b7e563          	bltu	a5,a1,80201ea0 <walk+0x28>
{
    80201e9a:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    80201e9c:	4b31                	li	s6,12
    80201e9e:	a0b5                	j	80201f0a <walk+0x92>
		panic("walk");
    80201ea0:	fffff097          	auipc	ra,0xfffff
    80201ea4:	aa6080e7          	jalr	-1370(ra) # 80200946 <threadid>
    80201ea8:	86aa                	mv	a3,a0
    80201eaa:	03400793          	li	a5,52
    80201eae:	00002717          	auipc	a4,0x2
    80201eb2:	64270713          	addi	a4,a4,1602 # 802044f0 <digits+0x3c0>
    80201eb6:	00002617          	auipc	a2,0x2
    80201eba:	15a60613          	addi	a2,a2,346 # 80204010 <e_text+0x10>
    80201ebe:	45fd                	li	a1,31
    80201ec0:	00002517          	auipc	a0,0x2
    80201ec4:	63850513          	addi	a0,a0,1592 # 802044f8 <digits+0x3c8>
    80201ec8:	fffff097          	auipc	ra,0xfffff
    80201ecc:	8a8080e7          	jalr	-1880(ra) # 80200770 <printf>
    80201ed0:	fffff097          	auipc	ra,0xfffff
    80201ed4:	250080e7          	jalr	592(ra) # 80201120 <shutdown>
    80201ed8:	b7c9                	j	80201e9a <walk+0x22>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80201eda:	060a8663          	beqz	s5,80201f46 <walk+0xce>
    80201ede:	ffffe097          	auipc	ra,0xffffe
    80201ee2:	25c080e7          	jalr	604(ra) # 8020013a <kalloc>
    80201ee6:	84aa                	mv	s1,a0
    80201ee8:	c529                	beqz	a0,80201f32 <walk+0xba>
				return 0;
			memset(pagetable, 0, PGSIZE);
    80201eea:	6605                	lui	a2,0x1
    80201eec:	4581                	li	a1,0
    80201eee:	fffff097          	auipc	ra,0xfffff
    80201ef2:	260080e7          	jalr	608(ra) # 8020114e <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    80201ef6:	00c4d793          	srli	a5,s1,0xc
    80201efa:	07aa                	slli	a5,a5,0xa
    80201efc:	0017e793          	ori	a5,a5,1
    80201f00:	00f93023          	sd	a5,0(s2)
	for (int level = 2; level > 0; level--) {
    80201f04:	3a5d                	addiw	s4,s4,-9
    80201f06:	036a0063          	beq	s4,s6,80201f26 <walk+0xae>
		pte_t *pte = &pagetable[PX(level, va)];
    80201f0a:	0149d933          	srl	s2,s3,s4
    80201f0e:	1ff97913          	andi	s2,s2,511
    80201f12:	090e                	slli	s2,s2,0x3
    80201f14:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    80201f16:	00093483          	ld	s1,0(s2)
    80201f1a:	0014f793          	andi	a5,s1,1
    80201f1e:	dfd5                	beqz	a5,80201eda <walk+0x62>
			pagetable = (pagetable_t)PTE2PA(*pte);
    80201f20:	80a9                	srli	s1,s1,0xa
    80201f22:	04b2                	slli	s1,s1,0xc
    80201f24:	b7c5                	j	80201f04 <walk+0x8c>
		}
	}
	return &pagetable[PX(0, va)];
    80201f26:	00c9d513          	srli	a0,s3,0xc
    80201f2a:	1ff57513          	andi	a0,a0,511
    80201f2e:	050e                	slli	a0,a0,0x3
    80201f30:	9526                	add	a0,a0,s1
}
    80201f32:	70e2                	ld	ra,56(sp)
    80201f34:	7442                	ld	s0,48(sp)
    80201f36:	74a2                	ld	s1,40(sp)
    80201f38:	7902                	ld	s2,32(sp)
    80201f3a:	69e2                	ld	s3,24(sp)
    80201f3c:	6a42                	ld	s4,16(sp)
    80201f3e:	6aa2                	ld	s5,8(sp)
    80201f40:	6b02                	ld	s6,0(sp)
    80201f42:	6121                	addi	sp,sp,64
    80201f44:	8082                	ret
				return 0;
    80201f46:	4501                	li	a0,0
    80201f48:	b7ed                	j	80201f32 <walk+0xba>

0000000080201f4a <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    80201f4a:	57fd                	li	a5,-1
    80201f4c:	83e9                	srli	a5,a5,0x1a
    80201f4e:	00b7f463          	bgeu	a5,a1,80201f56 <walkaddr+0xc>
		return 0;
    80201f52:	4501                	li	a0,0
		return 0;
	if ((*pte & PTE_U) == 0)
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}
    80201f54:	8082                	ret
{
    80201f56:	1141                	addi	sp,sp,-16
    80201f58:	e406                	sd	ra,8(sp)
    80201f5a:	e022                	sd	s0,0(sp)
    80201f5c:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    80201f5e:	4601                	li	a2,0
    80201f60:	00000097          	auipc	ra,0x0
    80201f64:	f18080e7          	jalr	-232(ra) # 80201e78 <walk>
	if (pte == 0)
    80201f68:	c105                	beqz	a0,80201f88 <walkaddr+0x3e>
	if ((*pte & PTE_V) == 0)
    80201f6a:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    80201f6c:	0117f693          	andi	a3,a5,17
    80201f70:	4745                	li	a4,17
		return 0;
    80201f72:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    80201f74:	00e68663          	beq	a3,a4,80201f80 <walkaddr+0x36>
}
    80201f78:	60a2                	ld	ra,8(sp)
    80201f7a:	6402                	ld	s0,0(sp)
    80201f7c:	0141                	addi	sp,sp,16
    80201f7e:	8082                	ret
	pa = PTE2PA(*pte);
    80201f80:	00a7d513          	srli	a0,a5,0xa
    80201f84:	0532                	slli	a0,a0,0xc
	return pa;
    80201f86:	bfcd                	j	80201f78 <walkaddr+0x2e>
		return 0;
    80201f88:	4501                	li	a0,0
    80201f8a:	b7fd                	j	80201f78 <walkaddr+0x2e>

0000000080201f8c <useraddr>:

// Look up a virtual address, return the physical address,
uint64 useraddr(pagetable_t pagetable, uint64 va)
{
    80201f8c:	1101                	addi	sp,sp,-32
    80201f8e:	ec06                	sd	ra,24(sp)
    80201f90:	e822                	sd	s0,16(sp)
    80201f92:	e426                	sd	s1,8(sp)
    80201f94:	1000                	addi	s0,sp,32
    80201f96:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    80201f98:	00000097          	auipc	ra,0x0
    80201f9c:	fb2080e7          	jalr	-78(ra) # 80201f4a <walkaddr>
	if (page == 0)
    80201fa0:	c509                	beqz	a0,80201faa <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    80201fa2:	03449593          	slli	a1,s1,0x34
    80201fa6:	91d1                	srli	a1,a1,0x34
    80201fa8:	8d4d                	or	a0,a0,a1
}
    80201faa:	60e2                	ld	ra,24(sp)
    80201fac:	6442                	ld	s0,16(sp)
    80201fae:	64a2                	ld	s1,8(sp)
    80201fb0:	6105                	addi	sp,sp,32
    80201fb2:	8082                	ret

0000000080201fb4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80201fb4:	715d                	addi	sp,sp,-80
    80201fb6:	e486                	sd	ra,72(sp)
    80201fb8:	e0a2                	sd	s0,64(sp)
    80201fba:	fc26                	sd	s1,56(sp)
    80201fbc:	f84a                	sd	s2,48(sp)
    80201fbe:	f44e                	sd	s3,40(sp)
    80201fc0:	f052                	sd	s4,32(sp)
    80201fc2:	ec56                	sd	s5,24(sp)
    80201fc4:	e85a                	sd	s6,16(sp)
    80201fc6:	e45e                	sd	s7,8(sp)
    80201fc8:	0880                	addi	s0,sp,80
    80201fca:	8aaa                	mv	s5,a0
    80201fcc:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    80201fce:	777d                	lui	a4,0xfffff
    80201fd0:	00e5f7b3          	and	a5,a1,a4
	last = PGROUNDDOWN(va + size - 1);
    80201fd4:	167d                	addi	a2,a2,-1
    80201fd6:	00b609b3          	add	s3,a2,a1
    80201fda:	00e9f9b3          	and	s3,s3,a4
	a = PGROUNDDOWN(va);
    80201fde:	893e                	mv	s2,a5
    80201fe0:	40f68a33          	sub	s4,a3,a5
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    80201fe4:	6b85                	lui	s7,0x1
    80201fe6:	a0ad                	j	80202050 <mappages+0x9c>
			errorf("pte invalid, va = %p", a);
    80201fe8:	fffff097          	auipc	ra,0xfffff
    80201fec:	95e080e7          	jalr	-1698(ra) # 80200946 <threadid>
    80201ff0:	86aa                	mv	a3,a0
    80201ff2:	874a                	mv	a4,s2
    80201ff4:	00002617          	auipc	a2,0x2
    80201ff8:	22c60613          	addi	a2,a2,556 # 80204220 <digits+0xf0>
    80201ffc:	45fd                	li	a1,31
    80201ffe:	00002517          	auipc	a0,0x2
    80202002:	51a50513          	addi	a0,a0,1306 # 80204518 <digits+0x3e8>
    80202006:	ffffe097          	auipc	ra,0xffffe
    8020200a:	76a080e7          	jalr	1898(ra) # 80200770 <printf>
			return -1;
    8020200e:	557d                	li	a0,-1
		pa += PGSIZE;
	}
	return 0;
}
    80202010:	60a6                	ld	ra,72(sp)
    80202012:	6406                	ld	s0,64(sp)
    80202014:	74e2                	ld	s1,56(sp)
    80202016:	7942                	ld	s2,48(sp)
    80202018:	79a2                	ld	s3,40(sp)
    8020201a:	7a02                	ld	s4,32(sp)
    8020201c:	6ae2                	ld	s5,24(sp)
    8020201e:	6b42                	ld	s6,16(sp)
    80202020:	6ba2                	ld	s7,8(sp)
    80202022:	6161                	addi	sp,sp,80
    80202024:	8082                	ret
			errorf("remap");
    80202026:	fffff097          	auipc	ra,0xfffff
    8020202a:	920080e7          	jalr	-1760(ra) # 80200946 <threadid>
    8020202e:	86aa                	mv	a3,a0
    80202030:	00002617          	auipc	a2,0x2
    80202034:	1f060613          	addi	a2,a2,496 # 80204220 <digits+0xf0>
    80202038:	45fd                	li	a1,31
    8020203a:	00002517          	auipc	a0,0x2
    8020203e:	50650513          	addi	a0,a0,1286 # 80204540 <digits+0x410>
    80202042:	ffffe097          	auipc	ra,0xffffe
    80202046:	72e080e7          	jalr	1838(ra) # 80200770 <printf>
			return -1;
    8020204a:	557d                	li	a0,-1
    8020204c:	b7d1                	j	80202010 <mappages+0x5c>
		a += PGSIZE;
    8020204e:	995e                	add	s2,s2,s7
	for (;;) {
    80202050:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0) {
    80202054:	4605                	li	a2,1
    80202056:	85ca                	mv	a1,s2
    80202058:	8556                	mv	a0,s5
    8020205a:	00000097          	auipc	ra,0x0
    8020205e:	e1e080e7          	jalr	-482(ra) # 80201e78 <walk>
    80202062:	d159                	beqz	a0,80201fe8 <mappages+0x34>
		if (*pte & PTE_V) {
    80202064:	611c                	ld	a5,0(a0)
    80202066:	8b85                	andi	a5,a5,1
    80202068:	ffdd                	bnez	a5,80202026 <mappages+0x72>
		*pte = PA2PTE(pa) | perm | PTE_V;
    8020206a:	80b1                	srli	s1,s1,0xc
    8020206c:	04aa                	slli	s1,s1,0xa
    8020206e:	0164e4b3          	or	s1,s1,s6
    80202072:	0014e493          	ori	s1,s1,1
    80202076:	e104                	sd	s1,0(a0)
		if (a == last)
    80202078:	fd391be3          	bne	s2,s3,8020204e <mappages+0x9a>
	return 0;
    8020207c:	4501                	li	a0,0
    8020207e:	bf49                	j	80202010 <mappages+0x5c>

0000000080202080 <kvmmap>:
{
    80202080:	1141                	addi	sp,sp,-16
    80202082:	e406                	sd	ra,8(sp)
    80202084:	e022                	sd	s0,0(sp)
    80202086:	0800                	addi	s0,sp,16
    80202088:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8020208a:	86b2                	mv	a3,a2
    8020208c:	863e                	mv	a2,a5
    8020208e:	00000097          	auipc	ra,0x0
    80202092:	f26080e7          	jalr	-218(ra) # 80201fb4 <mappages>
    80202096:	e509                	bnez	a0,802020a0 <kvmmap+0x20>
}
    80202098:	60a2                	ld	ra,8(sp)
    8020209a:	6402                	ld	s0,0(sp)
    8020209c:	0141                	addi	sp,sp,16
    8020209e:	8082                	ret
		panic("kvmmap");
    802020a0:	fffff097          	auipc	ra,0xfffff
    802020a4:	8a6080e7          	jalr	-1882(ra) # 80200946 <threadid>
    802020a8:	86aa                	mv	a3,a0
    802020aa:	06900793          	li	a5,105
    802020ae:	00002717          	auipc	a4,0x2
    802020b2:	44270713          	addi	a4,a4,1090 # 802044f0 <digits+0x3c0>
    802020b6:	00002617          	auipc	a2,0x2
    802020ba:	f5a60613          	addi	a2,a2,-166 # 80204010 <e_text+0x10>
    802020be:	45fd                	li	a1,31
    802020c0:	00002517          	auipc	a0,0x2
    802020c4:	49850513          	addi	a0,a0,1176 # 80204558 <digits+0x428>
    802020c8:	ffffe097          	auipc	ra,0xffffe
    802020cc:	6a8080e7          	jalr	1704(ra) # 80200770 <printf>
    802020d0:	fffff097          	auipc	ra,0xfffff
    802020d4:	050080e7          	jalr	80(ra) # 80201120 <shutdown>
}
    802020d8:	b7c1                	j	80202098 <kvmmap+0x18>

00000000802020da <kvmmake>:
{
    802020da:	1101                	addi	sp,sp,-32
    802020dc:	ec06                	sd	ra,24(sp)
    802020de:	e822                	sd	s0,16(sp)
    802020e0:	e426                	sd	s1,8(sp)
    802020e2:	e04a                	sd	s2,0(sp)
    802020e4:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    802020e6:	ffffe097          	auipc	ra,0xffffe
    802020ea:	054080e7          	jalr	84(ra) # 8020013a <kalloc>
    802020ee:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    802020f0:	6605                	lui	a2,0x1
    802020f2:	4581                	li	a1,0
    802020f4:	fffff097          	auipc	ra,0xfffff
    802020f8:	05a080e7          	jalr	90(ra) # 8020114e <memset>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    802020fc:	00002917          	auipc	s2,0x2
    80202100:	f0490913          	addi	s2,s2,-252 # 80204000 <e_text>
    80202104:	4729                	li	a4,10
    80202106:	bff00693          	li	a3,-1025
    8020210a:	06d6                	slli	a3,a3,0x15
    8020210c:	96ca                	add	a3,a3,s2
    8020210e:	40100613          	li	a2,1025
    80202112:	0656                	slli	a2,a2,0x15
    80202114:	85b2                	mv	a1,a2
    80202116:	8526                	mv	a0,s1
    80202118:	00000097          	auipc	ra,0x0
    8020211c:	f68080e7          	jalr	-152(ra) # 80202080 <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    80202120:	4719                	li	a4,6
    80202122:	46c5                	li	a3,17
    80202124:	06ee                	slli	a3,a3,0x1b
    80202126:	412686b3          	sub	a3,a3,s2
    8020212a:	864a                	mv	a2,s2
    8020212c:	85ca                	mv	a1,s2
    8020212e:	8526                	mv	a0,s1
    80202130:	00000097          	auipc	ra,0x0
    80202134:	f50080e7          	jalr	-176(ra) # 80202080 <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80202138:	4729                	li	a4,10
    8020213a:	6685                	lui	a3,0x1
    8020213c:	00001617          	auipc	a2,0x1
    80202140:	ec460613          	addi	a2,a2,-316 # 80203000 <trampoline>
    80202144:	040005b7          	lui	a1,0x4000
    80202148:	15fd                	addi	a1,a1,-1
    8020214a:	05b2                	slli	a1,a1,0xc
    8020214c:	8526                	mv	a0,s1
    8020214e:	00000097          	auipc	ra,0x0
    80202152:	f32080e7          	jalr	-206(ra) # 80202080 <kvmmap>
}
    80202156:	8526                	mv	a0,s1
    80202158:	60e2                	ld	ra,24(sp)
    8020215a:	6442                	ld	s0,16(sp)
    8020215c:	64a2                	ld	s1,8(sp)
    8020215e:	6902                	ld	s2,0(sp)
    80202160:	6105                	addi	sp,sp,32
    80202162:	8082                	ret

0000000080202164 <kvm_init>:
{
    80202164:	1141                	addi	sp,sp,-16
    80202166:	e406                	sd	ra,8(sp)
    80202168:	e022                	sd	s0,0(sp)
    8020216a:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    8020216c:	00000097          	auipc	ra,0x0
    80202170:	f6e080e7          	jalr	-146(ra) # 802020da <kvmmake>
    80202174:	0058b797          	auipc	a5,0x58b
    80202178:	eaa7b623          	sd	a0,-340(a5) # 8078d020 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    8020217c:	8131                	srli	a0,a0,0xc
    8020217e:	57fd                	li	a5,-1
    80202180:	17fe                	slli	a5,a5,0x3f
    80202182:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    80202184:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    80202188:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    8020218c:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    80202190:	4501                	li	a0,0
    80202192:	fffff097          	auipc	ra,0xfffff
    80202196:	16a080e7          	jalr	362(ra) # 802012fc <dummy>
}
    8020219a:	60a2                	ld	ra,8(sp)
    8020219c:	6402                	ld	s0,0(sp)
    8020219e:	0141                	addi	sp,sp,16
    802021a0:	8082                	ret

00000000802021a2 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    802021a2:	711d                	addi	sp,sp,-96
    802021a4:	ec86                	sd	ra,88(sp)
    802021a6:	e8a2                	sd	s0,80(sp)
    802021a8:	e4a6                	sd	s1,72(sp)
    802021aa:	e0ca                	sd	s2,64(sp)
    802021ac:	fc4e                	sd	s3,56(sp)
    802021ae:	f852                	sd	s4,48(sp)
    802021b0:	f456                	sd	s5,40(sp)
    802021b2:	f05a                	sd	s6,32(sp)
    802021b4:	ec5e                	sd	s7,24(sp)
    802021b6:	e862                	sd	s8,16(sp)
    802021b8:	e466                	sd	s9,8(sp)
    802021ba:	e06a                	sd	s10,0(sp)
    802021bc:	1080                	addi	s0,sp,96
    802021be:	8a2a                	mv	s4,a0
    802021c0:	892e                	mv	s2,a1
    802021c2:	89b2                	mv	s3,a2
    802021c4:	8b36                	mv	s6,a3
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    802021c6:	03459793          	slli	a5,a1,0x34
    802021ca:	e785                	bnez	a5,802021f2 <uvmunmap+0x50>
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    802021cc:	09b2                	slli	s3,s3,0xc
    802021ce:	99ca                	add	s3,s3,s2
    802021d0:	0d397263          	bgeu	s2,s3,80202294 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    802021d4:	4b85                	li	s7,1
				panic("uvmunmap: not a leaf");
    802021d6:	00002d17          	auipc	s10,0x2
    802021da:	31ad0d13          	addi	s10,s10,794 # 802044f0 <digits+0x3c0>
    802021de:	00002c97          	auipc	s9,0x2
    802021e2:	e32c8c93          	addi	s9,s9,-462 # 80204010 <e_text+0x10>
    802021e6:	00002c17          	auipc	s8,0x2
    802021ea:	3c2c0c13          	addi	s8,s8,962 # 802045a8 <digits+0x478>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    802021ee:	6a85                	lui	s5,0x1
    802021f0:	a0bd                	j	8020225e <uvmunmap+0xbc>
		panic("uvmunmap: not aligned");
    802021f2:	ffffe097          	auipc	ra,0xffffe
    802021f6:	754080e7          	jalr	1876(ra) # 80200946 <threadid>
    802021fa:	86aa                	mv	a3,a0
    802021fc:	09200793          	li	a5,146
    80202200:	00002717          	auipc	a4,0x2
    80202204:	2f070713          	addi	a4,a4,752 # 802044f0 <digits+0x3c0>
    80202208:	00002617          	auipc	a2,0x2
    8020220c:	e0860613          	addi	a2,a2,-504 # 80204010 <e_text+0x10>
    80202210:	45fd                	li	a1,31
    80202212:	00002517          	auipc	a0,0x2
    80202216:	36650513          	addi	a0,a0,870 # 80204578 <digits+0x448>
    8020221a:	ffffe097          	auipc	ra,0xffffe
    8020221e:	556080e7          	jalr	1366(ra) # 80200770 <printf>
    80202222:	fffff097          	auipc	ra,0xfffff
    80202226:	efe080e7          	jalr	-258(ra) # 80201120 <shutdown>
    8020222a:	b74d                	j	802021cc <uvmunmap+0x2a>
				panic("uvmunmap: not a leaf");
    8020222c:	ffffe097          	auipc	ra,0xffffe
    80202230:	71a080e7          	jalr	1818(ra) # 80200946 <threadid>
    80202234:	86aa                	mv	a3,a0
    80202236:	09900793          	li	a5,153
    8020223a:	876a                	mv	a4,s10
    8020223c:	8666                	mv	a2,s9
    8020223e:	45fd                	li	a1,31
    80202240:	8562                	mv	a0,s8
    80202242:	ffffe097          	auipc	ra,0xffffe
    80202246:	52e080e7          	jalr	1326(ra) # 80200770 <printf>
    8020224a:	fffff097          	auipc	ra,0xfffff
    8020224e:	ed6080e7          	jalr	-298(ra) # 80201120 <shutdown>
    80202252:	a03d                	j	80202280 <uvmunmap+0xde>
			if (do_free) {
				uint64 pa = PTE2PA(*pte);
				kfree((void *)pa);
			}
		}
		*pte = 0;
    80202254:	0004b023          	sd	zero,0(s1) # 4000000 <_entry-0x7c200000>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202258:	9956                	add	s2,s2,s5
    8020225a:	03397d63          	bgeu	s2,s3,80202294 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
    8020225e:	4601                	li	a2,0
    80202260:	85ca                	mv	a1,s2
    80202262:	8552                	mv	a0,s4
    80202264:	00000097          	auipc	ra,0x0
    80202268:	c14080e7          	jalr	-1004(ra) # 80201e78 <walk>
    8020226c:	84aa                	mv	s1,a0
    8020226e:	d56d                	beqz	a0,80202258 <uvmunmap+0xb6>
		if ((*pte & PTE_V) != 0) {
    80202270:	611c                	ld	a5,0(a0)
    80202272:	0017f713          	andi	a4,a5,1
    80202276:	df79                	beqz	a4,80202254 <uvmunmap+0xb2>
			if (PTE_FLAGS(*pte) == PTE_V)
    80202278:	3ff7f793          	andi	a5,a5,1023
    8020227c:	fb7788e3          	beq	a5,s7,8020222c <uvmunmap+0x8a>
			if (do_free) {
    80202280:	fc0b0ae3          	beqz	s6,80202254 <uvmunmap+0xb2>
				uint64 pa = PTE2PA(*pte);
    80202284:	6088                	ld	a0,0(s1)
    80202286:	8129                	srli	a0,a0,0xa
				kfree((void *)pa);
    80202288:	0532                	slli	a0,a0,0xc
    8020228a:	ffffe097          	auipc	ra,0xffffe
    8020228e:	dbe080e7          	jalr	-578(ra) # 80200048 <kfree>
    80202292:	b7c9                	j	80202254 <uvmunmap+0xb2>
	}
}
    80202294:	60e6                	ld	ra,88(sp)
    80202296:	6446                	ld	s0,80(sp)
    80202298:	64a6                	ld	s1,72(sp)
    8020229a:	6906                	ld	s2,64(sp)
    8020229c:	79e2                	ld	s3,56(sp)
    8020229e:	7a42                	ld	s4,48(sp)
    802022a0:	7aa2                	ld	s5,40(sp)
    802022a2:	7b02                	ld	s6,32(sp)
    802022a4:	6be2                	ld	s7,24(sp)
    802022a6:	6c42                	ld	s8,16(sp)
    802022a8:	6ca2                	ld	s9,8(sp)
    802022aa:	6d02                	ld	s10,0(sp)
    802022ac:	6125                	addi	sp,sp,96
    802022ae:	8082                	ret

00000000802022b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate(uint64 trapframe)
{
    802022b0:	1101                	addi	sp,sp,-32
    802022b2:	ec06                	sd	ra,24(sp)
    802022b4:	e822                	sd	s0,16(sp)
    802022b6:	e426                	sd	s1,8(sp)
    802022b8:	e04a                	sd	s2,0(sp)
    802022ba:	1000                	addi	s0,sp,32
    802022bc:	892a                	mv	s2,a0
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    802022be:	ffffe097          	auipc	ra,0xffffe
    802022c2:	e7c080e7          	jalr	-388(ra) # 8020013a <kalloc>
    802022c6:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    802022c8:	cd29                	beqz	a0,80202322 <uvmcreate+0x72>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    802022ca:	6605                	lui	a2,0x1
    802022cc:	4581                	li	a1,0
    802022ce:	fffff097          	auipc	ra,0xfffff
    802022d2:	e80080e7          	jalr	-384(ra) # 8020114e <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    802022d6:	4729                	li	a4,10
    802022d8:	00001697          	auipc	a3,0x1
    802022dc:	d2868693          	addi	a3,a3,-728 # 80203000 <trampoline>
    802022e0:	6605                	lui	a2,0x1
    802022e2:	040005b7          	lui	a1,0x4000
    802022e6:	15fd                	addi	a1,a1,-1
    802022e8:	05b2                	slli	a1,a1,0xc
    802022ea:	8526                	mv	a0,s1
    802022ec:	00000097          	auipc	ra,0x0
    802022f0:	cc8080e7          	jalr	-824(ra) # 80201fb4 <mappages>
    802022f4:	04054a63          	bltz	a0,80202348 <uvmcreate+0x98>
		     PTE_R | PTE_X) < 0) {
		panic("mappages fail");
	}
	if (mappages(pagetable, TRAPFRAME, PGSIZE, trapframe, PTE_R | PTE_W) <
    802022f8:	4719                	li	a4,6
    802022fa:	86ca                	mv	a3,s2
    802022fc:	6605                	lui	a2,0x1
    802022fe:	020005b7          	lui	a1,0x2000
    80202302:	15fd                	addi	a1,a1,-1
    80202304:	05b6                	slli	a1,a1,0xd
    80202306:	8526                	mv	a0,s1
    80202308:	00000097          	auipc	ra,0x0
    8020230c:	cac080e7          	jalr	-852(ra) # 80201fb4 <mappages>
    80202310:	06054963          	bltz	a0,80202382 <uvmcreate+0xd2>
	    0) {
		panic("mappages fail");
	}
	return pagetable;
}
    80202314:	8526                	mv	a0,s1
    80202316:	60e2                	ld	ra,24(sp)
    80202318:	6442                	ld	s0,16(sp)
    8020231a:	64a2                	ld	s1,8(sp)
    8020231c:	6902                	ld	s2,0(sp)
    8020231e:	6105                	addi	sp,sp,32
    80202320:	8082                	ret
		errorf("uvmcreate: kalloc error");
    80202322:	ffffe097          	auipc	ra,0xffffe
    80202326:	624080e7          	jalr	1572(ra) # 80200946 <threadid>
    8020232a:	86aa                	mv	a3,a0
    8020232c:	00002617          	auipc	a2,0x2
    80202330:	ef460613          	addi	a2,a2,-268 # 80204220 <digits+0xf0>
    80202334:	45fd                	li	a1,31
    80202336:	00002517          	auipc	a0,0x2
    8020233a:	2a250513          	addi	a0,a0,674 # 802045d8 <digits+0x4a8>
    8020233e:	ffffe097          	auipc	ra,0xffffe
    80202342:	432080e7          	jalr	1074(ra) # 80200770 <printf>
		return 0;
    80202346:	b7f9                	j	80202314 <uvmcreate+0x64>
		panic("mappages fail");
    80202348:	ffffe097          	auipc	ra,0xffffe
    8020234c:	5fe080e7          	jalr	1534(ra) # 80200946 <threadid>
    80202350:	86aa                	mv	a3,a0
    80202352:	0b000793          	li	a5,176
    80202356:	00002717          	auipc	a4,0x2
    8020235a:	19a70713          	addi	a4,a4,410 # 802044f0 <digits+0x3c0>
    8020235e:	00002617          	auipc	a2,0x2
    80202362:	cb260613          	addi	a2,a2,-846 # 80204010 <e_text+0x10>
    80202366:	45fd                	li	a1,31
    80202368:	00002517          	auipc	a0,0x2
    8020236c:	2a050513          	addi	a0,a0,672 # 80204608 <digits+0x4d8>
    80202370:	ffffe097          	auipc	ra,0xffffe
    80202374:	400080e7          	jalr	1024(ra) # 80200770 <printf>
    80202378:	fffff097          	auipc	ra,0xfffff
    8020237c:	da8080e7          	jalr	-600(ra) # 80201120 <shutdown>
    80202380:	bfa5                	j	802022f8 <uvmcreate+0x48>
		panic("mappages fail");
    80202382:	ffffe097          	auipc	ra,0xffffe
    80202386:	5c4080e7          	jalr	1476(ra) # 80200946 <threadid>
    8020238a:	86aa                	mv	a3,a0
    8020238c:	0b400793          	li	a5,180
    80202390:	00002717          	auipc	a4,0x2
    80202394:	16070713          	addi	a4,a4,352 # 802044f0 <digits+0x3c0>
    80202398:	00002617          	auipc	a2,0x2
    8020239c:	c7860613          	addi	a2,a2,-904 # 80204010 <e_text+0x10>
    802023a0:	45fd                	li	a1,31
    802023a2:	00002517          	auipc	a0,0x2
    802023a6:	26650513          	addi	a0,a0,614 # 80204608 <digits+0x4d8>
    802023aa:	ffffe097          	auipc	ra,0xffffe
    802023ae:	3c6080e7          	jalr	966(ra) # 80200770 <printf>
    802023b2:	fffff097          	auipc	ra,0xfffff
    802023b6:	d6e080e7          	jalr	-658(ra) # 80201120 <shutdown>
    802023ba:	bfa9                	j	80202314 <uvmcreate+0x64>

00000000802023bc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    802023bc:	7179                	addi	sp,sp,-48
    802023be:	f406                	sd	ra,40(sp)
    802023c0:	f022                	sd	s0,32(sp)
    802023c2:	ec26                	sd	s1,24(sp)
    802023c4:	e84a                	sd	s2,16(sp)
    802023c6:	e44e                	sd	s3,8(sp)
    802023c8:	e052                	sd	s4,0(sp)
    802023ca:	1800                	addi	s0,sp,48
    802023cc:	8a2a                	mv	s4,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    802023ce:	84aa                	mv	s1,a0
    802023d0:	6905                	lui	s2,0x1
    802023d2:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    802023d4:	4985                	li	s3,1
    802023d6:	a021                	j	802023de <freewalk+0x22>
	for (int i = 0; i < 512; i++) {
    802023d8:	04a1                	addi	s1,s1,8
    802023da:	03248063          	beq	s1,s2,802023fa <freewalk+0x3e>
		pte_t pte = pagetable[i];
    802023de:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    802023e0:	00f57793          	andi	a5,a0,15
    802023e4:	ff379ae3          	bne	a5,s3,802023d8 <freewalk+0x1c>
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
    802023e8:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    802023ea:	0532                	slli	a0,a0,0xc
    802023ec:	00000097          	auipc	ra,0x0
    802023f0:	fd0080e7          	jalr	-48(ra) # 802023bc <freewalk>
			pagetable[i] = 0;
    802023f4:	0004b023          	sd	zero,0(s1)
    802023f8:	b7c5                	j	802023d8 <freewalk+0x1c>
		} else if (pte & PTE_V) {
			// panic("freewalk: leaf");
		}
	}
	kfree((void *)pagetable);
    802023fa:	8552                	mv	a0,s4
    802023fc:	ffffe097          	auipc	ra,0xffffe
    80202400:	c4c080e7          	jalr	-948(ra) # 80200048 <kfree>
}
    80202404:	70a2                	ld	ra,40(sp)
    80202406:	7402                	ld	s0,32(sp)
    80202408:	64e2                	ld	s1,24(sp)
    8020240a:	6942                	ld	s2,16(sp)
    8020240c:	69a2                	ld	s3,8(sp)
    8020240e:	6a02                	ld	s4,0(sp)
    80202410:	6145                	addi	sp,sp,48
    80202412:	8082                	ret

0000000080202414 <uvmfree>:
 * @brief Free user memory pages, then free page-table pages.
 *
 * @param max_page The max vaddr of user-space.
 */
void uvmfree(pagetable_t pagetable, uint64 max_page)
{
    80202414:	1101                	addi	sp,sp,-32
    80202416:	ec06                	sd	ra,24(sp)
    80202418:	e822                	sd	s0,16(sp)
    8020241a:	e426                	sd	s1,8(sp)
    8020241c:	1000                	addi	s0,sp,32
    8020241e:	84aa                	mv	s1,a0
	if (max_page > 0)
    80202420:	e999                	bnez	a1,80202436 <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80202422:	8526                	mv	a0,s1
    80202424:	00000097          	auipc	ra,0x0
    80202428:	f98080e7          	jalr	-104(ra) # 802023bc <freewalk>
}
    8020242c:	60e2                	ld	ra,24(sp)
    8020242e:	6442                	ld	s0,16(sp)
    80202430:	64a2                	ld	s1,8(sp)
    80202432:	6105                	addi	sp,sp,32
    80202434:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    80202436:	4685                	li	a3,1
    80202438:	862e                	mv	a2,a1
    8020243a:	4581                	li	a1,0
    8020243c:	00000097          	auipc	ra,0x0
    80202440:	d66080e7          	jalr	-666(ra) # 802021a2 <uvmunmap>
    80202444:	bff9                	j	80202422 <uvmfree+0xe>

0000000080202446 <uvmcopy>:

// Used in fork.
// Copy the pagetable page and all the user pages.
// Return 0 on success, -1 on error.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 max_page)
{
    80202446:	715d                	addi	sp,sp,-80
    80202448:	e486                	sd	ra,72(sp)
    8020244a:	e0a2                	sd	s0,64(sp)
    8020244c:	fc26                	sd	s1,56(sp)
    8020244e:	f84a                	sd	s2,48(sp)
    80202450:	f44e                	sd	s3,40(sp)
    80202452:	f052                	sd	s4,32(sp)
    80202454:	ec56                	sd	s5,24(sp)
    80202456:	e85a                	sd	s6,16(sp)
    80202458:	e45e                	sd	s7,8(sp)
    8020245a:	0880                	addi	s0,sp,80
	pte_t *pte;
	uint64 pa, i;
	uint flags;
	char *mem;

	for (i = 0; i < max_page * PAGE_SIZE; i += PGSIZE) {
    8020245c:	00c61a13          	slli	s4,a2,0xc
    80202460:	080a0e63          	beqz	s4,802024fc <uvmcopy+0xb6>
    80202464:	8aaa                	mv	s5,a0
    80202466:	8b2e                	mv	s6,a1
    80202468:	4481                	li	s1,0
    8020246a:	a029                	j	80202474 <uvmcopy+0x2e>
    8020246c:	6785                	lui	a5,0x1
    8020246e:	94be                	add	s1,s1,a5
    80202470:	0744fa63          	bgeu	s1,s4,802024e4 <uvmcopy+0x9e>
		if ((pte = walk(old, i, 0)) == 0)
    80202474:	4601                	li	a2,0
    80202476:	85a6                	mv	a1,s1
    80202478:	8556                	mv	a0,s5
    8020247a:	00000097          	auipc	ra,0x0
    8020247e:	9fe080e7          	jalr	-1538(ra) # 80201e78 <walk>
    80202482:	d56d                	beqz	a0,8020246c <uvmcopy+0x26>
			continue;
		if ((*pte & PTE_V) == 0)
    80202484:	6118                	ld	a4,0(a0)
    80202486:	00177793          	andi	a5,a4,1
    8020248a:	d3ed                	beqz	a5,8020246c <uvmcopy+0x26>
			continue;
		pa = PTE2PA(*pte);
    8020248c:	00a75593          	srli	a1,a4,0xa
    80202490:	00c59b93          	slli	s7,a1,0xc
		flags = PTE_FLAGS(*pte);
    80202494:	3ff77913          	andi	s2,a4,1023
		if ((mem = kalloc()) == 0)
    80202498:	ffffe097          	auipc	ra,0xffffe
    8020249c:	ca2080e7          	jalr	-862(ra) # 8020013a <kalloc>
    802024a0:	89aa                	mv	s3,a0
    802024a2:	c515                	beqz	a0,802024ce <uvmcopy+0x88>
			goto err;
		memmove(mem, (char *)pa, PGSIZE);
    802024a4:	6605                	lui	a2,0x1
    802024a6:	85de                	mv	a1,s7
    802024a8:	fffff097          	auipc	ra,0xfffff
    802024ac:	d02080e7          	jalr	-766(ra) # 802011aa <memmove>
		if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    802024b0:	874a                	mv	a4,s2
    802024b2:	86ce                	mv	a3,s3
    802024b4:	6605                	lui	a2,0x1
    802024b6:	85a6                	mv	a1,s1
    802024b8:	855a                	mv	a0,s6
    802024ba:	00000097          	auipc	ra,0x0
    802024be:	afa080e7          	jalr	-1286(ra) # 80201fb4 <mappages>
    802024c2:	d54d                	beqz	a0,8020246c <uvmcopy+0x26>
			kfree(mem);
    802024c4:	854e                	mv	a0,s3
    802024c6:	ffffe097          	auipc	ra,0xffffe
    802024ca:	b82080e7          	jalr	-1150(ra) # 80200048 <kfree>
		}
	}
	return 0;

err:
	uvmunmap(new, 0, i / PGSIZE, 1);
    802024ce:	4685                	li	a3,1
    802024d0:	00c4d613          	srli	a2,s1,0xc
    802024d4:	4581                	li	a1,0
    802024d6:	855a                	mv	a0,s6
    802024d8:	00000097          	auipc	ra,0x0
    802024dc:	cca080e7          	jalr	-822(ra) # 802021a2 <uvmunmap>
	return -1;
    802024e0:	557d                	li	a0,-1
    802024e2:	a011                	j	802024e6 <uvmcopy+0xa0>
	return 0;
    802024e4:	4501                	li	a0,0
}
    802024e6:	60a6                	ld	ra,72(sp)
    802024e8:	6406                	ld	s0,64(sp)
    802024ea:	74e2                	ld	s1,56(sp)
    802024ec:	7942                	ld	s2,48(sp)
    802024ee:	79a2                	ld	s3,40(sp)
    802024f0:	7a02                	ld	s4,32(sp)
    802024f2:	6ae2                	ld	s5,24(sp)
    802024f4:	6b42                	ld	s6,16(sp)
    802024f6:	6ba2                	ld	s7,8(sp)
    802024f8:	6161                	addi	sp,sp,80
    802024fa:	8082                	ret
	return 0;
    802024fc:	4501                	li	a0,0
    802024fe:	b7e5                	j	802024e6 <uvmcopy+0xa0>

0000000080202500 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80202500:	c6bd                	beqz	a3,8020256e <copyout+0x6e>
{
    80202502:	715d                	addi	sp,sp,-80
    80202504:	e486                	sd	ra,72(sp)
    80202506:	e0a2                	sd	s0,64(sp)
    80202508:	fc26                	sd	s1,56(sp)
    8020250a:	f84a                	sd	s2,48(sp)
    8020250c:	f44e                	sd	s3,40(sp)
    8020250e:	f052                	sd	s4,32(sp)
    80202510:	ec56                	sd	s5,24(sp)
    80202512:	e85a                	sd	s6,16(sp)
    80202514:	e45e                	sd	s7,8(sp)
    80202516:	e062                	sd	s8,0(sp)
    80202518:	0880                	addi	s0,sp,80
    8020251a:	8b2a                	mv	s6,a0
    8020251c:	8c2e                	mv	s8,a1
    8020251e:	8a32                	mv	s4,a2
    80202520:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80202522:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    80202524:	6a85                	lui	s5,0x1
    80202526:	a015                	j	8020254a <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    80202528:	9562                	add	a0,a0,s8
    8020252a:	0004861b          	sext.w	a2,s1
    8020252e:	85d2                	mv	a1,s4
    80202530:	41250533          	sub	a0,a0,s2
    80202534:	fffff097          	auipc	ra,0xfffff
    80202538:	c76080e7          	jalr	-906(ra) # 802011aa <memmove>

		len -= n;
    8020253c:	409989b3          	sub	s3,s3,s1
		src += n;
    80202540:	9a26                	add	s4,s4,s1
		dstva = va0 + PGSIZE;
    80202542:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80202546:	02098263          	beqz	s3,8020256a <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    8020254a:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    8020254e:	85ca                	mv	a1,s2
    80202550:	855a                	mv	a0,s6
    80202552:	00000097          	auipc	ra,0x0
    80202556:	9f8080e7          	jalr	-1544(ra) # 80201f4a <walkaddr>
		if (pa0 == 0)
    8020255a:	cd01                	beqz	a0,80202572 <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    8020255c:	418904b3          	sub	s1,s2,s8
    80202560:	94d6                	add	s1,s1,s5
		if (n > len)
    80202562:	fc99f3e3          	bgeu	s3,s1,80202528 <copyout+0x28>
    80202566:	84ce                	mv	s1,s3
    80202568:	b7c1                	j	80202528 <copyout+0x28>
	}
	return 0;
    8020256a:	4501                	li	a0,0
    8020256c:	a021                	j	80202574 <copyout+0x74>
    8020256e:	4501                	li	a0,0
}
    80202570:	8082                	ret
			return -1;
    80202572:	557d                	li	a0,-1
}
    80202574:	60a6                	ld	ra,72(sp)
    80202576:	6406                	ld	s0,64(sp)
    80202578:	74e2                	ld	s1,56(sp)
    8020257a:	7942                	ld	s2,48(sp)
    8020257c:	79a2                	ld	s3,40(sp)
    8020257e:	7a02                	ld	s4,32(sp)
    80202580:	6ae2                	ld	s5,24(sp)
    80202582:	6b42                	ld	s6,16(sp)
    80202584:	6ba2                	ld	s7,8(sp)
    80202586:	6c02                	ld	s8,0(sp)
    80202588:	6161                	addi	sp,sp,80
    8020258a:	8082                	ret

000000008020258c <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    8020258c:	caa5                	beqz	a3,802025fc <copyin+0x70>
{
    8020258e:	715d                	addi	sp,sp,-80
    80202590:	e486                	sd	ra,72(sp)
    80202592:	e0a2                	sd	s0,64(sp)
    80202594:	fc26                	sd	s1,56(sp)
    80202596:	f84a                	sd	s2,48(sp)
    80202598:	f44e                	sd	s3,40(sp)
    8020259a:	f052                	sd	s4,32(sp)
    8020259c:	ec56                	sd	s5,24(sp)
    8020259e:	e85a                	sd	s6,16(sp)
    802025a0:	e45e                	sd	s7,8(sp)
    802025a2:	e062                	sd	s8,0(sp)
    802025a4:	0880                	addi	s0,sp,80
    802025a6:	8b2a                	mv	s6,a0
    802025a8:	8a2e                	mv	s4,a1
    802025aa:	8c32                	mv	s8,a2
    802025ac:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    802025ae:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    802025b0:	6a85                	lui	s5,0x1
    802025b2:	a01d                	j	802025d8 <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    802025b4:	018505b3          	add	a1,a0,s8
    802025b8:	0004861b          	sext.w	a2,s1
    802025bc:	412585b3          	sub	a1,a1,s2
    802025c0:	8552                	mv	a0,s4
    802025c2:	fffff097          	auipc	ra,0xfffff
    802025c6:	be8080e7          	jalr	-1048(ra) # 802011aa <memmove>

		len -= n;
    802025ca:	409989b3          	sub	s3,s3,s1
		dst += n;
    802025ce:	9a26                	add	s4,s4,s1
		srcva = va0 + PGSIZE;
    802025d0:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    802025d4:	02098263          	beqz	s3,802025f8 <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    802025d8:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    802025dc:	85ca                	mv	a1,s2
    802025de:	855a                	mv	a0,s6
    802025e0:	00000097          	auipc	ra,0x0
    802025e4:	96a080e7          	jalr	-1686(ra) # 80201f4a <walkaddr>
		if (pa0 == 0)
    802025e8:	cd01                	beqz	a0,80202600 <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    802025ea:	418904b3          	sub	s1,s2,s8
    802025ee:	94d6                	add	s1,s1,s5
		if (n > len)
    802025f0:	fc99f2e3          	bgeu	s3,s1,802025b4 <copyin+0x28>
    802025f4:	84ce                	mv	s1,s3
    802025f6:	bf7d                	j	802025b4 <copyin+0x28>
	}
	return 0;
    802025f8:	4501                	li	a0,0
    802025fa:	a021                	j	80202602 <copyin+0x76>
    802025fc:	4501                	li	a0,0
}
    802025fe:	8082                	ret
			return -1;
    80202600:	557d                	li	a0,-1
}
    80202602:	60a6                	ld	ra,72(sp)
    80202604:	6406                	ld	s0,64(sp)
    80202606:	74e2                	ld	s1,56(sp)
    80202608:	7942                	ld	s2,48(sp)
    8020260a:	79a2                	ld	s3,40(sp)
    8020260c:	7a02                	ld	s4,32(sp)
    8020260e:	6ae2                	ld	s5,24(sp)
    80202610:	6b42                	ld	s6,16(sp)
    80202612:	6ba2                	ld	s7,8(sp)
    80202614:	6c02                	ld	s8,0(sp)
    80202616:	6161                	addi	sp,sp,80
    80202618:	8082                	ret

000000008020261a <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    8020261a:	715d                	addi	sp,sp,-80
    8020261c:	e486                	sd	ra,72(sp)
    8020261e:	e0a2                	sd	s0,64(sp)
    80202620:	fc26                	sd	s1,56(sp)
    80202622:	f84a                	sd	s2,48(sp)
    80202624:	f44e                	sd	s3,40(sp)
    80202626:	f052                	sd	s4,32(sp)
    80202628:	ec56                	sd	s5,24(sp)
    8020262a:	e85a                	sd	s6,16(sp)
    8020262c:	e45e                	sd	s7,8(sp)
    8020262e:	e062                	sd	s8,0(sp)
    80202630:	0880                	addi	s0,sp,80
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    80202632:	c6c9                	beqz	a3,802026bc <copyinstr+0xa2>
    80202634:	8aaa                	mv	s5,a0
    80202636:	8bae                	mv	s7,a1
    80202638:	8c32                	mv	s8,a2
    8020263a:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    8020263c:	4481                	li	s1,0
		va0 = PGROUNDDOWN(srcva);
    8020263e:	7b7d                	lui	s6,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80202640:	6a05                	lui	s4,0x1
    80202642:	a025                	j	8020266a <copyinstr+0x50>
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
				*dst = '\0';
    80202644:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x801ff000>
		}

		srcva = va0 + PGSIZE;
	}
	return len;
}
    80202648:	8526                	mv	a0,s1
    8020264a:	60a6                	ld	ra,72(sp)
    8020264c:	6406                	ld	s0,64(sp)
    8020264e:	74e2                	ld	s1,56(sp)
    80202650:	7942                	ld	s2,48(sp)
    80202652:	79a2                	ld	s3,40(sp)
    80202654:	7a02                	ld	s4,32(sp)
    80202656:	6ae2                	ld	s5,24(sp)
    80202658:	6b42                	ld	s6,16(sp)
    8020265a:	6ba2                	ld	s7,8(sp)
    8020265c:	6c02                	ld	s8,0(sp)
    8020265e:	6161                	addi	sp,sp,80
    80202660:	8082                	ret
		srcva = va0 + PGSIZE;
    80202662:	01498c33          	add	s8,s3,s4
	while (got_null == 0 && max > 0) {
    80202666:	fe0901e3          	beqz	s2,80202648 <copyinstr+0x2e>
		va0 = PGROUNDDOWN(srcva);
    8020266a:	016c79b3          	and	s3,s8,s6
		pa0 = walkaddr(pagetable, va0);
    8020266e:	85ce                	mv	a1,s3
    80202670:	8556                	mv	a0,s5
    80202672:	00000097          	auipc	ra,0x0
    80202676:	8d8080e7          	jalr	-1832(ra) # 80201f4a <walkaddr>
		if (pa0 == 0)
    8020267a:	c139                	beqz	a0,802026c0 <copyinstr+0xa6>
		n = PGSIZE - (srcva - va0);
    8020267c:	41898833          	sub	a6,s3,s8
    80202680:	9852                	add	a6,a6,s4
		if (n > max)
    80202682:	01097363          	bgeu	s2,a6,80202688 <copyinstr+0x6e>
    80202686:	884a                	mv	a6,s2
		char *p = (char *)(pa0 + (srcva - va0));
    80202688:	9562                	add	a0,a0,s8
    8020268a:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    8020268e:	fc080ae3          	beqz	a6,80202662 <copyinstr+0x48>
    80202692:	985e                	add	a6,a6,s7
    80202694:	87de                	mv	a5,s7
			if (*p == '\0') {
    80202696:	41750633          	sub	a2,a0,s7
    8020269a:	197d                	addi	s2,s2,-1
    8020269c:	9bca                	add	s7,s7,s2
    8020269e:	00f60733          	add	a4,a2,a5
    802026a2:	00074703          	lbu	a4,0(a4)
    802026a6:	df59                	beqz	a4,80202644 <copyinstr+0x2a>
				*dst = *p;
    802026a8:	00e78023          	sb	a4,0(a5)
			--max;
    802026ac:	40fb8933          	sub	s2,s7,a5
			dst++;
    802026b0:	0785                	addi	a5,a5,1
			len++;
    802026b2:	2485                	addiw	s1,s1,1
		while (n > 0) {
    802026b4:	ff0795e3          	bne	a5,a6,8020269e <copyinstr+0x84>
			dst++;
    802026b8:	8bc2                	mv	s7,a6
    802026ba:	b765                	j	80202662 <copyinstr+0x48>
	int got_null = 0, len = 0;
    802026bc:	4481                	li	s1,0
    802026be:	b769                	j	80202648 <copyinstr+0x2e>
			return -1;
    802026c0:	54fd                	li	s1,-1
    802026c2:	b759                	j	80202648 <copyinstr+0x2e>

00000000802026c4 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    802026c4:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    802026c8:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    802026cc:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    802026ce:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    802026d0:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    802026d4:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    802026d8:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    802026dc:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    802026e0:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    802026e4:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    802026e8:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    802026ec:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    802026f0:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    802026f4:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    802026f8:	0005b083          	ld	ra,0(a1) # 2000000 <_entry-0x7e200000>
        ld sp, 8(a1)
    802026fc:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80202700:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80202702:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80202704:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80202708:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8020270c:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80202710:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80202714:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80202718:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8020271c:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80202720:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80202724:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80202728:	0685bd83          	ld	s11,104(a1)

    8020272c:	8082                	ret
	...

0000000080203000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80203000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80203004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80203008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020300c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80203010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80203014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80203018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020301c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80203020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80203022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80203024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80203026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80203028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020302a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020302c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020302e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80203032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80203036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020303a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020303e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80203042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80203046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020304a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020304e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80203052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80203056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020305a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020305e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80203062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80203066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020306a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020306e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80203072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80203076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020307a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020307e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80203082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80203086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020308a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020308e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80203092:	12000073          	sfence.vma
        jr t0
    80203096:	8282                	jr	t0

0000000080203098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80203098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020309c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802030a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802030a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802030a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802030ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802030b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802030b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802030b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802030bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802030c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802030c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802030c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802030c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802030ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802030cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802030ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802030d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802030d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802030d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802030da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802030de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802030e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802030e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802030ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802030ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802030f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802030f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802030fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802030fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80203102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80203106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020310a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020310e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80203112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80203116:	10200073          	sret
	...
