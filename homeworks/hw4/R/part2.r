### Information on the towns ###

town_labels <- c(1, 2, 3, 4, 5, 6)
town_rates <- c(2.1, 1.7, 1.0, 1.8, 1.5, 1.2)
town_locs <- c(
    c(70.1, 34.3), c(70.4, 35.2), c(69.3, 36.2),
    c(72.5, 35.8), c(71.2, 33.8), c(68.7, 34.5)
)

town_locs <- matrix(town_locs, nrow = 6, ncol = 2, byrow = TRUE)

print(town_locs)

distances <- matrix(0, nrow = 6, ncol = 6)

for (i in 1:6) {
    for (j in 1:6) {
        distances[i, j] <- dist(rbind(town_locs[i, ], town_locs[j, ]))
    }
}

correlations <- exp(-0.2 * distances)

matrix2latex <- function(matr) {
    printmrow <- function(x) {
        cat(cat(x, sep = " & "), "\\\\ \n")
    }

    cat("\\begin{bmatrix}", "\n")
    body <- apply(matr, 1, printmrow)
    cat("\\end{bmatrix}")
}

matrix2latex(correlations)
