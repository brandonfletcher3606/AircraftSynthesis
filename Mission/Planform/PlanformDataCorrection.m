function PlanformData = PlanformDataCorrection(S,AR,Loading,MGCHeight,InnerTapRat,OuterTapRat,iWing,Length,Diameter,InnerSweep,OuterSweep,InnerRootC,Weight,Which)
%Wing
            switch Which
                case 'WingLoading'
                    PlanformData.PlanformData.Wing.S = Weight/Loading;
                    PlanformData.PlanformData.Wing.AR=AR;
                    PlanformData.PlanformData.Wing.b = power(PlanformData.PlanformData.Wing.AR * PlanformData.PlanformData.Wing.S, 1/2);
                    PlanformData.PlanformData.Wing.Loading = Loading;
                    PlanformData.PlanformData.Wing.MGCHeight=MGCHeight; %Mean Geometric Height from ground - ft
                    PlanformData.PlanformData.Wing.XhMGC=3.6; %Distance between wing and HT divided by MGC
                    PlanformData.PlanformData.Wing.SeSh=0.257; %area of elevator to HT
                    PlanformData.PlanformData.Wing.SrSv=0.293; %rudder area to VT volume
                    PlanformData.PlanformData.Wing.TaperRat=0.3;
                    PlanformData.PlanformData.InnerWing.TaperRat=InnerTapRat;
                    PlanformData.PlanformData.OuterWing.TaperRat=OuterTapRat;
                    PlanformData.PlanformData.Wing.ao = 0.11;
                    PlanformData.PlanformData.Wing.iwing = iWing;
                    PlanformData.PlanformData.Wing.zerolift = -2.5;

                    %Fuselage
                    PlanformData.PlanformData.Fuselage.Length = Length;
                    PlanformData.PlanformData.Fuselage.Diameter = Diameter; %This is the lateral length

                    %InnerWing and OuterWing
                    PlanformData.PlanformData.InnerWing.Sweep=InnerSweep;

                    PlanformData.PlanformData.InnerWing.Span = (0.75*PlanformData.PlanformData.Fuselage.Diameter)*2; % ft
                    PlanformData.PlanformData.InnerWing.HalfSpan = PlanformData.PlanformData.InnerWing.Span/2;
                    PlanformData.PlanformData.OuterWing.Sweep=OuterSweep;

                    PlanformData.PlanformData.OuterWing.Span = PlanformData.PlanformData.Wing.b-PlanformData.PlanformData.InnerWing.Span; % ft
                    PlanformData.PlanformData.OuterWing.HalfSpan =PlanformData.PlanformData.OuterWing.Span/2;
                    %Span = (PlanformData.PlanformData.InnerWing.Span+PlanformData.PlanformData.OuterWing.Span);
                    PlanformData.PlanformData.InnerWing.RootChord=InnerRootC;

                    PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                    PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                    PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                    PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                    PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                    PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                    PlanformData.PlanformData.error = 1;
                    PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;

                    while abs(PlanformData.PlanformData.Difference) >= PlanformData.PlanformData.error
                        if PlanformData.PlanformData.Difference > PlanformData.PlanformData.error
                            PlanformData.PlanformData.InnerWing.RootChord=PlanformData.PlanformData.InnerWing.RootChord+0.1*PlanformData.PlanformData.InnerWing.RootChord;
                            PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                            PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                            PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                            PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                            PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;
                        elseif PlanformData.PlanformData.Difference < PlanformData.PlanformData.error
                            PlanformData.PlanformData.InnerWing.RootChord=PlanformData.PlanformData.InnerWing.RootChord-0.1*PlanformData.PlanformData.InnerWing.RootChord;
                            PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                            PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                            PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                            PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                            PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;
                        end
                    end

                    PlanformData.PlanformData.InnerWing.Chord=0.5*(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord);
                    PlanformData.PlanformData.OuterWing.Chord=0.5*(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord);
                    PlanformData.PlanformData.Wing.MGC=(PlanformData.PlanformData.InnerWing.Chord*PlanformData.PlanformData.InnerWing.S+PlanformData.PlanformData.OuterWing.Chord*PlanformData.PlanformData.OuterWing.S)/(PlanformData.PlanformData.Wing.S/2);
                    PlanformData.PlanformData.Wing.Dist2HT = PlanformData.PlanformData.Wing.XhMGC*PlanformData.PlanformData.Wing.MGC;


                    %Vertical Tail
                    PlanformData.PlanformData.VerticalTail.AR=1.35;
                    PlanformData.PlanformData.VerticalTail.SweepAng=43;
                    PlanformData.PlanformData.VerticalTail.TaperRat=0.5;
                    PlanformData.PlanformData.VerticalTail.Vv=0.08;
                    PlanformData.PlanformData.VerticalTail.Xvb=0.44;
                    PlanformData.PlanformData.Wing.Dist2VT=PlanformData.PlanformData.VerticalTail.Xvb*PlanformData.PlanformData.Wing.b;
                    PlanformData.PlanformData.VerticalTail.S=PlanformData.PlanformData.VerticalTail.Vv*PlanformData.PlanformData.Wing.S*PlanformData.PlanformData.Wing.MGC/PlanformData.PlanformData.Wing.Dist2VT;
                    PlanformData.PlanformData.VerticalTail.b=power(PlanformData.PlanformData.VerticalTail.S*PlanformData.PlanformData.VerticalTail.AR,1/2);
                    PlanformData.PlanformData.VerticalTail.RootChord=2*PlanformData.PlanformData.VerticalTail.S/(1.5*PlanformData.PlanformData.VerticalTail.b);
                    PlanformData.PlanformData.VerticalTail.TipChord=PlanformData.PlanformData.VerticalTail.TaperRat*PlanformData.PlanformData.VerticalTail.RootChord;

                    %Horizontal Tail
                    PlanformData.PlanformData.HorizontalTail.AR=4.75;
                    PlanformData.PlanformData.HorizontalTail.SweepAng=27.5; %degrees
                    PlanformData.PlanformData.HorizontalTail.TaperRat=0.44;
                    PlanformData.PlanformData.HorizontalTail.Vh=1;
                    PlanformData.PlanformData.HorizontalTail.S=PlanformData.PlanformData.HorizontalTail.Vh*PlanformData.PlanformData.Wing.S*PlanformData.PlanformData.Wing.MGC/PlanformData.PlanformData.Wing.Dist2HT;
                    PlanformData.PlanformData.HorizontalTail.b=power(PlanformData.PlanformData.HorizontalTail.S*PlanformData.PlanformData.HorizontalTail.AR,1/2);
                    PlanformData.PlanformData.HorizontalTail.RootChord=2*PlanformData.PlanformData.HorizontalTail.S/(1.44*PlanformData.PlanformData.HorizontalTail.b);
                    PlanformData.PlanformData.HorizontalTail.TipChord=PlanformData.PlanformData.HorizontalTail.RootChord*PlanformData.PlanformData.HorizontalTail.TaperRat;
                    PlanformData.PlanformData.HorizontalTail.MGC=0.5*(PlanformData.PlanformData.HorizontalTail.RootChord+PlanformData.PlanformData.HorizontalTail.TipChord);
                    PlanformData.PlanformData.HorizontalTail.twodLiftCurve=0.06;
                    PlanformData.PlanformData.HorizontalTail.iHT = 0;

                    %Engine
                    PlanformData.PlanformData.Engine.NacelleDiameter = 4.5;
                    PlanformData.PlanformData.Engine.LengthActual = 9.3;
                    PlanformData.PlanformData.Engine.LengthExtended = 12;
                    PlanformData.PlanformData.Engine.NacelleFrontDiameter = 6;
                    PlanformData.PlanformData.Engine.NacelleFrontLength = 2;
                    PlanformData.PlanformData.Engine.NacelleRearDiameter = 3;
                    PlanformData.PlanformData.Engine.NacelleRearLength = 4;
                    PlanformData.PlanformData.Engine.NacelleMountWidth = 6.739;
                    PlanformData.PlanformData.Engine.NacelleMountLength = 6.739;

                    if PlanformData.PlanformData.Wing.MGC > PlanformData.PlanformData.InnerWing.RootChord
                        PlanformData.PlanformData.Wing.MGCSweep = PlanformData.PlanformData.InnerWing.Sweep;   
                    elseif PlanformData.PlanformData.Wing.MGC < PlanformData.PlanformData.InnerWing.RootChord
                        PlanformData.PlanformData.Wing.MGCSweep = PlanformData.PlanformData.OuterWing.Sweep;
                    end

                    PlanformData.PlanformData.distFromCenterLine = (PlanformData.PlanformData.Wing.S/2)/(PlanformData.PlanformData.InnerWing.TipChord + PlanformData.PlanformData.Wing.MGC);
                    PlanformData.PlanformData.Wing.MGCXLoc = tan(deg2rad(PlanformData.PlanformData.Wing.MGCSweep))*(PlanformData.PlanformData.distFromCenterLine);
                    PlanformData.PlanformData.AircraftLength=PlanformData.PlanformData.Wing.Dist2HT+.75*PlanformData.PlanformData.HorizontalTail.RootChord+0.25*PlanformData.PlanformData.Wing.MGC+PlanformData.PlanformData.Wing.MGCXLoc;
                    
                otherwise
                    PlanformData.PlanformData.Wing.S = S;
                    PlanformData.PlanformData.Wing.AR=AR;
                    PlanformData.PlanformData.Wing.b = power(PlanformData.PlanformData.Wing.AR * PlanformData.PlanformData.Wing.S, 1/2);
                    PlanformData.PlanformData.Wing.Loading = Loading;
                    PlanformData.PlanformData.Wing.MGCHeight=MGCHeight; %Mean Geometric Height from ground - ft
                    PlanformData.PlanformData.Wing.XhMGC=3.6; %Distance between wing and HT divided by MGC
                    PlanformData.PlanformData.Wing.SeSh=0.257; %area of elevator to HT
                    PlanformData.PlanformData.Wing.SrSv=0.293; %rudder area to VT volume
                    PlanformData.PlanformData.Wing.TaperRat=0.3;
                    PlanformData.PlanformData.InnerWing.TaperRat=InnerTapRat;
                    PlanformData.PlanformData.OuterWing.TaperRat=OuterTapRat;
                    PlanformData.PlanformData.Wing.ao = 0.11;
                    PlanformData.PlanformData.Wing.iwing = iWing;
                    PlanformData.PlanformData.Wing.zerolift = -2.5;

                    %Fuselage
                    PlanformData.PlanformData.Fuselage.Length = Length;
                    PlanformData.PlanformData.Fuselage.Diameter = Diameter; %This is the lateral length

                    %InnerWing and OuterWing
                    PlanformData.PlanformData.InnerWing.Sweep=InnerSweep;

                    PlanformData.PlanformData.InnerWing.Span = (0.75*PlanformData.PlanformData.Fuselage.Diameter)*2; % ft
                    PlanformData.PlanformData.InnerWing.HalfSpan = PlanformData.PlanformData.InnerWing.Span/2;
                    PlanformData.PlanformData.OuterWing.Sweep=OuterSweep;

                    PlanformData.PlanformData.OuterWing.Span = PlanformData.PlanformData.Wing.b-PlanformData.PlanformData.InnerWing.Span; % ft
                    PlanformData.PlanformData.OuterWing.HalfSpan =PlanformData.PlanformData.OuterWing.Span/2;
                    %Span = (PlanformData.PlanformData.InnerWing.Span+PlanformData.PlanformData.OuterWing.Span);
                    PlanformData.PlanformData.InnerWing.RootChord=InnerRootC;

                    PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                    PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                    PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                    PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                    PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                    PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                    PlanformData.PlanformData.error = 1;
                    PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;

                    while abs(PlanformData.PlanformData.Difference) >= PlanformData.PlanformData.error
                        if PlanformData.PlanformData.Difference > PlanformData.PlanformData.error
                            PlanformData.PlanformData.InnerWing.RootChord=PlanformData.PlanformData.InnerWing.RootChord+0.1*PlanformData.PlanformData.InnerWing.RootChord;
                            PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                            PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                            PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                            PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                            PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;
                        elseif PlanformData.PlanformData.Difference < PlanformData.PlanformData.error
                            PlanformData.PlanformData.InnerWing.RootChord=PlanformData.PlanformData.InnerWing.RootChord-0.1*PlanformData.PlanformData.InnerWing.RootChord;
                            PlanformData.PlanformData.InnerWing.TipChord = PlanformData.PlanformData.InnerWing.RootChord*PlanformData.PlanformData.InnerWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.RootChord = PlanformData.PlanformData.InnerWing.TipChord; % ft
                            PlanformData.PlanformData.OuterWing.TipChord = PlanformData.PlanformData.OuterWing.RootChord*PlanformData.PlanformData.OuterWing.TaperRat; % ft
                            PlanformData.PlanformData.OuterWing.S=(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord)*PlanformData.PlanformData.OuterWing.HalfSpan/2;
                            PlanformData.PlanformData.InnerWing.S=(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord)*PlanformData.PlanformData.InnerWing.HalfSpan/2;
                            PlanformData.PlanformData.Area = 2*(PlanformData.PlanformData.OuterWing.S+PlanformData.PlanformData.InnerWing.S);
                            PlanformData.PlanformData.Difference = PlanformData.PlanformData.Wing.S-PlanformData.PlanformData.Area;
                        end
                    end

                    PlanformData.PlanformData.InnerWing.Chord=0.5*(PlanformData.PlanformData.InnerWing.TipChord+PlanformData.PlanformData.InnerWing.RootChord);
                    PlanformData.PlanformData.OuterWing.Chord=0.5*(PlanformData.PlanformData.OuterWing.TipChord+PlanformData.PlanformData.OuterWing.RootChord);
                    PlanformData.PlanformData.Wing.MGC=(PlanformData.PlanformData.InnerWing.Chord*PlanformData.PlanformData.InnerWing.S+PlanformData.PlanformData.OuterWing.Chord*PlanformData.PlanformData.OuterWing.S)/(PlanformData.PlanformData.Wing.S/2);
                    PlanformData.PlanformData.Wing.Dist2HT = PlanformData.PlanformData.Wing.XhMGC*PlanformData.PlanformData.Wing.MGC;


                    %Vertical Tail
                    PlanformData.PlanformData.VerticalTail.AR=1.35;
                    PlanformData.PlanformData.VerticalTail.SweepAng=43;
                    PlanformData.PlanformData.VerticalTail.TaperRat=0.5;
                    PlanformData.PlanformData.VerticalTail.Vv=0.08;
                    PlanformData.PlanformData.VerticalTail.Xvb=0.44;
                    PlanformData.PlanformData.Wing.Dist2VT=PlanformData.PlanformData.VerticalTail.Xvb*PlanformData.PlanformData.Wing.b;
                    PlanformData.PlanformData.VerticalTail.S=PlanformData.PlanformData.VerticalTail.Vv*PlanformData.PlanformData.Wing.S*PlanformData.PlanformData.Wing.MGC/PlanformData.PlanformData.Wing.Dist2VT;
                    PlanformData.PlanformData.VerticalTail.b=power(PlanformData.PlanformData.VerticalTail.S*PlanformData.PlanformData.VerticalTail.AR,1/2);
                    PlanformData.PlanformData.VerticalTail.RootChord=2*PlanformData.PlanformData.VerticalTail.S/(1.5*PlanformData.PlanformData.VerticalTail.b);
                    PlanformData.PlanformData.VerticalTail.TipChord=PlanformData.PlanformData.VerticalTail.TaperRat*PlanformData.PlanformData.VerticalTail.RootChord;

                    %Horizontal Tail
                    PlanformData.PlanformData.HorizontalTail.AR=4.75;
                    PlanformData.PlanformData.HorizontalTail.SweepAng=27.5; %degrees
                    PlanformData.PlanformData.HorizontalTail.TaperRat=0.44;
                    PlanformData.PlanformData.HorizontalTail.Vh=1;
                    PlanformData.PlanformData.HorizontalTail.S=PlanformData.PlanformData.HorizontalTail.Vh*PlanformData.PlanformData.Wing.S*PlanformData.PlanformData.Wing.MGC/PlanformData.PlanformData.Wing.Dist2HT;
                    PlanformData.PlanformData.HorizontalTail.b=power(PlanformData.PlanformData.HorizontalTail.S*PlanformData.PlanformData.HorizontalTail.AR,1/2);
                    PlanformData.PlanformData.HorizontalTail.RootChord=2*PlanformData.PlanformData.HorizontalTail.S/(1.44*PlanformData.PlanformData.HorizontalTail.b);
                    PlanformData.PlanformData.HorizontalTail.TipChord=PlanformData.PlanformData.HorizontalTail.RootChord*PlanformData.PlanformData.HorizontalTail.TaperRat;
                    PlanformData.PlanformData.HorizontalTail.MGC=0.5*(PlanformData.PlanformData.HorizontalTail.RootChord+PlanformData.PlanformData.HorizontalTail.TipChord);
                    PlanformData.PlanformData.HorizontalTail.twodLiftCurve=0.06;
                    PlanformData.PlanformData.HorizontalTail.iHT = 0;

                    %Engine
                    PlanformData.PlanformData.Engine.NacelleDiameter = 4.5;
                    PlanformData.PlanformData.Engine.LengthActual = 9.3;
                    PlanformData.PlanformData.Engine.LengthExtended = 12;
                    PlanformData.PlanformData.Engine.NacelleFrontDiameter = 6;
                    PlanformData.PlanformData.Engine.NacelleFrontLength = 2;
                    PlanformData.PlanformData.Engine.NacelleRearDiameter = 3;
                    PlanformData.PlanformData.Engine.NacelleRearLength = 4;
                    PlanformData.PlanformData.Engine.NacelleMountWidth = 6.739;
                    PlanformData.PlanformData.Engine.NacelleMountLength = 6.739;

                    if PlanformData.PlanformData.Wing.MGC > PlanformData.PlanformData.InnerWing.RootChord
                        PlanformData.PlanformData.Wing.MGCSweep = PlanformData.PlanformData.InnerWing.Sweep;   
                    elseif PlanformData.PlanformData.Wing.MGC < PlanformData.PlanformData.InnerWing.RootChord
                        PlanformData.PlanformData.Wing.MGCSweep = PlanformData.PlanformData.OuterWing.Sweep;
                    end

                    PlanformData.PlanformData.distFromCenterLine = (PlanformData.PlanformData.Wing.S/2)/(PlanformData.PlanformData.InnerWing.TipChord + PlanformData.PlanformData.Wing.MGC);
                    PlanformData.PlanformData.Wing.MGCXLoc = tan(deg2rad(PlanformData.PlanformData.Wing.MGCSweep))*(PlanformData.PlanformData.distFromCenterLine);
                    PlanformData.PlanformData.AircraftLength=PlanformData.PlanformData.Wing.Dist2HT+.75*PlanformData.PlanformData.HorizontalTail.RootChord+0.25*PlanformData.PlanformData.Wing.MGC+PlanformData.PlanformData.Wing.MGCXLoc;

end

