all: main.hex

clean:
	rm -f *.o *.lst *.asm firmware.hex firmware.cod

main.hex: main.o interrupt.o timer.o digin.o digout.o config.o
	sdcc --use-non-free -mpic16 -p18f452 -o firmware.hex $^

.SUFFIXES: .c .o

%.o:%.c
	sdcc --use-non-free -c -mpic16 -p18f452 $^
        












