function [ LF_V_abs, Unbalance_factor] = Load_Flow_LG(pvphase,N_data)
min_power 	= 0.25;   				% Minimum power of each load
max_power 	= 5;      				% Maximum power of each load
Transformer_rating = 400;			% Transformer rating
pv_scale	= N_data.pv_scale;		% Scalling factor for PV capacity values
load_scale  = N_data.load_scale;	% Scalling factor for load values

Sing_Phase_Load_Power   = N_data.Sing_Phase_Load_Power;
Sing_Phase_Load_Power   = load_scale.*Sing_Phase_Load_Power(:,2:4);
powerfactor             = N_data.powerfactor;
pv_details              = N_data.pv_details;
pvbus                   = pv_details(:,1);
pvkw                    = pv_scale.*pv_details(:,2);

%SECTIONA 1
nodes_no_custermes_1    =[3 1 2 2 2 2 2 2 2 1]; %No of customers connected
length_1                =[36 19 21 27 24 26 28 23 21 22]; %Distance to each node

%SECTION 2
nodes_no_custermes_2=[0 0 1 1];	%No of customers connected
length_2=[36 30 30 32]; %Distance to each node

%SECTION 3
nodes_no_custermes_3=[2 2 2 2 2 1 1 2 2 1]; %No of customers connected
length_3=[25 25 30 25 26 10 9 11 12 9]; %Distance to each node

%SECTION 4
nodes_no_custermes_4=[1 1 1 1 1 1]; %No of customers connected
length_4=[27 28 29 25 24 26]; %Distance to each node

%SECTION 5
nodes_no_custermes_5=[0 0 0 0 2 1 2 1]; %No of customers connected
length_5=[22 30 33 28 23 24 25 29]; %Distance to each node

%SECTION 6
nodes_no_custermes_6=[0 0 2 2 2 2 4 3 3]; %No of customers connected
length_6=[28 27 20 20 23 24 20 25 24]; %Distance to each node

%SECTION 7
nodes_no_custermes_7=[0 0 1 2 2 2 2 2 1]; %No of customers connected
length_7=[44 29 30 25 27 22 28 23 30]; %Distance to each node

%SECTION 8
nodes_no_custermes_8=[2 2 2 2 1 3]; %No of customers connected
length_8=[30 28 29 24 28 15]; %Distance to each node

totalnumload	=	sum(nodes_no_custermes_1)+sum(nodes_no_custermes_2)+sum(nodes_no_custermes_3)+sum(nodes_no_custermes_4)+sum(nodes_no_custermes_5)+sum(nodes_no_custermes_6)+sum(nodes_no_custermes_7)+sum(nodes_no_custermes_8);

pvkva		= pvkw/sqrt(1-0.44^2);
    
c		= [0 0 13 0 0 34 0 50]; %%%%%%%% connection point when starting new Line

if exist('DSSStartOK','var')==0
	[DSSStartOK, DSSObj, DSSText] = DSSStartup(cd);
end

DSSStartOK;
% Check to see if the DSS started properly
if DSSStartOK
						
DSSText.command = 'Clear';

DSSText.command = 'new circuit.Feeder01 basekv=11 pu=1.05 phases=3 bus1=SourceBus Angle=30';    
				 
DSSText.command = 'New Wiredata.ABC70Ph GMR=0.0035937 DIAM=9.9 RDC=0.443';
DSSText.command = '~ Runits=km radunits=mm gmrunits=m';
DSSText.command = 'New Wiredata.ABC70Ne GMR=0.0034485 DIAM=9.5 RDC=0.63';
DSSText.command = '~ Runits=km radunits=mm gmrunits=m';
				 
DSSText.command = 'New Linegeometry.ABC70 nconds=4 nphases=3';
DSSText.command = '~ cond=1 Wire=ABC70Ph x=0.00675 h=8.00675 units=m';
DSSText.command = '~ cond=2 Wire=ABC70Ph x=0.05235 h=8.00675 units=m';
DSSText.command = '~ cond=3 Wire=ABC70Ph x=0.01985 h=7.9869  units=m';
DSSText.command = '~ cond=4 Wire=ABC70Ne x=0.01985 h=8       units=m';
DSSText.command = 'New Transformer.TR1 Buses=[SourceBus.1.2.3.0, busno_0.1.2.3.4] Phases=3 Conns=[Delta Wye] kVs= [11 0.413] kVAs=[400 400] XHL=10 Rneut=0.5'; %%Windings=2 %%%%%DSSText.command = 'New Linecode.ALXLPE R1=0.35 X1=0.026 R0=.1784 X0=.4047 C1=3.4 C0=1.6 Units=km';
				 

