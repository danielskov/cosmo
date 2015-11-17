function setseed(seed)
try
  rng(seed)
catch
  rand('seed',seed)
  randn('seed',seed)
end