classdef Climb < Segments
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID = "Climb"
        CL
        vLiftOff
        s
        thrust
        drag
        cdo
        clo
        e
        AR
        tsfcCurve
        initAlt
        endAlt
        cruiseV
        vAlt
    end
    
    methods
        function obj = Climb(vLiftOff,s,thrust,drag,cdo,clo,e,AR,tsfcCurve,initAlt,endAlt,cruiseV)
            obj.vLiftOff = vLiftOff;
            obj.s = s;
            obj.thrust = thrust;
            obj.drag = drag;
            obj.cdo = cdo;
            obj.clo = clo;
            obj.e = e;
            obj.AR = AR;
            obj.tsfcCurve = tsfcCurve;
            obj.initAlt = initAlt;
            obj.endAlt = endAlt;
            obj.cruiseV = cruiseV;       
        end
        function obj = runSegment(self,weight)
            iteration = 100;
            altitude = linspace(self.initAlt,self.endAlt,iteration);
            fuel = 0;
            time = 0;
            distance = 0;
            
            for i = 1:1:iteration

                if i==1
                    weight=weight;
                    self.vAlt = self.vLiftOff;
                elseif i~=1
                    weight=self.CL.weight(end);
                    self.vAlt = self.CL.velocity(end);
                end
                
            ClimbThrust = 100; %percent
            [T,a,P,rho] = atmosisa(altitude(i)*0.3048);
            self.CL.rho(i)=0.001977;
            self.CL.pRatio(i)=power(1-0.001981*altitude(i)/288.16,5.256);
            self.CL.thrust(i)=self.CL.pRatio(i)*self.thrust;
            self.CL.rho(i)=rho*0.00194032;%slugs/ft^3
            self.CL.vAlt(i)=self.vAlt;
            self.CL.velocity(i)=(self.cruiseV-self.vLiftOff)/iteration+self.CL.vAlt(i);
            lift=weight;
            self.CL.cl(i)=lift/(0.5*self.CL.rho(i)*power(self.CL.vAlt(i),2)*self.s);
            self.CL.cd(i)=self.cdo(2)+(1/(pi*self.AR*self.e(2)))*power(self.CL.cl(i)-self.clo,2);
            self.CL.roc(i)=self.CL.vAlt(i)*(self.CL.thrust(i)-self.drag(2))/weight;%ft/s
            self.CL.timeToClimb(i)=(self.endAlt-self.initAlt)/iteration/self.CL.roc(i); %seconds
            self.CL.groundSpeed(i)=power(power(self.CL.vAlt(i),2)-power(self.CL.roc(i),2),1/2);
            self.CL.distanceTraveled(i)=self.CL.groundSpeed(i)*self.CL.timeToClimb(i);
            self.CL.drag(i)=0.5*self.CL.rho(i)*power(self.CL.vAlt(i),2)*self.s*self.CL.cd(i);
            self.CL.climbThrust(i)=100;
            self.CL.tsfcClimb(i)=self.tsfcCurve(1)*power(self.CL.climbThrust(i),5)+self.tsfcCurve(2)*power(self.CL.climbThrust(i),4)+self.tsfcCurve(3)*power(self.CL.climbThrust(i),3)+self.tsfcCurve(4)*power(self.CL.climbThrust(i),2)+self.tsfcCurve(5)*power(self.CL.climbThrust(i),1)+self.tsfcCurve(6);
            self.CL.FFR(i)=self.CL.tsfcClimb(i)*self.CL.thrust(i); %Fuel Flow Rate
            self.CL.fuelUsed(i)=self.CL.tsfcClimb(i)*self.CL.thrust(i)*self.CL.timeToClimb(i)/3600;
            self.CL.weight(i)=weight-self.CL.fuelUsed(i);
            
            time = time + self.CL.timeToClimb(i);
            distance = distance + self.CL.distanceTraveled(i);
            fuel = fuel + self.CL.fuelUsed(i);
            end

            MissionSegmentData(1).ID = self.ID;
            MissionSegmentData(1).fuel = fuel;
            MissionSegmentData(1).finalWeight = self.CL.weight(end);
            MissionSegmentData(1).time = time/3600;
            MissionSegmentData(1).distance = distance*0.000165;
            
            obj = MissionSegmentData;            
        end
    end
end

