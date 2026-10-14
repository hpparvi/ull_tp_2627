# Solutions to the Lecture 3 exercises
#
#   make        compile all the programs
#   make test   run each program
#   make clean  remove the executables
#
# The palindrome program reads from standard input. The test target feeds
# it a few numbers with printf, including one that is not an integer.

FC = gfortran
FCFLAGS = -Wall -fcheck=all -std=f2008
PROGRAMS = l0301_matmul l0302_palindrome

all: $(PROGRAMS)

%: %.f90
	$(FC) $(FCFLAGS) -o $@ $<

test: all
	./l0301_matmul
	printf '12321\n' | ./l0302_palindrome
	printf '12345\n' | ./l0302_palindrome
	printf 'abc\n1999999999\n' | ./l0302_palindrome
	printf '0\n' | ./l0302_palindrome
	printf -- '-121\n' | ./l0302_palindrome

clean:
	rm -f $(PROGRAMS) *.o *.mod

.PHONY: all test clean
