### Information on the towns ###
mu_x <- c(2.1, 1.7, 1.0, 1.8, 1.5)
x <- c(2.1, 4.1, 1.0, 1.8, 1.5)
mu_y <- 1.2
town_locs <- c(
    c(70.1, 34.3), c(70.4, 35.2), c(69.3, 36.2),
    c(72.5, 35.8), c(71.2, 33.8), c(68.7, 34.5)
)
town_locs <- matrix(town_locs, nrow = 6, ncol = 2, byrow = TRUE)
sigma <- 0.1

distances <- matrix(0, nrow = 6, ncol = 6)

for (i in 1:6) {
    for (j in 1:6) {
        distances[i, j] <- dist(rbind(town_locs[i, ], town_locs[j, ]))
    }
}

R <- exp(-0.2 * distances)

D <- diag(sigma^2, nrow = 5, ncol = 5)

w <- rep(sigma^2, 5)
for (i in 1:5) {
    w[i] <- w[i] * R[i, 6]
}

Omega <- D^(1 / 2) %*% R[1:5, 1:5] %*% D^(1 / 2)

Omega_inv <- solve(Omega)

exp_y <- mu_y + t(w) %*% Omega_inv %*% (x - mu_x)

var_y <- sigma^2 - t(w) %*% Omega_inv %*% w

### 95% CI ###

c_1 <- 1.265522 - 1.959964 * 0.02683833
c_2 <- 1.265522 + 1.959964 * 0.02683833

print(c(c_1, c_2))
