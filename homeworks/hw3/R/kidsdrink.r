kidsdrink <-
    function(job = 1) {
        d <- read.csv("./homeworks/hw3/data/kidsdrink.csv", header = T)
        if (job == 1) {
            pdf("./homeworks/hw3/plots/kidsdrink_job1.pdf", width = 8, height = 10)
            par(mfrow = c(1, 1), mar = c(4.5, 4.5, 1, 1), cex.lab = 1.5)
            plot(d$age, d$alcm, type = "n", xlab = "Age", ylab = "Time of watching, hours")
            for (a in 12:16)
            {
                da <- d$alcm[d$age == a]
                n <- length(da)
                points(rep(a, n), da)
                den <- density(da, from = 0)
                lines(a + 2.25 * den$y, den$x)
            }
        }
        if (job == 2) {
            d <- cbind(d, log(1 / 60^2 + d$alcm))
            names(d)[ncol(d)] <- "logalcm"
            # linear model
            o <- lm(logalcm ~ drink + age + boy + race + alcbr + pared + inc + grade, data = d)
            print(summary(o))
            pdf("./homeworks/hw3/plots/kidsdrink_job2.pdf", width = 16, height = 10)
            par(mfrow = c(1, 1), mar = c(4.5, 4.5, 1, 1), cex.lab = 1.5)
            alab <- c(1, 2, 5, 10, 25, 50)
            lalab <- log(alab)
            plot(d$age, d$logalcm, xlim = c(12, 17), ylim = range(lalab), type = "n", axes = F, xlab = "Age", ylab = "Alcohol scene watching")
            axis(side = 1, 12:16)
            axis(side = 2, at = lalab, labels = paste(alab, "h"), srt = 90)
            for (a in 12:16) {
                da <- d$logalcm[d$age == a]
                n <- length(da)
                points(rep(a, n), da)
                den <- density(da, from = 0)
                lines(a + 1.25 * den$y, den$x)
            }
            x <- 11:16
            a <- coef(o)
            print(a)
            # black girl who drinks, has alcohol related item,
            # has parents with high education, has high income,
            # and has good grades
            lines(x, a[1] + a[2] + a[3] * x + a[6] + a[7], col = 2, lwd = 3)
            intercept_first <- a[1] + a[2] + a[6] + a[7]
            # same black girl, except who doesn't drink
            # and doesn't have an alcohol related item
            lines(x, a[1] + a[3] * x + a[7], col = 3, lwd = 3, lty = 2)
            intercept_second <- a[1] + a[7]
            legend(
                13.2, log(2),
                c(
                    "Drink and have an alcohol related item",
                    "Do not drink and do not have an alcohol related item"
                ),
                col = 2:3, lwd = 3, lty = 1:2, bg = "gray97", cex = 1.5
            )

            # o <- lm(logalcm ~ age + boy + race + I(drink * alcbr) + pared + inc + grade, data = d)
            # print(summary(o))
        }
    }

kidsdrink(job = 2)
