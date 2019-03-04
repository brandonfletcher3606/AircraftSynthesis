classdef WeightDataTest
    
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = WeightDataTest()
            fprintf('\n\nStarting WeightDataTest\n')
        end
        function calculatedTest(self)
            a = WeightData(87650,22000,15760,1530);
            b = a.empty;
            assert(b==48360,"Error: empty not calculated as expexted");
            fprintf('\tcalculatedTest successful\n');
        end
    end
end

