### Loading Data ###

data <- read.csv("./homeworks/hw6/data/bp.csv", header = T)

### Part A ###

# Define patients with hypertension
X <- data[data$high == 1, ]
# Define patients without hypertension
Y <- data[data$high == 0, ]

# Define the empirical cdf's
cdf_x <- ecdf(X$BP)
cdf_y <- ecdf(Y$BP)

# Define plot limits
xlim <- range(data$BP)
ylim <- c(0, 1)

# Define the x labels
x_labels <- c(
    80,
    100,
    120,
    140,
    160,
    180,
    200,
    220
)

## Plotting

# Open a png device
png("./homeworks/hw6/plots/q2a.png", width = 1600, height = 1200)

# Set up margins
par(mar = c(8, 8, 8, 8))

# Plot the empiral cdf's
plot(
    cdf_x,
    verticals = TRUE,
    do.points = FALSE,
    xlim = xlim,
    ylim = ylim,
    main = "Empirical CDF for Blood Pressure of Hypertension
    & Non-Hypertension Patients",
    cex.main = 3,
    xlab = "Blood Pressure",
    ylab = "Empirical CDF (Probability)",
    cex.lab = 2,
    cex.axis = 2,
    col = "red",
    lwd = 3,
    xaxt = "n"
)
plot(
    cdf_y,
    verticals = TRUE,
    do.points = FALSE,
    add = TRUE,
    col = "blue",
    lwd = 3
)

# Add rug plot for both hypertension & non-hypertension patients
rug(X$BP, col = "red", lwd = 2, ticksize = 0.075)
rug(Y$BP, col = "blue", lwd = 2, ticksize = 0.025)

# Add x-axis labels
axis(
    side = 1,
    at = x_labels,
    labels = x_labels,
    cex.axis = 2
)

# Add a legend
legend(
    "topleft",
    legend = c(
        "Hypertension Patients",
        "Non-Hypertension Patients"
    ),
    col = c("red", "blue"),
    lwd = 3, cex = 1.5
)

# Close the png device
dev.off()

### Part B ###

# Sort the data
data <- data[order(data$BP), ]

# Define number of patients
n <- nrow(data)

# Define vectors for sensitivity & false positive
sensitivity <- rep(0, n)
false_positive <- rep(0, n)

# Loop through each patient
for (i in 1:n) {
    # Calculate empirical sensitivity & false positive
    sensitivity[i] <- mean(Y$BP < data$BP[i])
    false_positive[i] <- mean(X$BP < data$BP[i])
}

# Define thresholds
thresholds <- seq(xlim[1], xlim[2], length.out = 1000)

# Define binomial cdf's
cdf_x_binom <- pnorm(thresholds, mean = mean(X$BP), sd = sd(X$BP))
cdf_y_binom <- pnorm(thresholds, mean = mean(Y$BP), sd = sd(Y$BP))

## Plotting

# Open a png device
png("./homeworks/hw6/plots/q2b.png", width = 1600, height = 1200)

# Set up margins
par(mar = c(8, 8, 8, 8))

# Plot the binomial ROC curve (cdf_y vs cdf_x)
plot(
    cdf_x_binom,
    cdf_y_binom,
    type = "s",
    xlim = c(0, 1),
    ylim = c(0, 1),
    main = "ROC Curve for Identification of Non-Hypertension Patients",
    cex.main = 3,
    xlab = "False Positive (1 - Specificity)",
    ylab = "Sensitivity",
    cex.lab = 2,
    cex.axis = 2,
    col = "blue",
    lwd = 3
)

# Plot the empirical ROC curve (false positive vs sensitivity)
lines(
    false_positive,
    sensitivity,
    type = "s",
    lwd = 3,
    col = "red"
)

# Add a dashed line for the diagonal
abline(
    a = 0,
    b = 1,
    lty = 2,
    lwd = 3
)

# Add a legend
legend(
    "bottomright",
    legend = c(
        "Empirical ROC Curve",
        "Binomial ROC Curve"
    ),
    col = c("blue", "red"),
    lwd = 3, cex = 1.5
)

# Close the png device
dev.off()

### Part C ###

# Part 1. (sum of rectangles)

# Define AUC
AUC <- 0

# Loop through each patient
for (i in 1:n) {
    if (i > 1) {
        width <- false_positive[i] - false_positive[i - 1]
        height <- sensitivity[i]
        AUC <- AUC + width * height
    }
}

# Print the AUC
cat("AUC calculated using sum of rectangles:", AUC, "\n")

# Part 2. (vectorized computation)

# Define AUC
AUC <- 0

# Define the length of the vectors
Y_len <- length(Y$BP)
X_len <- length(X$BP)

# Define the long vectors
Y_long <- rep(Y$BP, times = X_len)
X_long <- rep(X$BP, times = Y_len)

# Calculate the AUC
AUC <- mean(Y_long < X_long)

# Print the AUC
cat("AUC calculated using vectorized computation:", AUC, "\n")

# Part 3. (theoretical)

# Define distribution parameters
mu_x_hat <- mean(X$BP)
mu_y_hat <- mean(Y$BP)
sigma_x_hat <- sd(X$BP)
sigma_y_hat <- sd(Y$BP)

# Define the AUC
AUC <- pnorm((mu_x_hat - mu_y_hat) / sqrt(sigma_x_hat^2 + sigma_y_hat^2))

# Print the AUC
cat("AUC calculated using theoretical formula:", AUC, "\n")

### Part D ###

# Define the cost of false positive & false negative
false_positive_weight <- 10
false_negative_weight <- 1

# Define an empty vector for the total cost
total_cost_emp <- rep(0, n)

