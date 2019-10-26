%naming convention is:
% fl - front left
% fr - front right
% rr - rear right
% rl - rear left
%
%This script needs pot data arrays to be saved as frontleft, rearright,
%etc in order to run. Can change names so that it does it lap by lap or
%overall for the whole data set.
sz = length(FrontLeft001000100);

%precreate the arrays for shockspeed to optimize runtime
shockspeedfl = zeros(sz,1);
shockspeedfr = zeros(sz,1);
shockspeedrr = zeros(sz,1);
shockspeedrl = zeros(sz,1);

frontLeft = FrontLeft001000100;
frontRight = FrontRight001000100;
rearLeft = RearLeft001000100;
rearRight = RearRight001000100;


dt = 10E-3; %this is time step of sample
for i=1:(length(frontLeft)-1) %cycle through length of poteniometer array
   %take deriviative (approx is used here) for pot array to calculate shock
   %speed
    shockspeedfl(i) = (frontLeft(i+1)-frontLeft(i))/dt;
    shockspeedfr(i) = (frontRight(i+1)-frontRight(i))/dt;
    shockspeedrr(i) = (rearRight(i+1)-rearRight(i))/dt;
    shockspeedrl(i) = (rearLeft(i+1)-rearLeft(i))/dt;
end

%Removes NaN from shock speeds, may not be necessary in full app as the
%arrays should already have no NaN's
shockspeedfl = shockspeedfl(~isnan(shockspeedfl));
shockspeedfr = shockspeedfr(~isnan(shockspeedfr));
shockspeedrr = shockspeedrr(~isnan(shockspeedrr));
shockspeedrl = shockspeedrl(~isnan(shockspeedrl));

%Calculates mean and SD for plotting the pdf
flmu = mean(shockspeedfl);
frmu = mean(shockspeedfr);
rrmu = mean(shockspeedrr);
rlmu = mean(shockspeedrl);

flsd = std2(shockspeedfl);
frsd = std2(shockspeedfr);
rrsd = std2(shockspeedrr);
rlsd = std2(shockspeedrl);


%----PLOTTING TIME BOYS----
bl = [-20 20]; %bin limits, for histogram plotting
%this provides the values used to plot the pdf, based on the sizes of the
%bins used in the histogram
x = bl(1):0.1:bl(2);
nbins = 50; %number of bins in histogram, can adjust to optimize
sz = size(frontLeft); %this presizes the shock speed arrays for speed
xlb = 'Shock Speed(no units yet)'; %xlabel for plots
ylb = 'Probability (%)'; %ylabel for plots
xlimit = bl;
ylimit = [0 .15];
xlabel(xlb);
box = [.75, .75 .2 .2];

%start of plotting
figure
subplot(2,2,1);
%histogram for FRONT LEFT
histogram(shockspeedfl, nbins, 'Normalization', 'probability', 'BinLimits', bl);
title('Shock Speed - Front Left(Normalized Distribution)');
xlabel(xlb);
ylabel(ylb);
xlim(xlimit);
ylim(ylimit);
hold on 
%normalized probabiltiy distribution function plot
f = exp(-(x-flmu).^2./(2*flsd^2))./(flsd*sqrt(2*pi));
plot(x,f,'LineWidth',1.5);

subplot(2,2,2);
%histogram for FRONT RIGHT
histogram(shockspeedfr, nbins, 'Normalization','probability', 'BinLimits', bl);
title('Shock Speed - Front Right (Normalized Distribution)');
xlabel(xlb);
ylabel(ylb);
xlim(xlimit);
ylim(ylimit);
hold on
%normalized probabiltiy distribution function plot
f = exp(-(x-frmu).^2./(2*frsd^2))./(frsd*sqrt(2*pi));
plot(x,f,'LineWidth',1.5);

subplot(2,2,3);
%histogram for REAR LEFT
histogram(shockspeedrl, nbins, 'Normalization','probability', 'BinLimits', bl);
title('Shock Speed - Rear Left(Normalized Distribution)');
annotation('textbox', box, 'String', "Standard Deviation: % \n
ylabel(ylb);
xlim(xlimit);
ylim(ylimit);
hold on
%normalized probabiltiy distribution function
f = exp(-(x-rlmu).^2./(2*rlsd^2))./(rlsd*sqrt(2*pi));
plot(x,f,'LineWidth',1.5);

subplot(2,2,4);
%histogram for REAR RIGHT
histogram(shockspeedrr, nbins, 'Normalization','probability', 'BinLimits', bl);
title('Shock Speed - Rear Right(Normalized Distribution)');
xlabel(xlb);
ylabel(ylb);
xlim(xlimit);
ylim(ylimit);
hold on
%normalized probabiltiy distribution function
f = exp(-(x-rrmu).^2./(2*rrsd^2))./(rrsd*sqrt(2*pi));
plot(x,f,'LineWidth',1.5);
