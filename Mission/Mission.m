classdef Mission < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        segmentList
        weight
    end
    
    methods
        function obj = Mission(weight)
            obj.segmentList = List();
            obj.weight = weight;
        end
        
        function addSegment(self,segment)
            self.segmentList.add(segment)
        end
        
        function obj = runMission(self)
            aWeight = self.weight;
            for i=1:1:self.segmentList.size()
                missionData = self.segmentList.get(i).runSegment(aWeight);
                aWeight = missionData(1).finalWeight;
                missionResult(i).ID = missionData.ID;
                missionResult(i).fuel = missionData.fuel;
                missionResult(i).finalWeight = missionData.finalWeight;
                missionResult(i).time = missionData.time;
                missionResult(i).distance = missionData.distance;
                obj = missionResult;
            end
        end
        
        function delete(self)
            self.segmentList.clear();
        end
    end
end

