kmsim <-
    function(n1 = 100, n2 = 200, sigma = .5, Kmax = 5) {
        X1 <- matrix(rnorm(n1 * 2, sd = sigma), ncol = 2)
        X2 <- matrix(rnorm(n2 * 2, mean = 1, sd = sigma), ncol = 2)
        X <- rbind(X1, X2)
        n <- n1 + n2
        par(mfrow = c(1, 2))
        plot(X[, 1], X[, 2], type = "n", xlab = "x", ylab = "y", main = paste("n1 = ", n1, ", n2 =", n2, ", sigma = ", sigma, sep = ""))
        points(X1[, 1], X1[, 2], col = 2, pch = 16)
        points(X2[, 1], X2[, 2], col = 3, pch = 16)
        ok <- kmeans(X, centers = 2)
        print(ok)

        print(paste("Total SS =", ok$totss))
        print(paste("Within SSs", 1:2, "=", ok$withinss))
        print(paste("Total within SS =", ok$tot.withinss))
        readline()

        points(ok$centers[1, 1], ok$centers[1, 2], col = 2, pch = 2, cex = 2)
        points(ok$centers[2, 1], ok$centers[2, 2], col = 3, pch = 2, cex = 2)

        id <- ok$cluster
        n1.cl <- length(id[id == 1])
        n2.cl <- length(id[id == 2])
        segments(X[id == 1, 1], X[id == 1, 2], rep(ok$centers[1, 1], n1.cl), rep(ok$centers[1, 2], n1.cl), col = 3)
        segments(X[id == 2, 1], X[id == 2, 2], rep(ok$centers[2, 1], n2.cl), rep(ok$centers[2, 2], n2.cl), col = 2)
        readline()


        da <- X
        TWSS <- rep(NA, Kmax)
        for (i in 1:Kmax) {
            TWSS[i] <- kmeans(da, centers = i, nstart = 10)$tot.withinss
        }
        LTWSS <- log(TWSS)
        plot(1:Kmax, LTWSS, type = "o", xlab = "", ylab = "", main = "Broken-line algorithm")
        mtext(side = 1, "Number of clusters, K", cex = 1, line = 2)
        mtext(side = 2, "LOG total within sum of squares", cex = 1, line = 2)
        TwoRSS_MIN <- 10^20
        for (ik in 2:(Kmax - 2))
        {
            x1 <- 1:ik
            y1 <- LTWSS[x1]
            x2 <- ik:Kmax
            y2 <- LTWSS[x2]
            TwoRSS <- sum(lm(y1 ~ x1)$residuals^2) + sum(lm(y2 ~ x2)$residuals^2)
            if (TwoRSS < TwoRSS_MIN) {
                TwoRSS_MIN <- TwoRSS
                K <- ik
            }
        }
        # two-segment visualization
        x1 <- 1:K
        y1 <- LTWSS[x1]
        x2 <- K:Kmax
        y2 <- LTWSS[x2]
        y1 <- lm(y1 ~ x1)$fitted.values
        lines(x1, y1)
        y2 <- lm(y2 ~ x2)$fitted.values
        lines(x2, y2)
        segments(K, -1, K, LTWSS[K], lwd = 2, col = 2)
        print(paste("Optimal K =", K))
    }
