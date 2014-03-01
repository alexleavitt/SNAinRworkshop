
#=============================================================
#
# 2014 Social Netowork Analysis in R Workshop  
# by Alex Leavitt and Josh Clark
# brought to you by the Annenberg Networks Network
# and the Annenberg School for Communication & Journalism
#
#=============================================================


#===============================================
# LOADING LIBRARIES
#===============================================

#install.packages("RCurl") #this will get stuff from the web
#install.packages("ergm") #this is our ERGM package
#install.packages("latticeExtra")
library(RCurl) 
library(ergm) 
library(latticeExtra)
# Good overview of ergm package here: http://sites.stat.psu.edu/~dhunter/papers/v24i03.pdf


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#===============================================
# REVIEW
#===============================================

par(mfrow=c(1,1)) #resetting the plot so you don't get mini network graphs 

summary(grey.net)

plot(grey.net, vertex.col=c("blue","pink")[1+(get.vertex.attribute(grey.net, "sex")=="F")],
     label=get.vertex.attribute(grey.net, "name"), label.cex=.75)



#===============================================
# OTHER THINGS OF NOTE
#===============================================

list.vertex.attributes(grey.net) #List the different vertex attributes in the network object
get.vertex.attribute(grey.net, "name") #The name assigned to each node.
get.vertex.attribute(grey.net, "sex") #The sex assigned to each node.

?control.ergm #This command will present different options on the estimation methods.



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#===============================================
# RUNNING AN ERGM MODEL
#===============================================

# To see all the options you could have as a "variable" in your model, 
# check out: http://cran.r-project.org/web/packages/ergm/ergm.pdf
# and go to p. 39.
# Note that many of them are limited to directed networks.

# You can also find these by running:
?ergm.terms #This command will provide a list of other terms that ergm() can model

#===============================================
# YOUR FIRST MODEL
#===============================================

# This will not use MCMC.
grey.base <- ergm(grey.net~edges+nodematch("sex")) #Estimate the model

# Explained:
# - ergm(): the function to be called
# - grey.net: our network
# - edges: the edges variable, taking into account the formation of an edge between any 2 nodes
# - nodematch: possibility of nodes forming an edge between members of the same parameter (here, sex, so m/m or f/f)

summary(grey.base) #Summarize the model

# Output explained:
# - Iterations: number of iterations required to estimate the mathematical result
# - Monte Carlo MLE Results: stands for MC Maximum Likelihood Estimate
# More here: http://www.pro-classic.com/ethnicgv/SN/Snijders02.pdf
# - Estimate: the effect size of each variable, in a similar way to logistic regression: 
# predicted loglikelihood of the variable
# for readability, you can exponentiate this to get the odds ratio
# e.g., exp(-2.3003) = 0.1002288, so a 10% odds of forming a tie with any other node (hence we see not many edges)
# e.g., exp(-3.1399) = 0.04328713, so a 4% odds of same-sex relationships forming (hence we see primarily heterosexual coupling)
# More here, p. 8: http://www.unc.edu/~bdesmara/ERGM5.pdf
# Also see practical example at bottom of p. 10, http://sites.stat.psu.edu/~dhunter/papers/v24i03.pdf
# - Std. Error
# Normal statistical error
# - MCMC %
# If Monte Carlo Markov Chain simulation was used for the parameter estimation, this will be %; if not used, NA.
# - p-value
# Your ordinary p-value.
# AIC / BIC
# Your ordinary AIC/BIC values.

#===============================================
# PLOT A PREDICTED NETWORK BASED ON THE MODEL
#===============================================

plot(simulate(grey.base),
     vertex.col=c("blue","pink")[ 1+(get.vertex.attribute(grey.net, "sex")=="F")])
# Try running this 4-5 times. Can you see what it's doing?

#===============================================
# TESTING ERGM MODEL FIT
#===============================================

grey.base.gof <- gof(grey.base)
summary(grey.base.gof) #Summarize the goodness of fit
par(mfrow=c(3,1)); plot(grey.base.gof) #Plot three windows. It's OK to ignore the warning.



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#===============================================
# TRYING A MORE COMPLEX MODEL
#===============================================

# We’ll now add a statistic to the model that controls for the monogamy (degree of 1) effect.
# This one will use MCMC.
grey.base.d1 <- ergm(grey.net~edges+nodematch("sex")+degree(1))

summary(grey.base.d1)

par(mfrow=c(1,1)) #resetting the plot so you don't get mini network graphs 
plot(simulate(grey.base.d1),
     vertex.col=c("blue","pink")[1+(get.vertex.attribute(grey.net, "sex")=="F")])

grey.base.d1.gof <- gof(grey.base.d1); summary(grey.base.d1.gof)

par(mfrow=c(3,1)); plot(grey.base.d1.gof)

# =================================================
# RUN MCMC DIAGNOSTICS
# =================================================

mcmc.diagnostics(grey.base.d1)

# EXPLAINED:

# Sample Statistics Summary
  # Also see plots

# 1. Mean/sd for each variable.

# 2. Quantiles for each variable.

# Are sample stats sig. different from observed?

# Sample stats cross-correlations.

# Sample stats auto-correlation.

# Sample stats burn-in diagnostic (Geweke).

# P-values


# =================================================
# RERUN WITH NEW ATTRIBUTES TO CHANGE DIAGNOSTICS
# =================================================

# but these can increase computation time significantly
# you want to do these if you're not happy with the results of the diagnostics, above

#this is the default
grey.base.d1 <- ergm(grey.net~edges+nodematch("sex")+degree(1),
                     control=control.ergm(MCMC.burnin=10000, MCMC.interval=100))

#this is upping the parameters
# watch out, it may take longer
#grey.base.d1 <- ergm(grey.net~edges+nodematch("sex")+degree(1),
#                     control=control.ergm(MCMC.burnin=50000, MCMC.interval=5000))

# increasing burin will lower Geweke statistics
# increasing interval will lower autocorrelation
# if the statistics differ greatly, then we can also up the sample size:
#grey.base.d1<-ergm(grey.net~edges+nodematch("sex")+degree(1),
#                 control=control.ergm(MCMC.burnin=50000,
#                                      MCMC.interval=5000, MCMC.samplesize=50000))

# RETEST DIAGNOSTICS
summary(grey.base.d1) #The figures are mostly the same
mcmc.diagnostics(grey.base.d1)



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#===============================================
# TRYING AN EVEN MORE COMPLEX MODEL
#===============================================


# ADDING AGE AS ATTRIBUTE
# this will take longer
#grey.base.d1.age <- ergm(grey.net~edges+nodematch("sex")+degree(1)+absdiff("birthyear"),
#                         control=control.ergm(MCMC.burnin=50000, MCMC.interval=5000))

summary(grey.base.d1.age)
mcmc.diagnostics(grey.base.d1.age)
summary(gof(grey.base.d1.age))

# ADDING RACE AS ATTRIBUTE
# this will also take longer
#grey.base.d1.age.race <- ergm(grey.net~edges+nodematch("sex")+degree(1)
#                              +absdiff("birthyear")+nodematch("race"),
#                              control=control.ergm(MCMC.burnin=50000,MCMC.interval=5000))

summary(grey.base.d1.age.race)
mcmc.diagnostics(grey.base.d1.age.race)
summary(gof(grey.base.d1.age.race))
# Note: the BIC increases slightly here, so the previous model is actually better.

# LET'S MODEL THE AGE NETWORK
par(mfrow=c(1,1))
plot(simulate(grey.base.d1.age),
     vertex.col=c("blue","pink")[1+(get.vertex.attribute(grey.net, "sex")=="F")])

