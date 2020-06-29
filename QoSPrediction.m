
%run DataGeneration file first.

%defining active consumer
% trial_period = 30;
% total_season = 3;
% 
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

% act_consumer = 1;
% actual_work = con_work(:,act_consumer);
% actual_tp = con_tp(:,:,act_consumer);
% actual_ir = con_ir(:,:,act_consumer);
% actual_rr = con_rr(:,:,act_consumer);

%generating trial workload


sample_rate = total_time/trial_period;

methods = 3;
trial_workload = zeros(trial_period,methods);
trial_tp = zeros(trial_period, total_provider, methods);
trial_ir = trial_tp;
trial_rr = trial_tp;

%method 1 PUS
current_method = 1;

trial_workload(:,current_method) = downsample(actual_work,sample_rate);

%generating QoS for method 1

for t = 1:trial_period
    
    index = find(actual_work==trial_workload(t,current_method));
    
    for prov = 1:total_provider
%         trial_tp(t,prov,current_method) = mean(actual_tp(index,prov));
%         trial_ir(t,prov,current_method) = mean(actual_ir(index,prov));
%         trial_rr(t,prov,current_method) = mean(actual_rr(index,prov));

       
        trial_tp(t,prov,current_method) = getTP(t*trial_month*each_month,prov,trial_workload(t,current_method),tp);
        % the time calculation t*trial_momnth*each_month is wrong it should
        % be plus. please change it before reusing.
        trial_ir(t,prov,current_method) = getIR(t*trial_month*each_month,prov,trial_workload(t,current_method),ir);
        trial_rr(t,prov,current_method) = getRR(t*trial_month*each_month,prov,trial_workload(t,current_method),rr);
       
    end
             
end
% figure;
% plot(actual_tp(:,1));
% figure;
% plot(trial_tp(:,1,current_method));

extrap_method='linear';
regenerate_tp = zeros(total_time,total_provider,methods);
regenerate_ir = regenerate_tp;
regenerate_rr = regenerate_tp;

projection_index = 1:sample_rate:total_time;

