# Copyright (C) 2001-2020  The Bochs Project
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

# Makefile for the BIOS component of bochs


.SUFFIXES: .cc

srcdir = .


SHELL = /bin/bash



CXX = g++
CXXFLAGS = -g -O2 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES 

LDFLAGS = 
LIBS = 
RANLIB = ranlib

BCC = bcc
GCC = gcc
GCC32 = gcc -m32 -march=i386 -fno-stack-protector
AS86 = as86
IASL = not_found

BX_INCDIRS = -I.. -I$(srcdir)/.. -I../iodev -I$(srcdir)/../iodev
LOCAL_CXXFLAGS =

UPSTREAM_RELEASE_DATE = $(shell grep "Updated:" ../README | sed 's/Updated://')
BUILDDATE = `date -u -d '$(UPSTREAM_RELEASE_DATE)' '+%m/%d/%y'`
BIOS_BUILD_DATE = "-DBIOS_BUILD_DATE=\"$(BUILDDATE)\""
#
# -------- end configurable options --------------------------
#


.cc.o:
	$(CXX) -c $(BX_INCDIRS) $(CXXFLAGS) $(LOCAL_CXXFLAGS) $< -o $@


bios: biossums BIOS-bochs-latest BIOS-bochs-legacy

clean:
	rm -f  *.o *.a *.s _rombios*_.c rombios*.txt rombios*.sym
	rm -f  acpt-dsdt.aml
	rm -f  usage biossums rombios16.bin
	rm -f  rombios32.bin rombios32.out

dist-clean: clean
	rm -f  Makefile

bios-clean:
	rm -f  BIOS-bochs-*

BIOS-bochs-legacy: rombios.c apmbios.S biossums rombios.h
	$(GCC32) $(BIOS_BUILD_DATE) -DLEGACY -E -P $< > _rombiosl_.c
	$(BCC) -o rombiosl.s -C-c -D__i86__ -0 -S _rombiosl_.c
	sed -e 's/^\.text//' -e 's/^\.data//' rombiosl.s > _rombiosl_.s
	$(AS86) _rombiosl_.s -b tmpl.bin -u- -w- -g -0 -j -O -l rombiosl.txt
	-perl ${srcdir}/makesym.perl < rombiosl.txt > rombiosl.sym
	mv tmpl.bin $@
	./biossums $@
	rm -f  _rombiosl_.s


rombios16.bin: rombios.c apmbios.S biossums rombios.h
	$(GCC32) $(BIOS_BUILD_DATE) -E -P $< > _rombios_.c
	$(BCC) -o rombios.s -C-c -D__i86__ -0 -S _rombios_.c
	sed -e 's/^\.text//' -e 's/^\.data//' rombios.s > _rombios_.s
	$(AS86) _rombios_.s -b tmp.bin -u- -w- -g -0 -j -O -l rombios.txt
	-perl ${srcdir}/makesym.perl < rombios.txt > rombios.sym
	mv tmp.bin rombios16.bin
	./biossums rombios16.bin
	rm -f  _rombios_.s

rombios32.bin: rombios32.out rombios.h
	objcopy -O binary $< $@
	./biossums -pad $@

rombios32.out: rombios32start.o rombios32.o rombios32.ld
	ld -o $@ -T $(srcdir)/rombios32.ld rombios32start.o rombios32.o

rombios32.o: rombios32.c acpi-dsdt.hex rombios.h
	$(GCC32) -O2 -Wall -c -o $@ $<

ifneq ($(IASL), not_found)
acpi-dsdt.hex: acpi-dsdt.dsl
	cpp -P $< $<.i
	iasl -tc -p $@ $<.i
	rm $<.i
	sed -i -e's/^unsigned/const unsigned/;s/ACPI-DSDT_HEX/ACPI_DSDT_HEX/g;s/acpi-dsdt_aml_code/AmlCode/g' $@
endif

rombios32start.o: rombios32start.S
	$(GCC32) -c -o $@ $<

BIOS-bochs-latest: rombios16.bin rombios32.bin
	cat rombios32.bin rombios16.bin > $@

biossums: biossums.o
