#include "syscall.h"
#include "console.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"
#include "vm.h"

#define MAX_MMAP_SIZE (1024 * 1024 * 1024)

uint64 console_write(uint64 va, uint64 len)
{
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
	tracef("write size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return len;
}

uint64 console_read(uint64 va, uint64 len)
{
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	tracef("read size = %d", len);
	for (int i = 0; i < len; ++i) {
		int c = consgetc();
		str[i] = c;
	}
	copyout(p->pagetable, va, str, len);
	return len;
}

uint64 sys_write(int fd, uint64 va, uint64 len)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
		return -1;
	struct proc *p = curr_proc();
	struct file *f = p->files[fd];
	if (f == NULL) {
		errorf("invalid fd %d\n", fd);
		return -1;
	}
	switch (f->type) {
	case FD_STDIO:
		return console_write(va, len);
	case FD_INODE:
		return inodewrite(f, va, len);
	default:
		panic("unknown file type %d\n", f->type);
	}
}

uint64 sys_read(int fd, uint64 va, uint64 len)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
		return -1;
	struct proc *p = curr_proc();
	struct file *f = p->files[fd];
	if (f == NULL) {
		errorf("invalid fd %d\n", fd);
		return -1;
	}
	switch (f->type) {
	case FD_STDIO:
		return console_read(va, len);
	case FD_INODE:
		return inoderead(f, va, len);
	default:
		panic("unknown file type %d\n", f->type);
	}
}

__attribute__((noreturn)) void sys_exit(int code)
{
	exit(code);
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
	yield();
	return 0;
}

uint64 sys_gettimeofday(uint64 va, int _tz) 
{
	struct proc *p = curr_proc();

	uint64 pa = useraddr(p->pagetable, va);
	if (pa == 0) {
		return -1;
	}

	TimeVal *val = (TimeVal *)pa;

	uint64 cycle = get_cycle();
	val->sec = cycle / CPU_FREQ;
	val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	return 0;
}

uint64 sys_mmap(uint64 start, uint64 len, int port, int flag, int fd) {
	if (len == 0) return 0;
	if (len > MAX_MMAP_SIZE) return -1;
	if (start % PGSIZE != 0) return -1;
	if ((port & ~0x7) != 0) return -1;
	if ((port & 0x7) == 0) return -1;

	struct proc *p = curr_proc();
	uint64 aligned_len = PGROUNDUP(len);

	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
		if (useraddr(p->pagetable, addr) != 0) {
			return -1;
		}
	}

	int perm = PTE_U;
	if (port & 1) perm |= PTE_R;
	if (port & 2) perm |= PTE_W;
	if (port & 4) perm |= PTE_X;

	for (uint64 addr = start; addr < start + aligned_len; addr += PGSIZE) {
		void *pa = kalloc();
		if (pa == 0) return -1;
		memset(pa, 0, PGSIZE);

		if (mappages(p->pagetable, addr, PGSIZE, (uint64)pa, perm) != 0) {
			kfree(pa);
			return -1;
		}
	}

	return 0;
}

uint64 sys_munmap(uint64 start, uint64 len) {
	if (start % PGSIZE != 0) { return -1; }
	
	struct proc *p = curr_proc();
	uint64 aligned_len = PGROUNDUP(len);

	for (uint64 addr = start; addr < start + aligned_len;  addr += PGSIZE) {
		if (useraddr(p->pagetable, addr) == 0) {
			return -1;
		}
	}

	uvmunmap(p->pagetable, start, aligned_len / PGSIZE, 1);

	return 0;
}

uint64 sys_getpid()
{
	return curr_proc()->pid;
}

uint64 sys_getppid()
{
	struct proc *p = curr_proc();
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
}

int sys_task_info(uint64 va) {
	struct proc *p = curr_proc();

	uint64 pa = useraddr(p->pagetable, va);
	if (pa == 0) { return -1; }

	TaskInfo *ti = (TaskInfo *)pa;

	ti->status = p->info->status;

	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
        ti->syscall_times[i] = p->info->syscall_times[i];
    }

	uint64 now = get_cycle() / (CPU_FREQ / 1000);
	ti->time = now - p->info->time;

	return 0;
}


uint64 sys_clone()
{
	debugf("fork!");
	return fork();
}

