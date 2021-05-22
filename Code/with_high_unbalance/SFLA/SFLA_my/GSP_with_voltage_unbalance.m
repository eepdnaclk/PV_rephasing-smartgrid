clear all;
close all;
clc;

%Voltage unbalance factor also included in the sensitivity function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%PREDEFINED VALUES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

min_power = 0.25;   %Minimum power of each load
max_power = 5;      %Maximum power of each load
Transformer_rating = 400;
Loading = 1;
pv_scale=1.4;

%SECTIONA 1
nodes_no_custermes_1=[3 1 2 2 2 2 2 2 2 1]; %No of customers connected
length_1=[36 19 21 27 24 26 28 23 21 22]; %Distance to each node

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

totalnumload=sum(nodes_no_custermes_1)+sum(nodes_no_custermes_2)+sum(nodes_no_custermes_3)+sum(nodes_no_custermes_4)+sum(nodes_no_custermes_5)+sum(nodes_no_custermes_6)+sum(nodes_no_custermes_7)+sum(nodes_no_custermes_8);

%powerfactor=round(0.9 + 0.1*rand(totalnumload,1),3);
powerfactor = [0.981,0.991,0.913,0.991,0.963,0.9100,0.928,0.955,0.996,0.996,0.916,0.997,0.996,0.949,0.980,0.914,0.942,0.992,0.979,0.996,0.966,0.904,0.985,0.993,0.968,0.976,0.974,0.939,0.966,0.917,0.971,0.903,0.928,0.905,0.910,0.982,0.969,0.932,0.995,0.903,0.944,0.9380,0.977,0.980,0.919,0.949,0.945,0.965,0.971,0.975,0.928,0.968,0.966,0.916,0.912,0.950,0.996,0.934,0.959,0.922,0.975,0.926,0.951,0.970,0.989,0.996,0.955,0.914,0.915,0.926,0.984,0.925,0.981,0.924,0.993,0.935,0.920,0.925,0.962,0.947,0.935,0.983,0.959,0.955,0.992,0.929,0.976,0.975,0.938,0.957,0.908,0.905]';
%mean_pf = mean(powerfactor)
%Total_active_power = Transformer_rating*Loading*mean_pf;
%loadpower=round(randfixedsum(totalnumload,1,Total_active_power,min_power,max_power),1);
loadpower = [3.8,4.7,4.9,2.6,4.6,2.3,4.6,4.1,1,1.5,1.1,2.1,2.6,4.2,4.4,2.1,0.8,2.6,4.1,3.1,4.7,2.7,4.9,3.6,0.7,3.5,3.9,2.4,4.9,2.2,2.8,2.1,4.1,4,4,2.4,2.3,3.8,4.3,4.3,0.9,0.6,3.6,4.7,4.8,4.7,1.3,4.5,4,2.5,3.4,2.7,4.7,4.8,4.8,3.9,1.4,3.9,4.4,3.2,3.1,2.8,4.6,2.5,4.9,3.2,0.8,5,4.4,3.5,4.9,4.3,4.1,4.8,1.2,1.1,4.3,1.7,4.8,2.8,4.7,0.4,0.3,4.8,3.6,3.4,3.6,4.3,4.7,2.4,3.8,2.6]';

pvkw=pv_scale.*[2 6 4 2 5 4.2 4.2 2 10 4 5.4 5 3.3 5 2.6 3.5 17 10 5.3 4.8 6.9 4.3 7 7 7 7];
pvkva=pvkw/sqrt(1-0.44^2);
    
%pvphase=randi(3,length(pvkw),1);
pvphase = [1,2,1,3,1,1,2,1,3,1,3,1,2,1,2,3,1,1,3,2,1,3,3,2,3,2]';
%pvbus=randi(62,length(pvkw),1);
pvbus = [3,4,5,6,7,15,17,19,22,27,29,32,37,41,43,45,47,49,55,57,59,61,43,43,44,44]';
pvbus = [3,4,5,6,7,15,17,19,22,27,29,32,33,34,37,40,47,49,55,57,59,61,43,43,44,44]';

c=[0 0 13 0 0 34 0 50]; %%%%%%%% connection point when starting new Line

if exist('DSSStartOK','var')==0
	[DSSStartOK, DSSObj, DSSText] = DSSStartup(cd);
end

