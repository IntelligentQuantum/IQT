# IQ-T - IntelligentQuantum Terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = IQ-T.c X.c BoxDraw.c HB.c
OBJ = $(SRC:.c=.o)

all: options IQ-T

options:
	@echo IQ-T build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

.c.o:
	$(CC) $(STCFLAGS) -c $<

IQ-T.o: Config.h IQ-T.h Win.h
X.o: Arg.h Config.h IQ-T.h Win.h HB.h
HB.o: IQ-T.h
BoxDraw.o: Config.h IQ-T.h BoxDrawData.h

$(OBJ): Config.h config.mk

IQ-T: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f IQ-T $(OBJ) IQ-T-$(VERSION).tar.gz *.rej *.orig *.o

dist: clean
	mkdir -p IQ-T-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		Config.h IQ-T.info IQ-T.1 Arg.h IQ-T.h Win.h $(SRC)\
		IQ-T-$(VERSION)
	tar -cf - IQ-T-$(VERSION) | gzip > IQ-T-$(VERSION).tar.gz
	rm -rf IQ-T-$(VERSION)

install: IQ-T
	git submodule init
	git submodule update
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f IQ-T $(DESTDIR)$(PREFIX)/bin
	cp -f IQ-T-CopyOut $(DESTDIR)$(PREFIX)/bin
	cp -f IQ-T-UrlHandler $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQ-T
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQ-T-CopyOut
	chmod 755 $(DESTDIR)$(PREFIX)/bin/IQ-T-UrlHandler
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < IQ-T.1 > $(DESTDIR)$(MANPREFIX)/man1/IQ-T.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/IQ-T.1
	tic -sx IQ-T.info
	@echo Please see the README file regarding the terminfo entry of IQ-T.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/IQ-T
	rm -f $(DESTDIR)$(PREFIX)/bin/IQ-T-CopyOut
	rm -f $(DESTDIR)$(PREFIX)/bin/IQ-T-UrlHandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/IQ-T.1

.PHONY: all options clean dist install uninstall
