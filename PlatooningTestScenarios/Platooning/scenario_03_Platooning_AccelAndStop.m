function [initialActorPose,accelerationProfile,stopTime] = scenario_03_Platooning_AccelAndStop(tractorTrailerParameters,vehicleDimension)
% Creates a scenario that is compatible with PlatooningUsingV2VTestBench model.
% This initializes the initial pose of leader, follower1 and follower2 in
% the Straight Road 3D Environment based on the given initial spacing and
% velocity. This also selects the appropriate acceleration profile.

% Copyright 2022 The MathWorks, Inc.

% Initial spacing between the vehicles in meters. (Distance between trailer
% end of vehicle 1 to tractor front of vehicle 2)
initialSpacing.LeaderToFollower1    = 10;
initialSpacing.Follower1ToFollower2 = 10;

% Initial velocity of vehicles in m/s.
initialVelocities.Leader    = 10;
initialVelocities.Follower1 = 10;
initialVelocities.Follower2 = 10;

% Get initial Pose
initialActorPose = helperInitializeVehiclePose(initialSpacing,initialVelocities,tractorTrailerParameters,vehicleDimension);

% Define the acceleration profile.
% 
% The acceleration profile is the input acceleration fed to the leader of
% the platoon. This scenario uses the acceleration profile which shows a
% accelerate and stop behaviour.
accelerationProfile.Amplitude  = [1 -1];
accelerationProfile.Period     = 50;
accelerationProfile.PulseWidth = [5 25];
accelerationProfile.PhaseDelay = [10 30];

% Scenario stop time
stopTime = 50;
end

