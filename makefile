# Makefile that will build the SNES Neko Cradle

# determine which version to build
ifneq ($(BUILD),debug)
    BUILD = release
endif

# Assembler and Linker
AS 		= ca65
ASFLAGS	= --cpu 65816 -s $(INCARGS)
LD		= ld65
LDFLAGS = -C MemoryMap.cfg --obj-path $(OBJDIR)/

# Directories
SRCDIR	 = src
OBJDIR	 = obj
BUILDDIR = build/$(BUILD)

# Make does not offer a recursive wildcard function, so here's one:
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# Generate include directories list
INCLUDES := $(call rwildcard,$(SRCDIR)/,*.inc)
INCDIRS	 := $(sort $(dir $(INCLUDES)))
INCARGS  := $(foreach inc, $(INCDIRS),-I $(inc))

# Sources
SOURCES	:= $(call rwildcard,$(SRCDIR)/,*.s)	# list all source files
SSRC	:= $(notdir $(SOURCES))				# remove file paths
SOBJ	:= $(patsubst %.s, $(OBJDIR)/%.o, $(SSRC))
vpath %.s $(dir $(SOURCES))					# add source directories to vpath

# Recipes
EXECUTABLE = $(BUILDDIR)/NekoCradle.smc

all: dir $(EXECUTABLE)

debug: $(ASFLAGS) += -g
debug: dir $(EXECUTABLE)

$(EXECUTABLE): $(SOBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR)/%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

.PHONY: clean
clean:
	@rm -f $(OBJDIR)/*.o
	@rm -f $(EXECUTABLE)

dir:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BUILDDIR)
