function StepFact = UpdateStepFact(StepFact,accepts,fsSampling)
AR = sum(accepts)/length(accepts);
StepFact = StepFact*(AR+0.1)/(fsSampling.TargetAcceptanceRatio+0.1);