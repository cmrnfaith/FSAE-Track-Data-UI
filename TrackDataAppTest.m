classdef TrackDataAppTest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        DataMenu              matlab.ui.container.Menu
        SelectStartPointMenu  matlab.ui.container.Menu
        Menu2                 matlab.ui.container.Menu
        TabGroup              matlab.ui.container.TabGroup
        EngineTab             matlab.ui.container.Tab
        RPMGaugeLabel         matlab.ui.control.Label
        RPMGauge              matlab.ui.control.Gauge
        ImportDataButton      matlab.ui.control.Button
        TestGraphsTab         matlab.ui.container.Tab
        UIAxes2               matlab.ui.control.UIAxes
        UIAxes                matlab.ui.control.UIAxes
        LapDropDownLabel      matlab.ui.control.Label
        LapDropDown           matlab.ui.control.DropDown
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
            app.Lat = rmmissing(data.x_Latitude___Degrees____180_0_180_0_50_');
            app.Long = rmmissing(data.x_Longitude___Degrees____180_0_180_0_50_');
            app.Speed = rmmissing(data.x_Speed___MPH___0_0_150_0_50_');
            app.Time = rmmissing(data.x_Interval___ms___0_0_1_');
            app.RPM = rmmissing(data.x_RPM___RPM___0_12500_50_');
            app.Steering_Angle = rmmissing(data.x_SteeringAng___Volts____105_0_105_0_50_');
            app.Altitude = rmmissing(data.x_Altitude___ft___0_0_4000_0_50_');
            
            %POTENTIOMETERS
            app.FL_Damper = rmmissing(data.x_FrontLeft______0_0_100_0_100_');
            app.FR_Damper = rmmissing(data.x_FrontRight______0_0_100_0_100_');
            app.RL_Damper = rmmissing(data.x_RearLeft______0_0_100_0_100_');
            app.RR_Damper = rmmissing(data.x_RearRight______0_0_100_0_100_');
            
            %BRAKES
            app.R_Brake = rmmissing(data.x_RearBrake___Volts___0_0_5_0_50_');
            app.F_Brake = rmmissing(data.x_FrontBrake___Volts___0_0_5_0_50_');
            
            %ROLL
            app.Yaw = rmmissing(data.x_Yaw___Deg_Sec____120_120_25_');
            app.Pitch = rmmissing(data.x_Pitch___Deg_Sec____120_120_25_');
            app.Roll = rmmissing(data.x_Roll___Deg_Sec____120_120_25_');
            
            %ACCELERATION
            app.Accel_X = rmmissing(data.x_AccelX___G____3_0_3_0_25_');
            app.Accel_Y = rmmissing(data.x_AccelY___G____3_0_3_0_25_');
            app.Accel_Z = rmmissing(data.x_AccelZ___G____3_0_3_0_25_');
            
            %Filling with zeros for testing. Will either need to cut out data
            %or find a way to make the vector lengths the same.
            %app.Speed(numel(app.Long)) = 0;
            
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
                if (counter <= (SamplingFreq - 1)) && ((app.Lat(i) <= lat2) && (app.Lat(i) >= lat1)) && ((app.Long(i) <= long2) && (app.Long(i) >= long1))
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
                
                if counter > SamplingFreq - 1    %To make sure counter doesn't go below zero... counter should be a multiple of freq
                    counter = counter - SamplingFreq;
                end
            end
            LapNumber %#ok<NOPRT>
            
            colormap(app.UIAxes,hsv);
            scatter(app.UIAxes,app.Lat(10000:21000),app.Long(10000:21000),20,app.Speed(10000:21000));
            colorbar(app.UIAxes);
            
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
            scatter(app.UIAxes2,[1:1:length(nonzeros(app.Speed_filtered(:,lap)))],nonzeros(app.Speed_filtered(:,lap)));
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Size changed function: TestGraphsTab
        function TestGraphsTabSizeChanged(app, event)
            position = app.TestGraphsTab.Position;
            
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
            PlotTestGraphsTab(app,value);
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

            % Create Menu2
            app.Menu2 = uimenu(app.UIFigure);
            app.Menu2.Text = 'Menu2';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [377 1 420 588];

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

            % Create ImportDataButton
            app.ImportDataButton = uibutton(app.EngineTab, 'push');
            app.ImportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportDataButtonPushed, true);
            app.ImportDataButton.Position = [305 9 100 22];
            app.ImportDataButton.Text = 'Import Data';

            % Create TestGraphsTab
            app.TestGraphsTab = uitab(app.TabGroup);
            app.TestGraphsTab.SizeChangedFcn = createCallbackFcn(app, @TestGraphsTabSizeChanged, true);
            app.TestGraphsTab.Title = 'Test Graphs';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.TestGraphsTab);
            title(app.UIAxes2, 'Track Speed')
            xlabel(app.UIAxes2, 'Point')
            ylabel(app.UIAxes2, 'Speed')
            app.UIAxes2.PlotBoxAspectRatio = [1.84126984126984 1 1];
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [1 307 419 257];

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