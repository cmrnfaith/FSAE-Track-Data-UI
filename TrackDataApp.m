classdef TrackDataAppTest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        PlotMenu                 matlab.ui.container.Menu
        PlotAllLapsMenu          matlab.ui.container.Menu
        FreezePlotsMenu          matlab.ui.container.Menu
        UnfreezePlotsMenu        matlab.ui.container.Menu
        SelectedDataMenu         matlab.ui.container.Menu
        PlotSelectedDataMenu     matlab.ui.container.Menu
        PlotFullLapMenu          matlab.ui.container.Menu
        GeneralDataMenu          matlab.ui.container.Menu
        PlotGeneralDataMenu      matlab.ui.container.Menu
        DontPlotGeneralDataMenu  matlab.ui.container.Menu
        TrackDataMenu            matlab.ui.container.Menu
        PlotTackDataMenu         matlab.ui.container.Menu
        DontPlotTrackDataMenu    matlab.ui.container.Menu
        TabGroup                 matlab.ui.container.TabGroup
        LapInfoTab               matlab.ui.container.Tab
        UITable                  matlab.ui.control.Table
        ACCELTab                 matlab.ui.container.Tab
        UIAxes6                  matlab.ui.control.UIAxes
        UIAxes7                  matlab.ui.control.UIAxes
        UIAxes8                  matlab.ui.control.UIAxes
        GPSTab                   matlab.ui.container.Tab
        UIAxes2                  matlab.ui.control.UIAxes
        UIAxes3                  matlab.ui.control.UIAxes
        ROLLTab                  matlab.ui.container.Tab
        UIAxes9                  matlab.ui.control.UIAxes
        UIAxes10                 matlab.ui.control.UIAxes
        UIAxes11                 matlab.ui.control.UIAxes
        FrontPOTSTab             matlab.ui.container.Tab
        UIAxes12                 matlab.ui.control.UIAxes
        UIAxes13                 matlab.ui.control.UIAxes
        RearPOTSTab              matlab.ui.container.Tab
        UIAxes14                 matlab.ui.control.UIAxes
        UIAxes15                 matlab.ui.control.UIAxes
        BRAKESTab                matlab.ui.container.Tab
        UIAxes4                  matlab.ui.control.UIAxes
        UIAxes5                  matlab.ui.control.UIAxes
        General2                 matlab.ui.container.Tab
        UIAxes16                 matlab.ui.control.UIAxes
        UIAxes17                 matlab.ui.control.UIAxes
        FDamperSpeedTab          matlab.ui.container.Tab
        UIAxes18                 matlab.ui.control.UIAxes
        UIAxes19                 matlab.ui.control.UIAxes
        MeanLabel1hello          matlab.ui.control.Label
        MeanLabel2               matlab.ui.control.Label
        RDamperSpeedTab          matlab.ui.container.Tab
        UIAxes20                 matlab.ui.control.UIAxes
        UIAxes21                 matlab.ui.control.UIAxes
        MeanLabel3               matlab.ui.control.Label
        MeanLabel4               matlab.ui.control.Label
        FrontCamberTab           matlab.ui.container.Tab
        UIAxes70                 matlab.ui.control.UIAxes
        UIAxes71                 matlab.ui.control.UIAxes
        RearCamberTab            matlab.ui.container.Tab
        UIAxes72                 matlab.ui.control.UIAxes
        UIAxes73                 matlab.ui.control.UIAxes
        UIAxes                   matlab.ui.control.UIAxes
        LapDropDownLabel         matlab.ui.control.Label
        LapDropDown              matlab.ui.control.DropDown
        ImportDataButton         matlab.ui.control.Button
        SelectDataButton         matlab.ui.control.Button
    end

    
    properties (Access = public)
        %Variables to be imported for plotted need to go here... Filtered
        %variables are used to accomodate for the different sampling
        %frequencies.
        
        UIAxes69
        
        PlotTestGraphsSelect
        PlotSelectedDataSelect
        PlotTrackDataSelect
        
        %Filtered
        
        %GENERAL
        Lat_filtered
        Long_filtered
        Selected_Lat
        Selected_Long
        Speed_filtered
        Time_filtered
        RPM_filtered
        Steering_Angle_filtered
        Altitude_filtered
        
        %POTENTIOMETERS
        FL_Damper_filtered
        FR_Damper_filtered
        RL_Damper_filtered
        RR_Damper_filtered
        
        %BRAKES
        R_Brake_filtered
        F_Brake_filtered
        
        %ROLL
        Yaw_filtered
        Pitch_filtered
        Roll_filtered
        
        %ACCELERATION
        Accel_X_filtered
        Accel_Y_filtered
        Accel_Z_filtered
        LapNumber
        Lap_Index
        
    end
    
    methods (Access = public)
        
        
        function results = Startup(app)
            
            %   This function imports the data and then plots about 11k points
            %   on the graph so the data can be seen.
            
            %   Need to be filtered frist through the other script file
            data = uiimport('-file');   %   Need to be imported on the default settings
            app.PlotTestGraphsSelect = true;
            app.PlotTrackDataSelect = true;
            app.PlotSelectedDataSelect = false;
            
            %   LapNumber is found by counting the number of columns per
            %   variable.
            app.LapNumber = length(data.textdata)./length(rmmissing(data.textdata));
            app.LapNumber = ceil(app.LapNumber);
            
            %   Here we set the max/min values of the dropdown selector
            %   used to select the lap viewed
            app.LapDropDown.Items = cellstr(num2str((1:1:app.LapNumber)'));
            app.LapDropDown.ItemsData = cellstr(num2str((1:1:app.LapNumber)'));
            
            %   Here the data is imported in vectors. The columns represent
            %   the per lap data.
            %General
            app.Lat_filtered       = (data.data(:,1:app.LapNumber));
            app.Long_filtered      = (data.data(:,app.LapNumber + 1:2*app.LapNumber));
            app.Speed_filtered     = (data.data(:,app.LapNumber*2 + 1:3*app.LapNumber));
            app.Time_filtered      = (data.data(:,app.LapNumber*3 + 1:4*app.LapNumber));
            app.RPM_filtered       = (data.data(:,app.LapNumber*4 + 1:5*app.LapNumber));
            app.Steering_Angle_filtered = (data.data(:,app.LapNumber*5 + 1:6*app.LapNumber));
            app.Altitude_filtered  = (data.data(:,app.LapNumber*6 + 1:7*app.LapNumber));
            
            %POTENTIOMETERS
            app.FL_Damper_filtered = (data.data(:,app.LapNumber*7 + 1:8*app.LapNumber));
            app.FR_Damper_filtered = (data.data(:,app.LapNumber*8 + 1:9*app.LapNumber));
            app.RL_Damper_filtered = (data.data(:,app.LapNumber*9 + 1:10*app.LapNumber));
            app.RR_Damper_filtered = (data.data(:,app.LapNumber*10 + 1:11*app.LapNumber));
            
            %BRAKES
            app.R_Brake_filtered   = (data.data(:,app.LapNumber*11 + 1:12*app.LapNumber));
            app.F_Brake_filtered   = (data.data(:,app.LapNumber*12 + 1:13*app.LapNumber));
            
            %ROLL
            app.Yaw_filtered       = (data.data(:,app.LapNumber*13 + 1:14*app.LapNumber));
            app.Pitch_filtered     = (data.data(:,app.LapNumber*14 + 1:15*app.LapNumber));
            app.Roll_filtered      = (data.data(:,app.LapNumber*15 + 1:16*app.LapNumber));
            
            %ACCELERATION
            app.Accel_X_filtered   = (data.data(:,app.LapNumber*16 + 1:17*app.LapNumber));
            app.Accel_Y_filtered   = (data.data(:,app.LapNumber*17 + 1:18*app.LapNumber));
            app.Accel_Z_filtered   = (data.data(:,app.LapNumber*18 + 1:19*app.LapNumber));
            app.Lap_Index          = (data.data(:,app.LapNumber*19 + 1));
            
            %   Lap index represents the final index in each respective lap
            app.Lap_Index = rmmissing(app.Lap_Index);
            for i = 1:app.LapNumber
                for j = 1:app.Lap_Index(i)
                    if (app.Lat_filtered(app.Lap_Index(i)+1-j,i)~=0)
                        app.Lap_Index(i) = app.Lap_Index(i)+1-j;
                        break;
                    end
                end
            end
            
            %   Here we set default values for the selection area of the
            %   graph and the lap drop down tool. This isn't necessary but is merely just a
            %   precaution.
            app.Selected_Lat(1)  =  40.84479;
            app.Selected_Lat(2)  =  40.84487;
            app.Selected_Long(1) = -96.76793;
            app.Selected_Long(2) = -96.76790;
            app.LapDropDown.Value = "2";
            
            %   To start we plot lap 2 with a scale on lateral G's
            %   scatter(app.UIAxes,(app.Lat_filtered(1:app.Lap_Index(2),2)),(app.Long_filtered(1:app.Lap_Index(2),2)),20,abs(app.Accel_Y_filtered(1:app.Lap_Index(2),2)));
            colorbar(app.UIAxes,"north");
            DecideWhatToPlot(app,2)
            
            %   Here we plot the generic data on the tabs.
            %   PlotTestGraphsTab(app,2);
        end
    end
    
    
    methods (Access = public)
        
        function results = PlotTestGraphsTab(app,lap)
            %   Function plots on required tabs and also call other
            %   functions to plot their respective graphs
            
            %   GPS Tab
            scatter(app.UIAxes2,1:1:length((app.Speed_filtered(1:app.Lap_Index(lap),lap))),(app.Speed_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes3,1:1:length((app.Altitude_filtered(1:app.Lap_Index(lap),lap))),(app.Altitude_filtered(1:app.Lap_Index(lap),lap)));
            %   Brakes Tab
            scatter(app.UIAxes4,1:1:length((app.R_Brake_filtered(1:app.Lap_Index(lap),lap))),(app.R_Brake_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes5,1:1:length((app.F_Brake_filtered(1:app.Lap_Index(lap),lap))),(app.F_Brake_filtered(1:app.Lap_Index(lap),lap)));
            %   Accel Tab
            scatter(app.UIAxes6,1:1:length((app.Accel_X_filtered(1:app.Lap_Index(lap),lap))),(app.Accel_X_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes7,1:1:length((app.Accel_Y_filtered(1:app.Lap_Index(lap),lap))),(app.Accel_Y_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes8,1:1:length((app.Accel_Z_filtered(1:app.Lap_Index(lap),lap))),(app.Accel_Z_filtered(1:app.Lap_Index(lap),lap)));
            %   Front POTS
            scatter(app.UIAxes12,1:1:length((app.FL_Damper_filtered(1:app.Lap_Index(lap),lap))),(app.FL_Damper_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes13,1:1:length((app.FR_Damper_filtered(1:app.Lap_Index(lap),lap))),(app.FR_Damper_filtered(1:app.Lap_Index(lap),lap)));
            
            %   Rear POTS
            scatter(app.UIAxes14,1:1:length((app.RL_Damper_filtered(1:app.Lap_Index(lap),lap))),(app.RL_Damper_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes15,1:1:length((app.RR_Damper_filtered(1:app.Lap_Index(lap),lap))),(app.RR_Damper_filtered(1:app.Lap_Index(lap),lap)));
            
            %   ROLL
            scatter(app.UIAxes9, 1:1:length((app.Roll_filtered(1:app.Lap_Index(lap),lap))),(app.Roll_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes10,1:1:length((app.Yaw_filtered(1:app.Lap_Index(lap),lap))),(app.Yaw_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes11,1:1:length((app.Pitch_filtered(1:app.Lap_Index(lap),lap))),(app.Pitch_filtered(1:app.Lap_Index(lap),lap)));
            
            %   General2 - Steering angle / RPM
            scatter(app.UIAxes16,1:1:length((app.Steering_Angle_filtered(1:app.Lap_Index(lap),lap))),(app.Steering_Angle_filtered(1:app.Lap_Index(lap),lap)));
            scatter(app.UIAxes17,1:1:length((app.RPM_filtered(1:app.Lap_Index(lap),lap))),(app.RPM_filtered(1:app.Lap_Index(lap),lap)));
            
            %Damper Speed Tabs
            GenerateDamperSpeedData(app,lap, 1:1:length((app.FL_Damper_filtered(1:app.Lap_Index(lap),lap))));
            %Damper MAX/Min Tabs
            MaxMinCounter(app,lap, 1:1:length((app.FL_Damper_filtered(1:app.Lap_Index(lap),lap))), 1);
            DynamicCamber(app,lap, 1:1:length((app.FL_Damper_filtered(1:app.Lap_Index(lap),lap))), 1);
            
            
            LapBasicInfoCalcs(app, lap, 1:1:length((app.FL_Damper_filtered(1:app.Lap_Index(lap),lap))))
        end
        
    end
    
    methods (Access = public)
        
        function results = PlotSelectedData(app,lap,index)
            %   Same as plot data, but plots only a certain area of the
            %   graph
            
            %   GPS Tab
            scatter(app.UIAxes2,1:1:length((app.Speed_filtered(index,lap))),(app.Speed_filtered(index,lap)));
            scatter(app.UIAxes3,1:1:length((app.Altitude_filtered(index,lap))),(app.Altitude_filtered(index,lap)));
            %   Brakes Tab
            scatter(app.UIAxes4,1:1:length((app.R_Brake_filtered(index,lap))),(app.R_Brake_filtered(index,lap)));
            scatter(app.UIAxes5,1:1:length((app.F_Brake_filtered(index,lap))),(app.F_Brake_filtered(index,lap)));
            %   Accel Tab
            scatter(app.UIAxes6,1:1:length((app.Accel_X_filtered(index,lap))),(app.Accel_X_filtered(index,lap)));
            scatter(app.UIAxes7,1:1:length((app.Accel_Y_filtered(index,lap))),(app.Accel_Y_filtered(index,lap)));
            scatter(app.UIAxes8,1:1:length((app.Accel_Z_filtered(index,lap))),(app.Accel_Z_filtered(index,lap)));
            %   Front POTS
            scatter(app.UIAxes12,1:1:length((app.FL_Damper_filtered(index,lap))),(app.FL_Damper_filtered(index,lap)));
            scatter(app.UIAxes13,1:1:length((app.FR_Damper_filtered(index,lap))),(app.FR_Damper_filtered(index,lap)));
            
            %   Rear POTS
            scatter(app.UIAxes14,1:1:length((app.RL_Damper_filtered(index,lap))),(app.RL_Damper_filtered(index,lap)));
            scatter(app.UIAxes15,1:1:length((app.RR_Damper_filtered(index,lap))),(app.RR_Damper_filtered(index,lap)));
            
            %   ROLL
            scatter(app.UIAxes9, 1:1:length((app.Roll_filtered(index,lap))),(app.Roll_filtered(index,lap)));
            scatter(app.UIAxes10,1:1:length((app.Yaw_filtered(index,lap))),(app.Yaw_filtered(index,lap)));
            scatter(app.UIAxes11,1:1:length((app.Pitch_filtered(index,lap))),(app.Pitch_filtered(index,lap)));
            
            %   General2 - Steering angle / RPM
            scatter(app.UIAxes16,1:1:length((app.Steering_Angle_filtered(index,lap))),(app.Steering_Angle_filtered(index,lap)));
            scatter(app.UIAxes17,1:1:length((app.RPM_filtered(index,lap))),(app.RPM_filtered(index,lap)));
            
            %Damper Speed Tabs
            GenerateDamperSpeedData(app,lap, index);
            MaxMinCounter(app,lap, index, 1);
            DynamicCamber(app,lap, index, 0.0000000001);
            LapBasicInfoCalcs(app, lap, index);
        end
    end
    
    
    
    methods (Access = private)
        
        function results = GenerateDamperSpeedData(app, lap, index) %#ok<*STOUT>
            if (index == 1)
                k = 1;
                for i =1:1:app.LapNumber
                    for j = 1:1:app.Lap_Index(i)
                        frontLeft(k) = app.FL_Damper_filtered(j,i);
                        frontRight(k) = app.FR_Damper_filtered(j,i);
                        rearLeft(k) = app.RL_Damper_filtered(j,i);
                        rearRight(k) = app.RR_Damper_filtered(j,i);
                        k=k+1;
                    end
                end
            else
                frontLeft = app.FL_Damper_filtered(index,lap);
                frontRight = app.FR_Damper_filtered(index,lap);
                rearLeft = app.RL_Damper_filtered(index,lap);
                rearRight = app.RR_Damper_filtered(index,lap);
            end
            sz = length(frontLeft);
            %precreate the arrays for shockspeed to optimize runtime
            shockspeedfl = zeros(sz,1);
            shockspeedfr = zeros(sz,1);
            shockspeedrr = zeros(sz,1);
            shockspeedrl = zeros(sz,1);
            
            dt = 10E-3; %this is time step of sample
            for i=1:(length(frontLeft)-1) %cycle through length of poteniometer array
                %take deriviative (approx is used here) for pot array to calculate shock
                %speed
                shockspeedfl(i) = (frontLeft(i+1)-frontLeft(i))/dt;
                shockspeedfr(i) = (frontRight(i+1)-frontRight(i))/dt;
                shockspeedrr(i) = (rearLeft(i+1)-rearLeft(i))/dt;
                shockspeedrl(i) = (rearRight(i+1)-rearRight(i))/dt;
            end
            
            
            %Calculates mean and SD for plotting the pdf
            flmu = mean(shockspeedfl);
            frmu = mean(shockspeedfr);
            rrmu = mean(shockspeedrr);
            rlmu = mean(shockspeedrl);
            
            flsd = std(shockspeedfl);
            frsd = std(shockspeedfr);
            rrsd = std(shockspeedrr);
            rlsd = std(shockspeedrl);
            
            
            %----PLOTTING TIME BOYS----
            bl = [-20 20]; %bin limits, for histogram plotting
            %this provides the values used to plot the pdf, based on the sizes of the
            %bins used in the histogram
            x = bl(1):0.1:bl(2);
            nbins = 50; %number of bins in histogram, can adjust to optimize
            
            xlb = 'Shock Speed(no units yet)'; %xlabel for plots
            ylb = 'Probability (%)'; %ylabel for plots
            xlimit = bl;
            
            
            
            
            %start of plotting
            %histogram for FRONT LEFT
            histogram(app.UIAxes18, shockspeedfl, nbins, 'Normalization', 'probability', 'BinLimits', bl);
            title(app.UIAxes18, 'Shock Speed - Front Left(Normalized Distribution)');
            xlabel(app.UIAxes18, xlb);
            ylabel(app.UIAxes18, ylb);
            xlim(app.UIAxes18, xlimit);
            text = sprintf('%s\n%s',"Mean is: " + flmu,"SD is: " + flsd);
            %label = uilabel('Text',text,'Position',[100 100 100 32]);
            app.MeanLabel1hello.Text = text;
            %label = uilabel(app.UIAxes18,'Text', txt, 'Position', dim);
            %ylim(app.UIAxes18, ylimit);
            hold(app.UIAxes18, 'on');
            %normalized probabiltiy distribution function plot
            f = exp(-(x-flmu).^2./(2*flsd^2))./(flsd*sqrt(2*pi));
            plot(app.UIAxes18, x,f,'LineWidth',1.5);
            
            %histogram for FRONT RIGHT
            histogram(app.UIAxes19, shockspeedfr, nbins, 'Normalization','probability', 'BinLimits', bl);
            title(app.UIAxes19,'Shock Speed - Front Right (Normalized Distribution)');
            xlabel(app.UIAxes19,xlb);
            ylabel(app.UIAxes19,ylb);
            xlim(app.UIAxes19,xlimit);
            text = sprintf('%s\n%s',"Mean is: " + frmu,"SD is: " + frsd);
            app.MeanLabel2.Text = text;
            %ylim(app.UIAxes19,ylimit);
            hold(app.UIAxes19, 'on');
            %normalized probabiltiy distribution function plot
            f = exp(-(x-frmu).^2./(2*frsd^2))./(frsd*sqrt(2*pi));
            plot(app.UIAxes19,x,f,'LineWidth',1.5);
            
            %histogram for REAR LEFT
            histogram(app.UIAxes20, shockspeedrl, nbins, 'Normalization','probability', 'BinLimits', bl);
            title(app.UIAxes20, 'Shock Speed - Rear Left(Normalized Distribution)');
            xlabel(app.UIAxes20,xlb);
            ylabel(app.UIAxes20,ylb);
            xlim(app.UIAxes20,xlimit);
            text = sprintf('%s\n%s',"Mean is: " + rlmu,"SD is: " + rlsd);
            app.MeanLabel3.Text = text;
            %ylim(app.UIAxes20,ylimit);
            hold(app.UIAxes20, 'on');
            %normalized probabiltiy distribution function
            f = exp(-(x-rlmu).^2./(2*rlsd^2))./(rlsd*sqrt(2*pi));
            plot(app.UIAxes20,x,f,'LineWidth',1.5);
            
            %histogram for REAR RIGHT
            histogram(app.UIAxes21,shockspeedrr, nbins, 'Normalization','probability', 'BinLimits', bl);
            title(app.UIAxes21,'Shock Speed - Rear Right(Normalized Distribution)');
            xlabel(app.UIAxes21,xlb);
            ylabel(app.UIAxes21,ylb);
            xlim(app.UIAxes21,xlimit);
            text = sprintf('%s\n%s',"Mean is: " + rrmu,"SD is: " + rrsd);
            app.MeanLabel4.Text = text;
            %ylim(app.UIAxes21,ylimit);
            hold(app.UIAxes21, 'on');
            %normalized probabiltiy distribution function
            f = exp(-(x-rrmu).^2./(2*rrsd^2))./(rrsd*sqrt(2*pi));
            plot(app.UIAxes21,x,f,'LineWidth',1.5);
            
            hold(app.UIAxes18, 'off');
            hold(app.UIAxes19, 'off');
            hold(app.UIAxes20, 'off');
            hold(app.UIAxes21, 'off');
        end
        
        
        function results = MaxMinCounter(app, lap, index,percent)
            if (index == 1)
                k = 1;
                for i =1:1:app.LapNumber
                    for j = 1:1:app.Lap_Index(i)
                        frontLeft(k) = app.FL_Damper_filtered(j,i); %#ok<*AGROW>
                        frontRight(k) = app.FR_Damper_filtered(j,i);
                        rearLeft(k) = app.RL_Damper_filtered(j,i);
                        rearRight(k) = app.RR_Damper_filtered(j,i);
                        k=k+1;
                    end
                end
            else
                frontLeft = app.FL_Damper_filtered(index,lap);
                frontRight = app.FR_Damper_filtered(index,lap);
                rearLeft = app.RL_Damper_filtered(index,lap);
                rearRight = app.RR_Damper_filtered(index,lap);
            end
            
            sz = size(frontLeft);
            
            FLmax = 0;
            FRmax = 0;
            RRmax = 0;
            RLmax = 0;
            
            FLmin = 0;
            FRmin = 0;
            RRmin = 0;
            RLmin = 0;
            
            upper_p = 100-percent;
            lower_p = percent;
            
            %After the if/else at start of GenerateDamperSpeedData add the following:
            FLupper = prctile(frontLeft, upper_p);
            FLlower = prctile(frontLeft, lower_p);
            
            FRupper = prctile(frontRight, upper_p);
            FRlower = prctile(frontRight, lower_p);
            
            RLupper = prctile(rearLeft, upper_p);
            RLlower = prctile(rearLeft, lower_p);
            
            RRupper = prctile(rearRight, upper_p);
            RRlower = prctile(rearRight, lower_p);
            
            for i = 1:sz
                %MAXS MAXS MAXS MAXS MAXS
                if(frontLeft(i) > FLupper)
                    FLmax = FLmax + 1;
                end
                
                if(frontRight(i) > FRupper)
                    FRmax = FRmax + 1;
                end
                
                if(rearRight(i) > RRupper)
                    RRmax = RRmax + 1;
                end
                
                if(rearLeft(i) > RLupper)
                    RLmax = RLmax + 1;
                end
                
                %MIN MIN MIN MIN
                if(frontLeft(i) < FLlower)
                    FLmin = FLmin + 1;
                end
                
                if(frontRight(i) < FRlower)
                    FRmin = FRmin + 1;
                end
                
                if(rearRight(i) < RRlower)
                    RRmin = RRmin + 1;
                end
                
                if(rearLeft(i) < RLlower)
                    RLmin = RLmin + 1;
                end
            end
            
            %need to change the name of labels to get it to print right
            %depending on how we name the labels in Design View
            tableData = app.UITable.Data;
            tableData(5,1) = FLmax;
            tableData(6,1) = FLmin;
            tableData(7,1) = FRmax;
            tableData(8,1) = FRmin;
            tableData(9,1) = RLmax;
            tableData(10,1) = RLmin;
            tableData(11,1) = RRmax;
            tableData(12,1) = RRmin;
            app.UITable.Data = tableData;
         
        end
        
        function results = DynamicCamber(app, lap, index, percent)
            %PARAMETERS NEEDED
            %Ride Height: (mm)
            FLride = app.FL_Damper_filtered(1,1);
            FRride = app.FR_Damper_filtered(1,1);
            RRride = app.RR_Damper_filtered(1,1);
            RLride = app.RL_Damper_filtered(1,1);
            %Vertical Sweep of Wheel:
            %FLwheeltravel
            %FRwheeltravel
            %RRwheeltravel
            %RLwheeltravel
            %Vertical Sweep of Damper --> movement at damper(stroke length)
            FLshockstroke = 50;
            FRshockstroke = 50;
            RRshockstroke = 50;
            RLshockstroke = 50;
            %Motion Ratio (Can compare measure or calculated)
            Fmotionratio = 1;
            
            Rmotionratio = 1;
            %Track: (mm)
            Ftrack = 1250;
            Rtrack = 1200;
            %Wheelbase: (mm)
            wheelbase = 1531.62;
            %Front/Rear Weight Distributiton: xx% / xx%
            Fweight = .5;
            Rweight = .5;
            %Need Equation for Camber Curve (probably just theoretical is fune
            %unless we want to measure and calculate)
            cambergain = -0.0688; %=cambergain/bump
            FLstaticcamber = -0.5;
            FRstaticcamber = -0.5;
            RRstaticcamber = -0.5;
            RLstaticcamber = -0.5;
            
            if (index == 1)
                k = 1;
                for i =1:1:app.LapNumber
                    for j = 1:1:app.Lap_Index(i)
                        frontLeft(k) = app.FL_Damper_filtered(j,i); %#ok<*AGROW>
                        frontRight(k) = app.FR_Damper_filtered(j,i);
                        rearLeft(k) = app.RL_Damper_filtered(j,i);
                        rearRight(k) = app.RR_Damper_filtered(j,i);
                        k=k+1;
                    end
                end
            else
                frontLeft = app.FL_Damper_filtered(index,lap);
                frontRight = app.FR_Damper_filtered(index,lap);
                rearLeft = app.RL_Damper_filtered(index,lap);
                rearRight = app.RR_Damper_filtered(index,lap);
            end
            
            upper_p = 100-percent;
            lower_p = percent;
            
            %After the if/else at start of GenerateDamperSpeedData add the following:
            FLupper = prctile(frontLeft, upper_p);
            FLlower = prctile(frontLeft, lower_p);
            
            FRupper = prctile(frontRight, upper_p);
            FRlower = prctile(frontRight, lower_p);
            
            RLupper = prctile(rearLeft, upper_p);
            RLlower = prctile(rearLeft, lower_p);
            
            RRupper = prctile(rearRight, upper_p);
            RRlower = prctile(rearRight, lower_p);
            
            %CALCULATED VARIABLES
            %Shock position (0-100%), calculate using probabilities and assume
            %linearity
            %FLshock
            %FRshock
            %RRshock
            %RLshock
            %Dynamic Bump at Wheel
            %FLbump
            %FRbump
            %RRbump
            %RLbump
            %Camber change due to bump travel
            %FLcamberchange
            %FRcamberchange
            %RRcamberchange
            %RLcamberchange
            %Roll(at front axel, rear axel, and CG)
            %Froll
            %Rroll
            %Roll
            %Pitch angle (+) when nose up
            %Pitch
            %Vertical motion of chassis(heave), at front, at rear
            %Vertical
            %Fvertical
            %Rvertical
            
            %STEP 1: CALCULATATE SHOCK POSITION IN % (used formula position(%) =
            %(1/(Vmax-Vmin))*(voltage) - (1/(Vmax-Vmin))/Vmin (assumed linear)
            if (index == 1)
                k = 1;
                for i =1:1:app.LapNumber
                    for j = 1:1:app.Lap_Index(i)
                        FLshock(k) = (1/(FLupper-FLlower))*app.FL_Damper_filtered(j,i) - (1/(FLupper-FLlower))/FLlower;
                        FRshock(k) = (1/(FRupper-FRlower))*app.FR_Damper_filtered(j,i) - (1/(FRupper-FRlower))/FRlower;
                        RRshock(k) = (1/(RRupper-RRlower))*app.RR_Damper_filtered(j,i) - (1/(RRupper-RRlower))/RRlower;
                        RLshock(k) = (1/(RLupper-RLlower))*app.RL_Damper_filtered(j,i) - (1/(RLupper-RLlower))/RLlower;
                        k=k+1;
                    end
                end
            else
                FLshock = (1/(FLupper-FLlower))*app.FL_Damper_filtered(index,lap) - (1/(FLupper-FLlower))/FLlower;
                FRshock = (1/(FRupper-FRlower))*app.FR_Damper_filtered(index,lap) - (1/(FRupper-FRlower))/FRlower;
                RRshock = (1/(RRupper-RRlower))*app.RL_Damper_filtered(index,lap) - (1/(RRupper-RRlower))/RRlower;
                RLshock = (1/(RLupper-RLlower))*app.RR_Damper_filtered(index,lap) - (1/(RLupper-RLlower))/RLlower;
            end
            
            %STEP 2: CALCULATE SHOCK POSITION IN (mm)
            for i = 1:length(FLshock)
                FLshockbump(i) = (FLshock(i) - FLride) * FLshockstroke;
                FRshockbump(i) = (FRshock(i) - FRride) * FRshockstroke;
                RRshockbump(i) = (RRshock(i) - RRride) * RRshockstroke;
                RLshockbump(i) = (RLshock(i) - RLride) * RLshockstroke;
            end
            
            %STEP 3: CALCULATE WHEEL POSITION IN (mm)
            for i = 1:length(FLshockbump)
                FLbump(i) = FLshockbump(i)/Fmotionratio;
                FRbump(i) = FRshockbump(i)/Fmotionratio;
                RRbump(i) = RRshockbump(i)/Rmotionratio;
                RLbump(i) = RLshockbump(i)/Rmotionratio;
            end
            
            %STEP 4: CALCULATE VERTICAL MOVEMENTS (mm)
            
            for i = 1:length(FLbump)
                Fvertical(i) = (FLbump(i) + FRbump(i))/2;
                Rvertical(i) = (RLbump(i) + RRbump(i))/2;
            end
            
            for i = 1:length(Fvertical)
                vertical(i) = ((Fvertical(i)*Fweight) + (Rvertical(i)*Rweight))/2; %I used a equation different than one in paper because I think he made typo, check this if we are getting weird numbers
            end
            
            %STEP 5: CALCULATE ROLL ANGLES
            for i = 1:length(FLbump)
                Froll(i) = atand((FRbump(i) - FLbump(i))/Ftrack);
                Rroll(i) = atand((RRbump(i) - RLbump(i))/Rtrack);
            end
            
            for i = 1:length(Froll)
                roll(i) = (Froll(i)*Fweight) + (Rroll(i)*Rweight);
            end
            
            %STEP 6:CALCULATE PITCH ANGLES
            for i = 1:length(Fvertical)
                pitch(i) = atand((Rvertical(i) - Fvertical(i))/wheelbase);
            end
            
            %STEP 7: CALCULATE CHANGE IN CAMBER AT EACH WHEEL
            for i = 1:length(FLbump)
                FLcamberchange(i) = cambergain * FLbump(i);
                FRcamberchange(i) = cambergain * FRbump(i);
                RRcamberchange(i) = cambergain * RRbump(i);
                RLcamberchange(i) = cambergain * RLbump(i);
            end
            
            %STEP 8: CALCULATE TOTAL DYNAMIC CAMBER
            for i = 1:length(FLcamberchange)
                FLcamber(i) = FLcamberchange(i) + FLstaticcamber - roll(i);
                FRcamber(i) = FRcamberchange(i) + FRstaticcamber + roll(i);
                RRcamber(i) = RRcamberchange(i) + RRstaticcamber + roll(i);
                RLcamber(i) = RLcamberchange(i) + RLstaticcamber - roll(i);
            end
            
            scatter(app.UIAxes70, 1:1:length(FLcamber), FLcamber);
            scatter(app.UIAxes71, 1:1:length(FRcamber), FRcamber);
            scatter(app.UIAxes72, 1:1:length(RLcamber), RLcamber);
            scatter(app.UIAxes73, 1:1:length(RRcamber), RRcamber);
        end
        
        function results = DecideWhatToPlot(app,value)
            if(app.PlotSelectedDataSelect)
                j = 1;
                for i = 1:1:length(app.Lat_filtered(:,value))
                    if((app.Lat_filtered(i,value) >= app.Selected_Lat(1)) && (app.Lat_filtered(i,value) <= app.Selected_Lat(2))) && ((app.Long_filtered(i,value) >= app.Selected_Long(1)) && ((app.Long_filtered(i,value) <= app.Selected_Long(2))))
                        index(j) = i;
                        j = j + 1;
                    end
                end
                if(app.PlotTrackDataSelect)
                scatter(app.UIAxes,(app.Lat_filtered(index,value)),(app.Long_filtered(index,value)),20,abs(app.Accel_Y_filtered(index,value)));
                end
                if(app.PlotTestGraphsSelect)
                    PlotSelectedData(app,value,index)
                end
            else
                if(app.PlotTestGraphsSelect)
                    PlotTestGraphsTab(app,value);
                end
                if(app.PlotTrackDataSelect)
                    scatter(app.UIAxes,(app.Lat_filtered(1:app.Lap_Index(value),value)),(app.Long_filtered(1:app.Lap_Index(value),value)),20,abs(app.Accel_Y_filtered(1:app.Lap_Index(value),value)));
                end
            end
            
        end
        
        function results = LapBasicInfoCalcs(app, lap, index)
            tableData = app.UITable.Data;
            if (index == 1)
                tableData(1,1) = max(max(app.Speed_filtered));
                tableData(2,1) = max(max(app.Accel_X_filtered));
                tableData(3,1) = max(max(app.Accel_Y_filtered));
                tableData(4,1) = max(max(app.Accel_Z_filtered));
            else
                tableData(1,1) = max(app.Speed_filtered(index, lap));
                tableData(2,1) = max(app.Accel_X_filtered(index, lap));
                tableData(3,1) = max(app.Accel_Y_filtered(index, lap));
                tableData(4,1) = max(app.Accel_Z_filtered(index, lap));
            end
            
            app.UITable.Data = tableData;
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ImportDataButton
        function ImportDataButtonPushed(app, event)
            %Once the importData button is pressed this function starts.
            Startup(app);
        end

        % Value changed function: LapDropDown
        function LapDropDownValueChanged(app, event)
            value = str2double(app.LapDropDown.Value);
            %   Update the graphs based on the changed
            DecideWhatToPlot(app,value);
        end

        % Button pushed function: SelectDataButton
        function SelectDataButtonPushed(app, event)
            value = str2double(app.LapDropDown.Value);
            
            app.PlotSelectedDataSelect = true;
            
            f = figure;
            
            length(app.Lat_filtered(1:app.Lap_Index(value),value))
            length(app.Long_filtered(1:app.Lap_Index(value),value))
            
            scatter((app.Lat_filtered(1:app.Lap_Index(value),value)), (app.Long_filtered(1:app.Lap_Index(value),value)));
            [app.Selected_Lat,app.Selected_Long]=ginput(2); %1:app.Lap_Index(value),lap
            
            if(app.Selected_Lat(2)<app.Selected_Lat(1))
                temp = app.Selected_Lat(2);
                app.Selected_Lat(2) = app.Selected_Lat(1);
                app.Selected_Lat(1) = temp;
            end
            if(app.Selected_Long(2)<app.Selected_Long(1))
                temp = app.Selected_Long(2);
                app.Selected_Long(2) = app.Selected_Long(1);
                app.Selected_Long(1) = temp;
            end
            
            close(f);
            j = 1;
            for i = 1:1:length(app.Lat_filtered(:,value))
                if((app.Lat_filtered(i,value) >= app.Selected_Lat(1)) && (app.Lat_filtered(i,value) <= app.Selected_Lat(2))) && ((app.Long_filtered(i,value) >= app.Selected_Long(1)) && ((app.Long_filtered(i,value) <= app.Selected_Long(2))))
                    index(j) = i;
                    j = j + 1;
                end
            end
            scatter(app.UIAxes,(app.Lat_filtered(index,value)),(app.Long_filtered(index,value)),20,abs(app.Accel_Y_filtered(index,value)));
            PlotSelectedData(app,value,index)
        end

        % Menu selected function: PlotAllLapsMenu
        function PlotAllLapsMenuSelected(app, event)
            GenerateDamperSpeedData(app,app.LapNumber, 1);
            MaxMinCounter(app,app.LapNumber, 1, 1);
            DynamicCamber(app,app.LapNumber, 1, 1);
            LapBasicInfoCalcs(app, app.LapNumber, 1)
        end

        % Menu selected function: PlotGeneralDataMenu
        function PlotGeneralDataMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotTestGraphsSelect = true;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: DontPlotGeneralDataMenu
        function DontPlotGeneralDataMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotTestGraphsSelect = false;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: PlotSelectedDataMenu
        function PlotSelectedDataMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotSelectedDataSelect = true;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: PlotFullLapMenu
        function PlotFullLapMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotSelectedDataSelect = false;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: FreezePlotsMenu
        function FreezePlotsMenuSelected(app, event)
            app.PlotSelectedDataSelect = false;
            app.PlotTestGraphsSelect = false;
            app.PlotTrackDataSelect = false;
        end

        % Menu selected function: PlotTackDataMenu
        function PlotTackDataMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotTrackDataSelect = true;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: DontPlotTrackDataMenu
        function DontPlotTrackDataMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotTrackDataSelect = false;
            DecideWhatToPlot(app,value);
        end

        % Menu selected function: UnfreezePlotsMenu
        function UnfreezePlotsMenuSelected(app, event)
            value = str2double(app.LapDropDown.Value);
            app.PlotSelectedDataSelect = true;
            app.PlotTestGraphsSelect = true;
            app.PlotTrackDataSelect = true;
            DecideWhatToPlot(app,value);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 796 588];
            app.UIFigure.Name = 'UI Figure';

            % Create PlotMenu
            app.PlotMenu = uimenu(app.UIFigure);
            app.PlotMenu.Text = 'Plot';

            % Create PlotAllLapsMenu
            app.PlotAllLapsMenu = uimenu(app.PlotMenu);
            app.PlotAllLapsMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotAllLapsMenuSelected, true);
            app.PlotAllLapsMenu.Text = 'Plot All Laps';

            % Create FreezePlotsMenu
            app.FreezePlotsMenu = uimenu(app.PlotMenu);
            app.FreezePlotsMenu.MenuSelectedFcn = createCallbackFcn(app, @FreezePlotsMenuSelected, true);
            app.FreezePlotsMenu.Text = 'Freeze Plots';

            % Create UnfreezePlotsMenu
            app.UnfreezePlotsMenu = uimenu(app.FreezePlotsMenu);
            app.UnfreezePlotsMenu.MenuSelectedFcn = createCallbackFcn(app, @UnfreezePlotsMenuSelected, true);
            app.UnfreezePlotsMenu.Text = 'Unfreeze Plots';

            % Create SelectedDataMenu
            app.SelectedDataMenu = uimenu(app.PlotMenu);
            app.SelectedDataMenu.Text = 'Selected Data';

            % Create PlotSelectedDataMenu
            app.PlotSelectedDataMenu = uimenu(app.SelectedDataMenu);
            app.PlotSelectedDataMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotSelectedDataMenuSelected, true);
            app.PlotSelectedDataMenu.Text = 'Plot Selected Data';

            % Create PlotFullLapMenu
            app.PlotFullLapMenu = uimenu(app.SelectedDataMenu);
            app.PlotFullLapMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotFullLapMenuSelected, true);
            app.PlotFullLapMenu.Text = 'Plot Full Lap';

            % Create GeneralDataMenu
            app.GeneralDataMenu = uimenu(app.PlotMenu);
            app.GeneralDataMenu.Text = 'General Data';

            % Create PlotGeneralDataMenu
            app.PlotGeneralDataMenu = uimenu(app.GeneralDataMenu);
            app.PlotGeneralDataMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotGeneralDataMenuSelected, true);
            app.PlotGeneralDataMenu.Text = 'Plot General Data';

            % Create DontPlotGeneralDataMenu
            app.DontPlotGeneralDataMenu = uimenu(app.GeneralDataMenu);
            app.DontPlotGeneralDataMenu.MenuSelectedFcn = createCallbackFcn(app, @DontPlotGeneralDataMenuSelected, true);
            app.DontPlotGeneralDataMenu.Text = 'Don''t Plot General Data';

            % Create TrackDataMenu
            app.TrackDataMenu = uimenu(app.PlotMenu);
            app.TrackDataMenu.Text = 'Track Data';

            % Create PlotTackDataMenu
            app.PlotTackDataMenu = uimenu(app.TrackDataMenu);
            app.PlotTackDataMenu.MenuSelectedFcn = createCallbackFcn(app, @PlotTackDataMenuSelected, true);
            app.PlotTackDataMenu.Text = 'Plot Tack Data';

            % Create DontPlotTrackDataMenu
            app.DontPlotTrackDataMenu = uimenu(app.TrackDataMenu);
            app.DontPlotTrackDataMenu.MenuSelectedFcn = createCallbackFcn(app, @DontPlotTrackDataMenuSelected, true);
            app.DontPlotTrackDataMenu.Text = 'Don''t Plot Track Data';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [377 1 420 588];

            % Create LapInfoTab
            app.LapInfoTab = uitab(app.TabGroup);
            app.LapInfoTab.Title = 'Lap Info';

            % Create UITable
            app.UITable = uitable(app.LapInfoTab);
            app.UITable.ColumnName = {'Value'};
            app.UITable.RowName = {'Top Speed '; 'Top Lat. G''s'; 'Top Long. G''s'; 'Top Vertical G''s'; 'FL Max Count'; 'FL Min Count'; 'FR Max Count'; 'FR Min Count'; 'RL Max Count'; 'RL Min Count'; 'RR Max Count'; 'RR Min Count'; ''};
            app.UITable.ForegroundColor = [0.7176 0.2745 1];
            app.UITable.Position = [46 223 328 312];

            % Create ACCELTab
            app.ACCELTab = uitab(app.TabGroup);
            app.ACCELTab.Title = 'ACCEL';

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.ACCELTab);
            title(app.UIAxes6, 'X Accel')
            xlabel(app.UIAxes6, 'Time')
            ylabel(app.UIAxes6, 'G')
            app.UIAxes6.PlotBoxAspectRatio = [2.8848167539267 1 1];
            app.UIAxes6.Position = [1 379 418 185];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.ACCELTab);
            title(app.UIAxes7, 'Y Accel')
            xlabel(app.UIAxes7, 'Time')
            ylabel(app.UIAxes7, 'G')
            app.UIAxes7.PlotBoxAspectRatio = [2.89528795811518 1 1];
            app.UIAxes7.Position = [1 195 419 185];

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.ACCELTab);
            title(app.UIAxes8, 'Z Accel')
            xlabel(app.UIAxes8, 'Time')
            ylabel(app.UIAxes8, 'G')
            app.UIAxes8.PlotBoxAspectRatio = [2.8848167539267 1 1];
            app.UIAxes8.Position = [1 10 418 185];

            % Create GPSTab
            app.GPSTab = uitab(app.TabGroup);
            app.GPSTab.Title = 'GPS';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GPSTab);
            title(app.UIAxes2, 'Track Speed')
            xlabel(app.UIAxes2, 'Point')
            ylabel(app.UIAxes2, 'Speed')
            app.UIAxes2.PlotBoxAspectRatio = [1.8494983277592 1 1];
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [0 307 419 257];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.GPSTab);
            title(app.UIAxes3, 'Altitude')
            xlabel(app.UIAxes3, 'Time')
            ylabel(app.UIAxes3, 'Altitude')
            app.UIAxes3.PlotBoxAspectRatio = [1.73817034700315 1 1];
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.Position = [1 39 418 269];

            % Create ROLLTab
            app.ROLLTab = uitab(app.TabGroup);
            app.ROLLTab.Title = 'ROLL';

            % Create UIAxes9
            app.UIAxes9 = uiaxes(app.ROLLTab);
            title(app.UIAxes9, 'Roll')
            xlabel(app.UIAxes9, 'Time')
            ylabel(app.UIAxes9, '(Deg/s)')
            app.UIAxes9.PlotBoxAspectRatio = [2.8848167539267 1 1];
            app.UIAxes9.Position = [1 379 418 185];

            % Create UIAxes10
            app.UIAxes10 = uiaxes(app.ROLLTab);
            title(app.UIAxes10, 'Yaw')
            xlabel(app.UIAxes10, 'Time')
            ylabel(app.UIAxes10, '(Deg/s)')
            app.UIAxes10.PlotBoxAspectRatio = [2.8848167539267 1 1];
            app.UIAxes10.Position = [1 195 418 185];

            % Create UIAxes11
            app.UIAxes11 = uiaxes(app.ROLLTab);
            title(app.UIAxes11, 'Pitch')
            xlabel(app.UIAxes11, 'Time')
            ylabel(app.UIAxes11, '(Deg/s)')
            app.UIAxes11.PlotBoxAspectRatio = [2.8848167539267 1 1];
            app.UIAxes11.Position = [1 11 418 185];

            % Create FrontPOTSTab
            app.FrontPOTSTab = uitab(app.TabGroup);
            app.FrontPOTSTab.Title = 'Front POTS';

            % Create UIAxes12
            app.UIAxes12 = uiaxes(app.FrontPOTSTab);
            title(app.UIAxes12, 'FL')
            xlabel(app.UIAxes12, 'Time')
            ylabel(app.UIAxes12, 'Voltage')
            app.UIAxes12.PlotBoxAspectRatio = [1.70061728395062 1 1];
            app.UIAxes12.Position = [1 290 418 274];

            % Create UIAxes13
            app.UIAxes13 = uiaxes(app.FrontPOTSTab);
            title(app.UIAxes13, 'FR')
            xlabel(app.UIAxes13, 'Time')
            ylabel(app.UIAxes13, 'Voltage')
            app.UIAxes13.PlotBoxAspectRatio = [1.90034364261168 1 1];
            app.UIAxes13.Position = [1 39 419 252];

            % Create RearPOTSTab
            app.RearPOTSTab = uitab(app.TabGroup);
            app.RearPOTSTab.Title = 'Rear POTS';

            % Create UIAxes14
            app.UIAxes14 = uiaxes(app.RearPOTSTab);
            title(app.UIAxes14, 'RL')
            xlabel(app.UIAxes14, 'Time')
            ylabel(app.UIAxes14, 'Voltage (Degrees)')
            app.UIAxes14.PlotBoxAspectRatio = [1.81848184818482 1 1];
            app.UIAxes14.Position = [1 304 418 260];

            % Create UIAxes15
            app.UIAxes15 = uiaxes(app.RearPOTSTab);
            title(app.UIAxes15, 'RR')
            xlabel(app.UIAxes15, 'Time')
            ylabel(app.UIAxes15, 'Voltage')
            app.UIAxes15.PlotBoxAspectRatio = [1.76602564102564 1 1];
            app.UIAxes15.Position = [1 39 418 266];

            % Create BRAKESTab
            app.BRAKESTab = uitab(app.TabGroup);
            app.BRAKESTab.Title = 'BRAKES';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.BRAKESTab);
            title(app.UIAxes4, 'Rear Brakes')
            xlabel(app.UIAxes4, 'Time')
            ylabel(app.UIAxes4, 'V')
            app.UIAxes4.PlotBoxAspectRatio = [1.69018404907975 1 1];
            app.UIAxes4.Position = [1 289 418 275];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.BRAKESTab);
            title(app.UIAxes5, 'Front Brakes')
            xlabel(app.UIAxes5, 'Time')
            ylabel(app.UIAxes5, 'V')
            app.UIAxes5.PlotBoxAspectRatio = [1.65465465465465 1 1];
            app.UIAxes5.Position = [2 10 418 280];

            % Create General2
            app.General2 = uitab(app.TabGroup);
            app.General2.Title = 'General2';

            % Create UIAxes16
            app.UIAxes16 = uiaxes(app.General2);
            title(app.UIAxes16, 'Steering Angle')
            xlabel(app.UIAxes16, '')
            ylabel(app.UIAxes16, 'Angle')
            app.UIAxes16.PlotBoxAspectRatio = [1.90689655172414 1 1];
            app.UIAxes16.Position = [1 313 419 251];

            % Create UIAxes17
            app.UIAxes17 = uiaxes(app.General2);
            title(app.UIAxes17, 'RPM')
            xlabel(app.UIAxes17, 'Point')
            ylabel(app.UIAxes17, 'RPM')
            app.UIAxes17.PlotBoxAspectRatio = [1.6301775147929 1 1];
            app.UIAxes17.Position = [1 31 418 283];

            % Create FDamperSpeedTab
            app.FDamperSpeedTab = uitab(app.TabGroup);
            app.FDamperSpeedTab.Title = 'F. Damper Speed';

            % Create UIAxes18
            app.UIAxes18 = uiaxes(app.FDamperSpeedTab);
            title(app.UIAxes18, 'Title')
            xlabel(app.UIAxes18, 'X')
            ylabel(app.UIAxes18, 'Y')
            app.UIAxes18.Position = [1 275 418 289];

            % Create UIAxes19
            app.UIAxes19 = uiaxes(app.FDamperSpeedTab);
            title(app.UIAxes19, 'Title')
            xlabel(app.UIAxes19, 'X')
            ylabel(app.UIAxes19, 'Y')
            app.UIAxes19.Position = [1 2 419 274];

            % Create MeanLabel1hello
            app.MeanLabel1hello = uilabel(app.FDamperSpeedTab);
            app.MeanLabel1hello.Position = [196 423 224 133];
            app.MeanLabel1hello.Text = {'MeanLabel1'; 'hello'};

            % Create MeanLabel2
            app.MeanLabel2 = uilabel(app.FDamperSpeedTab);
            app.MeanLabel2.Position = [196 134 224 122];
            app.MeanLabel2.Text = 'MeanLabel2';

            % Create RDamperSpeedTab
            app.RDamperSpeedTab = uitab(app.TabGroup);
            app.RDamperSpeedTab.Title = 'RDamperSpeedTab';

            % Create UIAxes20
            app.UIAxes20 = uiaxes(app.RDamperSpeedTab);
            title(app.UIAxes20, 'Title')
            xlabel(app.UIAxes20, 'X')
            ylabel(app.UIAxes20, 'Y')
            app.UIAxes20.Position = [1 275 418 289];

            % Create UIAxes21
            app.UIAxes21 = uiaxes(app.RDamperSpeedTab);
            title(app.UIAxes21, 'Title')
            xlabel(app.UIAxes21, 'X')
            ylabel(app.UIAxes21, 'Y')
            app.UIAxes21.Position = [1 2 419 274];

            % Create MeanLabel3
            app.MeanLabel3 = uilabel(app.RDamperSpeedTab);
            app.MeanLabel3.Position = [217 416 202 130];
            app.MeanLabel3.Text = 'MeanLabel3';

            % Create MeanLabel4
            app.MeanLabel4 = uilabel(app.RDamperSpeedTab);
            app.MeanLabel4.Position = [217 144 202 116];
            app.MeanLabel4.Text = 'MeanLabel4';

            % Create FrontCamberTab
            app.FrontCamberTab = uitab(app.TabGroup);
            app.FrontCamberTab.Title = 'Front Camber';

            % Create UIAxes70
            app.UIAxes70 = uiaxes(app.FrontCamberTab);
            title(app.UIAxes70, 'FL')
            xlabel(app.UIAxes70, 'Points')
            ylabel(app.UIAxes70, 'Camber')
            app.UIAxes70.Position = [1 294 419 269];

            % Create UIAxes71
            app.UIAxes71 = uiaxes(app.FrontCamberTab);
            title(app.UIAxes71, 'FR')
            xlabel(app.UIAxes71, 'Points')
            ylabel(app.UIAxes71, 'Camber')
            app.UIAxes71.Position = [1 38 419 257];

            % Create RearCamberTab
            app.RearCamberTab = uitab(app.TabGroup);
            app.RearCamberTab.Title = 'Rear Camber';

            % Create UIAxes72
            app.UIAxes72 = uiaxes(app.RearCamberTab);
            title(app.UIAxes72, 'RL')
            xlabel(app.UIAxes72, '')
            ylabel(app.UIAxes72, 'Camber')
            app.UIAxes72.Position = [1 274 419 289];

            % Create UIAxes73
            app.UIAxes73 = uiaxes(app.RearCamberTab);
            title(app.UIAxes73, 'RR')
            xlabel(app.UIAxes73, '')
            ylabel(app.UIAxes73, 'Camber')
            app.UIAxes73.Position = [1 30 419 245];

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Track')
            xlabel(app.UIAxes, 'Lat')
            ylabel(app.UIAxes, 'Long')
            app.UIAxes.Box = 'on';
            app.UIAxes.Position = [1 39 377 550];

            % Create LapDropDownLabel
            app.LapDropDownLabel = uilabel(app.UIFigure);
            app.LapDropDownLabel.HorizontalAlignment = 'right';
            app.LapDropDownLabel.Position = [269 10 26 22];
            app.LapDropDownLabel.Text = 'Lap';

            % Create LapDropDown
            app.LapDropDown = uidropdown(app.UIFigure);
            app.LapDropDown.Items = {'1'};
            app.LapDropDown.ItemsData = {'1'};
            app.LapDropDown.Editable = 'on';
            app.LapDropDown.ValueChangedFcn = createCallbackFcn(app, @LapDropDownValueChanged, true);
            app.LapDropDown.BackgroundColor = [1 1 1];
            app.LapDropDown.Position = [310 10 60 22];
            app.LapDropDown.Value = '1';

            % Create ImportDataButton
            app.ImportDataButton = uibutton(app.UIFigure, 'push');
            app.ImportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportDataButtonPushed, true);
            app.ImportDataButton.Position = [21 10 100 22];
            app.ImportDataButton.Text = 'Import Data';

            % Create SelectDataButton
            app.SelectDataButton = uibutton(app.UIFigure, 'push');
            app.SelectDataButton.ButtonPushedFcn = createCallbackFcn(app, @SelectDataButtonPushed, true);
            app.SelectDataButton.Position = [140 10 100 22];
            app.SelectDataButton.Text = 'Select Data';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TrackDataAppTest

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end