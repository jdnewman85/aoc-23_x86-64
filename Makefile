ASM = fasm
ASM_EXT = asm

BINS = first aoc_day1_p1

all: $(BINS)

% : %.$(ASM_EXT)
	@printf -- '-%.0s' {1..79}
	@printf '\n'
	@printf "Building '$<'\n" %
	@printf -- '-%.0s' {1..79}
	@printf '\n'
	$(ASM) $<

clean:
	rm $(BINS)
