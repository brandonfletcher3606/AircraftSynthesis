classdef Cruise < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Cruise"
        CR
        altitude
        thrust
        s
        tsfcCurve
        cdo
        AR
        e
        clo
        cMach
        cruiseDist
    end
    
    methods
        function obj = Cruise(altitude,thrust,s,tsfcCurve,cdo,AR,e,clo,cMach,cruiseDist)
            obj.altitude = altitude;
            obj.thrust = thrust;
            obj.s = s;
            obj.tsfcCurve = tsfcCurve;
            obj.cdo = cdo;
            obj.AR = AR;
            obj.e = e;
            obj.clo = clo;
            obj.cMach = cMach;
            obj.cruiseDist = cruiseDist;
        end
        function obj = runSegment(self,weight)
            iteration = 100;
            dIncriment = self.cruiseDist/iteration;
            fuel = 0;
            time = 0;
            
            for i = 1:1:iteration
                
                if i~=1
                    weight=self.CR.weight(end);
                end
                
            [T,a,P,rho] = atmosisa(self.altitude*0.3048);
            self.CR.rho(i)=rho*0.00194032;%slugs/ft^3
            a=a*3.28084; %ft/s
            self.CR.pRatio(i)=power(1-0.001981*self.altitude/288.16,5.256);
            self.CR.thrust(i)=self.CR.pRatio(i)*self.thrust;
            self.CR.velocity(i)=a*self.cMach;
            self.CR.cl(i)=weight/(0.5*self.CR.rho(i)*power(self.CR.velocity(i),2)*self.s);
            self.CR.cd(i)=self.cdo(1)+(1/(pi*self.AR*self.e(1)))*power(self.CR.cl(i)-self.clo,2);
            self.CR.drag(i)=0.5*self.CR.rho(i)*power(self.CR.velocity(i),2)*self.s*self.CR.cd(i);
            self.CR.cruiseThrust(i)=self.CR.drag(i)/self.CR.thrust(i)*100;
            self.CR.tsfcCruise(i)=self.tsfcCurve(1)*power(self.CR.cruiseThrust(i),5)+self.tsfcCurve(2)*power(self.CR.cruiseThrust(i),4)+self.tsfcCurve(3)*power(self.CR.cruiseThrust(i),3)+self.tsfcCurve(4)*power(self.CR.cruiseThrust(i),2)+self.tsfcCurve(5)*power(self.CR.cruiseThrust(i),1)+self.tsfcCurve(6);
            self.CR.timeToFly(i)=dIncriment*6076.115/self.CR.velocity(i); %Seconds
            self.CR.fuelUsed(i)=self.CR.drag(i)*self.CR.tsfcCruise(i)*self.CR.timeToFly(i)/3600;
            self.CR.weight(i)=weight-self.CR.fuelUsed(i);
            self.CR.rocReq(i) = self.CR.velocity(i)*(self.CR.thrust(i)-self.CR.drag(i))/weight*60;
            
            fuel = fuel + self.CR.fuelUsed(i);
            time = time + self.CR.timeToFly(i);
            end
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = fuel;
            MissionSegmentData(1).finalWeight = self.CR.weight(end);
            MissionSegmentData(1).time = time/3600;
            MissionSegmentData(1).distance = self.cruiseDist;
            
            obj = MissionSegmentData;            
        end
    end
end

