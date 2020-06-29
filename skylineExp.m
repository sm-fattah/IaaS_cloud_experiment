load('./Data/advertisements.mat');
time = 3; %number of time stamps

[no_QoS,no_provider] = size(advertisements);

no_QoS = no_QoS/time;

no_QoS = 7;
len = no_provider;

providers = 1:len;

start = 4;
sky_results = zeros(no_provider-start,1);
temp_results = zeros(no_provider-start,1);
for k=start:len
   %increasing the number of providers
    skylines = 1:k;
    dominant_QoS = 4;
    for i=1:k
        %testing providers[i]    
        for j=1:k
           if(i~=j)
            if(dominates(providers(j),providers(i),advertisements,dominant_QoS,time)==true)
                skylines(i)=0;             
                break;
            end
           end
        end
    end
    sky_results(k-start+1) = k - sum(skylines==0);
end
%disp(skylines)
%disp(sky_results)
%createfigureSKY(sky_results);


for k=start:len
   %increasing the number of providers
    skylines = 1:k;
    dominant_QoS = 2;
    for i=1:k
        %testing providers[i]    
        for j=1:k
           if(i~=j)
            if(dominates(providers(j),providers(i),advertisements,dominant_QoS,time)==true)
                skylines(i)=0;             
                break;
            end
           end
        end
    end
    temp_results(k-start+1) = k - sum(skylines==0);
end

figure('Name','Skyline Providers')
plot(sky_results,'--');
hold on;
plot(temp_results,'-');
xlim([4 60]);
ylim([1 50]);
ylabel('Number of Providers in the Skyline');

% Create xlabel
xlabel('Number of Providers');

legend({'Temporal IaaS Skyline without Dominant QoS','Temporal IaaS Skyline with Dominant QoS'},'Location','northwest')

ax = gca;
%ax.YAxis.Exponent = 4;
ax.FontSize = 16;

%createSky([sky_results,temp_results]);


