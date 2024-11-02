function simulationTable(temperature, arrivalTimeRandomRange, serviceTimeRandomRange, noCust, maxCustPerTime)
    
    %Interarrival Time
    for(i=1: noCust-1)
        if (arrivalTimeRandomRange(i) >= 1 & arrivalTimeRandomRange(i) <=18)
            interarrivalTime(i) = 1;
        elseif (arrivalTimeRandomRange(i) >= 19 & arrivalTimeRandomRange(i) <=50)
            interarrivalTime(i) = 2;
        elseif (arrivalTimeRandomRange(i) >= 51 & arrivalTimeRandomRange(i) <=70)
            interarrivalTime(i) = 3;
        elseif (arrivalTimeRandomRange(i) >= 71 & arrivalTimeRandomRange(i) <=95)
            interarrivalTime(i) = 4;
        elseif (arrivalTimeRandomRange(i) >= 96 & arrivalTimeRandomRange(i) <=100)
            interarrivalTime(i) = 5;
        end
    end
    
    %Service Time Counter 1
    for(i=1: noCust) 
        if (serviceTimeRandomRange(i) >= 1 & serviceTimeRandomRange(i) <=14)
            serviceTime1(i) = 1;
        elseif (serviceTimeRandomRange(i) >= 15 & serviceTimeRandomRange(i) <=30)
            serviceTime1(i) = 2;
        elseif (serviceTimeRandomRange(i) >= 31 & serviceTimeRandomRange(i) <=66)
            serviceTime1(i) = 3;
        elseif (serviceTimeRandomRange(i) >= 67 & serviceTimeRandomRange(i) <=86)
            serviceTime1(i) = 4;
        elseif (serviceTimeRandomRange(i) >= 87 & serviceTimeRandomRange(i) <=100)
            serviceTime1(i) = 5;
        end
    end
    
    %Service Time Counter 2
    for(i=1: noCust)
        if (serviceTimeRandomRange(i) >= 1 & serviceTimeRandomRange(i) <=20)
            serviceTime2(i) = 2;
        elseif (serviceTimeRandomRange(i) >= 21 & serviceTimeRandomRange(i) <=45)
            serviceTime2(i) = 3;
        elseif (serviceTimeRandomRange(i) >= 46 & serviceTimeRandomRange(i) <=63)
            serviceTime2(i) = 4;
        elseif (serviceTimeRandomRange(i) >= 64 & serviceTimeRandomRange(i) <=85)
            serviceTime2(i) = 5;
        elseif (serviceTimeRandomRange(i) >= 86 & serviceTimeRandomRange(i) <=100)
            serviceTime2(i) = 6;
        end
    end
    
    %MAIN CALCULATION
    arrivalTime = 0;
    noOfCustomer = 0;
    timeEnteringHospital = 0;
    counter1ServiceBegin = 0;
    counter1ServiceEnd = 0;
    counter2ServiceBegin = 0;
    counter2ServiceEnd = 0;
    serviceEnd = 0; 
    waitingTime = 0;
    timeSpent = 0;
    customerNo = 0; 
    serviceBegin = 0;
    counter1Use = 0;
    sumCounter1Service = 0;
    sumCounter2Service = 0;
    sumCounter1ServiceTime = 0;
    sumCounter2ServiceTime = 0;
    
    for(i=1: noCust)
        %First customer
        if(i == 1)
            %First customer that can enter MMU Hospital without exceeding temperature limit
            if (temperature(i) <= 37.5)
                arrivalTime(i) = 0;
                noOfCustomer(i) = 0;
                timeEnteringHospital(i) = 0;
                counter1ServiceBegin(i) = 0;
                counter1ServiceEnd(i) = counter1ServiceBegin(i) + serviceTime1(i);
                counter2ServiceBegin(i) = 0;
                counter2ServiceEnd(i) = 0;
                serviceEnd(i) = counter1ServiceEnd(i);
                serviceBegin(i) = counter1ServiceBegin(i);
                serviceTime(i) = serviceTime1(i); 
                sumCounter1Service = sumCounter1Service + 1;
                sumCounter1ServiceTime = sumCounter1ServiceTime + serviceTime1(i);
                waitingTime(i) = 0;
                timeSpent(i) = counter1ServiceEnd(i) + counter2ServiceEnd(i) - arrivalTime(i);
                counter1Use(i) = 1;
                counter2Use(i) = 0;
            else
                %First customer that cannot enter MMU Hospital because they exceed temperature limit check    
                arrivalTime(i) = 0;
                noOfCustomer(i) = 0;
                timeEnteringHospital(i) = 0;
                counter1ServiceBegin(i) = 0;
                counter1ServiceEnd(i) = 0;
                counter2ServiceBegin(i) = 0;
                counter2ServiceEnd(i) = 0;
                serviceEnd(i) = counter1ServiceEnd(i);
                serviceTime(i) = serviceTime2(i); 
                waitingTime = 0;
                timeSpent = 0;
                counter1Use(i) = 0;
                counter2Use(i) = 1;
            end
            %End of calculation for first customer
        else
            arrivalTime(i) = arrivalTime(i-1) + interarrivalTime(i-1);
            %Find amount of customer in shop to determine if customer can enter
            noOfCustomer(i) = 0;
            for(j =1: length(serviceEnd))
                if (arrivalTime(i) < serviceEnd(j))
                    noOfCustomer(i) = noOfCustomer(i) + 1;
                else
                    continue
                end
            end        
            
            
            %Calculations for customer that are not allowed to proceed for exceeding temperature check
            if (temperature(i) >= 37.5)
                timeEnteringHospital(i) = 0;
                counter1ServiceBegin(i) =  counter1ServiceBegin(i-1);
                counter1ServiceEnd(i) = counter1ServiceEnd(i-1);
                counter2ServiceBegin(i) = counter2ServiceBegin(i-1);
                counter2ServiceEnd(i) = counter2ServiceEnd(i-1);
                serviceEnd(i) = 0;
                serviceTime(i) = 0;
                waitingTime(i) = 0;
                timeSpent(i) = 0;
                
                %Customer not allowed to enter, delay entry time to last counter service end
            elseif(noOfCustomer(i) >= maxCustPerTime)
                for(k=1:length(serviceEnd))
                    if(arrivalTime(i) - serviceEnd(k) <0)
                        timeEnteringHospital(i) = serviceEnd(k);
                        break;                        
                    end
                end
                
                counter1Check = counter1ServiceEnd(i-1) - arrivalTime(i);  
                counter2Check = counter2ServiceEnd(i-1) - arrivalTime(i);
                
                %Counter 1 waiting time smaller than counter 2
                if(counter1Check < counter2Check) 
                    counter1Use(i) = 1; 
                    counter2Use(i) = 0;
                    if (timeEnteringHospital(i) < counter1ServiceEnd(i-1))
                        counter1ServiceBegin(i) = counter1ServiceEnd(i-1);
                    else
                        counter1ServiceBegin(i) = timeEnteringHospital(i);
                    end
                    counter1ServiceEnd(i) = counter1ServiceBegin(i) + serviceTime1(i);
                    counter2ServiceBegin(i) = counter2ServiceBegin(i-1);  %save last counter data
                    counter2ServiceEnd(i) = counter2ServiceEnd(i-1);     %save last counter data
                    serviceEnd(i) = counter1ServiceEnd(i);
                    serviceTime(i) = serviceTime1(i);
                    sumCounter1Service = sumCounter1Service + 1;
                    sumCounter1ServiceTime = sumCounter1ServiceTime + serviceTime1(i);
                    waitingTime(i) =abs(arrivalTime(i) - counter1ServiceBegin(i));
                    timeSpent(i) = counter1ServiceEnd(i)- arrivalTime(i);
                    
                    %Counter 2 waiting time smaller than counter 1
                else
                    %Counter 1 has finished service
                    if (timeEnteringHospital(i) - counter1ServiceEnd(i-1) >= 0)
                        %Counter 1
                        counter1Use(i) = 1; 
                        counter2Use(i) = 0;
                        if (timeEnteringHospital(i) < counter1ServiceEnd(i-1))
                            counter1ServiceBegin(i) = counter1ServiceEnd(i-1);
                        else
                            counter1ServiceBegin(i) = timeEnteringHospital(i);
                        end
                        counter1ServiceEnd(i) = counter1ServiceBegin(i) + serviceTime1(i);
                        counter2ServiceBegin(i) = counter2ServiceBegin(i-1);  %save last counter data
                        counter2ServiceEnd(i) = counter2ServiceEnd(i-1);     %save last counter data
                        serviceEnd(i) = counter1ServiceEnd(i);
                        serviceTime(i) = serviceTime1(i);
                        sumCounter1Service = sumCounter1Service + 1;
                        sumCounter1ServiceTime = sumCounter1ServiceTime + serviceTime1(i);
                        waitingTime(i) =abs(arrivalTime(i) - counter1ServiceBegin(i));
                        timeSpent(i) = counter1ServiceEnd(i)- arrivalTime(i);
                        
                        
                        %Counter 1 is busy 
                    else 
                        counter1Use(i) = 0;
                        counter2Use(i) = 1;
                        
                        if (timeEnteringHospital(i) < counter2ServiceEnd(i-1))
                            counter2ServiceBegin(i) = counter2ServiceEnd(i-1);
                        else
                            counter2ServiceBegin(i) = timeEnteringHospital(i);
                        end
                        counter1ServiceBegin(i) = counter1ServiceBegin(i-1);
                        counter1ServiceEnd(i) = counter1ServiceEnd(i-1);
                        counter2ServiceEnd(i) = counter2ServiceBegin(i) + serviceTime2(i);
                        serviceEnd(i) = counter2ServiceEnd(i);
                        serviceTime(i) = serviceTime2(i);
                        sumCounter2Service = sumCounter2Service + 1;
                        sumCounter2ServiceTime = sumCounter2ServiceTime + serviceTime2(i);
                        waitingTime(i) =abs(arrivalTime(i) - counter2ServiceBegin(i));
                        timeSpent(i) = counter2ServiceEnd(i)- arrivalTime(i);
                        
                    end
                end
                
                %Customer allowed to enter, delay begin service time to last service end time
            elseif (temperature(i) < 37.5 & noOfCustomer(i) <= maxCustPerTime)
                timeEnteringHospital(i) = arrivalTime(i);
                counter1Check = counter1ServiceEnd(i-1) - arrivalTime(i);  
                counter2Check = counter2ServiceEnd(i-1) - arrivalTime(i);
                
                %Counter 1 waiting time less than counter 2.    
                if(counter1Check < counter2Check) 
                    counter1Use(i) = 1; 
                    counter2Use(i) = 0;
                    if (timeEnteringHospital(i) < counter1ServiceEnd(i-1))
                        counter1ServiceBegin(i) = counter1ServiceEnd(i-1);
                    else
                        counter1ServiceBegin(i) = timeEnteringHospital(i);
                    end
                    counter1ServiceEnd(i) = counter1ServiceBegin(i) + serviceTime1(i);
                    counter2ServiceBegin(i) = counter2ServiceBegin(i-1);  %save last counter data
                    counter2ServiceEnd(i) = counter2ServiceEnd(i-1);     %save last counter data
                    serviceEnd(i) = counter1ServiceEnd(i);
                    serviceTime(i) = serviceTime1(i);
                    sumCounter1Service = sumCounter1Service + 1;
                    sumCounter1ServiceTime = sumCounter1ServiceTime + serviceTime1(i);
                    waitingTime(i) =abs(arrivalTime(i) - counter1ServiceBegin(i));
                    timeSpent(i) = counter1ServiceEnd(i)- arrivalTime(i);
                    
                    %Counter 2 waiting time less than counter 1.
                else
                    %Counter 1 has finished servicing.
                    if (timeEnteringHospital(i) - counter1ServiceEnd(i-1) >= 0)                        
                        counter1Use(i) = 1; 
                        counter2Use(i) = 0;
                        if (timeEnteringHospital(i) <= counter1ServiceEnd(i-1))
                            counter1ServiceBegin(i) = counter1ServiceEnd(i-1);
                        else
                            counter1ServiceBegin(i) = timeEnteringHospital(i);
                        end
                        counter1ServiceEnd(i) = counter1ServiceBegin(i) + serviceTime1(i);
                        counter2ServiceBegin(i) = counter2ServiceBegin(i-1);  %save last counter data
                        counter2ServiceEnd(i) = counter2ServiceEnd(i-1);     %save last counter data
                        serviceEnd(i) = counter1ServiceEnd(i);
                        serviceTime(i) = serviceTime1(i);
                        sumCounter1Service = sumCounter1Service + 1;
                        sumCounter1ServiceTime = sumCounter1ServiceTime + serviceTime1(i);                        
                        waitingTime(i) =abs(arrivalTime(i) - counter1ServiceBegin(i));
                        timeSpent(i) = counter1ServiceEnd(i)- arrivalTime(i);
                        
                        %Counter 1 is busy.   
                    else 
                        counter1Use(i) = 0;
                        counter2Use(i) = 1;
                        
                        if (timeEnteringHospital(i) < counter2ServiceEnd(i-1))
                            counter2ServiceBegin(i) = counter2ServiceEnd(i-1);
                        else
                            counter2ServiceBegin(i) = timeEnteringHospital(i);
                        end
                        counter1ServiceBegin(i) = counter1ServiceBegin(i-1);
                        counter1ServiceEnd(i) = counter1ServiceEnd(i-1);
                        counter2ServiceEnd(i) = counter2ServiceBegin(i) + serviceTime2(i);
                        serviceEnd(i) = counter2ServiceEnd(i);
                        serviceTime(i) = serviceTime2(i);
                        sumCounter2Service = sumCounter2Service + 1;
                        sumCounter2ServiceTime = sumCounter2ServiceTime + serviceTime2(i);
                        waitingTime(i) =abs(arrivalTime(i) - counter2ServiceBegin(i));
                        timeSpent(i) = counter2ServiceEnd(i)- arrivalTime(i);
                        
                    end
                end                                                                                         
                
            end
        end
    end
    
    disp('=============================================================================');
    disp('| Customer no | Arrival Time | Time Enter Clinic | Departure Time | Counter |');
    disp('=============================================================================');
    customerNo = 0;
    for(i=1: noCust)
        if(i == 1)
            %First customer with low temperature and proceedable
            if (temperature(i) < 37.5)
                customerNo = customerNo + 1;
                printf('|%13.0f|%14.0f|%19.0f|%16.0f|%9.0f|\n',customerNo, arrivalTime(i), timeEnteringHospital(i), counter1ServiceEnd(i) , 1);
                disp('=============================================================================');
                %First customer with high temperature
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%13.0f|%14.0f|%19s|%16s|%9s|\n',customerNo, arrivalTime(i), '-', '-' , '-');
                disp('=============================================================================');
            end
        else
            %First customer with low temperature and proceedable
            if (temperature(i) < 37.5)
                if(counter1Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('|%13.0f|%14.0f|%19.0f|%16.0f|%9.0f|\n',customerNo, arrivalTime(i), timeEnteringHospital(i), counter1ServiceEnd(i) , 1);
                    disp('=============================================================================');
                elseif(counter2Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('|%13.0f|%14.0f|%19.0f|%16.0f|%9.0f|\n',customerNo, arrivalTime(i), timeEnteringHospital(i), counter2ServiceEnd(i) , 2);
                    disp('=============================================================================');
                end
                %First customer with high temperature
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%13.0f|%14.0f|%19s|%16s|%9s|\n',customerNo, arrivalTime(i), '-', '-' , '-');
                disp('=============================================================================');
            end
        end
    end
    
    %SHOW RESULT OF SIMULATION
    printf('\n');
    printf('-->                                             Simulation Table                                                            <-- \n');
    
    disp('====================================================================================================================================');
    disp('|Customer no | Temperature | Random Number inter-arrival time | Inter-arrival time | Arrival Time | Customer in clinic | Time enter|');
    disp('====================================================================================================================================');
    customerNo = 0;
    for(i=1:noCust)
        %First customer table arrangements
        if (i == 1)
            %If customer's temperature is higher than 37.5
            if (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%12.0f|%13.1f|%34s|%20s|%14.0f|%20s|%11s|\n', customerNo, temperature(i), '-', '-', arrivalTime(i), '-', '-');
                disp('====================================================================================================================================');
            else
                %If customer have normal temperature
                customerNo = customerNo + 1;
                printf('|%12.0f|%13.1f|%34s|%20s|%14.0f|%20.0f|%11.0f|\n', customerNo, temperature(i), '-', '-', arrivalTime(i), noOfCustomer(i), timeEnteringHospital(i));
                disp('====================================================================================================================================');
            end
            %Second and all customers afterwards table arrangements
        else
            if (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%12.0f|%13.1f|%34.0f|%20.0f|%14.0f|%20s|%11s|\n', customerNo, temperature(i), arrivalTimeRandomRange(i-1), interarrivalTime(i-1), arrivalTime(i), '-', '-');
                disp('====================================================================================================================================');
            else
                customerNo = customerNo + 1;
                printf('|%12.0f|%13.1f|%34.0f|%20.0f|%14.0f|%20.0f|%11.0f|\n', customerNo, temperature(i), arrivalTimeRandomRange(i-1), interarrivalTime(i-1), arrivalTime(i), noOfCustomer(i), timeEnteringHospital(i));
                disp('====================================================================================================================================');
            end
        end
    end    
    
    printf('\n');
    printf('\n');
    
    disp('=====================================================================================================================================================');
    disp('|Customer no | Random Number Service Time |               Counter 1              |               Counter 2              | Waiting time | Time Spent |');
    disp('|            |                            +--------------------------------------+--------------------------------------+              |            |');
    disp('|            |                            | Service time | Time Begin | Time End | Service time | Time Begin | Time End |              |            |');
    disp('=====================================================================================================================================================');
    customerNo = 0;
    for(i=1: noCust)
        if(i == 1)
            %First customer with low temperature and proceedable table arrangements
            if (temperature(i) < 37.5)
                customerNo = customerNo + 1;
                printf('|%12.0f|%28.0f|%14.0f|%12.0f|%10.0f|%14s|%12s|%10s|%14.0f|%12.0f|\n', customerNo, serviceTimeRandomRange(i), serviceTime(i), counter1ServiceBegin(i), counter1ServiceEnd(i), '-', '-', '-', waitingTime(i), timeSpent(i));
                disp('====================================================================================================================================================='); 
                %First customer with high temperature table arrangements
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%12.0f|%28s|%14s|%12s|%10s|%14s|%12s|%10s|%14s|%12s|\n', customerNo, '-', '-', '-', '-', '-', '-', '-', '-', '-');
                disp('=====================================================================================================================================================');
            end
        else
            %First customer with low temperature and proceedable table arrangements
            if (temperature(i) < 37.5)
                if(counter1Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('|%12.0f|%28.0f|%14.0f|%12.0f|%10.0f|%14s|%12s|%10s|%14.0f|%12.0f|\n', customerNo, serviceTimeRandomRange(i), serviceTime(i), counter1ServiceBegin(i), counter1ServiceEnd(i), '-', '-', '-', waitingTime(i), timeSpent(i));
                    disp('=====================================================================================================================================================');
                elseif(counter2Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('|%12.0f|%28.0f|%14s|%12s|%10s|%14.0f|%12.0f|%10.0f|%14.0f|%12.0f|\n', customerNo, serviceTimeRandomRange(i), '-', '-', '-', serviceTime(i), counter2ServiceBegin(i), counter2ServiceEnd(i),  waitingTime(i), timeSpent(i));
                    disp('=====================================================================================================================================================');
                end
                %First customer with high temperature table arrangements
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('|%12.0f|%28s|%14s|%12s|%10s|%14s|%12s|%10s|%14s|%12s|\n', customerNo, '-', '-', '-', '-', '-', '-', '-', '-', '-');                                
                disp('=====================================================================================================================================================');
            end
        end
    end
    
    %CALCULATION
    interArrivalCounter = 0;
    counter = 0;
    waitCounter = 0;
    sumWaitingTime = 0;
    sumTimeSpent = 0;
    sumInterArrivalTime = 0;
    
    for (i=1: length(temperature))
        if(temperature(i) < 37.5)
            counter = counter + 1;
            sumWaitingTime = sumWaitingTime + waitingTime(i);
            sumTimeSpent = sumTimeSpent + timeSpent(i);
            if(i == 1)
                continue;
            end
            sumInterArrivalTime = sumInterArrivalTime + interarrivalTime(i-1);
            interArrivalCounter = interArrivalCounter + 1;
        end
        if(waitingTime(i)~= 0)
            waitCounter = waitCounter + 1; 
        end
        
    end
    
    averageWaitingTime = sumWaitingTime / counter;
    averageTimeSpent = sumTimeSpent / counter;
    averageServiceTimeC1 = sumCounter1ServiceTime / sumCounter1Service;
    averageServiceTimeC2 = sumCounter2ServiceTime / sumCounter2Service;
    averageInterArrivalTime = sumInterArrivalTime / interArrivalCounter;
    probabilityCusWait = waitCounter / counter;
    probabilityCusAtC1 = sumCounter1Service / counter;
    probabilityCusAtC2 = sumCounter2Service / counter;
    probabilityCusFever = (noCust - counter) / noCust;
    probabilityCusNoFever = counter / noCust;
    efficiencyCounter1 = probabilityCusAtC1 * 100;
    efficiencyCounter2 = probabilityCusAtC2 * 100;
    
    %SHOW CALCULATION
    printf('\n');
    printf('==================================================================================================\n');
    printf('                                        Results Page                                             |\n');
    printf('==================================================================================================\n');
    printf('\n');
    printf('==================================================================================================\n');
    printf('                                          Average                                                |\n');
    
    
    if (sumCounter2Service > 0)
        printf('==================================================================================================\n');
        printf('| Waiting Time | Time Spent | Service Time Counter 1 | Service Time Counter 2 | InterArrivalTime |\n');
        printf('==================================================================================================\n');
        printf('|%14.2f|%12.2f|%24.2f|%24.2f|%18.2f|\n', averageWaitingTime, averageTimeSpent, averageServiceTimeC1, averageServiceTimeC2, averageInterArrivalTime);
        printf('==================================================================================================\n');
    else
        printf('=========================================================================================================\n');
        printf('| Average Waiting Time | Average Time Spent | Average Service Time Counter 1 | Average InterArrivalTime |\n');
        printf('=========================================================================================================\n');
        printf('|%22.2f|%20.2f|%32.2f|%26.2f|\n', averageWaitingTime, averageTimeSpent, averageServiceTimeC1, averageInterArrivalTime);
        printf('=========================================================================================================\n');                
    end
    
    %Exhibit Message to demonstrate the arrival and departure of each patient.
    customerNo = 0;
    for(i=1: noCust)
        if(i == 1)
            %First customer with low temperature and proceedable
            if (temperature(i) <= 37.5)
                customerNo = customerNo + 1;
                printf('\n');
                printf('Customer %d arrived at minute %d, entered the Hospital at minute %d, and departed at minutes %d.',customerNo, arrivalTime(i), timeEnteringHospital(i), counter1ServiceEnd(i));
                printf('\n');
                %First customer with high temperature
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('Customer %d arrived at minute %d, and was not allowed to enter the Hospital.',customerNo, arrivalTime(i));
                printf('\n');
            end
        else
            %First customer with low temperature and proceedable
            if (temperature(i) < 37.5)
                if(counter1Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('\n');
                    printf('Customer %d arrived at minute %d, entered the Hospital at minute %d, and departed at minutes %d.',customerNo, arrivalTime(i), timeEnteringHospital(i), counter1ServiceEnd(i));
                    printf('\n');
                elseif(counter2Use(i) == 1)
                    customerNo = customerNo + 1;
                    printf('\n');
                    printf('Customer %d arrived at minute %d, entered the Hospital at minute %d, and departed at minutes %d.',customerNo, arrivalTime(i), timeEnteringHospital(i), counter2ServiceEnd(i));
                    printf('\n');
                end
                %First customer with high temperature
            elseif (temperature(i) >= 37.5)
                customerNo = customerNo + 1;
                printf('\n');
                printf('Customer %d arrived at minute %d, and was not allowed to enter the Hospital.',customerNo, arrivalTime(i));
                printf('\n');
            end
        end
    end
    
    printf('\n');
    printf('===========================================================================================================================================\n');
    printf('                                                     Probability Table                                                                    |\n');
    printf('===========================================================================================================================================\n');  
    printf('| Customer Waiting | Customer at Counter 1 | Customer at Counter 2 | Customer generated high temp |       Customer generated low temp     |\n');
    printf('===========================================================================================================================================\n');
    printf('|%18.4f|%23.4f|%23.4f|%30.4f|%39.4f|\n', probabilityCusWait, probabilityCusAtC1, probabilityCusAtC2, probabilityCusFever, probabilityCusNoFever);
    printf('===========================================================================================================================================\n');
    
    printf('\n');
    printf('==========================================\n');
    printf('              Efficiency                 |\n');
    printf('==========================================\n');
    printf('Counter 1 efficiency is %.2f%s \n', efficiencyCounter1, '%');
    printf('Counter 2 efficiency is %.2f%s \n', efficiencyCounter2, '%');
    printf('==========================================\n');