clear
clc
close all

set(0,'DefaultFigureWindowStyle','docked')
load('Mission.mat')
s= size(planBuild.xAxis);
numCarpetPlotSets = s(1);

for i = 2:1:length(missionComplete)
    rem.TakeoffWeight{i-1,1} = missionComplete{i,2}.planform.weightData.takeoff;
    %rem.FuelWeight{i-1,1} = missionComplete{i,2}.planform.weightData.fuel;
    %rem.EmptyWeight{i-1,1} = missionComplete{i,2}.planform.weightData.empty;
    rem.Thrust{i-1,1} = missionComplete{i,2}.planform.engineData.totalThrust;
end

fields = fieldnames(rem);
graphCount = numel(fields);

for h = 1:1:graphCount
    for i = 1:1:numCarpetPlotSets
        numCarpetPlots = length(planBuild.xAxis{i,1}); %iterate this
        numVariableOne = length(planBuild.variableOne{i,1}); %iterate this
        numVariableTwo = length(planBuild.variableTwo{i,1}); % iterate this
        numPlanforms = numVariableOne * numVariableTwo;
        p = 0;
        k0Set = 0;
        for n = 1:1:numCarpetPlots
            m = p+1;
            while m > p && m < numPlanforms + p
                for k = 1:1:numVariableOne
                    for l = 1:1:numVariableTwo
                        C{l,k} = rem.(fields{h}){m,1};
                        %C{l,k} = rem.thrust{m,1};
                        m = m + 1;
                    end
                end
            end

            switch planBuild.xAxis{i,2}
                case 'loading'
                    xAxisValues = planBuild.loading;
                case 'thrust2Weight'
                    xAxisValues = planBuild.thrust2Weight;
                case 'wingArea'
                    xAxisValues = planBuild.wingArea;
                case 'AR'
                    xAxisValues = planBuild.AR;
                case 'clMaxTO'
                    xAxisValues = planBuild.clMaxTO;
                case 'clMaxLanding'
                    xAxisValues = planBuild.clMaxLanding;
                case 'clMaxClean'
                    xAxisValues = planBuild.clMaxClean;
                case 'innerWingSweep'
                    xAxisValues = planBuild.innerWingSweep;
                case 'outerWingSweep'
                    xAxisValues = planBuild.outerWingSweep;
                case 'totalWingSweep'
                    xAxisValues = planBuild.totalWingSweep;
                case 'innerWingTaper'
                    xAxisValues = planBuild.innerWingTaper;
                case 'outerWingTaper'
                    xAxisValues = planBuild.outerWingTaper;
            end

            switch planBuild.variableOne{i,2}
                case 'loading'
                    variableOneValues = planBuild.loading;
                case 'thrust2Weight'
                    variableOneValues = planBuild.thrust2Weight;
                case 'wingArea'
                    variableOneValues = planBuild.wingArea;
                case 'AR'
                    variableOneValues = planBuild.AR;
                case 'clMaxTO'
                    variableOneValues = planBuild.clMaxTO;
                case 'clMaxLanding'
                    variableOneValues = planBuild.clMaxLanding;
                case 'clMaxClean'
                    variableOneValues = planBuild.clMaxClean;
                case 'innerWingSweep'
                    variableOneValues = planBuild.innerWingSweep;
                case 'outerWingSweep'
                    variableOneValues = planBuild.outerWingSweep;
                case 'totalWingSweep'
                    variableOneValues = planBuild.totalWingSweep;
                case 'innerWingTaper'
                    variableOneValues = planBuild.innerWingTaper;
                case 'outerWingTaper'
                    variableOneValues = planBuild.outerWingTaper;
            end

            switch planBuild.variableTwo{i,2}
                case 'loading'
                    variableTwoValues = planBuild.loading;
                case 'thrust2Weight'
                    variableTwoValues = planBuild.thrust2Weight;
                case 'wingArea'
                    variableTwoValues = planBuild.wingArea;
                case 'AR'
                    variableTwoValues = planBuild.AR;
                case 'clMaxTO'
                    variableTwoValues = planBuild.clMaxTO;
                case 'clMaxLanding'
                    variableTwoValues = planBuild.clMaxLanding;
                case 'clMaxClean'
                    variableTwoValues = planBuild.clMaxClean;
                case 'innerWingSweep'
                    variableTwoValues = planBuild.innerWingSweep;
                case 'outerWingSweep'
                    variableTwoValues = planBuild.outerWingSweep;
                case 'totalWingSweep'
                    variableTwoValues = planBuild.totalWingSweep;
                case 'innerWingTaper'
                    variableTwoValues = planBuild.innerWingTaper;
                case 'outerWingTaper'
                    variableTwoValues = planBuild.outerWingTaper;
            end

            [A, B] = meshgrid(variableOneValues,variableTwoValues);

            C = cell2mat(C);

            hold on
            figure(h)
            myPlot = carpetplot(A,B,C);
            xlabel(planBuild.xAxis{i,2})
            ylabel(fields{h})
            myPlot.k0 = k0Set;
            myPlot.set;

            p=p+numPlanforms;
            k0Set = k0Set + 10;
            clear C
        end
        hold off
    end
end


