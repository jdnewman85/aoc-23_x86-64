ASM := fasm
ASM_EXT := asm

BINS := first aoc_day1_p1
BINS_FULL_PATH := $(foreach item,$(BINS),./$(item))

#fg/bg?
WHT := "\\e[29m"
BLK := "\\e[30m"

RED := "\\e[31m"
GRN := "\\e[32m"
YLW := "\\e[33m"
BLU := "\\e[34m"
PRP := "\\e[35m"
CYN := "\\e[36m"

RST := "\\e[0m"

all: $(BINS)

% : %.$(ASM_EXT)
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(GRN)Building$(RST) '$(YLW)$<$(GRN)'\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
	$(ASM) $<

test_aoc_day1_p1: aoc_day1_p1
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(CYN)Testing$(RST) '$(YLW)$<$(CYN)'\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
	@printf "$(YLW)'$<'$(RST) return value: $(GRN)%s$(RST)\n" $(shell ./aoc_day1_p1; echo $$?)

clean:
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(RED)Cleaning$(RED)\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
	rm $(BINS_FULL_PATH)
