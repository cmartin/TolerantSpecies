Tolerant Species Model
============================================

Inspired by the [dead leaves model](http://scholar.google.ca/scholar?hl=en&q=dead+leaves+model&btnG=&as_sdt=1%2C5&as_sdtp=), this piece of code simulates geometric aspects of plant community assembly through the use of a random placement model and a minimal set of rules.

How it works
---------------------------------------------

The simulation starts by building a pool of **n.species**, where each species is shape and a shadow tolerance from a uniform distribution.

Then for each iteration, an individual leaf (ellipse) is created from a random species in the pool, assigned a size from a power distribution and randomly placed on the matrix, underneath all existing leaves (from top to bottom). The individual is then either kept or removed from the matrix depending on the amount of light it receives (overlap with other leaves) and it's shadow tolerance. Albedos are assigned randomly and do not influence the simulation.

This process is repeated until either **max.iterations** or **max.cover** is reached.

Example code
---------------------------------------------
```{r}
source("lib.R")
source("TolerantSpecies.R")
community = Tolerant.Species(matrix.size=200, max.cover=.75,n.species=3)
pal = colorRampPalette(colors=c("black","green","white"))
image(community$matrix, col=pal(community$nb.leaves),useRaster=TRUE)
```

![](https://raw.githubusercontent.com/cmartin/TolerantSpecies/master/Example.png)

Also see **Example.Simulation.R** for a more complete simulation example.

Default parameters
-------------------------------
```{r}
matrix.size = 250 # matrix side length
sigma = 3 # power distribution parameter
rmin = 0.01 # minimum relative size of the ellipse major-axis compared to the matrix
rmax = 1, # minimum relative size of the ellipse major-axis compared to the matrix
max.cover = .75
n.species = 10
max.iterations = 100000
```
