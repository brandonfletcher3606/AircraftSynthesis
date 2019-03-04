clear
clc
close all

loadPaths;

inputs = false;

if inputs == true
    list = {'loading','thrust2Weight','wingArea',...                   
    'AR','clMaxTO','clMaxLanding','clMaxClean',...
    'innerWingSweep','outerWingSweep','totalWingSweep',...
    'innerWingTaper','outerWingTaper'};

    prompt = {'Do you want Single Variable Changes? (1/0)','Do you want double Variable Changes? (1/0)','Do you want Carpet Plots? (1/0)'};
    title = 'Input';
    dims = [1 35];
    definput = {'0','0','1'};
    answer = inputdlg(prompt,title,dims,definput);

    answer = cell2mat(answer);
    answer = str2num(answer);
    numCarpetSets = 0;

    if answer(3) == 1
        prompt = {'How many carpet plot sets do you want?'};
        title = 'Input';
        dims = [1 35];
        definput = {'1'};
        numCarpetSets = inputdlg(prompt,title,dims,definput);
    end

    numCarpetSets = cell2mat(numCarpetSets);
    numCarpetSets = str2num(numCarpetSets);

    if numCarpetSets > 0
        for i = 1:1:numCarpetSets
            [xIndx(i,1),~] = listdlg('PromptString','Carpet Plot X Axis',...
                'SelectionMode','single','ListString',list);

            switch xIndx(i,1)
                case 1
                    xIndxWord(i,1) = {'LOADING'};
                case 2
                    xIndxWord(i,1) = {'THRUST2WEIGHT'};
                case 3
                    xIndxWord(i,1) = {'WINGAREA'};
                case 4
                    xIndxWord(i,1) = {'ASPECTRATIO'};
                case 5
                    xIndxWord(i,1) = {'CLMAXTO'};
                case 6
                    xIndxWord(i,1) = {'CLMAXLANDING'};
                case 7
                    xIndxWord(i,1) = {'CLMAXCLEAN'};
                case 8
                    xIndxWord(i,1) = {'INNERWINGSWEEP'};
                case 9
                    xIndxWord(i,1) = {'OUTERWINGSWEEP'};
                case 10
                    xIndxWord(i,1) = {'TOTALWINGSWEEP'};
                case 11
                    xIndxWord(i,1) = {'INNERWINGTAPER'};
                case 12
                    xIndxWord(i,1) = {'OUTERWINGTAPER'};
            end

            [aIndx(i,1),~] = listdlg('PromptString','Carpet Plot A value',...
                'SelectionMode','single','ListString',list);
            switch aIndx(i,1)
                case 1
                    aIndxWord(i,1) = {'LOADING'};
                case 2
                    aIndxWord(i,1) = {'THRUST2WEIGHT'};
                case 3
                    aIndxWord(i,1) = {'WINGAREA'};
                case 4
                    aIndxWord(i,1) = {'ASPECTRATIO'};
                case 5
                    aIndxWord(i,1) = {'CLMAXTO'};
                case 6
                    aIndxWord(i,1) = {'CLMAXLANDING'};
                case 7
                    aIndxWord(i,1) = {'CLMAXCLEAN'};
                case 8
                    aIndxWord(i,1) = {'INNERWINGSWEEP'};
                case 9
                    aIndxWord(i,1) = {'OUTERWINGSWEEP'};
                case 10
                    aIndxWord(i,1) = {'TOTALWINGSWEEP'};
                case 11
                    aIndxWord(i,1) = {'INNERWINGTAPER'};
                case 12
                    aIndxWord(i,1) = {'OUTERWINGTAPER'};
            end

            [bIndx(i,1),~] = listdlg('PromptString','Carpet Plot B Value',...
                'SelectionMode','single','ListString',list);
            switch bIndx(i,1)
                case 1
                    bIndxWord(i,1) = {'LOADING'};
                case 2
                    bIndxWord(i,1) = {'THRUST2WEIGHT'};
                case 3
                    bIndxWord(i,1) = {'WINGAREA'};
                case 4
                    bIndxWord(i,1) = {'ASPECTRATIO'};
                case 5
                    bIndxWord(i,1) = {'CLMAXTO'};
                case 6
                    bIndxWord(i,1) = {'CLMAXLANDING'};
                case 7
                    bIndxWord(i,1) = {'CLMAXCLEAN'};
                case 8
                    bIndxWord(i,1) = {'INNERWINGSWEEP'};
                case 9
                    bIndxWord(i,1) = {'OUTERWINGSWEEP'};
                case 10
                    bIndxWord(i,1) = {'TOTALWINGSWEEP'};
                case 11
                    bIndxWord(i,1) = {'INNERWINGTAPER'};
                case 12
                    bIndxWord(i,1) = {'OUTERWINGTAPER'};
            end
        end
    end
