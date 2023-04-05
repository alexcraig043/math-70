# Make a "tr" function that sums the diagonal elements
tr <- function(M) sum(diag(M))

a <- 1:8
# cat(a)

A <- a%*%t(a)
# cat(A)

# Get the sum of the diagonal elements
cat(tr(A))

# A <- matrix(a, ncol = 2, byrow = FALSE)
# cat(A)