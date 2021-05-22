clear all;
close all;
clc;

%Author: Chaminda Bandara
%Date 14th - January - 2019
%V1

%Network parameters ...
N_data.N_opt_my         = 3;		% Number of best PV-phase solutions selected from my POWER-BALANCE analysis	(3)
N_data.Unbalance_limit	= 0.3;      % Unbalance Limit (0.3)
N_data.PF_SCALE			= 1;        % Panelty Factor Scale (20)
N_data.OF_SCALE			= 5;        % Panelty Factor Scale (1)
N_data.pv_scale         = 0.7;		% PV-Scale (0.7)
N_data.load_scale       = 1.0;		% Load-scale (1.0)
N_data.Sing_Phase_Load_Power   = xlsread('Data.xlsx', 'Sing_Phase_Load_Power');
N_data.powerfactor             = xlsread('Data.xlsx', 'powerfactor');
N_data.pv_details              = xlsread('Data.xlsx', 'pv_details');

%Vatiables
Unbalance_limit = N_data.Unbalance_limit;
population_size = 6;
mutation_ratio  = 0.07;     % Default = 0.03
count           = 500;

%Initial PV Combination
pv_details  = xlsread('Data.xlsx', 'pv_details');
temp        = pv_details(:,3);
PV_phase    = randi(3,length(temp),population_size);

% Initialize Variable
[ temp1, temp2]     = Load_Flow_LG(PV_phase(:,1),N_data);
LF_V_abs            = zeros([population_size, size(temp1)]);
Unbalance_factor    = zeros([size(temp2),population_size]);
fitness_evolution   = zeros(count,1);

cost_count = 1;
cumulative_cost(cost_count,1) = 100;

while count
    %Initial load flow
    for i=1: population_size
        
        % Calculate fitness function
        [Fitness_fun(i,1),Unbalance_factor(:,i)]=Lotus_Grove_Cost_Fn(PV_phase(:,i),N_data);
        
        if Fitness_fun(i,1) < cumulative_cost(cost_count,1)
            cumulative_cost(cost_count+1,1) = Fitness_fun(i,1);
        else 
            cumulative_cost(cost_count+1,1) = cumulative_cost(cost_count,1);
        end
        cost_count = cost_count +1;
        %Print progree
        fprintf('Itteration: %d <-----> population: %d \n',count,i);
    end
    
    %parent selection
    beta= 10;
    raw = exp((-1*beta/max(Fitness_fun)).*Fitness_fun);
    P   = raw./sum(raw);
    
     C          = cumsum(P);
     X          = 1:population_size;
     rand_num   = rand(population_size,1);
     
    for J=1:population_size
        parent_ID(J,1) = X(1,1+length(C(C<rand_num(J,1))));
    end
    
    %Crossover Operator
    PV_phase = find_crossover(PV_phase);
    
    %Mutation Operator
    PV_phase = find_mutation( PV_phase,mutation_ratio);
    
    %find minimum fitness value
    [fitness_evolution(length(fitness_evolution)-count+1,1), min_loc] = min(Fitness_fun);
    unbalance_evolution(:,length(fitness_evolution)-count+1) = Unbalance_factor(:,min_loc);
    
    %update count
    count = count-1;
end

cumulative_cost(1)=cumulative_cost(2);
DGA1 = cumulative_cost;
figure(1);
plot(DGA1);