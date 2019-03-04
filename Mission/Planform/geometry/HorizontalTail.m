classdef HorizontalTail < GeometryElement
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AR
        sweepAngle
        taperRatio
        
        vh=0.9;
        xhmgc=3.6;
        twoDLiftCurveSlope = 0.06;
        incidenceAngle = 0;
        thicknessRatio = 0.1666
        kuht = 1.143;
        ky = 0
        kz = 0
        kdoor = 1
        klg = 1
    end
    properties (SetAccess = private)
        dist2HT
        s
        b
        rootChord
        tipChord
        mgc
        elevatorArea
        sesh = 0.2570
        horizontalTailHeight = 5.8
    end
    
    methods
        function obj = HorizontalTail(AR,sweepAngle,taperRatio)
            obj.AR = AR;
            obj.sweepAngle = sweepAngle;
            obj.taperRatio = taperRatio;
        end
        function calculate(self,wAR,wS,owTaperRatio,flDiameter,iwTaperRatio)
            self.dist2HT = self.calculateHorizontalTailDistance(self.xhmgc,owTaperRatio,flDiameter,wAR,wS,iwTaperRatio);
            self.ky = 0.3*self.dist2HT;
            self.s=self.vh*wS*self.calculateWingMGC(owTaperRatio,flDiameter,wAR,wS,iwTaperRatio)/self.dist2HT;
            self.b=self.calculateWingSpan(self.AR,self.s);
            self.rootChord=2*self.s/(1.44*self.b);
            self.tipChord=self.rootChord*self.taperRatio;
            self.mgc=0.5*(self.rootChord+self.tipChord);
            self.elevatorArea = self.s*self.sesh;
        end
        function horizontalTail = getValue(self)
            horizontalTail.b = self.b;
            horizontalTail.s = self.s;
            horizontalTail.mgc = self.mgc;
            horizontalTail.dist2HT = self.dist2HT;
            horizontalTail.rootChord = self.rootChord;
            horizontalTail.tipChord = self.tipChord;
            horizontalTail.AR = self.AR;
            horizontalTail.sweepAngle = self.sweepAngle;
            horizontalTail.taperRatio = self.taperRatio;
            horizontalTail.vh = self.vh;
            horizontalTail.xhmgc = self.xhmgc;
            horizontalTail.incidenceAngle = self.incidenceAngle;
            horizontalTail.twoDLiftCurveSlope = self.twoDLiftCurveSlope;
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.AR,'Sheet1','E12')
            xlswrite('planformData.xlsx',self.sweepAngle,'Sheet1','E13')
            xlswrite('planformData.xlsx',self.taperRatio,'Sheet1','E14')
            xlswrite('planformData.xlsx',self.vh,'Sheet1','E15')
            xlswrite('planformData.xlsx',self.xhmgc,'Sheet1','E16')
            xlswrite('planformData.xlsx',self.twoDLiftCurveSlope,'Sheet1','E17')
            xlswrite('planformData.xlsx',self.incidenceAngle,'Sheet1','E18')
            xlswrite('planformData.xlsx',self.thicknessRatio,'Sheet1','E19')
            xlswrite('planformData.xlsx',self.kuht,'Sheet1','E20')
            xlswrite('planformData.xlsx',self.ky,'Sheet1','E21')
            xlswrite('planformData.xlsx',self.kz,'Sheet1','E22')
            xlswrite('planformData.xlsx',self.kdoor,'Sheet1','E23')
            xlswrite('planformData.xlsx',self.klg,'Sheet1','E24')
            xlswrite('planformData.xlsx',self.dist2HT,'Sheet1','E25')
            xlswrite('planformData.xlsx',self.s,'Sheet1','E26')
            xlswrite('planformData.xlsx',self.b,'Sheet1','E27')
            xlswrite('planformData.xlsx',self.rootChord,'Sheet1','E28')
            xlswrite('planformData.xlsx',self.tipChord,'Sheet1','E29')
            xlswrite('planformData.xlsx',self.mgc,'Sheet1','E30')
            xlswrite('planformData.xlsx',self.elevatorArea,'Sheet1','E31')
            xlswrite('planformData.xlsx',self.sesh,'Sheet1','E32')
            xlswrite('planformData.xlsx',self.horizontalTailHeight,'Sheet1','E33')
        end
    end
end

