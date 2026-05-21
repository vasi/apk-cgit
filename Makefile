
.PHONY: all image run run-sqfs

all: run

image:
	ch-image build . --force=fakeroot -t apk-cgit

REPO = git/repositories/apk-cgit.git

$(REPO):
	mkdir -p $@
	git clone --bare . $@
	echo 'cgit for apk distros' > $@/description

run: image $(REPO)
	ch-run apk-cgit --write-fake -b git:/var/lib/git -

apk-cgit.sqfs: image
	ch-convert apk-cgit $@

run-sqfs: apk-cgit.sqfs $(REPO)
	# Need to include full CMD: https://gitlab.com/charliecloud/charliecloud/-/work_items/2097
	ch-run $< --write-fake -b git:/var/lib/git -- \
		/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

clean:
	rm -rf apk-cgit.sqfs $(REPO)
	ch-image delete apk-cgit
