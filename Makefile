ifeq ($(shell uname),Linux)
OS                     = linux
else
OS                     = win64
endif

Packages 		       = \
	                      NWTC \

Empty                  =
Space                  = $(Empty) $(Empty)
temproot               = $(subst /Source,$(Space),$(CURDIR))
DEV_ROOT               = $(word 1,$(temproot))
LibraryDir             = $(DEV_ROOT)/../../Librarys

ObjectFiles            = $(wildcard Object/$(OBJMID)/*/*.o) 
MainProg               = main.c

PackageListLoop        = $(patsubst %,Source/%/.loop,$(Packages))

ifeq ($(OS),win32)
OBJMID                 = win32
LinkerOption           = $(CLIBS) -lgsl -lgslcblas
makelinux:
	@echo "Start Make Window32"
endif

ifeq ($(OS),win64)
OBJMID                 = win64
Main                   = aeroservo.exe
LinkerOption           = $(CLIBS)
LEXTRAOPTION           = -L$(LibraryDir)/common/$(OBJMID)/lib -lcommon
makelinux:
	@echo "Start Make Window64"
endif
ifeq ($(OS),linux)
OBJMID                 = linux
Main                   = aeroservo
LinkerOption           = `pkg-config --cflags --libs gtk+-3.0 gmodule-2.0`
LEXTRAOPTION           = -L$(LibraryDir)/common/$(OBJMID)/lib -lcommon -lcurl
COPTION                = `pkg-config --cflags --libs gtk+-3.0 gmodule-2.0`
makelinux:
	@echo "Start Make Linux"

endif
CEXTRAOPTION           = -I$(LibraryDir)/common/$(OBJMID)/include

%.loop:
	@$(MAKE) $(MakeOptions) -C $(subst .loop,,$@) -f Make package_$(MAKECMDGOALS)

build: makelinux $(PackageListLoop)
	@echo "End Make"

clean: $(PackageListLoop)
