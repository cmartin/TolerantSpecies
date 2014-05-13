source("lib.R")
source("TolerantSpecies.R")

# Sim parameters
stopping.thresholds = c(.3,.4,.5)
species.richness.steps = c(5,10)
replicates =3

runs = length(stopping.thresholds) * length(species.richness.steps) * replicates

# Setup experiment replicates
iterations = data.frame(
	stopping.threshold = rep(0,runs),
	species.richness = rep(0,runs)
)
count = 1
for (i in 1:length(stopping.thresholds)) {
	for (j in 1:length(species.richness.steps)) {
		for (k in 1:replicates) {
			
			iterations[count,"stopping.threshold"] = stopping.thresholds[i]
			iterations[count,"species.richness"] = species.richness.steps[j]
			
			count = count + 1
		}
	}
}

# Empty results data.frame
sims = data.frame(
	max.cover = rep(0,runs),
	n.species = rep(0,runs),
	total.leaf.surface = rep(0,runs),
	nb.leaves = rep(0,runs),
	nb.iterations = rep(0,runs),
	projected.leaf.surface = rep(0,runs),
	mig = rep(0,runs),
	mean.tolerance = rep(0,runs)
)

count = 1
while(count <= runs) {
	res = Tolerant.Species(max.cover=iterations[count,"stopping.threshold"],n.species=iterations[count,"species.richness"])
	
	sims[count,"max.cover"] = iterations[count,"stopping.threshold"]
	sims[count,"n.species"] = iterations[count,"species.richness"]
	sims[count,"total.leaf.surface"] = res$total.leaf.surface
	sims[count,"nb.leaves"] = res$nb.leaves
	sims[count,"nb.iterations"] = res$nb.iterations
	sims[count,"projected.leaf.surface"] = res$projected.leaf.surface
	sims[count,"mean.tolerance"] = res$mean.tolerance
	
	print(count)
	count = count+1
}

boxplot(sims$mean.tolerance~sims$max.cover, xlab="Max cover", ylab="Mean tolerance")
