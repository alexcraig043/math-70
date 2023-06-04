### Reading Data ###

data <- read.csv("./exams/midterm/data/Most active stocks prices_Feb_01.2023.csv")

data <- data[, -1] # remove date column

# Define column names and number of columns
names <- colnames(data)
num_names <- length(names)

# Convert data to a matrix
data_matrix <- as.matrix(data)
num_rows <- nrow(data_matrix)

# Convert daily prices to daily returns
data_matrix <- log(data_matrix[2:num_rows, ] / data_matrix[1:(num_rows - 1), ])

# Define the correlation matrix
cor_matrix <- cor(data_matrix)

# Define an inverse correlation matrix
inv_cor_matrix <- solve(cor_matrix)

# Define an empty matrix to store partial correlations
partial_cor_matrix <- matrix(NA, nrow = num_names, ncol = num_names)

# Fill in the partial correlation matrix
for (i in 1:num_names) {
    for (j in 1:num_names) {
        partial_cor_matrix[i, j] <- -inv_cor_matrix[i, j] / sqrt(
            inv_cor_matrix[i, i] * inv_cor_matrix[j, j]
        )
    }
}

# Set the diagonal to NA
diag(partial_cor_matrix) <- NA

# Define breaks and colors
breaks <- seq(-0.1, 1, length.out = 12)
colors <- c(
    "dodgerblue", "skyblue", "darkolivegreen",
    "yellowgreen", "greenyellow", "yellow", "goldenrod",
    "darkorange", "coral", "indianred", "red"
)
color_string <- "dodgerblue: -0.1 - 0, skyblue: 0 - 0.1, darkolivegreen: 0.1 - 0.2, yellowgreen: 0.2 - 0.3, greenyellow: 0.3 - 0.4, yellow: 0.4 - 0.5, goldenrod: 0.5 - 0.6, darkorange: 0.6 - 0.7, coral: 0.7 - 0.8, indianred: 0.8 - 0.9, red: 0.9 - 1.0"

# Open a PDF device
pdf("./exams/midterm/plots/q3.pdf", width = 50, height = 50)

# Define the margins
par(mar = c(10, 10, 15, 10))

# Create the heatmap
image(
    1:num_names, 1:num_names, partial_cor_matrix,
    col = colors,
    breaks = breaks, xlab = "", ylab = "", axes = FALSE,
    main = "Partial Correlation Heatmap of Major Stocks", cex.main = 4
)

# Label the axes
axis(1, at = 1:num_names, labels = names, las = 2, cex.axis = 1)
axis(2, at = 1:num_names, labels = names, las = 2, cex.axis = 1)
axis(3, at = 1:num_names, labels = names, las = 2, cex.axis = 1)
axis(4, at = 1:num_names, labels = names, las = 2, cex.axis = 1)

# Add correlation text to cells
for (i in 1:num_names) {
    text(
        rep(i, num_names), 1:num_names,
        round(partial_cor_matrix[i, ], 2),
        font = 2, cex = 1
    )
}

# Add color key
mtext(side = 1, color_string, line = 5, cex = 1.5, font = 2)

# Close the PDF device
dev.off()

# Initialize an empty list to store the stock pairs with r > 0.6
high_corr_pairs <- list()

# Iterate through the correlation matrix and find pairs with r > 0.6
for (i in 1:(num_names - 1)) {
    for (j in (i + 1):num_names) {
        if (partial_cor_matrix[i, j] > 0.6) {
            high_corr_pairs <- c(
                high_corr_pairs,
                list(c(names[i], names[j], round(partial_cor_matrix[i, j], 2)))
            )
        }
    }
}

# Print the stock pairs with r > 0.6
cat("Pairs of stocks with r > 0.6:\n")
for (pair in high_corr_pairs) {
    cat(pair[1], "and", pair[2], "with r =", pair[3], "\n")
}
