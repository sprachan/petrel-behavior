// The input data is a vector 'y' of length 'N'.
data {
  // data size
  int N; // number of rows in the data (number of observations of all the data)
  int B; //number of behaviors
  
  // individual ID and physical characteristics
  //int num_observations[N];
  int band[N];
  real tarsus[N];
  real weight[N];
  real wing[N];
  int sex[N];
  int experience[N];
  
  // effects of the observation process
  real exttime[N];
  
  // behavioral response
  int passive[N];
  int bite[N];
  int run_hide[N];
  int regurgitate[N];
  int vocalize[N];
  int kick[N];
  
}

// The parameters accepted by the model: 
// beta_wt, beta_TL, beta_WL, beta_0
parameters {
 real coeff_wt[B];
 real beta0[B];
}

// The model to be estimated. 
model {
  coeff_wt ~ normal(0, 10);
  beta0 ~ normal(0, 10);
  // for each individual, for each behavior, generate a p.
  for(i in 1:N){
    bite[i] ~ bernoulli_logit(coeff_wt[1]*weight[i]+beta0[1]);
    run_hide[i] ~ bernoulli_logit(coeff_wt[2]*weight[i]+beta0[2]);
    regurgitate[i] ~ bernoulli_logit(coeff_wt[3]*weight[i]+beta0[3]);
    vocalize[i] ~ bernoulli_logit(coeff_wt[4]*weight[i]+beta0[4]);
    kick[i] ~ bernoulli_logit(coeff_wt[5]*weight[i]+beta0[5]);
  }
}

generated quantities{
  // quantity we want to generate
  matrix[N,B] p;
  for(n in 1:N){
    for(b in 1:B){
      p[n,b] = exp(coeff_wt[b]*weight[n]+beta0[b])/(1+exp(coeff_wt[b]*weight[n]+beta0[b]));
    }
  }
}
  



