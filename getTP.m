function result=getTP(time,provider,workload,tp)
    
    if(workload==0)
        result = 0;
        return;
    end
    workFact = workloadFactor(workload,provider);
    timeFact = timeFactor(time,provider);
    result = timeFact * workFact * tp(workload+1) + randi(1000);
    %result = timeFact * workFact * tp(workload+1);


end