CFLAGS += -Iraylib-6.0/include/ -g3 -ggdb
LDFLAGS += -lm

RAYLIB = -Lraylib-6.0/lib -lGL -lraylib -Wl,-rpath raylib-6.0/lib

.PHONY: test
test: test_c test_asm

.PHONY: main
main: main_c main_asm

.PHONY: all
all: test main

.PHONY: run_c
run_c: main_c
	./main_c

.PHONY: run_asm
run_asm: main_asm
	./main_asm

.PHONY: run_test_c
run_test_c: test_c
	./test_c

.PHONY: run_test_asm
run_test_asm: test_asm
	./test_asm

.PHONY: valgrind_c
valgrind_c: test_c
	valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./test_c

.PHONY: valgrind_asm
valgrind_asm: test_asm
	valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./test_asm

.PHONY: clean
clean:
	rm -f main_c main_asm ej_asm.o test_c test_asm

main_c: main.c ej.c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) $(RAYLIB) -o $@

main_asm: main.c ej_asm.o
	$(CC) $(CFLAGS) $^ $(LDFLAGS) $(RAYLIB) -o $@

test_c: test.c ej.c
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

test_asm: test.c ej_asm.o
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

ej_asm.o: ej.asm
	nasm -felf64 -Fdwarf $^ -o $@
