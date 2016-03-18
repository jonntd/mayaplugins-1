
MAYA_LOCATION = ../../../repo/pipeline/SDK/Maya/linux_x64_gcc41_maya2015ext1sp6

INSTALL_LOCATION = .

PLUGIN_NAME = plugin.so


CC    			= gcc
CFLAGS        	= -I. -I$(MAYA_LOCATION)/include -D_BOOL -DREQUIRE_IOSTREAM -fPIC -D_DEBUG
LDFLAGS			= -shared -L$(MAYA_LOCATION)/lib -lm -lOpenMaya -lOpenMayaUI -lFoundation -lOpenMayaAnim -lm


all : $(PLUGIN_NAME)

$(PLUGIN_NAME) : plugin.o PoseSpaceCommand.o PoseSpaceDeformer.o RelaxDeformer.o
	$(CC) $(LDFLAGS) -o $@ $^
	rm -f $^

PoseSpaceCommand.o : PSD/PoseSpaceCommand.cpp
	$(CC) $(CFLAGS) -c $< > $@

PoseSpaceDeformer.o : PSD/PoseSpaceDeformer.cpp
	$(CC) $(CFLAGS) -c $< > $@

RelaxDeformer.o : Relax/RelaxDeformer.cpp
	$(CC) $(CFLAGS) -c $< > $@

.cpp.o:
	$(CC) $(CFLAGS) -c $< > $@

clean:
	rm -f $(PLUGIN_NAME) *.bak *.o

install:
	cp $(PLUGIN_NAME) $(INSTALL_LOCATION)