%define lines for all bus path with  transmission line
k	=	1;    %LINE number updating
p	=	1;
feders_starts	=	[];
separation		=	[];
for i=1:8
	%for each i value, length1 = length_i
	%eval(['length1=length_' num2str(i)]);
    eval(strcat('length1=length_', num2str(i),';'));
	%for each i value, Costomers = node_no_customers_i
	%eval(['Customers=nodes_no_custermes_',num2str(i)]);
    eval(strcat('Customers=nodes_no_custermes_', num2str(i),';'));

	%%%%% line connecton bus blength1)-1)];
	busnum=[c(i) k:1:(k+length(length1)-1)];			
	feders_starts=[feders_starts k];
	separation=[separation c(i)];
					
	for j=1:length(length1)
	%%%% define the transmission line 
		DSSText.command = strcat('New Line.LINE',num2str(k),' Bus1=busno_',num2str(busnum(j)),'.1.2.3.4 Bus2=busno_',num2str(busnum(j+1)),'.1.2.3.4 Geometry=ABC70 Length=',num2str(length1(j)),' Units=m');
		%%%%% define load connected to j+1 bus bar
		if(Customers(j)~=0)
			for g=1:Customers(j)
				%f = normrnd(1.5,0.7,[1,3]); %Generate normally distributed random variable with mean 1 and std=0.1
				%single_power=f.*(loadpower(p)/sum(f)); %Generate signle phase load power values
                %Sing_Phase_Load_Power(p,:) = single_power;
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P1',' Bus1=busno_',num2str(busnum(j+1)),'.1.4 kV=0.238 kW=',num2str(Sing_Phase_Load_Power(p,1)),' PF=',num2str(powerfactor(p)),' phases=1');
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P2',' Bus1=busno_',num2str(busnum(j+1)),'.2.4 kV=0.238 kW=',num2str(Sing_Phase_Load_Power(p,2)),' PF=',num2str(powerfactor(p)),' phases=1');
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P3',' Bus1=busno_',num2str(busnum(j+1)),'.3.4 kV=0.238 kW=',num2str(Sing_Phase_Load_Power(p,3)),' PF=',num2str(powerfactor(p)),' phases=1');
				p=p+1;
				end
			end
			k=k+1;
		end
    end
nofbus=k-1;
feders_starts=[feders_starts nofbus];

%%% adding Pv panel
DSSText.command = 'New XYCurve.MyPvsT npts=4 xarray=[0 25 75 100] yarray=[1.0 1.0 1.0 1.0]';
DSSText.command = 'New XYCurve.MyEff npts=4 xarray=[0.1 0.2 0.4 1.0] yarray=[1.0 1.0 1.0 1.0]';

for y=1:length(pvkw)
	DSSText.command = strcat('New PVSystem.PV',num2str(y),' phases=1 Bus1=busno_',num2str(pvbus(y)),'.',num2str(pvphase(y)),'.4 kv=0.24 kVA=',num2str(pvkva(y)),' irrad=1 Pmpp=',num2str(pvkw(y)),' PF=1 effcurve=MyEff P-Tcurve=MyPvsT');
end

DSSText.command = 'Set voltagebases=[11 0.413]';DSSText.command = 'Calcvoltagebases';
					
DSSText.command = 'Solve';

for i=0:(nofbus)
	im=strcat('busno_',num2str(i));
	DSSObj.ActiveCircuit.Buses(im);
	puvoltage(i+1,:) = DSSObj.ActiveCircuit.ActiveBus.puVoltages; 
end

%Extraction of complex voltage values for each node
for i=0:(nofbus)
	LF_V(i+1,1) = (puvoltage(i+1,1)+1i*puvoltage(i+1,2))*0.393*10^3/sqrt(3); 
	LF_V(i+1,2) = (puvoltage(i+1,3)+1i*puvoltage(i+1,4))*0.393*10^3/sqrt(3); 
	LF_V(i+1,3) = (puvoltage(i+1,5)+1i*puvoltage(i+1,6))*0.393*10^3/sqrt(3); 
	LF_V(i+1,4) = (puvoltage(i+1,7)+1i*puvoltage(i+1,8))*0.393*10^3/sqrt(3); 
end
end

%Sequence Voltages
for i=0:(nofbus)
	im=strcat('busno_',num2str(i));
	DSSObj.ActiveCircuit.Buses(im);
	SEQvoltage(i+1,:) = DSSObj.ActiveCircuit.ActiveBus.SeqVoltages; 
end

%Voltage unbalance factor
Unbalance_factor = 100.*SEQvoltage(:,1)./SEQvoltage(:,2);
LF_V_abs = abs(LF_V);
end

