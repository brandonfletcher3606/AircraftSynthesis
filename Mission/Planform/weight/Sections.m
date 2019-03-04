classdef Sections < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%% Inputs From GD
        inputs
%     wingArea                   %trapezoidal wing area [ft^2]
%     wingSpan
%     wingFuelWeight             %[lbf]
%     aspectRatio                  %[-]
%     sweep                        %use [rad] not [°]
%     dynamicPressure = 230;             %[lbf/ft^2]
%     dynamicPressureMax = 235.7;
%     taper                       %[-]
%     thicknessRatio
%     loadFactor
%     takeoffWeight = 87650;             %[lbf]
%     seaLevelMaxVelocity      %[KEAS] (Equivalent Airspeed in Knots)
%     horizontalTailArea
%     sweepHorizontalTail
%     aspectRatioHorizontalTail
%     taperHorizontalTail
%     lengthHorizontalTail
%     spanHorizontalTail
%     maxThicknessHorizontalTail
%     verticalTailArea
%     sweepVerticalTail
%     aspectRatioVerticalTail
%     taperVerticalTail
%     spanVerticalTail
%     maxThicknessVerticalTail
%     wettedFuselageArea
%     fuselageLength                      %length of fuselage structure
%     fuselageWidth                     %averaged from 14 and 25 ft
%     cabinVolume
%     cabinPressureDifferential           %Gudmunsson book approximates this at 8.
%     maxLandingLoad
%     mainStrutLength
%     noseStrutLength
%     nacelleWeight
%     fuelQuantity
%     fuelTankQuantity
%     uninstalledAvionicsWeight           % Uninstalled avionics weights, lb (typically = 800 - 1400 lb)
%     predictionACAnitIceWeight

    %% INPUTS from RAYMER

