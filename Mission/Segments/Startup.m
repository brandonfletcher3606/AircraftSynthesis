classdef Startup < Segments
    %Calculate quantities of startup
    
    properties
        ID = "Startup"
        SU
        thrust
        tsfcCurve
        duration
        altitude
    end
    
    methods
        function obj = Startup(thrust,tsfcCurve,duration,altitude)
            obj.thrust = thrust;
            obj.tsfcCurve = tsfcCurve;
            obj.duration = duration;
            obj.altitude = altitude;
        end
        function obj = runSegment(self,weight)
            flightIdle=20; %percent
            pRatio=power(1-0.001981*self.altitude/288.16,5.256);
            self.SU.Thrust=pRatio*self.thrust;
            self.SU.flightIdleThrust=flightIdle/100*self.SU.Thrust; %lbs
            self.SU.tsfc=self.tsfcCurve(1)*power(flightIdle,5)+self.tsfcCurve(2)*power(flightIdle,4)+self.tsfcCurve(3)*power(flightIdle,3)+self.tsfcCurve(4)*power(flightIdle,2)+self.tsfcCurve(5)*power(flightIdle,1)+self.tsfcCurve(6);
            self.SU.FFR=self.SU.tsfc*self.SU.flightIdleThrust; %Fuel Flow Rate
            self.SU.fuelUsed=self.SU.FFR*self.duration(1); %lbs
            self.SU.Weight=weight-self.SU.fuelUsed; %lbs
            
            self.fuel = self.SU.fuelUsed;
            self.finalWeight = self.SU.Weight;
            self.time = self.duration(1);
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