# Loop through each patient
for (i in 1:n) {
    # Calculate the total cost
    total_cost_emp[i] <- false_positive_weight * false_positive[i] +
        false_negative_weight * (1 - sensitivity[i])
}

### TAKE MEAN

# Find the index of the minimum total cost
min_index_emp <- which.min(total_cost_emp)

# Define the empirical optimal threshold
optimal_threshold_emp <- data$BP[min_index_emp]

# Define an empty vector for binomial total cost
total_cost_binom <- rep(0, n)

# Calculate the binomial total cost
total_cost_binom <- false_positive_weight * cdf_x_binom +
    false_negative_weight * (1 - cdf_y_binom)

# Find the index of the minimum total cost
min_index_binom <- which.min(total_cost_binom)

# Define the binomial optimal threshold
optimal_threshold_binom <- thresholds[min_index_binom]

## Plotting

# Open a png device
png("./homeworks/hw6/plots/q2d.png", width = 1600, height = 1200)

# Set up margins
par(mar = c(8, 8, 12, 8))

# Define y-axis limits
ylim <- c(0, max(total_cost_emp))

# Plot the binomial total cost vs threshold
plot(
    thresholds,
    total_cost_binom,
    type = "l",
    xlim = xlim,
    ylim = ylim,
    main = "Total Cost vs Threshold",
    cex.main = 3,
    xlab = "Threshold (Blood Pressure)",
    ylab = "Total Cost (Thousands of Dollars)",
    cex.lab = 2,
    cex.axis = 2,
    col = "blue",
    lwd = 3,
    xaxt = "n"
)

# Plot the empirical total cost vs threshold
lines(
    data$BP,
    total_cost_emp,
    type = "s",
    col = "red",
    lwd = 3
)

# Add a blue dot for the binomial optimal threshold
points(
    optimal_threshold_binom,
    total_cost_binom[min_index_binom],
    col = "blue",
    pch = 19,
    cex = 2.5
)

# Add a red dot for the empirical optimal threshold
points(
    optimal_threshold_emp,
    total_cost_emp[min_index_emp],
    col = "red",
    pch = 19,
    cex = 2.5
)

# Add x-axis labels
axis(
    side = 1,
    at = x_labels,
    labels = x_labels,
    cex.axis = 2
)

# Add a legend total cost
legend(
    "bottomright",
    legend = c(
        paste("Empirical Optimal Threshold: ",
            round(optimal_threshold_emp, 0), " Blood Pressure",
            sep = ""
        ),
        paste(
            "Empirical Minimum Total Cost: $",
            round(total_cost_emp[min_index_emp], 2), " K",
            sep = ""
        ),
        paste("Binomial Optimal Threshold: ",
            round(optimal_threshold_binom, 0), " Blood Pressure",
            sep = ""
        ),
        paste(
            "Binomial Minimum Total Cost: $",
            round(total_cost_binom[min_index_binom], 2), " K",
            sep = ""
        )
    ),
    col = c("red", "red", "blue", "blue"),
    pch = c(19, NA, 19, NA),
    lwd = 0, cex = 1.75,
    pt.cex = c(2.5, NA, 2.5, NA)
)


# Close the png device
dev.off()

### Part E ###

## Plotting

# Open a png device
png("./homeworks/hw6/plots/q2e.png", width = 1600, height = 1200)

# Set up margins
par(mar = c(8, 8, 12, 8))

# Plot the binomial ROC curve (cdf_y vs cdf_x)
plot(
    cdf_x_binom,
    cdf_y_binom,
    type = "s",
    xlim = c(0, 1),
    ylim = c(0, 1),
    main = "ROC Curve for Identification of Non-Hypertension Patients",
    cex.main = 3,
    xlab = "False Positive (1 - Specificity)",
    ylab = "Sensitivity",
    cex.lab = 2,
    cex.axis = 2,
    col = "blue",
    lwd = 3
)

# Plot the empirical ROC curve (false positive vs sensitivity)
lines(
    false_positive,
    sensitivity,
    type = "s",
    lwd = 3,
    col = "red"
)

# Add a blue dot for the binomial optimal threshold
points(
    cdf_x_binom[min_index_binom],
    cdf_y_binom[min_index_binom],
    col = "blue",
    pch = 19,
    cex = 2.5
)

# Add a red dot for the empirical optimal threshold
points(
    false_positive[min_index_emp],
    sensitivity[min_index_emp],
    col = "red",
    pch = 19,
    cex = 2.5
)

# Add a dashed line for the diagonal
abline(
    a = 0,
    b = 1,
    lty = 2,
    lwd = 3
)

# Define threshold label positions
threshold_labels_pos <- c(0.01, .2, .4, .6, .8, 0.99)

# Define threshold labels
threshold_labels <- round(
    qnorm(threshold_labels_pos, mean = mu_x_hat, sd = sigma_x_hat),
    0
)

# Add threshold labels
axis(
    side = 3,
    at = threshold_labels_pos,
    labels = threshold_labels,
    cex.axis = 2
)

# Add side 3 label
mtext(
    "Threshold (Blood Pressure)",
    side = 3,
    line = 3,
    cex = 2
)

# Add a legend
legend(
    "bottomright",
    legend = c(
        "Empirical ROC Curve",
        "Binomial ROC Curve",
        paste("Empirical Optimal Threshold: ",
            round(optimal_threshold_emp, 0), " Blood Pressure",
            sep = ""
        ),
        paste("Binomial Optimal Threshold: ",
            round(optimal_threshold_binom, 0), " Blood Pressure",
            sep = ""
        )
    ),
    col = c("blue", "red", "red", "blue"),
    pch = c(NA, NA, 19, 19),
    lwd = c(3, 3, 0, 0), cex = 1.5
)

# Close the png device
dev.off()
