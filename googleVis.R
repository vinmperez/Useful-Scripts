################This is an R Script to do some things##########################
#Vincent Perez
#03/11/2019
#===================================================================================================#
###Move in to the correct directory and set your working directory,duh. ###

library(googleVis)

dat <- structure(list(Program = c("R", "R", "R", 
                                  "Python", "Python", "Python", "Linux ",
                                  "Linux ", "Linux ", "Windows Powershell", "Windows Powershell",
                                  "Windows Powershell", "Predictive Modeling", "Predictive Modeling", "Predictive Modeling", "Batch Scripting",
                                  "Batch Scripting", "Batch Scripting", "Cluster Computing", "Cluster Computing", "Cluster Computing", "Matlab",
                                  "Matlab", "Matlab"), 
                      Program_Type = structure(c(1L, 2L, 3L, 1L, 2L, 3L, 1L, 
                                                2L, 3L, 1L, 2L, 3L, 1L, 2L, 
                                                3L, 1L, 2L, 3L, 1L, 2L, 3L, 
                                                1L, 2L, 3L), 
                                              class = "factor", 
                                              .Label = c("Package", 
                                                         "IDE", 
                                                         "")), 
                      Frequency_of_Use = c(0.37, 0.22, 0.41, 0.3, 0.31, 0.39, 
                                     0.35, 0.06, 0.59, 0.19, 0.2, 0.61, 
                                     0.4, 0.18, 0.42, 0.16, 0.28, 0.56, 
                                     0.27, 0.06, 0.67, 0.37, 0.08, 0.55)),
                 .Names = c("Program", "Program Type", "Frequency of Use"), 
                 row.names = c(NA, -24L), 
                 class = c("data.table", "data.frame"))

link_order <- unique(dat$Program)
node_order <- unique(as.vector(rbind(dat$Program, as.character(dat$Program_Type))))

link_cols <- data.frame(color = c('#ffd1ab', '#ff8d14', '#ff717e', '#dd2c40', '#d6b0ea', 
                                  '#8c4fab','#00addb','#297cbe'), 
                        Program = c("Cluster Computing", "Linux ", "Matlab", "Windows Powershell", "Batch Scripting", "Predictive Modeling", "R", "Python"),
                        stringsAsFactors = F)

node_cols <- data.frame(color = c("#ffc796", "#ff7100", "#ff485b", "#d20000", 
                                  "#cc98e6", "#6f2296", "#009bd2", "#005daf", 
                                  "grey", "grey", "grey"),
                        type = c("Cluster Computing", "Linux ", "Matlab", "Windows Powershell", "Batch Scripting", "Predictive Modeling", 
                                 "R", "Python", "multi", "desktop", "mobile"))

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