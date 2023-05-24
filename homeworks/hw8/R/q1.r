### Load data

shopper_data <- read.csv("./homeworks/hw8/data/amazshop.csv", header = T)

### Part A

# Create logistic regression model

full_model <- glm(
    shop ~ .,
    data = shopper_data, family = binomial
)

# summary(model)

# Create logistic regression model with only significant variables
parsimonious_model <- glm(
    shop ~ age + total,
    data = shopper_data, family = binomial
)

# summary(parsimonious_model)

### Part B

# Create the model under null hypothesis

null_model <- glm(
    shop ~ 1,
    data = shopper_data, family = binomial
)

## Calculating the likelihood ratio test

# Compute the likelihoods of the null model and the parsimonious model
null_deviance <- null_model$deviance
parsimonious_deviance <- parsimonious_model$deviance

# The likelihood ratio statistic (deviance) is the difference in deviance
# between the null model and the full model.
lr_stat <- null_deviance - parsimonious_deviance

# The degrees of freedom is the difference in degrees of freedom between
# the null model and the parsimonious model.
df <- null_model$df.residual - parsimonious_model$df.residual

# Use the chi-squared distribution to compute the p-value
p_value <- pchisq(lr_stat, df, lower.tail = FALSE)

# Print the p-value
print(p_value)

### Part C

# Define a sequence from minimum total to maximum total
total_seq <- seq(min(shopper_data$total),
    max(shopper_data$total),
    length.out = 10000
)

# Create data frames for 20 and 60 year old shoppers
shopper_data_20 <- data.frame(total = total_seq, age = 20)
shopper_data_60 <- data.frame(total = total_seq, age = 60)

# Make sure the data frames are sorted by total
shopper_data_20 <- shopper_data_20[order(shopper_data_20$total), ]
shopper_data_60 <- shopper_data_60[order(shopper_data_60$total), ]

# Predict the probability of shopping for 20 and 60 year olds
shopper_data_20$prob <- predict(
    parsimonious_model, shopper_data_20,
    type = "response"
)
shopper_data_60$prob <- predict(
    parsimonious_model, shopper_data_60,
    type = "response"
)

### Part D

# Define age and total spent
age_value <- 60
total_value <- 2000

# Get the coefficients of the logistic regression model
model_coefficients <- coef(parsimonious_model)

# Linear predictor for the given age and total
linear_predictor <- model_coefficients[1] + model_coefficients[2] *
    age_value + model_coefficients[3] * total_value

# Linear predictor for all data
linear_predictor_all <- model_coefficients[1] + model_coefficients[2] *
    shopper_data$age + model_coefficients[3] * shopper_data$total

# Exponential of the linear predictors
exp_linear_predictor_all <- exp(linear_predictor_all)

# Compute di for all data, which is used to compute the covariance matrix
d_i <- exp_linear_predictor_all / (1 + exp_linear_predictor_all)^2

# Compute the covariance matrix
cov_matrix <- matrix(0, 3, 3)
cov_matrix[1, 1] <- sum(d_i)
cov_matrix[1, 2] <- sum(d_i * shopper_data$age)
cov_matrix[1, 3] <- sum(d_i * shopper_data$total)
cov_matrix[2, 1] <- cov_matrix[1, 2]
cov_matrix[2, 2] <- sum(d_i * shopper_data$age^2)
cov_matrix[2, 3] <- sum(d_i * shopper_data$age * shopper_data$total)
cov_matrix[3, 1] <- cov_matrix[1, 3]
cov_matrix[3, 2] <- cov_matrix[2, 3]
cov_matrix[3, 3] <- sum(d_i * shopper_data$total^2)

# Invert the covariance matrix
cov_matrix <- solve(cov_matrix)

# Instantiate an x vector
x <- c(1, age_value, total_value)

# Compute variance of the probability
var_prob <- t(x) %*% cov_matrix %*% x

# Compute the z-score for the alpha level
alpha <- 0.05
z_score <- qnorm(1 - alpha / 2)

# Compute the lower and upper bounds of the confidence interval
lower_bound <- linear_predictor - z_score * sqrt(var_prob)
upper_bound <- linear_predictor + z_score * sqrt(var_prob)

# Transform back to the probability scale
lower_bound_prob <- exp(lower_bound) / (1 + exp(lower_bound))
upper_bound_prob <- exp(upper_bound) / (1 + exp(upper_bound))

confidence_interval <- c(lower_bound_prob, upper_bound_prob)

# Print the confidence interval
print(confidence_interval)

## Plotting

# Open a png device
png("./homeworks/hw8/plots/q1c.png", width = 1600, height = 1200)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Plot the probability of shopping for 20 year olds vs. total
plot(
    shopper_data_20$total, shopper_data_20$prob,
    type = "l", col = "blue", lwd = 3,
    xlab = "Total Spent ($)", ylab = "Probability of Being an Active Shopper",
    main = "Probability of Being an Active Shopper vs. Total Spent",
    cex.main = 3, cex.lab = 2.5, cex.axis = 2.5
)

