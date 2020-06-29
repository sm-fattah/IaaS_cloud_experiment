function wf = workloadFactor(w,p)
    workInfo=[1.0,1.0,0.90,0.99;
            1.20,1.8,0.9,0.70;
            1.30,1.2,0.99,0.80;
            1,1.6,0.98,0.75;
            1.10,1.35,0.60,0.50;];
        
%     if w>=0 && w<=8
%         wf = workInfo(p,1);
%     elseif  w>=9 && w<=16
%         wf = workInfo(p,2);
%     elseif  w>=17 && w<=24
%         wf = workInfo(p,3);
%     else
%         wf = workInfo(p,4);
%     end
        
    if w>0 && w<=.25
        wf = workInfo(p,1);
    elseif  w>.25 && w<=.5
        wf = workInfo(p,2);
    elseif  w>.5 && w<=.75
        wf = workInfo(p,3);
    else
        wf = workInfo(p,4);
    end

end