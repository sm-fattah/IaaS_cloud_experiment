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