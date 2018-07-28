
CPP=cpp
CPP_ARGS=-P
RM=rm
SED=sed
CHMOD=chmod
MKDIR=mkdir
INSTALL=install
BUILDPREFIX=build/
PROJECT=nougat
XDG_CONFIG_HOME="$(HOME)/.config"
XDG_DATA_HOME="$(HOME)/.local"
PREFIX="$(XDG_DATA_HOME)"

all: clean prepare

clean:
	$(RM) -rf $(BUILDPREFIX)

prepare: $(PROJECT).in
	$(MKDIR) -p build
	$(CPP) $(CPP_ARGS) $(PROJECT).in -o $(BUILDPREFIX)$(PROJECT)
	$(SED) -i 's/##/#/g' $(BUILDPREFIX)$(PROJECT)
	$(CHMOD) +x $(BUILDPREFIX)$(PROJECT)

install: all
	$(INSTALL) -d "$(PREFIX)/bin"
	$(INSTALL) -m775 "$(PROJECT)" "$(PREFIX)/bin/$(PROJECT)"
