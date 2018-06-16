TOP := $(shell cd .. && pwd)

YAML := YAML-PP-p5
TESTML := $(TOP)/testml
TESTML_REPO := $(TOP)/github/testml
TESTML_COMPILER := $(TESTML_REPO)/compiler
BIN := $(TESTML_REPO)/bin/testml
NODE_MODULES := ../node_modules

# TESTS := 229Q
# TESTS := $(TESTS:%=$(TESTML)/%.tml)
TESTS := $(TESTML)/*.tml

export PATH := $(TESTML_REPO)/bin:$(TESTML_COMPILER)/bin:$(NODE_MODULES)/.bin:$(PATH)
export TESTML_ROOT := $(TESTML_REPO)
export PERL5LIB := $(YAML)/lib:$(PERL5LIB)

export TESTML_RUN := perl
export TESTML_PATH := $(TESTML)
export TESTML_LIB := test

.PHONY: test
test: setup
	$(BIN) -i test/all-tests.tml $(TESTS)

test-emit-scalar-styles: setup
	$(BIN) test/$(@:test-%=%).tml

setup: $(TESTML) $(TESTML_REPO) $(TESTML_COMPILER) $(YAML) $(NODE_MODULES)

$(YAML):
	git clone --depth=1 git@github.com:perlpunk/$@

$(TESTML):
	make -C $(TOP) testml

$(TESTML_REPO):
	make -e -C $(TOP) github/testml

$(TESTML_COMPILER): $(TESTML_REPO)
	make -C $< compiler

$(NODE_MODULES):
	make -C .. node_modules

clean:
	rm -fr $(YAML) test/.testml
