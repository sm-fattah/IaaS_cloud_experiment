clear;
load('./Data/consumer_workloads.mat');
%QoS values are generated from QoSGenerator
%time and workload factor are considered have equal impact on all QoS
%paramters. The function getTP,getIR, and getRR applies the same workload
%and time factor for each QoS parameter.
load('./Data/QoS.mat');
tp = sort(tp,'descend');
ir = sort(ir,'descend');
rr = sort(rr, 'descend');
total_provider = 5;
total_consumer = 31;
total_time = 360;
%total_time = size(consumer_workloads,2);

con_work=[];
for i=1:31
    con_work(i,:) = paa_comp(consumer_workloads(i,:),18);
end
con_work = con_work(:,1:360);
%con_work = consumer_workloads(:,1:360);

con_work = con_work';
con_tp = zeros(total_time,total_provider,total_consumer);
con_ir = con_tp;
con_rr = con_ir;

for con=1:total_consumer
    
    for time = 1:total_time
        
        for prov = 1:total_provider
            
            con_tp(time,prov,con)=getTP(time,prov,con_work(time,con),tp);
            con_ir(time,prov,con)=getIR(time,prov,con_work(time,con),ir);
            con_rr(time,prov,con)=getRR(time,prov,con_work(time,con),rr);

        end
    end
end
trial_period = 30;
total_season = 3;
each_month = 30;
trial_month=4;
%defining active consumer
act_consumer = 10;
actual_work = con_work(:,act_consumer);
actual_tp = con_tp(:,:,act_consumer);
actual_ir = con_ir(:,:,act_consumer);
actual_rr = con_rr(:,:,act_consumer);


selectedProvider = 5;
req_tp = actual_tp(:,selectedProvider);
req_ir = actual_ir(:,selectedProvider);
req_rr= actual_rr(:,selectedProvider);

set(0,'DefaultFigureWindowStyle','docked')
figure;
plot(actual_work);

for prov = 1:total_provider
    figure;
    plot(con_tp(:,prov,act_consumer));
    ylim([0 25000]);
    %hold on;
    %break;
end
set(0,'DefaultFigureWindowStyle','normal')