end

tic

fprintf(1,'Building Planforms...');
planBuild = PlanformBuilder();
planBuild.setSweepVariable(PlanformBuilder.LOADING,[55:5:100]);
planBuild.setSweepVariable(PlanformBuilder.THRUST2WEIGHT,[0.29 0.30 0.32 0.33 0.34 0.35]);
planBuild.setSweepVariable(PlanformBuilder.WINGAREA,[1000 1100 1200 1300 1400 1500 1600 1700]);
planBuild.setSweepVariable(PlanformBuilder.ASPECTRATIO,[9 11 12]);
planBuild.setSweepVariable(PlanformBuilder.INNERWINGSWEEP,[20 23 27 29 33]);
planBuild.setSweepVariable(PlanformBuilder.OUTERWINGSWEEP,[20 23 27 29 33]);
planBuild.setSweepVariable(PlanformBuilder.TOTALWINGSWEEP,[20 23 27 29 33]);
planBuild.setSweepVariable(PlanformBuilder.INNERWINGTAPER,[0.9 1 1.1]);
planBuild.setSweepVariable(PlanformBuilder.OUTERWINGTAPER,[0.2 0.25 0.35 0.4]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXTO,[1.8 1.9 2.0 2.1 2.2]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXLANDING,[2.4 2.5 2.7 2.8]);
planBuild.setSweepVariable(PlanformBuilder.CLMAXCLEAN,[1.8 1.9 2.0 2.1 2.2]);

if inputs == true
    for i = 1:1:numCarpetSets
        planBuild.addCarpetPlotSet(PlanformBuilder.(xIndxWord{i,1}),PlanformBuilder.(aIndxWord{i,1}),PlanformBuilder.(bIndxWord{i,1}));
    end

    if answer(1) == 1
        planBuild.flag.sigleVariableChange = true;
    end
    if answer(2) == 1
        planBuild.flag.doubleVariableChange = true;
    end
    else
        planBuild.addCarpetPlotSet(PlanformBuilder.LOADING,PlanformBuilder.ASPECTRATIO,PlanformBuilder.INNERWINGSWEEP);
end

planforms = planBuild.build();
fprintf(1,'Done\n');

fprintf(1,'Running planforms against the mission...');
missionComplete = zeros(length(planforms),1);
missionComplete = num2cell(missionComplete);

planformSize = size(planforms);

for i = 1:1:planformSize(1)
    missionComplete{i,1} = planforms{i,1};
end

