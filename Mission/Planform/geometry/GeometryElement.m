classdef GeometryElement < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
    end
    
    methods
        function obj = GeometryElement()
        end
        function obj = calculateInnerWingRootChord(self,wS,wAR,owTaperRatio,flDiameter,iwTaperRatio)
            wB = power(wS*wAR,1/2);
            obj  = wS/((owTaperRatio*(1+iwTaperRatio)*(wB/2-((0.75*flDiameter)*2)/2))+(1+iwTaperRatio)*((0.75*flDiameter)*2)/2);
        end
        function obj = calculateInnerWingTipChord(self,wS,wAR,owTaperRatio,flDiameter,iwTaperRatio)
            obj = iwTaperRatio*self.calculateInnerWingRootChord(wS,wAR,owTaperRatio,flDiameter,iwTaperRatio);
        end
        function obj = calculateWingSpan(self,AR,s)
            obj = power(AR * s, 1/2);
        end
        function obj = calculateWingMGC(self,owTaperRatio,flDiameter,AR,s,iwTaperRatio)
            iwRootChord = self.calculateInnerWingRootChord(s,AR,owTaperRatio,flDiameter,iwTaperRatio);
            iwTipChord = self.calculateInnerWingTipChord(s,AR,owTaperRatio,flDiameter,iwTaperRatio);
            iwMGC = 0.5*(iwRootChord+iwTipChord);
            iwS = (iwRootChord+iwTipChord)*0.75*flDiameter;
            
            owRootChord = iwTipChord;
            owTipChord = owTaperRatio * owRootChord;
            owMGC = 0.5*(owRootChord+owTipChord);
            owS = (owRootChord+owTipChord)*(self.calculateWingSpan(AR,s)-0.75*flDiameter*2)/2;
            obj = (iwMGC*iwS+owMGC*owS)/s;
        end
        function obj = calculateVerticalTailDistance(self,xvb,wAR,wS)
            obj = xvb*self.calculateWingSpan(wAR,wS);
        end
        function obj = calculateHorizontalTailDistance(self,xhmgc,owTaperRatio,flDiameter,AR,s,iwTaperRatio)
            obj = xhmgc * self.calculateWingMGC(owTaperRatio,flDiameter,AR,s,iwTaperRatio);
        end
    end
end

