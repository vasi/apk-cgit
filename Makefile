.PHONY: all image run run-sqfs

all: run

image:
	ch-image build . --force=fakeroot -t apk-cgit	

run: image
	mkdir -p git/repositories
	ch-run apk-cgit --write-fake -b git:/var/lib/git -

apk-cgit.sqfs: image
	ch-convert apk-cgit apk-cgit.sqfs

run-sqfs: apk-cgit.sqfs
	mkdir -p git/repositories
	ch-run apk-cgit.sqfs --write-fake -b git:/var/lib/git -- \
	  /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

clean:
	rm -f apk-cgit.sqfs
	ch-image delete apk-cgit
