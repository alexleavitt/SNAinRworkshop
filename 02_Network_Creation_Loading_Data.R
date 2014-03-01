# Network data can come in a variety of forms which range from simply plain text to complex XML based containers.
# Before starting to examine the various social network analysis metrics and tools available we first have to figure 
# out how to get our data into R. In this section we will explain the structure and how to load various text based files 
# such as edge lists and adjacency matrices as well as going over some of the more complex formats such as .GRAPHML and 
# .GML.
# 
# Before starting it is important that we define a few terms which will appear again and again in this workshop.
# Nodes or vertices- The dots on a network graph. Nodes each node or a vertex can represent a person, place, thing or
# idea. In most graphs all nodes represent the same class of object, i.e. in a social network each node is a person.
# However some graphs can include nodes of different types, showing the relationship between authors and articles or
# people and organizations. Each node can have a number of attributes which describe characteristics such as age, gender,
# status or any other descriptor.
# 
# Edges- Edges represent the relationship between any two nodes. The type of relationship depends on the type of graph. 
# Social networks use edges to represent friendship or some other form of social relationship between any two nodes. 
# But other relationships can be modeled, both positive and negative. As an example you could make a graph where the 
# edges represented hostile relationships between nodes in an attempt to examine bullying. Like nodes edges can contain 
# attributes which describe the relationship. These this case these "edge attributes" can describe the type of 
# relationship, its duration or any other characteristic.
# 
# We'll be using network data from the show Grey's Anatomy for today's exercises. Each node represents a fictional
# character and each edge is a hookup between any two characters. Let's try loading this data in the various forms
# described above. 
#

#===============================================
# ADJACENCY MATRICES
#===============================================
# One of the most simple ways of representing a network is an adjacency matrix. This is square matrix with the names or identifiers of all nodes in the network along both axis. Any relationship between two members of the network is represented as a 1 at the intersection of their row and column. 
# As an example if we were to map out some friendships with an adjacency matrix it might look like this:
#         Josh  	Alex		Bob
# Josh		 -  		 1		  0
# Alex		 1		   -		  0
# Bob		   0       0      -
ga.adj<-as.matrix(read.table(('grey_adjacency.tsv'), sep="\t",
                             header=T, row.names=1, quote="\""))

#View the first few rows
head(ga.adj)

# Currently this data is not being recognized as a network by R, so we have to signal what it represents to the program.
# If you have not already done so, this is a good time to uncomment the following line and install the "statnet" package. 

# install.packages('statnet')

#If you have statnet installed let's load it with the following command
library(statnet)

# Now to make the data into a network called grey.net

grey.net.a<-network(ga.adj, directed=F, hyper=F, loops=F, multiple=F, bipartite=F)

# directed=F signals that the connections are undirected in this network, that is there are no one way
# relationships.
# hyper=F means that an edge can only connect two nodes at any given point
# loops=F indicates that you can't have an edge which connects to the same node it originates from 
# multiple=F shows that we have only one type of edge in this network (relationships)
# finally, bipartatie=F means that we have only one type of node (characters)

#===============================================
# EDGE LISTS
#===============================================

# Another way to representing a network is an edge list. Unlike an adjacency matrix an edge list assumes that there 
# is no relationship between any nodes unless previously specified. Therefore the list just consists of two columns 
# listing the source and target of any given edge (note that in undirected networks source and target are just
# meaningless labels because an edge always flows both ways). An example edgelist would look like:


# Let's load our edgelist

ga.el<-read.table('grey_edgelist.tsv', sep="\t", header=T, quote="\"",
                  stringsAsFactors=F, strip.white=T, as.is=T)

#Take a look at the first few rows
head(ga.el)

# And translate it into network format.
grey.net.e<-network(ga.el, directed=F, hyper=F, loops=F, multiple=F, bipartite=F)


#If we examine the edgelist and adjacency matrix networks we can see that they are exactly the same
plot(grey.net.e)
plot(grey.net.a)

#===============================================
# NODE LISTS
#===============================================
# Both edgelists and adjacency matrices are unable to hold node attributes (in this case the characteristics 
# of characters on the show). We have to load these separately as a node list. A node list is simply a catalog
# of every node in a network identified by a unique number or sting. Beside each identifier there is a series
# of values which represent the given node attributes. Let's load our node list

ga.atts<-read.table('grey_nodes.tsv', sep="\t", header=T, quote="\"",
                    stringsAsFactors=F, strip.white=T, as.is=T)
head(ga.atts)

# In this case the unique identifier is the name of the character and attributes include gender, birth year
# race, hospital position, season and zodiac sign.

# Finally we have to attach our node list to a network so that R associates the proper characteristics with
# each node. This can be done by modifying the network creation command we used before.

grey.net<-network(ga.adj, vertex.attr=ga.atts, vertex.attrnames=colnames(ga.atts),
                  directed=F, hyper=F, loops=F, multiple=F, bipartite=F)

#Now we can plot our network and see the gender or other attributes of the node represnted within the 
#visualization

plot(grey.net, vertex.col=c("blue","pink")[1+(get.vertex.attribute(grey.net, "sex")=="F")],
     label=get.vertex.attribute(grey.net, "name"), label.cex=.75)


#Once our network has been created we can always pass queries quickly access information about the object.
is.network(grey.net)       # Is it a network?
is.bipartite(grey.net)     # Does it contain adjacency or affiliation data?
is.directed(grey.net)      # Is it directed?
has.loops(grey.net)        # Are self-loops allowed?  
network.size(grey.net)     # What is the network size?
network.edgecount(grey.net) # What is the number of edges?
#===============================================
# RANDOM GRAPHS
#===============================================

# Random Graphs are networks with pseudo-randomly drawn edges . These graphs can be generated to fit certain preset 
# specifications or fit specific criteria. As such they are useful as a point of comparison with non-random graphs 
# in order to see if social processes generate patterns which are different from random noise. 
# Let's generate a random undirected graph with 44 nodes (the game as the Grey's Anatomy network) with an edge 
# probability of 0.1 (which is roughly the same as the Grey network as well, we will go into how to calculate this 
# in the next session).  Then we can plot and visually compare the random network to Grey's Anatomy network.


r.net<-network(rgraph(44, m=1, mode='digraph', tprob=0.025))
plot(r.net)
network.size(r.net)     # What is the network size?
network.edgecount(r.net)
