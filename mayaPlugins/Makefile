# When the following line is present, the linking of plugins will
# occur much faster. If you link transitively (the default) then
# a number of "ld Warning 85" messages will be printed by ld.
# They are expected, and can be safely ignored.
NO_TRANS_LINK = 

# edit this if your maya installation is somewhere else.
MAYA_LOCATION = ${BFD_DEV_ROOT}/SDK/Maya/linux_x64_gcc41_maya2015ext1sp5

INSTALL_LOCATION = .


C++	 		= g++
CFLAGS	 	= -O3 -pipe -D_BOOL -DREQUIRE_IOSTREAM -fPIC
C++FLAGS	= $(CFLAGS) $(WARNFLAGS)

INCLUDES	= -I. -I.. -I$(MAYA_LOCATION)/include 
LD	 = $(C++) -shared $(NO_TRANS_LINK) $(C++FLAGS)

# add more libs if you need to for your plugin
LIBS	 	= -L$(MAYA_LOCATION)/lib -lOpenMaya

# standard stuff: tells the make program how to deal with different file types
.SUFFIXES: .cpp .cc .o .so .c

.cc.o:
$(C++) -c $(INCLUDES) $(C++FLAGS) $<

.cpp.o:
$(C++) -c $(INCLUDES) $(C++FLAGS) $<

.cc.i:
$(C++) -E $(INCLUDES) $(C++FLAGS) $*.cc > $*.i

.cc.so:
-rm -f $@
$(LD) -o $@ $(INCLUDES) $< $(LIBS)

.cpp.so:
-rm -f $@
$(LD) -o $@ $(INCLUDES) $< $(LIBS) 

.o.so:
-rm -f $@
$(LD) -o $@ $< $(LIBS) 


plugin.so: plugin.o 
-rm -f $@
$(LD) -o $@ plugin.o $(LIBS)


depend:
makedepend $(INCLUDES) -I/usr/include/CC *.cc

clean:
-rm -f *.o

Clean:
-rm -f *.o *.so *.bak

# this line installs the plugin into the maya directory.
# you could also just put it in your user maya directory, load it by hand, etc.
install: plugin.so 
cp plugin.so $(INSTALL_LOCATION)