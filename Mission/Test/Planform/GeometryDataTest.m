classdef GeometryDataTest < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = GeometryDataTest()
            fprintf('\n\nStarting GemoetryDataTest\n')
        end
        function iwCalculateRootChordTest(self,s,AR,taperRatio,flDiameter,iwTaperRatio)
            a = InnerWing(25,0.3);
            b = a.calculateInnerWingRootChord(s,AR,taperRatio,flDiameter,iwTaperRatio);
            b = round(b,2);
            assert(b==27.23,'Incorrect Root Chord');
            fprintf('\tiwCalculateRootChordTest successful\n');
        end
        function iwCalculateTipChordTest(self,s,AR,taperRatio,flDiameter,iwTaperRatio);
            a = InnerWing(25,0.3);
            b = a.calculateInnerWingTipChord(s,AR,taperRatio,flDiameter,iwTaperRatio);
            b = round(b,2);
            assert(b==8.17,'Incorrect Tip Chord');
            fprintf('\tiwCalculateTipChordTest successful\n');
        end
        function iwCalculate(self,flDiameter,owTaperRatio,wAR,wS,sweep,taperRatio)
            a = InnerWing(sweep,taperRatio);
            a.calculate(flDiameter,owTaperRatio,wAR,wS)
            iwValue = a.getValue();
            assert(round(a.rootChord,2)==27.23,'Incorrect Inner Root Chord');
            assert(round(a.b,1)==37.5,'Incorrect Inner Wing Span');
            assert(round(a.halfSpan,1)==18.8,'Incorrect Inner Wing Half Span');
            assert(round(a.tipChord,2)==8.17,'Incorrect Inner Tip Chord');
            assert(round(a.s,1)==663.7,'Incorrect Inner Wing Area');
            assert(round(a.mgcChord,2)==17.7,'Incorrect Inner MGC Chord');
            fprintf('\tiwCalculate successful\n');
        end
        function owCalculate(self,sweep,taperRatio,flDiameter,wAR,wS,iwTaperRatio)
            a = OuterWing(sweep,taperRatio);
            a.calculate(flDiameter,wAR,wS,iwTaperRatio);
            owValue = a.getValue();
            assert(round(a.rootChord,2)==8.17,'Incorrect Outer Root Chord');
            assert(round(a.b,1)==62.2,'Incorrect Outer Wing Span');
            assert(round(a.halfSpan,1)==31.1,'Incorrect Outer Wing Half Span');
            assert(round(a.tipChord,2)==2.45,'Incorrect Outer Tip Chord');
            assert(round(a.s,1)==330.3,'Incorrect Outer Wing Area');
            assert(round(a.mgcChord,2)==5.31,'Incorrect Outer MGC Chord');
            fprintf('\towCalculate successful\n');
        end
        function wCalculate(self,s,AR,loading,owTaperRat,flDiameter,iwTaperRatio)
            a = Wing(s,AR,loading);
            a.calculate(owTaperRat,flDiameter,iwTaperRatio);
            wValue = a.getValue();
            assert(round(a.b,1)==99.7, 'Incorrect Total Span');
            assert(round(a.mgc,1)==13.6, 'Incorrect Total Mean Geometric Chord');
%             assert(round(a.dist2HT,1)==48.9, 'Incorrect Distance to HT');
%             assert(round(a.dist2VT,1)==43.9, 'Incorrect Distance to VT');
            assert(round(a.mgcYLoc,1)==10.7, 'Incorrect Y location for MGC');
            fprintf('\twCalculate successful\n');
        end
        function vtCalculate(self,wS,wAR,AR,sweepAngle,taperRatio,owTaperRatio,flDiameter,iwTaperRatio)
            a = VerticalTail(AR,sweepAngle,taperRatio);
            a.calculate(wAR,wS,owTaperRatio,flDiameter,iwTaperRatio);
            vtValue = a.getValue();
            assert(round(a.b,1)==5.8, 'Incorrect Vertical Tail Span');
            assert(round(a.s,1)==24.6, 'Incorrect Vertical Tail Area');
            assert(round(a.dist2VT,1)==43.9, 'Incorrect dist2VT');
            assert(round(a.rootChord,1)==5.7, 'Incorrect Root Chord');
            assert(round(a.tipChord,1)==2.8, 'Incorrect Tip Chord');
            fprintf('\tvtCalculate successful\n');
        end
        function htCalculate(self,wS,wAR,AR,sweepAngle,taperRatio,owTaperRatio,flDiameter,iwTaperRatio)
            a = HorizontalTail(AR,sweepAngle,taperRatio);
            a.calculate(wAR,wS,owTaperRatio,flDiameter,iwTaperRatio);
            htValue = a.getValue();
            assert(round(a.b,1)==36.2, 'Incorrect Horizontal Tail Span');
            assert(round(a.s,1)==276.1, 'Incorrect Horizontal Tail Area');
            assert(round(a.dist2HT,1)==48.9, 'Incorrect dist2HT');
            assert(round(a.rootChord,1)==10.6, 'Incorrect Root Chord');
            assert(round(a.tipChord,1)==4.7, 'Incorrect Tip Chord');
            fprintf('\thtCalculate successful\n');
        end
        function geometryCalculation(self,geometryData)
        end
    end
end

