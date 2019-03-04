classdef VerticalTail < GeometryElement
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AR
        sweepAngle
        taperRatio
        
        vv=0.035;
        xvb=0.44;
        incidenceAngle = 0;
        thicknessRatio = 0.683 %might have to correct
        verticalTailHeight = 5
        srsv = 0.2930
        dist2VT
        s
        b
        rootChord
        tipChord
        mgc
        zh = 5;
        zhbv
        rudderArea
    end    
    methods
        function obj = VerticalTail(AR,sweepAngle,taperRatio)
            obj.AR = AR;
            obj.sweepAngle = sweepAngle;
            obj.taperRatio = taperRatio;
        end
        function calculate(self,wAR,wS,owTaperRatio,flDiameter,iwTaperRatio)
            self.dist2VT = self.calculateVerticalTailDistance(self.xvb,wAR,wS);
            self.s=self.vv*wS*self.calculateWingMGC(owTaperRatio,flDiameter,wAR,wS,iwTaperRatio)/self.dist2VT;
            self.b=self.calculateWingSpan(self.AR,self.s);
            self.rootChord=2*self.s/(1.5*self.b);
            self.tipChord=self.taperRatio*self.rootChord;
            self.mgc = 0.5*(self.rootChord+self.tipChord);
            self.zhbv = self.zh/self.b;
            self.rudderArea = self.srsv*self.s;
        end
        function verticalTail = getValue(self)
            verticalTail.b = self.b;
            verticalTail.s = self.s;
            verticalTail.mgc = self.mgc;
            verticalTail.dist2VT = self.dist2VT;
            verticalTail.rootChord = self.rootChord;
            verticalTail.tipChord = self.tipChord;
            verticalTail.AR = self.AR;
            verticalTail.sweepAngle = self.sweepAngle;
            verticalTail.taperRatio = self.taperRatio;
            verticalTail.vv = self.vv;
            verticalTail.xvb = self.xvb;
            verticalTail.incidenceAngle = self.incidenceAngle;
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.AR,'Sheet1','B22')
            xlswrite('planformData.xlsx',self.sweepAngle,'Sheet1','B23')
            xlswrite('planformData.xlsx',self.taperRatio,'Sheet1','B24')
            xlswrite('planformData.xlsx',self.vv,'Sheet1','B25')
            xlswrite('planformData.xlsx',self.xvb,'Sheet1','B26')
            xlswrite('planformData.xlsx',self.incidenceAngle,'Sheet1','B27')
            xlswrite('planformData.xlsx',self.thicknessRatio,'Sheet1','B28')
            xlswrite('planformData.xlsx',self.verticalTailHeight,'Sheet1','B29')
            xlswrite('planformData.xlsx',self.srsv,'Sheet1','B30')
            xlswrite('planformData.xlsx',self.dist2VT,'Sheet1','B31')
            xlswrite('planformData.xlsx',self.s,'Sheet1','B32')
            xlswrite('planformData.xlsx',self.b,'Sheet1','B33')
            xlswrite('planformData.xlsx',self.rootChord,'Sheet1','B34')
            xlswrite('planformData.xlsx',self.tipChord,'Sheet1','B35')
            xlswrite('planformData.xlsx',self.mgc,'Sheet1','B36')
            xlswrite('planformData.xlsx',self.zh,'Sheet1','B37')
            xlswrite('planformData.xlsx',self.zhbv,'Sheet1','B38')
            xlswrite('planformData.xlsx',self.rudderArea,'Sheet1','B39')
        end
    end
end

