library(ggplot2)

## 2

cp <- function(S, K){
  return(max(S - K, 0))
}

pp <- function(S, K){
  return(max(K - S, 0))
}

cp <- Vectorize(cp, vectorize.args="S")
cp(args,80) - cp(args, 120)


args <- seq(0,200.1, 0.1)
cp(args, 80)
case_a <- sapply(args, function(S){cp(S,80) - cp(S,120)})
case_b <- sapply(args, function(S){pp(S,120) - pp(S,80)})
case_c <- sapply(args, function(S){cp(S,50) + cp(S,150) - 2 * cp(S,100)})

df_plotting <- data.frame(S = args, case_a, case_b, case_c)

ggplot(df_plotting, aes(x=S)) +
  #geom_line(aes(y=case_a)) +
  #geom_line(aes(y=case_b), col = 'red') +
  geom_line(aes(y=case_c), col = 'blue') +
  theme_bw() +
  ylab('value')
