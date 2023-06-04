### Load Data

# Define returns dataframe
returns <- read.csv("./exams/final/data/90returns.csv", header = TRUE)

# Define full names dataframe
full_names <- read.csv("./exams/final/data/mostactive.csv", header = FALSE)

# label first column as "symbol", second column as "full_name"
colnames(full_names) <- c("symbol", "full_name")

### Question 1

# Transpose the data to compare companies
returns <- t(returns)

# Define a covariance matrix of the features
W <- cov(returns)

# Get the eigenvalues and eigenvectors of the covariance matrix
eigen <- eigen(W, symmetric = TRUE)

# Get the eigenvector with the largest eigenvalue
p <- eigen$vectors[, 1]

# Center the data
Z <- scale(returns, center = TRUE, scale = FALSE)

# Project the data onto the line spanned by the eigenvector
proj <- Z %*% p

# Get the maximum eigenvalue
lambda <- eigen$values[1]

# Compute total variance as the sum of the eigenvalues
total_variance <- sum(eigen$values)

# Compute the variance explained by the first PCA component
variance_explained <- lambda / total_variance

## Plotting

# Open a png device
png("./exams/final/plots/q1.png", width = 2400, height = 1200)

# Set the margins
par(mar = c(10, 10, 10, 10))

main_text <- paste("Density of Company Returns Projected onto First Principal Component",
    "\nVariance Explained by First Principal Component: ",
    round(variance_explained * 100, 2), "%",
    sep = ""
)

# Plot the density of the projected data
plot(
    density(proj[, 1]),
    type = "l", col = "blue",
    lwd = 3, xlab = "", ylab = "",
    main = main_text, cex.main = 3.5,
    yaxt = "n", xaxt = "n"
)

# Add a rug plot
rug(proj[, 1], col = "blue", lwd = 2, ticksize = 0.05)

# Add x axis label for projected returns
returns_labels <- seq(-1, .5, length.out = 7)
axis(1,
    at = returns_labels,
    labels = round(returns_labels, 2), cex.axis = 2,
    lwd = 0
)
mtext("Projected Returns", side = 1, line = 5, cex = 3)

# Get the row labels of proj
row_labels <- rownames(proj)

# Add label for company symbols
text(
    proj[, 1], .15,
    labels = row_labels, cex = 2,
    pos = 1, adj = 0, srt = 90
)

# Add y axis label for density
max_density <- max(density(proj[, 1])$y)
density_labels <- seq(0, max_density, length.out = 5)
axis(2,
    at = density_labels, labels = round(density_labels, 2),
    las = 2, cex.axis = 2, lwd = 0
)
axis(2,
    at = max_density / 2, labels = c("Density"), cex.axis = 3, padj = -3
)

# Add a legend
legend(
    "topright",
    legend = c("Density"),
    col = c("blue"), lwd = 3,
    cex = 2.5
)

# Close the png device
dev.off()

### Question 2

# Get mean of each company's returns
mean_returns <- colMeans(t(returns))

# Make a dataframe of the projected returns and mean returns
comparison <- data.frame(proj, mean_returns)

# Define the column names
colnames(comparison) <- c("projected_return", "mean_return")

# Rank comparison by mean returns
comparison <- comparison[order(comparison[, 2]), ]

# Get the row names of comparison
comparison_rows <- rownames(comparison)

# Add a full_name column to comparison
comparison$full_name <- full_names[match(comparison_rows, full_names$symbol), 2]

# Print comparison dataframe
print(comparison, width = 100)

# Print the number of companies with positive projected returns
print(paste(
    "Number of Companies with Positive Projected Returns:",
    sum(comparison[, 1] > 0)
))

# Print the number of companies with positive mean returns
print(paste(
    "Number of Companies with Positive Mean Returns:",
    sum(comparison[, 2] > 0)
))

# Regress projected returns onto mean returns
regression <- lm(comparison[, 1] ~ comparison[, 2])

# Get the correlation coefficient
correlation <- cor(comparison[, 1], comparison[, 2])

## Plotting

# Open a png device
png("./exams/final/plots/q2.png", width = 1600, height = 1600)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Plot the projected returns against the mean returns
plot(
    comparison[, 2], comparison[, 1],
    col = "blue", pch = 16, cex = 1.5,
    xlab = "", ylab = "",
    main = "Projected Returns onto Mean Returns", cex.main = 3.5,
    xaxt = "n", yaxt = "n"
)

