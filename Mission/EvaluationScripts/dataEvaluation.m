clear
clc
close all

%% Data Evaluation
load('Mission.mat')
clear drag
len = 1:1:236;
len2 = 1:1:234;

for i = 1:1:length(missionComplete)
    weight(1,i) = missionComplete{i,2}.primaryMission.myStartup.SU.Weight;
    weight(2,i) = missionComplete{i,2}.primaryMission.myTaxi.TA.Weight;
    weight(3,i) = missionComplete{i,2}.primaryMission.myTakeoff.TO.weight;
    drag(1,i) = missionComplete{i,2}.primaryMission.myTakeoff.TO.drag;
    for k = 1:1:length(missionComplete{i,2}.primaryMission.myClimb.CL.weight)
        weight(3+k,i) = missionComplete{i,2}.primaryMission.myClimb.CL.weight(1,k);
        drag(1+k,i) = missionComplete{i,2}.primaryMission.myClimb.CL.drag(1,k);
    end
    for l = 1:1:length(missionComplete{i,2}.primaryMission.myCruise.CR.weight)
        weight(3+k+l,i) = missionComplete{i,2}.primaryMission.myCruise.CR.weight(1,l);
        drag(1+k+l,i) = missionComplete{i,2}.primaryMission.myCruise.CR.drag(1,l);
    end
    for m = 1:1:length(missionComplete{i,2}.primaryMission.myDescent.DE.weight)
        weight(3+k+l+m,i) = missionComplete{i,2}.primaryMission.myDescent.DE.weight(1,m);
        drag(1+k+l+m,i) = missionComplete{i,2}.primaryMission.myDescent.DE.drag(1,m);
    end
    weight(4+k+l+m,i) = missionComplete{i,2}.primaryMission.myLoiter.LO.weight;
    drag(2+k+l+m,i) = missionComplete{i,2}.primaryMission.myLoiter.LO.drag;
    for n = 1:1:length(missionComplete{i,2}.primaryMission.myDescentSecond.DE.weight)
        weight(4+k+l+m+n,i) = missionComplete{i,2}.primaryMission.myDescentSecond.DE.weight(1,n);
        drag(2+k+l+m+n,i) = missionComplete{i,2}.primaryMission.myDescentSecond.DE.drag(1,n);
    end
    weight(5+k+l+m,i) = missionComplete{i,2}.primaryMission.myLanding.LA.weight;
    weight(6+k+l+m,i) = missionComplete{i,2}.primaryMission.myTaxiAtLanding.TA.Weight;
    weight(7+k+l+m,i) = missionComplete{i,2}.primaryMission.myShutdown.SU.Weight;
    drag(3+k+l+m,i) = missionComplete{i,2}.primaryMission.myLanding.LA.drag;
   
%     figure(1)
%     hold on
%     plot(len,weight(:,i))
    
    figure(2)
    hold on
    plot(len2,drag(:,i))
end









