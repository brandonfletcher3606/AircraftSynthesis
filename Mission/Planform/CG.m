function CenterOfGravity = CG(cg)
%% INPUTS
% Plane_Length_ft = 90.84; %this is the original plane length and this is what we use as a ratio of DO NOT DELETE
% Root_Cord = 25;
% Tip_Cord = 7.38;
% Span = 109.33;
%C_bar = 16.19;
p = cg.planform;
C_bar = p.geometryData.wing.mgc;
% sweep = 25;      
% Area = (1/2) * (Root_Cord + Tip_Cord)*(Span/2);
% Height1 = ((Area/2)*2)/(Root_Cord + C_bar);
% x_cbar = tan(deg2rad(sweep))*Height1*12 +(C_bar*12) ;
x_cbar = p.geometryData.wing.mgcYLoc*12    ;         %% NEED TO BE CHNAGED ASK BRANDON
%x_cbar = 337.6128;
%% Weights Inputs

Takeoff = p.weightData.takeoff;
Empty = p.weightData.empty  ;
OE = p.weightData.operatingEmpty;
Fuel = p.weightData.fuel;
OE_Fuel = OE+Fuel;
OE_Passengers = OE+p.weightData.payload;

%% Weights Calcuated

% Wing_Takeoff = 0.114;
% Empennage_Takeoff = 0.025;
% Fuselage_Takeoff = 0.112;
% Nacelle_Takeoff = 0.015;
% Landing_Gear_Takeoff = 0.039;
% Power_Plant_Takeoff = 0.082;
% Fixed_Equipment_Takeoff = 0.118;

Wing =p.weightData.average.wingWeight;  %(Wing_Takeoff * Takeoff) + (-179*Takeoff/87650) ;
Tail = p.weightData.average.empennageWeight;  %Empennage_Takeoff * Takeoff + (-230*Takeoff/87650);
Fuselage_Weight =p.weightData.average.fuselageWeight; %Fuselage_Takeoff * Takeoff + (-1805*Takeoff/87650);
Nacelle = p.weightData.inputs.nacelleWeight; %((Nacelle_Takeoff * Takeoff/2) + (((Power_Plant_Takeoff * Takeoff)+((-1300*Takeoff/87650)))/2)); 
Landing_Gear = p.weightData.average.totalLandingGearWeight; %Landing_Gear_Takeoff * Takeoff + (-1000*Takeoff/87650);
% Fixed_Equipment = (Fixed_Equipment_Takeoff * Takeoff) + (-1800*Takeoff/87650);


Nacelle1 = Nacelle;
Nacelle2 = Nacelle;
Wing1 = Wing;
Wing2 = Wing;
Fuselage = Fuselage_Weight;
Vertical_Tail = Tail/2;
Horizontal_Tail = Vertical_Tail;

Payload = p.weightData.payload;
Flight_Attendant = 1050;
Pilots = 480;

Fuel1 =Fuel/2;             
Fuel2 = Fuel1;

Flight_Controls =(p.weightData.gudmundsson.raymer.flightControlsWeight + p.weightData.roskam.gudmundsson.flightControlsWeight)/2 ;
Pilot_Seats =75;
Galley_1 = 900;
Laventory_1 =250;
Passengers_Seats = 3500;
Laventory_2 = Laventory_1 ;
Ecu =800;
Fire_Proection =220;
EMER =812;
APU = p.weightData.raymer.apuInstalledWeight;
% NLG = Landing_Gear/3;
% RMLG = NLG;
% LMLG = NLG;

Total = Flight_Controls + Pilot_Seats + Galley_1 + Laventory_1 + Passengers_Seats + Laventory_2 + Ecu + Fire_Proection + EMER + APU;
%% X CORDINATES 


