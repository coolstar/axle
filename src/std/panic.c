#include "panic.h"
#include "common.h"

void panic(uint16_t line, const char* file) {
	printf("\n");
	printf_err("PANIC %s: line %d", file, line);
	//enter infinite loop
	do {} while (1);
}

void panic_msg(const char* msg, uint16_t line, const char* file) {
	printf_err("Throwing panic: %s", msg);
	panic(line, file);
}
