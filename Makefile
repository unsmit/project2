# Makefile for CS320 Project 2 - FOOTv8 Pipeline Simulator

CDIR = ./code  # Allows multiple versions of code in different subdirectories

# This Makefile assumes you are in a directory with the following sub-directories:
#    $(CDIR) ./code by default where all your code resides
#    ./init_mem where all the example input initial memory value files are provided to you
#    ./results where results are saved
#    ./correct_logs where the correct results provided to you reside


# Define which initial memory value file should be used in the simple tests
TCASE=c2f_0

test : checkBuild
	./sim init_mem/$(TCASE).txt | tee results/$(TCASE)_log.txt
	@if [ -f correct_logs/$(TCASE)_log.txt ]; then \
	cat ./compLog | bash -s -- correct_logs/$(TCASE)_log.txt results/$(TCASE)_log.txt; \
	fi
	
gdb : checkBuild
	gdb -ex 'set args init_mem/$(TCASE).txt)' ./sim
	
checkMem : checkBuild
	valgrind --leak-check=full ./sim init_mem/$(TCASE).txt
	
checkBuild :  
	make --directory $(CDIR) ../sim 2>&1 | tee compileMsgs.txt	

# Get a list of all cases for the full test
CASES := $(notdir $(wildcard init_mem/*.txt))
RESULTS := $(addprefix results/,$(CASES:.txt=_log.txt))

show :
	@echo CASES=$(CASES)
	@echo RESULTS=$(RESULTS)

fullTest : checkBuild $(RESULTS)

# Implicit rules to make results and check those results if possible
results/%_log.txt  :  init_mem/%.txt
	./sim init_mem/$*.txt | tee results/$*_log.txt  
	@if [ -f correct_logs/$*_log.txt ]; then \
	cat ./compLog | bash -s -- correct_logs/$*_log.txt results/$*_log.txt; \
	fi

submit : 
	make --directory $(CDIR) clean # clean up the code directory first
	tar -cvzf proj2_code.tar.gz $(CDIR) # Tar up whatever is in the code directory
	
clean : 
	make --directory $(CDIR) clean
	-rm results/*_log.txt compileMsgs.txt
