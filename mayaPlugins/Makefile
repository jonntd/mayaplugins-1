
MAYA_LOCATION = ../../../repo/pipeline/SDK/Maya/linux_x64_gcc41_maya2015ext1sp6

INSTALL_LOCATION = .

PLUGIN_NAME = plugin.so


SOURCES = plugin.cpp PSD/PoseSpaceDeformer.cpp Relax/RelaxDeformer.cpp



CC    			= gcc
CFLAGS        	= -I. -I$(MAYA_LOCATION)/include -D_BOOL -DREQUIRE_IOSTREAM -fPIC
LDFLAGS			= -shared -L$(MAYA_LOCATION)/lib -lm -lOpenMaya -lOpenMayaUI -lFoundation -lOpenMayaAnim -lm

OBJECTS = $(SOURCES:.cpp=.o)

all : $(PLUGIN_NAME)

$(PLUGIN_NAME) : $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^
	rm -f $^

.cpp.o:
	$(CC) $(CFLAGS) -c $< > $@

clean:
	rm -f $(PLUGIN_NAME) $(OBJECTS) *.bak *.o

install:
	cp $(PLUGIN_NAME) $(INSTALL_LOCATION)