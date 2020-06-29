
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
[score, rank]=sort(mean(dist_reg,2))

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
[original_score,original_rank] = sort(req_distance)