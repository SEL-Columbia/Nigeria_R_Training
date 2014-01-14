all: *.html
outlier_presentation.html outlier_presentation.md: outlier_presentation.Rmd
	echo "require(knitr); knit2html('outlier_presentation.Rmd')" | R --no-save
Day3.html Day3.md: Day3.Rmd
	echo "require(knitr); knit2html('Day3.Rmd')" | R --no-save
Day2.html Day2.md: Day2.Rmd
	echo "require(knitr); knit2html('Day2.Rmd')" | R --no-save
presentation_R.html presentation_R.md: presentation_R.Rmd
	echo "require(knitr); knit2html('presentation_R.Rmd')" | R --no-save
index.html: index.md
	echo "require(knitr); knit2html('index.md')" | R --no-save
