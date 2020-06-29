function test = dominates(p1,p,advertisements,dominant_QoS,time)
    test = false;
    [no_QoS,no_provider] = size(advertisements);
    no_QoS = no_QoS/time;
    
    provider_p1 = zeros(time,no_QoS);
    provider_p = zeros(time,no_QoS);
    for q=1:no_QoS
        st = (q-1)*time+1;
        en = q*time;
%         disp(st);
%         disp(en);
        provider_p1(:,q)=advertisements(st:en,p1);
        provider_p(:,q)=advertisements(st:en,p);               
    end
    
%     p1_price = advertisements(1:3,p1);
%     p1_av = advertisements(4:6,p1);
%     p_price = advertisements(1:3,p);
%     p_av = advertisements(4:6,p);
%     whether dominated interms of price
    count = 0;
    for t=1:time
%         if(p1_price(t)>=p_price(t) && p1_av(t)>=p1_av(t))
%             if(p1_price(t)>p_price(t) || p1_av(t)>p_av(t))
%                 count=count+1;
%             end
%         end
        flag = false;
        for q=1:dominant_QoS
            if(provider_p1(t,q)>=provider_p(t,q))
                flag = true;
            else
                flag = false;
                break;
            end
            
        end
        if(flag == true)
           flag = false;
           for q=1:dominant_QoS
                if(provider_p1(t,q)>provider_p(t,q))
                    flag = true;
                    break;
                end
           end
            if(flag==true)
                count=count+1;
            end
        end    
     end
    if(count==time)
        test = true;
    end
    

end