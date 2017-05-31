# =============================================================================================
# Makefile
# makefile should be in the project root directory
# Put external headers in the following folder:
# C:\Program_Files\mingw-w64\x86_64-6.3.0-posix-sjlj-rt_v5-rev2\mingw64\x86_64-w64-mingw32\include
# =============================================================================================
CC 			:= g++
PROJDIR		:= $(shell pwd)
SRCDIR 		:= src
BUILDDIR	:= build
TARGET		:= bin/runner
SRCEXT 		:= cpp
ALLSRCS 	:= $(wildcard $(SRCDIR)/*.$(SRCEXT))
EXCLSRCS	:=
FILTSRCS	:= $(filter-out $(EXCLSRCS),$(ALLSRCS))
OBJS		:= $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(FILTSRCS:.$(SRCEXT)=.o))
LIBS		:= # -L
CPPFLAGS	:= -Wall
CFLAGS		:=
CXXFLAGS	:= -std=c++11
INC			:= -I inc

# =============================================================================================

# To search in subfolders within SRCDIR use this function
# usgae: SOURCES := $(call RECURSIVEWILDCARD,$(SRCDIR)/,*.$(SRCEXT))
# RECURSIVEWILDCARD=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call RECURSIVEWILDCARD,$d/,$2))

$(shell mkdir -p $(BUILDDIR))

default : $(TARGET)

$(TARGET) : $(OBJS)
	@echo Building target: $@
	$(CC) $(OBJS) -o $(TARGET) $(LIBS)
	@echo Finished building target: $@
	@echo ''

$(BUILDDIR)/%.o : $(SRCDIR)/%.cpp
	@echo Building file: $<
	$(CC) $(CPPFLAGS) $(CFLAGS) $(CXXFLAGS) $(INC) -MD -c $< -o $@
	@cp $(BUILDDIR)/$*.d $(BUILDDIR)/$*.P
	@sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' -e '/^$$/ d' -e 's/$$/ :/' < $(BUILDDIR)/$*.d >> $(BUILDDIR)/$*.P;
	@rm -f $(BUILDDIR)/$*.d
	@echo Finished building file: $<
	@echo ''

clean :
	rm -rf build bin/*

output_vars :
	@echo CC: 			$(CC)
	@echo PROJDIR:		$(PROJDIR)
	@echo SRCDIR: 		$(SRCDIR)
	@echo BUILDDIR: 	$(BUILDDIR)
	@echo TARGET: 		$(TARGET)
	@echo SRCEXT: 		$(SRCEXT)
	@echo ALLSRCS: 		$(ALLSRCS)
	@echo EXCLSRCS:		$(EXCLSRCS)
	@echo FILTSRCS:		$(FILTSRCS)
	@echo OBJS: 		$(OBJS)
	@echo CPPFLAGS:		$(CPPFLAGS)
	@echo CXXFLAGS: 	$(CXXFLAGS)
	@echo INC: 			$(INC)

-include $(BUILDDIR)/*.P
