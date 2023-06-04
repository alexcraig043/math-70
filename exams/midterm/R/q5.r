### Reading Data ###

data <- read.csv("./exams/midterm/data/Most active stocks prices_Feb_01.2023.csv")

data <- data[, -1] # remove date column

# Define column names and number of columns
names <- colnames(data)
num_names <- length(names)

window <- 90 # 90 days

# Define breaks and colors
breaks <- seq(-0.4, 1, length.out = 15)
colors <- c(
    "blue3", "blue", "dodgerblue2",
    "dodgerblue", "skyblue", "darkolivegreen",
    "yellowgreen", "greenyellow", "yellow", "goldenrod",
    "darkorange", "coral", "indianred", "red"
)
color_string <- "blue3: (-0.4) - (-0.3), blue: (-0.3) - (-0.2), dodgerblue2: (-0.2) - (-0.1), dodgerblue: (-0.1) - 0.0, skyblue: 0.0 - 0.1, darkolivegreen: 0.1 - 0.2, yellowgreen: 0.2 - 0.3, greenyellow: 0.3 - 0.4, yellow: 0.4 - 0.5, goldenrod: 0.5 - 0.6, darkorange: 0.6 - 0.7, coral: 0.7 - 0.8, indianred: 0.8 - 0.9, red: 0.9 - 1.0"


# Start at the window'th day
for (day in window:nrow(data)) {
    # Get the data for the window
    data_window <- data[(day - window + 1):day, ]

    # Convert data to a matrix
    data_matrix <- as.matrix(data_window)
    num_rows <- nrow(data_matrix)

    # Take the log transform of the data by taking log(row t / row t - 1)
    data_matrix <- log(data_matrix[2:num_rows, ] / data_matrix[1:(num_rows - 1), ])

    # Define the correlation matrix
    cor_matrix <- cor(data_matrix)

    # Set the diagonal to NA
    diag(cor_matrix) <- NA

    # Open a PNG device
    png(
        paste("./exams/midterm/plots/q5_frames/frame_", day, ".png", sep = ""),
        width = 3500, height = 3500
    )

    # Define the margins
    par(mar = c(12, 10, 15, 10))

    # Create the heatmap
    image(
        1:num_names, 1:num_names, cor_matrix,
        col = colors,
        breaks = breaks, xlab = "", ylab = "", axes = FALSE,
        main = paste("Correlation Heatmap of Major Stocks (Calculated from Day ", day - window + 1, " to Day ", day, ")", sep = ""),
        cex.main = 4.5
    )

    # Label the axes
    axis(1, at = 1:num_names, labels = names, las = 2, cex.axis = 1.25)
    axis(2, at = 1:num_names, labels = names, las = 2, cex.axis = 1.25)
    axis(3, at = 1:num_names, labels = names, las = 2, cex.axis = 1.25)
    axis(4, at = 1:num_names, labels = names, las = 2, cex.axis = 1.25)

    # Add correlation text to cells
    for (i in 1:num_names) {
        text(
            rep(i, num_names), 1:num_names,
            round(cor_matrix[i, ], 2),
            font = 2, cex = 1
        )
    }

    # Add color key
    mtext(side = 1, color_string, line = 8, cex = 2, font = 2)

    # Close the PNG device
    dev.off()
}

# Create the animation

library(gifski)

frames <- list.files("./exams/midterm/plots/q5_frames/",
    pattern = ".png",
    full.names = TRUE
)

gifski(
    frames,
    gif_file = "./exams/midterm/plots/q5.gif",
    width = 1000, height = 1000,
    delay = 0.1
)
