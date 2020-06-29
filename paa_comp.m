function comp_data = paa_comp(data,s_rate)
    
    s_size = ceil(length(data)/s_rate);
%     sum_data = reshape(data,s_rate,s_size);
%     comp_data = mean(sum_data);   
    data_size = length(data);
    comp_data = zeros(s_size,1);
    sum=0;
    count = 0;
    j=1;
    for i=1:data_size
        sum = sum+data(i);
        count=count+1;
        if(count == s_rate)
            comp_data(j)=ceil(sum/count);
            sum = 0;
            j=j+1;
            count = 0;
        
        elseif(i==data_size)
            comp_data(j)=ceil(sum/count);
            
        end
    end
    
end