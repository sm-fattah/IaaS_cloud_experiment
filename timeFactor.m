function tf = timeFactor(t,p)
    temporalInfo=[1.10,1.30,0.90;
            0.80,1.50,0.90;
            1.30,1.0,0.95;
            1.80,0.55,0.99;
            1.10,1.35,0.60;];
        
    
    if t>=1 && t<=120
        tf = temporalInfo(p,1);
    elseif t>=121 && t<=240
            tf = temporalInfo(p,2);
    else
            tf = temporalInfo(p,2);
    end
end