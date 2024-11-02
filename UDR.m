function output = UDR(noCust)
    
    i = 1;
    while i <= noCust   
    R = rand;
    a = 35;
    b = 39;
    x(i) = a + (b-a)*R;
        while ((x(i)<35) | (x(i)>39))
            R = rand;
            x(i) = a + (b-a)*R;                                 
        end  
    i = i + 1;
    
    end

output = x;