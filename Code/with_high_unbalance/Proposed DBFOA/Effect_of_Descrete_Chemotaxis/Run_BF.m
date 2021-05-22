function [ Best ] = Run_BF( params, Position, N_data )
p   =  params.p;     % Dimension of search space
S   = params.S;      % Number of bacteria in the colony
Nc  = params.N_c;    % Number of chemotactic steps 
Ns  =  params.N_s;   % Number of swim steps 
Nre =  params.N_re;  % Number of reproductive steps 
Ned =  params.N_ed;  % Number of elimination and dispersal steps
Sr  = S/2;           % The number of bacteria reproductions (splits) per generation 
P_ed = params.P_ed;  % The probability that each bacteria will be eliminated/dispersed 
A   = params.A;		 % The number of shiffling variables

% Initial positions
for m=1:S                    % the initital posistions 
    B(:,m,1,1,1)= Position(m,:);
end  
b_count = 1;
% (2) Elimination-dispersal loop
for l = 1:Ned
    % (3) Reproduction loop
    for k = 1:Nre    
        % (4) Chemotaxis (swim/tumble) loop
        for j=1:Nc
            % (4.1) Chemotatic step
            for i=1:S 
				display(strcat('BF-Default:::ED(l) = ',num2str(l),'|Re(k) = ',num2str(k),' |Che(j) = ',num2str(j),' |Bac(i) = ',num2str(i)));
                % (4.2) Fitness function
                [J(i,j,k,l),UB]  = Lotus_Grove_Cost_Fn(B(:,i,j,k,l),N_data);
                % (4.3) Jlast
                Jlast 		= J(i,j,k,l);
                % (4.4) Tumble
                tic
                delta_max 	= 3.*ones(size(B(:,i,j,k,l))) - B(:,i,j,k,l);
				delta_min 	= ones(size(B(:,i,j,k,l))) - B(:,i,j,k,l);
				Delta 			= zeros(p,1);
				for t1 = 1:p
					Delta(t1,1) = randi([delta_min(t1) delta_max(t1)], 1);
				end
				R = A(randperm(length(A)));
                % (4.5) Move
                B(:,i,j+1,k,l)=B(:,i,j,k,l) + R.*Delta;
                toc
                % (4.6) New fitness function
                [J(i,j+1,k,l),~]  = Lotus_Grove_Cost_Fn(B(:,i,j+1,k,l),N_data);
                % (4.7) Swimming
                m=0; % counter for swim length
                while m < Ns 
                    m=m+1;
                     if J(i,j+1,k,l)<Jlast 				 
                        Jlast=J(i,j+1,k,l);
						delta_max 	= 3.*ones(size(B(:,i,j+1,k,l))) - B(:,i,j+1,k,l);
						delta_min 	= ones(size(B(:,i,j+1,k,l))) - B(:,i,j+1,k,l);
						Delta 			= zeros(p,1);
						for t1 = 1:p
							Delta(t1,1) = randi([delta_min(t1) delta_max(t1)], 1);
						end
                        B(:,i,j+1,k,l) 	= B(:,i,j+1,k,l) + R.*Delta;
                        [J(i,j+1,k,l),~]  = Lotus_Grove_Cost_Fn(B(:,i,j+1,k,l),N_data);
                     else       
                        m=Ns;     
                     end 
                end
                %J(i,j,k,l) 	= Jlast; %???
            end % (4.8) Next bacterium
			% Record the minimum cost
			if b_count == 1
				[Best.Cost(b_count,1), Min_Loc] = min(J(:,j,k,l));
				Best.Position = B(:,Min_Loc,j,k,l);
				b_count = b_count+1;
			else
				[Temp_Min,Min_Loc] = min(J(:,j,k,l));
				if Temp_Min<Best.Cost(b_count-1,1)
					Best.Cost(b_count,1) = Temp_Min;
					Best.Position = B(:,Min_Loc,j,k,l);
					b_count = b_count+1;
				else
					Best.Cost(b_count,1) = Best.Cost(b_count-1,1);
					b_count = b_count+1;
				end
			end
        end % (5) if j < Nc, chemotaxis
		% (6) Reproduction
        % (6.1) Health
        for i=1:S
            Jhealth(i,1) = sum(J(i,:,k,l)');
        end
        [Jhealth,sortind]=sort(Jhealth);% Sorts bacteria in order of ascending values
        B(:,:,1,k+1,l)=B(:,sortind,Nc+1,k,l);
		%% We can modify this with GSP
        %c(:,k+1)=c(sortind,k);          % Keeps the chemotaxis parameters with each bacterium at the next generation
		
       	% (6.2) Split the bacteria
        for i=1:Sr
                B(:,i+Sr,1,k+1,l)=B(:,i,1,k+1,l); % The least fit do not reproduce, the most fit ones split into two identical copies  
                %c(i+Sr,k+1)=c(i,k+1);                 
        end
    end % (7) Loop to go to the next reproductive step
    % (8) Elimination-dispersal
        for m = 1:S 
            if  rand<P_ed %% Generate random number 
                B(:,m,1,1,l+1)=Best.Position; %randi(3,size(B(:,m,1,Nre+1,l)));
            else 
                B(:,m,1,1,l+1)= B(:,m,1,Nre+1,l); % Bacteria that are not dispersed
            end        
        end 
end
end