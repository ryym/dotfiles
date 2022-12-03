
.PHONY: sync
sync: install link

.PHONY: clean
clean: uninstall unlink

.PHONY: install
install:
	@./sync/install

.PHONY: link
link:
	@./link/link

.PHONY: dryrun
dryrun: dryrun-install dryrun-link

.PHONY: dryrun-install
dryrun-install:
	@DOTFILES_DRYRUN=1 ./sync/install

.PHONY: dryrun-link
dryrun-link:
	@DOTFILES_DRYRUN=1 ./link/link

.PHONY: uninstall
uninstall:
	@./sync/uninstall

.PHONY: unlink
unlink:
	@./link/unlink

.PHONY: bin
bin:
	@chmod 755 bin/*

.PHONY: test
test:
	@./test.sh
