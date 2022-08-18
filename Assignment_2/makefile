a.out:	main.o libio.a
				gcc main.o -L. -lio

main.o: main.c myl.h
				gcc -Wall -c main.c

libio.a: myl.o
				ar -rcs libio.a myl.o

myl.o: ass2_20CS10038.c myl.h
				gcc -Wall -c -o myl.o ass2_20CS10038.c

clean:
				rm a.out main.o libio.a myl.o