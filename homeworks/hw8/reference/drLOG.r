drLOG <-
    function(job = 1) {
        dump("drLOG", "c:\\M7021\\drLOG.r")
        yx <- read.table("c:\\M7021\\RDheight.txt", header = T)
        # print(yx)
        if (job == 1) {
            par(mfrow = c(1, 2))
            hr <- yx$x[yx$y == 0]
            hd <- yx$x[yx$y == 1]
            print(t.test(hr, hd))
            boxplot(list(hr, hd), names = c("Republicans", "Democrats"), main = "Height of senators. Boxplot analysis")
            dr <- density(hr)
            dd <- density(hd)
            plot(dr$x, dr$y, type = "l", main = "Height of senators. Density analysis (red=D, black=R)", ylab = "Density", xlab = "Height")
            lines(dd$x, dd$y, col = 2)
            rug(hr)
            rug(hd, col = 2)
        }
        if (job == 2) {
            par(mfrow = c(1, 1))
            y <- yx$y
            x <- yx$x
            o <- glm(y ~ x, family = binomial)
            print(summary(o))
            plot(x, y, axes = F, xlab = "Height, inches", ylab = "Probability to be", xlim = c(55, 90), main = "Logistic regression for height of republicans and democrats")
            axis(side = 1, seq(from = 55, to = 90, by = 5))
            axis(side = 2, at = c(0, 1), labels = c("Republican (y=0)", "Democrat (y=1)"), srt = 90)
            b <- coef(o)
            xx <- seq(from = min(x), to = max(x), length = 100)
            prMOD <- exp(b[1] + b[2] * xx) / (1 + exp(b[1] + b[2] * xx))
            lines(xx, prMOD, lwd = 5)
            segments(0, .5, 100, .5, col = 2)

            # return()

            o <- glm(y ~ x, family = binomial(probit))
            print(summary(o))
            b <- coef(o)
            prPROB <- pnorm(b[1] + b[2] * xx)
            lines(xx, prPROB, col = 3)
            # return()

            # confidence band

            o <- glm(y ~ x, family = binomial)
            b <- coef(o)
            alpha <- 0.05
            lxx <- b[1] + b[2] * xx
            elxx <- exp(lxx)
            lx <- b[1] + b[2] * x
            elx <- exp(lx)
            di <- elx / (1 + elx)^2
            C <- matrix(0, 2, 2)
            C[1, 1] <- sum(di)
            C[1, 2] <- sum(di * x)
            C[2, 1] <- sum(di * x)
            C[2, 2] <- sum(di * x^2)
            C <- solve(C)
            print(sqrt(diag(C)))
            varP <- C[1, 1] + 2 * C[1, 2] * xx + C[2, 2] * xx^2
            Za <- pnorm(1 - alpha / 2)
            lowL <- lxx - Za * sqrt(varP)
            upL <- lxx + Za * sqrt(varP)
            lines(xx, exp(lowL) / (1 + exp(lowL)), col = 3)
            lines(xx, exp(upL) / (1 + exp(upL)), col = 3)
        }
    }