%     controlSurfaceWingArea % control surface (wing-mounted), ft^2
%     Kuht % for unit (all moving) horizontal tail
%     horizontalTailSpan % horizontal tail span, ft
%     tailLength % tail length; wing quarter-MAC to tail quarter-MAC, ft
%     Ky % aircraft pitching radius of gyration, ft (approx. 0.3L_t)
%     elevatorArea % elevator area, ft
%     horizontalTailHeight % horizontal tail height above fuselage
%     verticalTailHeight % vertical tail height above fuselage
%     Kz % aircraft yawing radius of gyration, ft (approx. L_t) 
%     Kdoor % 1 if no cargo door, check book for further door values 
%     Klg % 1.12 if fuselage-mounted main landing gear, if otherwise 1.0
%     Kws
%     liftOverDrag % L/D
%     landingGrossWeight =  83267.5; % landing design gross weight, lb
%     ultimateLandingLoadFactor % ultimate landing load factor
%     mainWheels % number of main wheels 
%     mainGearStruts % number of main gear shock struts
%     Vstall
%     Knp % 1.15 for kneeling gear; = 1.0 otherwise
%     Kmp % 1.126 for kneeling gear; = 1.0 otherwise  
%     noseWheels % number of nose wheels
%     Kng % 1.017 for pylon-mounted nacelle; = 1.0 otherwise
%     nacelleLength % nacelle length, ft
%     nacelleWidth % nacelle width, ft
%     wettedNacelleArea % nacelle wetted area, ft^2
%     numberEngines% number of engines 
%     engineToCockpitLength % length from engine front to cockpit -- total if multiengine, ft
%     engineWeight % engine weight, each lb.. using 90% of nacelle weight
%     fuelVolume % total fuel volume, gal
%     integralTanksVolume % integral tanks volume, gal
%     Vp % self-sealing "protected" tanks volume, gal
%     numberFuelTanks % number of fuel tanks
%     Nf % number of functions performed by controls (typically 4-7)
%     Nm % number of mechanical functions (typically 0-2)
%     controlSurfacesArea % total area of control surfaces, ft^2
%     Iy % yawing moment of inertia, lb-ft^2
%     Kr % 1.133 if reciprocating engine; = 1.0 otherwise
%     Ktp% 0.793 if turboprop; = 1.0 otherwise
%     numberCrew % number of crew 
%     Lf
%     Rkva% system electrical rating, kv * A (typically 40-60) 
%     electricalRoutingDistance% (*subject to change due to distance*) electrical routing distance, generators to avionics to cockpit, ft
%     Ngen % number of generators (typically = N_en)
%     cargoWeight% max cargo weight, lb
%     Sf % fuselage wetted area, ft^2
%     numberCrewAndPassengers% Number of crew and passangers
%     Vpr % volume of pressurized section, ft^3
%     uninstalledAPU % lbs uninstalled 
% 
%     %% INPUTS FROM ROSKAM
%     fuelWeight                             % Weight of the Fuel in lbs
%     maxZeroFuelWeight  % Maximum Zero Fuel Weight in lbs
%     takeoffVelocity                       % Take-Off Speed
%     diveVelocity                         % Design dive speed in KEAS (Page 37)
%     highestMachNumber                       % Allowable Range for GD Method Equations: 0.4 to 0.8
%     maxThicknessRootChordHorizontalTail        % Maximum thickness of Horizontal Tail root chord in feet
%     cBar                                   % Mean Geometric Chord of the Wing in Feet
%     zh                                          % Distance from root chord of vertical tail to where the horizontal tail is mounted
%     verticalTailSpan                         % Vertical Tail Span
%     zhbv                    % Zh / vertical tail span (28.66 ft)
%     rudderArea                             % Rudder Area in feet^2
%     SrSv            % Ratio of Rudder to Vertical Tail Area
%     sweepVerticalTailHalf                 % Sweep of the Vertical Tail at the Half Chord in degrees
%     fuselageHeight                             % Height of the Fuselage;
%     SUMwfhf = 39;       % Sum of width of fuselage (25 ft) and the height of the fuselage (14 ft
%     P2                                          % Maximum static pressure at engine compressor face in psi . Value range from 15 to 50 psi
%     takeoffThrust                          % Total Required Take-off Thrust
%     numberInlets                               % number of Inlets
%     inletsArea                               % Area of Inlets
%     InletDiameter                             % Diameter of Inlets (Average of Front and Rear Diamters 6 and 3 respectively)
%     emptyWeight                            % Empty Weight
%     fuelFlowTakeoff                        % Fuel Flow at take-off in lbs/sec
%     numberPassengers                          % number of passengers
%     passengerCabinVolume                 % volume of passenger cabin
%     cabinLength                                % length of passenger cabin
%     freightFloorArea                          % Area of freight floor
%     flightDeckCrew                              % Number of Flight Deck Crew
%     cabinCrew                                  % Number of Cabin Crew
%     Klav                                     %  For Long Range
%     Kbuf                                     % For Short range
%     Pc                                        % Ultimate cabin pressure
%     range                                  % Max Range
%     numberPilots                               % Number of Pilots
%     Ncr               % Number of crew members
    end 
    
    methods
        function obj = Sections()
        end
        function capture(self,gd,pd)
            %% Inputs From GD
            self.inputs.wingArea = gd.wing.s;                    %trapezoidal wing area [ft^2]
            self.inputs.wingSpan = gd.wing.b;
            self.inputs.wingFuelWeight = self.fuel;             %[lbf]
            self.inputs.aspectRatio = gd.wing.AR;                  %[-]
            self.inputs.sweep = gd.wing.mgcSweep;                        %use [rad] not [°]
            self.inputs.dynamicPressure = 230;             %[lbf/ft^2]
            self.inputs.dynamicPressureMax = 235.7;
            self.inputs.taper = gd.wing.taperRatio;                       %[-]
            self.inputs.thicknessRatio= gd.wing.thicknessRatio;
            self.inputs.loadFactor = pd.loadFactor;
            self.inputs.takeoffWeight = 87650;             %[lbf]
            self.inputs.seaLevelMaxVelocity = pd.seaLevelMaxVelocity;      %[KEAS] (Equivalent Airspeed in Knots)
            self.inputs.horizontalTailArea = gd.horizontalTail.s;
            self.inputs.sweepHorizontalTail = deg2rad(gd.horizontalTail.sweepAngle);
            self.inputs.aspectRatioHorizontalTail = gd.horizontalTail.AR;
            self.inputs.taperHorizontalTail = gd.horizontalTail.taperRatio;
            self.inputs.lengthHorizontalTail = gd.horizontalTail.dist2HT;
            self.inputs.spanHorizontalTail = gd.horizontalTail.b;
            self.inputs.maxThicknessHorizontalTail = gd.horizontalTail.thicknessRatio;
            self.inputs.verticalTailArea = gd.verticalTail.s;
            self.inputs.sweepVerticalTail = deg2rad(gd.verticalTail.sweepAngle);
            self.inputs.aspectRatioVerticalTail = gd.verticalTail.AR;
            self.inputs.taperVerticalTail = gd.verticalTail.taperRatio;
            self.inputs.spanVerticalTail = gd.verticalTail.b;
            self.inputs.maxThicknessVerticalTail = gd.verticalTail.thicknessRatio;
            self.inputs.wettedFuselageArea = gd.fuselage.wettedArea;
            self.inputs.fuselageLength = gd.fuselage.length;                      %length of fuselage structure
            self.inputs.fuselageWidth = (gd.fuselage.diameterLong+gd.fuselage.diameterShort)/2;                     %averaged from 14 and 25 ft
            self.inputs.cabinVolume = gd.fuselage.volume;
            self.inputs.cabinPressureDifferential = gd.fuselage.cabinPressure;           %Gudmunsson book approximates this at 8.
            self.inputs.maxLandingLoad = pd.maxLandingLoad;
            self.inputs.mainStrutLength = gd.fuselage.mainGearStrutLength;
            self.inputs.noseStrutLength = gd.fuselage.noseGearStrutLength;
            self.inputs.nacelleWeight = 1307.259;
            self.inputs.fuelQuantity = self.fuel/6.7;
            self.inputs.fuelTankQuantity = self.fuel/6.7;
            self.inputs.uninstalledAvionicsWeight = 1000;           % Uninstalled avionics weights, lb (typically = 800 - 1400 lb)
            self.inputs.predictionACAnitIceWeight = 700;

            %% INPUTS from RAYMER

            self.inputs.controlSurfaceWingArea = 60; % control surface (wing-mounted), ft^2
            self.inputs.Kuht = gd.horizontalTail.kuht; % for unit (all moving) horizontal tail
            self.inputs.horizontalTailSpan = gd.horizontalTail.b; % horizontal tail span, ft
            self.inputs.tailLength = gd.horizontalTail.dist2HT ; % tail length; wing quarter-MAC to tail quarter-MAC, ft
            self.inputs.Ky =gd.horizontalTail.ky; % aircraft pitching radius of gyration, ft (approx. 0.3L_t)
            self.inputs.elevatorArea = gd.horizontalTail.elevatorArea; % elevator area, ft
            self.inputs.horizontalTailHeight =gd.horizontalTail.horizontalTailHeight; % horizontal tail height above fuselage
            self.inputs.verticalTailHeight = gd.verticalTail.verticalTailHeight; % vertical tail height above fuselage
            self.inputs.Kz = gd.verticalTail.dist2VT; % aircraft yawing radius of gyration, ft (approx. L_t) 
            self.inputs.Kdoor = gd.horizontalTail.kdoor; % 1 if no cargo door, check book for further door values 
            self.inputs.Klg = gd.horizontalTail.klg; % 1.12 if fuselage-mounted main landing gear, if otherwise 1.0
            self.inputs.Kws = 0.75*((1+2*self.inputs.taper)/(1+self.inputs.taper))*(self.inputs.wingSpan*tan(self.inputs.sweep/self.inputs.fuselageLength));
            self.inputs.liftOverDrag = pd.liftOverDrag; % L/D
            self.inputs.landingGrossWeight =  83267.5; % landing design gross weight, lb
            self.inputs.ultimateLandingLoadFactor = pd.ultimateLandingLoadFactor; % ultimate landing load factor
            self.inputs.mainWheels = gd.fuselage.numberOfMainWheels; % number of main wheels 
            self.inputs.mainGearStruts = gd.fuselage.numberOfMainGearStruts; % number of main gear shock struts
            self.inputs.Vstall = pd.stallVelocity;
            self.inputs.Knp = gd.fuselage.knp; % 1.15 for kneeling gear; = 1.0 otherwise
            self.inputs.Kmp = gd.fuselage.kmp; % 1.126 for kneeling gear; = 1.0 otherwise  
            self.inputs.noseWheels = gd.fuselage.numberOfNoseWheels; % number of nose wheels
            self.inputs.Kng = gd.fuselage.kng; % 1.017 for pylon-mounted nacelle; = 1.0 otherwise
            self.inputs.nacelleLength =gd.engine.lengthActual; % nacelle length, ft
            self.inputs.nacelleWidth = gd.engine.nacelleFrontDiameter; % nacelle width, ft
            self.inputs.wettedNacelleArea = gd.engine.wettedNacelleArea; % nacelle wetted area, ft^2
            self.inputs.numberEngines = gd.engine.numberOfEngines; % number of engines 
            self.inputs.engineToCockpitLength = gd.engine.engineToCockpitLength; % length from engine front to cockpit -- total if multiengine, ft
            self.inputs.engineWeight = .9*1307; % engine weight, each lb.. using 90% of nacelle weight
            self.inputs.fuelVolume = self.fuel/6.7; % total fuel volume, gal
            self.inputs.integralTanksVolume = gd.engine.integralTanksVolume; % integral tanks volume, gal
            self.inputs.Vp =0; % self-sealing "protected" tanks volume, gal
            self.inputs.numberFuelTanks  = gd.engine.numberOfFuelTanks; % number of fuel tanks
            self.inputs.Nf = 5; % number of functions performed by controls (typically 4-7)
            self.inputs.Nm = 2; % number of mechanical functions (typically 0-2)
            self.inputs.controlSurfacesArea = 575.2; % total area of control surfaces, ft^2
            self.inputs.Iy = 503.6; % yawing moment of inertia, lb-ft^2
            self.inputs.Kr = gd.engine.kr; % 1.133 if reciprocating engine; = 1.0 otherwise
            self.inputs.Ktp = gd.engine.ktp; % 0.793 if turboprop; = 1.0 otherwise
            self.inputs.numberCrew = pd.numberOfCrew; % number of crew 
            self.inputs.Lf = pd.lf; 
            self.inputs.Rkva = gd.fuselage.rkva; % system electrical rating, kv * A (typically 40-60) 
            self.inputs.electricalRoutingDistance =  gd.fuselage.electricalRoutingDistance; % (*subject to change due to distance*) electrical routing distance, generators to avionics to cockpit, ft
            self.inputs.Ngen = self.inputs.numberEngines; % number of generators (typically = N_en)
            self.inputs.cargoWeight = self.payload; % max cargo weight, lb
            self.inputs.Sf = self.inputs.wettedFuselageArea; % fuselage wetted area, ft^2
            self.inputs.numberCrewAndPassengers = pd.cabinCrewAndPassenger; % Number of crew and passangers
            self.inputs.Vpr = gd.fuselage.volume/2; % volume of pressurized section, ft^3
            self.inputs.uninstalledAPU = 350; % lbs uninstalled 

            %% INPUTS FROM ROSKAM
            self.inputs.fuelWeight = self.fuel;                              % Weight of the Fuel in lbs
            self.inputs.maxZeroFuelWeight = self.takeoff - self.fuel;  % Maximum Zero Fuel Weight in lbs
            self.inputs.takeoffVelocity =  128.88;                       % Take-Off Speed
            self.inputs.diveVelocity = pd.diveVelocity;                         % Design dive speed in KEAS (Page 37)
            self.inputs.highestMachNumber = pd.cruiseMach;                        % Allowable Range for GD Method Equations: 0.4 to 0.8
            self.inputs.maxThicknessRootChordHorizontalTail = gd.horizontalTail.thicknessRatio;        % Maximum thickness of Horizontal Tail root chord in feet
            self.inputs.cBar = gd.wing.mgc;                                    % Mean Geometric Chord of the Wing in Feet
            self.inputs.zh = 5;                                          % Distance from root chord of vertical tail to where the horizontal tail is mounted
            self.inputs.verticalTailSpan = gd.verticalTail.b;                         % Vertical Tail Span
            self.inputs.zhbv =  gd.verticalTail.zhbv;                    % Zh / vertical tail span (28.66 ft)
            self.inputs.rudderArea = gd.verticalTail.rudderArea;                             % Rudder Area in feet^2
            self.inputs.SrSv = gd.verticalTail.srsv;            % Ratio of Rudder to Vertical Tail Area
            self.inputs.sweepVerticalTailHalf =  gd.verticalTail.sweepAngle;                  % Sweep of the Vertical Tail at the Half Chord in degrees
            self.inputs.fuselageHeight = gd.fuselage.diameterShort;                             % Height of the Fuselage;
            self.inputs.SUMwfhf = 39;        % Sum of width of fuselage (25 ft) and the height of the fuselage (14 ft
            self.inputs.P2 = gd.engine.p2;                                          % Maximum static pressure at engine compressor face in psi . Value range from 15 to 50 psi
            self.inputs.takeoffThrust = 27172;                           % Total Required Take-off Thrust
            self.inputs.numberInlets = gd.engine.numberOfEngines;                                % number of Inlets
            self.inputs.inletsArea = pi*power(gd.engine.nacelleFrontDiameter/2,2);                               % Area of Inlets
            self.inputs.InletDiameter = gd.engine.nacelleFrontDiameter;                             % Diameter of Inlets (Average of Front and Rear Diamters 6 and 3 respectively)
            self.inputs.emptyWeight =  48333;                            % Empty Weight
            self.inputs.fuelFlowTakeoff = 6.281;                         % Fuel Flow at take-off in lbs/sec
            self.inputs.numberPassengers = pd.numberOfPassenger;                          % number of passengers
            self.inputs.passengerCabinVolume = gd.fuselage.volume/2;                 % volume of passenger cabin
            self.inputs.cabinLength = gd.fuselage.length;                                % length of passenger cabin
            self.inputs.freightFloorArea = gd.fuselage.freightFloorArea;                          % Area of freight floor
            self.inputs.flightDeckCrew = pd.flightDeckCrew;                              % Number of Flight Deck Crew
            self.inputs.cabinCrew = pd.cabinCrew;                                   % Number of Cabin Crew
            self.inputs.Klav = pd.klav;                                     %  For Long Range
            self.inputs.Kbuf = pd.kbuf;                                     % For Short range
            self.inputs.Pc = gd.fuselage.ultimateCabinPressure;                                        % Ultimate cabin pressure
            self.inputs.range = pd.cruiseDistance;                                   % Max Range
            self.inputs.numberPilots = pd.numberOfCrew;                               % Number of Pilots
            self.inputs.Ncr = pd.cabinCrew + pd.flightDeckCrew;               % Number of crew members            
        end
    end
end