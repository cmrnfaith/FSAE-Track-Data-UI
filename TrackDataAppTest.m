classdef TrackDataAppTest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        DataMenu              matlab.ui.container.Menu
        SelectStartPointMenu  matlab.ui.container.Menu
        TabGroup              matlab.ui.container.TabGroup
        GPSTab                matlab.ui.container.Tab
        UIAxes2               matlab.ui.control.UIAxes
        UIAxes3               matlab.ui.control.UIAxes
        ACCELTab              matlab.ui.container.Tab
        UIAxes6               matlab.ui.control.UIAxes
        UIAxes7               matlab.ui.control.UIAxes
        UIAxes8               matlab.ui.control.UIAxes
        ROLLTab               matlab.ui.container.Tab
        UIAxes9               matlab.ui.control.UIAxes
        UIAxes10              matlab.ui.control.UIAxes
        UIAxes11              matlab.ui.control.UIAxes
        FrontPOTSTab          matlab.ui.container.Tab
        UIAxes12              matlab.ui.control.UIAxes
        UIAxes13              matlab.ui.control.UIAxes
        RearPOTSTab           matlab.ui.container.Tab
        UIAxes14              matlab.ui.control.UIAxes
        UIAxes15              matlab.ui.control.UIAxes
        BRAKESTab             matlab.ui.container.Tab
        UIAxes4               matlab.ui.control.UIAxes
        UIAxes5               matlab.ui.control.UIAxes
        General2              matlab.ui.container.Tab
        UIAxes16              matlab.ui.control.UIAxes
        UIAxes17              matlab.ui.control.UIAxes
        EngineTab             matlab.ui.container.Tab
        RPMGaugeLabel         matlab.ui.control.Label
        RPMGauge              matlab.ui.control.Gauge
        UIAxes                matlab.ui.control.UIAxes
        LapDropDownLabel      matlab.ui.control.Label
        LapDropDown           matlab.ui.control.DropDown
        ImportDataButton      matlab.ui.control.Button
        SelectDataButton      matlab.ui.control.Button
    end

    
    properties (Access = public)
        %Variables to be imported for plotted need to go here... Filtered
        %variables are used to accomodate for the different sampling
        %frequencies.
        
        %GENERAL
        Lat
        Long
        Speed
        Time
        RPM
        Steering_Angle
        Altitude
        
        %POTENTIOMETERS
        FL_Damper
        FR_Damper
        RL_Damper
        RR_Damper
        
        %BRAKES
        R_Brake
        F_Brake
        
        %ROLL
        Yaw
        Pitch
        Roll
        
        %ACCELERATION
        Accel_X
        Accel_Y
        Accel_Z
        
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
    end
    
    methods (Access = public)
        
        
        function results = Startup(app)
            
            %   This function imports the data and then plots about 11k points
            %   on the graph so the data can be seen. Next in the process is
            %   to select a "start point" for the track in order to separate
            %   the data lap by lap.
            
            data = uiimport('-file');   %   Need to be imported as vectors
            
            %Variables are assigned values based on the convention in the
            %test_log_1 excel headers
            
            %   Importing the data vectors... Removing the NAN's from the
            %   vectors... If there are issues in vector lengths, will need to
            %   cut out initial and final data where sensors aren't running
            
            %General
            app.Lat = fillmissing(data.x_Latitude___Degrees____180_0_180_0_50_','movmean',5);
            app.Long = fillmissing(data.x_Longitude___Degrees____180_0_180_0_50_','movmean',5);
            app.Speed = fillmissing(data.x_Speed___MPH___0_0_150_0_50_','movmean',5);
            app.Time = fillmissing(data.x_Interval___ms___0_0_1_','movmean',5);
            app.RPM = fillmissing(data.x_RPM___RPM___0_12500_50_','movmean',5);
            app.Steering_Angle = fillmissing(data.x_SteeringAng___Volts____105_0_105_0_50_','movmean',5);
            app.Altitude = fillmissing(data.x_Altitude___ft___0_0_4000_0_50_','movmean',5);
            
            %POTENTIOMETERS
            app.FL_Damper = fillmissing(data.x_FrontLeft______0_0_100_0_100_','movmean',5);
            app.FR_Damper = fillmissing(data.x_FrontRight______0_0_100_0_100_','movmean',5);
            app.RL_Damper = fillmissing(data.x_RearLeft______0_0_100_0_100_','movmean',5);
            app.RR_Damper = fillmissing(data.x_RearRight______0_0_100_0_100_','movmean',5);
            
            %BRAKES
            app.R_Brake = fillmissing(data.x_RearBrake___Volts___0_0_5_0_50_','movmean',5);
            app.F_Brake = fillmissing(data.x_FrontBrake___Volts___0_0_5_0_50_','movmean',5);
            
            %ROLL
            app.Yaw = fillmissing(data.x_Yaw___Deg_Sec____120_120_25_','movmean',9);
            app.Pitch = fillmissing(data.x_Pitch___Deg_Sec____120_120_25_','movmean',9);
            app.Roll = fillmissing(data.x_Roll___Deg_Sec____120_120_25_','movmean',9);
            
            %ACCELERATION
            app.Accel_X = fillmissing(data.x_AccelX___G____3_0_3_0_25_','movmean',9);
            app.Accel_Y = fillmissing(data.x_AccelY___G____3_0_3_0_25_','movmean',9);
            app.Accel_Z = fillmissing(data.x_AccelZ___G____3_0_3_0_25_','movmean',9);
            
            %   Filling with zeros for testing. Will either need to cut out data
            %   or find a way to make the vector lengths the same.
            %   app.Speed(numel(app.Long)) = 0;
            
            %   Manual Setpoints for the initial start of the "Laps" will
            %   implement another method for the user to be able to manually
            %   select and adjust these in the future.
            lat1 = 40.84479;
            lat2 = 40.84487;
            long1 = -96.76793;
            long2 = -96.76790;
            
            LapNumber = 1;
            counter = 0;
            index = 1;
            
            %Sampling Frequency => Default is 1
            SamplingFreq = 4;
            
            %Cutoff Points => I.e if you need to get rid of garbage data at
            %start or finish
            SamplingStart = 80; % Needs to be a multiple of freq. I.e if frequency is 4 Start can be 4, 8, 12, etc.
            SamplingFinish = 80;
            
            for i = SamplingStart:(length(app.Yaw) - SamplingFinish)
                
                if (counter == 0) && ((app.Lat(i) <= lat2) && (app.Lat(i) >= lat1)) && ((app.Long(i) <= long2) && (app.Long(i) >= long1))
                    index = 1;
                    counter = 20;
                    i = i + SamplingFreq;
                    LapNumber = LapNumber + 1;
                end
                %Here the filtered data is
                app.Lat_filtered(index,LapNumber)= app.Lat(i);
                app.Long_filtered(index,LapNumber)= app.Long(i);
                app.Speed_filtered(index,LapNumber)= app.Speed(i);
                app.Time_filtered(index,LapNumber)= app.Time(i);
                app.RPM_filtered(index,LapNumber)= app.RPM(i);
                app.Steering_Angle_filtered(index,LapNumber)= app.Steering_Angle(i);
                app.Altitude_filtered(index,LapNumber)= app.Altitude(i);
                
                %POTENTIOMETERS
                app.FL_Damper_filtered(index,LapNumber)= app.FL_Damper(i);
                app.FR_Damper_filtered(index,LapNumber)= app.FR_Damper(i);
                app.RL_Damper_filtered(index,LapNumber)= app.RL_Damper(i);
                app.RR_Damper_filtered(index,LapNumber)= app.RR_Damper(i);
                
                %BRAKES
                app.R_Brake_filtered(index,LapNumber)= app.R_Brake(i);
                app.F_Brake_filtered(index,LapNumber)= app.F_Brake(i);
                
                %ROLL
                app.Yaw_filtered(index,LapNumber)= app.Yaw(i);
                app.Pitch_filtered(index,LapNumber)= app.Pitch(i);
                app.Roll_filtered(index,LapNumber)= app.Roll(i);
                
                %ACCELERATION
                app.Accel_X_filtered(index,LapNumber)= app.Accel_X(i);
                app.Accel_Y_filtered(index,LapNumber)= app.Accel_Y(i);
                app.Accel_Z_filtered(index,LapNumber)= app.Accel_Z(i);
                
                index = index + SamplingFreq;
                
                if counter ~= 0   %To make sure counter doesn't go below zero... counter should be a multiple of freq
                    counter = counter - 1;
                end
                
                
            end
            
            LapNumber %#ok<NOPRT>
            
            
            
            colormap(app.UIAxes,hsv);
            scatter(app.UIAxes,app.Lat(10000:21000),app.Long(10000:21000),20,app.Speed(10000:21000));
            colorbar(app.UIAxes);
            
            PlotTestGraphsTab(app,str2num(app.LapDropDown.Value));
        end
    end
    
    methods (Access = public)
        
        %         function trackStartArea = SelectStartPoint(app,plot1)
        %             trackStartArea = drawcuboid(plot1);
        %             disp('This will print immediately');
        %             uiwait(gcf);
        %             disp('This will print after you click Continue');
        %             return;
        %         end
    end
    
    methods (Access = public)
        
        function results = PlotTestGraphsTab(app,lap)
            %   GPS Tab
            scatter(app.UIAxes2,[1:1:length((app.Speed_filtered(:,lap)))],(app.Speed_filtered(:,lap)));
            scatter(app.UIAxes3,[1:1:length((app.Altitude_filtered(:,lap)))],(app.Altitude_filtered(:,lap)));
            %   Brakes Tab
            scatter(app.UIAxes4,[1:1:length((app.R_Brake_filtered(:,lap)))],(app.R_Brake_filtered(:,lap)));
            scatter(app.UIAxes5,[1:1:length((app.F_Brake_filtered(:,lap)))],(app.F_Brake_filtered(:,lap)));
            %   Accel Tab
            scatter(app.UIAxes6,[1:1:length((app.Accel_X_filtered(:,lap)))],(app.Accel_X_filtered(:,lap)));
            scatter(app.UIAxes7,[1:1:length((app.Accel_Y_filtered(:,lap)))],(app.Accel_Y_filtered(:,lap)));
            scatter(app.UIAxes8,[1:1:length((app.Accel_Z_filtered(:,lap)))],(app.Accel_Z_filtered(:,lap)));
            %   Front POTS
            scatter(app.UIAxes12,[1:1:length((app.FL_Damper_filtered(:,lap)))],(app.FL_Damper_filtered(:,lap)));
            scatter(app.UIAxes13,[1:1:length((app.FR_Damper_filtered(:,lap)))],(app.FR_Damper_filtered(:,lap)));
            
            %   Rear POTS
            scatter(app.UIAxes14,[1:1:length((app.RL_Damper_filtered(:,lap)))],(app.RL_Damper_filtered(:,lap)));
            scatter(app.UIAxes15,[1:1:length((app.RR_Damper_filtered(:,lap)))],(app.RR_Damper_filtered(:,lap)));
            
            %   ROLL
            scatter(app.UIAxes9, [1:1:length(app.Roll_filtered(:,lap))],app.Roll_filtered(:,lap));
            scatter(app.UIAxes10,[1:1:length(app.Yaw_filtered(:,lap))],app.Yaw_filtered(:,lap));
            scatter(app.UIAxes11,[1:1:length(app.Pitch_filtered(:,lap))],app.Pitch_filtered(:,lap));
            
            %   General2 - Steering angle / RPM
            scatter(app.UIAxes16,[1:1:length((app.Steering_Angle_filtered(:,lap)))],(app.Steering_Angle_filtered(:,lap)));
            scatter(app.UIAxes17,[1:1:length((app.RPM_filtered(:,lap)))],(app.RPM_filtered(:,lap)));

            
        end
        
    end
    
    methods (Access = public)
        
        function results = PlotSelectedData(app,lap,index)
            %   GPS Tab
            scatter(app.UIAxes2,[1:1:length((app.Speed_filtered(index,lap)))],(app.Speed_filtered(index,lap)));
            scatter(app.UIAxes3,[1:1:length((app.Altitude_filtered(index,lap)))],(app.Altitude_filtered(index,lap)));
            %   Brakes Tab
            scatter(app.UIAxes4,[1:1:length((app.R_Brake_filtered(index,lap)))],(app.R_Brake_filtered(index,lap)));
            scatter(app.UIAxes5,[1:1:length((app.F_Brake_filtered(index,lap)))],(app.F_Brake_filtered(index,lap)));
            %   Accel Tab
            scatter(app.UIAxes6,[1:1:length((app.Accel_X_filtered(index,lap)))],(app.Accel_X_filtered(index,lap)));
            scatter(app.UIAxes7,[1:1:length((app.Accel_Y_filtered(index,lap)))],(app.Accel_Y_filtered(index,lap)));
            scatter(app.UIAxes8,[1:1:length((app.Accel_Z_filtered(index,lap)))],(app.Accel_Z_filtered(index,lap)));
            %   Front POTS
            scatter(app.UIAxes12,[1:1:length((app.FL_Damper_filtered(index,lap)))],(app.FL_Damper_filtered(index,lap)));
            scatter(app.UIAxes13,[1:1:length((app.FR_Damper_filtered(index,lap)))],(app.FR_Damper_filtered(index,lap)));
            
            %   Rear POTS
            scatter(app.UIAxes14,[1:1:length((app.RL_Damper_filtered(index,lap)))],(app.RL_Damper_filtered(index,lap)));
            scatter(app.UIAxes15,[1:1:length((app.RR_Damper_filtered(index,lap)))],(app.RR_Damper_filtered(index,lap)));
            
            %   ROLL
            scatter(app.UIAxes9, [1:1:length(app.Roll_filtered(index,lap))],app.Roll_filtered(index,lap));
            scatter(app.UIAxes10,[1:1:length(app.Yaw_filtered(index,lap))],app.Yaw_filtered(index,lap));
            scatter(app.UIAxes11,[1:1:length(app.Pitch_filtered(index,lap))],app.Pitch_filtered(index,lap));
            
            %   General2 - Steering angle / RPM
            scatter(app.UIAxes16,[1:1:length((app.Steering_Angle_filtered(index,lap)))],(app.Steering_Angle_filtered(index,lap)));
            scatter(app.UIAxes17,[1:1:length((app.RPM_filtered(index,lap)))],(app.RPM_filtered(index,lap)));
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Size changed function: GPSTab
        function GPSTabSizeChanged(app, event)
            position = app.GPSTab.Position;
            
        end

        % Button pushed function: ImportDataButton
        function ImportDataButtonPushed(app, event)
            %Once the importData button is pressed this function starts.
            Startup(app);
        end

        % Menu selected function: SelectStartPointMenu
        function SelectStartPointMenuSelected(app, event)
            %When Data -> Startpoint is selected this function is started.
%             startPointFigure = figure;
%             data = uiimport('-file');
%             Lat = rmmissing(data.x_Latitude___Degrees____180_0_180_0_50_');
%             Long = rmmissing(data.x_Longitude___Degrees____180_0_180_0_50_');
%             Speed = rmmissing(data.x_Speed___MPH___0_0_150_0_50_');
%             scatter(Lat(10000:21000),Long(10000:21000),20,Speed(10000:21000))
%             colormap(hsv);
            
        end

        % Value changed function: LapDropDown
        function LapDropDownValueChanged(app, event)
            value = str2num(app.LapDropDown.Value);
            scatter(app.UIAxes,nonzeros(app.Lat_filtered(:,value)),nonzeros(app.Long_filtered(:,value)));
            colorbar(app.UIAxes,'off');
            PlotTestGraphsTab(app,value);
        end

        % Button pushed function: SelectDataButton
        function SelectDataButtonPushed(app, event)
            value = str2num(app.LapDropDown.Value);
            colorbar(app.UIAxes,'off');
            f = figure;
            scatter(nonzeros(app.Lat_filtered(:,value)),nonzeros(app.Long_filtered(:,value)));
            [app.Selected_Lat,app.Selected_Long]=ginput(2);
            close(f);
            j = 1;
            for i = 1:1:length(app.Lat_filtered(:,value))
                if((app.Lat_filtered(i,value) >= app.Selected_Lat(1)) && (app.Lat_filtered(i,value) <= app.Selected_Lat(2))) && ((app.Long_filtered(i,value) >= app.Selected_Long(1)) && ((app.Long_filtered(i,value) <= app.Selected_Long(2))))
                    index(j) = i;
                    j = j + 1;
                end
            end
            scatter(app.UIAxes,nonzeros(app.Lat_filtered(index,value)),nonzeros(app.Long_filtered(index,value)));
            PlotSelectedData(app,value,index)
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

            % Create DataMenu
            app.DataMenu = uimenu(app.UIFigure);
            app.DataMenu.Text = 'Data';

            % Create SelectStartPointMenu
            app.SelectStartPointMenu = uimenu(app.DataMenu);
            app.SelectStartPointMenu.MenuSelectedFcn = createCallbackFcn(app, @SelectStartPointMenuSelected, true);
            app.SelectStartPointMenu.Text = 'Select Start Point';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [377 1 420 588];

            % Create GPSTab
            app.GPSTab = uitab(app.TabGroup);
            app.GPSTab.SizeChangedFcn = createCallbackFcn(app, @GPSTabSizeChanged, true);
            app.GPSTab.Title = 'GPS';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GPSTab);
            title(app.UIAxes2, 'Track Speed')
            xlabel(app.UIAxes2, 'Point')
            ylabel(app.UIAxes2, 'Speed')
            app.UIAxes2.PlotBoxAspectRatio = [1.84126984126984 1 1];
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [-8 306 427 257];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.GPSTab);
            title(app.UIAxes3, 'Altitude')
            xlabel(app.UIAxes3, 'Time')
            ylabel(app.UIAxes3, 'Altitude')
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.Position = [1 38 418 269];

            % Create ACCELTab
            app.ACCELTab = uitab(app.TabGroup);
            app.ACCELTab.Title = 'ACCEL';

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.ACCELTab);
            title(app.UIAxes6, 'X Accel')
            xlabel(app.UIAxes6, 'Time')
            ylabel(app.UIAxes6, 'G')
            app.UIAxes6.Position = [1 378 418 185];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.ACCELTab);
            title(app.UIAxes7, 'Y Accel')
            xlabel(app.UIAxes7, 'Time')
            ylabel(app.UIAxes7, 'G')
            app.UIAxes7.Position = [1 194 419 185];

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.ACCELTab);
            title(app.UIAxes8, 'Z Accel')
            xlabel(app.UIAxes8, 'Time')
            ylabel(app.UIAxes8, 'G')
            app.UIAxes8.Position = [1 9 418 185];

            % Create ROLLTab
            app.ROLLTab = uitab(app.TabGroup);
            app.ROLLTab.Title = 'ROLL';

            % Create UIAxes9
            app.UIAxes9 = uiaxes(app.ROLLTab);
            title(app.UIAxes9, 'Roll')
            xlabel(app.UIAxes9, 'Time')
            ylabel(app.UIAxes9, '(Deg/s)')
            app.UIAxes9.Position = [1 378 418 185];

            % Create UIAxes10
            app.UIAxes10 = uiaxes(app.ROLLTab);
            title(app.UIAxes10, 'Yaw')
            xlabel(app.UIAxes10, 'Time')
            ylabel(app.UIAxes10, '(Deg/s)')
            app.UIAxes10.Position = [1 194 418 185];

            % Create UIAxes11
            app.UIAxes11 = uiaxes(app.ROLLTab);
            title(app.UIAxes11, 'Pitch')
            xlabel(app.UIAxes11, 'Time')
            ylabel(app.UIAxes11, '(Deg/s)')
            app.UIAxes11.Position = [1 10 418 185];

            % Create FrontPOTSTab
            app.FrontPOTSTab = uitab(app.TabGroup);
            app.FrontPOTSTab.Title = 'Front POTS';

            % Create UIAxes12
            app.UIAxes12 = uiaxes(app.FrontPOTSTab);
            title(app.UIAxes12, 'FL')
            xlabel(app.UIAxes12, 'Time')
            ylabel(app.UIAxes12, 'Voltage')
            app.UIAxes12.Position = [1 289 418 274];

            % Create UIAxes13
            app.UIAxes13 = uiaxes(app.FrontPOTSTab);
            title(app.UIAxes13, 'FR')
            xlabel(app.UIAxes13, 'Time')
            ylabel(app.UIAxes13, 'Voltage')
            app.UIAxes13.Position = [1 38 419 252];

            % Create RearPOTSTab
            app.RearPOTSTab = uitab(app.TabGroup);
            app.RearPOTSTab.Title = 'Rear POTS';

            % Create UIAxes14
            app.UIAxes14 = uiaxes(app.RearPOTSTab);
            title(app.UIAxes14, 'RL')
            xlabel(app.UIAxes14, 'Time')
            ylabel(app.UIAxes14, 'Voltage (Degrees)')
            app.UIAxes14.Position = [1 303 418 260];

            % Create UIAxes15
            app.UIAxes15 = uiaxes(app.RearPOTSTab);
            title(app.UIAxes15, 'RR')
            xlabel(app.UIAxes15, 'Time')
            ylabel(app.UIAxes15, 'Voltage')
            app.UIAxes15.Position = [1 38 418 266];

            % Create BRAKESTab
            app.BRAKESTab = uitab(app.TabGroup);
            app.BRAKESTab.Title = 'BRAKES';

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.BRAKESTab);
            title(app.UIAxes4, 'Rear Brakes')
            xlabel(app.UIAxes4, 'Time')
            ylabel(app.UIAxes4, 'V')
            app.UIAxes4.Position = [1 288 418 275];

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.BRAKESTab);
            title(app.UIAxes5, 'Front Brakes')
            xlabel(app.UIAxes5, 'Time')
            ylabel(app.UIAxes5, 'V')
            app.UIAxes5.Position = [2 9 418 280];

            % Create General2
            app.General2 = uitab(app.TabGroup);
            app.General2.Title = 'General2';

            % Create UIAxes16
            app.UIAxes16 = uiaxes(app.General2);
            title(app.UIAxes16, 'Steering Angle')
            xlabel(app.UIAxes16, '')
            ylabel(app.UIAxes16, 'Angle')
            app.UIAxes16.Position = [1 312 419 251];

            % Create UIAxes17
            app.UIAxes17 = uiaxes(app.General2);
            title(app.UIAxes17, 'RPM')
            xlabel(app.UIAxes17, 'Point')
            ylabel(app.UIAxes17, 'RPM')
            app.UIAxes17.Position = [1 30 418 283];

            % Create EngineTab
            app.EngineTab = uitab(app.TabGroup);
            app.EngineTab.Title = 'Engine';
            app.EngineTab.BackgroundColor = [0.502 0.502 0.502];

            % Create RPMGaugeLabel
            app.RPMGaugeLabel = uilabel(app.EngineTab);
            app.RPMGaugeLabel.HorizontalAlignment = 'center';
            app.RPMGaugeLabel.Position = [194 84 32 22];
            app.RPMGaugeLabel.Text = 'RPM';

            % Create RPMGauge
            app.RPMGauge = uigauge(app.EngineTab, 'circular');
            app.RPMGauge.Limits = [0 14];
            app.RPMGauge.ScaleDirection = 'counterclockwise';
            app.RPMGauge.FontColor = [1 0 0];
            app.RPMGauge.Position = [1 121 418 418];
            app.RPMGauge.Value = 1.4;

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
            app.LapDropDown.Items = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
            app.LapDropDown.ItemsData = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
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