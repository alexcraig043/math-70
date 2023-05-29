kmsimK <-
    function(K = 4, Kmax = 20, sigma = .2, st = 3) {
        set.seed(st)
        m <- 2 # dimension of x
        n <- 100 + round(10 + runif(K) * 100) # number of vectors in K clusters
        n[n < 3] <- 3 # can't be < than 3
        nsum <- sum(n)
        mu <- matrix(nrow = K, ncol = m) # centers
        for (i in 1:K) mu[i, ] <- runif(m, min = -1, max = 1) # random centers/mus
        X <- matrix(nrow = sum(n), ncol = m)
        # generate X with K clusters and centers mu and sigma
        ii <- 1
        for (k in 1:K)
        {
            for (j in 1:m) {
                X[ii:(ii + n[k] - 1), j] <- rnorm(n[k], mean = mu[k, j], sd = sigma)
            }
            ii <- ii + n[k]
        }

        par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
        Xmin <- min(X)
        Xmax <- max(X)
        plot(X[, 1], X[, 2], type = "n", xlim = c(Xmin, Xmax), ylim = c(Xmin, Xmax), main = paste(K, "clusters with sigma =", sigma), xlab = "x", ylab = "y")

        ii <- 1
        tt <- seq(from = 0, to = 2 * pi, length = 200)
        cost <- cos(tt)
        sint <- sin(tt)
        alpha <- 0.05
        qchi <- sqrt(qchisq(1 - alpha, df = m)) * sigma
        for (k in 1:K)
        {
            points(X[ii:(ii + n[k] - 1), 1], X[ii:(ii + n[k] - 1), 2], pch = 16, col = k + 1)
            segments(X[ii:(ii + n[k] - 1), 1], X[ii:(ii + n[k] - 1), 2], mu[k, 1], mu[k, 2], col = k + 1)
            ii <- ii + n[k]
            lines(mu[k, 1] + cost * qchi, mu[k, 2] + sint * qchi, col = k + 1) # 95% confidence circle
        }

        # Broken-line algorithm for detection of K
        Swin <- rep(0, Kmax)
        for (k in 1:Kmax) {
            Swin[k] <- kmeans(X, centers = k, nstart = 10)$tot.withinss
        } # Find the total within sum of squares from 1 to Kmax


        ss <- log(Swin)
        siMIN <- 1000000
        for (ik in 2:(Kmax - 2))
        {
            x1 <- 1:ik
            y1 <- ss[x1]
            x2 <- ik:Kmax
            y2 <- ss[x2]
            si <- sum(lm(y1 ~ x1)$residuals^2) + sum(lm(y2 ~ x2)$residuals^2)
            if (si < siMIN) {
                siMIN <- si
                km <- ik # K for which two SS is minimal
            }
        }

        plot(1:Kmax, ss, type = "b", xlab = "", ylab = "", main = "Broken-line algorithm", cex.main = 1.5)
        mtext(side = 1, "Number of clusters, K", line = 2.5, cex = 1.5)
        mtext(side = 2, "LOG within SS", line = 2.5, cex = 1.5)
        x1 <- 1:km
        y1 <- ss[x1]
        x2 <- km:Kmax
        y2 <- ss[x2]
        y1 <- lm(y1 ~ x1)$fitted.values
        lines(x1, y1)
        y2 <- lm(y2 ~ x2)$fitted.values
        lines(x2, y2)
        segments(km, -1, km, ss[km])
        text(km + .3, min(ss) + .1, paste("K = ", km), adj = 0, cex = 1.5, font = 2)
    }
