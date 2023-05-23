# Access the iris dataset
data <- iris

### Part A

# Define features
X <- data[, 1:4]

# Define labels
Y <- data[, 5]

# Define a covariance matrix of the features
W <- cov(X)

# Get the eigenvalues and eigenvectors of the covariance matrix
eigen <- eigen(W, symmetric = TRUE)

# Get the two eigenvectors with the largest eigenvalues
p <- eigen$vectors[, 1:2]

# Split the eigenvectors into two vectors
p1 <- p[, 1]
p2 <- p[, 2]

# Center the data
Z <- scale(X, center = TRUE, scale = FALSE)

# Project the data onto the plane spanned by the two eigenvectors
proj <- Z %*% p

### Part B

# Get the two maximum eigenvalues
lambda <- eigen$values[1:2]

# Compute total variance as the sum of the eigenvalues
total_variance <- sum(eigen$values)

# Compute the variance explained by the first PCA component
variance_explained_1 <- lambda[1] / total_variance

# Compute the variance explained by the second PCA component
variance_explained_2 <- lambda[2] / total_variance

# Compute total variance explained by the first two PCA components
total_variance_explained <- variance_explained_1 + variance_explained_2

### Part C

## Plotting

# Open a png device
png("./homeworks/hw8/plots/q2.png", width = 1600, height = 1200)

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
    "PCA Projection of Iris Dataset Onto Plane \n Total Variance Explained: ",
    round(total_variance_explained * 100, 2), "%",
    sep = ""
)

# Plot the projection
plot(
    proj,
    xlab = "", ylab = "", main = main_text,
    cex.main = 3, cex.axis = 2
)

# Add the x and y labels
axis(1, at = 0, labels = xlabel, cex.axis = 2, line = 4)
axis(2, at = 0, labels = ylabel, cex.axis = 2, line = 4)

# Plot the iris flowers with different colors
points(proj[Y == "setosa", ], col = "red", pch = 16, cex = 2)
points(proj[Y == "versicolor", ], col = "green", pch = 16, cex = 2)
points(proj[Y == "virginica", ], col = "blue", pch = 16, cex = 2)

# Add a legend
legend(
    "bottomright",
    legend = c("setosa", "versicolor", "virginica"),
    col = c("red", "green", "blue"),
    pch = 16,
    cex = 2
)

# Close the png device
dev.off()