%Plane_Length_in = Plane_Length_ft * 12;
%Correction = (p.geometryData.aircraftLength/Plane_Length_ft);
CenterOfGravity.x.Nacelle1_x = (p.geometryData.wing.mgcYLoc+C_bar)*12;
CenterOfGravity.x.Nacelle2_x = (p.geometryData.wing.mgcYLoc+C_bar)*12;
CenterOfGravity.x.Wing1_x = (p.geometryData.wing.mgcYLoc+0.25*C_bar)*12;
CenterOfGravity.x.Wing2_x = CenterOfGravity.x.Wing1_x;
CenterOfGravity.x.Fueslage_x = p.geometryData.innerWing.rootChord*12/2;
CenterOfGravity.x.Vertical_Tail_x = (p.geometryData.aircraftLength-0.75*p.geometryData.verticalTail.tipChord)*12;
CenterOfGravity.x.Horizontal_Tail_x = (p.geometryData.aircraftLength-0.75*p.geometryData.horizontalTail.mgc)*12;
CenterOfGravity.x.Payload_x = p.geometryData.innerWing.rootChord*12/2;
CenterOfGravity.x.Flight_Attendant_x = p.geometryData.innerWing.rootChord*12/2;
CenterOfGravity.x.Pilots_x = p.geometryData.innerWing.rootChord*12*0.1;
CenterOfGravity.x.Fuel1_x = (p.geometryData.wing.mgcYLoc+0.25*C_bar)*12*0.5;
CenterOfGravity.x.Fuel2_x = CenterOfGravity.x.Fuel1_x;
CenterOfGravity.x.Flight_Controls_x = p.geometryData.innerWing.rootChord*12*0.03;
CenterOfGravity.x.Pilot_Seats_x = p.geometryData.innerWing.rootChord*12*0.1;
CenterOfGravity.x.Galley_1_x = (p.geometryData.wing.mgcYLoc+0.25*C_bar)*12;
CenterOfGravity.x.Laventory_1_x = (p.geometryData.wing.mgcYLoc+0.25*C_bar)*12;
CenterOfGravity.x.Passengers_Seats_x = p.geometryData.innerWing.rootChord*12/2;
CenterOfGravity.x.Laventory_2_x = p.geometryData.innerWing.rootChord*12;
CenterOfGravity.x.Ecu_x = (p.geometryData.wing.mgcYLoc+C_bar)*12;
CenterOfGravity.x.Fire_Proection_x = p.geometryData.innerWing.rootChord*12*0.035;
CenterOfGravity.x.EMER_x = p.geometryData.innerWing.rootChord*12*0.035;
CenterOfGravity.x.APU_x = (p.geometryData.aircraftLength-0.95*p.geometryData.verticalTail.rootChord)*12;


Nacelle1_x = CenterOfGravity.x.Nacelle1_x;
Nacelle2_x = CenterOfGravity.x.Nacelle2_x;
Wing1_x = CenterOfGravity.x.Wing1_x;
Wing2_x = CenterOfGravity.x.Wing2_x;
Fueslage_x = CenterOfGravity.x.Fueslage_x;
Vertical_Tail_x = CenterOfGravity.x.Vertical_Tail_x;
Horizontal_Tail_x = CenterOfGravity.x.Horizontal_Tail_x;
Payload_x = CenterOfGravity.x.Payload_x;
Flight_Attendant_x = CenterOfGravity.x.Flight_Attendant_x;
Pilots_x = CenterOfGravity.x.Pilots_x;
Fuel1_x = CenterOfGravity.x.Fuel1_x;
Fuel2_x = CenterOfGravity.x.Fuel2_x;
Flight_Controls_x = CenterOfGravity.x.Flight_Controls_x;
Pilot_Seats_x = CenterOfGravity.x.Pilot_Seats_x;
Galley_1_x = CenterOfGravity.x.Galley_1_x;
Laventory_1_x = CenterOfGravity.x.Laventory_1_x;
Passengers_Seats_x = CenterOfGravity.x.Passengers_Seats_x;
Laventory_2_x = CenterOfGravity.x.Laventory_2_x;
Ecu_x = CenterOfGravity.x.Ecu_x;
Fire_Proection_x = CenterOfGravity.x.Fire_Proection_x;
EMER_x = CenterOfGravity.x.EMER_x;
APU_x = CenterOfGravity.x.APU_x;

