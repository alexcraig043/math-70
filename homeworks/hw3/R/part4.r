# Load the data with column for height, foot length, and nose length
data <- read.csv("./homeworks/hw3/data/HeightFootNose.csv", header = T)
# Instantiate the regression model
regression <- lm(Height ~ Foot + Nose, data = data)
# Print the summary of the regression model
print(summary(regression))

plot_scatter <- function(data, regression) {
    # Plot the regression model
    pdf("./homeworks/hw3/plots/height_foot_nose_scatter.pdf",
        width = 18, height = 6
    )

    # Set up a two-panel plot
    par(mfrow = c(1, 3))

    # Plot height on foot & regression line
    height_foot_regression <- lm(Height ~ Foot, data = data)
    height_foot_regression_R <- round(
        cor(data$Foot, data$Height),
        digits = 2
    )
    plot(
        data$Foot, data$Height,
        xlab = "Foot Length, inches",
        ylab = "Height, inches",
        main = paste("Height on Foot, R = ", height_foot_regression_R)
    )
    abline(height_foot_regression, col = "blue", lwd = 2)
    abline(regression, col = "red", lwd = 2)
    legend(
        "bottomright",
        legend = c(
            "Regression for Height on Foot",
            "Regression for Height on Foot & Nose"
        ),
        col = c("blue", "red"), lty = 1, cex = 0.8
    )

    # Plot height on nose & regression line
    height_nose_regression <- lm(Height ~ Nose, data = data)
    height_nose_regression_R <- round(
        cor(data$Nose, data$Height),
        digits = 2
    )
    plot(
        data$Nose, data$Height,
        xlab = "Nose Length, inches",
        ylab = "Height, inches",
        main = paste("Height on Nose, R = ", height_nose_regression_R)
    )
    abline(height_nose_regression, col = "blue", lwd = 2)
    abline(regression, col = "red", lwd = 2)
    legend(
        "bottomright",
        legend = c(
            "Regression for Height on Nose",
            "Regression for Height on Foot & Nose"
        ),
        col = c("blue", "red"), lty = 1, cex = 0.8
    )

    # Plot nose on foot & regression line
    foot_nose_regression <- lm(Nose ~ Foot, data = data)
    foot_nose_regression_R <- round(
        cor(data$Foot, data$Nose),
        digits = 2
    )
    plot(
        data$Foot, data$Nose,
        xlab = "Foot Length, inches",
        ylab = "Nose Length, inches",
        main = paste("Nose on Foot, R = ", foot_nose_regression_R)
    )
    abline(foot_nose_regression, col = "blue", lwd = 2)
    legend(
        "bottomright",
        legend = "Regression for Nose on Foot",
        col = "blue", lty = 1, cex = 0.8
    )

    # # Plot foot on nose & regression line
    # nose_foot_regression <- lm(Foot ~ Nose, data = data)
    # nose_foot_regression_R <- round(
    #     cor(data$Foot, data$Nose),
    #     digits = 2
    # )
    # plot(
    #     data$Nose, data$Foot,
    #     xlab = "Nose Length, inches",
    #     ylab = "Foot Length, inches",
    #     main = paste("Foot on Nose, R = ", nose_foot_regression_R)
    # )
    # abline(nose_foot_regression, col = "blue", lwd = 2)
    # abline(regression, col = "red", lwd = 2)
    # legend(
    #     "bottomright",
    #     legend = c(
    #         "Regression for Foot on Nose",
    #         "Regression for Height on Foot & Nose"
    #     ),
    #     col = c("blue", "red"), lty = 1, cex = 0.8
    # )

    # Close the PDF device
    dev.off()
}

plot_scatter(data, regression)

plot_residuals <- function(data, regression) {
    # Plot the residuals
    pdf("./homeworks/hw3/plots/height_foot_nose_residuals.pdf",
        width = 12, height = 6
    )

    # Plot the residuals for height on foot no the residuals for nose on foot
    height_foot_regression <- lm(Height ~ Foot, data = data)
    nose_foot_regression <- lm(Nose ~ Foot, data = data)
    residuals_regression <- lm(
        residuals(height_foot_regression) ~ residuals(nose_foot_regression),
    )
    plot(
        residuals(nose_foot_regression), residuals(height_foot_regression),
        xlab = "Residuals from Nose on Foot",
        ylab = "Residuals from Height on Foot",
        main = "Residuals for Height on Foot vs. Nose on Foot"
    )
    abline(residuals_regression, col = "red", lwd = 2)
    legend(
        "bottomright",
        legend = c(paste("Regression for Residuals, slope = ", round(
            residuals_regression$coefficients[2],
            digits = 4
        ))),
        col = c("red"), lty = 1, cex = 0.8
    )

    # Close the PDF device
    dev.off()
}

plot_residuals(data, regression)
