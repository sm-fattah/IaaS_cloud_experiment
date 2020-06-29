load('./Data/advertisements.mat');

add = advertisements(1:6,:);

time = 3; %number of time stamps

[no_QoS,no_provider] = size(add);

desired_ad = add(:,1);
no_QoS = no_QoS/time;

ad_dist = zeros(total_provider,1);

for prov=1:total_provider
    
    temp = CalcPerf(desired_ad,add(:,prov));    
    ad_dist(prov)= temp.NRMSE;
    
end

[ad_score,ad_rank]=sort(ad_dist);



t_st=(trial_month-1)*each_month+1;
t_en=t_st-1+30;

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

%distance for regenerated QoS accuracy
dist_reg_tp = zeros(total_provider,methods);
dist_reg_ir=dist_reg_tp;
dist_reg_rr=dist_reg_tp;
for m=1:methods
    for prov = 1:total_provider
        temp = CalcPerf(req_tp,regenerate_tp(:,prov,m));
        dist_reg_tp(prov,m)=temp.NRMSE;
        
        temp = CalcPerf(req_ir,regenerate_ir(:,prov,m));
        dist_reg_ir(prov,m)=temp.NRMSE;
        
        temp = CalcPerf(req_rr,regenerate_rr(:,prov,m));
        dist_reg_rr(prov,m)=temp.NRMSE;        
    end
end

dist_reg = dist_reg_tp+dist_reg_ir+dist_reg_rr;
[score, rank]=sort(mean(dist_reg,2));

dist_cop_tp = zeros(total_provider,1);
dist_cop_ir=dist_cop_tp;
dist_cop_rr=dist_cop_tp;

    for prov = 1:total_provider
        temp = CalcPerf(req_tp,pred_tp(:,prov));
        dist_cop_tp(prov)=temp.NRMSE;
        
        temp = CalcPerf(req_ir,pred_ir(:,prov));
        dist_cop_ir(prov)=temp.NRMSE;
        
        temp = CalcPerf(req_rr,pred_rr(:,prov));
        dist_cop_rr(prov)=temp.NRMSE;        
    end


dist_cop = dist_cop_tp+dist_cop_ir+dist_cop_rr;
[score_cop, cop_rank]=sort(dist_cop);


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


Ranks = [original_rank,cop_rank, rank, trial_rank,ad_rank]
% figure;
% bar([original_rank,trial_rank]);