%% Y CORDINATES

CenterOfGravity.y.Nacelle1_y = 0.75*p.geometryData.innerWing.b  *12;
CenterOfGravity.y.Nacelle2_y = -CenterOfGravity.y.Nacelle1_y;
CenterOfGravity.y.Wing1_y = p.geometryData.wing.b/2*12;
CenterOfGravity.y.Wing2_y = -CenterOfGravity.y.Wing1_y;
CenterOfGravity.y.Fueslage_y = 0;
CenterOfGravity.y.Vertical_Tail_y = 0;
CenterOfGravity.y.Horizontal_Tail_y = 0;
CenterOfGravity.y.Payload_y = 0;
CenterOfGravity.y.Flight_Attendant_y = 0;
CenterOfGravity.y.Pilots_y = 0;
CenterOfGravity.y.Fuel1_y = p.geometryData.wing.b/2*12;
CenterOfGravity.y.Fuel2_y = -CenterOfGravity.y.Fuel1_y;
CenterOfGravity.y.Flight_Controls_y = 0;
CenterOfGravity.y.Pilot_Seats_y = 0;
CenterOfGravity.y.Galley_1_y = -36;
CenterOfGravity.y.Laventory_1_y = 36;
CenterOfGravity.y.Passengers_Seats_y = 0;
CenterOfGravity.y.Laventory_2_y = -CenterOfGravity.y.Laventory_1_y;
CenterOfGravity.y.Ecu_y = 0;
CenterOfGravity.y.Fire_Proection_y = 0;
CenterOfGravity.y.EMER_y = 0;
CenterOfGravity.y.APU_y = 0;


Nacelle1_y = CenterOfGravity.y.Nacelle1_y;
Nacelle2_y = CenterOfGravity.y.Nacelle2_y;
Wing1_y = CenterOfGravity.y.Wing1_y;
Wing2_y = CenterOfGravity.y.Wing2_y;
Fueslage_y = CenterOfGravity.y.Fueslage_y;
Vertical_Tail_y = CenterOfGravity.y.Vertical_Tail_y;
Horizontal_Tail_y = CenterOfGravity.y.Horizontal_Tail_y;
Payload_y = CenterOfGravity.y.Payload_y;
Flight_Attendant_y = CenterOfGravity.y.Flight_Attendant_y;
Pilots_y = CenterOfGravity.y.Pilots_y;
Fuel1_y = CenterOfGravity.y.Fuel1_y;
Fuel2_y = CenterOfGravity.y.Fuel2_y;
Flight_Controls_y = CenterOfGravity.y.Flight_Controls_y;
Pilot_Seats_y = CenterOfGravity.y.Pilot_Seats_y;
Galley_1_y = CenterOfGravity.y.Galley_1_y;
Laventory_1_y = CenterOfGravity.y.Laventory_1_y;
Passengers_Seats_y = CenterOfGravity.y.Passengers_Seats_y;
Laventory_2_y = CenterOfGravity.y.Laventory_2_y;
Ecu_y = CenterOfGravity.y.Ecu_y;
Fire_Proection_y = CenterOfGravity.y.Fire_Proection_y;
EMER_y = CenterOfGravity.y.EMER_y;
APU_y = CenterOfGravity.y.APU_y;

%% Z CORDINATES

