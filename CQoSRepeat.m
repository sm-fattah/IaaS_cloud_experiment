%this file is for repeating the Cooperative QoS prediction for variable
%number of segmentation of period.



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

seasons = [1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 30, 36, 40, 45, 60, 72, 90, 120, 180, 360];

error_dist = zeros(length(seasons),1);

for ss = 1:length(seasons)
    total_season = seasons(ss);
    %total_season = 3;
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
%     for prov=1:5
%         dist = CalcPerf(actual_tp(:,prov),pred_tp(:,prov));
%         accuracy(ss,prov)= dist.NRMSE;
%     end
      dist=CalcPerf(actual_tp(:,prov),pred_tp(:,prov));
      error_dist(ss)=dist.NRMSE;

end

% set(0,'DefaultFigureWindowStyle','docked')
% for prov=1:total_provider
%     figure;
%     plot(actual_tp(:,prov))
%     hold on;
%     plot(pred_tp(:,prov));
%     break;
% end
set(0,'DefaultFigureWindowStyle','docked')
figure;
plot(seasons,error_dist);
xlabel('Number of Seasons') 
ylabel('Prediction Accuracy') 
ax = gca;
ax.FontSize = 16;
set(0,'DefaultFigureWindowStyle','normal')

