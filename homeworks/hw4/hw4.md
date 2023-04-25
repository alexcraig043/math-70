---
geometry: margin=.5in
---

\centerline{\Large\bf Math 70 Homework 4}
\vspace{1em}
\centerline{\bf Alex Craig}
\vspace{3em}

## Part 1.

### Instructions:

The bivariate normal distribution is given by $\mu_y = -1, \sigma_y = 0.8, \mu_x = 2, \sigma_x = 1.5$ and $\rho = -0.6$
(a) Use contour command to plot contours of the pdf.
(b) Add the regression line as the conditional mean of $Y$ on $X$ along with $\pm \sigma_{y|x}$ line.
(c) Generate 100 pairs from this distribution by generating marginal $X$ and then normally distributed conditional $Y$.
(d) Display the arrow with the maximum eigenvector at the center of the distribution.
(e) Add contours of the estimated $\boldsymbol{\Omega}$ computed by var with different color (use contour with option `add=T`).

### Solution:

## Part 2.

### Instructions:

The average covid rates at six towns are $(2.1, 1.7, 1.0, 1.8, 1.5, 1.2)$ with SD = $0.1$. The GPS town locations are $(70.1, 34.3), (70.4, 35.2), (69.3, 36.2), (72.5, 35.8), (71.2, 33.8), (68.7, 34.5)$. A covid outbreak is detected in town #2: the rate raised to $4.1$. Assuming that the spatial correlation between towns $i$ and $j$ is modeled as $e^{-0.2d_{ij}}$ where $d_{ij}$ is the distance, what is the expected $95\%$ confidence interval for the rate of covid in town $6$? Make other necessary plausible assumptions if needed.

### Solution:

Let us define a vector of initial covid rates $\bold{x}$ and a matrix of distances between towns $\bold{D}$ as

$$
\bold{x} = \begin{bmatrix} 2.1 \\ 1.7 \\ 1.0 \\ 1.8 \\ 1.5 \\ 1.2 \end{bmatrix}, \quad \bold{D} = \begin{bmatrix}
0 & 0.9486833 & 2.061553 & 2.830194 & 1.208305 & 1.414214 \\
0.9486833 & 0 & 1.486607 & 2.184033 & 1.612452 & 1.838478 \\
2.061553 & 1.486607 & 0 & 3.224903 & 3.061046 & 1.802776 \\
2.830194 & 2.184033 & 3.224903 & 0 & 2.385372 & 4.016217 \\
1.208305 & 1.612452 & 3.061046 & 2.385372 & 0 & 2.596151 \\
1.414214 & 1.838478 & 1.802776 & 4.016217 & 2.596151 & 0 \\
\end{bmatrix}
$$

We can then define a correlation matrix $\bold{R}$ as $\bold{R}_{ij} = e^{-0.2\bold{D}_{ij}}$

$$
\bold{R} = \begin{bmatrix}
1 & 0.8271769 & 0.6621186 & 0.56777 & 0.7853224 & 0.7536383 \\
0.8271769 & 1 & 0.7428053 & 0.6460964 & 0.724343 & 0.6923279 \\
0.6621186 & 0.7428053 & 1 & 0.5246727 & 0.5421519 & 0.6972891 \\
0.56777 & 0.6460964 & 0.5246727 & 1 & 0.6205963 & 0.447874 \\
0.7853224 & 0.724343 & 0.5421519 & 0.6205963 & 1 & 0.5949784 \\
0.7536383 & 0.6923279 & 0.6972891 & 0.447874 & 0.5949784 & 1 \\
\end{bmatrix}
$$

The $i^{th}$ column of $\bold{D}$ is the distance from town $i$ to all other towns. The $i^{th}$ column of $\bold{R}$ is the correlation between town $i$ and all other towns.

Let $\bold{y}$ be the vector of updated covid rates. We know that $\bold{y}_2 = 4.1$, and we are trying to find the $95\%$ confidence interval for the value of $\bold{y}_6$. Let us use the formulas

$$
E(Y|\bold{X} = \bold{x}) = \mu_y + \boldsymbol{\omega}_{yx}^T \boldsymbol{\Omega}_{xx}^{-1} (\bold{x} - \boldsymbol{\mu}_x), \quad var(Y|\bold{X} = \bold{x}) = \sigma_y^2 - (1 - \rho_{yx} ^ 2)
$$

where

$$
\boldsymbol{\omega}_{yx} = cov(Y, \bold{X}), \quad \rho_{yx}^2 = \sigma_y^{-2} \boldsymbol{\omega}_{yx} \boldsymbol{\Omega}_{xx}^{-1} \boldsymbol{\omega}_{yx}
$$

In this case $Y = \bold{y}_6$ is the updated covid rate in town $2$.

## Part 3.

### Instructions:

Generate $200$ trivariate normally distributed random vectors with the mean vector $2, 2, 4$ and covariance matrix

$$
\begin{bmatrix} 2 & -1 & -1 \\ -1 & 3 & 1 \\ -1 & -1 & 4 \end{bmatrix}
$$

and 300 trivariate normally distributed random vectors with the mean vector $1, -2, 1$ and covariance matrix

$$
\begin{bmatrix} 4 & 1 & 0.5 \\ 1 & 1 & -0.1 \\ 0.1 & -0.1 & 2 \end{bmatrix}
$$

Create animation with the `theta` angle running from $1$ to $360\degree$. Use different colors to show the two groups. Submit as a `*.pptx` file

### Solution:
