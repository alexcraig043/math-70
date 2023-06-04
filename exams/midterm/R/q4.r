### Reading Data ###

data <- read.csv("./exams/midterm/data/Most active stocks prices_Feb_01.2023.csv")

data <- data[, -1] # remove date column

# Convert daily prices to daily returns
data <- log(data[2:nrow(data), ] / data[1:(nrow(data) - 1), ])

### Part A ###

# Create model regressing TSLA on all other stocks
model <- lm(TSLA ~ ., data = data)

# Define alpha
alpha <- 0.001

# Extract companies with p-values less than alpha
significant_companies <- names(
    coef(summary(model))[, "Pr(>|t|)"]
)[coef(summary(model))[, "Pr(>|t|)"] < alpha]

# Create a new model with only significant companies
parsimonious_model <- lm(
    TSLA ~ .,
    data = data[, c("TSLA", significant_companies)]
)

# Print the summary of the parsimonious model
summary(parsimonious_model)

### Part D ###

# Create the grid for the regression plane
x <- seq(min(data$AAPL), max(data$AAPL), length.out = 25)
y <- seq(min(data$NIO), max(data$NIO), length.out = 25)
grid <- expand.grid(x, y)
colnames(grid) <- c("AAPL", "NIO")

# Calculate the z values for the regression plane
grid$TSLA <- predict(parsimonious_model, newdata = grid)

# Convert the grid to a matrix format for plotting
z <- matrix(grid$TSLA, nrow = 25, ncol = 25)

# Define the z limits
zlim <- c(min(data$TSLA), max(data$TSLA))

# Open a PNG device
png("./exams/midterm/plots/q4.png", width = 1800, height = 1800)

# Set the graphical parameters
par(mfrow = c(1, 1), mar = c(1, 1, 3, 1), cex.lab = 1.5, cex.main = 1.5)

# Create the 3D plot
plot_3d <- persp(x, y, z, xlab = "AAPL", ylab = "NIO", zlab = "TSLA", zlim = zlim, theta = 45, phi = 8, ticktype = "detailed", col = "lightblue", main = "TSLA Returns Predicted by AAPL and NIO Returns")

# Define the true points
points_true <- trans3d(
    x = data$AAPL, y = data$NIO, z = data$TSLA,
    pmat = plot_3d
)

# Define the predicted points
tsla_pred <- predict(parsimonious_model, newdata = data[, c("AAPL", "NIO")])
points_pred <- trans3d(
    x = data$AAPL, y = data$NIO, z = tsla_pred,
    pmat = plot_3d
)

# Plot the residual vectors
segments(
    x0 = points_pred$x, y0 = points_pred$y, z0 = points_pred$z,
    x1 = points_true$x, y1 = points_true$y, z1 = points_true$z,
    col = "red", lwd = 1
)

# Plot the predicted points
points(
    x = points_pred$x, y = points_pred$y, z = points_pred$z,
    pch = 4, col = "blue", cex = 1
)

# Plot the true points
points(
    x = points_true$x, y = points_true$y, z = points_true$z,
    pch = 16, col = "red", cex = 1
)

# Add a legend
legend(
    "topright",
    legend = c(
        "True TSLA Return", "Predicted TSLA Return",
        "Residual Vector", "Regression Plane"
    ),
    col = c("red", "blue", "red", "lightblue"),
    pch = c(16, 4, NA, 15),
    lwd = c(NA, NA, 1, NA),
    cex = 1.5
)


# Close the PNG device
dev.off()
