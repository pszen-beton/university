library(ggplot2)

set.seed(1, kind = 'Mersenne-Twister')

k=1000

vector <- -k:k
vector_shuffled <- sample(vector)
vector_shuffled_cumsum <- cumsum(vector_shuffled)
vector_shuffled_cummax <- cummax(vector_shuffled)

vector_removed_cumsum <- vector_shuffled[vector_shuffled>=vector_shuffled_cumsum]
vector_removed_cummax <- vector_shuffled[vector_shuffled>=vector_shuffled_cummax]

df_plotting <- data.frame(id = 1:2001, shuffled = vector_shuffled, cumsum=vector_shuffled_cumsum, cummax=vector_shuffled_cummax)
ggplot(data=df_plotting, aes(x=id)) +
         geom_point(aes(y=shuffled)) +
         geom_line(aes(y=cumsum), col='red') +
         geom_line(aes(y=cummax), col='green') + 
         theme_bw()
