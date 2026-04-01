set.seed(1, kind = 'Mersenne-Twister')

n <- 500
m <- 252

mat <- matrix(rnorm(n * m, mean=0.2, sd=0.3),ncol=m)
