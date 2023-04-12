---
geometry: margin=.5in
---

# Math 70 Homework 2

## Alex Craig

## Part 1.

**Instructions:** Generate $z_1$ and $z_2$ as above and graph the scatter plot. Compute and show the regression lines $z_1$ on $z_2$, $z_2$ on $z_1$, and the major principle axis. Print out the four slopes and explain the results.

## Part 2.

**Instructions:** Prove that $\bold{A}^{1/2}$, $\bold{A}^{-1}$, and $\bold{A}^{-1/2}$ derived through the matrix function meet their definitions.

If $\bold{A}$ is a symmetric matrix with spectral decomposition $\bold{A} = \bold{P}\bold{\Lambda}\bold{P}^{-1}$, then

$$
f(\bold{A}) = \bold{P}f(\bold{\Lambda})\bold{P}^{T}
$$

Keep in mind that matrix $\bold{P}$ is orthogonal, so $\bold{P}^{T} = \bold{P}^{-1}$, so $\bold{P}^T \bold{P} = \bold{P} \bold{P}^T = \bold{I}$.

### 2.1 Proving $\bold{A}^{1/2}$ Meets Definition

By definition, $\bold{A}^{1/2} \bold{A}^{1/2} = \bold{A}$. Lets prove this identity through the matrix function.

$$
\bold{A}^{1/2} \bold{A}^{1/2} = \bold{P}\bold{\Lambda^{1/2}}\bold{P}^{T} \bold{P}\bold{\Lambda^{1/2}}\bold{P}^{T} = \bold{P}\bold{\Lambda^{1/2}} \bold{I} \bold{\Lambda^{1/2}}\bold{P}^{T}
$$

$$
= \bold{P}\bold{\Lambda}\bold{P}^{T} = \bold{A}
$$

### 2.2 Proving $\bold{A}^{-1}$ Meets Definition

By definition, $\bold{A} \bold{A}^{-1} = \bold{I}$. Lets prove this identity through the matrix function.

$$
\bold{A} \bold{A}^{-1} = \bold{P}\bold{\Lambda}\bold{P}^{T} \bold{P}\bold{\Lambda^{-1}}\bold{P}^{T} = \bold{P}\bold{\Lambda} \bold{I} \bold{\Lambda^{-1}}\bold{P}^{T} = \bold{P}\bold{I}\bold{P}^{T} = \bold{I}
$$

$\bold{A}^{-1} \bold{A} = \bold{I}$ is also true.

$$
\bold{A}^{-1} \bold{A} = \bold{P}\bold{\Lambda^{-1}}\bold{P}^{T} \bold{P}\bold{\Lambda}\bold{P}^{T} = \bold{P}\bold{\Lambda^{-1}} \bold{I} \bold{\Lambda}\bold{P}^{T} = \bold{P}\bold{I}\bold{P}^{T} = \bold{I}
$$

### 2.3 Proving $\bold{A}^{-1/2}$ Meets Definition

By definition, $\bold{A}^{-1/2} \bold{A}^{-1/2} = \bold{A}^{-1}$. Lets prove this identity through the matrix function.

$$
\bold{A}^{-1/2} \bold{A}^{-1/2} = \bold{P}\bold{\Lambda^{-1/2}}\bold{P}^{T} \bold{P}\bold{\Lambda^{-1/2}}\bold{P}^{T} = \bold{P}\bold{\Lambda^{-1/2}} \bold{I} \bold{\Lambda^{-1/2}}\bold{P}^{T} = \bold{P}\bold{\Lambda^{-1}}\bold{P}^{T} = \bold{A}^{-1}
$$

## Part 3.

**Instructions:** Prove that $\frac{\partial ||x||}{\partial x} = \frac{x}{||x||}$.

$||x||$ is the norm of $x$ and can be defined as the square root of the scalar product of $x$ with itself. Thus

$$
||x|| = \sqrt{x^T x}
$$

We can then differentiate this expression with respect to $x$.

$$
\frac{\partial ||x||}{\partial x} = \frac{\partial \sqrt{x^Tx}}{\partial x}
$$

Apply chain rule

$$
\frac{\partial \sqrt{x^Tx}}{\partial x} = \frac{1}{2\sqrt{x^Tx}} \frac{\partial (x^Tx)}{\partial x}
$$

Apply product rule

$$
\frac{\partial (x^Tx)}{\partial x} = \frac{\partial x^T}{\partial x} x + x^T \frac{\partial x}{\partial x} = I x + x^T I = 2x
$$

$$
\Rightarrow \frac{1}{2\sqrt{x^Tx}} \frac{\partial (x^Tx)}{\partial x} = \frac{1}{2\sqrt{x^Tx}} 2x = \frac{x}{\sqrt{x^Tx}} = \frac{x}{||x||}
$$

$$
\Rightarrow \frac{\partial ||x||}{\partial x} = \frac{x}{||x||}
$$
