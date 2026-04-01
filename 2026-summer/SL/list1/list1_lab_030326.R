#no need - problem1, problem2

library(ellipse)
library(ggplot2)
library(xtable)
library(patchwork)

WL_raw <- read.table('WeightLength.txt', header=TRUE)
WeightLength <- read.table('WeightLength.txt', header = TRUE)

ParentsWeightLength <- read.table('ParentsWeightLength.txt', header = TRUE)

WL_mean <- apply(WeightLength, 2, mean)
WL_cov <- cov(WeightLength)


# 1. Scatterplot
p_scatter <- ggplot(WeightLength, aes(x = Length, y = Weight)) +
  geom_point(alpha = 0.5, color = "steelblue") +
  theme_bw()

ggsave('p_scatter.pdf', device=cairo_pdf, width=10, height=5)

# 2. QQ-plot for Length
p_qq_length <- ggplot(WeightLength, aes(sample = Length)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  theme_bw() +
  xlab('') +
  ylab('')

# 3. QQ-plot for Weight
p_qq_weight <- ggplot(WeightLength, aes(sample = Weight)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  theme_bw() +
  xlab('') +
  ylab('')

p_qq_length + p_qq_weight

df_ellipse_75 <- data.frame(ellipse(WL_cov, centre=WL_mean, level=0.75))
df_ellipse_95 <- data.frame(ellipse(WL_cov, centre=WL_mean, level=0.95))



group <- function(x, mean, cov){
  inverse = solve(cov)
  if(t(x-mean)%*%inverse%*%(x-mean) <= qchisq(0.75, 2)){
    return(0)
  } else if(t(x-mean)%*%inverse%*%(x-mean) <= qchisq(0.95, 2)){
    return(1)
  } else{
    return(2)
  }
}

groups <- apply(WeightLength, 1, function(x){group(x, WL_mean, WL_cov)})
groups <- as.factor(groups)
WeightLength <- cbind(WeightLength, groups)
sum(groups == 0)
sum(groups == 1)
sum(groups == 2)

ggplot(data=WeightLength, (aes(x=Weight, y=Length))) +
  geom_point(aes(col=groups)) +
  theme_bw() +
  geom_path(data=df_ellipse_75, aes(x=Weight, y=Length), col='#CC79A7') +
  geom_path(data=df_ellipse_95, aes(x=Weight, y=Length), col='#F0E442') + 
  scale_color_manual(
    values = c("0" = "#CC79A7", "1" = "#F0E442", "2" = "#0072B2"),
    name = "Score Given"
  )
#girls code fun - bio-stat community



library(colorBlindness)
elips


P <- eigen(WL_cov)$vectors

transformed <- data.frame(t(apply(WL_raw, 1, function(X){t(P) %*% X})))

ggplot(data=transformed, aes(x=X1, y=X2)) + geom_point(col = 'steelblue', alpha=0.5) + theme_bw()
cor(transformed$X1, transformed$X2)


#####

# 1. Combine the transformed data with the group labels
transformed$groups <- WeightLength$groups

# 2. Function to transform the ellipse paths
# We use the same P matrix to rotate the ellipse coordinates
transform_path <- function(df, P) {
  # Extract numeric columns, multiply by t(P), and convert back to data frame
  path_matrix <- as.matrix(df[, c("Weight", "Length")])
  trans_path <- t(t(P) %*% t(path_matrix)) 
  colnames(trans_path) <- c("X1", "X2")
  return(as.data.frame(trans_path))
}

# Apply the transformation to your existing ellipse data frames
df_ellipse_75_trans <- transform_path(df_ellipse_75, P)
df_ellipse_95_trans <- transform_path(df_ellipse_95, P)

# 3. Create the plot
ggplot(data = transformed, aes(x = X1, y = X2)) +
  geom_point(aes(col = groups), alpha = 0.6) +
  # Add the transformed ellipses
  geom_path(data = df_ellipse_75_trans, aes(x = X1, y = X2), col = '#CC79A7', size = 1) +
  geom_path(data = df_ellipse_95_trans, aes(x = X1, y = X2), col = '#F0E442', size = 1) +
  # Keep the same color scheme for consistency
  scale_color_manual(
    values = c("0" = "#CC79A7", "1" = "#F0E442", "2" = "#0072B2"),
    name = "Score Given"
  ) +
  theme_bw()