# Add a regression line
abline(regression, col = "red", lwd = 3)

# Add x axis labeling
x_labels <- seq(min(mean_returns), max(mean_returns), length.out = 5)
center <- mean(x_labels)
axis(1,
    at = x_labels,
    labels = round(x_labels, 4), cex.axis = 2,
    lwd = 0
)
mtext("Mean Returns", side = 1, line = 5, cex = 3)

# Add y axis labeling
y_labels <- seq(min(proj[, 1]), max(proj[, 1]), length.out = 5)
center <- mean(y_labels)
axis(2,
    at = y_labels,
    labels = round(y_labels, 2), cex.axis = 2,
    lwd = 0
)
mtext("Projected Returns", side = 2, line = 5, cex = 3)


# Label each point with the company symbol
text(
    comparison[, 2], comparison[, 1],
    labels = rownames(comparison), cex = 2,
    pos = 4, adj = 0
)

# Add lines for y and x = 0
abline(h = 0, col = "black", lwd = 2)
abline(v = 0, col = "black", lwd = 2)

# Add a legend
legend(
    "bottomright",
    legend = c(paste("Correlation: ", round(correlation, 2)), "Returns = 0"),
    col = c("red", "black"), lwd = 3,
    cex = 2.5
)

# Close the png device
dev.off()

### Question 3

# Get the first two principal components
p <- eigen$vectors[, 1:2]

# Project the data onto the first two principal components
proj <- Z %*% p

# Add a third column to proj for mean returns
proj <- cbind(proj, mean_returns)

# Get the two eigenvalues
lambda <- eigen$values[1:2]

# Compute the variance explained by the first two PCA components
variance_explained_1 <- lambda[1] / total_variance
variance_explained_2 <- lambda[2] / total_variance

# Compute the total variance explained by the first two PCA components
total_variance_explained <- variance_explained_1 + variance_explained_2

## Plotting

# Open a png device
png("./exams/final/plots/q3.png", width = 1600, height = 1600)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Set the x and y labels
xlabel <- paste(
    "1st PCA Component Explains ",
    round(variance_explained_1 * 100, 2), "% of the Variance",
    sep = ""
)
ylabel <- paste(
    "2nd PCA Component Explains ",
    round(variance_explained_2 * 100, 2), "% of the Variance",
    sep = ""
)

# Set the main text
main_text <- paste(
    "PCA Projection of Company Returns Onto Plane
    Total Variance Explained: ",
    round(total_variance_explained * 100, 2), "%",
    sep = ""
)

# Plot the projection (mean_returns > 0 -> red, mean_returns < 0 -> blue)
plot(
    proj[, 1], proj[, 2],
    col = ifelse(proj[, 3] > 0, "red", "blue"), pch = 16, cex = 1.5,
    xlab = "", ylab = "",
    main = main_text, cex.main = 3.5,
    xaxt = "n", yaxt = "n"
)

# Add a rug for both axes
rug(proj[, 1], side = 1, col = "black", lwd = 2)
rug(proj[, 2], side = 2, col = "black", lwd = 2)

# Add x and y axis labels
mtext(xlabel, side = 1, line = 5, cex = 3)
mtext(ylabel, side = 2, line = 5, cex = 3)

# Add tick marks for x and y axes
x_labels <- seq(min(proj[, 1]), max(proj[, 1]), length.out = 5)
center <- mean(x_labels)
axis(1,
    at = x_labels,
    labels = round(x_labels, 2), cex.axis = 2,
    lwd = 0
)
y_labels <- seq(min(proj[, 2]), max(proj[, 2]), length.out = 5)
center <- mean(y_labels)
axis(2,
    at = y_labels,
    labels = round(y_labels, 2), cex.axis = 2,
    lwd = 0
)

# Add company symbols to the plot
text(
    proj[, 1], proj[, 2],
    labels = rownames(proj), cex = 2,
    pos = 4, adj = 0
)

# Add a lengend
legend(
    "topright",
    legend = c("Mean Returns > 0", "Mean Returns < 0"),
    col = c("red", "blue"), lwd = c(0, 0),
    pch = c(16, 16), cex = 2.5
)

# Close the png device
dev.off()

