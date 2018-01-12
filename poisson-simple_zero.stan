/* Skeleton of Stan program 
 * for simple Poisson model
 * Order of blocks matters
 */
data {
  int<lower=1> N; // Number of observations
  int<lower=0> y[N]; // Array of count data
}
parameters {
  // Poisson rate/mean parameter (must be positive real number)
   real<lower=0> lambda;
}
model {
  // Prior and likelihood; order within does not matter
  y ~ poisson(lambda); 
  //target += exponential_lpdf(lambda | 0.2); 
  lambda ~ exponential(0.2);
  //target += poisson_lpmf(y | lambda); // target is what we are trying to accumulate into the log likilihood; += takes the target value, which starts at zero, and then evaluate the likelihood of y given the current markov value of lambda
  //lpmf = log of the probability mass function
  
}
generated quantities {
  // Simulate from posterior predictive distribution
  int<lower=0> y_rep[N]; // Array of count data
  for (n in 1:N) {
    y_rep[n] = poisson_rng(lambda); // this is the posterior
  }
}
