# Now that we've create a graph we can start to calculate some of the basic networks metrics which describe various elements 
# of a person's position within a network. These statistics can operate at the node level (where each value is unique for a particular node)
# or at the graph level (where a statistic describes the graph as a whole). Network metrics are generally concerned with identifying 
# nodes who have a special position within the graph, such as influence or serving as the gatekeeper between two groups of nodes.
# Finally some network metrics are designed to find groups or communities within the broader graph.
# 

plot(grey.net)
ga.atts

#===============================================
# DEGREE
#===============================================
# Degree counting is the simplest node level metric. For every edge which connects to a given node the given degree goes up. 
# For directed networks nodes have two types of degree, in-degree and out-degree. The former represents the amount of connections 
# an edge receives and the later the amount it sends out. For undirected networks like ours there is only one count as all degrees 
# are by their nature symmetrical. We'll be saving all of our network attributes to the nodelist so that when we are done we can 
# attach them to the nodes as attributes. This allows us to visually see the differences in centrality or degree when looking at our network.
ga.atts$Degree <- degree(grey.net, gmode="graph")     

#===============================================
# SHORTEST PATH AND GEODESICS
#===============================================
# Before examining centralities and other slightly more complicated indexes let's take a second and define the idea of shortest paths 
# and geodesics. A shortest path is the easiest way to traverse a network. As an example if you are trying to get to know someone 
# then it is easier to go to a common friend who you both have a relationship with then go to a friend of a friend of a friend of a 
# friend. That common person therefore lies on the shortest path between your node and the person you are trying to get to know.
# A trope within network analysis is that it is usually possible to get anywhere on a network in six steps 
# (as demonstrated by the famous six degrees of Kevin Bacon example). A geodesic is simply the measure of any given path out of a node.

#===============================================
# CENTRALITIES
#===============================================
# Both shortest path and geodesics are key in determining centrality. Centrality is based on the idea that certain network positions 
# exert a greater degree of power than others. The exact position and nature of this power depends on the type of centrality index 
# being examined. As an example, closeness centrality holds that the nodes which can reach the rest of the network along the shortest paths. Therefore it is the average of all the paths which a node can take to get to the rest of the network
# Betweenness centrality is a count of the number of times a node lies on the shortest path of all the other nodes in a network.  
# Nodes which high betweenness centrality serve as a bridge between different sections of the network
ga.atts$BetweenCent <- betweenness(grey.net, gmode="graph") # Betweenness centrality    
ga.atts$CloseCent <- closeness(grey.net, g=4, gmode="graph")     # closeness centrality

head(ga.atts)
plot(grey.net)
# Weird, closeness is all zero. This is because we have some random unconnected elements off to the side of the graph, therefore R
# there are no shortest paths that reach the entire other network. Let's load a modified version of the network with some completely
# un-canonical relationships to see what happens with a fully connected network 

ga.mod<-as.matrix(read.table(('grey_adjacency_mod.tsv'), sep="\t",
                             header=T, row.names=1, quote="\""))

grey.net.mod<-network(ga.mod, vertex.attr=ga.atts, vertex.attrnames=colnames(ga.atts),
                  directed=F, hyper=F, loops=F, multiple=F, bipartite=F)
#Let's take a look at the modified network
plot(grey.net.mod)
#And try closeness again
ga.atts$CloseCentMOD <- closeness(grey.net.mod, g=3, gmode="graph") 

# Eigenvector centrality is a more complicated measure which basically take into account who well connected a nodes neighbor is. 
# Well connected nodes with well connected neighbors will have a higher centrality score. Google's famous pagerank algorithm is a
# variant on this approach.
ga.atts$evcent<-evcent(grey.net, gmode='graph', maxiter=500, use.eigen=TRUE)

# At the graph level density is simply the measure of how many edges are present out of all the possible connections within a graph.
gden(grey.net, mode="graph") #Graph Density


#===============================================
# TRIANGLES, TRIADS AND TRANSITIVITY OH MY!
#===============================================
# Transitivity and a triad census examines how many triangles a node is a part of. Triangle are extremely important in social network analysis.
# Completed triads, such as a group of three friends who are all friends with each other are theoretically more stable than simple dyads. 
# Incomplete triangles such as two people who are both friends with a third person but not with each other are potential sites for new 
# relationships. Each of the various types of triads are labeled with a specific alphanumeric code which is explained below.
gtrans(grey.net) #Number of complete triads

triad.census(grey.net, mode="digraph") #Census of all triads. Note that since this is an undirected network some triads are not available.

# Triad types (per Davis & Leinhardt):
# 
# 003  A, B, C, empty triad.
# 012  A->B, C 
# 102  A<->B, C  
# 021D A<-B->C 
# 021U A->B<-C 
# 021C A->B->C
# 111D A<->B<-C
# 111U A<->B->C
# 030T A->B<-C, A->C
# 030C A<-B<-C, A->C.
# 201  A<->B<->C.
# 120D A<-B->C, A<->C.
# 120U A->B<-C, A<->C.
# 120C A->B->C, A<->C.
# 210  A->B<->C, A<->C.
# 300  A<->B<->C, A<->C, completely connected.


#===============================================
# COMMUNITIES AND CLIQUES
#===============================================
# Finally community detection looks for groups or clusters within a given network. Cliques are groups over a given size where every member
#is connected to all of the other members of the group.
grey.net.cliques <- clique.census(grey.net, mode = "graph", clique.comembership="sum")

# The first element of the result list is clique.count: a matrix containing the  
# number of cliques of different sizes (size = number of nodes in the clique).
# The first column (named Agg) gives you the total  number of cliqies of each size,
# the rest of the columns show the number of cliques each node participates in.
#
# Note that this includes cliques of sizes 1 & 2. We have those when the largest
# fully connected structure includes just 1 or 2 nodes.


grey.net.cliques$clique.count

# The second element is the clique co-membership matrix:

grey.net.cliques$clique.comemb


# The third element of the clique census result is a list of all found cliques:
# (Remember that a list can have another list as its element)

grey.net.cliques$cliques # a full list of cliques, all sizes

grey.net.cliques$cliques[[2]] # cliques of size 2


#===============================================
# COMPONENTS
#===============================================
#Components are sections of a graph which are internally connected but not tied to other sections of the graph . 
# How many connected components do we have in the network? components()

# connected ="strong" means v1 and v2 are connected if there is a directed path 
# from v1 to v2 and from v2 to v1.
# connected = "weak" means v1 and v2 are connected if there is a semi-path
# (i.e. path ignoring the link direction) from v1 to v2 and v2 to v1.

# Number of components:
components(grey.net, connected="strong")
components(grey.net, connected="weak")


# Which node belongs to which component? component.dist()

grey.comp <- component.dist(grey.net, connected="strong")
grey.comp

grey.comp$membership # The component each node belongs to
grey.comp$csize      # The size of each component
grey.comp$cdist      # The distribution of component sizes

# Which nodes in the network, if removed, will increase the
# number of components we find?

cutpoints(grey.net, connected="strong")

# Let's remove one of the cutpoints and count components again.

grey.net.cut <- grey.net[-3,-3] # remember "-3" selects all bit the third row/column.
# So grey.net.cut will be grey.net with node 1 removed.
components(grey.net.cut, connected="strong")

class(grey.net.cut)
grey.cut.net <- network(grey.net.cut, vertex.attr=ga.atts, vertex.attrnames=colnames(ga.atts),
        directed=F, hyper=F, loops=F, multiple=F, bipartite=F)
plot(grey.cut.net)
