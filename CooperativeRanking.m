
%distance for regenerated QoS accuracy
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
[score_cop, cop_rank]=sort(dist_cop)

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