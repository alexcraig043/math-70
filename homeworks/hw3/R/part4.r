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

    # Plot foot vs height & regression line
    foot_height_regression <- lm(Height ~ Foot, data = data)
    foot_height_regression_R <- round(
        cor(data$Foot, data$Height),
        digits = 2
    )
    plot(
        data$Foot, data$Height,
        xlab = "Foot Length, inches",
        ylab = "Height, inches",
        main = paste("Height vs Foot Length, R = ", foot_height_regression_R)
    )
    abline(foot_height_regression, col = "blue", lwd = 2)
    abline(regression, col = "red", lwd = 2)
    legend(
        "bottomright",
        legend = c(
            "Regression for Height vs Foot",
            "Regression for Height vs Foot & Nose"
        ),
        col = c("blue", "red"), lty = 1, cex = 0.8
    )

    # Plot nose vs height & regression line
    nose_height_regression <- lm(Height ~ Nose, data = data)
    nose_height_regression_R <- round(
        cor(data$Nose, data$Height),
        digits = 2
    )
    plot(
        data$Nose, data$Height,
        xlab = "Nose Length, inches",
        ylab = "Height, inches",
        main = paste("Height vs Nose Length, R = ", nose_height_regression_R)
    )
    abline(nose_height_regression, col = "blue", lwd = 2)
    abline(regression, col = "red", lwd = 2)
    legend(
        "bottomright",
        legend = c(
            "Regression for Height vs Nose",
            "Regression for Height vs Foot & Nose"
        ),
        col = c("blue", "red"), lty = 1, cex = 0.8
    )

    # Plot foot vs nose & regression line
    foot_nose_regression <- lm(Nose ~ Foot, data = data)
    foot_nose_regression_R <- round(
        cor(data$Foot, data$Nose),
        digits = 2
    )
    plot(
        data$Foot, data$Nose,
        xlab = "Foot Length, inches",
        ylab = "Nose Length, inches",
        main = paste("Foot vs Nose Length, R = ", foot_nose_regression_R)
    )
    abline(foot_nose_regression, col = "blue", lwd = 2)
    legend(
        "bottomright",
        legend = "Regression for Foot vs Nose",
        col = "blue", lty = 1, cex = 0.8
    )

    # Close the PDF device
    dev.off()
}

plot_scatter(data, regression)

plot_residuals <- function(data, regression) {
    # Plot the residuals
    pdf("./homeworks/hw3/plots/height_foot_nose_residuals.pdf",
        width = 12, height = 6
    )

    # Set up a two-panel plot
    par(mfrow = c(1, 2))

    # Plot the residuals for foot vs height
    plot(
        data$Foot, residuals(regression),
        xlab = "Foot Length, inches",
        ylab = "Residuals", main = "Residuals vs Foot Length"
    )
    abline(h = 0, col = "red")
    legend(
        "bottomright",
        legend = c("Regression for Foot & Nose vs Height"),
        col = c("red"), lty = 1, cex = 0.8
    )

    # Plot the residuals for nose vs height
    plot(
        data$Nose, residuals(regression),
        xlab = "Nose Length, inches",
        ylab = "Residuals", main = "Residuals vs Nose Length"
    )
    abline(h = 0, col = "red")
    legend(
        "bottomright",
        legend = c("Regression for Foot & Nose vs Height"),
        col = c("red"), lty = 1, cex = 0.8
    )

    # Close the PDF device
    dev.off()
}

plot_residuals(data, regression)
