### Load data

data <- read.csv("./homeworks/hw7/data/creditpr.csv", header = T)

### Part b

## LDA Model

# Mean values of payers
mu_x <- colMeans(data[data$Failed == 0, c("Months", "Paycheck")])

# Mean values of non-payers
mu_y <- colMeans(data[data$Failed == 1, c("Months", "Paycheck")])

# Covariance matrix
Omega <- cov(data[, c("Months", "Paycheck")])

# Covariance matrix inverse
Omega_inv <- solve(Omega)

# Translation vector
s <- (mu_x + mu_y) / 2

# Normal vector
n <- Omega_inv %*% (mu_x - mu_y)

# Plotting

# Open a png device
png("./homeworks/hw7/plots/q1b.png", width = 1600, height = 1200)

# Set margins
par(mar = c(8, 8, 8, 8))

# Make scatterplot
plot(
    data$Months,
    data$Paycheck,
    col = ifelse(data$Failed == 1, "red", "green"),
    pch = 16,
    xlab = "Months at Work",
    ylab = "Paycheck",
    main = "Scatterplot of Months at Work vs Paycheck",
    cex.main = 3,
    cex.lab = 2,
    cex.axis = 2
)

# Add decision boundary (z - s)^T %*% n = 0

# Define slope and intercept
slope <- n[1] / n[2]
intercept <- s[2] - (n[1] / n[2]) * s[1]

# Generate a sequence of x values to use for the decision boundary
x_values <- seq(min(data$Months), max(data$Months), by = 0.1)

# Compute the corresponding y values for the decision boundary
y_values <- slope * x_values + intercept

# Add the decision boundary to the plot
lines(
    x_values,
    y_values,
    col = "blue",
    lwd = 2
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
