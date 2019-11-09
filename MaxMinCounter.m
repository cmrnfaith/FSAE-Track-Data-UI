FLmax = 0;
FRmax = 0;
RRmax = 0;
RLmax = 0;

FLmin = 0;
FRmin = 0;
RRmin = 0;
RLmin = 0;

upper_p = 99;
lower_p = 1;

%After the if/else at start of GenerateDamperSpeedData add the following:
    FLupper = prctile(frontLeft, upper_p);
    FLlower = prctile(frontLeft, lower_p);
    
    FRupper = prctile(frontRight, upper_p);
    FRlower = prctile(frontRight, lower_p);
    
    RLupper = prctile(rearLeft, upper_p);
    RLlower = prctile(rearLeft, lower_p);
    
    RRupper = prctile(frontRight, upper_p);
    RRlower = prctile(frontRight, lower_p);
    
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
   
    app.LABELFL.Text = sprintf('%s\n%s', FLmax + "/" + FLmin);
    app.LABELFR.Text = sprintf('%s\n%s', FRmax + "/" + FRmin);
    app.LABELRR.Text = sprintf('%s\n%s', RRmax + "/" + RRmin);
    app.LABELRL.Text = sprintf('%s\n%s', RLmax + "/" + RLmin);
    
    
