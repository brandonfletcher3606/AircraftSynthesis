classdef PerformanceData < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initialAltitude
        cruiseAltitude
        loiterAltitude
        duration
        cruiseMach
        cruiseVelocity
        cruiseMachAlternate
        cruiseVelocityAlternate
        loiterVelocity
        stallVelocity
        estimatedLandingVelocity
        estimatedTakeoffVelocity
        diveVelocity
        cruiseDistance
        alternateCruiseDistance
        clMax
        cdo
        clo
        parasiteDrag
        muRolling
        muBreaking
        e
        descentTime
        liftOverDrag = 19
        nf = 5
        nm = 2
        numberOfCrew = 7
        flightDeckCrew = 2;
        cabinCrew = 5;
        cabinCrewAndPassenger = 105
        numberOfPassenger = 100
        lf = 0
        klav = 1.11
        kbuf = 1.02
        dynamicPressureCruise
        dynamicPressureMax
        loadFactor = 3
        ultimateLandingLoadFactor = 6;
        seaLevelMaxVelocity = 631.88
        maxLandingLoad = 40230.56;
        estimatedFuelFlowRateTakeoff
    end
    
    methods
        function obj = PerformanceData()
            obj.initialAltitude = 5000; %feet
            obj.cruiseAltitude = 33000; %feet
            obj.loiterAltitude = 10000;
            obj.duration = [5 10 1 1 1 1 30 1 1 15 5 60]./60; %duration for each segment in minutes
            obj.cruiseMach = 0.8;
            obj.cruiseVelocity = 784.67;
            obj.cruiseMachAlternate = 0.3919;
            obj.cruiseVelocityAlternate = 421.952;
            obj.loiterVelocity = 421.952;
            obj.stallVelocity = 180.5;
            obj.estimatedLandingVelocity = 217.91;
            obj.estimatedTakeoffVelocity = 216.6;
            obj.diveVelocity = 527.44;
            obj.cruiseDistance = 1500;
            obj.alternateCruiseDistance = 100;
            obj.clMax = [1.7 2.7 3]; %Clean/TO/Landing
            obj.cdo = [0.0231 0.0237 0.0442 0.0447];
            obj.clo = 0.15; %CAN CHANGE THIS TO ADD CAMBER
            obj.parasiteDrag = [5816.4 5855.2 5878.1 5916.8]; %Drag - Clean/Clean+Flaps/TO/Landing
            obj.muRolling = 0.04;
            obj.muBreaking = 0.4;
            obj.e=[0.85,0.79,0.76]; %Oswalts Effeciency - Clean/TO/Landing
            obj.descentTime=25;            
        end
        function calculate(self)
        end
        function delete(self)
        end
    end
end


