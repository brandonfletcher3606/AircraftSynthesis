classdef GeometryData < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        wing
        innerWing
        outerWing
        fuselage
        verticalTail
        horizontalTail
        engine
    end
    properties (SetAccess = private)
        distFromCenterLine
        aircraftLength
    end

    methods
        function obj = GeometryData()
            obj.innerWing = InnerWing(25,0.3);
            obj.outerWing = OuterWing(25,0.3);
            obj.wing = Wing(994,10,88);
            obj.fuselage = Fuselage(30,25,14);
            obj.verticalTail = VerticalTail(1.35,43,0.5);
            obj.horizontalTail = HorizontalTail(4.75,27.5,0.44);
            obj.engine = Engine(4.5,9.3,12,6,2,3,4,6.739,6.739);
        end
        function setWing(self,s,AR,loading)
            self.wing = Wing(s,AR,loading);
        end
        function setInnerWing(self,sweep,taperRatio)
            self.innerWing = InnerWing(sweep,taperRatio);
        end        
        function setOuterWing(self,sweep,taperRatio)
            self.outerWing = OuterWing(sweep,taperRatio);
        end        
        function setFuselage(self,length,diameterLong,diameterShort)
            self.fuselage = Fuselage(length,diameterLong,diameterShort);
        end 
        function setVerticalTail(self,AR,sweepAngle,taperRatio)
            self.verticalTail = VerticalTail(AR,sweepAngle,taperRatio);
        end
        function setHorizontalTail(self,AR,sweepAngle,taperRatio)
            self.horizontalTail = HorizontalTail(AR,sweepAngle,taperRatio);
        end 
        function setEngine(self,nacelleDiameter,lengthActual,lengthExtended,nacelleFrontDiameter,nacelleFrontLength,nacelleRearDiameter,nacellRearLength,nacellMountWidth,nacellMountLength)
            self.engine = Engine(nacelleDiameter,lengthActual,lengthExtended,nacelleFrontDiameter,nacelleFrontLength,nacelleRearDiameter,nacellRearLength,nacellMountWidth,nacellMountLength);
        end
        function calculate(self)
            fd = self.fuselage.diameterLong;
            owtr = self.outerWing.taperRatio;
            iwtr = self.innerWing.taperRatio;
            war = self.wing.AR;
            ws = self.wing.s;
            
            self.innerWing.calculate(fd,owtr,war,ws);
            self.outerWing.calculate(fd,war,ws,iwtr);
            
            iwB = self.innerWing.b;
            owB = self.outerWing.b;
            iwS = self.innerWing.sweep;
            owS = self.outerWing.sweep;
            
            self.wing.calculate(owtr,fd,iwtr,iwB,owB,iwS,owS);
            self.verticalTail.calculate(war,ws,owtr,fd,iwtr);
            self.horizontalTail.calculate(war,ws,owtr,fd,iwtr);
            
            self.calculateAircraftLength();
        end
        function write(self)
            self.wing.writeToExcel()
            self.innerWing.writeToExcel()
            self.outerWing.writeToExcel()
            self.fuselage.writeToExcel()
            self.verticalTail.writeToExcel()
            self.horizontalTail.writeToExcel()
            self.engine.writeToExcel()
        end
    end
    methods (Access = private)
        function calculateAircraftLength(self)
            height = (self.wing.s/2)/(self.innerWing.tipChord + self.wing.mgc);
            self.distFromCenterLine = tan(deg2rad(self.wing.mgcSweep))*(height);
            self.aircraftLength=self.horizontalTail.dist2HT+.75*self.horizontalTail.rootChord+0.25*self.wing.mgc+self.distFromCenterLine;
        end
    end
end

