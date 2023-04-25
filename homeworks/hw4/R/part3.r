### Import Libraries ###
library(MASS)
library(gifski)

### Trivariate normal distribution parameters ###

# First 200 normally distributed random vectors (U)
u_num <- 100
u_mu_1 <- 2
u_mu_2 <- 2
u_mu_3 <- 4
u_cov_mat <- matrix(c(2, -1, -1, -1, 3, 1, -1, 1, 4), nrow = 3, ncol = 3)

# Second 300 normally distributed random vectors (V)
v_num <- 300
v_mu_1 <- 1
v_mu_2 <- -2
v_mu_3 <- 1
v_cov_mat <- matrix(c(4, 1, .1, 1, 1, -.1, .5, -.1, 2), nrow = 3, ncol = 3)

### Vector Generation ###

# QUESTION: Can I use mvnorm?
# Generate the first 200 normally distributed random vectors
U <- mvrnorm(u_num, c(u_mu_1, u_mu_2, u_mu_3), u_cov_mat)

# Generate the second 300 normally distributed random vectors
V <- mvrnorm(v_num, c(v_mu_1, v_mu_2, v_mu_3), v_cov_mat)

xlim <- c(min(U[, 1], V[, 1]), max(U[, 1], V[, 1]))
ylim <- c(min(U[, 2], V[, 2]), max(U[, 2], V[, 2]))
zlim <- c(min(U[, 3], V[, 3]), max(U[, 3], V[, 3]))

### Animation ###

for (theta in 1:360) {
    # File naming
    frame_label <- theta
    if (theta < 10) {
        frame_label <- paste("00", frame_label, sep = "")
    } else if (theta < 100) {
        frame_label <- paste("0", frame_label, sep = "")
    }
    png(
        paste("./homeworks/hw4/plots/part3/frames/",
            frame_label, ".png",
            sep = ""
        ),
        width = 1000, height = 1000,
        units = "px", res = 100
    )
    par(mfrow = c(1, 1), mar = c(3, 1, 1, 1))

    # Create an empty 3D plot
    plot_3d <- persp(
        x = xlim, y = ylim, z = matrix(0, nrow = 2, ncol = 2), zlim = zlim,
        xlab = "X", ylab = "Y", zlab = "Z", main = paste("Theta =", theta, "°"),
        theta = theta, phi = 20, ticktype = "detailed", col = "white"
    )

    # Add 3d points for group U
    U_3d <- trans3d(
        x = U[, 1], y = U[, 2], z = U[, 3],
        pmat = plot_3d
    )

    # Add 3d points for group V
    V_3d <- trans3d(
        x = V[, 1], y = V[, 2], z = V[, 3],
        pmat = plot_3d
    )

    # Plot the 3d points
    points(
        x = U_3d$x, y = U_3d$y, z = U_3d$z,
        pch = 16, col = "red", cex = 0.75
    )
    points(
        x = V_3d$x, y = V_3d$y, z = V_3d$z,
        pch = 16, col = "blue", cex = 0.75
    )

    # Add 2d points for group U
    U_2d <- trans3d(
        x = U[, 1], y = U[, 2], z = matrix(0, nrow = u_num, ncol = 1),
        pmat = plot_3d
    )

    # Add 2d points for group V
    V_2d <- trans3d(
        x = V[, 1], y = V[, 2], z = matrix(0, nrow = v_num, ncol = 1),
        pmat = plot_3d
    )

    # Plot the 2d points
    points(
        x = U_2d$x, y = U_2d$y, z = U_2d$z,
        pch = 4, col = "red", cex = 0.5
    )
    points(
        x = V_2d$x, y = V_2d$y, z = V_2d$z,
        pch = 4, col = "blue", cex = 0.5
    )

    # Plot the segments
    segments(
        x0 = U_3d$x, y0 = U_3d$y, z0 = U_3d$z,
        x1 = U_2d$x, y1 = U_2d$y, z1 = U_2d$z,
        col = "red"
    )
    segments(
        x0 = V_3d$x, y0 = V_3d$y, z0 = V_3d$z,
        x1 = V_2d$x, y1 = V_2d$y, z1 = V_2d$z,
        col = "blue"
    )

    # Add the legend
    legend(
        "topright",
        legend = c("U", "V"),
        col = c("red", "blue"),
        pch = c(16, 16),
        cex = 1.5, text.font = 12
    )

    # Close the file after plotting
    dev.off()
}

### Create the animation ###

frames <- list.files("./homeworks/hw4/plots/part3/frames/",
    pattern = ".png",
    full.names = TRUE
)

gifski(
    frames,
    gif_file = "./homeworks/hw4/plots/part3.gif",
    width = 1000, height = 1000,
    delay = 0.01
)
