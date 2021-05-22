function [ PV_phase ] = find_crossover(PV_phase)
    P=[0.1 0.2 0.7];
    [L, population_size] = size(PV_phase);
    C = cumsum(P);
    X = 1:3;
    rand_num = rand(population_size/2,1);
    
    for J=1:population_size/2
        Cross_over_ID(J,1) = X(1,1+length(C(C<rand_num(J,1))));
    end
    
    for J=1:(population_size/2)
        switch Cross_over_ID(J,1)
            case 1
                crossoverPoint = randi(L,1,1); 
                c1 = PV_phase(1:crossoverPoint,2*J-1);
                c2 = PV_phase(1:crossoverPoint,2*J);
                    
                PV_phase(1:crossoverPoint,2*J-1)    = c2;
                PV_phase(1:crossoverPoint,2*J)      = c1;
            case 2
                crossoverPoint = randi(L,1,2);
                
                c1 = PV_phase(crossoverPoint(1,1):crossoverPoint(1,2),2*J-1);
                c2 = PV_phase(crossoverPoint(1,1):crossoverPoint(1,2),2*J);
                
                PV_phase(crossoverPoint(1,1):crossoverPoint(1,2),2*J-1)    = c2;
                PV_phase(crossoverPoint(1,1):crossoverPoint(1,2),2*J)      = c1;
            case 3
                C  = logical(randi([0 1], L,1));
                C_ = ~C;
                
                c1 = PV_phase(:,2*J-1);
                c2 = PV_phase(:,2*J);
                
                PV_phase(:,2*J-1)    = C.*c1 + C_.*c2;
                PV_phase(:,2*J)      = C.*c2 + C_.*c1;
            otherwise
                
        end
    end
end

