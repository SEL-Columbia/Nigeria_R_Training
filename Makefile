all: *.html
README.md Day2.html Day2.md: Day2.Rmd
	echo "require(knitr); knit2html('Day2.Rmd')" | R --no-save
	cp Day2.md README.md
presentation_R.html presentation_R.md: presentation_R.Rmd
	echo "require(knitr); knit2html('presentation_R.Rmd')" | R --no-save
index.html: index.md
	echo "require(knitr); knit2html('index.md')" | R --no-save
