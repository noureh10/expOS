IMG_PATH = img/os.img
BOOTLOADER_BIN = bin/bootloader.bin
KERNEL_BIN = bin/kernel.bin
IMG_FOLDER = img
OBJ_FOLDER = obj
BIN_FOLDER = bin

all: $(IMG_PATH)

$(IMG_PATH): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	mkdir -p $(IMG_FOLDER)
	dd if=/dev/zero of=$(IMG_PATH) bs=512 count=2880
	dd if=$(BOOTLOADER_BIN) of=$(IMG_PATH) bs=512 seek=0
	dd if=$(KERNEL_BIN) of=$(IMG_PATH) bs=512 seek=1

$(BOOTLOADER_BIN): bootloader/bootloader.asm
	mkdir -p $(BIN_FOLDER)
	nasm -f bin bootloader/bootloader.asm -o $(BOOTLOADER_BIN)

$(KERNEL_BIN): kernel/kernel.c linker.ld
	mkdir -p $(OBJ_FOLDER) $(BIN_FOLDER)
	gcc -m32 -ffreestanding -fno-pie -nostdlib -c kernel/kernel.c -o $(OBJ_FOLDER)/kernel.o
	ld -m elf_i386 -T linker.ld -o $(KERNEL_BIN) $(OBJ_FOLDER)/kernel.o --oformat binary

clean:
	rm -rf $(OBJ_FOLDER)/* $(BIN_FOLDER)/* $(IMG_FOLDER)/*

run: all
	qemu-system-x86_64 $(IMG_PATH) -boot c
