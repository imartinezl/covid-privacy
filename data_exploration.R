library(dplyr)

df <- read.csv("sketch_covid_vicomtech/result.txt") %>% na.omit()



df_contacts <- df %>% 
  dplyr::group_by(agent_A, agent_B) %>%
  dplyr::mutate(date_step = date-lag(date, default = min(date)),
                contact = cumsum(date_step > 2)) %>% 
  dplyr::ungroup() %>% 
  dplyr::group_by(agent_A, agent_B, contact) %>% 
  dplyr::summarise(date_start = min(date, na.rm=T),
                   date_stop = max(date, na.rm=T),
                   duration = date_stop - date_start,
                   dist_min = round(min(dist, na.rm=T), 2),
                   dist_mean = round(mean(dist, na.rm=T), 2),
                   dist_max = round(max(dist, na.rm=T), 2)) %>% 
  dplyr::ungroup() #%>% 
  #dplyr::select(-contact)

df_contacts %>% write.csv(file="contacts.csv", row.names = F)

g <- df_contacts %>% 
  dplyr::group_by(agent_A, agent_B) %>% 
  dplyr::summarise(duration_mean = mean(duration),
                   dist_mean = mean(dist_mean),
                   dist_min = min(dist_min),
                   dist_max = max(dist_max),
                   weight = duration_mean*(1/dist_min)) %>% 
  igraph::graph_from_data_frame(directed=T)
#igraph::E(g)$weight <- igraph::edge.attributes(g)$weight
igraph::E(g)$width <- scales::rescale(igraph::E(g)$weight, to = c(1, 20))

plot(g, layout=igraph::layout_nicely, 
     shape = "circle",
     vertex.size=1, vertex.color="black",
     vertex.label = NA, vertex.label.dist=1,  
     edge.arrow.size=0.05, edge.arrow.width=1, 
     # edge.width = relations$n, 
     edge.color="#FF000010", edge.curved=F)

  # IGRAPH ------------------------------------------------------------------

relations <- df_contacts %>% 
  dplyr::rename(from = agent_A, to=agent_B) %>% 
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