CenterOfGravity.z.Nacelle1_z = 24;
CenterOfGravity.z.Nacelle2_z = CenterOfGravity.z.Nacelle1_z;
CenterOfGravity.z.Wing1_z = 0;
CenterOfGravity.z.Wing2_z = 0;
CenterOfGravity.z.Fueslage_z = 0;
CenterOfGravity.z.Vertical_Tail_z = 180;
CenterOfGravity.z.Horizontal_Tail_z = 320;
CenterOfGravity.z.Payload_z = 0;
CenterOfGravity.z.Flight_Attendant_z = 0;
CenterOfGravity.z.Pilots_z = 0;
CenterOfGravity.z.Fuel1_z = 0;
CenterOfGravity.z.Fuel2_z = CenterOfGravity.z.Fuel1_z;
CenterOfGravity.z.Flight_Controls_z = 24;
CenterOfGravity.z.Pilot_Seats_z = 0;
CenterOfGravity.z.Galley_1_z = 20;
CenterOfGravity.z.Laventory_1_z = 0;
CenterOfGravity.z.Passengers_Seats_z = 0;
CenterOfGravity.z.Laventory_2_z = CenterOfGravity.z.Laventory_1_z;
CenterOfGravity.z.Ecu_z = 0;
CenterOfGravity.z.Fire_Proection_z = 0;
CenterOfGravity.z.EMER_z = 0;
CenterOfGravity.z.APU_z = 10;

Nacelle1_z = CenterOfGravity.z.Nacelle1_z;
Nacelle2_z = CenterOfGravity.z.Nacelle2_z;
Wing1_z = CenterOfGravity.z.Wing1_z;
Wing2_z = CenterOfGravity.z.Wing2_z;
Fueslage_z = CenterOfGravity.z.Fueslage_z;
Vertical_Tail_z = CenterOfGravity.z.Vertical_Tail_z;
Horizontal_Tail_z = CenterOfGravity.z.Horizontal_Tail_z;
Payload_z = CenterOfGravity.z.Payload_z;
Flight_Attendant_z = CenterOfGravity.z.Flight_Attendant_z;
Pilots_z = CenterOfGravity.z.Pilots_z;
Fuel1_z = CenterOfGravity.z.Fuel1_z;
Fuel2_z = CenterOfGravity.z.Fuel2_z;
Flight_Controls_z = CenterOfGravity.z.Flight_Controls_z;
Pilot_Seats_z = CenterOfGravity.z.Pilot_Seats_z;
Galley_1_z = CenterOfGravity.z.Galley_1_z;
Laventory_1_z = CenterOfGravity.z.Laventory_1_z;
Passengers_Seats_z = CenterOfGravity.z.Passengers_Seats_z;
Laventory_2_z = CenterOfGravity.z.Laventory_2_z;
Ecu_z = CenterOfGravity.z.Ecu_z;
Fire_Proection_z = CenterOfGravity.z.Fire_Proection_z;
EMER_z = CenterOfGravity.z.EMER_z;
APU_z = CenterOfGravity.z.APU_z;


%% MOMENT X

M_Nacelle1_x = Nacelle1_x * Nacelle1;
M_Nacelle2_x = Nacelle2_x * Nacelle2;
M_Wing1_x = Wing1_x * Wing1;
M_Wing2_x = Wing2_x * Wing2 ;
M_Fueslage_x = Fueslage_x * Fuselage;
M_Vertical_Tail_x = Vertical_Tail_x * Vertical_Tail;
M_Horizontal_Tail_x = Horizontal_Tail_x * Horizontal_Tail;
M_Payload_x = Payload_x * Payload;
M_Flight_Attendant_x = Flight_Attendant_x * Flight_Attendant;
M_Pilots_x = Pilots_x * Pilots;
M_Fuel1_x = Fuel1_x * Fuel1;
M_Fuel2_x = Fuel2_x * Fuel2;
M_Flight_Controls_x = Flight_Controls_x * Flight_Controls;
M_Pilot_Seats_x = Pilot_Seats_x * Pilot_Seats;
M_Galley_1_x = Galley_1_x * Galley_1;
M_Laventory_1_x = Laventory_1_x * Laventory_1;
M_Passengers_Seats_x = Passengers_Seats_x * Passengers_Seats;
M_Laventory_2_x = Laventory_2_x * Laventory_2;
M_Ecu_x = Ecu_x * Ecu;
M_Fire_Proection_x = Fire_Proection_x * Fire_Proection;
M_EMER_x = EMER_x * EMER;
M_APU_x = APU_x * APU;