for prov = 1:total_provider
    regenerate_tp(:,prov,current_method)= interp1(projection_index,trial_tp(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_ir(:,prov,current_method)= interp1(projection_index,trial_ir(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_rr(:,prov,current_method)= interp1(projection_index,trial_rr(:,prov,current_method),1:total_time,extrap_method,'extrap');



end

% for prov = 1:total_provider
%     figure;
%     plot(actual_tp(:,prov));
%     hold on;
%     plot(regenerate_tp(:,prov,current_method));
%     
%     break;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%method 2 PAA
current_method = 2;

trial_workload(:,current_method) = paa_comp(actual_work,sample_rate);

%figure;plot(actual_work);figure; plot(trial_workload(:,1)); figure;plot(trial_workload(:,2));

%generating QoS for method 2

for t = 1:trial_period
    
    index = find(actual_work==trial_workload(t,current_method));
    
    isEmpty = length(index);
    if(isEmpty==0)
        [x , ix] = min(abs(actual_work-trial_workload(t,current_method)));
        index = find(actual_work==actual_work(ix));
    end
    
    for prov = 1:total_provider
%         trial_tp(t,prov,current_method) = mean(actual_tp(index,prov));
%         trial_ir(t,prov,current_method) = mean(actual_ir(index,prov));
%         trial_rr(t,prov,current_method) = mean(actual_rr(index,prov));
       
        trial_tp(t,prov,current_method) = getTP(t*trial_month*each_month,prov,trial_workload(t,current_method),tp);
        trial_ir(t,prov,current_method) = getIR(t*trial_month*each_month,prov,trial_workload(t,current_method),ir);
        trial_rr(t,prov,current_method) = getRR(t*trial_month*each_month,prov,trial_workload(t,current_method),rr);
        
    end
             
end
% figure;
% plot(actual_tp);
% figure;
% plot(trial_tp(:,:,current_method));

% extrap_method='linear';
% regenerate_tp = zeros(total_time,total_provider,methods);
% regenerate_ir = regenerate_tp;
% regenerate_rr = regenerate_tp;

projection_index = 1:sample_rate:total_time;

for prov = 1:total_provider
    regenerate_tp(:,prov,current_method)= interp1(projection_index,trial_tp(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_ir(:,prov,current_method)= interp1(projection_index,trial_ir(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_rr(:,prov,current_method)= interp1(projection_index,trial_rr(:,prov,current_method),1:total_time,extrap_method,'extrap');

end

% for prov = 1:total_provider
%     figure;
%     plot(actual_tp(:,prov));
%     hold on;
%     plot(regenerate_tp(:,prov,current_method));
%     
%     break;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%

%method 3 RS
current_method = 3;
random_index=randperm(total_time,trial_period);
trial_workload(:,current_method) = actual_work(random_index);

%figure;plot(actual_work);figure; plot(trial_workload(:,1)); figure;plot(trial_workload(:,2));

%generating QoS for method 3

for t = 1:trial_period
    
    index = find(actual_work==trial_workload(t,current_method));
    
%     isEmpty = length(index);
%     if(isEmpty==0)
%         [x , ix] = min(abs(actual_work-trial_workload(t,current_method)));
%         index = find(actual_work==actual_work(ix));
%     end
    
    for prov = 1:total_provider
%         trial_tp(t,prov,current_method) = mean(actual_tp(index,prov));
%         trial_ir(t,prov,current_method) = mean(actual_ir(index,prov));
%         trial_rr(t,prov,current_method) = mean(actual_rr(index,prov));
        trial_tp(t,prov,current_method) = getTP(t*trial_month*each_month,prov,trial_workload(t,current_method),tp);
        trial_ir(t,prov,current_method) = getIR(t*trial_month*each_month,prov,trial_workload(t,current_method),ir);
        trial_rr(t,prov,current_method) = getRR(t*trial_month*each_month,prov,trial_workload(t,current_method),rr);
        
       
    end
             
end
% figure;
% plot(actual_tp);
% figure;
% plot(trial_tp(:,:,current_method));

% extrap_method='linear';
% regenerate_tp = zeros(total_time,total_provider,methods);
% regenerate_ir = regenerate_tp;
% regenerate_rr = regenerate_tp;

projection_index = random_index;

for prov = 1:total_provider
    regenerate_tp(:,prov,current_method)= interp1(projection_index,trial_tp(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_ir(:,prov,current_method)= interp1(projection_index,trial_ir(:,prov,current_method),1:total_time,extrap_method,'extrap');
    regenerate_rr(:,prov,current_method)= interp1(projection_index,trial_rr(:,prov,current_method),1:total_time,extrap_method,'extrap');

end

set(0,'DefaultFigureWindowStyle','docked')
figure;
plot(actual_work);
xlabel('Time (day)') 
ylabel('CPU utilization (no. of cores)') 
xlim([1 365])
ylim([0 35])
ax = gca;
ax.FontSize = 16;

for prov = 4:total_provider
    figure;
    plot(actual_tp(:,prov));
    for meth = 1:methods
        hold on;
        plot(regenerate_tp(:,prov,meth));
        %break;
    end
    legend({'Actual throughput','Predicted (PUS)','Predicted (PAA)','Predicted (RS)'},'Location','northwest')
    xlabel('Time (day)') 
    ylabel('Throughput (op/s)') 
    ax = gca;
    ax.FontSize = 16;
    xlim([1 365])
    ylim([0 25000])
   break;
end


pred_accuracy_tp = zeros(total_provider,methods);
for m=1:methods
    for prov = 1:total_provider
        temp = CalcPerf(actual_tp(:,prov),regenerate_tp(:,prov,m));
        pred_accuracy_tp(prov,m)=temp.NRMSE;
    end
end

pred_accuracy_ir = zeros(total_provider,methods);
for m=1:methods
    for prov = 1:total_provider
        temp = CalcPerf(actual_ir(:,prov),regenerate_ir(:,prov,m));
        pred_accuracy_ir(prov,m)=temp.NRMSE;
    end
end

pred_accuracy_rr = zeros(total_provider,methods);
for m=1:methods
    for prov = 1:total_provider
        temp = CalcPerf(actual_rr(:,prov),regenerate_rr(:,prov,m));
        pred_accuracy_rr(prov,m)=temp.NRMSE;
    end
end

figure;
bar(pred_accuracy_tp);
legend({'PUS','PAA','RS'},'Location','northeast')
xlabel('Providers') 
ylabel('NRMSE') 
ax = gca;
ax.FontSize = 20;
%xlim([1 365])
ylim([0 .7])

figure;
c = categorical({'PUS','PAA','RS'});
pred_accuracy=[mean(pred_accuracy_tp); mean(pred_accuracy_ir);mean(pred_accuracy_rr)];
bar(c,pred_accuracy);
legend({'Throughput','Insert Response Time','Random Selection'},'Location','northeast')
xlabel('Compression Techniques') 
ylabel('Mean NRMSE') 
ax = gca;
ax.FontSize = 20;
ylim([0 .7])
set(0,'DefaultFigureWindowStyle','normal')