DSSStartOK
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
k=1;    %LINE number updating
p=1;
feders_starts=[];
separation=[];
for i=1:8
	%for each i value, length1 = length_i
	eval(['length1=length_' num2str(i)]);
	%for each i value, Costomers = node_no_customers_i
	eval(['Customers=nodes_no_custermes_',num2str(i)]);

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
				f = normrnd(1,0.1,[1,3]); %Generate normally distributed random variable with mean 1 and std=0.1
				single_power=f.*(loadpower(p)/sum(f)); %Generate signle phase load power values
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P1',' Bus1=busno_',num2str(busnum(j+1)),'.1.4 kV=0.238 kW=',num2str(single_power(1,1)),' PF=',num2str(powerfactor(p)),' phases=1');
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P2',' Bus1=busno_',num2str(busnum(j+1)),'.2.4 kV=0.238 kW=',num2str(single_power(1,2)),' PF=',num2str(powerfactor(p)),' phases=1');
				DSSText.command = strcat('New Load.LOAD',num2str(p),'_P3',' Bus1=busno_',num2str(busnum(j+1)),'.3.4 kV=0.238 kW=',num2str(single_power(1,3)),' PF=',num2str(powerfactor(p)),' phases=1');
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
%DSSText.command = 'show voltages';
%DSSText.command = 'Show Voltage LN Nodes';
%DSSText.command = 'Show power kva elem';
%DSSText.command = 'Show current elem';

for i=0:(nofbus)
	im=strcat('busno_',num2str(i));
	DSSObj.ActiveCircuit.Buses(im);
	puvoltage(i+1,:) = DSSObj.ActiveCircuit.ActiveBus.puVoltages; 
end

%%%%Sequence Voltages%%%%
for i=0:(nofbus)
	im=strcat('busno_',num2str(i));
	DSSObj.ActiveCircuit.Buses(im);
	SEQvoltage(i+1,:) = DSSObj.ActiveCircuit.ActiveBus.SeqVoltages; 
end

%EXTRACTING VOLTAGE (COMPLEX) AT EACH NODE 0-62 NODES TOTAL = 63 NODES
for i=0:(nofbus)
	LF_V(i+1,1) = (puvoltage(i+1,1)+1i*puvoltage(i+1,2))*0.393*10^3/sqrt(3); 
	LF_V(i+1,2) = (puvoltage(i+1,3)+1i*puvoltage(i+1,4))*0.393*10^3/sqrt(3); 
	LF_V(i+1,3) = (puvoltage(i+1,5)+1i*puvoltage(i+1,6))*0.393*10^3/sqrt(3); 
	LF_V(i+1,4) = (puvoltage(i+1,7)+1i*puvoltage(i+1,8))*0.393*10^3/sqrt(3); 
end
end

%%%%Rescale voltage values%%%%%
voltage_r_p1 = rescale_voltages(abs(LF_V(:,1)),230,4);
voltage_r_p2 = rescale_voltages(abs(LF_V(:,2)),230,4);
voltage_r_p3 = rescale_voltages(abs(LF_V(:,3)),230,4);

%%%%GSP%%%%
[U, lambda] = GSP_on_Network(1);
spectrum_V1 = U'*voltage_r_p1;
spectrum_V2 = U'*voltage_r_p2;
spectrum_V3 = U'*voltage_r_p3;

%Localized Graph Signal Processing
LSV_Convolution_V1 = LSV_Convolution( 63, voltage_r_p1, lambda, U, 10,2);
LSV_Convolution_V2 = LSV_Convolution( 63, voltage_r_p2, lambda, U, 10,2);
LSV_Convolution_V3 = LSV_Convolution( 63, voltage_r_p3, lambda, U, 10,2);


%Calculating Voltage Unbalance Factor for three phase system
Unbalance_factor = SEQvoltage(:,1)./SEQvoltage(:,2);
Rescaled_Unbalances = rescale_unbalance(Unbalance_factor.*100,1,10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Plot Bus Voltages%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); hold on;
title('Variation of voltage profile at each node (63 nodes in total)');
xlabel('Node Number');
ylabel('Voltage Magnitude (V)');
plot(1:63, abs(LF_V(:,1)),'ro-','Linewidth',1.2);
plot(1:63, abs(LF_V(:,2)),'bo-','Linewidth',1.2);
plot(1:63, abs(LF_V(:,3)),'go-','Linewidth',1.2);
plot(1:63, 230*ones(1,63),'k-');
plot(1:63, 234*ones(1,63),'k-');
plot(1:63, 226*ones(1,63),'k-');
legend('Phase A', 'Phase B', 'Phase C')
ylim([220 240]);xlim([1 63]);

%%% Plot Rescaled Voltages%%%
figure(2); hold on;
title('Rescaled voltage values');
xlabel('Node Number');
ylabel('Transformed Voltage Values');
plot(1:63, voltage_r_p1,'ro-','Linewidth',1.2);
plot(1:63, voltage_r_p2,'bo-','Linewidth',1.2);
plot(1:63, voltage_r_p3,'go-','Linewidth',1.2);
legend('Phase A', 'Phase B', 'Phase C')
xlim([1 63]);

%%% Eigenvalue plot of L%%%
figure(3); hold on;
title('Eigenvalues of Laplacian Matrix');
xlabel('k');
ylabel('\lambda_k');
stem(1:63,lambda,'ro');
xlim([1 63]);

