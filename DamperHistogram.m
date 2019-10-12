%naming convention is:
% fl - front left
% fr - front right
% rr - rear right
% rl - rear left
%
%This script needs pot data arrays to be saved as frontleft, rearright,
%etc in order to run. Can change names so that it does it lap by lap or
%overall for the whole data set.

%precreate the arrays for shockspeed to optimize runtime
shockspeedfl = zeros(sz);
shockspeedfr = zeros(sz);
shockspeedrr = zeros(sz);
shockspeedrl = zeros(sz);

dt = 10E-3; %this is time step of sample
for i=1:(length(frontleft)-1) %cycle through length of poteniometer array
   %take deriviative (approx is used here) for pot array to calculate shock
   %speed
    shockspeedfl(i) = (frontleft(i+1)-frontleft(i))/dt;
    shockspeedfr(i) = (frontright(i+1)-frontright(i))/dt;
    shockspeedrr(i) = (rearright(i+1)-rearright(i))/dt;
    shockspeedrl(i) = (rearleft(i+1)-rearleft(i))/dt;
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
%this provides the values used to plot the pdf, based on the sizes of the
%bins used in the histogram
x = bl(1):0.1:bl(2);

%----PLOTTING TIME BOYS----
bl = [-20 20]; %bin limits, for histogram plotting
nbins = 50; %number of bins in histogram, can adjust to optimize
sz = size(frontleft); %this presizes the shock speed arrays for speed
xlb = 'Shock Speed(no units yet)'; %xlabel for plots
ylb = 'Probability (%)'; %ylabel for plots
xlimit = bl;
ylimit = [0 .15];

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
xlabel(xlb);
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
