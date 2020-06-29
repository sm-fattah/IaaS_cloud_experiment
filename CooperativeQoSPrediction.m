% act_consumer = 25;
% actual_work = con_work(:,act_consumer);
% actual_tp = con_tp(:,:,act_consumer);
% actual_ir = con_ir(:,:,act_consumer);
% actual_rr = con_rr(:,:,act_consumer);
% figure;
% plot(actual_work);
% figure;
% for prov = 1:total_provider
%     plot(con_tp(:,prov,act_consumer));
%     hold on;
%     
% end

%generating trial workload
t_st=(trial_month-1)*each_month+1;
t_en=t_st-1+30;
t_work = actual_work(t_st:t_en);

t_tp=zeros(trial_period, total_provider);
t_ir=t_tp;
t_rr=t_tp;

%generate QoS for trial workload

for t = 1:trial_period
    
    index = find(actual_work==t_work(t));
    
    for prov = 1:total_provider
%         t_tp(t,prov) = mean(actual_tp(index,prov));
%         t_ir(t,prov) = mean(actual_ir(index,prov));
%         t_rr(t,prov) = mean(actual_rr(index,prov));       
        t_tp(t,prov) = getTP(t*trial_month*each_month,prov,t_work(t),tp);
         % the time calculation t*trial_momnth*each_month is wrong it should
        % be plus. please change it before reusing.
        t_ir(t,prov) = getIR(t*trial_month*each_month,prov,t_work(t),ir);
        t_rr(t,prov) = getRR(t*trial_month*each_month,prov,t_work(t),rr);
    end
             
end

% figure;
% plot(actual_tp(t_st:t_en,:));
% figure;
% plot(t_tp);

%generate cooperative prediction

%there are three seasons. for each season we will predict

%step one is finding similar users within each season
total_season = 3;
season_length = total_time/total_season;
con_sim = zeros(total_consumer,total_season);
for ssn=1:total_season
        st = (ssn-1)*season_length+1;
        en = st-1+season_length;

        for con=1:31
            
            distances = CalcPerf(actual_work(st:en),con_work(st:en,con));
            con_sim(con,ssn) = distances.RMSE;
        end
end
[sortedDistances, sortedCon] = sort(con_sim);
normDist = normalize(sortedDistances,'range');
%generating predictedQoS
topK= 3;
pred_tp = zeros(total_time,total_provider);
pred_ir = pred_tp;
pred_rr = pred_tp;
for ssn=1:total_season
    st = (ssn-1)*season_length+1;
    en = st-1+season_length;
    %select five consumer that have minimum distance
    selectedCon=sortedCon(2:topK+1,ssn);
    selectedDist = normDist(2:topK+1,ssn);
    selectedDist=1-selectedDist;

    for prov=1:total_provider
        
        sum_tp = 0;
        sum_ir = 0;
        sum_rr = 0;
        for sc=1:topK
            sum_tp = sum_tp+selectedDist(sc)*con_tp(st:en,prov,selectedCon(sc));
            sum_ir = sum_ir+selectedDist(sc)*con_ir(st:en,prov,selectedCon(sc));
            sum_rr = sum_rr+selectedDist(sc)*con_rr(st:en,prov,selectedCon(sc));
        end
        pred_tp(st:en,prov) = sum_tp/sum(selectedDist);
        pred_ir(st:en,prov) = sum_ir/sum(selectedDist);
        pred_rr(st:en,prov) = sum_rr/sum(selectedDist);
         
    end
    
    
%     for prov=1:total_provider
%         pred_tp(st:en,prov) = mean(con_tp(st:en,prov,selectedCon),3);
%         pred_ir(st:en,prov) = mean(con_ir(st:en,prov,selectedCon),3);
%         pred_rr(st:en,prov) = mean(con_rr(st:en,prov,selectedCon),3);   
%     end
    
 
    
end
% CalcPerf(actual_tp,pred_tp)

set(0,'DefaultFigureWindowStyle','docked')
% figure;
% plot(actual_work);
for prov=4:total_provider
    figure;
    plot(actual_tp(:,prov))
    hold on;
    plot(pred_tp(:,prov));
    legend({'Actual throughput','Predicted throughput'},'Location','northwest')
    xlabel('Time (day)') 
    ylabel('Throughput (op/s)') 
    ax = gca;
    ax.FontSize = 16;
    xlim([1 365])
    ylim([0 25000])
    break;
end



cop_accuracy_tp = zeros(total_provider,1);

    for prov = 1:total_provider
        temp = CalcPerf(actual_tp(:,prov),pred_tp(:,prov));
        cop_accuracy_tp(prov)=temp.NRMSE;
    end


cop_accuracy_ir = zeros(total_provider,1);

    for prov = 1:total_provider
        temp = CalcPerf(actual_ir(:,prov),pred_ir(:,prov));
        cop_accuracy_ir(prov)=temp.NRMSE;
    end


cop_accuracy_rr = zeros(total_provider,1);

    for prov = 1:total_provider
        temp = CalcPerf(actual_rr(:,prov),pred_rr(:,prov));
        cop_accuracy_rr(prov)=temp.NRMSE;
    end


figure;
bar([cop_accuracy_tp,cop_accuracy_ir,cop_accuracy_rr]);

legend({'Throughput','Insert Response Time','Read Response Time'},'Location','northwest')
xlabel('Providers') 
ylabel('Prediction Accuracy') 
ax = gca;
ax.FontSize = 16;
ylim([0 .7])
% figure;
% cop_accuracy=[mean(cop_accuracy_tp), mean(cop_accuracy_ir),mean(cop_accuracy_rr)];
% bar(cop_accuracy);



confidence = zeros(total_provider,3);
error_dist=zeros(total_provider,1);
trial_dist=zeros(total_provider,1);



for prov=1:total_provider
    errStruct=CalcPerf(actual_tp(:,prov),pred_tp(:,prov));
    error_dist(prov) = errStruct.NRMSE;
    %disp("prediction error " + error_dist.NRMSE)
    errStruct=CalcPerf(pred_tp(t_st:t_en,prov),t_tp(:,prov));
    trial_dist(prov)=errStruct.NRMSE;
    %disp("trial distance "+trial_dist.NRMSE)
end

[total_dist pred_rank] = sort(error_dist);
[trial_dist trial_rank]=sort(trial_dist);

disp(pred_rank);
disp(trial_rank);
disp(trial_dist);

set(0,'DefaultFigureWindowStyle','normal')
