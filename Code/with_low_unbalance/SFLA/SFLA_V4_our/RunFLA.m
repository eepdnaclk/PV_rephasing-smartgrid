% Author: Chaminda Bandara
% Modified MSFLA Algorithm
% Date: 19th-January-2020

function pop = RunFLA(pop, params, N_data)
    %% FLA Parameters
    q 		= params.q;           		% Number of Parents
    alpha 	= params.alpha;   			% Number of Offsprings
    beta 	= params.beta;     			% Maximum Number of Iterations
    sigma 	= params.sigma;
    CostFunction = params.CostFunction;
    VarMin 	= params.VarMin;
    VarMax 	= params.VarMax;
    VarSize = size(pop(1).Position);
    BestSol = params.BestSol;
	No_of_Ones = params.No_of_Ones;     % No of alternate bits
                             
    nPop 	= numel(pop);      			% Population Size
    P 		= 2*(nPop+1-(1:nPop))/(nPop*(nPop+1));    % Selection Probabilities
    
    % Calculate Population Range (Smallest Hypercube)
    LowerBound = pop(1).Position;
    UpperBound = pop(1).Position;
    for i = 2:nPop
        LowerBound = min(LowerBound, pop(i).Position);
        UpperBound = max(UpperBound, pop(i).Position);
    end
    
    %% FLA Main Loop
    for it = 1:beta
        
        % Select Parents
        L = RandSample(P,q);
        B = pop(L);
        
        % Generate Offsprings
        for k=1:alpha
            
            % Sort Population
            [B, SortOrder] = SortPopulation(B);
            L = L(SortOrder);
            
            % Flags
            ImprovementStep2 = false;
            Censorship = false;
            
            % Improvement Step 1 %%%% CHANGED %%%%
            NewSol1 = B(end);
            Step_T  = (B(1).Position-B(end).Position);
			mix 	= [ones(1,22), zeros(1,length(Step_T)-22)];
            Step 	= logical(mix(randperm(length(mix)))).*Step_T;
            NewSol1.Position = B(end).Position + Step;
            [NewSol1.Cost, UF]      = CostFunction(NewSol1.Position,N_data);
            
            if NewSol1.Cost<B(end).Cost
                B(end) = NewSol1;
            else
                ImprovementStep2 = true;
            end
            
            % Improvement Step 2
            if ImprovementStep2
                NewSol2 = B(end);
                
                [~, Loc] = max(UF);
                
                if Loc>=1 && Loc<=14
                    NewSol2.Position(N_data.pv_details(:,1)'>=1 & N_data.pv_details(:,1)'<=14) = N_data.A(randi(N_data.N_opt_my,1),:);
                elseif Loc>=15 && Loc<=24
                    NewSol2.Position(N_data.pv_details(:,1)'>=15 & N_data.pv_details(:,1)'<=24) = N_data.B(randi(N_data.N_opt_my,1),:);
                elseif Loc>=25 && Loc<=30
                    NewSol2.Position(N_data.pv_details(:,1)'>=25 & N_data.pv_details(:,1)'<=30) = N_data.C(randi(N_data.N_opt_my,1),:);
                elseif Loc>=31 && Loc<=38
                    NewSol2.Position(N_data.pv_details(:,1)'>=31 & N_data.pv_details(:,1)'<=38) = N_data.D(randi(N_data.N_opt_my,1),:);
                elseif Loc>=39 && Loc<=47
                    NewSol2.Position(N_data.pv_details(:,1)'>=39 & N_data.pv_details(:,1)'<=47) = N_data.E(randi(N_data.N_opt_my,1),:);
                elseif Loc>=48 && Loc<=56
                    NewSol2.Position(N_data.pv_details(:,1)'>=48 & N_data.pv_details(:,1)'<=56) = N_data.F(randi(N_data.N_opt_my,1),:);
                else
                    NewSol2.Position(N_data.pv_details(:,1)'>=57 & N_data.pv_details(:,1)'<=62) = N_data.G(randi(N_data.N_opt_my,1),:);
                end
                %%% CHANGE HERE
                %Step_T  = (B(1).Position-B(end).Position);
				%mix 	= [ones(1,No_of_Ones), zeros(1,length(Step_T)-No_of_Ones)];
				%Step 	= logical(mix(randperm(length(mix)))).*Step_T;
				%NewSol2.Position = B(end).Position + Step;
                NewSol2.Cost     = CostFunction(NewSol2.Position,N_data);
                
                if NewSol2.Cost<B(end).Cost
                   B(end) = NewSol2;
                else
                   Censorship = true;
                end
            end
                
            % Censorship
            if Censorship
                %B(end).Position = unifrnd(LowerBound, UpperBound);
                B(end).Position     = randi(VarMax,VarSize);
                B(end).Cost         = CostFunction(B(end).Position,N_data);
            end
            
        end
        
        % Return Back Subcomplex to Main Complex
        pop(L) = B;
        
    end
    
end