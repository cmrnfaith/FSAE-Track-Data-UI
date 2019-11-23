%NOTES FOR PSUEDO CODE

%PARAMETERS NEEDED
    %Ride Height:
        %FLride
        %FRride
        %RRride
        %RLride
    %Vertical Sweep of Wheel:
        %FLwheeltravel
        %FRwheeltravel
        %RRwheeltravel
        %RLwheeltravel
    %Vertical Sweep of Damper --> movement at damper(stroke length)
        %FLshockstroke
        %FRshockstroke
        %RRshockstroke
        %RLshockstroke
    %Motion Ratio (Can compare measure or calculated)
        %FLmotionratio
        %FRmotionratio
        %RRmotionratio
        %RLmotionratio
    %Track:
        %Ftrack
        %Rtrack
    %Wheelbase:
        %wheelbase
    %Front/Rear Weight Distributiton: xx% / xx%
        %Fweight
        %Rweight
    %Need Equation for Camber Curve (probably just theoretical is fune
    %unless we want to measure and calculate)
        %FLstaticcamber
        %FRstaticcamber
        %RRstaticcamber
        %RLstaticcamber
  
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
    FLshockbump = (FLshock(i) - FLride) * FLshockstroke;
    FRshockbump = (FRshock(i) - FRride) * FRshockstroke;
    RRshockbump = (RRshock(i) - RRride) * RRshockstroke;
    RLshockbump = (RLshock(i) - RLride) * RLshockstroke;
end

%STEP 3: CALCULATE WHEEL POSITION IN (mm)  
for i = 1:length(FLschockbump)
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
   Froll(i) = atan((FRbump(i) - FLbump(i))/Ftrack);
   Rroll(i) = atan((RRbump(i) - RLbump(i))/Rtrack);
end

for i = 1:length(Froll)
   roll = (Froll(i)*Fweight) + (Rroll(i)*Rweight); 
end

%STEP 6:CALCULATE PITCH ANGLES
for i = 1:length(Fvertical)
   pitch(i) = atan((Rvertical(i) - Fvertical(i))/wheelbase); 
end

%STEP 7: CALCULATE CHANGE IN CAMBER AT EACH WHEEL
FLcamberchange = 

%STEP 8: CALCULATE TOTAL DYNAMIC CAMBER


