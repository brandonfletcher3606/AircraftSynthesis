classdef WingElement < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = WingElement()
        end
        function obj = calculateInnerWingRootChord(self,wS,wAR,owTaperRatio,flDiameter)
            wB = power(wS*wAR,1/2);
            obj  = wS/((owTaperRatio*(1+self.taperRatio)*(wB/2-((0.75*flDiameter)*2)/2))+(1+self.taperRatio)*((0.75*flDiameter)*2)/2);
        end
        function obj = calculateInnerWingTipChord(self,wS,wAR,owTaperRatio,flDiameter)
            obj = self.taperRatio*self.calculateInnerWingRootChord(wS,wAR,owTaperRatio,flDiameter);
        end
        function obj = calculateWingSpan(self,AR,s)
            obj = power(AR * s, 1/2);
        end
    end
end

