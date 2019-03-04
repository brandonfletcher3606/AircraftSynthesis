classdef Planform < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        geometryData
        performanceData
        weightData
        engineData
        globalData
    end
    
    methods
        function obj = Planform()
            obj.geometryData = GeometryData();
            obj.performanceData = PerformanceData();
            obj.engineData = EngineData();
            obj.globalData = GlobalData();
            obj.weightData = WeightData();
        end
        
        function calculate(self)
            self.geometryData.calculate();
            self.performanceData.calculate();
            self.engineData.calculate();
            self.globalData.calculate();
            self.weightData.calculate(self.geometryData,self.performanceData);
        end
        
        function geometryWrite(self)
            self.geometryData.write();
        end
    end
end

