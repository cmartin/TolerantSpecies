###############################################################################
# May 2014
# Charles A. Martin
# Université du Québec à Trois-Rivières
# Chaire de recherche du Canada en intégrité écologique
###############################################################################

Tolerant.Species = function(
	
	######################################################
	# Simulation parameters
	matrix.size = 250,
	sigma = 3, # sigma controls the repartition of the size of the basic shape :
	#	sigma --> 0  gives more uniform repartition of shape,
	# 	sigma = 3 gives a nearly scale invariant image.
	rmin = 0.01, # maximum and minimum of major axis distirbution
	rmax = 1,
	max.cover = .75, # total cover threshold to which the simulation stops
	n.species = 10,
	max.iterations = 100000
	
	) {

	##################################################
	# Setup the environment matrix
	M = matrix(data=rep(Inf,matrix.size^2),ncol=matrix.size,nrow=matrix.size) # The matrix containing albedo values	
	# Create a grid of coordinates for the ellipse calculations
	x = seq(0,1,length=matrix.size) # Separate the 0-1 space in matrix.size columns and n lines
	X = meshgrid(x,x)$x # X values in the 0-1 space
	Y = meshgrid(x,x)$y
	m = matrix.size^2 # Empty cell count
	
	##################################################
	# Setup species pool
	# TODO : Plasticity
	species = matrix(nrow=n.species,ncol=4)
	colnames(species) = c("major.axis","shape","shadow.tolerance","albedo")
	for (i in 1:n.species) {		
		species[i,"shape"] = runif(1,rmin,rmax)
		species[i,"shadow.tolerance"] = runif(1) #	# i.e. covered pixel ratio under which the leaf cannot establish itself
		# 1 = totally tolerant
		# 0 = totally intolerant
	}
	
	##################################################
	# Prepare simulation stats/output
	nb.iterations = 0
	nb.leaves = 0
	total.leaf.surface = 0
	projected.leaf.surface = 0
	tolerance.sum = 0

	##################################################
	# Simulation 
	while( 
		((m / matrix.size^2) >= (1-max.cover))
		&
		(nb.iterations < max.iterations)
	) {
		
		# Pick a random species from pool
		selected.species = species[sample(c(1:n.species),1),]

		# Position individual randomly
		x = runif(1)
		y = runif(1)
		phi = runif(1,1,360)*pi/180 # Convert to radians
		
		# Determine leaf size
		major.axis = ( 
			(rmax^(-sigma+1) - rmin^(-sigma+1))* # Normalize for sum(p) = 1 and value range between rmin and rmax
				runif(1) + # Start from a uniform distribution
				rmin^(-sigma+1)
		)^(1/(-sigma+1)) # Power function per se
		minor.axis= selected.species["shape"]*major.axis
		
				
		# Rotated ellipse around its center
		# # http://math.stackexchange.com/questions/426150/what-is-the-general-equation-of-the-ellipse-that-is-not-in-the-origin-and-rotate
		proposed.ellipse = ((
			((X-x)*cos(phi) + (Y-y)*sin(phi))^2 / major.axis^2
		)
		+ (
			((X-x)*sin(phi) - (Y-y)*cos(phi))^2 / minor.axis^2
		) <= 1)
				
		uncovered.pixels = which(is.infinite(M) & proposed.ellipse)
		covered.pixels = which((!is.infinite(M)) & proposed.ellipse)
		
		if ((length(covered.pixels)+length(uncovered.pixels))>0) {
			
			nb.iterations = nb.iterations+1
			
			if ((length(covered.pixels) / (length(uncovered.pixels)+length(covered.pixels)) ) <= selected.species["shadow.tolerance"]) {
			
				nb.leaves = nb.leaves+1
			
				M[uncovered.pixels] = runif(1) # Assign a random albedo
				m = m - length(uncovered.pixels) # Update count of empty cells in matrix
				
				total.leaf.surface = total.leaf.surface + length(uncovered.pixels) + length(covered.pixels)
				projected.leaf.surface = projected.leaf.surface + length(uncovered.pixels)				
				tolerance.sum = tolerance.sum + selected.species["shadow.tolerance"]
			
			}
		} else {
			# This leaf never existed, it contained 0 pixels
		}
		
	}
	
	M[which(is.infinite(M))]=0 # Empty pixels reflect nothing
	
	return (list(
		matrix=M,
		total.leaf.surface=total.leaf.surface,
		nb.leaves=nb.leaves,
		nb.iterations=nb.iterations,
		projected.leaf.surface = projected.leaf.surface,
		mean.tolerance = tolerance.sum / nb.leaves
	))
}