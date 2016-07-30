
.PHONY: sync
sync: install link

.PHONY: clean
clean: uninstall unlink

.PHONY: install
install:
	@./sync/install

.PHONY: link
link:
	@./sync/link

.PHONY: dryrun
dryrun: dryrun-install dryrun-link

.PHONY: dryrun-install
dryrun-install:
	@SYNC_DRYRUN=1 ./sync/install

.PHONY: dryrun-link
dryrun-link:
	@./sync/link -t

.PHONY: uninstall
uninstall:
	@./sync/uninstall

.PHONY: unlink
unlink:
	@./sync/unlink

.PHONY: bin
bin:
	@chmod 755 bin/*
