#set.seed(1, kind = 'Mersenne-Twister')

k <- 1000
p <- .5
walk_sim <- function(k, p){
  steps <- sample(c(1,-1), k, replace=T, prob=c(p,1-p))
  walk <- cumsum(steps)
  
  plotting_walk <- data.frame(id = 1:k, walk=walk, walk_cummax=cummax(walk), walk_cummin=cummin(walk))
  
  
  plot = ggplot(data=plotting_walk, aes(x=id)) +
    geom_line(aes(y=walk)) +
    geom_line(aes(y=cummax(walk)), col='blue') +
    geom_line(aes(y=cummin(walk)), col = 'red') +
    geom_hline(yintercept = 0, linetype='dashed') +
    theme_bw()
  
  plot
  
  
  ##
  
  where_zero <- which(walk == 0)
  num_zero_crosses <- length(where_zero)
  return(list(plot = plot, where_zero=where_zero, num_zero_crosses=num_zero_crosses))
}
walk_sim(1000, .5)


#no bardzo sie zmieniaja