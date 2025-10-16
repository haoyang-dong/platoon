function [initialActorPose,accelerationProfile,stopTime] = scenario_02_Platooning_StopAndGo(tractorTrailerParameters,vehicleDimension)
% Creates a scenario that is compatible with PlatooningUsingV2VTestBench model.
% This initializes the initial pose of leader, follower1 and follower2 in
% the Straight Road 3D Environment based on the given initial spacing and
% velocity. This also selects the appropriate acceleration profile.

% Copyright 2022 The MathWorks, Inc.

% Initial spacing between the vehicles in meters. (Distance between trailer
% end of vehicle 1 to tractor front of vehicle 2)
initialSpacing.LeaderToFollower1    = 20;
initialSpacing.Follower1ToFollower2 = 40;

% Initial velocity of vehicles in m/s.
initialVelocities.Leader    = 10;
initialVelocities.Follower1 = 08;
initialVelocities.Follower2 = 08;

% Get initial Pose
initialActorPose = helperInitializeVehiclePose(initialSpacing,initialVelocities,tractorTrailerParameters,vehicleDimension);

% Define the acceleration profile.
% 
% The acceleration profile is the input acceleration fed to the leader of
% the platoon. This scenario uses the acceleration profile which shows a
% stop and go behaviour.
accelerationProfile.Amplitude  = [1 -1];
accelerationProfile.Period     = 70;
accelerationProfile.PulseWidth = [7 5];
accelerationProfile.PhaseDelay = [45 15];

% Scenario stop time
stopTime = 70;

end

