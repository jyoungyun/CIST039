as -g -alh -mfpu=vfpv4 -o %e.o %e.s > %e.lst ; gcc -z noexecstack -g -o %e %e.o
