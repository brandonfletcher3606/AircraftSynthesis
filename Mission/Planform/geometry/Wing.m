classdef Wing < GeometryElement
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        s
        AR
        loading
        
        mgcHeight = 10.1
        incedence = 2.5
        xhmgc = 3.6
        sesh = 0.2570
        srsv = 0.2930
        twoDLiftCurveSlope = 0.11
        zeroLift = -2.5
        mgcSweep = 25
        taperRatio = 0.3 
        thicknessRatio = 0.1765
        controlSurfaceWingArea = 0 %Probably Ailerons
        totalControlSurfaceArea = 0
    end
    properties (SetAccess = private)
        b
        mgc
        mgcYLoc
    end
    
    methods
        function obj = Wing(s,AR,loading)
            obj.s = s;
            obj.AR = AR;
            obj.loading = loading;
        end
        function calculate(self,owTaperRatio,flDiameter,iwTaperRatio,iwB,owB,iwS,owS)
            self.b = self.calculateWingSpan(self.AR,self.s);
            self.mgc = self.calculateWingMGC(owTaperRatio,flDiameter,self.AR,self.s,iwTaperRatio);
            self.mgcYLoc = tan(deg2rad(self.mgcSweep))*((self.s/2)/((self.calculateInnerWingTipChord(self.s,self.AR,owTaperRatio,flDiameter,iwTaperRatio)) + self.mgc));
            self.taperRatio = owTaperRatio*iwTaperRatio;
            self.calculateFullWingSweep(iwB,owB,iwS,owS);
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.s,'Sheet1','B2')
            xlswrite('planformData.xlsx',self.AR,'Sheet1','B3')
            xlswrite('planformData.xlsx',self.loading,'Sheet1','B4')
            xlswrite('planformData.xlsx',self.mgcHeight,'Sheet1','B5')
            xlswrite('planformData.xlsx',self.incedence,'Sheet1','B6')
            xlswrite('planformData.xlsx',self.xhmgc,'Sheet1','B7')
            xlswrite('planformData.xlsx',self.sesh,'Sheet1','B8')
            xlswrite('planformData.xlsx',self.srsv,'Sheet1','B9')
            xlswrite('planformData.xlsx',self.twoDLiftCurveSlope,'Sheet1','B10')
            xlswrite('planformData.xlsx',self.zeroLift,'Sheet1','B11')
            xlswrite('planformData.xlsx',self.mgcSweep,'Sheet1','B12')
            xlswrite('planformData.xlsx',self.taperRatio,'Sheet1','B13')
            xlswrite('planformData.xlsx',self.thicknessRatio,'Sheet1','B14')
            xlswrite('planformData.xlsx',self.controlSurfaceWingArea,'Sheet1','B15')
            xlswrite('planformData.xlsx',self.totalControlSurfaceArea,'Sheet1','B16')
            xlswrite('planformData.xlsx',self.b,'Sheet1','B17')
            xlswrite('planformData.xlsx',self.mgc,'Sheet1','B18')
            xlswrite('planformData.xlsx',self.mgcYLoc,'Sheet1','B19')
        end
        function calculateFullWingSweep(self,iwB,owB,iwS,owS)
            %fprintf('\n%f %f %f %f\n',iwB, owB, iwS, owS)
            l = iwB/2*tan(deg2rad(iwS));
            m = owB/2*tan(deg2rad(owS));
            self.mgcSweep = atan((l + m)/(self.b/2))*180/pi;
        end
    end
    methods
        function wing = getValue(self)
            wing.b = self.b;
            wing.mgc = self.mgc;
            wing.mgcYLoc = self.mgcYLoc;
            wing.mgcHeight = self.mgcHeight;
            wing.incedence = self.incedence;
            wing.sesh = self.sesh;
            wing.srsv = self.srsv;
            wing.twoDLiftCurveSlope = self.twoDLiftCurveSlope;
            wing.zeroLift = self.zeroLift;
            wing.mgcSweep = self.mgcSweep;
            wing.taperRatio = self.taperRatio;
            wing.s = self.s;
            wing.AR = self.AR;
            wing.loading = self.loading;
        end
    end
end

