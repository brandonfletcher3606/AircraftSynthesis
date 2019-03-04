classdef Descent < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Descent"
        DE
        thrust
        cdo
        s
        AR
        e
        clo
        tsfcCurve
        initAlt
        endAlt
        initVel
        endVel
        descentTime
    end
    
    methods
        function obj = Descent(thrust,cdo,s,AR,e,clo,tsfcCurve,initAlt,endAlt,initVel,endVel,descentTime)
            obj.thrust = thrust;
            obj.cdo = cdo;
            obj.s = s;
            obj.AR = AR;
            obj.e = e;
            obj.clo = clo;
            obj.tsfcCurve = tsfcCurve;
            obj.initAlt = initAlt;
            obj.endAlt = endAlt;
            obj.initVel = initVel;
            obj.endVel = endVel;
            obj.descentTime = descentTime;
        end
        function obj = runSegment(self,weight)
            iteration = self.descentTime; %Represent this in Minutes
            rod=(self.initAlt - self.endAlt)/iteration;
            decentVel1=(self.initVel-self.endVel)/iteration;
            altitude = linspace(self.initAlt,self.endAlt,iteration);
            fuel = 0;
            distance = 0;
            time = 0;
            
            for i = 1:1:iteration
                
                if i==1
                    weight = weight;
                    velocity = self.initVel;
                elseif i~=1
                    weight = self.DE.weight(end);
                    velocity = self.DE.velocity(end)-decentVel1;
                end
                
            [T,a,P,rho] = atmosisa(altitude(i)*0.3048);
            self.DE.rho(i)=rho*0.00194032;%slugs/ft^3
            self.DE.pRatio(i)=power(1-0.001981*altitude(i)/288.16,5.256);
            self.DE.thrust(i)=self.DE.pRatio(i)*self.thrust;
            self.DE.velocity(i)=velocity;
            self.DE.angleofDecent(i)=asind(rod/60/self.DE.velocity(i));
            self.DE.cl(i)=weight/(0.5*self.DE.rho(i)*power(self.DE.velocity(i),2)*self.s);
            self.DE.cd(i)=self.cdo(2)+(1/(pi*self.AR*self.e(2)))*power(self.DE.cl(i)-self.clo,2);
            self.DE.drag(i)=0.5*self.DE.rho(i)*power(self.DE.velocity(i),2)*self.s*self.DE.cd(i);
            self.DE.decentThrust(i)=self.DE.drag(i)/self.DE.thrust(i)*100;
            self.DE.tsfcDecent(i)=self.tsfcCurve(1)*power(self.DE.decentThrust(i),5)+self.tsfcCurve(2)*power(self.DE.decentThrust(i),4)+self.tsfcCurve(3)*power(self.DE.decentThrust(i),3)+self.tsfcCurve(4)*power(self.DE.decentThrust(i),2)+self.tsfcCurve(5)*power(self.DE.decentThrust(i),1)+self.tsfcCurve(6);
            self.DE.FFR(i)=self.DE.thrust(i)*self.DE.tsfcDecent(i);
            self.DE.timeToDecent(i)=1/60;
%             self.DE.fuelUsedDecent=self.DE.FFR*self.DE.timeToDecent;
            self.DE.altitude(i)=altitude(i);
            self.DE.fuelUsed(i)=self.DE.tsfcDecent(i)*self.DE.thrust(i)/60;
            self.DE.weight(i)=weight-self.DE.fuelUsed(i);
            self.DE.distanceTraveled(i)=(self.DE.velocity(i)/(self.DE.tsfcDecent(i)*(1/3600)))*(self.DE.cl(i)/self.DE.cd(i))*log(weight/self.DE.weight(i));
            
            fuel = fuel + self.DE.fuelUsed(i);
            distance = distance + self.DE.distanceTraveled(i);
            time = time + self.DE.timeToDecent(i);
            end
            
            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = fuel;
            MissionSegmentData(1).finalWeight = self.DE.weight(end);
            MissionSegmentData(1).time = time;
            MissionSegmentData(1).distance = distance*0.000165;
            
            obj = MissionSegmentData;
        end
    end
end

