#define CODE_ADDR 0x00000400
#define FLASH_CODE_ADDR 0x90000400
#pragma CODE_SECTION(boot,".bootload")

extern far void c_int00(void);

void boot(void)
{
	register int c_entrypoint;
	register int code_i;
	register int code_num;
	code_num=*(volatile int *)(FLASH_CODE_ADDR+4);
	code_i=0;
	for((code_i)=0;(code_i)<(code_num);(code_i)++)
	{
		*(short *)(0x00000400+2*(code_i))=*(short *)(FLASH_CODE_ADDR+12+2*(code_i));
	}
	c_int00();
}

