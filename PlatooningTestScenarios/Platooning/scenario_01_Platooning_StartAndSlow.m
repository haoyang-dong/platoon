function [initialActorPose,accelerationProfile,stopTime] = scenario_01_Platooning_StartAndSlow(tractorTrailerParameters,vehicleDimension)
% Creates a scenario that is compatible with PlatooningUsingV2VTestBench
% model. This initializes the initial pose of leader, follower1 and
% follower2 in the Straight Road 3D Environment based on the given initial
% spacing and velocity. This also selects the appropriate acceleration
% profile.

% Copyright 2022 The MathWorks, Inc.

% Initial spacing between the vehicles in meters. (Distance between trailer
% end of vehicle 1 to tractor front of vehicle 2)
initialSpacing.LeaderToFollower1    = 55;
initialSpacing.Follower1ToFollower2 = 35;

% Initial velocity of vehicles in m/s.
initialVelocities.Leader    = 0;
initialVelocities.Follower1 = 0;
initialVelocities.Follower2 = 0;

% Get initial Pose
initialActorPose = helperInitializeVehiclePose(initialSpacing,initialVelocities,tractorTrailerParameters,vehicleDimension);

% Define the acceleration profile.
% 
% The acceleration profile is the input acceleration fed to the leader of
% the platoon. This scenario uses the acceleration profile which shows a
% start and slow behaviour.
accelerationProfile.Amplitude  = [2 -2];
accelerationProfile.Period     = 50;
accelerationProfile.PulseWidth = [10 5];
accelerationProfile.PhaseDelay = [10 40];

% Scenario stop time
stopTime = 50;
end

