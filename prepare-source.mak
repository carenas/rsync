gen: gen_no_man man

gen_no_man: configure.sh config.h.in proto.h

configure.sh: configure.in aclocal.m4
	autoconf -o configure.sh

config.h.in: configure.in aclocal.m4
	autoheader && touch config.h.in

proto.h: *.c lib/compat.c
	cat *.c lib/compat.c | awk -f mkproto.awk >proto.h.new
	if diff proto.h proto.h.new >/dev/null 2>&1; then \
	  rm proto.h.new; \
	else \
	  mv proto.h.new proto.h; \
	fi

man: rsync.1 rsyncd.conf.5

rsync.1: rsync.yo
	yodl2man -o rsync.1 rsync.yo
	-./tweak_manpage rsync.1

rsyncd.conf.5: rsyncd.conf.yo
	yodl2man -o rsyncd.conf.5 rsyncd.conf.yo
	-./tweak_manpage rsyncd.conf.5
