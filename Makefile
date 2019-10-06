VERSION := 2019\/04\/21 0.1.0
PACKAGE := rebeccastyle

ROOT_DIR := $(CURDIR)
DIST_FILES := ${PACKAGE}.sty rebeccaessay.cls
DOC_FILES := ${PACKAGE}.tex \
	LICENSE.md README.md
DIST_PDF := ${PACKAGE}.pdf
NEEDS_LATEXMK := ${PACKAGE}.tex

NEEDS_ESCAPE := ${PACKAGE}.sty rebeccaessay.cls ${PACKAGE}.tex
ESCAPE_VERSION := sed -e 's/\$${VERSION}\$$/${VERSION}/' -i

# Simple OS detection for Make on Cygwin...
UNAME := $(shell uname -o)
ifeq ($(UNAME), Cygwin)
	# use the windows home folder rather than the cygwin one
	HOME := $(shell cygpath ${USERPROFILE})
endif

TEXMF := ${HOME}/.texmf
INSTALL_DIR := ${TEXMF}/tex/latex/${PACKAGE}
LATEXMK := latexmk -pdf -r $(ROOT_DIR)/.latexmkrc -pvc- -pv-
LATEXMK_CLEAN := $(LATEXMK) -c

${PACKAGE}/${PACKAGE}.pdf: ${PACKAGE}/${PACKAGE}.tex
	cd ${PACKAGE} && $(LATEXMK) ${PACKAGE}.tex

.PHONY: dir-no-pdf
dir-no-pdf: $(DIST_FILES) $(DOC_FILES)
	# copies files over, escapes versions
	mkdir -p $(PACKAGE)
	cp -t ${PACKAGE} $^
	cd ${PACKAGE} && $(ESCAPE_VERSION) $(NEEDS_ESCAPE)

dir: dir-pdf
dir-pdf: dir-no-pdf ${PACKAGE}/example.tex ${PACKAGE}/${PACKAGE}.tex
	cd ${PACKAGE} && $(LATEXMK) $(NEEDS_LATEXMK)

${PACKAGE}: $(DIST_FILES) $(DOC_FILES)
	make dir-no-pdf dir-pdf
	chmod -x,+r ${PACKAGE}/*

.PHONY: dist
dist: ${PACKAGE}.tar.gz
${PACKAGE}.tar.gz: ${PACKAGE}
	cd ${PACKAGE} && $(LATEXMK_CLEAN) && rm -rf extra *.fls
	tar -czf $@ $?
	make tidy
	tar -tvf $@

tidy:
	# all generated files but the pdf and .tar.gz
	$(LATEXMK_CLEAN)
	# copied files
	rm -rf ${PACKAGE} extra

distclean: clean
clean:
	$(LATEXMK) -C
	make tidy
	rm -f ${PACKAGE}.tar.gz

install: dir-no-pdf
	install -d ${INSTALL_DIR}
	cd ${PACKAGE} && install -m 644 $(DIST_FILES) ${INSTALL_DIR}

.PHONY:                            help
help:
	@echo "dist:               Make distribution '.tar.gz'"
	@echo "tidy:               Clean generated files except '.pdf's and '.tar.gz's"
	@echo "clean / distclean:  Clean all generated files"
	@echo "install:            install style and class files to \$$INSTALL_DIR"
	@echo "                        ${INSTALL_DIR}"
	@echo "dir-no-pdf:         The directory which is '.tar.gz'd without necessary '.pdf's"
	@echo "dir-pdf:            The directory which is '.tar.gz'd with '.pdf's"
