/* Skeleton of Stan program 
 * for simple Poisson model
 * Order of blocks matters
 */
data {
  int<lower=1> N; // Number of observations
  int<lower=0> y[N]; // Array of count data
}
transformed data{
  int U = max(y); // Upper truncation point
  
}
parameters {
  real<lower = 0, upper = 1> theta; // Pr(y = 0)
  real<lower=0> lambda; // Poisson rate/mean parameter (must be positive real number
}
model {
  // Prior and likelihood; order within does not matter
  y ~ poisson(lambda); 
  //target += exponential_lpdf(lambda | 0.2); // alternative using target
  for(n in 1:N) {
    if (y[n] == 0) {
      target += log(theta); // basically log likelihood of bernoulli (coin flip)
    }
    else {
      target += log1m(theta); // equivalent to log(1 - theta)
      y[n] ~ poisson(lambda) T[1,U]; // truncated poisson with a max of U
    }
  }
}
generated quantities {
  // Simulate from posterior predictive distribution
  int<lower=0> y_rep[N]; // Array of count data
  for (n in 1:N) {
    if (bernoulli_rng(theta)) {
      y_rep[n] = 0;
    }
    else {
      int w = poisson_rng(lambda);
      while(w < 1 || w > U){
        w = poisson_rng(lambda) // here we are waiting for w to be truncated
      }
      y_rep[n] = w; 
    }
  }
}