%% MOMENT Y

M_Nacelle1_y = Nacelle1_y * Nacelle1;
M_Nacelle2_y = Nacelle2_y * Nacelle2;
M_Wing1_y = Wing1_y * Wing1;
M_Wing2_y = Wing2_y * Wing2 ;
M_Fueslage_y = Fueslage_y * Fuselage;
M_Vertical_Tail_y = Vertical_Tail_y * Vertical_Tail;
M_Horizontal_Tail_y = Horizontal_Tail_y * Horizontal_Tail;
M_Payload_y = Payload_y * Payload;
M_Flight_Attendant_y = Flight_Attendant_y * Flight_Attendant;
M_Pilots_y = Pilots_y * Pilots;
M_Fuel1_y = Fuel1_y * Fuel1;
M_Fuel2_y = Fuel2_y * Fuel2;
M_Flight_Controls_y = Flight_Controls_y * Flight_Controls;
M_Pilot_Seats_y = Pilot_Seats_y * Pilot_Seats;
M_Galley_1_y = Galley_1_y * Galley_1;
M_Laventory_1_y = Laventory_1_y * Laventory_1;
M_Passengers_Seats_y = Passengers_Seats_y * Passengers_Seats;
M_Laventory_2_y = Laventory_2_y * Laventory_2;
M_Ecu_y = Ecu_y * Ecu;
M_Fire_Proection_y = Fire_Proection_y * Fire_Proection;
M_EMER_y = EMER_y * EMER;
M_APU_y = APU_y * APU;
%% MOMENT Z

M_Nacelle1_z = Nacelle1_z * Nacelle1;
M_Nacelle2_z = Nacelle2_z * Nacelle2;
M_Wing1_z = Wing1_z * Wing1;
M_Wing2_z = Wing2_z * Wing2 ;
M_Fueslage_z = Fueslage_z * Fuselage;
M_Vertical_Tail_z = Vertical_Tail_z * Vertical_Tail;
M_Horizontal_Tail_z = Horizontal_Tail_z * Horizontal_Tail;
M_Payload_z = Payload_z * Payload;
M_Flight_Attendant_z = Flight_Attendant_z * Flight_Attendant;
M_Pilots_z = Pilots_z * Pilots;
M_Fuel1_z = Fuel1_z * Fuel1;
M_Fuel2_z = Fuel2_z * Fuel2;
M_Flight_Controls_z = Flight_Controls_z * Flight_Controls;
M_Pilot_Seats_z = Pilot_Seats_z * Pilot_Seats;
M_Galley_1_z = Galley_1_z * Galley_1;
M_Laventory_1_z = Laventory_1_z * Laventory_1;
M_Passengers_Seats_z = Passengers_Seats_z * Passengers_Seats;
M_Laventory_2_z = Laventory_2_z * Laventory_2;
M_Ecu_z = Ecu_z * Ecu;
M_Fire_Proection_z = Fire_Proection_z * Fire_Proection;
M_EMER_z = EMER_z * EMER;
M_APU_z = APU_z * APU;


