n=100
p=300

I_300 = diag(1, 300)

I_30 = diag(1, 30)
C_10 = matrix(0.8, nrow = 10, ncol = 10) + diag(0.2, 10)

Cov_2 = I_30 %x% C_10

covs = list(I_300, Cov_2)
cov_lab = c('I_300', 'Cov_2')

X = rmvnorm(1, mean=rep(0,10))

LW_optimal_lambda <- function(X){
  Yks = apply(X, 1, function(row){
    cov(row)
  })
  return(Yks)
}

LW_optimal_lambda(X)

library(mvtnorm)

matrices <- lapply(1:100, function(iter){
  lapply(1:2, function(i){
    cov_mat = covs[[i]]
    mu = rep(0, 300)
    X = rmvnorm(100, mean=mu, sigma = cov_mat)
    S = cov(X)
    
    lLW = linearShrinkLWEst(X)
    nlLW = nlShrinkLWEst(X)
    
    risk_S = sum((cov_mat - S)^2)
    risk_lLW =sum((cov_mat - lLW)^2)
    risk_nlLW = sum((cov_mat - nlLW)^2)
    
    list(label = cov_lab[i],
      risk_S = risk_S,
      risk_lLW = risk_lLW,
      risk_nlLW = risk_nlLW)
  })
})

matrices_table = rbindlist(unlist(matrices, F, F))

boxplots = lapply(c('risk_S', 'risk_lLW', 'risk_nlLW'), function(risk){
  ggplot(data=matrices_table, aes(y= .data[[risk]])) +
    geom_boxplot(fill='steelblue', col='black') +
    facet_grid(~label) +
    theme_bw() +
    ylim(0, 1000)
})

boxplots[[1]] + boxplots[[2]] + boxplots[[3]]



