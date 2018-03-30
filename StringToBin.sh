#!/bin/bash
# This script will create a bootable kernel from user input
NASM="$(which nasm)"
if [ ! -f "${NASM}" ]; then
    echo "Please install \'nasm\' before running this script."; 
    exit 1;
fi
    
echo "Enter the text to be displayed in textOS, followed by [ENTER]:"

read text

for (( i = 0 ; i < ${#text} ; i++ )); do array[i]=${text:i:1}; done

echo "mov ah, 0x0e" > kernel.asm

for ((i = 0; i < ${#text} ; i++ )); do echo "mov al, '"${array[i]}"'" >> kernel.asm; echo "int 0x10" >> kernel.asm; done

echo "" >> kernel.asm
echo "jmp $" >> kernel.asm
echo "" >> kernel.asm
echo 'times 510 - ($-$$) db 0' >> kernel.asm
echo "dw 0xaa55" >> kernel.asm

nasm -fbin kernel.asm -o kernel.bin

echo "Created kernel.bin."

QEMU="$(which qemu-system-x86_64)"
if [ -f "${QEMU}" ]; then
    echo "Qemu is installed.";
    echo "To preview your kernel, run qemu-system-x86_64 kernel.bin"
else
    echo "Qemu is not installed";
    echo "To preview your kernel, install Qemu and run qemu-system-x86_64 kernel.bin";
fi
