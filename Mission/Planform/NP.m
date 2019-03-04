function NEUTRALPOINT = NP(neutralPoint)
%% STICKED-FIXED NEUTRAL POINT AND STICK-FREE NEUTRAL POINT

P = neutralPoint.planform.geometryData;
ao = 0.11;                             % INPUT - Value from Perkins and Hage
e = 0.85;                              % INPUT - Input from Performance
AR = P.wing.AR;                               % INPUT - Input from Planform
awing = ao/(1+(57.3*ao/pi/e/AR));      % In degrees
TR =P.wing.taperRatio; % Taper ratio               % INPUT - Input Planform
Cbar = P.wing.mgc;                         % INPUT - MGC Length in inches
Lft = P.aircraftLength;                           % INPUT whole length of aicraft in feet
L = Lft*12;
FT =20*awing*TR^0.35;
ST =FT/(AR^0.725);
TT =(3*Cbar/L)^0.25;
de_da = ST*TT;
one_de_da = 1-de_da;

%% MULTHOPP FUSELAGE 

C_bar = Cbar ;
P1x = 0;
P2x = 310.08;       %WTF IS THIS                  % INPUT - Length of Back of Fueselage - input from Planform
P1y = 84;           %WTF IS THIS                  % INPUT - Lateral length of Back of Fueselage - input from Planform
P2y = 0;
m = (P2y - P1y)/(P2x - P1x);
b = P1y;
MaxX = P2x;
DeltaX = MaxX/100;
Rho= neutralPoint.primaryMission.myCruise.CR.rho(1,1)  ;                           % INPUT - Change to Altitude input - Calculate on the spot - cruise
V =  neutralPoint.primaryMission.myCruise.CR.velocity(1,1);                          % INPUT - Input from Performance - ft/s
q = (1/2)*(Rho)*(V^2)/(12^2);     

for i = 1:1:MaxX/DeltaX
    xcol(i) = (i-1)*DeltaX;
    ycol(i) = xcol(i)*m + b;
    wf(i) = ycol(i)*2;
    wf2(i) = (wf(i))^2;
    xcol2(i) = i*DeltaX/2;
    x_lcol(i) = xcol2(i)/MaxX;
    db_da(i) = x_lcol(i)/one_de_da ;
    Mult(i) = wf2(i) * db_da(i)*MaxX;     
end
SumFuselage = sum(Mult);

%% MULTHOPP NACELLE
P2xN = P.engine.lengthActual ;                                        % INPUT - Nacelle Length - Engine Data - m
MaxXN = P2xN;
YN = P.engine.nacelleFrontDiameter/2 ;                                          % INPUT - Nacelle Radius - m
DeltaXN = MaxXN/100;
for i = 1:1:MaxXN/DeltaXN
    xcol(i) = i*DeltaXN;
    ycol(i) = YN;
    wn(i) = ycol(i)*2;
    wn2(i) = (wn(i))^2;
    xcol2n(i) = i*DeltaXN/2;
    x_lcoln(i) = xcol2n(i)/MaxXN;
    db_dan(i) = x_lcoln(i)/one_de_da ;
    Multn(i) = wn2(i)^2 * db_dan(i)*MaxXN;     
end
SumN = sum(Multn);
    
%% Continue STICK-FIXED Neutral Point 

dm_da_fuselage = (q/(36.5*SumFuselage))/12 ;
dm_da_twoNacelles = ((q/12)/36.5)*SumN ;
dm_da_total = dm_da_fuselage + dm_da_twoNacelles ;
S = P.wing.s;                                              % INPUT - Wing Area ft^2
dm_dcl_fuselage = dm_da_fuselage/(q*S*12^2*C_bar*ao);
AR_HT = P.horizontalTail.AR;                                                % INPUT - Planform Data
aht = 0.06;                                               % INPUT - Perkins and Hage iterate this
V_HT = 1;                                                 
n_ht = 0.85;                                              % INPUT - from Perkins and Hage
xa_c = P.wing.thicknessRatio;                                              %INPUT - Figure out how to calcualte this

NEUTRALPOINT.neutralPoint.stickFixedNeutralPoint = xa_c - dm_dcl_fuselage +((aht/awing)*V_HT*n_ht*one_de_da);

%% STICK-FREE NEUTRAL POINT
se_st = 0.25 ;                                           % INPUT All here are From Book
t = 0.45 ;                                               % INPUT
cb_cf = 0.1 ;                                            % INPUT
chd = -0.013 ;                                           % INPUT
cha = -0.007 ;                                           % INPUT
cha_3d = cha * awing/ao ;
chd_3d = chd + (t*(cha_3d - cha)) ;

NEUTRALPOINT.neutralPoint.stickFreeNeutralPoint = xa_c - dm_dcl_fuselage +((aht/awing)*V_HT*n_ht*one_de_da*(1-((cha_3d/chd_3d)*t)));

%% FORWARD CG LIMIT 
CR = P.innerWing.rootChord;                                                  % INPUT IN FT
MAC =((2/3)*CR*((1+TR+TR^2)/(1+TR)));
CMAC = MAC/(q*12^2*AR);
CL_Clean = neutralPoint.planform.performanceData.clMax(1,1);                                           %INPUT
CL_Landing = neutralPoint.planform.performanceData.clMax(1,3);                                          %INPUT
CM_FUSE = CL_Clean * dm_dcl_fuselage ;
alphawing = 10 ;                                          % INPUT IN DEGREE 
downwash = 20*CL_Clean*((TR^0.3)/(AR^0.725))*(3*C_bar/L)^0.25;
iwing = 5;                                                %INPUT
iht = 0 ;                                                 %INPUT
aowing = -2.5;                                            %INPUT
tht = 0.02;
Cmd = -aht*V_HT*n_ht*t;
deo = (-CMAC/Cmd)-((aowing-iwing-iht)/t);
q_denver_landing = 46.942942;
CMAC_two = MAC/(q_denver_landing*AR);
demax =(CMAC_two+CL_Landing*xa_c+CM_FUSE-aht*(alphawing-downwash-iwing+iht)*V_HT*n_ht)/(aht*t*V_HT*n_ht);


NEUTRALPOINT.neutralPoint.firstFowardCGLimit = (deo-demax)*(Cmd/CL_Clean);
NEUTRALPOINT.neutralPoint.secondFowardCGLimit = (deo-demax)*(Cmd/CL_Landing);
