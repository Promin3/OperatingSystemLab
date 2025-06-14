#########################################################################
# Copyright (C) 2001-2021  The Bochs Project
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
#########################################################################

.SUFFIXES: .cc

srcdir = .

top_builddir    = ..
top_srcdir      = ..

SHELL = /bin/bash



CC = gcc
CFLAGS = -g -O2 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES   $(X_CFLAGS)
CXX = g++
CXXFLAGS = -g -O2 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES   $(X_CFLAGS)

LDFLAGS = 
LIBS = 
RANLIB = ranlib

# Definitely use flex.  Use flex version >= 2.5.4
# Flex version 2.5.2 was reported not to work
LEX    = flex
YACC   = yacc


# ===========================================================
# end of configurable options
# ===========================================================


BX_OBJS = \
  dbg_main.o \
  dbg_breakpoints.o \
  symbols.o \
  linux.o \

BX_PARSER_OBJS = \
  parser.o \
  lexer.o

BX_INCLUDES = debug.h

BX_INCDIRS = -I.. -I$(srcdir)/.. -I../instrument/stubs -I$(srcdir)/../instrument/stubs -I. -I$(srcdir)/.

all: libdebug.a

.cc.o:
	$(CXX) -c $(BX_INCDIRS) $(CXXFLAGS) $< -o $@


.c.o:
	$(CC) -c $(BX_INCDIRS) $(CFLAGS) $< -o $@



libdebug.a: $(BX_OBJS) $(BX_PARSER_OBJS)
	rm -f  libdebug.a
	ar rv $@ $(BX_OBJS) $(BX_PARSER_OBJS)
	$(RANLIB) libdebug.a

$(BX_OBJS): $(BX_INCLUDES)


clean:
	rm -f  *.o
	rm -f  libdebug.a

dist-clean: clean
	rm -f  Makefile

parse-clean:
	rm -f  -f  lexer.c
	rm -f  -f  parser.cc
	rm -f  -f  parser.h

dbg_main.o: debug.h

parser.cc: parser.y
	@/bin/rm -f y.tab.c parser.cc
	@/bin/rm -f y.tab.h parser.h
	$(YACC) -p bx -d $<
	@/bin/mv -f y.tab.c parser.cc
	@/bin/mv -f y.tab.h parser.h
	@sed -i s/extern\ YYSTYPE/extern\ \"C\"\ YYSTYPE/ parser.cc
	@echo '#endif  /* if BX_DEBUGGER */' >> parser.cc
	@echo '/* The #endif is appended by the makefile after running yacc. */' >> parser.cc

lexer.c: lexer.l
	$(LEX) -Pbx -t $< > lexer.c

###########################################
# dependencies generated by
#  gcc -MM -I. -I.. -I../instrument/stubs *.c  *.cc | sed 's/\.cc/.cc/g'
###########################################
lexer.o: lexer.c debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 parser.h
parser.o: parser.cc debug.h ../config.h ../osdep.h \
 ../cpu/decoder/decoder.h
dbg_breakpoints.o: dbg_breakpoints.cc ../bochs.h ../config.h ../osdep.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../gui/paramtree.h ../logio.h \
 ../instrument/stubs/instrument.h
dbg_main.o: dbg_main.cc ../bochs.h ../config.h ../osdep.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../gui/paramtree.h ../logio.h \
 ../instrument/stubs/instrument.h ../param_names.h ../cpu/cpu.h \
 ../cpu/decoder/decoder.h ../cpu/i387.h ../cpu/fpu/softfloat.h \
 ../cpu/fpu/tag_w.h ../cpu/fpu/status_w.h ../cpu/fpu/control_w.h \
 ../cpu/crregs.h ../cpu/descriptor.h ../cpu/decoder/instr.h \
 ../cpu/lazy_flags.h ../cpu/tlb.h ../cpu/icache.h ../cpu/apic.h \
 ../cpu/xmm.h ../cpu/vmx.h ../cpu/svm.h ../cpu/cpuid.h ../cpu/access.h \
 ../cpu/decoder/ia_opcodes.h ../cpu/decoder/ia_opcodes.def \
 ../iodev/iodev.h ../plugin.h ../extplugin.h ../pc_system.h \
 ../memory/memory-bochs.h ../gui/siminterface.h ../gui/paramtree.h \
 ../gui/gui.h
linux.o: linux.cc ../bochs.h ../config.h ../osdep.h ../bx_debug/debug.h \
 ../config.h ../osdep.h ../cpu/decoder/decoder.h ../gui/paramtree.h \
 ../logio.h ../instrument/stubs/instrument.h ../cpu/cpu.h \
 ../cpu/decoder/decoder.h ../cpu/i387.h ../cpu/fpu/softfloat.h \
 ../cpu/fpu/tag_w.h ../cpu/fpu/status_w.h ../cpu/fpu/control_w.h \
 ../cpu/crregs.h ../cpu/descriptor.h ../cpu/decoder/instr.h \
 ../cpu/lazy_flags.h ../cpu/tlb.h ../cpu/icache.h ../cpu/apic.h \
 ../cpu/xmm.h ../cpu/vmx.h ../cpu/svm.h ../cpu/cpuid.h ../cpu/access.h \
 syscalls-linux.h
symbols.o: symbols.cc ../bochs.h ../config.h ../osdep.h \
 ../bx_debug/debug.h ../config.h ../osdep.h ../cpu/decoder/decoder.h \
 ../gui/paramtree.h ../logio.h \
 ../instrument/stubs/instrument.h ../cpu/cpu.h ../cpu/decoder/decoder.h \
 ../cpu/i387.h ../cpu/fpu/softfloat.h ../cpu/fpu/tag_w.h \
 ../cpu/fpu/status_w.h ../cpu/fpu/control_w.h ../cpu/crregs.h \
 ../cpu/descriptor.h ../cpu/decoder/instr.h ../cpu/lazy_flags.h \
 ../cpu/tlb.h ../cpu/icache.h ../cpu/apic.h ../cpu/xmm.h ../cpu/vmx.h \
 ../cpu/svm.h ../cpu/cpuid.h ../cpu/access.h
