mortgAPP <-
    function() # LR and ROC/AUC for classification
    {
        dump("mortgAPP", "c:\\M7021\\mortgAPP.r")
        d <- read.csv("c:\\M7021\\mortgageAPP_DEF.csv")
        n <- nrow(d)

        o <- glm(Default ~ age + sex + mariStat + income + yearsW + ownCar + Savings, data = d, family = binomial)
        a <- coef(o)
        print(summary(o))

        sens <- fp <- rep(0, n)
        X <- as.matrix(d[, 1:7])
        linpred <- a[1] + X %*% a[2:8]
        cc <- sort(linpred)
        Y <- d$Default
        AUC <- 0
        for (i in 1:n)
        {
            sens[i] <- sum(linpred > cc[i] & Y == 1) / sum(Y) # > is used
            fp[i] <- sum(linpred > cc[i] & Y == 0) / sum(1 - Y) # > is used
            if (i > 1) AUC <- AUC + sens[i] * (fp[i - 1] - fp[i])
        }
        par(mfrow = c(1, 1), mar = c(4.5, 4.5, 3, 1), cex.lab = 1.5, cex.main = 1.5)
        plot(fp, sens, type = "s", lwd = 3, ylab = "Sensitivity", xlab = "False positive", main = "ROC curve for identification of nondefaulters")
        text(.6, .48, paste("AUC=", round(AUC * 100, 1), "%", sep = ""), adj = 0, cex = 1.5)

        print("Parsimonious model:")
        oPARS <- glm(Default ~ age + income + Savings, data = d, family = binomial)
        a <- coef(oPARS)
        print(summary(oPARS))
        XPARS <- cbind(d$age, d$income, d$Savings)
        linpred <- a[1] + XPARS %*% a[2:4]
        cc <- sort(linpred)
        sensPARS <- fpPARS <- rep(0, n)
        AUC.PARS <- 0
        for (i in 1:n)
        {
            sensPARS[i] <- sum(linpred > cc[i] & Y == 1) / sum(Y) # > is used
            fpPARS[i] <- sum(linpred > cc[i] & Y == 0) / sum(1 - Y) # > is used
            if (i > 1) AUC.PARS <- AUC.PARS + sensPARS[i] * (fpPARS[i - 1] - fpPARS[i])
        }
        lines(fpPARS, sensPARS, type = "s", lwd = 3, col = 2)
        text(.6, .4, paste("AUC.PARS=", round(AUC.PARS * 100, 1), "%", sep = ""), adj = 0, cex = 1.5, col = 2)
        legend("bottomright", c("Full LR model", "Parsimonious LR model"), col = c(1, 2), lty = 1, lwd = 2, bg = "grey96", cex = 1.5)
    }
