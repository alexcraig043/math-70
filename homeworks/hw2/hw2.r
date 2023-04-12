# generate z1 and z2
n <- 1000
z1 <- rnorm(n)
z2 <- z1 + rnorm(n)
z2 <- z2 / sd(z2)

### REGRESSIONS ###

# Manual computation of the regression lines
scalar_prod_z1_z2 <- sum(z1 * z2)
z1_sq_norm <- sum(z1^2)
z2_sq_norm <- sum(z2^2)

# compute beta (slope) for z1 on z2 and z2 on z1
beta_z1_z2 <- scalar_prod_z1_z2 / z2_sq_norm
beta_z2_z1 <- scalar_prod_z1_z2 / z1_sq_norm

### MAJOR AXIS ###

# compute the n x n covariance matrix of each entry of z1 and z2
# define a matrix with z1 and z2 as columns
z1_z2 <- cbind(z1, z2)

# compute the covariance matrix
omega <- cov(z1_z2)

cat("\n\n")
omega

# compute the eigenvalues and eigenvectors of the covariance matrix
eigenvalues <- eigen(omega)$values
eigenvectors <- eigen(omega)$vectors

cat("\n\n")
eigenvalues
cat("\n")
eigenvectors

eigen(cov(cbind(z2, z1)))$vectors

# compute the major axis vector
largest_eigenvector_index <- which(eigenvalues == max(eigenvalues))
major_axis_vector <- eigenvectors[, largest_eigenvector_index]

cat("\n\nMajor Axis Vector: ", major_axis_vector)

# compute the slope of the major axis
major_axis_slope_z1_z2 <- major_axis_vector[2] / major_axis_vector[1]
major_axis_slope_z2_z1 <- major_axis_vector[1] / major_axis_vector[2]

### PRINT RESULTS ###

cat("\n\nRegression Results:")
cat("\n--------------------")

# z1 on z2
cat("\nz1 on z2: y = ", beta_z1_z2, "* x")
# major axis
cat("\n\nmajor axis: y = ", major_axis_slope_z1_z2, "* x")

# z2 on z1
cat("\n\nz2 on z1: y = ", beta_z2_z1, "* x")
# major axis
cat("\n\nmajor axis: y = ", major_axis_slope_z2_z1, "* x")

cat("\n--------------------\n\n")

### PLOT ###

# Set up a three-panel plot
par(mfrow = c(1, 3))

# graph a scatterplot of z1 and z2
pdf("./homeworks/hw2/plots/scatter.pdf", width = 8, height = 8)

# Panel 1: Plot z1 on z2 with the regression line
plot(z2, z1,
    xlab = "z2", ylab = "z1", main = "z1 on z2",
    xlim = c(-3, 3), ylim = c(-3, 3)
)
abline(0, beta_z1_z2, col = "red", lwd = 2)
# Plot the major axis
abline(0, major_axis_slope_z1_z2, col = "green", lwd = 2)
# Legend
legend("topleft",
    legend = c("z1 on z2", "major axis"),
    col = c("red", "green"), lty = 1, cex = 0.8
)

# Panel 2: Plot z2 on z1 with the regression line
plot(z1, z2,
    xlab = "z1", ylab = "z2", main = "z2 on z1",
    xlim = c(-3, 3), ylim = c(-3, 3)
)
abline(0, beta_z2_z1, col = "blue", lwd = 2)
# Plot the major axis
abline(0, major_axis_slope_z2_z1, col = "purple", lwd = 2)
# Legend
legend("topleft",
    legend = c("z2 on z1", "major axis"),
    col = c("blue", "purple"), lty = 1, cex = 0.8
)

# Panel 3: Plot z1 on z2 with the major axis
plot(z2, z1,
    xlab = "z2", ylab = "z1", main = "z1 on z2",
    xlim = c(-3, 3), ylim = c(-3, 3)
)
abline(0, major_axis_slope_z1_z2, col = "green", lwd = 2)
abline(0, 1 / major_axis_slope_z1_z2, col = "purple", lwd = 2)
# Plot the regression lines
abline(0, beta_z1_z2, col = "red", lwd = 2)
abline(0, 1 / beta_z2_z1, col = "blue", lwd = 2)
abline(0, 1, col = "black", lwd = 1)
# Legend
legend("topleft",
    legend = c(
        "z1 on z2", "z2 on z1", "major axis z1 on z2",
        "major axis z2 on z1", "y = x"
    ),
    col = c("red", "blue", "green", "purple", "black"), lty = 1, cex = 0.8
)

# Close the PDF device
dev.off()
