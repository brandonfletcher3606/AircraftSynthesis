classdef InnerWing < GeometryElement
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        taperRatio
        sweep
    end
    properties (SetAccess = private)
        b
        halfSpan
        rootChord
        tipChord
        s
        mgcChord
    end
    
    methods
        function obj = InnerWing(sweep,taperRatio)
            obj.sweep = sweep;
            obj.taperRatio = taperRatio;
        end
        function calculate(self,flDiameter,owTaperRatio,wAR,wS)
            %flDiameter = fuselage diameter (known)
            %iwTaperRatio = inner wing taper ratio (known)
            %iwSweep = inner wing sweep angle (known)
            %owTaperRatio = outer wing taper ratio (known)
            %wAR = total wing aspect ratio (known)
            %wS = total wing area (known)
            
            %substitutes
            wB = self.calculateWingSpan(wAR,wS);
                        
            %calculated values
            self.b = (0.75*flDiameter)*2;
            self.halfSpan = self.b/2;
            self.rootChord  = self.calculateInnerWingRootChord(wS,wAR,owTaperRatio,flDiameter,self.taperRatio);
            self.tipChord = self.calculateInnerWingTipChord(wS,wAR,owTaperRatio,flDiameter,self.taperRatio);
            self.s = self.halfSpan*(self.rootChord + self.tipChord);
            self.mgcChord = 0.5 * (self.rootChord + self.tipChord);
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.sweep,'Sheet1','E2')
            xlswrite('planformData.xlsx',self.taperRatio,'Sheet1','E3')
            xlswrite('planformData.xlsx',self.b,'Sheet1','E4')
            xlswrite('planformData.xlsx',self.halfSpan,'Sheet1','E5')
            xlswrite('planformData.xlsx',self.rootChord,'Sheet1','E6')
            xlswrite('planformData.xlsx',self.tipChord,'Sheet1','E7')
            xlswrite('planformData.xlsx',self.s,'Sheet1','E8')
            xlswrite('planformData.xlsx',self.mgcChord,'Sheet1','E9')
        end
    end
    methods
        function innerWing = getValue(self)
            innerWing.span = self.b;
            innerWing.halfSpan = self.halfSpan;
            innerWing.rootChord = self.rootChord;
            innerWing.tipChord = self.tipChord;
            innerWing.area = self.s;
            innerWing.mgcChord = self.mgcChord;
            innerWing.taperRatio = self.taperRatio;
            innerWing.sweepAngle = self.sweep;
        end
    end    
end

