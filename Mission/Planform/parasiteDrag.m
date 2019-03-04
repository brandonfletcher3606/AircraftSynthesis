function Drag = parasiteDrag(planform)



%% |Drag Component Build-Up (Parasite Drag)|
% |Created by Aaron Ross|
% 
% |--------------------------------------------------------------|
P = planform.globalData;
G = planform.geometryData;
Pe = planform.performanceData;

[~,~,~,rho] = atmosisa(Pe.cruiseAltitude*0.3048);
rho=rho*0.00194032;%slugs/ft^3

%% Conditions
%%
DynamicPressure = 0.5 * rho * power(Pe.cruiseVelocity,2); % slugs/ft^2
AirDensity.CruiseAltitude = rho; % slugs/ft^3 0.000794
Velocity.Cruise = Pe.cruiseVelocity; % ft/s
Altitude = Pe.cruiseAltitude; % ft
Kinematic.Viscosity = P.dynamicViscosity(1,1)/AirDensity.CruiseAltitude; % ft^2/s
%% Geometrical Data and Gross-Wetted Area Calculations
% * Fuselage
%%
% Fuselage.Length = 50; % ft
% Fuselage.Diameter = 14; % ft
% Fuselage.Perimeter = Fuselage.Diameter * pi; % ft
% Fuselage.t_c = 0.72 % thickness / mgc
% Fuselage.CF = 0.3325 * Fuselage.t_c + 1.0199; % Correction Factor
% Fuselage.GWArea = Fuselage.Length * Fuselage.Perimeter * Fuselage.CF; % ft^2
%% 
% * Inner Wing (Center-Body Airfoil)
% * 

Number.InnerWings = 2;
InnerWing.Span = G.innerWing.b(1,1)/2; % ft
InnerWing.RootChord = G.innerWing.rootChord(1,1); % ft
InnerWing.TipChord = G.innerWing.tipChord(1,1); % ft
InnerWing.t_c = 0.18; % thickness / mgc
InnerWing.CF = 0.3325 * InnerWing.t_c + 1.0199; % Correction Factor (Do Not Change)
InnerWing.GWArea = Number.InnerWings * (InnerWing.Span * (InnerWing.RootChord + InnerWing.TipChord) / 2); % ft^2
%% 
% * Outer Wing (Outer-Wing Airfoil)
%%
Number.OuterWings = 2;
OuterWing.Span = G.outerWing.b(1,1)/2; % ft
OuterWing.RootChord = InnerWing.TipChord; % ft
OuterWing.TipChord = G.outerWing.tipChord(1,1); % ft
OuterWing.t_c = 0.18; % thickness / mgc
OuterWing.CF = 0.3325 * OuterWing.t_c + 1.0199; % Correction Factor (Do Not Change)
OuterWing.GWArea = Number.OuterWings * (OuterWing.Span * (OuterWing.RootChord + OuterWing.TipChord) / 2); % ft^2
%% 
% * Flaps (Control Surfaces)
%%
Number.Flaps = 2;
Flaps.Width = .30*G.wing.mgc; % ft
Flaps.Length = 0.65*G.wing.b; % ft
Flaps.t_c = 0.18; % thickness / mgc
Flaps.CF = 0.3325 * Flaps.t_c + 1.0199; % Correction Factor (Do Not Change)
Flaps.GWArea = Number.Flaps * (Flaps.Width * Flaps.Length); % ft^2
%% 
% * Horizontal Tail
%%
Number.HTWings = 2;
HT.Span = G.horizontalTail.b(1,1)/2; % ft
HT.RootChord = G.horizontalTail.rootChord(1,1); % ft
HT.TipChord = G.horizontalTail.tipChord(1,1); % ft
HT.t_c = G.horizontalTail.thicknessRatio(1,1); % thickness / mgc
HT.CF = 0.3325 * HT.t_c + 1.0199; % Correction Factor (Do Not Change)
HT.GWArea = Number.HTWings * (HT.Span * (HT.RootChord + HT.TipChord) / 2); % ft^2
%% 
% * Vertical Tail
%%
VT.Span = G.verticalTail.b(1,1); % ft
VT.Width = 1.75; % ft
VT.RootChord = G.verticalTail.rootChord(1,1); % ft
VT.TipChord = G.verticalTail.tipChord(1,1); % ft
VT.t_c = G.verticalTail.thicknessRatio(1,1); % thickness / mgc
VT.CF = 0.3325 * VT.t_c + 1.0199; % Correction Factor (Do Not Change)
VT.GWArea = (VT.Span * (VT.RootChord + VT.TipChord) / 2); % ft^2

