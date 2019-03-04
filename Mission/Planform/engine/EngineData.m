classdef EngineData < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        thrustToWeight = 0.31
        tsfc = [-0.0000000008331, 0.0000002822, -0.0000377, 0.00252, -0.08754, 1.965];
        takeoffWeight = 87650
    end
    properties (SetAccess = private)
        totalThrust
    end
    
    methods
        function obj = EngineData()
        end
        function calculate(self)
            self.totalThrust = self.thrustToWeight * self.takeoffWeight;
        end
        function delte(self)
            self.tsfc = {};
        end
    end
end

