all: main.hex

clean:
	rm -f *.o *.lst *.asm firmware.hex firmware.cod

main.hex: main.o interrupt.o timer.o digin.o digout.o config.o
	sdcc -mpic16 -p18f452 -o firmware.hex $^

#main.hex: main.o interrupt.o timer.o digital_input.o
#	sdcc -o main.hex $^ | more

.SUFFIXES: .c .o

%.o:%.c
	sdcc -c -mpic16 -p18f452 $^
        












