docs:
	cat notes/documentation/docs.metadata notes/documentation/system_documentation.md | pandoc -N --template=notes/documentation/default.template --latex-engine=xelatex  --toc -o Dokumentation.pdf
