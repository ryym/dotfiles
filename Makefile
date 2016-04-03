
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

.PHONY: uninstall
uninstall:
	@./sync/uninstall

.PHONY: unlink
unlink:
	@./sync/unlink

.PHONY: bin
bin:
	@chmod 755 bin/*
