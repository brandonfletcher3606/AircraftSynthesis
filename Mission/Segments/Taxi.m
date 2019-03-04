classdef Taxi < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Taxi"
        TA
        thrust
        tsfcCurve
        duration
        altitude
    end
    
    methods
        function obj = Taxi(thrust,tsfcCurve,duration,altitude)
            obj.thrust = thrust;
            obj.tsfcCurve = tsfcCurve;
            obj.duration = duration;
            obj.altitude = altitude;
        end
        function obj = runSegment(self,weight)
            flightIdle=20; %percent
            pRatio=power(1-0.001981*self.altitude/288.16,5.256);
            self.TA.Thrust=pRatio*self.thrust;
            self.TA.flightIdleThrust=flightIdle/100*self.TA.Thrust; %lbs
            self.TA.tsfcSU=self.tsfcCurve(1)*power(flightIdle,5)+self.tsfcCurve(2)*power(flightIdle,4)+self.tsfcCurve(3)*power(flightIdle,3)+self.tsfcCurve(4)*power(flightIdle,2)+self.tsfcCurve(5)*power(flightIdle,1)+self.tsfcCurve(6);
            self.TA.FFR=self.TA.tsfcSU*self.TA.flightIdleThrust; %Fuel Flow Rate
            self.TA.fuelUsed=self.TA.FFR*self.duration(2); %lbs
            self.TA.Weight=weight-self.TA.fuelUsed; %lbs
            
            self.fuel = self.TA.fuelUsed;
            self.finalWeight = self.TA.Weight;
            self.time = self.duration(2);
            self.distance = 'N/A';
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = self.fuel;
            MissionSegmentData(1).finalWeight = self.finalWeight;
            MissionSegmentData(1).time = self.time;
            MissionSegmentData(1).distance = self.distance;

            obj = MissionSegmentData;
        end
    end
end

