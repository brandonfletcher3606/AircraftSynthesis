classdef Takeoff < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Takeoff"
        TO
        height
        span
        s
        clMax
        cdo
        AR
        e
        clo
        mu
        drag
        thrust
        altitude
        tsfcCurve
    end

    methods
         function obj = Takeoff(height,span,s,clMax,cdo,AR,e,clo,mu,drag,thrust,altitude,tsfcCurve)
             obj.height = height;
             obj.span = span;
             obj.s = s;
             obj.clMax = clMax;
             obj.cdo = cdo;
             obj.AR = AR;
             obj.e = e;
             obj.clo = clo;
             obj.mu = mu;
             obj.drag = drag;
             obj.thrust = thrust;
             obj.altitude = altitude;
             obj.tsfcCurve = tsfcCurve;
            
        end       
        function obj = runSegment(self,weight)
            takeOffThrust = 100; %percent
            % [T,a,P,rho] = atmosisa(altitude*0.3048);
            % TO.rho=rho*0.00194032;
            self.TO.rho=0.001977;
            self.TO.pRatio=power(1-0.001981*self.altitude/288.16,5.256);
            self.TO.Thrust=self.TO.pRatio*self.thrust;
            self.TO.phi=(power(16*self.height/self.span,2))/(1+power(16*self.height/self.span,2));
            self.TO.vStall=power(2*(weight/self.s)/(self.clMax(2)*self.TO.rho),1/2);
            self.TO.vLiftoff=1.2*self.TO.vStall;
            self.TO.vInf=0.7*self.TO.vLiftoff;
            self.TO.lift=self.clMax(2)*0.5*self.TO.rho*power(self.TO.vInf,2)*self.s;
            self.TO.tsfcTakeoff=self.tsfcCurve(1)*power(takeOffThrust,5)+self.tsfcCurve(2)*power(takeOffThrust,4)+self.tsfcCurve(3)*power(takeOffThrust,3)+self.tsfcCurve(4)*power(takeOffThrust,2)+self.tsfcCurve(5)*power(takeOffThrust,1)+self.tsfcCurve(6);
            FFR=self.TO.tsfcTakeoff*self.TO.Thrust; %Fuel Flow Rate
            self.TO.cl=weight/(0.5*self.TO.rho*power(self.TO.vInf,2)*self.s);
            k=1/(pi*self.AR*self.e(2));
            self.TO.cd=self.cdo(3)+k*self.TO.phi*power(self.clMax(2)-self.clo,2);
            self.TO.drag=0.5*self.TO.rho*power(self.TO.vInf,2)*self.s*self.TO.cd;
            Term1=self.TO.Thrust-(self.TO.drag-self.mu*(weight-self.TO.lift));
            self.TO.fieldLength=(1.44*power(weight,2))/(Term1*self.TO.rho*self.s*self.clMax(2)*32.2); %ft
            self.TO.groundRollDuration=self.TO.fieldLength/(self.TO.vLiftoff/2); %seconds
            self.TO.tRotation=1.5; %seconds
            self.TO.liftOffDrag=(self.TO.drag/power(self.TO.vInf,2))*power(self.TO.vLiftoff,2);
            self.TO.roc=self.TO.vLiftoff*(self.TO.Thrust-self.TO.liftOffDrag)/weight;
            self.TO.climb35ft=35/self.TO.roc;
            self.TO.takeOffTime=self.TO.groundRollDuration+self.TO.tRotation+self.TO.climb35ft; %seconds
            self.TO.fuelUsed=self.TO.Thrust*self.TO.takeOffTime/3600; %lbs
            self.TO.weight=weight-self.TO.fuelUsed; %lbs
            
%             self.fuel = self.TO.fuelUsed;
%             self.finalWeight = self.TO.weight;
%             self.time = self.TO.takeOffTime/3600;
%             self.distance = self.TO.fieldLength*0.000165;
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = self.TO.fuelUsed;
            MissionSegmentData(1).finalWeight = self.TO.weight;
            MissionSegmentData(1).time = self.TO.takeOffTime/3600;
            MissionSegmentData(1).distance = self.TO.fieldLength*0.000165;

            obj = MissionSegmentData;            
        end
    end
end

