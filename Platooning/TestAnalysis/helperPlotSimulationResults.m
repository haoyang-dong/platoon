function hFig = helperPlotSimulationResults(out)
% helper function to plot the simulation results for the platooning
% example. This function displays the camera images, spacing , velocity
% and information from V2V BSM Messages.
%
% This helper script for example purposes and may be removed or
% modified in the future.
% 
% Copyright 2022 The MathWorks, Inc.

% Create the figure window
figureName = 'Platooning Simulation Results';
hFig = findobj('Type','Figure','Name',figureName);

% create the figure only if it is not already open.
if isempty(hFig)
    hFig = figure('Name',figureName);
    hFig.NumberTitle = "off";
    hFig.Visible = "on";
    scrsz = double(get(groot,'ScreenSize'));
    hFig.Position = [70 70 scrsz(3)*0.9 scrsz(4)*0.7];
end

% Clear figure.
clf(hFig);  

% Create UI panel for camera images
cameraPanel = uipanel(hFig,"Title","Camera Display","Units","normalized","Position",[0 0.1 0.6 0.9],"BackgroundColor",[1 1 1]);
% Create UI panel for spacing plot
spacingPanel = uipanel(hFig,"Title","Spacing Plots","Units","normalized","Position",  [0.6 0.65 0.4 0.35],"BackgroundColor",[1 1 1]);
% Create UI panel for velocity plot
velocityPanel = uipanel(hFig,"Title","Velocity Plots","Units","normalized","Position",[0.6 0.3 0.4 0.35],"BackgroundColor",[1 1 1]);
% Create UI panel for slider
sliderPanel = uipanel(hFig,"Title","Slider","Units","normalized","Position",[0.0 0.0 1 0.1],"BackgroundColor",[1 1 1]);
% Create UI panel for data extracted from received BSM
v2vPanel = uipanel(hFig,"Title","Lead and Front Vehicle Information From Received BSM","Units","normalized","Position",[0.6 0.1 0.4 0.2],"BackgroundColor",[1 1 1]);


% UI table for V2V Data
v2vUITab = uitable(v2vPanel,'Units','Normalized','FontSize',10);
v2vUITab.ColumnName = {'Name', 'Number of Messages Received','Lead Position','Lead Velocity','Front Position','Front Velocity'};
v2vUITab.ColumnWidth = {95 120 130 90 130 90};
v2vUITab.Position = [0 0 1 1];

% Axes for the camera images
hVideoAxes = axes('Position',[0.05 0 1 1],'Parent',cameraPanel);
% Axes for the spacing plot
hSpacingAxes = axes(spacingPanel);  
% Axes for the spacing plot
hVelocityAxes = axes(velocityPanel);  

% Camera images
cameraImg = out.CameraOutput;
numFrames = size(cameraImg,4);
% Handle for video display
videoDisplayHandle = imshow([], 'Parent', hVideoAxes);

% Create a UI Slider for control
hSlider = uicontrol('Parent',sliderPanel,'Style','slider','Units','normalized','Position',[0.05,0.05,0.9,0.8],...
    'value',1, 'min',1, 'max',numFrames,'SliderStep',[1/numFrames 1/numFrames]);

% Get the time data
t = out.logsout.get('Spacing Between Leader and Follower 1').Values.Time;
sz = size(t);

% Get spacing data
spacing.LeaderToFollower1    = reshape(out.logsout.get("Spacing Between Leader and Follower 1").Values.Data,sz);
spacing.Follower1ToFollower2 = reshape(out.logsout.get("Spacing Between Follower 1 and Follower 2").Values.Data,sz);
spacing.ExpecetedSpacing     = reshape(out.logsout.get("Expected Spacing").Values.Data,sz);

% Get velocity data
velocity.Leader    =  reshape(out.logsout.get("Leader").Values.Data,sz);
velocity.Follower1 =  reshape(out.logsout.get("Follower 1").Values.Data,sz);
velocity.Follower2 =  reshape(out.logsout.get("Follower 2").Values.Data,sz);

% Lead and front vehicle information for follower 1 from received BSM
FollowersLeadAndFrontInfo(1).Name = "Follower 1";
fsz = size(out.logsout.get("Follower1LeadAndFrontInfo").Values.NumOfReceivedBSM.Time,1);
FollowersLeadAndFrontInfo(1).NumOfReceivedBSM = reshape(out.logsout.get("Follower1LeadAndFrontInfo").Values.NumOfReceivedBSM.Data,[fsz 1]);
FollowersLeadAndFrontInfo(1).LeadPosition = reshape(out.logsout.get("Follower1LeadAndFrontInfo").Values.LeadPosition.Data,[3 fsz])';
FollowersLeadAndFrontInfo(1).LeadSpeed = reshape(out.logsout.get("Follower1LeadAndFrontInfo").Values.LeadSpeed.Data,[fsz 1]);
FollowersLeadAndFrontInfo(1).FrontPosition = reshape(out.logsout.get("Follower1LeadAndFrontInfo").Values.FrontPosition.Data,[3 fsz])';
FollowersLeadAndFrontInfo(1).FrontSpeed = reshape(out.logsout.get("Follower1LeadAndFrontInfo").Values.FrontSpeed.Data,[fsz 1]);

