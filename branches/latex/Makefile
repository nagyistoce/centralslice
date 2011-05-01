matlab_source=$(subst ../../trunk/,,$(wildcard ../../trunk/*.m))

all: clean refman.pdf

pdf: refman.pdf

refman.pdf: refman.tex $(matlab_source)
	pdflatex refman.tex
	makeindex refman.idx
	pdflatex refman.tex
	latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' refman.log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      pdflatex refman.tex ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done

$(matlab_source):%:../../trunk/%
	ln $<

clean:
	rm -f *.ps *.dvi *.aux *.toc *.idx *.ind *.ilg *.log *.out refman.pdf
