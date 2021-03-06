MBOOT_PAGE_ALIGN	equ 1<<0	; load kernel and modules on page boundary
MBOOT_MEM_INFO		equ 1<<1	; provide kernel. with memory info
MBOOT_HEADER_MAGIC	equ 0x1BADB002	; multiboot magic value
MBOOT_HEADER_FLAGS	equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM		equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

[BITS 32]

[GLOBAL mboot]
[EXTERN code]			; start of .text section
[EXTERN bss]			; start of .bss
[EXTERN end]			; end of last loadable section

[SECTION .mboot]
mboot:
	dd MBOOT_HEADER_MAGIC	; header value for GRUB
	dd MBOOT_HEADER_FLAGS	; grub settings
	dd MBOOT_CHECKSUM	; ensure above values are correct

	dd mboot		; location of this descriptor
	dd code			; start of .text (code) section
	dd bss			; start of .data section
	dd end			; end of kernel
	dd start		; kernel entry point (initial EIP)

[SECTION .text]
[GLOBAL start]			; entry point
[EXTERN kernel_main]		; C entry point
start:
	; load multiboot information
	push esp
	push ebx

	; execute kernel
	call kernel_main
	cli
	hlt
	jmp $			; enter infinite loop so processor doesn't
				; try executing junk values in memory

; set size of the _start symbol to the current location '.' minus its start
; .size _start, . -_start