### Question 4

# Define distance between cluster types
# dist_types <- c("ward.D", "ward.D2", "single", "complete", "average")
dist_type <- "ward.D2"

# Open a png device
png("./exams/final/plots/q4.png", width = 3600, height = 2400)

# Set the margins and rows/cols
par(mar = c(5, 10, 10, 10))

# Perform hierarchical clustering
hc <- hclust(dist(Z), method = dist_type)

# Add results to plot
plot(
    hc,
    main = dist_type, xlab = "",
    sub = "", cex.main = 5, cex.lab = 3.5, cex.axis = 3,
    cex = 2, lwd = 3
)

# Close the png device
dev.off()

### Question 5

# Define the maximum number of clusters to consider
Kmax <- 10

# Pre-allocate vector for total within-cluster sum of squares (TWSS)
TWSS <- rep(NA, Kmax)

# Calculate TWSS for different number of clusters (from 1 to Kmax)
for (i in 1:Kmax) {
    TWSS[i] <- kmeans(Z, centers = i, nstart = 10)$tot.withinss
}

# Log-transform the TWSS
LTWSS <- log(TWSS)

## Implement the broken-line algorithm

# Initialize minimum two residual sum of squares
TwoRSS_MIN <- Inf

for (ik in 2:(Kmax - 2)) {
    x1 <- 1:ik
    y1 <- LTWSS[x1]
    x2 <- ik:Kmax
    y2 <- LTWSS[x2]

    # Calculate two residual sum of squares
    TwoRSS <- sum(lm(y1 ~ x1)$residuals^2) +
        sum(lm(y2 ~ x2)$residuals^2)

    if (TwoRSS < TwoRSS_MIN) {
        TwoRSS_MIN <- TwoRSS
        # Save the number of clusters corresponding to the minimum TwoRSS
        optimal_K <- ik
    }
}

# Print the optimal number of clusters
print(paste("Optimal number of clusters =", optimal_K))

## Plotting

# Open a PNG device
png("./exams/final/plots/q5_brokenline.png", width = 1600, height = 1200)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Plot the LTWSS for visual inspection
plot(
    1:Kmax, LTWSS,
    type = "o", lwd = 2,
    main = "Broken-line Algorithm",
    xlab = "", ylab = "",
    cex.lab = 2.5, cex.axis = 1.75, cex.main = 3, cex.sub = 2,
    pch = 19, cex = 1.5, xaxt = "n"
)

# Label axes
mtext("Number of clusters (K)", side = 1, line = 5, cex = 2.5)
mtext("LOG Total Within Sum of Squares", side = 2, line = 5, cex = 2.5)

# Add x-axis ticks
axis(1, at = 1:Kmax, labels = 1:Kmax, cex.axis = 1.5)

# Draw two-segment lines on the plot
x1 <- 1:optimal_K
y1 <- LTWSS[x1]
x2 <- optimal_K:Kmax
y2 <- LTWSS[x2]
y1 <- lm(y1 ~ x1)$fitted.values
lines(x1, y1, lwd = 2)
y2 <- lm(y2 ~ x2)$fitted.values
lines(x2, y2, lwd = 2)
segments(optimal_K, min(LTWSS), optimal_K, LTWSS[optimal_K], lwd = 3, col = 2)

# Add text displaying the optimal number of clusters
text(
    optimal_K + 1, LTWSS[optimal_K] + .25,
    paste("Optimal Number of Clusters =", optimal_K),
    cex = 2.5
)

# Close the PNG device
dev.off()

## Finding p value of 1 cluster vs 2 clusters

# Perform k-means clustering with 2 clusters
kmeans_2 <- kmeans(Z, centers = 2, nstart = 10)

# Compute r_star test statistic
r_star <- kmeans_2$totss / kmeans_2$tot.withinss

# Define the number of simulations
n_sim <- 1000

# Initialize an empty vector to store the r test statistic
r_sim <- rep(NA, n_sim)

# For each simulation
for (i in 1:n_sim) {
    # Simulate data from a standard normal distribution
    Z_sim <- matrix(rnorm(nrow(Z) * ncol(Z), mean = 0, sd = 1),
        nrow = nrow(Z), ncol = ncol(Z)
    )

    # Perform k-means clustering with 2 clusters
    kmeans_2_sim <- kmeans(Z_sim, centers = 2, nstart = 10)

    # Compute r test statistic
    r_sim[i] <- kmeans_2_sim$totss / kmeans_2_sim$tot.withinss
}

