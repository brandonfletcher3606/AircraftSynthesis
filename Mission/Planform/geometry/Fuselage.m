classdef Fuselage < GeometryElement
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        length
        diameterLong
        diameterShort
        
        cabinPressure = 8 %psi
        knp = 1
        kmp = 1
        kng = 1.017
        rkva = 50
        maxStaticPressure = 35
        ultimateCabinPressure = 20
        volume
        wettedArea
        mainGearStrutLength = 5.51*12;
        numberOfMainGearStruts = 2;
        noseGearStrutLength = 5.51*12;
        numberOfMainWheels = 4;
        numberOfNoseWheels = 2;
        electricalRoutingDistance = 20
        sumwfhf
        freightFloorArea = 200
    end
    methods
        function obj = Fuselage(length,diameterLong,diameterShort)
            obj.length = length;
            obj.diameterLong = diameterLong;
            obj.diameterShort = diameterShort;
            obj.calculateVolume();
            obj.calculateWettedArea();
            obj.sumwfhf = obj.diameterShort + obj.diameterLong;
        end
        function calculateVolume(self)
            self.volume = pi*self.diameterLong/2*self.diameterShort/2*self.length;
        end
        function calculateWettedArea(self)
            self.wettedArea = pi*(3*(self.diameterLong/2+self.diameterShort/2)-power((3*self.diameterLong/2+self.diameterShort/2)*(self.diameterLong/2+3*self.diameterShort/2),1/2))*self.length;
        end
        function writeToExcel(self)
            xlswrite('planformData.xlsx',self.length,'Sheet1','K2')
            xlswrite('planformData.xlsx',self.diameterLong,'Sheet1','K3')
            xlswrite('planformData.xlsx',self.diameterShort,'Sheet1','K4')
            xlswrite('planformData.xlsx',self.cabinPressure,'Sheet1','K5')
            xlswrite('planformData.xlsx',self.knp,'Sheet1','K6')
            xlswrite('planformData.xlsx',self.kmp,'Sheet1','K7')
            xlswrite('planformData.xlsx',self.kng,'Sheet1','K8')
            xlswrite('planformData.xlsx',self.rkva,'Sheet1','K9')
            xlswrite('planformData.xlsx',self.maxStaticPressure,'Sheet1','K10')
            xlswrite('planformData.xlsx',self.ultimateCabinPressure,'Sheet1','K11')
            xlswrite('planformData.xlsx',self.volume,'Sheet1','K12')
            xlswrite('planformData.xlsx',self.wettedArea,'Sheet1','K13')
            xlswrite('planformData.xlsx',self.mainGearStrutLength,'Sheet1','K14')
            xlswrite('planformData.xlsx',self.numberOfMainGearStruts,'Sheet1','K15')
            xlswrite('planformData.xlsx',self.noseGearStrutLength,'Sheet1','K16')
            xlswrite('planformData.xlsx',self.numberOfMainWheels,'Sheet1','K17')
            xlswrite('planformData.xlsx',self.numberOfNoseWheels,'Sheet1','K18')
            xlswrite('planformData.xlsx',self.electricalRoutingDistance,'Sheet1','K19')
            xlswrite('planformData.xlsx',self.sumwfhf,'Sheet1','K20')
            xlswrite('planformData.xlsx',self.freightFloorArea,'Sheet1','K21')
        end
    end
end