VTMount.Length = VT.Span; % ft
VTMount.Width = VT.RootChord; % ft
%% 
% * Landing Gear
%%
SmallWheel.Number = 2;
SmallWheel.Width = 1.5;
SmallWheel.Length = 5.0596;
SmallWheel.FGWArea = SmallWheel.Number * (SmallWheel.Length * SmallWheel.Width);

BigWheel.Number = 4;
BigWheel.Width = 2;
BigWheel.Length = 6;
BigWheel.FGWArea = BigWheel.Number *(BigWheel.Length * BigWheel.Width);

MiddleStrut.Number = 1;
MiddleStrut.Length = 8.8;
MiddleStrut.Width = 4;
MiddleStrut.FGWArea = MiddleStrut.Number * (MiddleStrut.Length * MiddleStrut.Width);

OuterStrut.Number = 2;
OuterStrut.Length = 6;
OuterStrut.Width =3;
OuterStrut.FGWArea = OuterStrut.Number * (OuterStrut.Length * OuterStrut.Width);
%% 
% * Windshield
%%
Windshield.Length = 18.25166667; % ft
Windshield.Width = 2.01125; % ft
%% 
% * Engine Nacelles 
%%
Number.EngineNacelles = 2;

EngineNacelle.Diameter = G.engine.nacelleDiameter(1,1); % For now use average
EngineNacelle.LengthActual = G.engine.lengthActual(1,1); % This will be the length of the Nacelle with the engine in it total
EngineNacelle.LengthExtended = G.engine.lengthExtended(1,1); % This length will be used to calculate the drag as a streamlined body and will later be corrected for discontinuities, and in proportion to actual wetted area
EngineNacelle.MaxPerimeter = EngineNacelle.Diameter * pi;
EngineNacelle.FrontalArea = pi * (EngineNacelle.Diameter/2)^2;

EngineNacelle.FrontDiameter = G.engine.nacelleFrontDiameter; % ft
EngineNacelle.FrontLength = G.engine.nacelleFrontLength; % ft
EngineNacelle.RearDiameter = G.engine.nacelleRearDiameter; %ft
EngineNacelle.RearLength = G.engine.nacelleRearLength; % ft

NacelleMount.Width = G.engine.nacelleMountWidth; % ft
NacelleMount.Length = G.engine.nacelleMountLength; % ft
%% Reynold's Number & Coefficients of Skin Friction Drag
% * Fuselage
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
% Fuselage.RN = (Velocity.Cruise * Fuselage.Length) / Kinematic.Viscosity; % Unitless
% Fuselage.CFB = 0.455 / (log10(Fuselage.RN)^2.58); % Unitless
%% 
% * Wings (Inner & Outer Wings)
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
Wing.RN = (Velocity.Cruise * (InnerWing.Span + OuterWing.Span) )/ Kinematic.Viscosity; % Unitless
Wing.CFB = 0.455 / (log10(Wing.RN)^2.58); % Unitless
%% 
% * Horizontal Tail
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
HT.RN = (Velocity.Cruise * HT.Span) / Kinematic.Viscosity; % Unitless
HT.CFB = 0.455 / (log10(HT.RN)^2.58); % Unitless
%% 
% * Vertical Tail
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
VT.RN = (Velocity.Cruise * VT.Span) / Kinematic.Viscosity; % Unitless
VT.CFB = 0.455 / (log10(VT.RN)^2.58); % Unitless
%% 
% * Engine Nacelles
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
EngineNacelle.RN = (Velocity.Cruise * EngineNacelle.LengthExtended) / Kinematic.Viscosity; % Unitless
EngineNacelle.CFB = 0.455 / (log10(EngineNacelle.RN)^2.58); % Unitless
%% 
% * Landing Gear
% 
% $\mathrm{RN}=\frac{V\cdot L}{\nu }$ ; Reynold's Number
% 
% $C_{\mathrm{FB}} =\frac{0\ldotp 455}{{\mathrm{Log}}_{10} {\left(\mathrm{RN}\right)}^{2\ldotp 
% 58} }$ ; Coefficient of Skin-Friction Drag
%%
SmallWheel.RN = (Velocity.Cruise * SmallWheel.Length) / Kinematic.Viscosity; % Unitless
SmallWheel.CFB = 0.455 / (log10(SmallWheel.RN)^2.58); % Unitless