for i = 1:1:planformSize(1)
    fuelError = 2;
    distanceError = 2;
    distanceCapture = 1500;
    rocError = 20;
    while abs(fuelError) > 1 && abs(distanceError) > 1 && abs(rocError) > 10
        fuelCapture = planforms{i,2}.weightData.fuel;
        
        mission.planform = planforms{i,2};
        drag = parasiteDrag(mission.planform);
        mission.planform.performanceData.cdo =[drag.CDo.Clean*2 0.035 drag.CDo.TakeOff+0.025 drag.CDo.Landing-0.04]; 
        %Primary Mission
        mission.primaryMission.myStartup = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
        mission.primaryMission.myTaxi = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
        mission.primaryMission.myTakeoff = Takeoff(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.muRolling,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
        mission.primaryMission.myClimb = Climb(planforms{i,2}.performanceData.estimatedTakeoffVelocity,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.e,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.cruiseVelocity);
        mission.primaryMission.myCruise = Cruise(planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cruiseMach,planforms{i,2}.performanceData.cruiseDistance);
        mission.primaryMission.myDescent = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.cruiseVelocity,planforms{i,2}.performanceData.loiterVelocity,planforms{i,2}.performanceData.descentTime);
        mission.primaryMission.myLoiter = Loiter(planforms{i,2}.performanceData.duration(7),planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.loiterVelocity);
        mission.primaryMission.myDescentSecond = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.performanceData.loiterVelocity,planforms{i,2}.performanceData.estimatedLandingVelocity,7);
        mission.primaryMission.myLanding = Landing(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.muBreaking,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
        mission.primaryMission.myTaxiAtLanding = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
        mission.primaryMission.myShutdown = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);

        %Alternate Mission
        mission.alternateMission.myCruiseAlternate = Cruise(planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.engineData.totalThrust,planforms{i,2}.geometryData.wing.s,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cruiseMach,planforms{i,2}.performanceData.alternateCruiseDistance);
        mission.alternateMission.myDescentAlternate = Descent(planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.cdo,planforms{i,2}.geometryData.wing.s,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.cruiseAltitude,planforms{i,2}.performanceData.loiterAltitude,planforms{i,2}.performanceData.cruiseVelocity,planforms{i,2}.performanceData.loiterVelocity,7);
        mission.alternateMission.myLandingAlternate = Landing(planforms{i,2}.geometryData.wing.mgcHeight,planforms{i,2}.geometryData.wing.b,planforms{i,2}.geometryData.wing.s,planforms{i,2}.performanceData.clMax,planforms{i,2}.geometryData.wing.AR,planforms{i,2}.performanceData.e,planforms{i,2}.performanceData.clo,planforms{i,2}.performanceData.cdo,planforms{i,2}.performanceData.muBreaking,planforms{i,2}.performanceData.parasiteDrag,planforms{i,2}.engineData.totalThrust,planforms{i,2}.performanceData.initialAltitude,planforms{i,2}.engineData.tsfc);
        mission.alternateMission.myTaxiAtAlternateLanding = Taxi(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);
        mission.alternateMission.myShutdownAlternate = Startup(planforms{i,2}.engineData.totalThrust,planforms{i,2}.engineData.tsfc,planforms{i,2}.performanceData.duration,planforms{i,2}.performanceData.initialAltitude);

        myPrimaryMission = Mission(planforms{i,2}.weightData.takeoff);
        myPrimaryMission.addSegment(mission.primaryMission.myStartup);
        myPrimaryMission.addSegment(mission.primaryMission.myTaxi);
        myPrimaryMission.addSegment(mission.primaryMission.myTakeoff);
        myPrimaryMission.addSegment(mission.primaryMission.myClimb);
        myPrimaryMission.addSegment(mission.primaryMission.myCruise);
        myPrimaryMission.addSegment(mission.primaryMission.myDescent);
        myPrimaryMission.addSegment(mission.primaryMission.myLoiter);
        myPrimaryMission.addSegment(mission.primaryMission.myDescentSecond);
        myPrimaryMission.addSegment(mission.primaryMission.myLanding);
        myPrimaryMission.addSegment(mission.primaryMission.myTaxiAtLanding);
        myPrimaryMission.addSegment(mission.primaryMission.myShutdown);

        mission.primaryMissionQuick = myPrimaryMission.runMission;

        myAlternateMission = Mission(mission.primaryMissionQuick(7).finalWeight);
        myAlternateMission.addSegment(mission.alternateMission.myCruiseAlternate);
        myAlternateMission.addSegment(mission.alternateMission.myDescentAlternate);
        myAlternateMission.addSegment(mission.alternateMission.myLandingAlternate);
        myAlternateMission.addSegment(mission.alternateMission.myTaxiAtAlternateLanding);
        myAlternateMission.addSegment(mission.alternateMission.myShutdownAlternate);

        mission.alternateMissionQuick = myAlternateMission.runMission;

        error = 2;
        k = 1;
        while error > 1
            if k == 1
                mission.CG = CG(mission);
                estimate = mission.CG.percentChordOperatingEmptyFuelWeightCG ;
            end
                mission.landingGear = LG(mission,mission);
                mission.CGWLG = CGWLG(mission,mission);
                capture = mission.CGWLG.percentChordOperatingEmptyFuelWeightCG;
                error = estimate - capture;
            if error > 0.5 
                estimate = estimate - 0.9*error ;
            elseif error < 0
                estimate = estimate - 0.9*error ;
            end
            k = k + 1;    
        end
