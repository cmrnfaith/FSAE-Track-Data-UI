classdef TrackAppScriptFile < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        TabGroup             matlab.ui.container.TabGroup
        TestGraphsTab        matlab.ui.container.Tab
        UIAxes               matlab.ui.control.UIAxes
        EngineTab            matlab.ui.container.Tab
        GaugeLabel           matlab.ui.control.Label
        Gauge                matlab.ui.control.Gauge
        CSVLINESpinnerLabel  matlab.ui.control.Label
        CSVLINESpinner       matlab.ui.control.Spinner
    end


    properties (Access = private)
    end

    methods (Access = private)
    
        
    end


    methods (Access = private)

        % Size changed function: TestGraphsTab
        function TestGraphsTabSizeChanged(app, event)

        end

        % Value changing function: CSVLINESpinner
        function CSVLINESpinnerValueChanging(app, event)
            changingValue = event.Value;
            val = app.CSVLINESpinner.Value;
            app.Guage.Value = changingValue;
            CSVLine = changingValue;
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

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [325 1 472 588];

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
            app.UIAxes.Position = [1 368 300 185];

            % Create EngineTab
            app.EngineTab = uitab(app.TabGroup);
            app.EngineTab.Title = 'Engine';
            app.EngineTab.BackgroundColor = [0.502 0.502 0.502];

            % Create GaugeLabel
            app.GaugeLabel = uilabel(app.EngineTab);
            app.GaugeLabel.HorizontalAlignment = 'center';
            app.GaugeLabel.Position = [163 194 42 22];
            app.GaugeLabel.Text = 'Gauge';

            % Create Gauge
            app.Gauge = uigauge(app.EngineTab, 'circular');
            app.Gauge.Limits = [0 14000];
            app.Gauge.MajorTickLabels = {'0', '1400', '2800', '4200', '5600', '7000', '8400', '9800', '11200', '12600', '14000'};
            app.Gauge.FontColor = [1 0 0];
            app.Gauge.Position = [30 231 308 308];

            % Create CSVLINESpinnerLabel
            app.CSVLINESpinnerLabel = uilabel(app.UIFigure);
            app.CSVLINESpinnerLabel.HorizontalAlignment = 'right';
            app.CSVLINESpinnerLabel.Position = [21 2 60 22];
            app.CSVLINESpinnerLabel.Text = 'CSV LINE';

            % Create CSVLINESpinner
            app.CSVLINESpinner = uispinner(app.UIFigure);
            app.CSVLINESpinner.ValueChangingFcn = createCallbackFcn(app, @CSVLINESpinnerValueChanging, true);
            app.CSVLINESpinner.Position = [96 2 100 22];
        end
    end

    methods (Access = public)

        % Construct app
        function app = TrackAppScriptFile
            %Import data to be plotted
            CSVdata = uiimport('-file');
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