BigWheel.RN = (Velocity.Cruise * BigWheel.Length) / Kinematic.Viscosity; % Unitless
BigWheel.CFB = 0.455 / (log10(BigWheel.RN)^2.58); % Unitless

OuterStrut.RN = (Velocity.Cruise * OuterStrut.Length) / Kinematic.Viscosity; % Unitless
OuterStrut.CFB = 0.455 / (log10(OuterStrut.RN)^2.58); % Unitless

MiddleStrut.RN = (Velocity.Cruise * MiddleStrut.Length) / Kinematic.Viscosity; % Unitless
MiddleStrut.CFB = 0.455 / (log10(MiddleStrut.RN)^2.58); % Unitless
%% Intersecting Surface Area Properties
% * Fuselage
%%
Fuselage.WingIntersection = 0; % Wings do not intersect fuselage on Hybrid-Winged Body
Fuselage.HTIntersection = 0; % HT does not intersect fuselage on Hybrid-Winged Body
Fuselage.VTIntersection = VT.Width * VT.Span; % ft^2
Fuselage.NacelleMountIntersection = Number.EngineNacelles * (NacelleMount.Width * NacelleMount.Length); % ft^2
Fuselage.WindshieldIntersection = Windshield.Width * Windshield.Length; % ft^2  (NOTE: Will also be the Windshield Area)
%% 
% * Inner-Wing (Center-Body Airfoil)
%%
% No Intersecting Surfaces
%% 
% * Outer-Wing (Outer-Wing Airfoil)
%%
% No Intersecting Surfaces
%% 
% * Flaps (Control Surfaces)
%%
% No Intersecting Surfaces
%% 
% * Horizontal Tail
%%
% No Intersecting Surfaces
%% 
% * Vertical Tail
%%
VT.FuselageIntersection = VTMount.Width * VTMount.Length; % ft^2
%% Nett-Wetted Areas
% * Fuselage
%%
% Fuselage.NWArea = Fuselage.GWArea - (Fuselage.WingIntersection + Fuselage.HTIntersection + Fuselage.NacelleMountIntersection + Fuselage.VTIntersection + Fuselage.WindshieldIntersection); % ft^2
%% 
% * Inner-Wings (Center-Body Airfoil)
%%
InnerWing.NWArea = InnerWing.GWArea * InnerWing.CF;
%% 
% * Outer-Wings (Outer-Wing Airfoil)
%%
OuterWing.NWArea = OuterWing.GWArea * OuterWing.CF;
%% 
% * Flaps
%%
Flaps.NWArea = Flaps.GWArea * Flaps.CF;
%% 
% * Horizontal Tail
%%
HT.NWArea = HT.GWArea * HT.CF;
%% 
% * Vertical Tail
%%
VT.NWArea = VT.GWArea * VT.CF;
%% 
% * Engine Nacelles (Turbofan Only)
%%
EngineNacelle.Imaginary_Area = EngineNacelle.MaxPerimeter * 0.72 * EngineNacelle.LengthExtended;
EngineNacelle.Wet_Area = (pi * EngineNacelle.FrontDiameter * 0.9 * EngineNacelle.FrontLength) + (pi * EngineNacelle.RearDiameter * 0.8 * EngineNacelle.RearLength); % Approximation from Hoerner
%% 
% * Landing Gear
%%
% The Net-Wetted Area for the Landing Gear is Frontal Area
SmallWheel.NWArea = SmallWheel.FGWArea;
BigWheel.NWArea = BigWheel.FGWArea;
OuterStrut.NWArea = OuterStrut.FGWArea;
MiddleStrut.NWArea = MiddleStrut.FGWArea;
%% *Drag Calculations *
% * Fuselage
%%
% Fuselage.EquivalentMaxDiameter = Fuselage.Perimeter / pi; % ft
% Fuselage.LD = Fuselage.Length / Fuselage.Diameter;
% Fuselage.DL = Fuselage.Diameter / Fuselage.Length;
% 
% Fuselage.FDD = 1 + 1.5 * Fuselage.DL^(3/2) + 7 * Fuselage.DL^3;               % Streamlined Body Fluid Dynamic Drag Coefficient of Fuselage (CD_Wet/CFB)
% Fuselage.FA = 3 * Fuselage.LD + 4.5 * Fuselage.DL^(1/2) + 21 * Fuselage.DL^2; % Frontal Area Fluid Dynamic Drag Coefficient of Fuselage (CD/CFB)
% 
% Fuselage.CD_Wet = Fuselage.FDD * Fuselage.CFB;                                % Drag Coefficient of Wetted Area (CD_Wet)
% Fuselage.CD_Frontal = Fuselage.FA * Fuselage.CFB;                             % Drag Coefficient of Frontal Area (CD_Frontal)
% Fuselage.D_Wet = Fuselage.CD_Wet * 0.5 * AirDensity.CruiseAltitude * Fuselage.GWArea * Velocity.Cruise^2;         % Drag of Wetted Area [lbs]
% Fuselage.D_Frontal = Fuselage.CD_Frontal * 0.5 * AirDensity.CruiseAltitude * Fuselage.GWArea * Velocity.Cruise^2; % Drag of Frontal Area [lbs]
% 
% Fuselage.D_Basic = ((Fuselage.D_Wet + Fuselage.D_Frontal) / 2) * (Fuselage.NWArea / Fuselage.GWArea);   % Good Correlation for finding Actual Drag and corrects for Nett Area vs. Gross Wett Area
% Fuselage.D_Roughness = Fuselage.D_Basic * 0.10;   % 10% of the Basic Drag is a good approximation that accounts for plate laps, door handles, rivet and bolt heads
% Fuselage.D_Windshield = 0.06 * 0.5 * AirDensity.CruiseAltitude * Fuselage.WindshieldIntersection * Velocity.Cruise; % Windshield CD = 0.06 comes from Hoerner Data, but poor design can increase the Windshield's CD by 5x. MAKE IT SMOOTH!
% 
% Fuselage.Drag = Fuselage.D_Basic + Fuselage.D_Roughness + Fuselage.D_Windshield; % Total Profile Drag of the Fuselage [lbs]
% Fuselage.CDo = Fuselage.Drag / ((InnerWing.GWArea + OuterWing.GWArea) * DynamicPressure);              % Parasite Drag of the Fuselage
%% 
% * Inner-Wings (Center Airfoil)
%%
InnerWing.D_Basic = 0.008 * 0.5 * AirDensity.CruiseAltitude * InnerWing.GWArea * Velocity.Cruise^2; % Wing Profile Drag CD = 0.008 as an approximation in order to avoid assuming the full benefit of laminar flow using NACA 64(3)-218 in Theory Of Wing Sections
InnerWing.D_Roughness = InnerWing.D_Basic * 0.10; % 10% of the Basic Drag is a good approximation to account for bolt/rivet heads (anything unsmoothness in the surface)
InnerWing.D_Interference = (InnerWing.D_Basic + InnerWing.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty
InnerWing.Drag = (InnerWing.D_Basic + InnerWing.D_Roughness) + InnerWing.D_Interference; % Total Profile Drag of the Inner-wings [lbs]
InnerWing.CDo = InnerWing.Drag / ((InnerWing.GWArea + OuterWing.GWArea) * DynamicPressure);% Parasite Drag of the Inner Wings
%% 
% * Outer-Wings (Outer Airfoil)
%%
OuterWing.D_Basic = 0.008 * 0.5 * AirDensity.CruiseAltitude * OuterWing.GWArea * Velocity.Cruise^2; % Wing Profile Drag CD = 0.0065 as an approximation in order to avoid assuming the full benefit of laminar flow using NACA 64(3)-218 in Theory of Wing Sections
OuterWing.D_Roughness = OuterWing.D_Basic * 0.10; % 10% of the Basic Drag is a good approximation to account for bolt/rivet heads (anything unsmoothness in the surface)
OuterWing.D_Interference = (OuterWing.D_Basic + OuterWing.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty
OuterWing.Drag = OuterWing.D_Basic + OuterWing.D_Roughness + OuterWing.D_Interference; % Total Profile Drag of the Outer-wings [lbs]
OuterWing.CDo = OuterWing.Drag / ((InnerWing.GWArea + OuterWing.GWArea) * DynamicPressure); % Parasite Drag of the Outer Wings
%% 
% * Horizontal Tail
%%
HT.D_Basic = 0.007 * 0.5 * AirDensity.CruiseAltitude * HT.GWArea * Velocity.Cruise^2; % Horizontal Tail Profile Drag CD = 0.007 as an approximation in order to avoid assuming the full benefit of laminar flow using NACA 0012 CL vs CD in Theory of Wing Sections
HT.D_Roughness = HT.D_Basic * 0.10; % 10% of the Basic Drag is a good approximation to account for bolt/rivet heads (anything unsmoothness in the surface)
HT.D_Interference = (HT.D_Basic + HT.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty
HT.Drag = HT.D_Basic + HT.D_Roughness + HT.D_Interference;            % Total Profile Drag of the Horizontal Tail [lbs]
HT.CDo = HT.Drag / ((InnerWing.GWArea + OuterWing.GWArea) * DynamicPressure); % Parasite Drag of the Horizontal Tail
%% 
% * Vertical Tail
%%
VT.D_Basic = 0.007 * 0.5 * AirDensity.CruiseAltitude * VT.GWArea * Velocity.Cruise^2; % Vertical Tail Profile Drag CD = 0.007 as an approximation in order to avoid assuming the full benefit of laminar flow using NACA 0012 CL vs CD in Theory of Wing Sections
VT.D_Roughness = VT.D_Basic * 0.10; % 10% of the Basic Drag is a good approximation to account for bolt/rivet heads (anything unsmoothness in the surface)
VT.D_Interference = (VT.D_Basic + VT.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty
VT.Drag = VT.D_Basic + VT.D_Roughness + VT.D_Interference;            % Total Profile Drag of the Vertical Tail [lbs]
VT.CDo = VT.Drag / ((InnerWing.GWArea + OuterWing.GWArea) * DynamicPressure); % Parasite Drag of the Vertical Tail
%% 
% * Engine Nacelles
%%
EngineNacelle.EquivalentMaxDiameter = EngineNacelle.MaxPerimeter / pi; % ft
EngineNacelle.LD = EngineNacelle.LengthExtended / EngineNacelle.Diameter;
EngineNacelle.DL = EngineNacelle.Diameter / EngineNacelle.LengthExtended;

EngineNacelle.FA = 3 * EngineNacelle.LD + 4.5 * EngineNacelle.DL^(1/2) + 21 * EngineNacelle.DL^2; % Frontal Area Fluid Dynamic Drag Coefficient of Engine Nacelle (CD/CFB)
EngineNacelle.CD_Frontal = EngineNacelle.FA * EngineNacelle.CFB;                         % Drag Coefficient of Frontal Area (CD_Frontal)
EngineNacelle.D_Basic = (EngineNacelle.CD_Frontal * 0.5 * AirDensity.CruiseAltitude * EngineNacelle.Wet_Area * Velocity.Cruise^2)*(1 + 0.10); % Engine Nacelle Profile Drag with accounting for a 10% approximation of drag from discontinuities
EngineNacelle.Drag = EngineNacelle.D_Basic * (EngineNacelle.Wet_Area / EngineNacelle.Imaginary_Area) + (EngineNacelle.D_Basic) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty;
EngineNacelle.CDo = EngineNacelle.Drag / (DynamicPressure * (InnerWing.GWArea + OuterWing.GWArea)); % DOUBLE CHECK Which area should be used!
%% 
% * Take-Off/Landing Gear (Most Likely has errors in method or assumed CDo Profile 
% Drag)
%%
Cylindrical.FA = BigWheel.NWArea + SmallWheel.NWArea;
Cylindrical.D_Basic = 0.212 * 0.5 * AirDensity.CruiseAltitude * Cylindrical.FA * Velocity.Cruise^2; % CD Profile Drag Assumption
Cylindrical.D_Roughness = Cylindrical.D_Basic * 0.10;
Cylindrical.Drag = Cylindrical.D_Basic + Cylindrical.D_Roughness + (Cylindrical.D_Basic + Cylindrical.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty;
Cylindrical.CDo = Cylindrical.Drag / (DynamicPressure * (InnerWing.GWArea + OuterWing.GWArea));

Rectangular.FA = OuterStrut.NWArea + MiddleStrut.NWArea;
Rectangular.D_Basic = 0.216 * 0.5 * AirDensity.CruiseAltitude * Rectangular.FA * Velocity.Cruise^2; % CD Profile Drag Assumption
Rectangular.D_Roughness = Rectangular.D_Basic * 0.10;
Rectangular.Drag = Rectangular.D_Basic + Rectangular.D_Roughness + (Rectangular.D_Basic + Rectangular.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty;
Rectangular.CDo = Rectangular.Drag / (DynamicPressure * (InnerWing.GWArea + OuterWing.GWArea));

LandingGear.CDo = Cylindrical.CDo + Rectangular.CDo;
%% 
% * Flaps at 30 Degrees (Most Likely has errors in method or assumed CDo Profile 
% Drag)
%%
Flaps.D_Basic = 0.11 * 0.5 * AirDensity.CruiseAltitude * Flaps.NWArea * Velocity.Cruise^2; % CD Profile Drag Assumption
Flaps.D_Roughness = Flaps.D_Basic * 0.10;
Flaps.D_Interference = (Flaps.D_Basic + Flaps.D_Roughness) * 0.03;  % Hoerner's data adds 2% for clean and 5% for dirty
Flaps.Drag = Flaps.D_Basic + Flaps.D_Roughness + Flaps.D_Interference;
Flaps.CDo = Flaps.Drag / (DynamicPressure *(InnerWing.GWArea + OuterWing.GWArea));
%% Total Parasite Drag
%%
Drag.CDo.Clean = EngineNacelle.CDo + HT.CDo + InnerWing.CDo + OuterWing.CDo + VT.CDo;
Drag.CDo.TakeOff = EngineNacelle.CDo + HT.CDo + InnerWing.CDo + OuterWing.CDo + VT.CDo + LandingGear.CDo;
Drag.CDo.Landing = EngineNacelle.CDo + HT.CDo + InnerWing.CDo + OuterWing.CDo + VT.CDo + LandingGear.CDo + Flaps.CDo;
Drag.CDo.CruiseWithFlaps = EngineNacelle.CDo + HT.CDo + InnerWing.CDo + OuterWing.CDo + VT.CDo + Flaps.CDo;

end