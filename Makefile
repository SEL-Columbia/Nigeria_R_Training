all: *.html
outlier_presentation.html outlier_presentation.md: outlier_presentation.Rmd
	echo "require(knitr); knit2html('outlier_presentation.Rmd')" | R --no-save
Day6.html Day6.md: Day6.Rmd
	echo "require(knitr); knit2html('Day6.Rmd')" | R --no-save
Day5.html Day5.md: Day5.Rmd
	echo "require(knitr); knit2html('Day5.Rmd')" | R --no-save
Day4.html Day4.md: Day4.Rmd
	echo "require(knitr); knit2html('Day4.Rmd')" | R --no-save
Day3.html Day3.md: Day3.Rmd
	echo "require(knitr); knit2html('Day3.Rmd')" | R --no-save
Day2.html Day2.md: Day2.Rmd
	echo "require(knitr); knit2html('Day2.Rmd')" | R --no-save
Day1.html Day1.md: Day1.Rmd
	echo "require(knitr); knit2html('Day1.Rmd')" | R --no-save
index.html: index.md
	echo "require(knitr); knit2html('index.md')" | R --no-save
