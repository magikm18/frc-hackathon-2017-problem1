SRC_FILES := $(wildcard src/*.s)
OBJ_FILES := $(addprefix obj/,$(notdir $(SRC_FILES:.s=.o)))

.PHONY: all

obj/%.o: src/%.s
	as -o $@ $< --gstabs+

bin/problem1: $(OBJ_FILES)
	gcc $(OBJ_FILES) -o $@ -static
	chmod +x $@

all: bin/problem1

clean:
	rm -f bin/problem1 $(wildcard obj/*.o)
