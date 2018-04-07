# To be sure any GNUISM's dont't accidentally
# creep in, be sure to test the Makefile with
# different implementations of `make`, e.g
# `bmake` (BSD Make) or `pmake` (NETBSD Make)
CPP=cpp
CPP_ARGS=-P -DENABLE_ALL_BACKENDS=1
RM=rm
SED=sed
CHMOD=chmod
PROJECT=nougat

all: clean prepare

clean:
	$(RM) -f $(PROJECT)

prepare: $(PROJECT).in backends/backends.in backends/*/*
	$(CPP) $(CPP_ARGS) $(PROJECT).in -o $(PROJECT)
	$(SED) -i 's/##/#/g' $(PROJECT)
	$(CHMOD) +x $(PROJECT)
