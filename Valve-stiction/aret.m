%%% stiction detection based in area calculation%%%  
%%% Not suitable for integrating processes      %%% 
%%% y= mv process signal                        %%% 
%%% average lenght of the half period           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SIp]=aret(y,hp)

[~,n]=size(y);
if n > 1
        y=y';
end
CE=y; %control error

%% filtering
omega = 2*pi/hp.d;
gamma = exp(-3*omega);
CE_f = zeros(1, length(CE));
CE_f(1) = CE(1);
for i = 2:length(CE)
    CE_f(i) = gamma*CE_f(i-1) + (1 - gamma)*CE(i);
end
CE = CE_f;
%[~, ~, ~, hp] = oscdec(CE);

%% define the half periods
zc = zeros(1, 2*length(hp.y));
for i = 1:length(hp.y)
    %between two maximas
    v1 = find( CE(hp.lmax(i):hp.lmin(i)) > hp.y(i) );
    v2 = find( CE(hp.lmax(i):hp.lmin(i)) < hp.y(i) );
    if ~isempty(v1) & ~isempty(v2)
        zc(2*(i-1)+1) = hp.lmax(i) - 1 + floor( (v1(end) + v2(1)) /2 );
    else
        zc(2*(i-1)+1) = hp.lmax(i) - 1 + floor( (hp.lmin(i) - hp.lmax(i)) /2 );
    end
    
    v1 = find( CE(hp.lmin(i):hp.lmax(i+1)) > hp.y(i) );
    v2 = find( CE(hp.lmin(i):hp.lmax(i+1)) < hp.y(i) );
    if ~isempty(v1) & ~isempty(v2)
        zc(2*i) = hp.lmin(i) -1 + floor( (v1(1) + v2(end)) /2 );
    else
        zc(2*i) = hp.lmin(i) -1 + floor( (hp.lmax(i+1) - hp.lmin(i)) /2 );
    end
end

%%  define the peaks
g=length(zc);
%I(2:2:g) = hp.lmin(1:round(g/2));
%I(1:2:g) = hp.lmax(1:round(g/2));
I = zeros(1, g);
I(1) = hp.lmax(1);
for i = 1:round(g/2)-1
    [~, ind] = min( CE(zc(2*i-1):zc(2*i)) );
    I(2*i) = zc(2*i-1) + ind-1;
    [~, ind] = max( CE(zc(2*i):zc(2*i+1)) );
    I(2*i+1) = zc(2*i) + ind-1;
end
[~, ind] = min( CE(zc(g-1):zc(g)) );
I(g) = zc(g-1) + ind-1;
    
%% Compute the areas and the ratios

ayf = abs(CE);
Al = zeros(1, g-1);
Ar = zeros(1, g-1);
for i=1:g-1
   Al(i) = sum( ayf(zc(i):I(i+1))     - hp.y( floor((i+1.5)/2) )  ); 
   Ar(i) = sum( ayf(I(i+1):zc(i+1))   - hp.y( floor((i+1.5)/2) )  );
end

R=(Al./Ar);
l=length(R);
 
% The stiction index
mr = median(log(R));
sr = 1.4826 * mad(log(R));
%ts = mr /(sr/sqrt(l-1));
ts = mr /(sr);
tp = tcdf(ts,l-1);
if tp>0.65
SIp=1;
elseif 0.45<tp>0.65
    SIp=0;
elseif tp<0.45
    SIp=0.5;
end
%% plotting
% disp([median(log(R)), log(R)]);
% plot(CE)
% hold on
% for i=1:g-2
%     plot((I(i)),CE(I(i)),'r*')
%     plot(zc(i), CE(zc(i)), 'g*')
% end
% for i = 1:length(hp.y)-1
%     plot(zc([2*i-1, 2*i+1]), [hp.y(i) hp.y(i)], 'k')
% end
% 
