classdef TrackDataAppTest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        DataMenu              matlab.ui.container.Menu
        SelectStartPointMenu  matlab.ui.container.Menu
        Menu2                 matlab.ui.container.Menu
        TabGroup              matlab.ui.container.TabGroup
        TestGraphsTab         matlab.ui.container.Tab
        UIAxes2               matlab.ui.control.UIAxes
        EngineTab             matlab.ui.container.Tab
        RPMGaugeLabel         matlab.ui.control.Label
        RPMGauge              matlab.ui.control.Gauge
        ImportDataButton      matlab.ui.control.Button
        UIAxes                matlab.ui.control.UIAxes
        LapDropDownLabel      matlab.ui.control.Label
        LapDropDown           matlab.ui.control.DropDown
    end


    properties (Access = private)
    end

    methods (Access = public)
    
        
        function results = Startup(app)
            %This function imports the data and then plots about 11k points
            %on the graph so the data can be seen. Next in the process is
            %to select a "start point" for the track in order to separate
            %the data lap by lap.
        data = uiimport('-file');
        Lat = rmmissing(data.x_Latitude___Degrees____180_0_180_0_50_');
        Long = rmmissing(data.x_Longitude___Degrees____180_0_180_0_50_');
        Speed = rmmissing(data.x_Speed___MPH___0_0_150_0_50_');
        lat1 = 40.84479;
        lat2 = 40.84487;
        long1 = -96.76792;
        long2 = -96.76790;
        
        LapNumber = 0;
        for i = 0:length(Lat)
           if ((Lat(i) <= lat2) && (Lat(i) >= lat1)) && ((Long(i) <= long2) && (Long(i) >= long1))
               LapNumber = LapNumber + 1;
           end
           
        
        end
        LapNumber
        
        colormap(app.UIAxes,hsv);
        scatter(app.UIAxes,Lat(10000:21000),Long(10000:21000),20,Speed(10000:21000));
        figure;
        scatterPlot = scatter(Lat,Long,20,Speed);
        legend;
        Widthlong = abs(long2 - long1);
        Widthlat = abs(lat2 - lat1);
        rectangle('Position', [lat1 long2 Widthlat Widthlong]);

        %trackStartArea = SelectStartPoint(app,scatterPlot);
        
        end
    end
    
    methods (Access = public)
        
        function trackStartArea = SelectStartPoint(app,plot1)
            trackStartArea = drawcuboid(plot1);
            disp('This will print immediately');
            uiwait(gcf); 
            disp('This will print after you click Continue');
            return;
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

            % Create TestGraphsTab
            app.TestGraphsTab = uitab(app.TabGroup);
            app.TestGraphsTab.SizeChangedFcn = createCallbackFcn(app, @TestGraphsTabSizeChanged, true);
            app.TestGraphsTab.Title = 'Test Graphs';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.TestGraphsTab);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            app.UIAxes2.Position = [1 379 300 185];

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
            app.LapDropDown.Items = {'Lap 1', 'Lap 2', 'Lap 3', 'Lap 4'};
            app.LapDropDown.Editable = 'on';
            app.LapDropDown.BackgroundColor = [1 1 1];
            app.LapDropDown.Position = [310 10 60 22];
            app.LapDropDown.Value = 'Lap 1';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = TrackDataApp

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