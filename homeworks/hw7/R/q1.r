### Load data

data <- read.csv("./homeworks/hw7/data/creditpr.csv", header = T)

### Part B

## LDA Model

# Mean values of non-payers
mu_x <- colMeans(data[data$Failed == 1, c("Paycheck", "Months")])

# Mean values of payers
mu_y <- colMeans(data[data$Failed == 0, c("Paycheck", "Months")])

# num_payers
n_x <- sum(data$Failed == 0)

# num_nonpayers
n_y <- sum(data$Failed == 1)

# Covariance matrix
# Omega <- cov(data[, c("Paycheck", "Months")])
Omega <- (1 / (n_x + n_y - 2)) *
    ((n_x - 1) * cov(data[data$Failed == 0, c("Paycheck", "Months")]) +
        (n_y - 1) * cov(data[data$Failed == 1, c("Paycheck", "Months")]))

# Covariance matrix inverse
Omega_inv <- solve(Omega)

# Translation vector
s <- (mu_x + mu_y) / 2

# Normal vector
n <- Omega_inv %*% (mu_x - mu_y)

# Define slope and intercept
slope <- -n[1] / n[2]
intercept <- (n[1] * s[1] + n[2] * s[2]) / n[2]

### Part C

## Total empirical misclassification

# Number of misclassified payers
n_payers <- sum(
    (data$Failed == 0) & (data$Paycheck * slope + intercept < data$Months)
)

# Empirical misclassification rate of payers
payers_misclass <- n_payers / sum(data$Failed == 0)

cat("Empirical misclassification rate of payers:", payers_misclass, "\n")

# Number of misclassified non-payers
n_nonpayers <- sum(
    (data$Failed == 1) & (data$Paycheck * slope + intercept > data$Months)
)

# Empirical misclassification rate of non-payers
nonpayers_misclass <- n_nonpayers / sum(data$Failed == 1)

cat("Empirical misclassification rate of non-payers:", nonpayers_misclass, "\n")

# Total empirical misclassification
empirical_misclass <- payers_misclass + nonpayers_misclass

# Print total empirical misclassification
cat("Total empirical misclassification:", empirical_misclass, "\n")

## Total theoretical misclassification

# Compute delta
delta <- sqrt(t((mu_x - mu_y)) %*% Omega_inv %*% (mu_x - mu_y))

# Total theoretical misclassification
theoretical_misclass <- 2 * pnorm(delta / -2)

# Print total theoretical misclassification
cat("Total theoretical misclassification:", theoretical_misclass, "\n")

## Plotting

# Open a png device
png("./homeworks/hw7/plots/q1b.png", width = 1600, height = 1200)

# Set margins
par(mar = c(8, 8, 8, 8))

# Make scatterplot
plot(
    data$Paycheck,
    data$Months,
    col = ifelse(data$Failed == 1, "red", "green"),
    pch = 16,
    xlab = "Paycheck",
    ylab = "Months at Work",
    main = "Scatterplot of Paycheck vs. Months at Work",
    cex.main = 3,
    cex.lab = 2,
    cex.axis = 2
)

# Add decision boundary (z - s)^T %*% n = 0

# Generate a sequence of x values to use for the decision boundary
x_values <- seq(min(data$Paycheck), max(data$Paycheck), by = 0.1)

# Compute the corresponding y values for the decision boundary
y_values <- slope * x_values + intercept

# Add the decision boundary to the plot
lines(
    x_values,
    y_values,
    col = "blue",
    lwd = 2
)

# Add text in the center displaying the total empirical misclassification
text(
    x = 1400,
    y = 85,
    paste(
        "Total empirical misclassification:",
        round(empirical_misclass, 4)
    ),
    cex = 1.5
)

# Add text in the center displaying the total theoretical misclassification
text(
    x = 1400,
    y = 80,
    paste(
        "Total theoretical misclassification:",
        round(theoretical_misclass, 4)
    ),
    cex = 1.5
)

# Add legend
legend(
    "bottomright",
    legend = c("Failed Payment", "Successful Payment", "Decision Boundary"),
    col = c("red", "green", "blue"),
    pch = c(16, 16, NA),
    lty = c(NA, NA, 1),
    lwd = c(NA, NA, 2),
    cex = 2
)

# Close the png device
dev.off()

### Part D

# Computer the theoretical AUC
AUC <- pnorm(delta / sqrt(2))

cat("Theoretical/Binomial AUC:", AUC, "\n")

# Define paycheck thresholds
paycheck_limits <- range(data$Paycheck)
thresholds <- seq(paycheck_limits[1], paycheck_limits[2], length.out = 100)

## Get the binomial CDF's of payers and non-payers

# Non-Payers:
x_cdf <- pnorm((thresholds - mu_x[1]) / sqrt(Omega[1, 1]))
# Payers
y_cdf <- pnorm((thresholds - mu_y[1]) / sqrt(Omega[1, 1]))

## Plotting

# Open a png device
png("./homeworks/hw7/plots/q1d.png", width = 1600, height = 1200)

# Set margins
par(mar = c(8, 8, 8, 8))

# Plot the binomial ROC curve (cdf_y vs cdf_x)
plot(
    y_cdf,
    x_cdf,
    type = "l",
    col = "blue",
    lwd = 2,
    xlab = "Payers CDF (1 - Specificity)",
    ylab = "Non-Payers CDF (Sensitivity)",
    main = "Binomial ROC Curve For Identification of Non-Payers",
    cex.main = 3,
    cex.lab = 2,
    cex.axis = 2
)

# Add the diagonal line
lines(
    c(0, 1),
    c(0, 1),
    col = "black",
    lwd = 2,
    lty = 2
)

# Add text in middle of plot to display AUC %
text(
    x = 0.35,
    y = 0.6,
    labels = paste("AUC = ", round(AUC, 3) * 100, "%", sep = ""),
    cex = 3
)

# Add legend
legend(
    "bottomright",
    legend = c("ROC Curve", "45 Degree Line"),
    col = c("blue", "black"),
    lwd = c(2, 2),
    lty = c(1, 2),
    cex = 2
)

# Close the png device
dev.off()