# Plot the probability of shopping for 60 year olds vs. total
lines(
    shopper_data_60$total, shopper_data_60$prob,
    type = "l", col = "red", lwd = 3
)

# Add a point for 60 year old who spends $2000
points(
    total_value, predict(
        parsimonious_model, data.frame(age = age_value, total = total_value),
        type = "response"
    ),
    col = "red", pch = 19, cex = 2
)

# Add a like for the confidence interval
lines(
    c(total_value, total_value),
    c(confidence_interval[1], confidence_interval[2]),
    col = "red", lwd = 3
)

# Add a legend
legend(
    "bottomright",
    legend = c("20 Years Old", "60 Years Old", "60 Years Old, $2000 Spent"),
    col = c("blue", "red", "red"),
    lty = c(1, 1, 0), pch = c(NA, NA, 19),
    lwd = 2, cex = 2
)

# Close the png device
dev.off()

### Part E

# Full Model

# Coefficients of the full model
full_model_coefficients <- coef(full_model)

# Independent variables matrix for the full model
X_full <- as.matrix(shopper_data[, names(full_model_coefficients)[-1]])

# Linear predictors for the full model
full_model_linpred <- full_model_coefficients[1] +
    X_full %*% full_model_coefficients[-1]

# Active shopper indicator
Y <- shopper_data$shop

# Sensitivity and False positive rates for full model
n <- nrow(shopper_data)
sensitivity_full <- false_positive_full <- numeric(n)
AUC_full <- 0
sorted_full_model_linpred <- sort(full_model_linpred)

for (i in 1:n) {
    sensitivity_full[i] <- sum(full_model_linpred >
        sorted_full_model_linpred[i] & Y == 1) / sum(Y == 1)
    false_positive_full[i] <- sum(full_model_linpred >
        sorted_full_model_linpred[i] & Y == 0) / sum(Y == 0)
    if (i > 1) {
        AUC_full <- AUC_full + sensitivity_full[i] *
            (false_positive_full[i - 1] - false_positive_full[i])
    }
}

# Parsimonious Model

# Coefficients of the parsimonious model
pars_model_coefficients <- coef(parsimonious_model)

# Independent variables matrix for the parsimonious model
X_pars <- as.matrix(shopper_data[, names(pars_model_coefficients)[-1]])

# Linear predictors for the parsimonious model
pars_model_linpred <- pars_model_coefficients[1] +
    X_pars %*% pars_model_coefficients[-1]

# Sensitivity and False positive rates for parsimonious model
sensitivity_pars <- false_positive_pars <- numeric(n)
AUC_pars <- 0
sorted_pars_model_linpred <- sort(pars_model_linpred)

for (i in 1:n) {
    sensitivity_pars[i] <- sum(pars_model_linpred >
        sorted_pars_model_linpred[i] & Y == 1) / sum(Y == 1)
    false_positive_pars[i] <- sum(pars_model_linpred >
        sorted_pars_model_linpred[i] & Y == 0) / sum(Y == 0)
    if (i > 1) {
        AUC_pars <- AUC_pars + sensitivity_pars[i] *
            (false_positive_pars[i - 1] - false_positive_pars[i])
    }
}

# Plotting ROC curves

# Open a png device
png("./homeworks/hw8/plots/q1e.png", width = 1600, height = 1200)

# Set the margins
par(mar = c(10, 10, 10, 10))

# Plot ROC curve for the full model
plot(false_positive_full, sensitivity_full,
    type = "s", lwd = 3,
    xlab = "False Positive Rate", ylab = "Sensitivity",
    main = "ROC Curves for Full and Parsimonious Models", col = "blue",
    cex.main = 3, cex.lab = 2.5, cex.axis = 2.5
)

# Add AUC for full model
text(
    0.6, 0.48, paste("AUC for Full Model = ",
        round(AUC_full * 100, 1), "%",
        sep = ""
    ),
    adj = 0, cex = 2, col = "blue"
)

# Add ROC curve for the parsimonious model
lines(false_positive_pars, sensitivity_pars, type = "s", lwd = 3, col = "red")

# Add AUC for parsimonious model
text(
    0.6, 0.4, paste("AUC for Parsimonious Model = ",
        round(AUC_pars * 100, 1), "%",
        sep = ""
    ),
    adj = 0, cex = 2, col = "red"
)

# Add a legend
legend("bottomright", c("Full Model", "Parsimonious Model"),
    col = c("blue", "red"),
    lty = 1, lwd = 2, cex = 1.5
)

# Close the png device
dev.off()
