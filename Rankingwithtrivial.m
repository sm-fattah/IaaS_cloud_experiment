
t_st=trial_month*each_month+1;
t_en=trial_month*each_month+30;

dist_trial_tp = zeros(total_provider,methods);
dist_trial_ir=dist_trial_tp;
dist_trial_rr=dist_trial_tp;
for m=1:methods
    for prov = 1:total_provider
        temp = CalcPerf(req_tp(t_st:t_en),trial_tp(:,prov,m));
        dist_trial_tp(prov,m)=temp.NRMSE;
        
        temp = CalcPerf(req_tp(t_st:t_en),trial_ir(:,prov,m));
        dist_trial_ir(prov,m)=temp.NRMSE;
        
        temp = CalcPerf(req_tp(t_st:t_en),trial_rr(:,prov,m));
        dist_trial_rr(prov,m)=temp.NRMSE;        
    end
end

dist_trial = dist_trial_tp+dist_trial_ir+dist_trial_rr;
[score_trial, trial_rank]=sort(mean(dist_trial,2));



req_distance_tp=zeros(total_provider,1);
req_distance_ir=zeros(total_provider,1);
req_distance_rr=zeros(total_provider,1);
for prov = 1:total_provider
    
    temp = CalcPerf(req_tp,actual_tp(:,prov));
    req_distance_tp(prov) = temp.NRMSE;
    
    temp = CalcPerf(req_ir,actual_ir(:,prov));
    req_distance_ir(prov) = temp.NRMSE;
    
    temp = CalcPerf(req_rr,actual_ir(:,prov));
    req_distance_rr(prov) = temp.NRMSE;

end
req_distance = req_distance_tp+req_distance_ir+req_distance_rr;
[original_score,original_rank] = sort(req_distance);

