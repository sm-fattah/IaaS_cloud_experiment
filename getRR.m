function result=getRR(time,provider,workload,rr)
    if(workload==0)
        result=0;
        return;
    end
    
    a = 0.1;
    b = 0.2;
    r = (b-a).*rand + a;
    workFact = workloadFactor(workload,provider);
    timeFact = timeFactor(time,provider);
    result = timeFact * workFact * rr(workload+1)+r;

end