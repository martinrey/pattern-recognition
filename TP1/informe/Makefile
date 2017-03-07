LATEX = pdflatex

.PHONY: all clean

all: main.tex caratula.sty imagenes/logo_uba.jpg
	$(LATEX) main.tex
	
clean:
	rm -f main.aux
	rm -f main.log
	rm -f main.toc
	rm -f main.pdf
	rm -f main.synctex.gz
