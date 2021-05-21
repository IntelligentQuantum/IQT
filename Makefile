# IQT - IntelligentQuantum Terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = IQT.c X.c BoxDraw.c HB.c
OBJ = $(SRC:.c=.o)

all: options IQT

options:
	@echo IQT build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

.c.o:
	$(CC) $(STCFLAGS) -c $<

IQT.o: Config.h IQT.h Win.h
X.o: Arg.h Config.h IQT.h Win.h HB.h
HB.o: IQT.h
BoxDraw.o: Config.h IQT.h BoxDrawData.h

$(OBJ): Config.h config.mk

IQT: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f IQT $(OBJ) IQT-$(VERSION).tar.gz *.rej *.orig *.o

dist: clean
	mkdir -p IQT-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		Config.h IQT.info IQT.1 Arg.h IQT.h Win.h $(SRC)\
		IQT-$(VERSION)
	tar -cf - IQT-$(VERSION) | gzip > IQT-$(VERSION).tar.gz
	rm -rf IQT-$(VERSION)

install: IQT
	git submodule init
	git submodule update
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f IQT $(DESTDIR)$(PREFIX)/bin
	cp -f IQT_CopyOut $(DESTDIR)$(PREFIX)/bin
	cp -f IQT_UrlHandler $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQT
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQT_CopyOut
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQT_UrlHandler
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < IQT.1 > $(DESTDIR)$(MANPREFIX)/man1/IQT.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/IQT.1
	tic -sx IQT.info
	@echo Please see the README file regarding the terminfo entry of IQT.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/IQT
	rm -f $(DESTDIR)$(PREFIX)/bin/IQT_CopyOut
	rm -f $(DESTDIR)$(PREFIX)/bin/IQT_UrlHandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/IQT.1

.PHONY: all options clean dist install uninstall
