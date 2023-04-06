# Function: simSlopeIntercept
# Description: Simulates the slope and intercept of a
#       linear regression model
# Inputs:
#   b_true: the true slope of the linear regression model
#   a_true: the true intercept of the linear regression model
#   sigma: the standard deviation of the error term
#   n: the number of observations
#   nSim: the number of simulations to run
# Outputs:
#   sim_mean_b: the simulated mean of the slope estimate
#   sim_mean_a: the simulated mean of the intercept estimate
#   scatterplot.pdf: a scatterplot of the simulated data
#       with the regression line
#   bias_slope.pdf: a scatterplot of the bias of the
#       slope estimate
#   bias_intercept.pdf: a scatterplot of the bias of the
#       intercept estimate

simSlopeIntercept <- function(
    b_true = 0.5,
    a_true = 1,
    sigma = 1,
    n = 100,
    nSim = 1000) {
    x <- 1:n
    x_magnitude_sq <- sum(x^2)
    x_bar <- mean(x)

    b_hat <- rep(NA, nSim)
    a_hat <- rep(NA, nSim)

    x_scatterplot_vals <- rep(x, nSim) # x values for scatterplot
    y_scatterplot_vals <- rep(NA, nSim * n) # y values for scatterplot

    x_bias_vals <- 1:nSim # x values for bias plots
    b_hat_bias <- rep(NA, nSim) # y values for bias plots
    a_hat_bias <- rep(NA, nSim) # y values for bias plots

    for (i in 1:nSim) {
        eps <- rnorm(n, sd = sigma) # error term
        y <- a_true + (b_true * x) + eps # y values with error term
        y_scatterplot_vals[((i * n) - n + 1):(i * n)] <-
            y # add y values to scatterplot
        y_bar <- mean(y) # mean of y values
        scalar_prod_xy <- sum(x * y) # scalar product of x and y

        b_hat[i] <- (scalar_prod_xy - (n * y_bar * x_bar)) /
            (x_magnitude_sq - (n * x_bar^2)) # unbiased estimator of b
        a_hat[i] <- y_bar - (b_hat[i] * x_bar) # unbiased estimator of a

        b_hat_bias[i] <- mean(b_hat[1:i]) - b_true # bias of b_hat
        # estimator up to i
        a_hat_bias[i] <- mean(a_hat[1:i]) - a_true # bias of a_hat
        # estimator up to i
    }

    sim_mean_b <- mean(b_hat) # simulated mean of b_hat
    sim_mean_a <- mean(a_hat) # simulated mean of a_hat

    # # Plot the scatterplot
    # pdf("./homeworks/hw1/plots/scatterplot.pdf", width = 8, height = 6)
    # plot(x_scatterplot_vals, y_scatterplot_vals,
    #     main = "Scatter plot of x and y", xlab = "x", ylab = "y",
    #     pch = 19, col = "#0000ff3c"
    # )
    # abline(sim_mean_a, sim_mean_b, col = "red", lwd = 2)
    # dev.off()

    # # Plot a scatterplot of the bias of the slope and intercept estimates.
    # # Slope estimate is blue, intercept estimate is red.
    # pdf("./homeworks/hw1/plots/bias_slope.pdf", width = 8, height = 6)
    # plot(x_bias_vals, b_hat_bias,
    #     main = "Bias of slope estimator",
    #     xlab = "Simulation number", ylab = "Bias", pch = 19, col = "blue"
    # )
    # abline(h = 0, col = "black", lwd = 2)
    # dev.off()

    # pdf("./homeworks/hw1/plots/bias_intercept.pdf", width = 8, height = 6)
    # plot(x_bias_vals, a_hat_bias,
    #     main = "Bias of intercept estimator",
    #     xlab = "Simulation number", ylab = "Bias", pch = 19, col = "red"
    # )
    # abline(h = 0, col = "black", lwd = 2)
    # dev.off()

    # Print the results
    cat(
        "\nSimulated mean of b_hat (slope estimate):", sim_mean_b,
        "\nTrue value of b (slope):", b_true,
        "\n\nSimulated mean of a_hat (intercept estimate):", sim_mean_a,
        "\nTrue value of a (intercept):", a_true
    )
}

simSlopeIntercept(nSim = 2500)
