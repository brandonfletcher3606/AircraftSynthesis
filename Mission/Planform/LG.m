function LG = LG(mission,CGWOLG)
Wto    = mission.planform.weightData.takeoff;
Wfuel  = mission.planform.weightData.fuel;
CGoef_x= CGWOLG.CG.CG_X_3;
CGoep_x= CGWOLG.CG.CG_X_5;
CGoef_z= CGWOLG.CG.CG_Z_3;
% CGoef_xcon= CGWOLG.CGTest.CGOEF_X; %Used in the convergence step
% CGoep_xcon= CGWOLG.CGTest.CGOEP_X; %""
% CGoef_zcon= CGWOLG.CGTest.CGOEF_Z; %""
Phi    = 15;
Psai   = 43;
h_fuse = mission.planform.geometryData.fuselage.diameterShort;
h_strut= 66;
h_CG   = CGoef_z+(h_fuse/2)+h_strut;
% h_CGcon= CGoef_zcon+(h_fuse/2)+h_strut;
n_s    = 2;
bp     = h_CG/tan(Psai);
% bpcon  = h_CGcon/tan(Psai);

%Positions of Gear
l_nx    = CGoep_x-400; %[in] Distance of nose gear from the nose.
% l_nxcon = CGoep_xcon-400;
l_mx    = CGoef_x+h_CG*tan(deg2rad(Phi)); %[in] Distance of main gear from the nose.
% l_mxcon = CGoef_xcon+h_CGcon*tan(deg2rad(Phi));
theta   = asin(bp/(l_nx+400));
% thetacon= asin(bpcon/(l_nxcon+400));
l_my    = ((l_nx+400)+(l_mx-CGoef_x))*tan(theta); %[in] Lateral Distance from Centerline.
% l_mycon = ((l_nxcon+400)+(l_mxcon-CGoef_xcon))*tan(thetacon);
LG.Position.Nose = [l_nx,0];
LG.Position.Main = [l_mx,l_my];
% LG.Position.Nosecon = [l_nxcon,0];
% LG.Position.Maincon = [l_mxcon,l_mycon];
%Maximum Static Load per Strut
P_n    = (Wto*(l_mx-CGoef_x))/((l_mx-CGoef_x)+(l_nx+400)); %[lb] Amount of weight on nose gear
P_m    = (Wto*(l_nx+400))/(n_s*((l_mx-CGoef_x)+(l_nx+400)));
% P_ncon = (Wto*(l_mxcon-CGoef_xcon))/((l_mxcon-CGoef_xcon)+(l_nxcon+400));
% P_mcon = (Wto*(l_nxcon+400))/(n_scon*((l_mxcon-CGoef_xcon)+(l_nxcon+400)));
LG.Loading.Nose = P_n;
LG.Loading.Main = P_m;
% LG.Loading.Nosecon = P_ncon;
% LG.Loading.Maincon = P_mcon;
%Strut Travel on Impact
Wland  = 0.9*Wto;
Vz     = 12; %[fps] vertical touchdown rate. MANDATED PER FAR25, DO NOT CHANGE THIS!!
g      = 32.2; %[fps] gravity.  Unless we're going off-world, don't touch this!
Ng     = 1; %Landing Gear Load Factor, approximately 1 per convention.
Sstrut = (0.5*Wland*(power(Vz,2)/g))/(n_s*P_m*Ng); %[ft] Distance the strut compresses on landing
% Sstrutcon = (0.5*Wland*(power(Vz,2)/g))/(n_s*P_mcon*Ng);
Dstrut = 0.041+0.0025*power(P_m,0.5); %[ft] Strut Diameter
% Dstrutcon = 0.041+0.0025*power(P_mcon,0.5);
LG.Loading.StrutTravel = Sstrut/.8;
LG.Loading.StrutDiameter = Dstrut;

% diff = 100000000;
% while diff >= 0.05
%  a = CGoef_x -   
% LG.Loading.StrutTravel = Sstrutcon/.8;
% LG.Loading.StrutDiameter = Dstrutcon;
end