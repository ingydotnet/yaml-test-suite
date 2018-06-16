export PATH := $(PWD)/node_modules/.bin:$(PATH)

# Each YAML framework has a branch for its tests:
YAMLS := \
    yamlpp \
    yamlpm \

TESTS := $(YAMLS:%=test-%)

WORKTREES := \
    data \
    gh-pages \
    node_modules \
    template \
    testml \
    $(YAMLS) \

TESTML_BRANCH := master

MATRIX_REPO ?= git@github.com:perlpunk/yaml-test-matrix

#------------------------------------------------------------------------------
status:
	@for d in $(WORKTREES); do \
	    [ -d $$d ] || continue; \
	    ( \
		echo "=== $$d"; \
		cd $$d; \
		git status | grep -Ev '(^On branch|up-to-date|nothing to commit)'; \
		git log --graph --decorate --pretty=oneline --abbrev-commit -10 | grep wip; \
		echo; \
	    ); \
	done
	@echo "=== master"
	@git status | grep -Ev '(^On branch|up-to-date|nothing to commit)' || true

work: $(WORKTREES)

$(WORKTREES):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

github/testml:
	git clone --branch=$(TESTML_BRANCH) git@github.com:testml-lang/testml $@

#------------------------------------------------------------------------------
test: $(TESTS)

test-%: %
	make -C $< test

#------------------------------------------------------------------------------
update: testml node_modules
	rm -fr testml/name/ testml/tags/
	bin/generate-links testml/*.tml
	git add -A -f testml/

#------------------------------------------------------------------------------
data-update: data testml node_modules
	rm -fr data/*
	bin/generate-data testml/*.tml

data-status:
	@(cd data; git add -Af .; git status --short)

data-diff:
	@(cd data; git add -Af .; git diff --cached)

data-push:
	@[ -z "$$(cd data; git status --short)" ] || { \
	    cd data; \
	    git add -Af .; \
	    COMMIT=`cd ..; git rev-parse --short HEAD` ; \
	    git commit -m "Regenerated data from master $$COMMIT"; \
	    git push origin data; \
	}

#------------------------------------------------------------------------------
matrix:
	git clone $(MATRIX_REPO) $@

matrix-build: matrix
	make -C $< $(@:matrix-%=%)

matrix-push: matrix-copy
	( \
	    cd gh-pages && \
	    git add -A . && \
	    git commit -m 'Regenerated matrix files' && \
	    git push \
	)

matrix-status:
	( \
	    cd gh-pages && \
	    git status \
	)

matrix-copy: gh-pages
	rm -fr gh-pages/css \
	       gh-pages/js \
	       gh-pages/*.html \
	       gh-pages/details
	cp -r matrix/matrix/html/css \
	      matrix/matrix/html/js \
	      matrix/matrix/html/details \
	      matrix/matrix/html/*.html \
	      $<

#------------------------------------------------------------------------------
clean:
	rm -fr data matrix gh-pages
	rm -fr node_modules
	rm -f package*
	git worktree prune

realclean: clean
	rm -fr $(WORKTREES)
	rm -fr github
	git worktree prune
