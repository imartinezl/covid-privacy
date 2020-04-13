library(dplyr)

df <- read.csv("sketch_200407a/result.txt") %>% na.omit()

relations <- data.frame(from = df$agent_A, to=df$agent_B,
                        ts=df$ts, dist=df$dist) %>% 
  dplyr::group_by(from, to) %>% 
  dplyr::summarise(n = n())

agents <- union(relations$from, relations$to)

g <- igraph::graph_from_data_frame(relations, directed=T, vertices=agents)
igraph::E(g)$weight <- igraph::edge.attributes(g)$n

plot(g, layout=igraph::layout_nicely, 
     shape = "circle",
     vertex.size=1, vertex.color="black",
     vertex.label = NA, vertex.label.dist=1,  
     edge.arrow.size=0.05, edge.arrow.width=1, 
     # edge.width = relations$n, 
     edge.color="#FF000010", edge.curved=F)
