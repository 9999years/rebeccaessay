DIST_FILES := rebeccaessay.cls
HOME := C:/Users/arvensis
TEXMF_ROOT := $(HOME)/texmf
INSTALL_DIR := $(TEXMF_ROOT)/tex/latex/rebeccaessay

install: rebeccaessay.cls
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
