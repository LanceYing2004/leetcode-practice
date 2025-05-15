## EECS 281 Advanced Makefile

# Bash is needed for project identifier logic
SHELL = /bin/bash

# How to use this Makefile...
###################
###################
##               ##
##  $ make help  ##
##               ##
###################
###################

# IMPORTANT NOTES:
#   1. Set EXECUTABLE to the command name from the project specification.
#   2. To enable automatic creation of unit test rules, your program logic
#      (where main() is) should be in a file named project*.cpp or
#      specified in the PROJECTFILE variable.
#   3. Files you want to include in your final submission cannot match the
#      test*.cpp pattern.

#######################
# TODO (begin) #
#######################
# Change 'youruniqname' to match your UM uniqname (no quote marks).
UNIQNAME    = lanying

# Change the right hand side of the identifier to match the project identifier
# given in the project or lab specification.
IDENTIFIER  = EEC50281EEC50281EEC50281EEC50281EEC50281

# Change 'executable' to match the command name given in the project spec.
EXECUTABLE  = test

# The following line looks for a project's main() in files named project*.cpp,
# executable.cpp (substituted from EXECUTABLE above), or main.cpp
PROJECTFILE = $(or $(wildcard project*.cpp $(EXECUTABLE).cpp), main.cpp)
# If main() is in another file delete line above, edit and uncomment below
#PROJECTFILE = mymainfile.cpp

# List additional project source files here (besides auto-detected .cpp files)
# Add your own .cpp filenames separated by spaces, for example:
#    EXTRA_SRCS = foo.cpp bar.cpp
EXTRA_SRCS = test.cpp

# This is the path from the CAEN home folder to where projects will be
# uploaded. (eg. /home/mmdarden/eecs281/project1)
# Change this if you prefer a different path.
REMOTE_PATH := eecs281_$(EXECUTABLE)_sync
#######################
# TODO (end) #
#######################

# enables c++17 on CAEN or 281 autograder
PATH := /usr/um/gcc-11.3.0/bin:$(PATH)
LD_LIBRARY_PATH := /usr/um/gcc-11.3.0/lib64
LD_RUN_PATH := /usr/um/gcc-11.3.0/lib64

# disable built-in rules
.SUFFIXES:

# designate which compiler to use
CXX         = g++

# rule for creating objects
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $*.cpp

# list of test drivers (with main()) for development
# exclude any EXTRA_SRCS files (they are project sources)
TESTSOURCES = $(filter-out $(EXTRA_SRCS),$(wildcard test*.cpp))
TESTSOURCES := $(filter-out $(PROJECTFILE),$(TESTSOURCES))

# list of sources used in project (including extras)
SOURCES     = $(sort $(wildcard *.cpp) $(EXTRA_SRCS))
SOURCES     := $(filter-out $(TESTSOURCES), $(SOURCES))
# list of objects used in project
OBJECTS     = $(SOURCES:%.cpp=%.o)

# Default Flags
CXXFLAGS = -std=c++17 -Wconversion -Wall -Wextra -pedantic

# make debug - will compile sources with $(CXXFLAGS) -g3 and -fsanitize
#              flags also defines DEBUG and _GLIBCXX_DEBUG
debug: CXXFLAGS += -g3 -DDEBUG -fsanitize=address -fsanitize=undefined -D_GLIBCXX_DEBUG
debug:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(EXECUTABLE)_debug
.PHONY: debug

# make release - compile with -O3 and NDEBUG defined
release: CXXFLAGS += -O3 -DNDEBUG
release: $(EXECUTABLE)
.PHONY: release

# make valgrind - compile with -g3 for memory checks
valgrind: CXXFLAGS += -g3
valgrind:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(EXECUTABLE)_valgrind
.PHONY: valgrind

# make profile - compile with -g3 for profiling
profile: CXXFLAGS += -g3
profile:
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $(EXECUTABLE)_profile
.PHONY: profile

# make static - perform static analysis (cppcheck)
static:
	cppcheck --enable=all --suppress=missingIncludeSystem \
      $(SOURCES) *.h *.hpp
.PHONY: static

# Build all executables\all: debug release profile valgrind
all: debug release profile valgrind
.PHONY: all

# link main executable
$(EXECUTABLE): $(OBJECTS)
ifneq ($(EXECUTABLE), executable)
	$(CXX) $(CXXFLAGS) $(OBJECTS) -o $(EXECUTABLE)
