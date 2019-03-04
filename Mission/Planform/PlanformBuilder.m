classdef PlanformBuilder < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        loading
        thrust2Weight
        wingArea
        AR
        clMaxTO
        clMaxLanding
        clMaxClean
        innerWingSweep
        outerWingSweep
        totalWingSweep
        innerWingTaper
        outerWingTaper
        flag
        
        planforms = {}
        
        xAxis = {}
        variableOne = {}
        variableTwo = {}
        iterationCount = {}
    end
    properties (Constant)
        LOADING = 'loading'
        THRUST2WEIGHT = 'thrust2Weight'
        WINGAREA = 'wingArea'
        ASPECTRATIO = 'AR'
        CLMAXTO = 'clMaxTO'
        CLMAXLANDING = 'clMaxLanding'
        CLMAXCLEAN = 'clMaxClean'
        INNERWINGSWEEP = 'innerWingSweep'
        OUTERWINGSWEEP = 'outerWingSweep'
        TOTALWINGSWEEP = 'totalWingSweep'
        INNERWINGTAPER = 'innerWingTaper'
        OUTERWINGTAPER = 'outerWingTaper'    
    end
    
    methods
        function obj = PlanformBuilder()
            obj.setFlag();
        end
        function setFlag(self)
            self.flag.singleVariableChange = false;
            self.flag.doubleVariableChange = false;
            self.flag.tripleVariableChange = false;
        end
        function obj = build(self)
            planform = Planform();
            planform.calculate();
            self.planforms{1,1} = 'InitConditions';            
            self.planforms{1,2} = planform;
            
            if self.flag.singleVariableChange == 1
                self.sweepLoading();
                self.sweepThrust2Weight();
                self.sweepWingArea();
                self.sweepAR();
                self.sweepInnerWingSweep();
                self.sweepOuterWingSweep();
                self.sweepTotalWingSweep();
                self.sweepInnerWingTaper();
                self.sweepOuterWingTaper();
                self.sweepClMaxTO();
                self.sweepClMaxLanding();
                self.sweepClMaxClean();
            end
            
            if self.flag.doubleVariableChange == 1
                self.sweepAllVariables();
            end
            
            if self.flag.tripleVariableChange == 1
                self.sweepCarpetPlotVariables();
            end
            
            obj = self.planforms;
        end
        function setSweepVariable(self,sweepName,sweepValues)
            
            switch sweepName
                case self.LOADING
                    self.loading = sweepValues;
                case self.THRUST2WEIGHT
                    self.thrust2Weight = sweepValues;
                case self.WINGAREA
                    self.wingArea = sweepValues;
                case self.ASPECTRATIO
                    self.AR = sweepValues;
                case self.CLMAXTO
                    self.clMaxTO = sweepValues;
                case self.CLMAXLANDING
                    self.clMaxLanding = sweepValues;
                case self.CLMAXCLEAN
                    self.clMaxClean = sweepValues;
                case self.INNERWINGSWEEP
                    self.innerWingSweep = sweepValues;
                case self.OUTERWINGSWEEP
                    self.outerWingSweep = sweepValues;
                case self.TOTALWINGSWEEP
                    self.totalWingSweep = sweepValues;
                case self.INNERWINGTAPER
                    self.innerWingTaper = sweepValues;
                case self.OUTERWINGTAPER
                    self.outerWingTaper = sweepValues;
                otherwise
            end
        end
        
        function addCarpetPlotSet(self,xAxis,variableOne,variableTwo)
            self.flag.tripleVariableChange = true;
            switch xAxis
                case self.LOADING
                    self.xAxis{end+1,1} = self.loading;
                    self.xAxis{end,2} = xAxis;
                case self.THRUST2WEIGHT
                    self.xAxis{end+1,1} = self.thrust2Weight;
                    self.xAxis{end,2} = xAxis;
                case self.WINGAREA
                    self.xAxis{end+1,1} = self.wingArea;
                    self.xAxis{end,2} = xAxis;
                case self.ASPECTRATIO
                    self.xAxis{end+1,1} = self.AR;
                    self.xAxis{end,2} = xAxis;
                case self.CLMAXTO
                    self.xAxis{end+1,1} = self.clMaxTO;
                    self.xAxis{end,2} = xAxis;
                case self.CLMAXLANDING
                    self.xAxis{end+1,1} = self.clMaxLanding;
                    self.xAxis{end,2} = xAxis;
                case self.CLMAXCLEAN
                    self.xAxis{end+1,1} = self.clMaxClean;
                    self.xAxis{end,2} = xAxis;
                case self.INNERWINGSWEEP
                    self.xAxis{end+1,1} = self.innerWingSweep;
                    self.xAxis{end,2} = xAxis;
                case self.OUTERWINGSWEEP
                    self.xAxis{end+1,1} = self.outerWingSweep;
                    self.xAxis{end,2} = xAxis;
                case self.TOTALWINGSWEEP
                    self.xAxis{end+1,1} = self.totalWingSweep;
                    self.xAxis{end,2} = xAxis;
                case self.INNERWINGTAPER
                    self.xAxis{end+1,1} = self.innerWingTaper;
                    self.xAxis{end,2} = xAxis;
                case self.OUTERWINGTAPER
                    self.xAxis{end+1,1} = self.outerWingTaper;
                    self.xAxis{end,2} = xAxis;
                otherwise
            end
            
            switch variableOne
                case self.LOADING
                    self.variableOne{end+1,1} = self.loading;
                    self.variableOne{end,2} = variableOne;
                case self.THRUST2WEIGHT
                    self.variableOne{end+1,1} = self.thrust2Weight;
                    self.variableOne{end,2} = variableOne;
                case self.WINGAREA
                    self.variableOne{end+1,1} = self.wingAre;
                    self.variableOne{end,2} = variableOne;
                case self.ASPECTRATIO
                    self.variableOne{end+1,1} = self.AR;
                    self.variableOne{end,2} = variableOne;
                case self.CLMAXTO
                    self.variableOne{end+1,1} = self.clMaxTO;
                    self.variableOne{end,2} = variableOne;
                case self.CLMAXLANDING
                    self.variableOne{end+1,1} = self.clMaxLanding;
                    self.variableOne{end,2} = variableOne;
                case self.CLMAXCLEAN
                    self.variableOne{end+1,1} = self.clMaxClean;
                    self.variableOne{end,2} = variableOne;
                case self.INNERWINGSWEEP
                    self.variableOne{end+1,1} = self.innerWingSweep;
                    self.variableOne{end,2} = variableOne;
                case self.OUTERWINGSWEEP
                    self.variableOne{end+1,1} = self.outerWingSweep;
                    self.variableOne{end,2} = variableOne;
                case self.TOTALWINGSWEEP
                    self.variableOne{end+1,1} = self.totalWingSweep;
                    self.variableOne{end,2} = variableOne;
                case self.INNERWINGTAPER
                    self.variableOne{end+1,1} = self.innerWingTaper;
                    self.variableOne{end,2} = variableOne;
                case self.OUTERWINGTAPER
                    self.variableOne{end+1,1} = self.outerWingTaper;
                    self.variableOne{end,2} = variableOne;
                otherwise
            end
            
            switch variableTwo
                case self.LOADING
                     self.variableTwo{end+1,1}= self.loading;
                     self.variableTwo{end,2} = variableTwo;
                case self.THRUST2WEIGHT
                    self.variableTwo{end+1,1} = self.thrust2Weight;
                    self.variableTwo{end,2} = variableTwo;
                case self.WINGAREA
                    self.variableTwo{end+1,1} = self.wingAre;
                    self.variableTwo{end,2} = variableTwo;
                case self.ASPECTRATIO
                    self.variableTwo{end+1,1} = self.AR;
                    self.variableTwo{end,2} = variableTwo;
                case self.CLMAXTO
                    self.variableTwo{end+1,1} = self.clMaxTO;
                    self.variableTwo{end,2} = variableTwo;
                case self.CLMAXLANDING
                    self.variableTwo{end+1,1} = self.clMaxLanding;
                    self.variableTwo{end,2} = variableTwo;
                case self.CLMAXCLEAN
                    self.variableTwo{end+1,1} = self.clMaxClean;
                    self.variableTwo{end,2} = variableTwo;
                case self.INNERWINGSWEEP
                    self.variableTwo{end+1,1} = self.innerWingSweep;
                    self.variableTwo{end,2} = variableTwo;
                case self.OUTERWINGSWEEP
                    self.variableTwo{end+1,1} = self.outerWingSweep;
                    self.variableTwo{end,2} = variableTwo;
                case self.TOTALWINGSWEEP
                    self.variableTwo{end+1,1} = self.totalWingSweep;
                    self.variableTwo{end,2} = variableTwo;
                case self.INNERWINGTAPER
                    self.variableTwo{end+1,1} = self.innerWingTaper;
                    self.variableTwo{end,2} = variableTwo;
                case self.OUTERWINGTAPER
                    self.variableTwo{end+1,1} = self.outerWingTaper;
                    self.variableTwo{end,2} = variableTwo;
                otherwise
            end
            for i = 1:1:length(self.xAxis{end,1})
                for j = 1:1:length(self.variableOne{end,1})
                    for k = 1:1:length(self.variableTwo{end,1})
                        self.iterationCount{end+1,1} = i;
                        self.iterationCount{end,2} = j;
                        self.iterationCount{end,3} = k;
                    end
                end
            end
        end
        
    end
    methods (Access = private)
        function sweepLoading(self)
            for i = 1:1:length(self.loading)
                planform = Planform();
                planform.geometryData.wing.loading = self.loading(i);
                planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                planform.calculate();
                self.planforms{end+1,1} = strcat('loading_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepThrust2Weight(self)
            for i = 1:1:length(self.thrust2Weight)
                planform = Planform();
                planform.engineData.thrustToWeight = self.thrust2Weight(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('thrust2weight_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepWingArea(self)
            for i = 1:1:length(self.wingArea)
                planform = Planform();
                planform.geometryData.wing.s = self.wingArea(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('wingArea_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepAR(self)
            for i = 1:1:length(self.AR)
                planform = Planform();
                planform.geometryData.wing.AR = self.AR(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('AR_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepInnerWingSweep(self)
            for i = 1:1:length(self.innerWingSweep)
                planform = Planform();
                planform.geometryData.innerWing.sweep = self.innerWingSweep(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('innerWingSweep_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepOuterWingSweep(self)
            for i = 1:1:length(self.outerWingSweep)
                planform = Planform();
                planform.geometryData.outerWing.sweep = self.outerWingSweep(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('outerWingSweep_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepTotalWingSweep(self)
            for i = 1:1:length(self.totalWingSweep)
                planform = Planform();
                planform.geometryData.wing.mgcSweep = self.totalWingSweep(i);
                planform.calculate()
                self.planforms{end+1} = strcat('totalWingSweep_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepInnerWingTaper(self)
            for i = 1:1:length(self.innerWingTaper)
                planform = Planform();
                planform.geometryData.innerWing.taperRatio = self.innerWingTaper(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('innerWingTaper_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepOuterWingTaper(self)
            for i = 1:1:length(self.outerWingTaper)
                planform = Planform();
                planform.geometryData.outerWing.taperRatio = self.outerWingTaper(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('outerWingTaper_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepClMaxTO(self)
            for i = 1:1:length(self.clMaxTO)
                planform = Planform();
                planform.performanceData.clMax(3) = self.clMaxTO(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('clMaxTO_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepClMaxLanding(self)
            for i = 1:1:length(self.clMaxLanding)
                planform = Planform();
                planform.performanceData.clMax(2) = self.clMaxLanding(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('clMaxLanding_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepClMaxClean(self)
            for i = 1:1:length(self.clMaxClean)
                planform = Planform();
                planform.performanceData.clMax(1) = self.clMaxClean(i);
                planform.calculate()
                self.planforms{end+1,1} = strcat('clMaxClean_',num2str(i));
                self.planforms{end,2} = planform;
            end
        end
        function sweepAllVariables(self)
            for i = 1:1:length(self.loading)
                for j = 1:1:length(self.thrust2Weight)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.engineData.thrustToWeight = self.thrust2Weight(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('thrust2weight_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.wingArea)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.wing.s = self.wingArea(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('wingArea_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.AR)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.wing.AR = self.AR(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('AR_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxTO)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.performanceData.clMax(3) = self.clMaxTO(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('clMaxTO_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxLanding)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('clMaxLanding_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.loading = self.loading(i);
                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('loading_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.thrust2Weight)
                for j = 1:1:length(self.wingArea)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.wing.s = self.wingArea(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('wingArea_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.AR)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.wing.AR = self.AR(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('AR_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxTO)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.performanceData.clMax(3) = self.clMaxTO(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('clMaxTO_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxLanding)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('clMaxLanding_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.engineData.thrustToWeight = self.thrust2Weight(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('thrust2weight_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.wingArea)
                for j = 1:1:length(self.AR)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.geometryData.wing.AR = self.AR(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('AR_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxTO)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.performanceData.clMax(3) = self.clMaxTO(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('clMaxTO_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxLanding)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('clMaxLanding_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.s = self.wingArea(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('wingArea_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.AR)
                for j = 1:1:length(self.clMaxTO)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.performanceData.clMax(3) = self.clMaxTO(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('clMaxTO_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxLanding)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('clMaxLanding_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.wing.AR = self.AR(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('AR_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.clMaxTO)
                for j = 1:1:length(self.clMaxLanding)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('clMaxLanding_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(3) = self.clMaxTO(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxTO_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.clMaxLanding)
                for j = 1:1:length(self.clMaxClean)
                    planform = Planform();
                    planform.performanceData.clMax(2) = self.clMaxLanding(i);
                    planform.performanceData.clMax(1) = self.clMaxClean(j);
                    planform.calculate()
                    first = strcat('clMaxLanding_',num2str(i));
                    second = strcat('clMaxClean_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(2) = self.clMaxLanding(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxLanding_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(2) = self.clMaxLanding(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxLanding_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(2) = self.clMaxLanding(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxLanding_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(2) = self.clMaxLanding(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxLanding_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.clMaxClean)
                for j = 1:1:length(self.innerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(1) = self.clMaxClean(i);
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxClean_',num2str(i));
                    second = strcat('innerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.performanceData.clMax(1) = self.clMaxClean(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('clMaxClean_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(1) = self.clMaxClean(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxClean_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.performanceData.clMax(1) = self.clMaxClean(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('clMaxClean_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.innerWingSweep)
                for j = 1:1:length(self.outerWingSweep)
                    planform = Planform();
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(i);
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                    planform.calculate()
                    first = strcat('innerWingSweep_',num2str(i));
                    second = strcat('outerWingSweep_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('innerWingSweep_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.innerWing.sweep = self.innerWingSweep(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('innerWingSweep_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.outerWingSweep)
                for j = 1:1:length(self.innerWingTaper)
                    planform = Planform();
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(i);
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                    planform.calculate()
                    first = strcat('outerWingSweep_',num2str(i));
                    second = strcat('innerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.outerWing.sweep = self.outerWingSweep(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('outerWingSweep_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
            for i = 1:1:length(self.innerWingTaper)
                for j = 1:1:length(self.outerWingTaper)
                    planform = Planform();
                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(i);
                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                    planform.calculate()
                    first = strcat('innerWingTaper_',num2str(i));
                    second = strcat('outerWingTaper_',num2str(j));
                    self.planforms{end+1,1} = strcat(first,second);
                    self.planforms{end,2} = planform;
                end
            end
        end
        
        function sweepCarpetPlotVariables(self)
            s = size(self.xAxis);
            for i = 1:1:s(1)
                for j = 1:1:length(self.xAxis{i,1})
                    for k = 1:1:length(self.variableOne{i,1})
                        for l = 1:1:length(self.variableTwo{i,1})
                            planform = Planform();
                            switch self.xAxis{i,2}
                                case 'loading'
                                    planform.geometryData.wing.loading = self.loading(j);
                                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(j);
                                    first = strcat('loading_',num2str(j));
                                case 'thrust2Weight'
                                    planform.engineData.thrustToWeight = self.thrust2Weight(j);
                                    first = strcat('thrust2weight_',num2str(j));
                                case 'wingArea'
                                    planform.geometryData.wing.s = self.wingArea(j);
                                    first = strcat('wingArea_',num2str(j));
                                case 'AR'
                                    planform.geometryData.wing.AR = self.AR(j);
                                    first = strcat('AR_',num2str(j));
                                case 'clMaxTO'
                                    planform.performanceData.clMax(3) = self.clMaxTO(j);
                                    first = strcat('clMaxTO_',num2str(j));
                                case 'clMaxLanding'
                                    planform.performanceData.clMax(2) = self.clMaxLanding(j);
                                    first = strcat('clMaxLanding_',num2str(j));
                                case 'clMaxClean'
                                    planform.performanceData.clMax(2) = self.clMaxClean(j);
                                    first = strcat('clMaxClean_',num2str(j));
                                case 'innerWingSweep'
                                    planform.geometryData.innerWing.sweep = self.innerWingSweep(j);
                                    first = strcat('innerWingSweep_',num2str(j));
                                case 'outerWingSweep'
                                    planform.geometryData.outerWing.sweep = self.outerWingSweep(j);
                                    first = strcat('outerWingSweep_',num2str(j));
                                case 'totalWingSweep'
                                    planform.geometryData.wing.mgcSweep = self.totalWingSweep(j);
                                    first = strcat('totalWingSweep_',num2str(j));
                                case 'innerWingTaper'
                                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(j);
                                    first = strcat('innerWingTaper_',num2str(j));
                                case 'outerWingTaper'
                                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(j);
                                    first = strcat('outerWingTaper_',num2str(j));
                            end
                            
                            switch self.variableOne{i,2}
                                case 'loading'
                                    planform.geometryData.wing.loading = self.loading(k);
                                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(k);
                                    second = strcat('loading_',num2str(k));
                                case 'thrust2Weight'
                                    planform.engineData.thrustToWeight = self.thrust2Weight(k);
                                    second = strcat('thrust2weight_',num2str(k));
                                case 'wingArea'
                                    planform.geometryData.wing.s = self.wingArea(k);
                                    second = strcat('wingArea_',num2str(k));
                                case 'AR'
                                    planform.geometryData.wing.AR = self.AR(k);
                                    second = strcat('AR_',num2str(k));
                                case 'clMaxTO'
                                    planform.performanceData.clMax(3) = self.clMaxTO(k);
                                    second = strcat('clMaxTO_',num2str(k));
                                case 'clMaxLanding'
                                    planform.performanceData.clMax(2) = self.clMaxLanding(k);
                                    second = strcat('clMaxLanding_',num2str(k));
                                case 'clMaxClean'
                                    planform.performanceData.clMax(2) = self.clMaxClean(k);
                                    second = strcat('clMaxClean_',num2str(k));
                                case 'innerWingSweep'
                                    planform.geometryData.innerWing.sweep = self.innerWingSweep(k);
                                    second = strcat('innerWingSweep_',num2str(k));
                                case 'outerWingSweep'
                                    planform.geometryData.outerWing.sweep = self.outerWingSweep(k);
                                    second = strcat('outerWingSweep_',num2str(k));
                                case 'totalWingSweep'
                                    planform.geometryData.wing.mgcSweep = self.totalWingSweep(k);
                                    second = strcat('totalWingSweep_',num2str(k));
                                case 'innerWingTaper'
                                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(k);
                                    second = strcat('innerWingTaper_',num2str(k));
                                case 'outerWingTaper'
                                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(k);
                                    second = strcat('outerWingTaper_',num2str(k));
                            end
                            
                            switch self.variableTwo{i,2}
                                case 'loading'
                                    planform.geometryData.wing.loading = self.loading(l);
                                    planform.geometryData.wing.s = planform.weightData.takeoff/self.loading(l);
                                    third = strcat('loading_',num2str(l));
                                case 'thrust2Weight'
                                    planform.engineData.thrustToWeight = self.thrust2Weight(l);
                                    third = strcat('thrust2weight_',num2str(l));
                                case 'wingArea'
                                    planform.geometryData.wing.s = self.wingArea(l);
                                    third = strcat('wingArea_',num2str(l));
                                case 'AR'
                                    planform.geometryData.wing.AR = self.AR(l);
                                    third = strcat('AR_',num2str(l));
                                case 'clMaxTO'
                                    planform.performanceData.clMax(3) = self.clMaxTO(l);
                                    third = strcat('clMaxTO_',num2str(l));
                                case 'clMaxLanding'
                                    planform.performanceData.clMax(2) = self.clMaxLanding(l);
                                    third = strcat('clMaxLanding_',num2str(l));
                                case 'clMaxClean'
                                    planform.performanceData.clMax(2) = self.clMaxClean(l);
                                    third = strcat('clMaxClean_',num2str(l));
                                case 'innerWingSweep'
                                    planform.geometryData.innerWing.sweep = self.innerWingSweep(l);
                                    third = strcat('innerWingSweep_',num2str(l));
                                case 'outerWingSweep'
                                    planform.geometryData.outerWing.sweep = self.outerWingSweep(l);
                                    third = strcat('outerWingSweep_',num2str(l));
                                case 'totalWingSweep'
                                    planform.geometryData.wing.mgcSweep = self.totalWingSweep(l);
                                    third = strcat('totalWingSweep_',num2str(l));
                                case 'innerWingTaper'
                                    planform.geometryData.innerWing.taperRatio = self.innerWingTaper(l);
                                    third = strcat('innerWingTaper_',num2str(l));
                                case 'outerWingTaper'
                                    planform.geometryData.outerWing.taperRatio = self.outerWingTaper(l);
                                    third = strcat('outerWingTaper_',num2str(l));
                            end
                            planform.calculate
                            self.planforms{end+1,1} = strcat(first,second,third);
                            self.planforms{end,2} = planform;
                        end
                    end
                end
            end
        end
    end
end

