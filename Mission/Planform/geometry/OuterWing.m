classdef OuterWing < GeometryElement
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sweep
        taperRatio
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
        function obj = OuterWing(sweep,taperRatio)
            obj.sweep = sweep;
            obj.taperRatio = taperRatio;
        end
        function calculate(self,flDiameter,wAR,wS,iwTaperRatio)
            %flDiameter = fuselage diameter (known)
            %iwTaperRatio = inner wing taper ratio (known)
            %iwSweep = inner wing sweep angle (known)
            %owTaperRatio = outer wing taper ratio (known)
            %owSweep = outer wing sweep
            %wAR = total wing aspect ratio (known)
            %wS = total wing area (known)
            
            %substitutes
            wB = self.calculateWingSpan(wAR,wS);
                        
            %calculated values            
            iwB = (0.75*flDiameter)*2;          
            
            self.b = wB-iwB;
            self.halfSpan = self.b/2;
            self.rootChord  = self.calculateInnerWingTipChord(wS,wAR,self.taperRatio,flDiameter,iwTaperRatio);
            self.tipChord = self.rootChord*self.taperRatio;
            self.s = self.halfSpan*(self.rootChord + self.tipChord);
            self.mgcChord = 0.5 * (self.rootChord + self.tipChord);
        end
        function outerWing = getValue(self)
            outerWing.span = self.b;
            outerWing.halfSpan = self.halfSpan;
            outerWing.rootChord = self.rootChord;
            outerWing.tipChord = self.tipChord;
            outerWing.area = self.s;
            outerWing.mgcChord = self.mgcChord;
            outerWing.taperRatio = self.taperRatio;
            outerWing.sweepAngle = self.sweep;
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.sweep,'Sheet1','H2')
            xlswrite('planformData.xlsx',self.taperRatio,'Sheet1','H3')
            xlswrite('planformData.xlsx',self.b,'Sheet1','H4')
            xlswrite('planformData.xlsx',self.halfSpan,'Sheet1','H5')
            xlswrite('planformData.xlsx',self.rootChord,'Sheet1','H6')
            xlswrite('planformData.xlsx',self.tipChord,'Sheet1','H7')
            xlswrite('planformData.xlsx',self.s,'Sheet1','H8')
            xlswrite('planformData.xlsx',self.mgcChord,'Sheet1','H9')
        end
    end      
end

