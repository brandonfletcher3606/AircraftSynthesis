classdef Engine < GeometryElement
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nacelleDiameter
        lengthActual
        lengthExtended
        nacelleFrontDiameter
        nacelleFrontLength
        nacelleRearDiameter
        nacelleRearLength
        nacelleMountWidth
        nacelleMountLength
        wettedNacelleArea = 445.1
        numberOfEngines = 2
        engineToCockpitLength = 34.05
        integralTanksVolume = 391.5
        numberOfFuelTanks = 6
        kr = 1.133
        ktp = 0.793
        p2 = 35;
    end
    
    methods
        function obj = Engine(nacelleDiameter,lengthActual,lengthExtended,nacelleFrontDiameter,nacelleFrontLength,nacelleRearDiameter,nacelleRearLength,nacelleMountWidth,nacelleMountLength)
            obj.nacelleDiameter = nacelleDiameter;
            obj.lengthActual = lengthActual;
            obj.lengthExtended = lengthExtended;
            obj.nacelleFrontDiameter = nacelleFrontDiameter;
            obj.nacelleFrontLength = nacelleFrontLength;
            obj.nacelleRearDiameter = nacelleRearDiameter;
            obj.nacelleRearLength = nacelleRearLength;
            obj.nacelleMountWidth = nacelleMountWidth;
            obj.nacelleMountLength = nacelleMountLength;
        end
        function engine = getValue(self)
            engine.nacelleDiameter = self.nacelleDiameter;
            engine.lengthActual = self.lengthActual;
            engine.lengthExtended = self.lengthExtended;
            engine.nacelleFrontDiameter = self.nacelleFrontDiameter;
            engine.nacelleFrontLength = self.nacelleFrontLength;
            engine.nacelleRearDiameter = self.nacelleRearDiameter;
            engine.nacelleRearLength = self.nacelleRearLength;
            engine.nacelleMountWidth = self.nacelleMountWidth;
            engine.nacelleMountLength = self.nacelleMountLength;
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.nacelleDiameter,'Sheet1','H12')
            xlswrite('planformData.xlsx',self.lengthActual,'Sheet1','H13')
            xlswrite('planformData.xlsx',self.lengthExtended,'Sheet1','H14')
            xlswrite('planformData.xlsx',self.nacelleFrontDiameter,'Sheet1','H15')
            xlswrite('planformData.xlsx',self.nacelleFrontLength,'Sheet1','H16')
            xlswrite('planformData.xlsx',self.nacelleRearDiameter,'Sheet1','H17')
            xlswrite('planformData.xlsx',self.nacelleRearLength,'Sheet1','H18')
            xlswrite('planformData.xlsx',self.nacelleMountWidth,'Sheet1','H19')
            xlswrite('planformData.xlsx',self.nacelleMountLength,'Sheet1','H20')
            xlswrite('planformData.xlsx',self.wettedNacelleArea,'Sheet1','H21')
            xlswrite('planformData.xlsx',self.numberOfEngines,'Sheet1','H22')
            xlswrite('planformData.xlsx',self.engineToCockpitLength,'Sheet1','H23')
            xlswrite('planformData.xlsx',self.integralTanksVolume,'Sheet1','H24')
            xlswrite('planformData.xlsx',self.numberOfFuelTanks,'Sheet1','H25')
            xlswrite('planformData.xlsx',self.kr,'Sheet1','H26')
            xlswrite('planformData.xlsx',self.ktp,'Sheet1','H27')
            xlswrite('planformData.xlsx',self.p2,'Sheet1','H28')
        end
    end
end

