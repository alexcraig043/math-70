A <- matrix(runif(10^2), ncol = 10, nrow = 10)
A <- t(A) %*% A # we need a symmetric matrix
eA <- eigen(A, symmetric = T)
print(eA)
AtA <- A %*% t(A)
eA <- eigen(AtA)
print(eA)
print(AtA)
print(eA$vectors %*% diag(eA$values, 10, 10) %*% t(eA$vectors))