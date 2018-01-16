# Makefile that will build the SNES Neko Cradle

# determine which version to build
ifneq ($(BUILD),debug)
    BUILD = release
endif

# Assembler and linker
AS 		= ca65
ASFLAGS	= -I $(SRCDIR)/$(INCDIR) -s --cpu 65816
LD		= ld65
LDFLAGS = -C MemoryMap.cfg

# Directories
SRCDIR	 = src
OBJDIR	 = obj
INCDIR	 = include
BUILDDIR = build/$(BUILD)

# Sources
SOURCES = $(shell find $(SRCDIR)/ -maxdepth 2 -name '*.s' -printf '%f\n')
OBJECTS	= $(patsubst %.s, $(OBJDIR)/%.o, $(SOURCES))
EXECUTABLE = $(BUILDDIR)/NekoCradle.smc

all: dir $(EXECUTABLE)

debug: $(ASFLAGS) += -g
debug: dir $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.s
	$(AS) $(ASFLAGS) -o $@ $<

.PHONY: clean
clean:
	@rm -f $(OBJECTS)
	@rm -f $(EXECUTABLE)

dir:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BUILDDIR)