%%%%%Plot Spectrum of Transformed Voltages%%%%%%
figure(4); hold on;
title('Graph Spectrum - X');
xlabel('\lambda_k');
ylabel('Magnitude');
stem(1:63, spectrum_V1,'ro-','Linewidth',1.2);
stem(1:63, spectrum_V2,'bo-','Linewidth',1.2);
stem(1:63, spectrum_V3,'go-','Linewidth',1.2);
legend('Phase A', 'Phase B', 'Phase C')
xlim([1 63]);

%%%%%%%Draw LSV Convolution%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_LSV = max(max(max(LSV_Convolution_V1))+max(max(LSV_Convolution_V2))+max(max(LSV_Convolution_V3)));
min_LSV = min(min(min(LSV_Convolution_V1))+min(min(LSV_Convolution_V2))+min(min(LSV_Convolution_V3)));
figure(5); hold on;
title('LSV Convolution Method - Phase A');
imagesc(LSV_Convolution_V1');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');

figure(6); hold on;
title('LSV Convolution Method - Phase B');
imagesc(LSV_Convolution_V2');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');


figure(7); hold on;
title('LSV Convolution Method - Phase C');
imagesc(LSV_Convolution_V3');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');







%%%%%%%%Plot Voltage Unbalance Factor%%%%%%%%
figure(8); 
hold on;
grid on;
plot(1:63,100.*Unbalance_factor,'o-','Linewidth',1.3);
title('Variation of Voltage Unbalance Factor = V^-/V^+');
ylabel('Voltage Unbalance Factor (VUF) - %');
xlabel('Node Number');
xlim([1 63]);

%%% Rescale Values%%%
Rescaled_Voltages_01 = rescale([voltage_r_p1,voltage_r_p2,voltage_r_p3]);
%%% Plot Rescaled Voltages%%%
cons_unb = 1;
cons_vol = 0;
figure(9); hold on;
title('Rescaled voltage values *Voltage Unbalance');
xlabel('Node Number');
ylabel('Transformed Voltage Values');
plot(1:63, cons_vol.*Rescaled_Voltages_01(:,1) + cons_unb.*rescale(Rescaled_Unbalances),'ro-','Linewidth',1.2);
plot(1:63, cons_vol.*Rescaled_Voltages_01(:,2) + cons_unb.*rescale(Rescaled_Unbalances),'bo-','Linewidth',1.2);
plot(1:63, cons_vol.*Rescaled_Voltages_01(:,3) + cons_unb.*rescale(Rescaled_Unbalances),'go-','Linewidth',1.2);
legend('Phase A', 'Phase B', 'Phase C')
xlim([1 63]);

%Localized Graph Signal Processing
LSV_Convolution_V1_unb = LSV_Convolution( 63, cons_vol.*Rescaled_Voltages_01(:,1) + cons_unb.*rescale(Rescaled_Unbalances), lambda, U, 100,7);
LSV_Convolution_V2_unb = LSV_Convolution( 63, cons_vol.*Rescaled_Voltages_01(:,2) + cons_unb.*rescale(Rescaled_Unbalances), lambda, U, 100,7);
LSV_Convolution_V3_unb = LSV_Convolution( 63, cons_vol.*Rescaled_Voltages_01(:,3) + cons_unb.*rescale(Rescaled_Unbalances), lambda, U, 100,7);

max_LSV = max(max(max(LSV_Convolution_V1_unb))+max(max(LSV_Convolution_V2_unb))+max(max(LSV_Convolution_V3_unb)));
min_LSV = min(min(min(LSV_Convolution_V1_unb))+min(min(LSV_Convolution_V2_unb))+min(min(LSV_Convolution_V3_unb)));

figure(10); hold on;
title('LSV Convolution Method - Phase A');
imagesc(LSV_Convolution_V1_unb');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');

figure(11); hold on;
title('LSV Convolution Method - Phase B');
imagesc(LSV_Convolution_V2_unb');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');


figure(12); hold on;
title('LSV Convolution Method - Phase C');
imagesc(LSV_Convolution_V3_unb');
colorbar;
caxis([min_LSV max_LSV]);
xlim([1 63]);
ylim([1 63]);
xlabel('n');
ylabel('k');

%PLOT RESCALED UNBALANCE FACTOR
figure(13); hold on;
plot(1:63,Rescaled_Unbalances,'o-','Linewidth',1.3);
title('Variation of Rescaled Voltage Unbalance Factor = V^-/V^+');
ylabel('Rescaled unbalance factor');
xlabel('Node Number');
xlim([1 63]);

Show_in_Network(14, Rescaled_Unbalances,'Rescaled Unbalance Factors');
Show_in_Network(15, 100.*Unbalance_factor,'Unbalance Factors');