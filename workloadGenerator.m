%https://alexpucher.com/blog/2015/07/13/visualizing-cloud-traces/

clear;
load('./Data/DS6trace.mat');

data = DS6trace;
%core_pernode = 32;
total_cpu = 0;
prevTime = 0;
len = size(data,1);
count = 0;
total_timestamps =size(unique(data(:,2)),1)-1;
result = zeros(total_timestamps,2);
resultIndex=1;
nodeNames = unique(data(:,4));
%the 4th column contains node name only start of a vm.
total_nodes = size(nodeNames,1)-1;
%Nodes = zeros(total_nodes,2);
%Nodes = {};
Nodes(:,1) = nodeNames(2:total_nodes+1);
timeIndex  = 2;
Nodes(:,timeIndex) = zeros(total_nodes,1);
for i = 1:len
    
    flag = data(i,1);
    currentTime=str2double(data(i,2));
    taskID = data(i,3);
    nodeName=data(i,4);    
    coreCount=str2double(data(i,5));
      
    
    if(currentTime>prevTime)       
        %create a new point on horizon
        result(resultIndex,:) = [prevTime total_cpu];
        resultIndex=resultIndex+1;
        timeIndex = timeIndex+1;
        Nodes(:,timeIndex) = Nodes(:,timeIndex-1);
    end
    if(flag=="START")
        total_cpu=total_cpu+coreCount;
        idx = find(strcmp(Nodes(:,1),nodeName));
        Nodes(idx,timeIndex) = str2double(Nodes(idx,timeIndex))+coreCount;
        %Nodes(idx,1)= Nodes(idx,1)+coreCount; 
        
    else
        startStop=find(strcmp(data(:,3), taskID));
        total_cpu=total_cpu - str2double( data(startStop(1),5));
        idx = find(strcmp(Nodes(:,1),data(startStop(1),4)));
        Nodes(idx,timeIndex)= str2double(Nodes(idx,timeIndex))-str2double( data(startStop(1),5)); 
       
        
    end
    prevTime = currentTime;
end
result(resultIndex,:)=[prevTime total_cpu];
perNode = str2double(Nodes(:,2:size(Nodes,2)));

%result = normalize(result,'range');
%result = downsample(result,18);
result = normalize(result,'range');
figure
plot(result(:, 1),result(:, 2))


% 
% figure
% plot(result(:,1),perNode(1,:));
%hold on;
%plot(result(:,1),perNode(2,:));

% figure;
% for i=1:total_nodes
%     plot(result(:,1),perNode(i,:));
%     hold on;
%     break;
% end
% con_work=perNode;

result = normalize(result,'range');
%con_work=reshape(result(1:6480,2),[360,18]);
con_work=perNode;
set(0,'DefaultFigureWindowStyle','docked')
for i=1:10
    figure;
    plot(con_work(i,:));
    %hold on;
    %break;
end
set(0,'DefaultFigureWindowStyle','normal')





