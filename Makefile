DIST_FILES := rebeccaessay.cls
TEXMF_ROOT := "${HOME}/texmf"
INSTALL_DIR := "$(TEXMF_ROOT)/tex/latex/problemset"

install: problemset
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
