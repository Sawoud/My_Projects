# this makefile is intended for g++ on Linux

CC = g++
# CFLAGS = -c -Wall -Wpedantic
CFLAGS = -c -g -O3
LDFLAGS = -pthread 
SOURCES = experiment.cpp iofunc.cpp filterRDS.cpp  fmPll.cpp  fourier.cpp  genfunc.cpp  logfunc.cpp
OBJECTS = $(SOURCES:.cpp=.o)
EXECUTABLE = experiment

all: $(EXECUTABLE) clean

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	-rm $(OBJECTS)
