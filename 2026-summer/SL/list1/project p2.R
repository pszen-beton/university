library(ggplot2)
library(ellipse)
library(patchwork)
library(xtable)
library(GGally)

# --- Task 0: Load Data ---
PWL <- read.table('ParentsWeightLength.txt', header = TRUE)
# Ensure columns are named for clarity
colnames(PWL) <- c("FatherHeight", "MotherHeight", "Weight", "Length")

print(xtable(head(PWL)), include.rownames = F)

# --- Task 1: Mean and Covariance (all four variables) ---
PWL_mean <- colMeans(PWL)
PWL_cov <- cov(PWL)

print("Mean Vector (Father, Mother, Weight, Length):")
print(PWL_mean)
print("4x4 Covariance Matrix:")
print(PWL_cov)

# --- Task 2: Graphical Normality Verification ---
ggpairs(PWL, 
        columns = 1:4, 
        mapping = aes(alpha = 0.5),
        upper = list(continuous = wrap("cor", size = 3)),
        lower = list(continuous = wrap("points", size = 0.8, color = 'steelblue')),
        diag = list(continuous = wrap("densityDiag"))) +
  theme_bw()


# Marginal QQ-plots
qq_plots <- lapply(names(PWL), function(var) {
  ggplot(PWL, aes(sample = .data[[var]])) +
    stat_qq() + stat_qq_line(col = "red") +
    labs(title = paste("qq-plot:", var)) + theme_bw() +
    xlab('') + ylab('')
})
(qq_plots[[1]] + qq_plots[[2]]) / (qq_plots[[3]] + qq_plots[[4]])

# --- Task 3: Conditional Distribution of (Weight, Length) given Parents ---
# Based on your order: 1=Father, 2=Mother (X2), 3=Weight, 4=Length (X1)
mu_p <- PWL_mean[1:2] # Parent means
mu_c <- PWL_mean[3:4] # Child means

S_pp <- PWL_cov[1:2, 1:2] # Var-Cov of Parents
S_cc <- PWL_cov[3:4, 3:4] # Var-Cov of Child (Weight/Length)
S_cp <- PWL_cov[3:4, 1:2] # Cov between Child and Parents
S_pc <- PWL_cov[1:2, 3:4] # Transpose of S_cp

# Conditional Covariance Matrix (Σ1|2 = Σ11 - Σ12 * Σ22^-1 * Σ21)
# This is the uncertainty remaining after accounting for parent heights
S_cond <- S_cc - S_cp %*% solve(S_pp) %*% S_pc

print("Conditional Covariance Matrix (Weight & Length given Parents):")
print(S_cond)

# --- Task 4 & 5: Conditional Scoring ---
# Function to get conditional mean for a specific set of parents
get_cond_mean <- function(parent_vals) {
  mu_c + S_cp %*% solve(S_pp) %*% (as.numeric(parent_vals) - mu_p)
}

# Function to assign score based on conditional Mahalanobis distance
score_conditional <- function(child_vals, cond_mu, cond_cov) {
  dist <- t(child_vals - cond_mu) %*% solve(cond_cov) %*% (child_vals - cond_mu)
  if(dist <= qchisq(0.75, 2)) return(0)
  else if(dist <= qchisq(0.95, 2)) return(1)
  else return(2)
}

# Apply to all rows
cond_scores <- sapply(1:nrow(PWL), function(i) {
  p_vals <- PWL[i, 1:2]
  c_vals <- as.numeric(PWL[i, 3:4])
  mu_target <- get_cond_mean(p_vals)
  score_conditional(c_vals, mu_target, S_cond)
})

PWL$group_cond <- as.factor(cond_scores)
print("Conditional Score Counts:")
table(PWL$group_cond)

# --- Task 6: Case Study (Father 185, Mother 178) ---
target_p <- c(185, 178)
mu_specific <- get_cond_mean(target_p)

df_ell_75 <- data.frame(ellipse(S_cond, centre = mu_specific, level = 0.75))
df_ell_95 <- data.frame(ellipse(S_cond, centre = mu_specific, level = 0.95))

ggplot(PWL, aes(x = Weight, y = Length)) +
  geom_point(aes(color = group_cond), alpha = 0.4) +
  geom_path(data = df_ell_75, color = "#CC79A7", size = 1) +
  geom_path(data = df_ell_95, color = "#F0E442", size = 1) +
  theme_bw() +
  scale_color_manual(
    values = c("0" = "#CC79A7", "1" = "#F0E442", "2" = "#0072B2"),
    name = "Score Given"
  )

# --- Task 7: Spectral Decomposition (4x4) ---
# Calculate the eigenvectors from the covariance matrix of all 4 variables
eigen_4x4 <- eigen(PWL_cov)
P_matrix <- eigen_4x4$vectors  # Matrix where columns are eigenvectors

# --- Task 8: Transformation and Pairwise Scatterplots ---

# 1. Transform the data: Y = P^T * X
# We subtract the mean first (centering) to center the transformation at the origin (0,0,0,0)
data_centered <- scale(PWL[, 1:4], center = TRUE, scale = FALSE)
transformed_4d <- data.frame(t(apply(data_centered, 1, function(row) {
  t(P_matrix) %*% as.numeric(row)
})))

# Rename columns to Principal Components (PC1 to PC4)
#colnames(transformed_4d) <- c("PC1", "PC2", "PC3", "PC4")

# 2. Plot Scatterplots of all pairs


# Option B: Using Base R (Quickest, no extra package needed)
pairs(transformed_4d, main = "Pairwise Scatterplots (PC1-PC4)", 
      pch = 16, col = rgb(0, 0, 0.5, 0.3))


plot_data <- cbind(transformed_4d, Group = PWL$group_cond)

# 2. Basic Plot
ggpairs(plot_data, columns = 1:4, lower = list(continuous = wrap("points", color = "steelblue", alpha = 0.4, size = 0.8))) + theme_bw() # columns 1 to 4 are PC1-PC4

# 3. Enhanced Plot (Color-coded by your conditional scores)
ggpairs(plot_data, 
        columns = 1:4, 
        mapping = aes(alpha = 0.5),
        upper = list(continuous = wrap("cor", size = 3)),
        lower = list(continuous = wrap("points", size = 0.8, color = 'steelblue')),
        diag = list(continuous = wrap("densityDiag"))) +
  theme_bw()
