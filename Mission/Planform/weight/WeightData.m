classdef WeightData < Sections
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        takeoff = 87650
        payload = 22000
        fuel = 15787
        crew = 1530
    end
    properties (SetAccess = private)
        empty
        operatingEmpty
        tfo
        gudmundsson
        raymer
        roskam
        average
    end
    
    methods
        function obj = WeightData()
        end
        function calculate(self,ged,pd)
            self.capture(ged,pd);
            self.gdWeightCalculate();
            self.raymerWeightCalculate();
            self.roskamWeightCalculate();
            self.averageWeightCalculate();
            self.empty = self.average.emptyWeight;
            self.takeoff = self.empty+self.payload+self.fuel+self.crew;
            self.operatingEmpty = self.takeoff - self.payload - self.fuel;
            self.tfo = 0.005 * self.takeoff;
        end
        function gdWeightCalculate(self)
            raymerwingWeight = 2*0.036*power(self.inputs.wingArea,0.758)*power(self.inputs.wingFuelWeight,0.0035)*...
                power((self.inputs.aspectRatio/power(cos(deg2rad(self.inputs.sweep)),2)),0.6)*power(self.inputs.dynamicPressure,0.006)*power(self.inputs.taper,0.04)*...
                power(100*self.inputs.thicknessRatio/cos(deg2rad(self.inputs.sweep)),-0.3)*power(self.inputs.loadFactor*self.inputs.takeoffWeight,0.49);
            nikolaiwingWeight = 2*96.948*power(power(self.inputs.loadFactor*self.inputs.takeoffWeight/10^5,0.65)*power(self.inputs.aspectRatio/...
                power(cos(deg2rad(self.inputs.sweep)),2),0.57)*power(self.inputs.wingArea/100,0.61)*power((1+self.inputs.taper)/...
                (2*self.inputs.thicknessRatio),0.36)*sqrt(1+self.inputs.seaLevelMaxVelocity/500),0.993);
            self.gudmundsson.raymer.horizontalTailWeight = 0.016*power(self.inputs.loadFactor*self.inputs.takeoffWeight,0.414)*self.inputs.dynamicPressure^0.168*power(self.inputs.horizontalTailArea,0.896)*...
                power(100*self.inputs.thicknessRatio/cos(deg2rad(self.inputs.sweepHorizontalTail)),-0.12)*power(self.inputs.aspectRatioHorizontalTail/cos(deg2rad(self.inputs.sweepHorizontalTail))^...
                2,0.043)*power(self.inputs.taperHorizontalTail,-0.02);
            self.gudmundsson.nikolai.horizontalTailWeight = 127*power(power(self.inputs.loadFactor*self.inputs.takeoffWeight/10^5,0.87)*power(self.inputs.horizontalTailArea/100,1.2)*...
                power(self.inputs.lengthHorizontalTail/10,0.483)*sqrt(self.inputs.spanHorizontalTail/self.inputs.maxThicknessHorizontalTail),0.458);
            self.gudmundsson.raymer.verticalTailWeight = 0.073*(1+0.2)*power(self.inputs.loadFactor*self.inputs.takeoffWeight,0.376)*power(self.inputs.dynamicPressure,0.122)*power(self.inputs.verticalTailArea,0.873)*...
                power(100*self.inputs.thicknessRatio/cos(deg2rad(self.inputs.sweepVerticalTail)),-0.49)*power(self.inputs.aspectRatioVerticalTail/cos(deg2rad(self.inputs.sweepVerticalTail))^2,0.357)*...
                power(self.inputs.taperVerticalTail,0.039);
            self.gudmundsson.nikolai.verticalTailWeight = 98.5*(power(self.inputs.loadFactor*self.inputs.takeoffWeight/10^5,0.87)*power(self.inputs.verticalTailArea/100,1.2)*sqrt(self.inputs.spanVerticalTail/self.inputs.maxThicknessVerticalTail));

            raymerfuselageWeight = 0.052*power(self.inputs.wettedFuselageArea,1.086)*power(self.inputs.loadFactor*self.inputs.takeoffWeight,0.177)*...
                power(self.inputs.lengthHorizontalTail,-0.051)*power(self.inputs.fuselageLength/self.inputs.fuselageWidth,-0.072)*power(self.inputs.dynamicPressure,0.241)+11.9*power(self.inputs.cabinVolume*...
                self.inputs.cabinPressureDifferential,0.271);

            nikolaifuselageWeight = 200*power(power(self.inputs.loadFactor*self.inputs.takeoffWeight/10^5,0.286)*power(self.inputs.fuselageLength/10,0.857)*...
                (self.inputs.fuselageWidth+self.inputs.fuselageLength)/10*power(self.inputs.seaLevelMaxVelocity/100,0.338),1.1);
            self.gudmundsson.raymer.mainLandingGearWeight = 0.095*power(self.inputs.ultimateLandingLoadFactor*self.inputs.maxLandingLoad,0.768)*power(self.inputs.mainStrutLength/12,0.409);
            self.gudmundsson.nikolai.mainLandingGearWeight = 0.054*power(self.inputs.ultimateLandingLoadFactor*self.inputs.maxLandingLoad,0.684)*power(self.inputs.mainStrutLength/12,0.601);
            self.gudmundsson.raymer.noseLandingGearWeight = 0.125*power(self.inputs.ultimateLandingLoadFactor*self.inputs.maxLandingLoad,0.566)*power(self.inputs.noseStrutLength/12,0.845);

            raymertotalLandingGearWeight = self.gudmundsson.raymer.mainLandingGearWeight + self.gudmundsson.raymer.noseLandingGearWeight;
            nikolaitotalLandingGearWeight = 3*self.gudmundsson.nikolai.mainLandingGearWeight ;

            self.gudmundsson.raymer.nacellePowerPlantWeight = 2.575*power(self.inputs.nacelleWeight,0.922)*2;
            self.gudmundsson.nikolai.nacellePowerPlantWeight = 2.575*power(self.inputs.nacelleWeight,0.922)*2;


            self.gudmundsson.raymer.fuelSystemWeight = 2.49*power(self.inputs.fuelQuantity,0.726)*power(self.inputs.fuelQuantity/(self.inputs.fuelQuantity+self.inputs.fuelTankQuantity),0.363)*...
                power(self.inputs.numberFuelTanks,0.242)*power(2,0.157);
            self.gudmundsson.nikolai.fuelSystemWeight   = 2.49*power(power(self.inputs.fuelQuantity,0.6)*power(self.inputs.fuelQuantity/(self.inputs.fuelQuantity+self.inputs.fuelTankQuantity),0.3)*...
                power(self.inputs.numberFuelTanks,0.2)*power(2,0.13),1.21);
            self.gudmundsson.raymer.flightControlsWeight = 0.053*power(self.inputs.fuselageLength,1.536)*power(self.inputs.wingSpan,0.371)*power(self.inputs.loadFactor*...
                self.inputs.takeoffWeight*10^(-4),0.8);

            self.gudmundsson.nikolai.flightControlsWeightP= 1.08*power(self.inputs.takeoffWeight,0.7);


            self.gudmundsson.raymer.hydraulicsWeight = 0.001*self.inputs.takeoffWeight; %No formula from nikolai
            self.gudmundsson.raymer.avionicsWeight   = 2.117*power(self.inputs.uninstalledAvionicsWeight,0.933);
            self.gudmundsson.nikolai.avionicsWeight   = 2.117*power(self.inputs.uninstalledAvionicsWeight,0.933);
            self.gudmundsson.raymer.electricalWeight = 12.57*power(self.gudmundsson.raymer.fuelSystemWeight+self.gudmundsson.raymer.avionicsWeight,0.51);
            self.gudmundsson.nikolai.electricalWeight = 12.57*power(self.gudmundsson.nikolai.fuelSystemWeight+self.gudmundsson.nikolai.avionicsWeight,0.51);
            self.gudmundsson.raymer.iceACWeight      = 0.265*power(self.inputs.takeoffWeight,0.52)*power(107,0.68)*power(self.inputs.predictionACAnitIceWeight,...
                0.17)*power(0.82,0.08); %107 is the number of occupants, 0.82 is the Mach number
            self.gudmundsson.nikolai.iceACWeight     = 0.265*power(self.inputs.takeoffWeight,0.52)*power(107,0.68)*power(self.inputs.predictionACAnitIceWeight,...
                0.17)*power(0.82,0.08); %107 is the number of occupants, 0.82 is the Mach number
            self.gudmundsson.raymer.furnishingWeight= 0.0582*self.inputs.takeoffWeight-65;
            self.gudmundsson.nikolai.furnishingWeight= 34.5*7*power(self.inputs.dynamicPressureMax,0.25);

            self.gudmundsson.raymer.structuralWeight = raymerwingWeight + self.gudmundsson.raymer.horizontalTailWeight + self.gudmundsson.raymer.verticalTailWeight + raymerfuselageWeight + self.gudmundsson.raymer.nacellePowerPlantWeight + raymertotalLandingGearWeight;
            self.gudmundsson.nikolai.structuralWeight = nikolaiwingWeight + self.gudmundsson.nikolai.horizontalTailWeight + self.gudmundsson.nikolai.verticalTailWeight + nikolaifuselageWeight + self.gudmundsson.nikolai.nacellePowerPlantWeight + nikolaitotalLandingGearWeight;

            self.gudmundsson.raymer.powerplantWeight = self.gudmundsson.raymer.nacellePowerPlantWeight + self.gudmundsson.raymer.fuelSystemWeight;
            self.gudmundsson.nikolai.powerplantWeight = self.gudmundsson.nikolai.nacellePowerPlantWeight + self.gudmundsson.nikolai.fuelSystemWeight;

            self.gudmundsson.raymer.fixedEquipmentWeight = self.gudmundsson.raymer.flightControlsWeight + self.gudmundsson.raymer.hydraulicsWeight + self.gudmundsson.raymer.avionicsWeight + self.gudmundsson.raymer.electricalWeight +self.gudmundsson.raymer.iceACWeight +  self.gudmundsson.raymer.furnishingWeight;
            self.gudmundsson.nikolai.fixedEquipmentWeight = self.gudmundsson.nikolai.flightControlsWeightP + self.gudmundsson.nikolai.avionicsWeight + self.gudmundsson.nikolai.electricalWeight + self.gudmundsson.nikolai.iceACWeight +self.gudmundsson.nikolai.furnishingWeight;

            self.gudmundsson.raymer.emptyWeight = self.gudmundsson.raymer.structuralWeight + self.gudmundsson.raymer.powerplantWeight + self.gudmundsson.raymer.fixedEquipmentWeight;
            self.gudmundsson.nikolai.emptyWeight = self.gudmundsson.nikolai.structuralWeight + self.gudmundsson.nikolai.powerplantWeight + self.gudmundsson.nikolai.fixedEquipmentWeight;

            self.gudmundsson.raymer.wingWeight = raymerwingWeight ;
            self.gudmundsson.nikolai.wingWeight = nikolaiwingWeight;

            self.gudmundsson.raymer.fuselageWeight = raymerfuselageWeight ;
            self.gudmundsson.nikolai.fuselageWeight =nikolaifuselageWeight ;

            self.gudmundsson.raymer.totalLandingGearWeight = raymertotalLandingGearWeight ;
            self.gudmundsson.nikolai.totalLandingGearWeight = nikolaitotalLandingGearWeight;

            self.gudmundsson.raymer.empennageWeight = self.gudmundsson.raymer.horizontalTailWeight + self.gudmundsson.raymer.verticalTailWeight ;
            self.gudmundsson.nikolai.empennageWeight = self.gudmundsson.nikolai.horizontalTailWeight + self.gudmundsson.nikolai.verticalTailWeight ;
        end
        function raymerWeightCalculate(self)
            W_wing = (0.0051*power(self.inputs.takeoffWeight*self.inputs.loadFactor,0.557))*power(self.inputs.wingArea,0.649)*power(self.inputs.aspectRatio,0.5)*(power(self.inputs.thicknessRatio,-0.4))*power((1+self.inputs.taper),0.1)*(power(cosd(self.inputs.sweep),-1))*power(self.inputs.controlSurfaceWingArea,0.1);
            W_horizontal_tail = 0.0379*self.inputs.Kuht*(power(1+(self.inputs.fuselageWidth/self.inputs.horizontalTailSpan),-0.25)*power(self.inputs.takeoffWeight,0.639)*power(self.inputs.loadFactor,0.10)*(power(self.inputs.horizontalTailArea,0.75))*power(self.inputs.tailLength,-1)*power(self.inputs.Ky,0.704)*(power(cos(deg2rad(self.inputs.sweepHorizontalTail)),-1))*power(self.inputs.aspectRatioHorizontalTail,0.166)*(power(1+(self.inputs.elevatorArea/self.inputs.horizontalTailArea),0.1)));
            W_vertical_tail = 0.0026*power((1+(self.inputs.horizontalTailHeight/self.inputs.verticalTailHeight)),0.225)*power(self.inputs.takeoffWeight,0.556)*power(self.inputs.loadFactor,0.536)*power(self.inputs.tailLength,-0.5)*power(self.inputs.verticalTailArea,0.5)*power(self.inputs.Kz,0.875)*power((cosd(self.inputs.sweepVerticalTail)),-1)*power(self.inputs.aspectRatioVerticalTail,0.35)*power(self.inputs.thicknessRatio,-0.5);
            W_fuselage = 0.3280*self.inputs.Kdoor*self.inputs.Klg*(power(self.inputs.takeoffWeight*self.inputs.loadFactor,0.5))*power(self.inputs.fuselageLength,0.25)*power(self.inputs.wettedFuselageArea,0.302)*power((1+self.inputs.Kws),0.04)*(power(self.inputs.liftOverDrag,0.1));
            W_main_landing_gear = 0.0106*self.inputs.Kmp*power(self.inputs.landingGrossWeight,0.888)*power(self.inputs.ultimateLandingLoadFactor,-0.25)*power(self.inputs.mainStrutLength,0.4)*power(self.inputs.noseWheels,-0.321)*power(self.inputs.mainGearStruts,-0.5)*power(self.inputs.Vstall,0.1);
            W_nose_landing_gear = 0.032*self.inputs.Knp*power(self.inputs.landingGrossWeight,0.646)*power(self.inputs.ultimateLandingLoadFactor,0.2)*power(self.inputs.noseStrutLength,0.5)*power(self.inputs.noseWheels,0.45);
            W_nacelle_group = 0.6724*self.inputs.Kng*power(self.inputs.nacelleLength,0.1)*power(self.inputs.nacelleWidth,0.294)*power(self.inputs.loadFactor,0.119)*power(self.inputs.nacelleWeight,0.611)*power(self.inputs.numberEngines,0.984)*power(self.inputs.wettedNacelleArea,0.224);
            W_engine_controls = 5*self.inputs.numberEngines + (.80*self.inputs.engineToCockpitLength);
            W_starter = 49.19*power(((self.inputs.numberEngines*self.inputs.engineWeight)/1000),0.541);
            W_fuel_system = 2.405*power(self.inputs.fuelVolume,0.606)*power((1+(self.inputs.integralTanksVolume/self.inputs.fuelVolume)),-1)*((1+(self.inputs.Vp/self.inputs.fuelVolume)))*power(self.inputs.numberFuelTanks,0.5);
            W_flight_controls = 145.9*power(self.inputs.Nf,0.554)*power((1+(self.inputs.Nm/self.inputs.Nf)),-1)*power(self.inputs.controlSurfacesArea,0.2)*power((self.inputs.Iy*10^-6),0.07);
            W_instruments = 4.509*self.inputs.Kr*self.inputs.Ktp*power(self.inputs.numberCrew,0.541)*self.inputs.numberEngines*power((self.inputs.Lf+self.inputs.wingSpan),0.5);
            W_hydraulics = 0.2673*self.inputs.Nf*power((self.inputs.Lf+self.inputs.wingSpan),0.5);
            W_electrical = 7.921*power(self.inputs.Rkva,0.782)*power(self.inputs.electricalRoutingDistance,0.346)*power(self.inputs.Ngen,0.1);
            W_avionics = 1.73*power(self.inputs.uninstalledAvionicsWeight,0.983);
            W_furnishing = 0.0577*power(self.inputs.numberCrew,0.1)*power(self.inputs.cargoWeight,0.393)*power(self.inputs.Sf,0.75);
            W_air_conditioning = 62.36*power(self.inputs.numberCrewAndPassengers,0.25)*power(self.inputs.Vpr/1000,0.604)*power(self.inputs.uninstalledAvionicsWeight,0.10);
            W_anti_ice = 0.002*self.inputs.takeoffWeight;
            W_handling_gear = (3.0*10^-4)*self.inputs.takeoffWeight;

            wingWeight = W_wing*2;
            self.raymer.horizontalTailWeight = W_horizontal_tail;
            self.raymer.verticalTailWeight = W_vertical_tail;
            fuselageWeight = W_fuselage;
            self.raymer.mainLandingGearWeight = W_main_landing_gear*2;
            self.raymer.noseLandingGearWeight = W_nose_landing_gear;
            totalLandingGearWeight = self.raymer.mainLandingGearWeight + self.raymer.noseLandingGearWeight;
            self.raymer.nacelleWeight = W_nacelle_group;
            self.raymer.engineControlsWeight = W_engine_controls;
            self.raymer.starterWeight = W_starter;
            self.raymer.fuelSystemWeight = W_fuel_system;
            self.raymer.flightControlsWeight = W_flight_controls;
            self.raymer.instrumentsWeight = W_instruments;
            self.raymer.hydraulicsWeight = W_hydraulics;
            self.raymer.electricalWeight = W_electrical;
            self.raymer.avionicsWeight = W_avionics;
            self.raymer.furnishingWeight = W_furnishing;
            self.raymer.airConditioningWeight = W_air_conditioning;
            self.raymer.antiIceWeight = W_anti_ice;
            self.raymer.handlingGearWeight = W_handling_gear;
            self.raymer.apuInstalledWeight = 2.2 * self.inputs.uninstalledAPU;
            %% COMPARISON STUFF

            self.raymer.structuralWeight = wingWeight + self.raymer.horizontalTailWeight + self.raymer.verticalTailWeight + fuselageWeight + self.raymer.nacelleWeight + totalLandingGearWeight;
            self.raymer.powerplantWeight =  self.raymer.nacelleWeight + self.raymer.engineControlsWeight + self.raymer.starterWeight + self.raymer.fuelSystemWeight;
            self.raymer.fixedEquipmentWeight = self.raymer.flightControlsWeight +self.raymer.instrumentsWeight +self.raymer.hydraulicsWeight +self.raymer.electricalWeight +self.raymer.avionicsWeight +self.raymer.furnishingWeight +self.raymer.airConditioningWeight +self.raymer.antiIceWeight +self.raymer.handlingGearWeight +self.raymer.apuInstalledWeight; 
            self.raymer.emptyWeight = self.raymer.structuralWeight + self.raymer.powerplantWeight + self.raymer.fixedEquipmentWeight ;
            self.raymer.wingWeight = wingWeight ;
            self.raymer.fuselageWeight = fuselageWeight ;
            self.raymer.totalLandingGearWeight = totalLandingGearWeight ;
            self.raymer.empennageWeight = self.raymer.horizontalTailWeight + self.raymer.verticalTailWeight ;
        end
        function roskamWeightCalculate(self)
            %% Structural Weight (Roskam Part V: Component Weight Method Estimation)
            % (Page 69 to 70)
            wingWeight.intialGD = (0.00428 * (self.inputs.wingArea ^ 0.48) * self.inputs.aspectRatio * (self.inputs.highestMachNumber ^ 0.43) * ((self.inputs.takeoffWeight * self.inputs.ultimateLandingLoadFactor) ^ 0.84) * self.inputs.taper ^ 0.14) / ( ((100 * self.inputs.thicknessRatio) ^ 0.76) * (cosd(self.inputs.sweep)) ^ 1.54);
            wingWeight.initialTorenbeek = 0.5*(0.0017*self.inputs.maxZeroFuelWeight) * power((self.inputs.wingSpan/cosd(self.inputs.sweep)),0.75) * (1 + power((6.3*cosd(self.inputs.sweep))/self.inputs.wingSpan,0.5)) * power(self.inputs.ultimateLandingLoadFactor,0.55) * power((self.inputs.wingSpan*self.inputs.wingArea)/(self.inputs.thicknessRatio*self.inputs.maxZeroFuelWeight*cosd(self.inputs.sweep)),0.30);
            %A1 = 0.0017*W_MZF;
            %A2 = power(b/cosd(sweepHalf),0.75);
            %A3 = (1 + power((6.3*cosd(sweepHalf))/b,0.5));
            %A4 = power(n_ult,0.55);
            %A5 = power((b*S)/(t_r*W_MZF*cosd(sweepHalf)),0.30);
            %wingWeight.initialTorenbeek = A1 * A2 * A3 * A4 * A5;
            gdwingWeight = 2*wingWeight.intialGD * 0.99; % See Roskam Part V Pages 69 to 70 (Special Notes)
            torenbeekwingWeight =  2*wingWeight.initialTorenbeek * 0.99; % See Roskam Part V Pages 69 to 70 (Special Notes)
            % ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 73 to 74)
            self.roskam.gudmundsson.horizontalTailWeight = 0.0034 * (power(self.inputs.takeoffWeight * self.inputs.ultimateLandingLoadFactor, 0.813) * power(self.inputs.horizontalTailArea, 0.584) * power(self.inputs.spanHorizontalTail/self.inputs.maxThicknessRootChordHorizontalTail, 0.033) * power(self.inputs.cBar/self.inputs.tailLength, 0.28)) ^0.915;
            self.roskam.gudmundsson.verticalTailWeight = 0.19 * (power(1 + self.inputs.zhbv, 0.5) * power(self.inputs.takeoffWeight * self.inputs.ultimateLandingLoadFactor, 0.363) * power(self.inputs.verticalTailArea, 1.089) * power(self.inputs.highestMachNumber, 0.601) * power(self.inputs.tailLength, -0.726) * power(1 + self.inputs.SrSv, 0.217) * power(self.inputs.aspectRatioVerticalTail, 0.337) * power(1+self.inputs.taperVerticalTail, 0.363) * power(cosd(self.inputs.sweepVerticalTail), -0.484))^1.014;
            K_h = 1.0; % For Fixed/Variable Incidence Stabilizers K_h = 1.0 or K_h = 1.1 respectively
            self.roskam.torenbeek.horizontalTailWeight = K_h*self.inputs.horizontalTailArea * (3.81 * (power(self.inputs.horizontalTailArea, 0.2) * self.inputs.diveVelocity) / (1000 * power(cosd(self.inputs.sweepHorizontalTail),0.5)) - 0.287);
            K_v = (1 + 0.15*((self.inputs.horizontalTailArea*self.inputs.zh)/(self.inputs.verticalTailArea*self.inputs.verticalTailSpan))); % For Fin Mounted Horizontal Tails, whereas for fuselage mounted K_h = 1.0
            self.roskam.torenbeek.verticalTailWeight = K_v*self.inputs.verticalTailArea * (3.81 * (power(self.inputs.verticalTailArea, 0.2) * self.inputs.diveVelocity) / (1000 * power(cosd(self.inputs.sweepVerticalTailHalf),0.5)) - 0.287);
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 76 to 77)
            K_inl = 1.25; % 1.25 for inlets in a buried engine installation, and 1.0 for elsewhere
            gdfuselageWeight = 10.43*power(K_inl,1.42) * power(self.inputs.dynamicPressure/100, 0.283) * power(self.inputs.takeoffWeight/1000, 0.95) * power(self.inputs.fuselageLength/self.inputs.fuselageHeight, 0.71);
            K_f = 1.08 * 1.10; % 1.08: Pressurized Fuselage, 1.07: main gear attached to fuselage, 1.10: Cargo Airplane with a Cargo Floor (The effects are multiplicative for airplanes equipped with all of the above)
            torenbeekfuselageWeight = 0.021*K_f * power((self.inputs.diveVelocity*self.inputs.tailLength)/self.inputs.SUMwfhf, 0.5) * self.inputs.wettedFuselageArea ^ 1.2;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 79 to 80)
            self.roskam.gudmundsson.nacelleWeight = 3.0*self.inputs.numberInlets*power(((self.inputs.inletsArea^0.5)*self.inputs.nacelleLength*self.inputs.P2),0.731);
            self.roskam.torenbeek.nacelleWeight = 0.055*self.inputs.takeoffThrust;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 82)
            K_gr = 1.04; % took an average between low and high wing airplanes (1.0,1.08)
            gdtotalLandingGearWeight = 62.21*power((self.inputs.takeoffWeight/1000),0.84);
            self.roskam.torenbeek.mainLandingGearWeight = K_gr*(33 + (0.04*power(self.inputs.takeoffWeight,3/4)) + 0.021*self.inputs.takeoffWeight);
            self.roskam.torenbeek.noseLandingGearWeight = K_gr*(12 + (0.06*power(self.inputs.takeoffWeight,3/4)));
            torenbeektotalLandingGearWeight = self.roskam.torenbeek.mainLandingGearWeight + self.roskam.torenbeek.noseLandingGearWeight;


            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            %% Powerplant Weight
            % (Page 85)
            self.roskam.enginesWeight = self.inputs.numberEngines*self.inputs.engineWeight;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 92)
            K_fsp = 6.44; % Constant for JP-4 (Page 91)
            self.roskam.torenbeek.fuelSystemWeight = 80 * (self.inputs.numberEngines + self.inputs.numberFuelTanks -1) + 15 * power(self.inputs.numberFuelTanks, 0.5) * power(self.inputs.fuelWeight / K_fsp, 0.333);
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 93)
            self.roskam.gudmundsson.engineControlsWeight = 88.46*power((self.inputs.fuselageLength + self.inputs.wingSpan)*self.inputs.numberEngines/100,0.294);
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 94)
            self.roskam.gudmundsson.engineStartingSystemWeight = 38.93*power(self.inputs.emptyWeight/1000,0.918);
            self.roskam.torenbeek.apsiWeight = 36*self.inputs.numberEngines*self.inputs.fuelFlowTakeoff; % accessory drives + powerplant controls + starting + ignition systems
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 95)
            self.roskam.thrustReversersWeight = 0.18*self.inputs.emptyWeight;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 96) OPTIONAL
            % self.roskam.waterInjectionWeight = (8.586 * waterWeight) / 8.35
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 96) 
            % K_osc = 0.00 for jet engines as the oil system and oil cooler weight are included in W_e
            % self.roskam.oilSystemOilCoolerWeight = K_osc * W_e;
            %% Fixed Equipment
            % (Page 99)
            K_fc = 0.64; % airplanes with powered flight controls
            self.roskam.gudmundsson.flightControlsWeight = 56.01*power((self.inputs.takeoffWeight*self.inputs.dynamicPressure/100000),0.576);
            self.roskam.torenbeek.flightControlsWeight = K_fc*power(self.inputs.takeoffWeight,2/3);
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 104)
            self.roskam.gudmundsson.instruments = self.inputs.numberPilots * (15 + 0.032*(self.inputs.takeoffWeight/1000) +self.inputs.numberEngines * (5 + 0.006*(self.inputs.takeoffWeight/1000))) + 0.15 * (self.inputs.takeoffWeight/1000) + 0.012*self.inputs.takeoffWeight;
            % self.roskam.torenbeek.regionalTransports.instrumentsAvionicsElectrionicsWeight = 0.575*power(W_e,0.556)*power(R,0.25);
            self.roskam.torenbeek.instrumentsAvionicsElectrionicsWeight = 120 + 20*self.inputs.numberEngines + 0.06*self.inputs.takeoffWeight;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 102)
            % self.roskam.gudmundsson.electricalSystemsWeight = 1163*power((self.roskam.torenbeek.fuelSystemWeight + self.roskam.gudmundsson.instruments)/1000,0.506);
            self.roskam.gudmundsson.electricalSystemsWeight = 1163*power((self.roskam.torenbeek.fuelSystemWeight + self.roskam.torenbeek.instrumentsAvionicsElectrionicsWeight)/1000,0.506);
            self.roskam.torenbeek.electricalSystemsWeight = 10.8*power(self.inputs.passengerCabinVolume,0.7)*(1-0.018*power(self.inputs.passengerCabinVolume,0.35));
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 105)
            self.roskam.gudmundsson.airConditioningPressurizationAntiIceWeight = 469* power((self.inputs.passengerCabinVolume*(self.inputs.Ncr + self.inputs.numberPassengers))/10000,0.419);  % Air Condition, Pressurization, and Anti-Ice System
            self.roskam.torenbeek.airConditioningPressurizationAntiIceWeight = 6.75*power(self.inputs.cabinLength,1.28);                   % Air Condition, Pressurization, and Anti-Ice System
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 106)
            self.roskam.gudmundsson.oxygenWeight = 7 * power(self.inputs.Ncr + self.inputs.numberPassengers, 0.702);
            self.roskam.torenbeek.oxygenWeight = 30 + 1.2*self.inputs.numberPassengers;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 107)
            self.roskam.apuWeight = (0.004 + 0.013) * self.inputs.takeoffWeight;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 108 to 109) INCLUDES OPERATIONAL ITEMS
            self.roskam.gudmundsson.furnishingWeight = 55*self.inputs.flightDeckCrew + 32*self.inputs.numberPassengers + 15*self.inputs.cabinCrew + self.inputs.Klav*power(self.inputs.numberPassengers, 1.33) + self.inputs.Kbuf*power(self.inputs.numberPassengers,1.12) + 109*power(self.inputs.numberPassengers*(1+self.inputs.Pc)/100,0.505) + 0.771*(self.inputs.takeoffWeight/1000);
            self.roskam.torenbeek.furnishingWeight = 0.211* power(self.inputs.takeoffWeight - self.inputs.fuelWeight, 0.91); % Look back over after having more detailed cg information
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 110)
            self.roskam.torenbeek.cargoWeight = 3 * self.inputs.freightFloorArea;
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 110) SEE FURNISHING WEIGHT
            % self.roskam.operationalItemsWeight = ...
            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % (Page 112)
            self.roskam.paintWeight = 0.0045*self.inputs.takeoffWeight;

            % ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            %%% COMPARISON STUFF ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            % self.roskam.gudmundsson.structuralWeight = self.roskam.gudmundsson.wingWeight + self.roskam.gudmundsson.horizontalTailWeight + self.roskam.gudmundsson.verticalTailWeight + self.roskam.gudmundsson.fuselageWeight + self.roskam.gudmundsson.nacelleWeight + self.roskam.gudmundsson.totalLandingGearWeight;
            % self.roskam.torenbeek.structuralWeight = self.roskam.torenbeek.wingWeight + self.roskam.torenbeek.horizontalTailWeight + self.roskam.torenbeek.verticalTailWeight + self.roskam.torenbeek.fuselageWeight + self.roskam.torenbeek.nacelleWeight + self.roskam.torenbeek.totalLandingGearWeight;
            % self.roskam.gudmundsson.powerPlantWeight = self.roskam.enginesWeight+self.roskam.gudmundsson.engineControlsWeight+self.roskam.gudmundsson.engineStartingSystemWeight+self.roskam.thrustReversersWeight;
            % self.roskam.torenbeek.powerPlantWeight = self.roskam.enginesWeight+self.roskam.torenbeek.fuelSystemWeight +self.roskam.torenbeek.apsiWeight+self.roskam.thrustReversersWeight;
            % self.roskam.gudmundsson.fixedEquipmentWeight = self.roskam.gudmundsson.flightControlsWeight+self.roskam.gudmundsson.instruments+self.roskam.gudmundsson.electricalSystemsWeight+self.roskam.gudmundsson.airConditioningPressurizationAntiIceWeight+self.roskam.gudmundsson.oxygenWeight+self.roskam.apuWeight+self.roskam.gudmundsson.furnishingWeight+self.roskam.paintWeight;
            % self.roskam.torenbeek.fixedEquipmentWeight = self.roskam.torenbeek.flightControlsWeight+self.roskam.torenbeek.instrumentsAvionicsElectrionicsWeight+self.roskam.torenbeek.electricalSystemsWeight+self.roskam.torenbeek.airConditioningPressurizationAntiIceWeight+self.roskam.torenbeek.oxygenWeight+self.roskam.apuWeight+self.roskam.torenbeek.furnishingWeight+self.roskam.torenbeek.cargoWeight+self.roskam.paintWeight;
            % self.roskam.gudmundsson.emptyWeight = self.roskam.gudmundsson.structuralWeight + self.roskam.gudmundsson.powerPlantWeight + self.roskam.gudmundsson.fixedEquipmentWeight;
            % self.roskam.torenbeek.emptyWeight = self.roskam.torenbeek.structuralWeight + self.roskam.torenbeek.powerPlantWeight + self.roskam.torenbeek.fixedEquipmentWeight;


            self.roskam.gudmundsson.structuralWeight = gdwingWeight + self.roskam.gudmundsson.horizontalTailWeight + self.roskam.gudmundsson.verticalTailWeight + gdfuselageWeight + self.roskam.gudmundsson.nacelleWeight + gdtotalLandingGearWeight;
            self.roskam.torenbeek.structuralWeight = torenbeekwingWeight + self.roskam.torenbeek.horizontalTailWeight + self.roskam.torenbeek.verticalTailWeight + torenbeekfuselageWeight + self.roskam.torenbeek.nacelleWeight + torenbeektotalLandingGearWeight;

            self.roskam.gudmundsson.powerplantWeight = self.roskam.enginesWeight+self.roskam.gudmundsson.engineControlsWeight+self.roskam.gudmundsson.engineStartingSystemWeight+self.roskam.thrustReversersWeight;
            self.roskam.torenbeek.powerplantWeight = self.roskam.enginesWeight+self.roskam.torenbeek.fuelSystemWeight +self.roskam.torenbeek.apsiWeight+self.roskam.thrustReversersWeight;

            self.roskam.gudmundsson.fixedEquipmentWeight = self.roskam.gudmundsson.flightControlsWeight+self.roskam.gudmundsson.instruments+self.roskam.gudmundsson.electricalSystemsWeight+self.roskam.gudmundsson.airConditioningPressurizationAntiIceWeight+self.roskam.gudmundsson.oxygenWeight+self.roskam.apuWeight+self.roskam.gudmundsson.furnishingWeight+self.roskam.paintWeight;
            self.roskam.torenbeek.fixedEquipmentWeight = self.roskam.torenbeek.flightControlsWeight+self.roskam.torenbeek.instrumentsAvionicsElectrionicsWeight+self.roskam.torenbeek.electricalSystemsWeight+self.roskam.torenbeek.airConditioningPressurizationAntiIceWeight+self.roskam.torenbeek.oxygenWeight+self.roskam.apuWeight+self.roskam.torenbeek.furnishingWeight+self.roskam.torenbeek.cargoWeight+self.roskam.paintWeight;

            self.roskam.gudmundsson.emptyWeight = self.roskam.gudmundsson.structuralWeight + self.roskam.gudmundsson.powerplantWeight + self.roskam.gudmundsson.fixedEquipmentWeight;
            self.roskam.torenbeek.emptyWeight = self.roskam.torenbeek.structuralWeight + self.roskam.torenbeek.powerplantWeight + self.roskam.torenbeek.fixedEquipmentWeight;

            self.roskam.gudmundsson.wingWeight = gdwingWeight;
            self.roskam.torenbeek.wingWeight = torenbeekwingWeight;

            self.roskam.gudmundsson.fuselageWeight = gdfuselageWeight;
            self.roskam.torenbeek.fuselageWeight =torenbeekfuselageWeight;

            self.roskam.gudmundsson.totalLandingGearWeight = gdtotalLandingGearWeight;
            self.roskam.torenbeek.totalLandingGearWeight = torenbeektotalLandingGearWeight;

            self.roskam.gudmundsson.empennageWeight = self.roskam.gudmundsson.horizontalTailWeight + self.roskam.gudmundsson.verticalTailWeight;
            self.roskam.torenbeek.empennageWeight = self.roskam.torenbeek.horizontalTailWeight + self.roskam.torenbeek.verticalTailWeight;
        end
        function averageWeightCalculate(self)
            %% Structural Weight --- GD NIKOLAI RAYMER AND ROSKAM TORENBEEK

            self.average.structuralWeight = ( self.gudmundsson.nikolai.structuralWeight + self.gudmundsson.raymer.structuralWeight + self.roskam.torenbeek.structuralWeight )/3;

            %% Powerplant Weight -- AVERAGE OF GD NIKOLAI RAYMER
            self.average.powerplantWeight = ( self.gudmundsson.nikolai.powerplantWeight + self.gudmundsson.raymer.powerplantWeight )/2;

            %% Fixed Equipment Weight -- AVERAGE OF GD NIKOLAI RAYMER and ROSKAM GD

            self.average.fixedEquipmentWeight = ( self.gudmundsson.nikolai.fixedEquipmentWeight + self.gudmundsson.raymer.fixedEquipmentWeight + self.roskam.gudmundsson.fixedEquipmentWeight )/3;

            %% Wing Weight --- AVERAGE OF RAYMER AND ROSKAM TOREENBEEK GD

            self.average.wingWeight =( self.raymer.wingWeight + self.roskam.gudmundsson.wingWeight + self.roskam.torenbeek.wingWeight )/3;

            %% Fuselage Weight -- GD NIKOLAI

            self.average.fuselageWeight = self.gudmundsson.nikolai.fuselageWeight;

            %% Landing Gear Weight -- AVERAGE OF Raymer and GD Nikolai, and Roskam Toren/GD

            self.average.totalLandingGearWeight =( self.raymer.totalLandingGearWeight + self.gudmundsson.nikolai.totalLandingGearWeight + self.roskam.gudmundsson.totalLandingGearWeight + self.roskam.torenbeek.totalLandingGearWeight )/4;

            %% Empennage Weight -- AVERAGE OF Raymer, GD Nikolai, and Roskam Torenbeek

            self.average.empennageWeight = (self.raymer.empennageWeight + self.gudmundsson.nikolai.empennageWeight + self.roskam.torenbeek.empennageWeight )/3;

            %% Empty Weight -- SUM of Average (Structural, Powerplant and Fixed Equipment)

            self.average.emptyWeight = self.average.fixedEquipmentWeight + self.average.powerplantWeight + self.average.structuralWeight;
        end
        function delete(self)
        end
    end
end

