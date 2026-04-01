set.seed(1, kind = 'Mersenne-Twister')

k <- 100000

dis <- function(c, t) {
  return(c * exp(-.05 * t))
}

v1 <- rexp(k, 1 / 5)
v2 <- runif(k, 0, 20)

df_plotting <- data.frame(v1 = v1, v2 = v2)

ggplot(data = df_plotting, aes(x = v1, y = v2)) + geom_point()

mean(dis(v1, v2))
