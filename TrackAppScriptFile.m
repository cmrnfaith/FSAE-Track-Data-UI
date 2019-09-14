

classdef TrackAppScriptFile < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        CSVLineSliderLabel  matlab.ui.control.Label
        CSVLineSlider       matlab.ui.control.Slider
        TabGroup            matlab.ui.container.TabGroup
        TestGraphsTab       matlab.ui.container.Tab
        UIAxes              matlab.ui.control.UIAxes
        EngineTab           matlab.ui.container.Tab
        GaugeLabel          matlab.ui.control.Label
        Gauge               matlab.ui.control.Gauge
    end



    methods (Access = private)

        % Size changed function: TestGraphsTab
        function TestGraphsTabSizeChanged(app, event)

        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 796 588];
            app.UIFigure.Name = 'UI Figure';

            % Create CSVLineSliderLabel
            app.CSVLineSliderLabel = uilabel(app.UIFigure);
            app.CSVLineSliderLabel.HorizontalAlignment = 'right';
            app.CSVLineSliderLabel.Position = [1 22 56 22];
            app.CSVLineSliderLabel.Text = 'CSV Line';

            % Create CSVLineSlider
            app.CSVLineSlider = uislider(app.UIFigure);
            app.CSVLineSlider.Position = [78 31 236 3];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [325 1 472 580];

            % Create TestGraphsTab
            app.TestGraphsTab = uitab(app.TabGroup);
            app.TestGraphsTab.SizeChangedFcn = createCallbackFcn(app, @TestGraphsTabSizeChanged, true);
            app.TestGraphsTab.Title = 'Test Graphs';

            % Create UIAxes
            app.UIAxes = uiaxes(app.TestGraphsTab);
            title(app.UIAxes, 'Test')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Box = 'on';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [1 360 300 185];

            % Create EngineTab
            app.EngineTab = uitab(app.TabGroup);
            app.EngineTab.Title = 'Engine';

            % Create GaugeLabel
            app.GaugeLabel = uilabel(app.EngineTab);
            app.GaugeLabel.HorizontalAlignment = 'center';
            app.GaugeLabel.Position = [163 186 42 22];
            app.GaugeLabel.Text = 'Gauge';

            % Create Gauge
            app.Gauge = uigauge(app.EngineTab, 'circular');
            app.Gauge.Limits = [0 14000];
            app.Gauge.MajorTickLabels = {'0', '1400', '2800', '4200', '5600', '7000', '8400', '9800', '11200', '12600', '14000'};
            app.Gauge.Position = [30 223 308 308];
        end
    end

    methods (Access = public)

        % Construct app
        function app = TrackAppScriptFile

            % Create and configure components
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