library(ggplot2)
library(gridExtra)
set.seed(1, kind = 'Mersenne-Twister')

## 1
k <- 1000
reps <- k/8


wave_pos <- c(0,1,2,1)
wave_neg <- - wave_pos


wave <- rep(c(wave_pos,wave_neg), reps)

wave_plotting <- data.frame(id = 1:k, wave = wave, wave_cumsum = cumsum(wave))

p1 <- ggplot(data=wave_plotting, aes(x=id)) +
  geom_line(aes(y=wave)) +
  geom_hline(yintercept = mean(wave)) +
  theme_bw()

p2 <- ggplot(data=wave_plotting, aes(x=id)) +
  geom_line(aes(y=wave_cumsum), col = 'red') +
  geom_hline(yintercept = mean(wave_plotting$wave_cumsum)) +
  theme_bw()

grid.arrange(p2,p1)

ggplot(data=wave_plotting, aes(x=id)) +
  geom_line(aes(y=wave)) +
  geom_line(aes(y=wave_cumsum), col = 'red') +
  geom_hline(yintercept = mean(wave)) +
  geom_hline(yintercept = mean(wave_plotting$wave_cumsum)) +
  theme_bw() + lims(y=c(-5,5), x=c(0,10))

sd(wave_plotting$wave)
sd(wave_plotting$wave_cumsum)
