################This is an R Script to do some things##########################
#Vincent Perez
#03/11/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory,duh. ###

library(googleVis)

dat <- structure(list(Program = c("ggplot","ggplot","ggplot","ggplot", "matplotlib","matplotlib","matplotlib","matplotlib", 
                                  "grep","grep","grep","grep","awk","awk","awk","awk","sed","sed","sed","sed",
                                  "findstr","findstr","findstr","findstr","carot","carot","carot","carot","gplots","gplots","gplots","gplots",
                                  "panda","panda","panda","panda","numbpy","numbpy","numbpy","numbpy","pyplot","pyplot","pyplot","pyplot",
                                  "github","github","github","github","scripting","scripting","scripting","scripting"), 
                      Program_Type = structure(c(1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L,
                                                 1L, 2L, 3L, 4L), 
                                              class = "factor", 
                                              .Label = c("R Programming Language", 
                                                         "Python Programming Language", 
                                                         "Linux/Unix",
                                                         "Windows Command/Powershell")), 
                      Frequency_of_Use = c(0.90,0.10,0,0,
                                           0,1,0,0,
                                           0,0,1,0,
                                           0,0,1,0,
                                           0,0,1,0,
                                           0,0,0,1,
                                           1,0,0,0,
                                           1,0,0,0,
                                           0,1,0,0,
                                           0,1,0,0,
                                           0,1,0,0,
                                           0.5,0.5,0,0,
                                           0,0,0.5,0.5)),
                 .Names = c("Program", "Program Type", "Frequency of Use"), 
                 row.names = c(NA, -52L), 
                 class = c("data.table", "data.frame"))

link_order <- unique(dat$Program)
node_order <- unique(as.vector(rbind(dat$Program, as.character(dat$Program_Type))))

link_cols <- data.frame(color = c("#ffc796", "#ff7100", "#ff485b", "#d20000", 
                                  "#cc98e6", "#6f2296", "#009bd2", "#005daf", 
                                  "ffc796", "#ff7100", "#ff485b", "#d20000","#cc98e6"), 
                        Program = c("ggplot", "matplotlib", "grep","awk","sed","findstr","carot","gplots","panda","numbpy","pyplot",
                                    "github","scripting"),
                        stringsAsFactors = F)

node_cols <- data.frame(color = c("#ffc796", "#ff7100", "#ff485b", "#d20000", 
                                  "#cc98e6", "#6f2296", "#009bd2", "#005daf", 
                                  "ffc796", "#ff7100", "#ff485b", "#d20000","#cc98e6"),
                        type = c("ggplot", "matplotlib", "grep","awk","sed","findstr","carot","gplots","panda","numbpy","pyplot",
                                 "github","scripting"))

link_cols2 <- sapply(link_order, function(x) link_cols[x == link_cols$Program, "color"])
node_cols2 <- sapply(node_order, function(x) node_cols[x == node_cols$type, "color"])

actual_link_cols <- paste0("[", paste0("'", link_cols2,"'", collapse = ','), "]")
actual_node_cols <- paste0("[", paste0("'", node_cols2,"'", collapse = ','), "]")

opts <- paste0("{
               link: { colorMode: 'source',
               colors: ", actual_link_cols ," },
               node: {colors: ", actual_node_cols ,"}}")

Sankey <- gvisSankey(dat, 
                     from = "Program", 
                     to = "Program_Type", 
                     weight = "Frequency_of_Use",
                     options = list(height = 500, width = 1000, sankey = opts))

plot(Sankey) 