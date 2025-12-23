build:
	gcc -Os -s -Wall -Wextra -ffunction-sections -fdata-sections -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fomit-frame-pointer -Wl,--gc-sections src/gcc/validate-ipv4-6.c -o validate-ipv4-6.elf
