        data = uiimport('-file');
        Lat = nonzeros(rmmissing(data.x_Latitude___Degrees____180_0_180_0_50_'));
        Long = nonzeros(rmmissing(data.x_Longitude___Degrees____180_0_180_0_50_'));
        Speed = nonzeros(rmmissing(data.x_Speed___MPH___0_0_150_0_50_'));
        lat1 = 40.84479;
        lat2 = 40.84487;
        long1 = -96.76792;
        long2 = -96.767907;
        
        LapNumber = 1;
        counter = 0;
        index = 1;
        for i = 1:length(Lat)
           if (counter == 0) && ((Lat(i) <= lat2) && (Lat(i) >= lat1)) && ((Long(i) <= long2) && (Long(i) >= long1))
               index = 1;
%                for j = 1:jump
%                    Lat_filtered(index,LapNumber)= Lat(i);
%                    Long_filtered(index,LapNumber)= Long(i);
%                    i = i + 1;
%                    index = index + 1;
%                end
               counter = 3;
               i = i + 1;
               LapNumber = LapNumber + 1;
           end
           Lat_filtered(index,LapNumber)= Lat(i);
           Long_filtered(index,LapNumber)= Long(i);
           index = index + 1;
           if counter ~= 0
               counter = counter - 1;
           end
        end
        LapNumber
        for laps = 1: LapNumber
            figure
            scatter(nonzeros(Lat_filtered(:,laps)),nonzeros((Long_filtered(:,laps))));
        end
        
        %colormap(hsv);
        %scatter(Lat(10000:21000),Long(10000:21000),20,Speed(10000:21000));
        %legend;
        %figure;
        %scatterPlot = scatter(Lat,Long);
        
        Widthlong = abs(long2 - long1);
        Widthlat = abs(lat2 - lat1);
        rectangle(u'Position', [lat1 long2 Widthlat Widthlong]);