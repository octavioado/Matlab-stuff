%%%%% Cross correlation stiction detection
function SI= wcrco(y,u,d);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% y= PV;               %%%
%%% u= OP;               %%%
%%% d=half-period length %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n]=size(y)
if n>1
u=u';
y=y';

else
    u=u;
    y=y;
  
end

% determine max lag
%[ind1, ind2, ind3, hp] = Oscdet_2(y);



% find zero crossings
% 
% n=length(y);
% 
% zc = find(abs( diff(sign(y+eps)) ) == 2);         % zero-crossings
% s=length(zc);




% compute cross covariance
d=ceil(2*d);    % period length

[v lags]=xcov(y,u,d,'coeff');

%v=xcov(y,u,s(1),'coeff');

% define if even or odd
% v(d+1:end);
% v(d+1:-1:1);

% zer crossins for both sides
zcpos = find(abs( diff(sign(v(d+1:end)+eps)) ) == 2);
zcneg = find(abs( diff(sign(v(d+1:-1:1)+eps)) ) == 2);
% vpos= v(zcpos(1));
% vneg= v(zcneg(1));
if isempty(zcpos)  || isempty(zcneg)
    SI = 0.5;
    return
end

% CCF at lag 0
r0 = abs(v(d+1));

% max cross cov for(tau)

[vm,tm] = max(abs( v(d+1-zcneg(1):d+1+zcpos(1)) ));

% r0pt

 r0pt = vm * sign(r0);

% delta tau delta ro
delta_tau = abs(zcneg(1)-zcpos(1))/(zcneg(1)+zcpos(1));   
delta_r0  = abs(r0-r0pt)/abs(r0+r0pt);

% conditions & threshold

th=(2-sqrt(3))/(2+sqrt(3));  

% stiction
Sc1 = delta_tau>=2.7/4;                          
Sc2 = delta_r0>=1/4;

% no stiction
Nc1 = delta_tau<1/3;
Nc2 = delta_r0<th;
 
 
% NO DECISION
Nd1=1/3<delta_tau && delta_tau<2/3;
Nd2=th<delta_r0 && delta_r0<1/3;
  if Sc1 & Sc2        % stiction case
   SI = 1;
 elseif Nc1 & Nc2  % non-stiction case
   SI = 0;
  elseif Nd1 |  Nd2
      SI=0.5; 
  end

  % plotting results
%   plot(lags,v)
%   hold on
%   plot(tm-zcneg(1)-1,sign(v(d+1))*vm,'*')
%   hold on
%   plot(0,(v(d+1)),'or')
%   hold on
%  if sign(v(d+1)) == 1
%   
%   plot(-sign(v(d+1))*zcneg(1),0,'*g')
%   
%  else sign(v(d+1)) == -1
%      
%    plot(sign(v(d+1))*zcneg(1),0,'*g')   
%  end
%   hold on
%   plot(zcpos(1),0,'*y')
% %  
%   
  
  
end