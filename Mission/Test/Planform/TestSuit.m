%addpath('C:\Users\Brandon Fletcher\Documents\MATLAB\MatlabCode');
addpath(genpath('C:\Users\Brandon Fletcher\Documents\MATLAB\MatlabCode'))

clear
clc
close all
tic
% weightTest = WeightDataTest();
% weightTest.calculatedTest();

%geometryTest = GeometryDataTest();
% geometryTest.iwCalculateRootChordTest(994,10,0.3,25,0.3)
% geometryTest.iwCalculateTipChordTest(994,10,0.3,25,0.3)
% geometryTest.iwCalculate(25,0.3,10,994,25,0.3)
% geometryTest.owCalculate(25,0.3,25,10,994,0.3)
% geometryTest.wCalculate(994,10,88,0.3,25,0.3)
% geometryTest.vtCalculate(994,10,1.35,43,0.5,0.3,25,0.3)
% geometryTest.htCalculate(994,10,4.75,27.5,0.44,0.3,25,0.3)

%geometryData = GeometryData();
% geometryData.setWing(994,10,88);
% geometryData.setInnerWing(25,0.3);
% geometryData.setOuterWing(25,0.3);
% geometryData.setFuselage(30,25);
% geometryData.setVerticalTail(1.35,43,0.5);
% geometryData.setHorizontalTail(4.75,27.5,0.44);
% geometryData.setEngine(4.5,9.3,12,6,2,3,4,6.739,6.739);
% geometryData.calculate();
% 
% geometryData.wing.loading = 70;
% geometryData.calculate();

planBuild = PlanformBuilder();
planBuild.setSweepVariable(PlanformBuilder.LOADING,[55 60 65 70]);
planBuild.setSweepVariable(PlanformBuilder.THRUST2WEIGHT,[0.29 0.30 0.32 0.33 0.34 0.35]);
planBuild.setSweepVariable(PlanformBuilder.WINGAREA,[1000 1100 1200 1300 1400 1500 1600 1700]);
planBuild.setSweepVariable(PlanformBuilder.ASPECTRATIO,[9 11 12]);
planBuild.setSweepVariable(PlanformBuilder.INNERWINGSWEEP,[20 23 27 29 33]);
planBuild.setSweepVariable(PlanformBuilder.OUTERWINGSWEEP,[20 23 27 29 33]);
planBuild.setSweepVariable(PlanformBuilder.INNERWINGTAPER,[0.2 0.25 0.35 0.4]);
planBuild.setSweepVariable(PlanformBuilder.OUTERWINGTAPER,[0.2 0.25 0.35 0.4]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXTO,[1.8 1.9 3.1]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXLANDING,[2.4 2.5 2.7 2.8]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXCLEAN,[1.8 1.9 2.0 2.1]);

planforms = planBuild.build();

missionComplete = zeros(length(planforms),1);
missionComplete = num2cell(missionComplete);
for i = 1:1:length(planforms)
%Primary Mission
myStartup = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
myTaxi = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
myTakeoff = Takeoff(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.muRolling,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
myClimb = Climb(planforms{i,2}.performanceData.estimatedTakeoffVelocity,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.e,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.cruiseVelocity);
myCruise = Cruise(planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cruiseMach,planforms{i,2}.performanceData.cruiseDistance);
myDescent = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.cruiseVelocity,planforms{i,2}.performanceData.loiterVelocity,planforms{i,2}.performanceData.descentTime);
myLoiter = Loiter(planforms{i,2}.performanceData.duration(7),planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.loiterVelocity);
myDescentSecond = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.performanceData.loiterVelocity,planforms{i,2}.performanceData.estimatedLandingVelocity,7);
myLanding = Landing(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.muBreaking,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
myTaxiAtLanding = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
myShutdown = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);

%Alternate Mission
myCruiseAlternate = Cruise(planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cruiseMach,planforms{i,2}.performanceData.cruiseDistance);
myDescentAlternate = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.cruiseVelocity,planforms{i,2}.performanceData.loiterVelocity,planforms{i,2}.performanceData.descentTime);
myLandingAlternate = Landing(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.muBreaking,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
myTaxiAtAlternateLanding = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
myShutdownAlternate = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);

myPrimaryMission = Mission(87650);
myPrimaryMission.addSegment(myStartup);
myPrimaryMission.addSegment(myTaxi);
myPrimaryMission.addSegment(myTakeoff);
myPrimaryMission.addSegment(myClimb);
myPrimaryMission.addSegment(myCruise);
myPrimaryMission.addSegment(myDescent);
myPrimaryMission.addSegment(myLoiter);
myPrimaryMission.addSegment(myDescentSecond);
myPrimaryMission.addSegment(myLanding);
myPrimaryMission.addSegment(myTaxiAtLanding);
myPrimaryMission.addSegment(myShutdown);

primaryMission = myPrimaryMission.runMission;

myAlternateMission = Mission(primaryMission(7).finalWeight);
myAlternateMission.addSegment(myCruiseAlternate);
myAlternateMission.addSegment(myDescentAlternate);
myAlternateMission.addSegment(myLandingAlternate);
myAlternateMission.addSegment(myTaxiAtAlternateLanding);
myAlternateMission.addSegment(myShutdownAlternate);

alternateMission = myAlternateMission.runMission;

missionComplete{i,1} = {myStartup;myTaxi;myTakeoff;myClimb;myCruise;myDescent;myLoiter;myDescentSecond;...
    myLanding;myTaxiAtLanding;myShutdown;myCruiseAlternate;myDescentAlternate;myLandingAlternate;...
    myTaxiAtAlternateLanding;myShutdownAlternate;primaryMission;alternateMission;planforms{i,2};planforms{i,1}};



end
toc



            
            
            
            
            