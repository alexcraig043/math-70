# library(rgl)

# Define the vectors
x1 <- c(1, 0, 0)
x2 <- c(0, 1, 0)
y <- c(1, 1, 1)

# Find the projection of y onto the plane spanned by x1 and x2
y_hat <- y - c(0, 0, y[3])

# Calculate the residual vector
residual <- y - y_hat

# Set up the 3D plotting window
open3d()
rgl.bg(color = "white")
rgl.viewpoint(theta = 60, phi = 30)

# Plot the plane
plane3d(c(0, 0, 0), normal = c(0, 0, 1), alpha = 0.5, color = "gray")

# Plot the vectors
vectors3d(rbind(c(0, 0, 0), c(0, 0, 0), c(0, 0, 0)), rbind(x1, x2, y), radius = 0.05)
vectors3d(y, y_hat, radius = 0.05, col = "blue")

# Plot the residual vector
vectors3d(y_hat, residual, col = "red", radius = 0.05)

# Label vectors
text3d(1.1 * x1, text = expression(x[1]))
text3d(1.1 * x2, text = expression(x[2]))
text3d(1.1 * y, text = expression(y))
text3d(y * 0.5 + y_hat * 0.5, text = expression(hat(y)))

# Label the angles
text3d(0.5 * y, text = expression(theta), adj = c(-0.5, -1))
text3d(0.5 * y_hat + 0.5 * residual, text = "90°", adj = c(-1, -1))

# Set axis labels
rgl.axis(col = "black", labels = TRUE)
rgl.postscript("3d_figure.png", fmt = "png")
rgl.close()
