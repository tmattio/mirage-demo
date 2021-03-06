ifeq (start,$(firstword $(MAKECMDGOALS)))
  START_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(START_ARGS):;@:)
endif

ifeq ($(OSTYPE),Darwin)
  mirage_mode=macosx
else
  mirage_mode=unix
endif

.PHONY: all
all:
	opam exec -- dune build @install

.PHONY: dev
dev:
	opam install dune-release merlin ocamlformat utop mirage mirage-unix opam-depext
	opam install --deps-only --with-test --with-doc -y .
	cd mirage; opam exec -- mirage configure -t $(mirage_mode)
	cd mirage; opam exec -- make depend

.PHONY: mirage
mirage: install
	cd mirage; opam exec -- mirage configure -t $(mirage_mode)
	cd mirage; opam exec -- make

.PHONY: build
build: all
	opam exec -- dune build

.PHONY: install
install: build
	opam exec -- dune install

.PHONY: start
start: mirage
	mirage/mirage_demo $(START_ARGS)

.PHONY: test
test:
	opam exec -- dune build @test/runtest -f

.PHONY: clean
clean:
	opam exec -- dune clean

.PHONY: doc
doc:
	opam exec -- dune build @doc

.PHONY: doc-path
doc-path:
	@echo "_build/default/_doc/_html/index.html"

.PHONY: format
format:
	opam exec -- dune build @fmt --auto-promote

.PHONY: watch
watch:
	opam exec -- dune build --watch

.PHONY: utop
utop:
	opam exec -- dune utop lib -- -implicit-bindings
