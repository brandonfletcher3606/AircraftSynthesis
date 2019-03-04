classdef Loiter < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Loiter"
        LO
        timeToLoiter
        cdo
        AR
        e
        altitude
        thrust
        s
        clo
        tsfcCurve
        loiterVel
    end
    
    methods
        function obj = Loiter(timeToLoiter,cdo,AR,e,altitude,thrust,s,clo,tsfcCurve,loiterVel)
            obj.timeToLoiter = timeToLoiter;
            obj.cdo = cdo;
            obj.AR = AR;
            obj.e = e;
            obj.altitude = altitude;
            obj.thrust = thrust;
            obj.s = s;
            obj.clo = clo;
            obj.tsfcCurve = tsfcCurve;
            obj.loiterVel = loiterVel;
        end
        function obj = runSegment(self,weight)
            [T,a,P,rho] = atmosisa(self.altitude*0.3048);
            self.LO.rho=rho*0.00194032;%slugs/ft^3
            self.LO.pRatio=power(1-0.001981*self.altitude/288.16,5.256);
            self.LO.k=1/(pi*self.AR*self.e(2));
            self.LO.thrust=self.LO.pRatio*self.thrust;
            self.LO.velocity=self.loiterVel;%power((4/3)*power(weight/self.s,2)*(1/power(self.LO.rho,2))*(1/self.cdo(1))*self.LO.k,1/4);
            self.LO.cl=weight/(0.5*self.LO.rho*power(self.LO.velocity,2)*self.s);
            self.LO.cd=self.cdo(2)+(1/(pi*self.AR*self.e(2)))*power(self.LO.cl-self.clo,2);
            self.LO.drag=0.5*self.LO.rho*power(self.LO.velocity,2)*self.s*self.LO.cd;
            self.LO.loiterThrust=self.LO.drag/self.LO.thrust*100;
            self.LO.lDMAX=1/(2*power(self.cdo(1)*self.LO.k,0.5));
            self.LO.cMid = power(self.cdo(1)/self.LO.k,1/2);
            self.LO.tsfcLoiter=self.tsfcCurve(1)*power(self.LO.loiterThrust,5)+self.tsfcCurve(2)*power(self.LO.loiterThrust,4)+self.tsfcCurve(3)*power(self.LO.loiterThrust,3)+self.tsfcCurve(4)*power(self.LO.loiterThrust,2)+self.tsfcCurve(5)*power(self.LO.loiterThrust,1)+self.tsfcCurve(6);
            TimetoLoiter=self.timeToLoiter*3600;
            self.LO.ct=self.LO.tsfcLoiter/3600;
            self.LO.c12 = self.LO.cl*tan(atan(1) - (TimetoLoiter*self.LO.ct/2/self.LO.lDMAX));
            self.LO.weight=self.LO.c12*0.5*self.LO.rho*power(self.LO.velocity,2)*self.s;
            self.LO.fuelUsed=weight-self.LO.weight;
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = self.LO.fuelUsed;
            MissionSegmentData(1).finalWeight = self.LO.weight;
            MissionSegmentData(1).time = TimetoLoiter/3600;
            MissionSegmentData(1).distance = 'N/A';
            
            obj = MissionSegmentData;
        end
    end
end

