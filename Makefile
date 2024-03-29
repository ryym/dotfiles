
.PHONY: sync
sync: install link

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

.PHONY: test-link
test-link:
	@DOTFILES_LINKTEST=1 ./link/link

.PHONY: unlink
unlink:
	@./link/unlink

.PHONY: bin
bin:
	@chmod 755 bin/*

.PHONY: test
test:
	@./test.sh
