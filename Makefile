# This snippet has been shamelessly borrowed from thestinger's repose Makefile
VERSION = 1.3
GIT_DESC = $(shell test -d .git && git describe --always 2>/dev/null)

ifneq "$(GIT_DESC)" ""
	VERSION = $(GIT_DESC)
endif

CC ?= gcc
PKG_CONFIG ?= pkg-config
WITH_XINERAMA ?= 0

PKGS = xcb xcb-randr x11 x11-xcb xft freetype2 fontconfig
ifeq "$(WITH_XINERAMA)" "1"
	PKGS += xcb-xinerama
endif

NEED_PKG_CONFIG = 1
ifneq "$(MAKECMDGOALS)" ""
ifeq "$(filter-out clean uninstall doc,$(MAKECMDGOALS))" ""
	NEED_PKG_CONFIG = 0
endif
endif

ifeq "$(NEED_PKG_CONFIG)" "1"
	PKG_CONFIG_MISSING = $(shell $(PKG_CONFIG) --exists $(PKGS) >/dev/null 2>&1 || echo yes)
	ifeq "$(PKG_CONFIG_MISSING)" "yes"
$(error Missing pkg-config dependencies: $(PKGS))
	endif
endif

CPPFLAGS += -DVERSION="\"$(VERSION)\"" -DWITH_XINERAMA=$(WITH_XINERAMA) $(shell $(PKG_CONFIG) --cflags $(PKGS) 2>/dev/null)
CFLAGS += -Wall -std=c11 -Os
LDLIBS += $(shell $(PKG_CONFIG) --libs $(PKGS) 2>/dev/null)
CFDEBUG = -g3 -pedantic -Wall -Wunused-parameter -Wlong-long \
          -Wsign-conversion -Wconversion -Wimplicit-function-declaration

EXEC = lemonbar
SRCS = lemonbar.c
OBJS = ${SRCS:.c=.o}

PREFIX ?= /usr
BINDIR = ${PREFIX}/bin
MANDIR = ${PREFIX}/share/man/man1

all: ${EXEC}

doc: README.pod
	pod2man --section=1 --center="lemonbar Manual" --name "lemonbar" --release="lemonbar $(VERSION)" README.pod > lemonbar.1

.c.o:
	${CC} ${CPPFLAGS} ${CFLAGS} -o $@ -c $<

${EXEC}: ${OBJS}
	${CC} ${LDFLAGS} -o ${EXEC} ${OBJS} ${LDLIBS}

debug: CFLAGS += ${CFDEBUG}
debug: ${EXEC}

check: ${EXEC}
	./${EXEC} -h >/dev/null

clean:
	rm -f ./*.o ./*.1
	rm -f ./${EXEC}

install: lemonbar doc
	install -D -m 755 lemonbar ${DESTDIR}${BINDIR}/lemonbar
	install -D -m 644 lemonbar.1 ${DESTDIR}${MANDIR}/lemonbar.1

uninstall:
	rm -f ${DESTDIR}${BINDIR}/lemonbar
	rm -f ${DESTDIR}${MANDIR}/lemonbar.1

.PHONY: all debug check clean doc install uninstall
