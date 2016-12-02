# Redis Makefile
# Copyright (C) 2009 Salvatore Sanfilippo <antirez at gmail dot com>
# This file is released under the BSD license, see the COPYING file

DEST_DIR = $(DESTDIR)/usr/local


uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
OPTIMIZATION?=-O2
ifeq ($(uname_S),SunOS)
  CFLAGS?= -std=c99 -pedantic $(OPTIMIZATION) -Wall -W -D__EXTENSIONS__ -D_XPG6
  CCLINK?= -ldl -lnsl -lsocket -lm -lpthread
else
  CFLAGS?= -std=c99 -pedantic $(OPTIMIZATION) -Wall -W $(ARCH) $(PROF)
  CCLINK?= -lm -pthread
endif
CCOPT= $(CFLAGS) $(CCLINK) $(ARCH) $(PROF)
DEBUG?= -g -rdynamic -ggdb 

OBJ = adlist.o ae.o anet.o dict.o medis.o sds.o zmalloc.o lzf_c.o lzf_d.o pqsort.o zipmap.o sha1.o
CHECKDUMPOBJ = medis-check-dump.o lzf_c.o lzf_d.o

PRGNAME = medis-server
CHECKDUMPPRGNAME = medis-check-dump

all: medis-server medis-check-dump install

# Deps (use make dep to generate this)
adlist.o: adlist.c adlist.h zmalloc.h
ae.o: ae.c ae.h zmalloc.h config.h ae_kqueue.c
ae_epoll.o: ae_epoll.c
ae_kqueue.o: ae_kqueue.c
ae_select.o: ae_select.c
anet.o: anet.c fmacros.h anet.h
dict.o: dict.c fmacros.h dict.h zmalloc.h
lzf_c.o: lzf_c.c lzfP.h
lzf_d.o: lzf_d.c lzfP.h
pqsort.o: pqsort.c
medis.o: medis.c fmacros.h config.h medis.h ae.h sds.h anet.h dict.h \
  adlist.h zmalloc.h lzf.h pqsort.h zipmap.h staticsymbols.h sha1.h
medis-check-dump.o: medis-check-dump.c lzf.h
sds.o: sds.c sds.h zmalloc.h
zipmap.o: zipmap.c zmalloc.h
zmalloc.o: zmalloc.c config.h

medis-server: $(OBJ)
	$(CC) -o $(PRGNAME) $(CCOPT) $(DEBUG) $(OBJ)

medis-check-dump: $(CHECKDUMPOBJ)
	$(CC) -o $(CHECKDUMPPRGNAME) $(CCOPT) $(DEBUG) $(CHECKDUMPOBJ)

.c.o:
	$(CC) -c $(CFLAGS) $(DEBUG) $(COMPILE_TIME) $<

clean:
	rm -rf $(PRGNAME) $(CHECKDUMPPRGNAME) *.o

install:
	install -D $(PRGNAME) $(DEST_DIR)/sbin/$(PRGNAME)
	install -D $(CHECKDUMPPRGNAME) $(DEST_DIR)/sbin/$(CHECKDUMPPRGNAME)
	install -D medis.conf /etc/conf/medis.conf
