using StanSample, Test

ProjDir = @__DIR__
cd(ProjDir)

gq = "
  data {
    int<lower=0> N;
    int<lower=0> y[N];
  }
  parameters {
    real<lower=0.00001> Theta;
  }
  model {
    Theta ~ gamma(4, 1000);
    for (n in 1:N)
      y[n] ~ exponential(Theta);
  }
  generated quantities{
    real y_pred;
    y_pred = exponential_rng(Theta);
  }
";

gq_data = Dict(
  "N" => 3,
  "y" => [100, 950, 450]
);

stanmodel = SampleModel("Generate_quantities", gq);

(sample_file, log_file) = stan_sample(stanmodel; data=gq_data)

if !(sample_file == Nothing)
  stan_generate_quantities(stanmodel, 1)
end
