BOOTLOADER_FOLDER = bootloader
BOOTLOADER_FILE = bootloader.asm
BOOTLOADER_PATH = $(BOOTLOADER_FOLDER)/$(BOOTLOADER_FILE)

BIN_FOLDER = bin
BIN_FILE = boot.bin
BIN_PATH = $(BIN_FOLDER)/$(BIN_FILE)


IMG_FOLDER = img
IMG_FILE = os.img
IMG_PATH = $(IMG_FOLDER)/$(IMG_FILE)

all:
	nasm $(BOOTLOADER_PATH) -f bin -o $(BIN_PATH)
	dd if=/dev/zero of=$(IMG_PATH) bs=512 count=2880
	dd if=$(BIN_PATH) of=$(IMG_PATH) bs=512 seek=0

run: all
	qemu-system-x86_64 -drive format=raw,file=$(BIN_PATH)

clean:
	rm -rf $(BIN_PATH)
	rm -rf $(IMG_PATH)

re: clean all

.PHONY: all clean re