%% TAKEOFF WEIGHT
%%
Sum_Moment_X = M_Nacelle1_x +M_Nacelle2_x +M_Wing1_x+M_Wing2_x +M_Fueslage_x +M_Vertical_Tail_x+M_Horizontal_Tail_x +M_Payload_x +M_Flight_Attendant_x +M_Pilots_x +M_Fuel1_x +M_Fuel2_x +M_Flight_Controls_x+M_Pilot_Seats_x +M_Galley_1_x +M_Laventory_1_x +M_Passengers_Seats_x +M_Laventory_2_x +M_Ecu_x +M_Fire_Proection_x + M_EMER_x + M_APU_x; 
Sum_Moment_y = M_Nacelle1_y +M_Nacelle2_y +M_Wing1_y+M_Wing2_y +M_Fueslage_y +M_Vertical_Tail_y+M_Horizontal_Tail_y +M_Payload_y +M_Flight_Attendant_y +M_Pilots_y +M_Fuel1_y +M_Fuel2_y +M_Flight_Controls_y+M_Pilot_Seats_y +M_Galley_1_y +M_Laventory_1_y +M_Passengers_Seats_y +M_Laventory_2_y +M_Ecu_y +M_Fire_Proection_y +M_EMER_y +M_APU_y;
Sum_Moment_z = M_Nacelle1_z +M_Nacelle2_z +M_Wing1_z+M_Wing2_z +M_Fueslage_z +M_Vertical_Tail_z+M_Horizontal_Tail_z +M_Payload_z +M_Flight_Attendant_z +M_Pilots_z +M_Fuel1_z +M_Fuel2_z +M_Flight_Controls_z+M_Pilot_Seats_z +M_Galley_1_z +M_Laventory_1_z +M_Passengers_Seats_z +M_Laventory_2_z +M_Ecu_z +M_Fire_Proection_z +M_EMER_z +M_APU_z;

CenterOfGravity.CG_X = Sum_Moment_X / Takeoff;
CG_Y = Sum_Moment_y / Takeoff;
CG_Z = Sum_Moment_z / Takeoff;

CenterOfGravity.percentChordTakeoffWeightCG = ((CenterOfGravity.CG_X-x_cbar)/(C_bar*12))*100;

%% EMPTY WEIGHT
%%
Sum_Moment_X_2 = M_Nacelle1_x +M_Nacelle2_x +M_Wing1_x+M_Wing2_x +M_Fueslage_x +M_Vertical_Tail_x+M_Horizontal_Tail_x +M_Flight_Controls_x+M_Pilot_Seats_x +M_Galley_1_x +M_Laventory_1_x +M_Passengers_Seats_x +M_Laventory_2_x +M_Ecu_x +M_Fire_Proection_x + M_EMER_x + M_APU_x; 
Sum_Moment_y_2 = M_Nacelle1_y +M_Nacelle2_y +M_Wing1_y+M_Wing2_y +M_Laventory_1_y  +M_Laventory_2_y + M_Galley_1_y;
Sum_Moment_z_2 = M_Nacelle1_z +M_Nacelle2_z +M_Vertical_Tail_z+M_Horizontal_Tail_z +M_Flight_Controls_z +M_Galley_1_z +M_APU_z ;

CenterOfGravity.CG_X_2 = Sum_Moment_X_2 / Empty;
CG_Y_2 = Sum_Moment_y_2 / Empty;
CG_Z_2 = Sum_Moment_z_2 / Empty;

CenterOfGravity.percentChordEmptyWeightCG = ((CenterOfGravity.CG_X_2-x_cbar)/(C_bar*12))*100;

%% Operating Empty + Fuel 
%%
Sum_Moment_X_3 = M_Nacelle1_x +M_Nacelle2_x +M_Wing1_x+M_Wing2_x +M_Fueslage_x +M_Vertical_Tail_x+M_Horizontal_Tail_x +M_Flight_Attendant_x +M_Pilots_x +M_Fuel1_x +M_Fuel2_x +M_Flight_Controls_x+M_Pilot_Seats_x +M_Galley_1_x +M_Laventory_1_x +M_Passengers_Seats_x +M_Laventory_2_x +M_Ecu_x +M_Fire_Proection_x + M_EMER_x + M_APU_x+1; 
Sum_Moment_y_3 = M_Nacelle1_y +M_Nacelle2_y +M_Wing1_y+M_Wing2_y +M_Fuel1_y +M_Fuel2_y +M_Galley_1_y +M_Laventory_1_y  +M_Laventory_2_y+1;
Sum_Moment_z_3 = M_Nacelle1_z +M_Nacelle2_z +M_Vertical_Tail_z+M_Horizontal_Tail_z +M_Flight_Controls_z+M_Galley_1_z + M_APU_z+1;

