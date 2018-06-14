TOP := $(shell cd .. && pwd)

TESTML := $(TOP)/testml
TESTML_REPO := $(TOP)/testml-lang

YAML := YAML-PP-p5

# TESTS := 229Q
# TESTS := $(TESTS:%=$(TESTML)/%.tml)
TESTS := $(TESTML)/*.tml

export PATH := $(TESTML_REPO)/bin:$(PATH)
export TESTML_ROOT := $(TESTML_REPO)
export PERL5LIB := $(YAML)/lib:$(PERL5LIB)

export TESTML_RUN := perl
export TESTML_PATH := $(TESTML)
export TESTML_LIB := test

.PHONY: test
test: $(TESTML) $(TESTML_REPO) $(YAML)
	$(TESTML_REPO)/bin/testml -i test/all-tests.tml $(TESTS)

$(YAML):
	git clone --depth=1 git@github.com:perlpunk/$@

$(TESTML):
	make -C $(TOP) testml

$(TESTML_REPO):
	make -C $(TOP) testml-lang

clean:
	rm -fr $(YAML)
