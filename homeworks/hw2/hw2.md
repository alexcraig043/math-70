# Math 70 Homework 2

## Alex Craig

## Part 1.

**Question:** An asteroid approaches Earth following the trajectory $x(t) = 2 + 2t, y(t) = -2 -t, z(t) = 1 + t$ where $ t >= 0$ is time. Assuming that Earth is at location $(3, -1, 5)$, (a) does the asteroid approach or move away from Earth at the time of the discovery, (b) at what time is the distance at its minimum, and (c) will it hit Earth?

#### (a) Does the asteroid approach or move away from Earth at the time of the discovery?

Let $y$ be the location of the Earth, and $f(t)$ be the position of the asteroid at time $t$.

$$
f(t) = \begin{bmatrix} 2 + 2t \\ -2 - t \\ 1 + t \end{bmatrix}, y = \begin{bmatrix} 3 \\ -1 \\ 5 \end{bmatrix}
$$

The squared distance from the asteroid to the Earth is then given by

$$
H(t) = ||y - f(t)||^2
$$

To tell whether the asteroid is approaching or moving away from the Earth at any given time, we take the derivative of $H(t)$ with respect to $t$.

$$
velocity = \frac{dH(t)}{dt} = -2(y - f(t))^T(y - f(t))' = -2(y - f(t))^Tf'(t)
$$

$$
= -2(y - f(t))^T\begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix} = -2 \begin{bmatrix} 3 - (2 + 2t) \\ -1 - (-2 - t) \\ 5 - (1 + t) \end{bmatrix}^T \begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix}
$$

To tell whether the asteroid is approaching or moving away from the Earth ath time time of discovery, we need to know whether the change in rate of the squared distance is positive or negative at $t = 0$. We can do this by plugging in $t = 0$.

$$
\frac{dH(0)}{dt} = -2 \begin{bmatrix} 3 - 2 \\ -1 + 2 \\ 5 - 1 \end{bmatrix}^T \begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix} = -2 \begin{bmatrix} 1 \\ 1 \\ 4 \end{bmatrix}^T \begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix} = -10
$$

We can see the change in rate of the squared distance between the asteroid and the Earth at $t = 0$ is $-10$ and therefore the asteroid is moving towards the Earth at the time of discovery, because the squared distance is decreasing.

#### (b) At what time is the distance at its minimum?

To find the time at which the distance is at its minimum, we need to find the time at which the change in rate of the squared distance between the asteroid and the Earth is zero. We can do this by setting the derivative of $H(t)$ with respect to $t$ equal to zero.

$$
\frac{dH(t)}{dt} = 0 \Rightarrow -2(y - f(t))^Tf'(t)
$$

$$
= -2 \begin{bmatrix} 3 - (2 + 2t) \\ -1 - (-2 - t) \\ 5 - (1 + t) \end{bmatrix}^T \begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix} = -2 \begin{bmatrix} 1 - 2t \\ 1 + t \\ 4 - t \end{bmatrix}^T \begin{bmatrix} 2 \\ -1 \\ 1 \end{bmatrix}
$$

$$
= -2 (2(1 - 2t) - 1(1 + t) + 1(4 - t)) = -10 + 12t = 0
$$

$$
\Rightarrow t = \frac{5}{6}
$$

We can see that the change in rate of the squared distance between the asteroid and the Earth can be modeled by the function $\frac{dH(t)}{dt} = -10 + 12t$. This means that for $0 <= t < \frac{5}{6}$, the squared distance between the asteroid and the Earth is decreasing, and for $\frac{5}{6} < t <= \infty$, the squared distance between the asteroid and the Earth is increasing. Therefore, the squared distance between the asteroid and the Earth is at its minimum at $t = \frac{5}{6}$.

#### (c) Will the asteroid hit Earth?

To determine whether the asteroid will hit the Earth, we need to know whether the squared distance between the asteroid and the Earth is 0 at the minimum squared distance. We can do this by plugging in $t = \frac{5}{6}$ to $H(t)$.

$$
distance_{min} = H(\frac{5}{6}) = ||y - f(\frac{5}{6})||^2 = ||\begin{bmatrix} 3 \\ -1 \\ 5 \end{bmatrix} - \begin{bmatrix} 2 + 2(\frac{5}{6}) \\ -2 - \frac{5}{6}\\ 1 + \frac{5}{6} \end{bmatrix} ||^2
$$

$$
= ||\begin{bmatrix} -2 / 3 \\ 11 / 6 \\ 19 / 6 \end{bmatrix} ||^2 = \frac{83}{6}
$$

As we can see, the squared distance between the asteroid and the Earth is $>0$ at the minimum squared distance, so the asteroid will not hit the Earth.

## Part 2.

**Question:** Random variables $X, Y$, and $Z$ are independent with variances $1, 2$, and $3$, respectively. Find the $var(X + 2Y - Z)$ using formula (5).

$$
var(a^T X) = a^T cov(X) a \quad (5)
$$

First define $W$, the vector of random variables $X, Y$, and $Z$, and $a$, the vector that represents the linear combination $X + 2Y - Z$.

$$
W = \begin{bmatrix} X \\ Y \\ Z \end{bmatrix} \quad
a = \begin{bmatrix} 1 \\ 2 \\ -1 \end{bmatrix}
$$

The covariance matrix of $W$ is given by

$$
cov(W) = \begin{bmatrix} cov(X,X) & cov(Y,X) & cov(Z,X) \\ cov(X,Y) & cov(Y,Y) & cov(Z,Y) \\ cov(X,Z) & cov(Y,Z) & cov(Z,Z) \end{bmatrix}
$$

And because $X, Y$, and $Z$ are independent, the covariance between any two of them is zero.

$$
cov(W) = \begin{bmatrix} var(X) & 0 & 0 \\ 0 & var(Y) & 0 \\ 0 & 0 & var(Z) \end{bmatrix} = \begin{bmatrix} 1 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 3 \end{bmatrix}
$$

Now we can solve for $var(X + 2Y - Z)$ using formula (5).

$$
var(X + 2Y - Z) = var(a^T W) = a^T cov(W) a \quad (5)
$$

$$
 = [1 \quad 2 \quad -1]\begin{bmatrix} 1 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 3 \end{bmatrix} \begin{bmatrix} 1 \\ 2 \\ -1 \end{bmatrix} = [1 \quad 4 \quad -3] \begin{bmatrix} 1 \\ 2 \\ -1 \end{bmatrix}
$$

$$
= 1 + 4(2) + 3 = 12
$$

$$
\Rightarrow var(X + 2Y - Z) = 12
$$

## Part 4.

**Question:** Let the components of the _m_-dimensional random vector $X$ be iid with a common variance $\sigma^2$ and $Y = X + Z1$, where random variable $Z$ has variance $\tau^2$ and independent of $X$. Express $cor(Y)$ in matrix form using $1$ and $I$.
