function output = LCG(noCust)
    
    x(1) = rand(1,100) * 100;  
    while ((x(1)<35) | (x(1)>39)) 
        x(1) = rand(1,100) * 100;
    end
    a = randi(1,100);
    c = randi(1,100);
    m = randi(1,100);
    i = 2;
    while i <= noCust       
        y = mod(((a*x(i-1))+c),m); 
        while ((y<35) | (y>39)) 
            a = randi(1,100);
            c = randi(1,100);
            m = randi(1,100);            
            y = mod(((a*x(i-1))+c),m); 
        end  
    x(i) = y;
    i = i + 1;
    end
    

output = x;