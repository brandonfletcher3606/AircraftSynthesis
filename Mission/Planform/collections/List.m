classdef List < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        elements = {}
    end
    
    methods
        function obj = List()   
        end
        function add(self,segment)
            self.elements(end+1) = {segment};
        end
        function obj = get(self,index)
            obj = self.elements{index};
        end
        function obj = size(self)
            obj = length(self.elements);            
        end
        function clear(self)
            self.elements = {};
        end
        function delete(self)
            self.elements = {};
        end
    end
end