% Lead and front vehicle information for follower 2 from received BSM
FollowersLeadAndFrontInfo(2).Name = "Follower 2";
fsz = size(out.logsout.get("Follower2LeadAndFrontInfo").Values.NumOfReceivedBSM.Time,1);
FollowersLeadAndFrontInfo(2).NumOfReceivedBSM = reshape(out.logsout.get("Follower2LeadAndFrontInfo").Values.NumOfReceivedBSM.Data,[fsz 1]);
FollowersLeadAndFrontInfo(2).LeadPosition = reshape(out.logsout.get("Follower2LeadAndFrontInfo").Values.LeadPosition.Data,[3 fsz])';
FollowersLeadAndFrontInfo(2).LeadSpeed = reshape(out.logsout.get("Follower2LeadAndFrontInfo").Values.LeadSpeed.Data,[fsz 1]);
FollowersLeadAndFrontInfo(2).FrontPosition = reshape(out.logsout.get("Follower2LeadAndFrontInfo").Values.FrontPosition.Data,[3 fsz])';
FollowersLeadAndFrontInfo(2).FrontSpeed = reshape(out.logsout.get("Follower2LeadAndFrontInfo").Values.FrontSpeed.Data,[fsz 1]);

% Initialize the table to display V2V related data
numOfFollower = 2;

% Initialize spacing plot
leadToFollower1Plot      = plot(hSpacingAxes,0,0,"Color","green","LineStyle","-");
hold(hSpacingAxes,'on');
follower1ToFollower2Plot = plot(hSpacingAxes,0,0,"Color","magenta","LineStyle","-");
expectedSpacingPlot      = plot(hSpacingAxes,0,0,"Color","red","LineStyle","-.");
set(leadToFollower1Plot,'XData',[],'YData',[]);
set(follower1ToFollower2Plot,'XData',[],'YData',[]);
set(expectedSpacingPlot,'XData',[],'YData',[]);
grid(hSpacingAxes,"on")
legend(hSpacingAxes,"Between Leader and Follower 1","Between Follower 1 and Follower 2","Expected Spacing","Location","northoutside","Orientation","horizontal")

% Initialize velocity plot
leadVelPlot      = plot(hVelocityAxes,0,0,"Color","green","LineStyle","-");
hold(hVelocityAxes,"on")
follower1VelPlot = plot(hVelocityAxes,0,0,"Color","magenta","LineStyle","-");
follower2VelPlot = plot(hVelocityAxes,0,0,"Color","blue","LineStyle","-");
set(leadVelPlot,'XData',[],'YData',[]);
set(follower1VelPlot,'XData',[],'YData',[]);
set(follower2VelPlot,'XData',[],'YData',[]);
grid(hVelocityAxes,"on")
legend(hVelocityAxes,"Leader","Follower 1","Follower 2","Location","northoutside","Orientation","horizontal")

% Callback for the slider
hSlider.Callback = @(src, event) stepSimulation(hSlider,t,cameraImg,videoDisplayHandle,FollowersLeadAndFrontInfo,numOfFollower,leadToFollower1Plot,follower1ToFollower2Plot,expectedSpacingPlot,leadVelPlot,follower1VelPlot,follower2VelPlot,v2vUITab,spacing,velocity);

% Position the slider at the end
hSlider.Value = numFrames;
stepSimulation(hSlider,t,cameraImg,videoDisplayHandle,FollowersLeadAndFrontInfo,numOfFollower,leadToFollower1Plot,follower1ToFollower2Plot,expectedSpacingPlot,leadVelPlot,follower1VelPlot,follower2VelPlot,v2vUITab,spacing,velocity)
end

% Slider callback function
function stepSimulation(hSlider,t,cameraImg,videoDisplayHandle,FollowersLeadAndFrontInfo,numOfFollower,leadToFollower1Plot,follower1ToFollower2Plot,expectedSpacingPlot,leadVelPlot,follower1VelPlot,follower2VelPlot,v2vUITab,spacing,velocity)
    
    % Get slider position
    sliderValue = round(hSlider.Value);
    
    % Read the frame
    frame = cameraImg(:,:,:,sliderValue);
    set(videoDisplayHandle,'CData',frame);

    % Plot spacing 
    set(leadToFollower1Plot,'XData',t(1:sliderValue),'YData',spacing.LeaderToFollower1(1:sliderValue));
    set(follower1ToFollower2Plot,'XData',t(1:sliderValue),'YData',spacing.Follower1ToFollower2(1:sliderValue));
    set(expectedSpacingPlot,'XData',t(1:sliderValue),'YData',spacing.ExpecetedSpacing(1:sliderValue));

    % Plot Velocity
    set(leadVelPlot,'XData',t(1:sliderValue),'YData',velocity.Leader(1:sliderValue));
    set(follower1VelPlot,'XData',t(1:sliderValue),'YData',velocity.Follower1(1:sliderValue));
    set(follower2VelPlot,'XData',t(1:sliderValue),'YData',velocity.Follower2(1:sliderValue));
    
    tabV2V = cell(numOfFollower,6);
    % Display the table.
    for j = 1:numOfFollower
        tabV2V{j,1} = sprintf('    %s',FollowersLeadAndFrontInfo(j).Name);
        tabV2V{j,2} = sprintf('             %d',FollowersLeadAndFrontInfo(j).NumOfReceivedBSM(sliderValue*10-9));
        tabV2V{j,3} = sprintf(' [%.2f, %.2f, %.2f]',FollowersLeadAndFrontInfo(j).LeadPosition(sliderValue*10-9,:));
        tabV2V{j,4} = sprintf('        %.2f',FollowersLeadAndFrontInfo(j).LeadSpeed(sliderValue*10-9));
        tabV2V{j,5} = sprintf(' [%.2f, %.2f, %.2f]',FollowersLeadAndFrontInfo(j).FrontPosition(sliderValue*10-9,:));
        tabV2V{j,6} = sprintf('        %.2f',FollowersLeadAndFrontInfo(j).FrontSpeed(sliderValue*10-9));
    end
    v2vUITab.Data = tabV2V;
    drawnow;
end