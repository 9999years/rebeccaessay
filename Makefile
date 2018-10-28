PKG := rebeccaessay
DIST_FILES := $(PKG).cls
HOME := ~
TEXMF_ROOT := ${HOME}/texmf
INSTALL_DIR := $(TEXMF_ROOT)/tex/latex/$(PKG)

install: $(PKG).cls
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
