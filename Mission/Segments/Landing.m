classdef Landing < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Landing"
        LA
        height
        b
        s
        cLMAX
        AR
        e
        clo
        cdo
        mu
        drag
        thrust
        altitude
        tsfcCurve
    end
    
    methods
        function obj = Landing(height,b,s,cLMAX,AR,e,clo,cdo,mu,drag,thrust,altitude,tsfcCurve)
            obj.height = height;
            obj.b = b;
            obj.s = s;
            obj.cLMAX = cLMAX;
            obj.AR = AR;
            obj.e = e;
            obj.clo = clo;
            obj.cdo = cdo;
            obj.mu = mu;
            obj.drag = drag;
            obj.thrust = thrust;
            obj.altitude = altitude;
            obj.tsfcCurve = tsfcCurve;
        end
        function obj = runSegment(self,weight)
            LandingThrust = 100; %percent
            % [T,a,P,rho] = atmosisa(Altitude*0.3048);
            % Takeoff.rho=rho*0.00194032;
            self.LA.rho=0.001977;
            self.LA.pRatio=power(1-0.001981*self.altitude/288.16,5.256);
            self.LA.thrust=self.LA.pRatio*self.thrust;
            self.LA.phi=(power(16*self.height/self.b,2))/(1+power(16*self.height/self.b,2));
            self.LA.vStall=power(2*(weight/self.s)/(self.cLMAX(3)*self.LA.rho),1/2);
            self.LA.vLanding=1.2*self.LA.vStall;
            self.LA.vInf=0.7*self.LA.vLanding;
            self.LA.lift=self.cLMAX(3)*0.5*self.LA.rho*power(self.LA.vInf,2)*self.s;
            self.LA.tsfcLanding=self.tsfcCurve(1)*power(LandingThrust,5)+self.tsfcCurve(2)*power(LandingThrust,4)+self.tsfcCurve(3)*power(LandingThrust,3)+self.tsfcCurve(4)*power(LandingThrust,2)+self.tsfcCurve(5)*power(LandingThrust,1)+self.tsfcCurve(6);
            FFR=self.LA.tsfcLanding*self.LA.thrust; %Fuel Flow Rate
            self.LA.cl=weight/(0.5*self.LA.rho*power(self.LA.vInf,2)*self.s);
            k=1/(pi*self.AR*self.e(2));
            self.LA.cd=self.cdo(3)+k*self.LA.phi*power(self.cLMAX(3)-self.clo,2);
            self.LA.drag=0.5*self.LA.rho*power(self.LA.vInf,2)*self.s*self.LA.cd;
            Term1=(self.LA.drag+self.mu*(weight-self.LA.lift));
            self.LA.fieldLength=(1.69*power(weight,2))/(Term1*self.LA.rho*self.s*self.cLMAX(3)*32.2); %ft
            self.LA.groundRollDuration=self.LA.fieldLength/(self.LA.vLanding/2); %seconds
            self.LA.tRotation=1.5; %seconds
            self.LA.landingDrag=(self.LA.drag/power(self.LA.vInf,2))*power(self.LA.vLanding,2);
            self.LA.roc=self.LA.vLanding*(self.LA.thrust)/weight;
            self.LA.decent50ft=50/self.LA.roc;
            self.LA.landingTime=self.LA.groundRollDuration+self.LA.tRotation+self.LA.decent50ft; %seconds
            self.LA.fuelUsed=self.LA.thrust*self.LA.landingTime/3600; %lbs
            self.LA.weight=weight-self.LA.fuelUsed; %lbs
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = self.LA.fuelUsed;
            MissionSegmentData(1).finalWeight = self.LA.weight;
            MissionSegmentData(1).time = self.LA.landingTime/3600;
            MissionSegmentData(1).distance = self.LA.fieldLength*0.000165;
            
            obj = MissionSegmentData;
        end
    end
end

