#cv.cov.est(?)
k <- 4000
X <- matrix(rnorm(100), ncol=10)
X_big_list <- lapply(1:3, function(iter){matrix(rnorm(k*k), nrow=k)})

params <- list(c(400,100), c(4000, 1000), c(100, 400), c(1000,4000))

dmarchenko <- function(x, c){
  a = (1 - sqrt(c)) ^ 2
  b = (1 + sqrt(c)) ^ 2
  if(x >= a && x<=b){
    Fc = (sqrt(b - x) * sqrt(x - a)) / (2 * pi * c * x)
  } else{
    Fc = 0
  }
  if(c > 0 && c <= 1){
    return(Fc)
  } else if(c>1){
    if (x == 0){
      return((1/c)*Fc + (1 - (1/c)))
    } else{
      return(Fc)
    }
  }
}

dmp <- Vectorize(dmarchenko, vectorize.args='x')

results <- lapply(X_big_list, function(X){
  lapply(params, function(param){
    X_subset <- X[1:param[1],1:param[2]]
    S = (1 / param[1]) * t(X_subset) %*% X_subset
    eigenvalues = eigen(S, only.values=T)$values
    
    c = param[2] / param[1]
    
    xs = c(seq(0,9.9, 0.1), rep(0, (length(eigenvalues)-100)))
    dmp_value = dmp(xs, c)
    
    list(case = rep(paste0(as.character(param[1]), ', ', as.character(param[2])), length(eigenvalues)),
         eigenvalues = eigenvalues,
         xs = xs,
         dmp_value = dmp_value)
  })
})

results_unl <- unlist(results, F, F)
library(data.table)
library(ggplot2)

results_table = rbindlist(results_unl)

ggplot(data = results_table, aes(x=eigenvalues)) +
geom_histogram(aes(y=after_stat(density)), col='white') +
geom_line(aes(x = xs, y = dmp_value), col = 'red') +
facet_wrap(~case) + 
theme_bw()






