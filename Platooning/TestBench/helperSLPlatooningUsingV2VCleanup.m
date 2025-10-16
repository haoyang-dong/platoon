% Clean up script for the Platooning Using V2V Example
%
% This script cleans up the base workspace variables created by the example
% model. It is triggered by the CloseFcn callback of
% PlatooningUsingV2VTestBench.
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2022 The MathWorks, Inc.

clearBuses({...
    'BusAccelerationSet4Way',...
    'BusActorPose',...
    'BusActorsInfo',...
    'BusBrakeSystemStatus',...
    'BusBSM',...
    'BusBSMCoreData',...
    'BusLeadAndFrontInfo',...
    'BusPositionalAccuracy',...
    'BusVehicleSize'});

clear C1
clear channelAttributes
clear czWhlAxl
clear f0zWhlAxl
clear hMax
clear hitch
clear initialActorPose
clear K1
clear K2
clear kzWhlAxl
clear L
clear N
clear scenario
clear sceneOrigin
clear trailer
clear tractorTrailerID
clear egoID
clear Ts
clear tractor
clear vehicleDimension
clear V2VRange
clear Tsv
clear tractorInertToTrailerInert
clear stopTime
clear accelerationProfile
clear spacing
clear initialCameraView
clear cameraViews

function clearBuses(buses)
matlabshared.tracking.internal.DynamicBusUtilities.removeDefinition(buses);
end