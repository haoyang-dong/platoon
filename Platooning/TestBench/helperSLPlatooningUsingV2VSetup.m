function helperSLPlatooningUsingV2VSetup(nvp)
% helperSLPlatooningUsingV2VSetup is called in the PostLoadFcn callback of
% PlatooningUsingV2VTestBench.slx model.
%
% helperSLPlatooningUsingV2VSetup() initializes model configuration
% parameters, workspace variables and Simulink bus objects for
% PlatooningUsingV2VTestBench.slx model for the test scenario defined by
% "scenarioFcnName".
% 
% scenarioFcnName: - Name of function which returns scenario which is
%                    compatible with PlatooningUsingV2VTestBench.slx model
%                    - Valid values are:
%                      "scenario_01_Platooning_StartAndSlow"
%                      "scenario_02_Platooning_StopAndGo"
%                      "scenario_03_Platooning_AccelAndStop"
%
% Range: - Option to set Range
%            - Valid values (0 - 1000 meter)
%            - default range is 150 meter
%            - Set Range = 0 to disable V2X
% 
% Examples of calling this function:
% -----------------------------------
% 
% helperSLPlatooningUsingV2VSetup("ScenarioFcnName","scenario_01_Platooning_StartAndSlow","Range",150);
% helperSLPlatooningUsingV2VSetup("ScenarioFcnName","scenario_02_Platooning_StopAndGo");
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2022 The MathWorks, Inc.
%% Define arguments
arguments
    % Scenario function name. 
    % "scenario_01_Platooning_StraightRoad" is set as default
    nvp.ScenarioFcnName(1,1) {mustBeMember(nvp.ScenarioFcnName, ...
        ["scenario_01_Platooning_StartAndSlow", ...
        "scenario_02_Platooning_StopAndGo", ...
        "scenario_03_Platooning_AccelAndStop"])} = "scenario_01_Platooning_StartAndSlow";

    % Vehicle-to-Vehicle communication Range. Default value set to 150m
    nvp.Range(1,1) {mustBeNonnegative(nvp.Range),mustBeLessThanOrEqual(nvp.Range,1000)} = 150; 
end
%% Load the Simulink model
modelName = 'PlatooningUsingV2VTestBench';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end
% Set random seed to ensure reproducibility.
rng(80);
%% Setup Scenario and Initial Values

% Load Scenario 
scenarioFcnHandle = str2func(nvp.ScenarioFcnName);

% Initialize the 6DOF tractor trailer model parameters.
[tractorTrailerParams,vehicleDimension] = helperInitTractorTrailerParams();

% Call scenario function
[initialActorPose,accelerationProfile,stopTime] = scenarioFcnHandle(tractorTrailerParams,vehicleDimension);

% Assign stop time
assignin("base","stopTime",stopTime);
% Assign Initial Pose 
assignin("base","initialActorPose",initialActorPose);
% Assign choice for acceleration profile
assignin("base","accelerationProfile",accelerationProfile);
% Assign the tractor trailer parameters and its dimensions into the base
% workspace
assignin("base","vehicleDimension",vehicleDimension);
assignin("base","czWhlAxl",tractorTrailerParams.CzWhlAxl)
assignin("base","f0zWhlAxl",tractorTrailerParams.F0zWhlAxl)
assignin("base","hMax",tractorTrailerParams.Hmax)
assignin("base","kzWhlAxl",tractorTrailerParams.KzWhlAxl)
assignin("base","tractor",tractorTrailerParams.VEH)
assignin("base","trailer",tractorTrailerParams.TRA)
assignin("base","hitch",tractorTrailerParams.HTCH)
%% Setup Model Parameters

% Scene Origin
assignin("base","sceneOrigin",[42.2995, -83.6990, 0]);
% Model Sample Time
assignin("base","Ts",0.02);
% Visualization Sample Time
assignin("base","Tsv",0.2);

%% Setup Controller Constants
% Spacing between trailer end of vehicle 1 to tractor front vehicle 2.
spacing = 7; 
% Expected spacing from tractor to tractor. (Tractor Length + Trailer Length + Spacing) 
L  = vehicleDimension.TractorLength + vehicleDimension.TrailerLength + vehicleDimension.InterConnection - vehicleDimension.Overlap + spacing;
assignin("base","L",L);
assignin("base","spacing",spacing);
% Assign controller constants
assignin("base","C1",0.8);    % Constant gain for acceleration control
assignin("base","K1",8);      % Constant gain for velocity control
assignin("base","K2",[2 0]);  % PD gains for spacing control [P,D]
assignin("base","N",160);     % Filter coefficient for PD controller
%% Load the SNR Curves
V2VRange = nvp.Range;
if exist("V2XChannelInfo.mat","file")
    snrCurvesData = load("V2XChannelInfo.mat");
    channelAttributes = snrCurvesData.snrCurves;
    % Adjust distance to SNR Relation based on range
    maxRange = 1000; % (meters)
    offsetIdx = round(max(1,min(V2VRange,maxRange))); 
    channelAttributes.dist2snr(:,2) = channelAttributes.dist2snr(:,2) + channelAttributes.snrOffset(offsetIdx);
    assignin("base","channelAttributes",channelAttributes);
    assignin("base","V2VRange",V2VRange)
else
    error('V2XChannelInfo.mat file not found')
end
%% Create all the Simulink Bus 
evalin("base","helperSLCreatePlatooningUsingV2VBus");
%% Create the enumeration data types needed for V2V Communication
evalin("base","helperCreateV2VEnumData");
%% Camera Views

% initialize the camera translation for various views
cameraViews.Translation.SideView      = [ 0 125 15];
cameraViews.Translation.TopView       = [ 0  0 150];
cameraViews.Translation.RearSideView  = [-80 55 25];
cameraViews.Translation.FrontSideView = [100 85 85];

% initialize the camera rotation for various views
cameraViews.Rotation.SideView      = [ 0  0 -90];
cameraViews.Rotation.TopView       = [90  90  0];
cameraViews.Rotation.RearSideView  = [0  20 -45];
cameraViews.Rotation.FrontSideView = [0 35 -135];

% initialize the initial camera translation and roation
initialCameraView.Translation = [100 85 85];
initialCameraView.Rotation    = [0 35 -135];

% assign the camera translation and roation to workspace
assignin("base","cameraViews",cameraViews);
assignin("base","initialCameraView",initialCameraView);
%% Position the scopes
screenSize = double(get(groot,'ScreenSize')); % get screen size
scopeSize1 = [(screenSize(1,3)-screenSize(1,3)*0.31) (screenSize(1,4)-screenSize(1,4)*0.4) (screenSize(1,3:4)*0.3)]; % 30% of screen size
scopeConfiguration = get_param('PlatooningUsingV2VTestBench/Visualization/Spacing Plot','ScopeConfiguration');
scopeConfiguration.Position = scopeSize1;
scopeConfiguration.Title = '';

scopeSize2 = scopeSize1 - [0 scopeSize1(:,4)*1.3 0 0];
scopeConfiguration = get_param('PlatooningUsingV2VTestBench/Visualization/Velocity Plot','ScopeConfiguration');
scopeConfiguration.Position = scopeSize2;
scopeConfiguration.Title = '';
end