ASM := fasm
ASM_EXT := asm

SRC_DIR := ./src
OUT_DIR := ./bin

BINS := first aoc_day1_p1
#BINS_FULL_PATH := $(foreach item,$(BINS),./$(OUT_DIR)/$(item))

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

% : $(SRC_DIR)/%.$(ASM_EXT)
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(GRN)Building$(RST) '$(YLW)$<$(GRN)'\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
	$(ASM) $< $(OUT_DIR)/$@

#TODO Redo this as bash scripts that are individual tests
test_aoc_day1_p1_t1: aoc_day1_p1
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(CYN)Testing$(RST) '$(YLW)$(OUT_DIR)/$<$(CYN)'\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
	$(eval result := $(shell "$(OUT_DIR)/$<"; echo $$?))
	$(eval expected := "82")
	@if [ $(result) = $(expected) ]; then\
		printf "\t$(GRN)Pass!$(RST) | result($(GRN)$(result)$(RST)) == expected($(GRN)$(expected)$(RST))";\
	else\
		printf "\t$(RED)FAIL!$(RST) | result($(RED)$(result)$(RST)) != expected($(GRN)$(expected)$(RST))";\
	fi
	@printf "\n"

clean:
	@printf -- ' %.0s' {1..79}
	@printf '\n'
	@printf "$(RED)Cleaning$(RED)\n" %
	@printf -- '-%.0s' {1..79}
	@printf "$(RST)\n"
#	rm $(BINS_FULL_PATH)
	@rm -Iv $(OUT_DIR)/* || printf "$(YLW)Nothing to clean$(RST)\n"
