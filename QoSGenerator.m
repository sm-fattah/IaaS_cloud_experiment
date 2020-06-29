clear
load('./Data/ycsb.mat');
%load('./Data/consumer_workloads.mat');
total_points = 360;
number_of_workloads = 32;

% con_work=consumer_workloads(:,1:total_points);
% con_work = con_work';

QoS = str2double(ycsb(:,3:5));
TP=QoS(:,1);
IR=QoS(:,2);
RR=QoS(:,3);
sortedTP = sort(TP,'descend');
sortedIR = sort(IR,'descend');
sortedRR = sort(RR,'descend');
% sortedWork = sort(con_work);
% figure
% plot(sortedTP);
% figure
% plot(sortedWork)

lenW = size(QoS,1)./number_of_workloads;
tp = downsample(sortedTP,lenW-1);
ir = downsample(sortedIR,lenW-1);
rr = downsample(sortedRR,lenW-1);
set(0,'DefaultFigureWindowStyle','docked')
figure;
plot(tp);
figure; plot(ir); figure; plot(rr);
set(0,'DefaultFigureWindowStyle','normal')
