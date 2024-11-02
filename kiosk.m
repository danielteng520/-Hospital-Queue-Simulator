function kiosk()

    %Display Welcome Message/Introduction
    clc;
    disp( '        Welcome to @MMUFCI Hospital/Clinic Kiosk!        <-- ' );
    printf('\n');

    %Random Number Generator Setup
    printf('\n');
    printf('-->         Choice of Random Number Generator           <-- \n');
    printf('[1] Uniform Distribution Randomizer \n'); 
    printf('[2] Linear Congruential Generator \n');
    
    getRNG = input('Select an option: ');


    %Get number of customers from user input
    sum = 0;
    printf('\n');
    valid=0;     %To check for errors
    noCust=input('Please enter number of customer for simulation : ');
    while (valid==0)
        if(noCust<1)
            printf('\n');
            printf('Error! Number of customer for simulation cannot be less than 1. Please try again.\n');
            noCust=input('Please enter number of customer for simulation : ');
        else
            valid=1;
        end
    end
    
    %Limits number of customers allowed to use kiosk during to MCO/SOP
    printf('\n');
    printf('Due to Movement Control Order in Malaysia, there is a maximum limit for customer to use kiosk at a time.');
    maxCustPerTime = input('Please enter the maximum number of customer at a time for simulation: ');
    printf('Maximum number of customer at a time for simulation is %i .\n', [maxCustPerTime]);
    printf('\n');
    
    fprintf('-->     Total number of customers in Simulation: %d       <-- \n', noCust);


    switch(getRNG)
        case {1}
            mainTable();
            
            %Temperature check to see if customer can proceed entering the hospital

            temperature = UDR(noCust); 
            arrivalTimeRandomRange = UDR(noCust);
            serviceTimeRandomRange = UDR(noCust);
            
            simulationTable(temperature, arrivalTimeRandomRange, serviceTimeRandomRange, noCust, maxCustPerTime);
            
        case {2}
            mainTable();
            
            temperature = LCG(noCust);
            arrivalTimeRandomRange = LCG(noCust);
            serviceTimeRandomRange = LCG(noCust);
            
            simulationTable(temperature, arrivalTimeRandomRange, serviceTimeRandomRange, noCust, maxCustPerTime);
            
        otherwise
            printf('Invalid option\n');
            printf('\n');
            kiosk();
    end

end    

