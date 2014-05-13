# Source : http://cran.r-project.org/doc/contrib/R-and-octave.txt
meshgrid <- function(a,b) {
	list(
		x=outer(b*0,a,FUN="+"),
		y=outer(b,a*0,FUN="+")
	)
}

# Source : http://stackoverflow.com/questions/5665599/range-standardization-0-to-1-in-r
range01 <- function(x){(x-min(x))/(max(x)-min(x))}
