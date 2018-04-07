TEXLIVEONFLY := $(shell command -v texliveonfly 2> /dev/null)

DOC := $(foreach dir,$(dir $(wildcard doc/*/main.tex)),$(shell basename $(dir)))
PDF := $(addprefix docs/,$(addsuffix .pdf,$(DOC)))

default: $(PDF)

docs/:
	mkdir -p docs/

define DOC_template
docs/$(1).pdf: docs/
	cd doc/$(1);\
		$(TEXLIVEONFLY)                             \
			-c latexmk                                \
			-a "-pdflatex=pdflatex                    \
			    -f                                    \
			    -pdf                                  \
			    -outdir=../../docs                  \
	        -latexoption=-interaction=nonstopmode \
	        -latexoption=-halt-on-error           \
	        -jobname=$(1)"                        \
			main.tex
endef

$(foreach doc,$(DOC),$(eval $(call DOC_template,$(doc))))

setup:
ifndef TEXLIVEONFLY
	curl -L http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar xz -C $(HOME)
	cd $(HOME)/install-tl-*;\
		yes i | ./install-tl --profile=$(TRAVISdocs_DIR)/texlive.profile
	tlmgr install                 \
		luatex                      \
		biber                       \
		latexmk                     \
		texliveonfly                \
		greek-fontenc               \
		babel                       \
		babel-greek                 \
		babel-english               \
		cbfonts                     \
		cbfonts-fd                  \
		textgreek                   \
		koma-script                 \
		collection-fontsrecommended \
		collection-fontsextra       \
		collection-bibtexextra
endif

.phony: setup
