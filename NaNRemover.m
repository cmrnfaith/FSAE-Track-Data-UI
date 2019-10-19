data = uiimport('-file');   %   Need to be imported as vectors, imports and stores as a structure called data

fn = fieldnames(data); %array of the names of each coloumn from excel file

for i=1:numel(fn) %loop that cycles through every coloumn of structure
    data.(fn{i})(1) = 0; %set first element to 0
    for k=1:length(data.(fn{i})) %loop that cycles through every element of every column
        if (isnan(data.(fn{i})(k))) %check to see if array element is NaN
            newvalue = data.(fn{i})(k-1); %if it is NaN then set the new value to the previous value
            n=1; %counter
            while (isnan(newvalue)) %loop to keep decreasing the newvalue until it is NaN
                newvalue = data.(fn{i})(k-n);
                n = n + 1; %increase counter
            end
            data.(fn{i})(k) = newvalue;
        end
    end
end

%GENERAL
Lat = (data.x_Latitude___Degrees____180_0_180_0_50_');
Long = (data.x_Longitude___Degrees____180_0_180_0_50_');
Speed = (data.x_Speed___MPH___0_0_150_0_50_');
Time = (data.x_Interval___ms___0_0_1_');
RPM = (data.x_RPM___RPM___0_12500_50_');
Steering_Angle = (data.x_SteeringAng___Volts____105_0_105_0_50_');
Altitude = (data.x_Altitude___ft___0_0_4000_0_50_');

%POTENTIOMETERS
FL_Damper = (data.x_FrontLeft______0_0_100_0_100_');
FR_Damper = (data.x_FrontRight______0_0_100_0_100_');
RL_Damper = (data.x_RearLeft______0_0_100_0_100_');
RR_Damper = (data.x_RearRight______0_0_100_0_100_');

%BRAKES
R_Brake = (data.x_RearBrake___Volts___0_0_5_0_50_');
F_Brake = (data.x_FrontBrake___Volts___0_0_5_0_50_');

%ROLL
Yaw = (data.x_Yaw___Deg_Sec____120_120_25_');
Pitch = (data.x_Pitch___Deg_Sec____120_120_25_');
Roll = (data.x_Roll___Deg_Sec____120_120_25_');

%ACCELERATION
Accel_X = (data.x_AccelX___G____3_0_3_0_25_');
Accel_Y = (data.x_AccelY___G____3_0_3_0_25_');
Accel_Z = (data.x_AccelZ___G____3_0_3_0_25_');

Selected_Lat(1)  =  40.84479;
Selected_Lat(2)  =  40.84487;
Selected_Long(1) = -96.76793;
Selected_Long(2) = -96.76790;

LapNumber = 1;
counter = 0;
index = 1;

%Sampling Frequency => Default is 1
SamplingFreq = 4;

%Cutoff Points => I.e if you need to get rid of garbage data at
%start or finish
SamplingStart = 80; % Needs to be a multiple of freq. I.e if frequency is 4 Start can be 4, 8, 12, etc.
SamplingFinish = 80;

for i = SamplingStart:(length(Yaw) - SamplingFinish)
    
    if (counter == 0) && ((Lat(i) <= Selected_Lat(2)) && (Lat(i) >= Selected_Lat(1))) && ((Long(i) <= Selected_Long(2)) && (Long(i) >= Selected_Long(1)))
        index = 1;
        counter = 2000;
        LapNumber = LapNumber + 1;
    end
    
        %Here the filtered data is
        Lat_filtered(index,LapNumber)= Lat(i);
        Long_filtered(index,LapNumber)= Long(i);
        Speed_filtered(index,LapNumber)= Speed(i);
        Time_filtered(index,LapNumber)= Time(i);
        RPM_filtered(index,LapNumber)= RPM(i);
        Steering_Angle_filtered(index,LapNumber)= Steering_Angle(i);
        Altitude_filtered(index,LapNumber)= Altitude(i);
        
        %POTENTIOMETERS
        FL_Damper_filtered(index,LapNumber)= FL_Damper(i);
        FR_Damper_filtered(index,LapNumber)= FR_Damper(i);
        RL_Damper_filtered(index,LapNumber)= RL_Damper(i);
        RR_Damper_filtered(index,LapNumber)= RR_Damper(i);
        
        %BRAKES
        R_Brake_filtered(index,LapNumber)= R_Brake(i);
        F_Brake_filtered(index,LapNumber)= F_Brake(i);
        
        %ROLL
        Yaw_filtered(index,LapNumber)= Yaw(i);
        Pitch_filtered(index,LapNumber)= Pitch(i);
        Roll_filtered(index,LapNumber)= Roll(i);
        
        %ACCELERATION
        Accel_X_filtered(index,LapNumber)= Accel_X(i);
        Accel_Y_filtered(index,LapNumber)= Accel_Y(i);
        Accel_Z_filtered(index,LapNumber)= Accel_Z(i);
        
        index = index + 1;
    i = i + SamplingFreq - 1; 
    if counter ~= 0   %To make sure counter doesn't go below zero... counter should be a multiple of freq
        counter = counter - 1;
    end
end


%Re-saving into new structure

%GENERAL
data_filtered.Latitude = Lat_filtered;
data_filtered.Longitude = Long_filtered;
data_filtered.Speed = Speed_filtered;
data_filtered.Time = Time_filtered;
data_filtered.RPM = RPM_filtered;
data_filtered.Steering_Angle = Steering_Angle_filtered;
data_filtered.Altitude = Altitude_filtered;

%POTENTIOMETERS
data_filtered.FL_Damper = FL_Damper_filtered;
data_filtered.FR_Damper = FR_Damper_filtered;
data_filtered.RL_Damper = RL_Damper_filtered;
data_filtered.RR_Damper = RR_Damper_filtered;

%BRAKES
data_filtered.R_Brake = R_Brake_filtered;
data_filtered.F_Brake = F_Brake_filtered;

%ROLL
data_filtered.Yaw = Yaw_filtered;
data_filtered.Pitch = Pitch_filtered;
data_filtered.Roll = Roll_filtered;

%ACCELERATION
data_filtered.Accel_X = Accel_X_filtered;
data_filtered.Accel_Y = Accel_Y_filtered;
data_filtered.Accel_Z = Accel_Z_filtered;

struct2csv(data_filtered, 'log_1_cleaned.csv');
clear
function struct2csv(s,fn)
% STRUCT2CSV(s,fn)
%
% Output a structure to a comma delimited file with column headers
%
%       s : any structure composed of one or more matrices and cell arrays
%      fn : file name
%
%      Given s:
%
%          s.Alpha = { 'First', 'Second';
%                      'Third', 'Fourth'};
%
%          s.Beta  = [[      1,       2;
%                            3,       4]];
%
%          s.Gamma = {       1,       2;
%                            3,       4};
%
%          s.Epsln = [     abc;
%                          def;
%                          ghi];
%
%      STRUCT2CSV(s,'any.csv') will produce a file 'any.csv' containing:
%
%         "Alpha",        , "Beta",   ,"Gamma",   , "Epsln",
%         "First","Second",      1,  2,      1,  2,   "abc",
%         "Third","Fourth",      3,  4,      3,  4,   "def",
%                ,        ,       ,   ,       ,   ,   "ghi",
%
%      v.0.9 - Rewrote most of the code, now accommodates a wider variety
%              of structure children
%
% Written by James Slegers, james.slegers_at_gmail.com
% Covered by the BSD License
%

FID = fopen(fn,'w');
headers = fieldnames(s);
m = length(headers);
sz = zeros(m,2);

t = length(s);

for rr = 1:t
    l = '';
    for ii = 1:m
        sz(ii,:) = size(s(rr).(headers{ii}));
        if ischar(s(rr).(headers{ii}))
            sz(ii,2) = 1;
        end
        l = [l,'"',headers{ii},'",',repmat(',',1,sz(ii,2)-1)];
    end
    
    l = [l,'\n'];
    
    fprintf(FID,l);
    
    n = max(sz(:,1));
    
    for ii = 1:n
        l = '';
        for jj = 1:m
            c = s(rr).(headers{jj});
            str = '';
            
            if sz(jj,1)<ii
                str = repmat(',',1,sz(jj,2));
            else
                if isnumeric(c)
                    for kk = 1:sz(jj,2)
                        str = [str,num2str(c(ii,kk)),','];
                    end
                elseif islogical(c)
                    for kk = 1:sz(jj,2)
                        str = [str,num2str(double(c(ii,kk))),','];
                    end
                elseif ischar(c)
                    str = ['"',c(ii,:),'",'];
                elseif iscell(c)
                    if isnumeric(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,num2str(c{ii,kk}),','];
                        end
                    elseif islogical(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,num2str(double(c{ii,kk})),','];
                        end
                    elseif ischar(c{1,1})
                        for kk = 1:sz(jj,2)
                            str = [str,'"',c{ii,kk},'",'];
                        end
                    end
                end
            end
            l = [l,str];
        end
        l = [l,'\n'];
        fprintf(FID,l);
    end
    fprintf(FID,'\n');
end

fclose(FID);
end