%             mission.parasiteDrag = parasiteDrag(mission);
            mission.parasiteDrag = drag;
            mission.neutralPoint = NP(mission);
        
        mission.totalPrimaryDistance = 0;
        mission.totalPrimaryFuel = 0;
        for j = 1:1:length(mission.primaryMissionQuick)
            if isnumeric(mission.primaryMissionQuick(j).distance) ~= 0
                mission.totalPrimaryDistance = mission.primaryMissionQuick(j).distance + mission.totalPrimaryDistance;
            end
            mission.totalPrimaryFuel = mission.primaryMissionQuick(j).fuel + mission.totalPrimaryFuel;
        end

        mission.totalAlternateDistance = 0;
        mission.totalAlternateFuel = 0;
        for j = 1:1:length(mission.alternateMissionQuick)
            if isnumeric(mission.alternateMissionQuick(j).distance) ~= 0
                mission.totalAlternateDistance = mission.alternateMissionQuick(j).distance + mission.totalAlternateDistance;
            end
            mission.totalAlternateFuel = mission.alternateMissionQuick(j).fuel + mission.totalAlternateFuel;
        end
        mission.totalMissionFuel = mission.totalPrimaryFuel*1.1+mission.totalAlternateFuel;
        mission.totalMissionDistance = mission.totalPrimaryDistance + mission.totalAlternateDistance;
        
        fuelError = mission.totalMissionFuel - fuelCapture;
        
        if fuelError > 1
            planforms{i,2}.weightData.fuel = fuelCapture + 0.9*fuelError;
            planforms{i,2}.weightData.takeoff = planforms{i,2}.weightData.takeoff + 0.9*fuelError;
        elseif fuelError < 1
            planforms{i,2}.weightData.fuel = fuelCapture + 0.9*fuelError;
            planforms{i,2}.weightData.takeoff = planforms{i,2}.weightData.takeoff + 0.9*fuelError;
        end
        
        distanceError = mission.totalPrimaryDistance - distanceCapture;
        
        if distanceError > 1
            planforms{i,2}.performanceData.cruiseDistance = planforms{i,2}.performanceData.cruiseDistance - 0.9*distanceError;
        elseif distanceError < 1
            planforms{i,2}.performanceData.cruiseDistance = planforms{i,2}.performanceData.cruiseDistance - 0.9*distanceError;
        end
        
        rocError = mission.primaryMission.myCruise.CR.rocReq(1)-510;
    
        if rocError > 10
            planforms{i,2}.engineData.thrustToWeight = planforms{i,2}.engineData.thrustToWeight - abs(0.005*rocError/100);
        elseif rocError < -10
            planforms{i,2}.engineData.thrustToWeight = planforms{i,2}.engineData.thrustToWeight + abs(0.005*rocError/100);
        end
        
        planforms{i,2}.engineData.calculate();
        missionComplete{i,2} = mission;
        i
    end
end

save('Mission.mat')

fprintf(1,'Done\n')

% for i = 1:1:length(missionComplete)
%     percent(i,1) = (missionComplete{i,2}.planform.weightData.empty/missionComplete{i,2}.planform.weightData.takeoff)*100;
% end
% len = 1:1:151;
% plot(len,percent)
toc

