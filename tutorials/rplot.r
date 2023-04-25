rplot <-
    function() {
        # dump("rplot","c:\\M7021\\rplot.r")
        # par(mfrow=c(1,1),mar=c(4.5,4.5,3,1),cex.lab=1.5,cex.main=1.5)
        x <- 1:100
        y <- .1 * x + rnorm(100)
        plot(x, y)
        print("Default points scatterplot")
        readline()
        plot(x, y, type = "l")
        print("Default line scatterplot")
        readline()
        plot(x, y, type = "o", col = 3)
        print("Default line-points (o) scatterplot")
        readline()

        lines(x, .1 * x, lwd = 3, lty = 2, col = 2)
        print("add a line")
        readline()
        points(x, y, pch = 18, col = 3, cex = 3)
        print("Customized scatterplot, pch,col,cex")
        readline()

        x1 <- 20
        y1 <- 6
        x2 <- 80
        y2 <- 0
        segments(x1, y1, x2, y2, col = 4, lwd = 3, lty = 3)
        readline()
        print("Add customized segments")

        par(mfrow = c(1, 1), mar = c(4.5, 4.5, 4, 1), cex.lab = 1.5, cex.main = 1.5)
        plot(x, y, axes = F) # Dummy plot
        axis(side = 1, seq(from = min(x), to = max(x), by = .1))
        axis(side = 2, seq(from = min(y), to = max(y), by = .25))
        print("Customized axes")
        readline()
        n <- length(x)
        y1 <- runif(n)
        y2 <- runif(n)
        y3 <- rnorm(n)
        matplot(x, cbind(y1, y2, y3), type = "l", col = 1:3, lwd = c(3, 1, 2), lty = 1, xlab = "Time", ylab = "Stock return")
        print("matplot")
        readline()

        mtext(side = 3, "Mtext tex -- your own control", cex = 2, font = 2, line = 2)
        print("Customized mtext")
        readline()
        text(70, -2, paste("R-squared =", round(cor(x, y)^2, 2)), cex = 2, font = 2, col = 4)
        legend("topright", c("line1", "line2", "line3"), col = 1:3, lty = 1, lwd = 3, cex = 1.5, bg = "grey95")
        print("paste command")
    }