else
	@echo Edit EXECUTABLE variable in Makefile.
	@echo Using default a.out.
	$(CXX) $(CXXFLAGS) $(OBJECTS)
endif

# names of test executables
TESTS       = $(TESTSOURCES:%.cpp=%)
# Automatically generate build rules for test*.cpp files
define make_tests
    ifeq ($$(PROJECTFILE),)
	    @echo Edit PROJECTFILE variable to .cpp file with main\(\)
	    @exit 1
    endif
    SRCS = $$(filter-out $$(PROJECTFILE), $$(SOURCES))
    OBJS = $$(SRCS:%.cpp=%.o)
    HDRS = $$(wildcard *.h *.hpp)
    $(1): CXXFLAGS += -g3 -DDEBUG
    $(1): $$(OBJS) $$(HDRS) $(1).cpp
	$$(CXX) $$(CXXFLAGS) $$(OBJS) $(1).cpp -o $(1)
endef
$(foreach test, $(TESTS), $(eval $(call make_tests, $(test))))

alltests: $(TESTS)
.PHONY: alltests

# make clean - remove artifacts
clean:
	rm -Rf *.dSYM
	rm -f $(OBJECTS) $(EXECUTABLE) $(EXECUTABLE)_debug
	rm -f $(EXECUTABLE)_valgrind $(EXECUTABLE)_profile $(TESTS) perf.data* \
      fullsubmit.tar.gz partialsubmit.tar.gz ungraded.tar.gz
.PHONY: clean

# Submission tarballs and identifier rules...

# Files that should not be included in a tarball
EXCLUDE_FILES = getopt.\?

# get a list of all files that might be included in a submit
FULL_SUBMITFILES=$(filter-out $(wildcard test*.cpp), \
                   $(wildcard Makefile *.h *.hpp *.cpp test*.txt))

# make fullsubmit.tar.gz - cleans, creates tarball including test files
$(FULL_SUBMITFILE): $(FULL_SUBMITFILES)
	rm -f $(PARTIAL_SUBMITFILE) $(FULL_SUBMITFILE) $(UNGRADED_SUBMITFILE)
	COPYFILE_DISABLE=true tar --exclude=$(EXCLUDE_FILES) -vczf $(FULL_SUBMITFILE) $(FULL_SUBMITFILES)
	@echo !!! Final submission prepared, test files included... READY FOR GRADING !!!

# make partialsubmit.tar.gz - cleans, creates tarball omitting test files
PARTIAL_SUBMITFILES=$(filter-out $(wildcard test*.txt), $(FULL_SUBMITFILES))
$(PARTIAL_SUBMITFILE): $(PARTIAL_SUBMITFILES)
	rm -f $(PARTIAL_SUBMITFILE) $(FULL_SUBMITFILE) $(UNGRADED_SUBMITFILE)
	COPYFILE_DISABLE=true tar --exclude=$(EXCLUDE_FILES) -vczf $(PARTIAL_SUBMITFILE) \
      $(PARTIAL_SUBMITFILES)
	@echo !!! WARNING: No test files included. Use 'make fullsubmit' to include test files. !!!

# make ungraded.tar.gz - cleans, creates tarball omitting test files, Makefile
UNGRADED_SUBMITFILES=$(filter-out Makefile, $(PARTIAL_SUBMITFILES))
$(UNGRADED_SUBMITFILE): $(UNGRADED_SUBMITFILES)
	rm -f $(PARTIAL_SUBMITFILE) $(FULL_SUBMITFILE) $(UNGRADED_SUBMITFILE)
	@touch __ungraded
	COPYFILE_DISABLE=true tar --exclude=$(EXCLUDE_FILES) -vczf $(UNGRADED_SUBMITFILE) \
      $(UNGRADED_SUBMITFILES) __ungraded
	@rm -f __ungraded
	@echo !!! WARNING: This submission will not be graded. !!!

# shortcut for make submit tarballs
fullsubmit: identifier $(FULL_SUBMITFILE)
partialsubmit: identifier $(PARTIAL_SUBMITFILE)
ungraded: identifier $(UNGRADED_SUBMITFILE)
.PHONY: fullsubmit partialsubmit ungraded

# REMOTE_PATH has default definition above
sync2caen:
ifeq ($(UNIQNAME), youruniqname)
	@echo Edit UNIQNAME variable in Makefile.
	@exit 1;
endif
	# Synchronize local files into target directory on CAEN
	rs