CenterOfGravity.CG_X_3 = Sum_Moment_X_3 / OE_Fuel;
CG_Y_3 = Sum_Moment_y_3 / OE_Fuel;
CenterOfGravity.CG_Z_3 = Sum_Moment_z_3 / OE_Fuel;

CenterOfGravity.percentChordOperatingEmptyFuelWeightCG = ((CenterOfGravity.CG_X_3-x_cbar)/(C_bar*12))*100;

%% Operating Empty
%%
Sum_Moment_X_4 = M_Nacelle1_x +M_Nacelle2_x +M_Wing1_x+M_Wing2_x +M_Fueslage_x +M_Vertical_Tail_x+M_Horizontal_Tail_x +M_Flight_Attendant_x +M_Pilots_x  +M_Flight_Controls_x+M_Pilot_Seats_x +M_Galley_1_x +M_Laventory_1_x +M_Passengers_Seats_x +M_Laventory_2_x +M_Ecu_x +M_Fire_Proection_x + M_EMER_x + M_APU_x+1; 
Sum_Moment_y_4 = M_Nacelle1_y +M_Nacelle2_y +M_Wing1_y+M_Wing2_y  +M_Galley_1_y +M_Laventory_1_y  +M_Laventory_2_y+1;
Sum_Moment_z_4 = M_Nacelle1_z +M_Nacelle2_z +M_Vertical_Tail_z+M_Horizontal_Tail_z +M_Flight_Controls_z+M_Galley_1_z + M_APU_z+1;

CenterOfGravity.CG_X_4 = Sum_Moment_X_4 / OE;
CG_Y_4 = Sum_Moment_y_4 / OE;
CG_Z_4 = Sum_Moment_z_4 / OE;

CenterOfGravity.percentChordOperatingEmptyWeightCG = ((CenterOfGravity.CG_X_4-x_cbar)/(C_bar*12))*100;

%% Operating Empty + Passenger
%%
Sum_Moment_X_5 = M_Nacelle1_x +M_Nacelle2_x +M_Wing1_x+M_Wing2_x +M_Fueslage_x +M_Vertical_Tail_x+M_Horizontal_Tail_x +M_Payload_x +M_Flight_Attendant_x +M_Pilots_x  +M_Flight_Controls_x+M_Pilot_Seats_x +M_Galley_1_x +M_Laventory_1_x +M_Passengers_Seats_x +M_Laventory_2_x +M_Ecu_x +M_Fire_Proection_x + M_EMER_x + M_APU_x+1; 
Sum_Moment_y_5 = M_Nacelle1_y +M_Nacelle2_y +M_Wing1_y+M_Wing2_y +M_Galley_1_y +M_Laventory_1_y +M_Laventory_2_y+1 ;
Sum_Moment_z_5 = M_Nacelle1_z +M_Nacelle2_z +M_Vertical_Tail_z+M_Horizontal_Tail_z +M_Flight_Controls_z +M_Galley_1_z +M_APU_z+1;

CenterOfGravity.CG_X_5 = Sum_Moment_X_5 / OE_Passengers;
CG_Y_5 = Sum_Moment_y_5 / OE_Passengers;
CG_Z_5 = Sum_Moment_z_5 / OE_Passengers;

CenterOfGravity.percentChordOperatingEmptyPassengerWeightCG = ((CenterOfGravity.CG_X_5-x_cbar)/(C_bar*12))*100;
end