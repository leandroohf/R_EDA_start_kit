SOYMODEL = models/soy
CORNMODEL = models/corn
CLEAN_LIST = $(SOYMODEL)/Rcode/*.R $(SOYMODEL)/Rcode/*/*.R $(CORNMODEL)/Rcode/*.R $(CORNMODEL)/Rcode/*/*.R
TESTSDIR = tests
EMACS = c:/Program\ Files\ \(x86\)/GNU\ Emacs\ 24.3/bin/emacs.exe


.PHONY: tests clean

tangle: $(CORNMODEL)/corn_yields_models.org $(SOYMODEL)/soy_yields_models.org
	pwd
	$(EMACS) -Q --batch --no-init-file -l setup/init.el --visit $(CORNMODEL)/corn_yields_models.org -f org-babel-tangle --kill
	$(EMACS) -Q --batch --no-init-file -l setup/init.el --visit $(SOYMODEL)/soy_yields_models.org -f org-babel-tangle --kill

tests: $(TESTSDIR)/main_tests_block.R
	@echo "Testing models and tools"
	Rscript $<

tags: build_tags.R
	@echo "Running build_tags.R ..."
	Rscript $<

clean:
	rm -v $(CLEAN_LIST)