static inline uint64 fetchaddr(pagetable_t pagetable, uint64 va)
{
	uint64 *addr = (uint64 *)useraddr(pagetable, va);
	return *addr;
}

uint64 sys_exec(uint64 path, uint64 uargv)
{
	struct proc *p = curr_proc();
	char name[MAX_STR_LEN];
	copyinstr(p->pagetable, name, path, MAX_STR_LEN);
	uint64 arg;
	static char strpool[MAX_ARG_NUM][MAX_STR_LEN];
	char *argv[MAX_ARG_NUM];
	int i;
	for (i = 0; uargv && (arg = fetchaddr(p->pagetable, uargv));
	     uargv += sizeof(char *), i++) {
		copyinstr(p->pagetable, (char *)strpool[i], arg, MAX_STR_LEN);
		argv[i] = (char *)strpool[i];
	}
	argv[i] = NULL;

	// return exec(name);
	return exec(name, (char **)argv);
}

uint64 sys_wait(int pid, uint64 va)
{
	struct proc *p = curr_proc();
	int *code = (int *)useraddr(p->pagetable, va);
	return wait(pid, code);
}

uint64 sys_spawn(uint64 va)
{
	// TODO: your job is to complete the sys call

	struct proc *p = curr_proc();

	char name[200];
	copyinstr(p->pagetable, name, va, 200);
	int id = get_id_by_name(name);
	if (id < 0) { return -1; }

	struct proc *child_p = allocproc();
	if (child_p == 0) { return -1; }
	loader(id, child_p);

	child_p->parent = p;
	child_p->state = RUNNABLE;
	
	return child_p->pid;
}

uint64 sys_set_priority(long long prio){
    // TODO: your job is to complete the sys call
	if (prio < 2) { return -1; }
	struct proc *p = curr_proc();
	p->priority = prio;
	p->pass = 65536 / prio;
	return prio;
}

uint64 sys_openat(uint64 va, uint64 omode, uint64 _flags)
{
	struct proc *p = curr_proc();
	char path[200];
	copyinstr(p->pagetable, path, va, 200);
	return fileopen(path, omode);
}

uint64 sys_close(int fd)
{
	if (fd < 0 || fd > FD_BUFFER_SIZE)
		return -1;
	struct proc *p = curr_proc();
	struct file *f = p->files[fd];
	if (f == NULL) {
		errorf("invalid fd %d", fd);
		return -1;
	}
	fileclose(f);
	p->files[fd] = 0;
	return 0;
}

int sys_fstat(int fd,uint64 stat){
	//TODO: your job is to complete the syscall
	return -1;
}

int sys_linkat(int olddirfd, uint64 oldpath, int newdirfd, uint64 newpath, uint64 flags){
	//TODO: your job is to complete the syscall
	return -1;
}

int sys_unlinkat(int dirfd, uint64 name, uint64 flags){
	//TODO: your job is to complete the syscall
	return -1;
}

extern char trap_page[];

void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
	case SYS_write:
		ret = sys_write(args[0], args[1], args[2]);
		break;
	case SYS_read:
		ret = sys_read(args[0], args[1], args[2]);
		break;
	case SYS_openat:
		ret = sys_openat(args[0], args[1], args[2]);
		break;
	case SYS_close:
		ret = sys_close(args[0]);
		break;
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday(args[0], args[1]);
		break;
	case SYS_getpid:
		ret = sys_getpid();
		break;
	case SYS_getppid:
		ret = sys_getppid();
		break;
	case SYS_clone: // SYS_fork
		ret = sys_clone();
		break;
	case SYS_execve:
		ret = sys_exec(args[0], args[1]);
		break;
	case SYS_wait4:
		ret = sys_wait(args[0], args[1]);
		break;
	case SYS_fstat:
	    ret = sys_fstat(args[0],args[1]);
		break;
	case SYS_linkat:
	    ret = sys_linkat(args[0],args[1],args[2],args[3],args[4]);
		break;
	case SYS_unlinkat:
	    ret = sys_unlinkat(args[0],args[1],args[2]);
	case SYS_spawn:
		ret = sys_spawn(args[0]);
		break;
	case SYS_task_info:
		ret = sys_task_info(args[0]);
		break;
	case SYS_mmap:
		ret = sys_mmap(args[0], args[1], (int)args[2], (int)args[3], (int)args[4]);
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