# Compute the proportion of r test statistics greater than r threshold
r_cdf <- ecdf(r_sim)

# Compute the p value
p_value <- 1 - r_cdf(r_star)

# Print the r star test statistic
print(paste("r* =", r_star))

# Print the range of simulated r test statistics
print(paste("Simulated r value ranges from", min(r_sim), "to", max(r_sim)))

# Print the p value
print(paste("p value =", p_value))

### Question 6

# Get cluster assignments
kmeans <- kmeans(Z, centers = 2, nstart = 10)

# Get the companies in each cluster
cluster_1 <- which(kmeans$cluster == 1)
cluster_2 <- which(kmeans$cluster == 2)

# Get the projections of each cluster
cluser_1_proj <- proj[cluster_1, ]
cluser_2_proj <- proj[cluster_2, ]

# Get the mean projections of each cluster
cluster_1_mean <- colMeans(cluser_1_proj)
cluster_2_mean <- colMeans(cluser_2_proj)

# Combine the mean projections
cluster_means <- rbind(cluster_1_mean, cluster_2_mean)

# Get the cluster index with the highest mean return
large_cluster <- which.max(cluster_means)

## Plotting

# Open a png device
png("./exams/final/plots/q6.png", width = 1600, height = 1600)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Set the x and y labels
xlabel <- paste(
    "1st PCA Component Explains ",
    round(variance_explained_1 * 100, 2), "% of the Variance",
    sep = ""
)
ylabel <- paste(
    "2nd PCA Component Explains ",
    round(variance_explained_2 * 100, 2), "% of the Variance",
    sep = ""
)

# Set the main text
main_text <- paste(
    "PCA Projection of Company Returns Onto Plane
    Total Variance Explained: ",
    round(total_variance_explained * 100, 2), "%",
    sep = ""
)

# Plot the projection (mean_returns > 0 -> red, mean_returns < 0 -> blue)
plot(
    proj[, 1], proj[, 2],
    col = ifelse(proj[, 3] > 0, "red", "blue"), pch = 16, cex = 1.5,
    xlab = "", ylab = "",
    main = main_text, cex.main = 3.5,
    xaxt = "n", yaxt = "n"
)

# Plot lines from mean of each cluster to all points in that cluster
for (i in 1:2) {
    if (i == large_cluster) {
        col <- "green"
    } else {
        col <- "purple"
    }
    curr_cluster <- which(kmeans$cluster == i)

    # Plot lines from mean of each cluster to all points in that cluster
    for (j in curr_cluster) {
        lines(
            c(cluster_means[i, 1], proj[j, 1]),
            c(cluster_means[i, 2], proj[j, 2]),
            col = col, lwd = 2
        )
    }
}

# Add a rug for both axes
rug(proj[, 1], side = 1, col = "black", lwd = 2)
rug(proj[, 2], side = 2, col = "black", lwd = 2)

# Add x and y axis labels
mtext(xlabel, side = 1, line = 5, cex = 3)
mtext(ylabel, side = 2, line = 5, cex = 3)

# Add tick marks for x and y axes
x_labels <- seq(min(proj[, 1]), max(proj[, 1]), length.out = 5)
center <- mean(x_labels)
axis(1,
    at = x_labels,
    labels = round(x_labels, 2), cex.axis = 2,
    lwd = 0
)
y_labels <- seq(min(proj[, 2]), max(proj[, 2]), length.out = 5)
center <- mean(y_labels)
axis(2,
    at = y_labels,
    labels = round(y_labels, 2), cex.axis = 2,
    lwd = 0
)

# Add company symbols to the plot
text(
    proj[, 1], proj[, 2],
    labels = rownames(proj), cex = 2,
    pos = 4, adj = 0
)

# Add a lengend
legend(
    "topright",
    legend = c(
        "Mean Returns > 0", "Mean Returns < 0",
        "Cluster With Larger Mean Returns", "Cluster With Smaller Mean Returns"
    ),
    col = c("red", "blue", "green", "purple"), lwd = c(0, 0, 3, 3),
    pch = c(16, 16, NA, NA), cex = 2.5
)

# Close the png device
dev.off()
