---
geometry: margin=.5in
---

\centerline{\Large\bf Math 70 Homework 2}
\vspace{1em}
\centerline{\bf Alex Craig}
\vspace{3em}

## Part 1.

**Instructions:** Display the time of watching alcohol scenes as a function of age for a black girl who drinks, has an alcohol related item, with high income and high parents’ education, and has good grades as in function `kidsdrink(job=2)`. To contrast, display the same girl but who does not drink and does not have an alcohol related item. Compute, interpret, and display the effect of drinking and having an alcohol related item.

Effect: raises intercept

## Part 2.

**Instructions:** How do you find the most efficient estimator of the intercept in the multiple regression where the slopes are treated as a nuisance parameters (not a subject of interest)? Provide a proof.

The unbiased predictor for $\boldsymbol{\beta}$ is given by $\boldsymbol{\hat{\beta}} = (\bold{X}^T\bold{X})^{-1}\bold{X}^T\bold{y}$ where $\boldsymbol{\beta}$ is a vector of coefficients for the linear model $\bold{y} = \boldsymbol{\beta_1}\bold{x_1} + \boldsymbol{\beta_2}\bold{x_2} + \dots + \boldsymbol{\beta_m}\bold{x_m} + \boldsymbol{\epsilon}$. $\bold{X}$ is a design matrix with full rank and first column $\bold{1}$, and the remaining columns are predictor vectors $\bold{x_2} \dots \bold{x_m}$. $\boldsymbol{\epsilon}$ is a vector of random uncorrelated errors. $\bold{y}$ is a vector of random variables.

<!-- For the purposes of this question, $\boldsymbol{\beta_2} \dots \boldsymbol{\beta_m}$ are treated as nuisance parameters, and we are only interested in $\boldsymbol{\beta_1}$ which represents the intercept. We can find the most efficient estimator of $\boldsymbol{\beta_1}$ by minimizing the variance of $\boldsymbol{\hat{\beta}_1}$. -->

## Part 3.

**Instructions:** Provide a geometric interpretation of the following fact: the coefficient of determination does not change if the new predictor is orthogonal to the previous set of predictors and the residual vector from the previous regression.

Start with 1 predictor, x1, add x2 which is orthogonal to x1, the projection of y onto the plane spanned by x1 & x2 is the same as the projection of y onto the plane spanned by x1.

## Part 4.

**Instructions:** Plot residuals from regression of Height on Foot versus residuals from regression of Nose on Foot. Explain the result in connection to the negative slope in the multiple regression of Height on Foot and Nose.

$$
$$
