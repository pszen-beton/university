n=100
p=300

I_300 = diag(1, 300)

I_30 = diag(1, 30)
C_10 = matrix(0.8, nrow = 10, ncol = 10) + diag(0.2, 10)

Cov_2 = I_30 %x% C_10

covs = c(I_300, Cov_2)

library(mvtnorm)

matrices <- lapply(1:100, function(iter){
  lapply(covs, function(c){
    mu = rep(0, 300)
    X = rmvnorm(100, mean=mu, sigma = c)
    S = cov(X)
    
    risk = sum((c - S)^2)
    
    list(risk = risk)
  })
})
