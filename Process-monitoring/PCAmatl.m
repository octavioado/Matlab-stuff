%%
%
% Principal component analysis for process monitoring 
%

%% Importing Data
clear all;
close all;
load('pcadata.mat')
X = pcadata;

%% Training
Xt = X(1:300,:); % Training data


N = length(Xt); % Num of obs
nvar = size(Xt,2); % Num of var 

% Scaling
Xmean = mean(Xt);
Xstd = std(Xt);
XtScaled = Xt - ones(N,1)*Xmean;
XtScaled = XtScaled./(ones(N,1)*Xstd);

% Covariance matrix
C = XtScaled'*XtScaled/(N-1);

% Eigen vectors
[eigvec, lambda] = eigs(C,nvar);

% Principal Components
cusm = cumsum(diag(lambda));
perc = [];

% Variance coverage
for i = 1:length(cusm)
       perc = [perc cusm(i)/cusm(end)*100];
end

bar(perc);
title('Variance coverage');
xlabel('Number of variables');
ylabel('Coverage %');

% Select the number of PCs for coverage of >95%
for i = 1:length(perc)
   if(perc(i) > 95)
       break;
   end 
end

npc = i; % Number of PCs

disp(['Number of PCs (>0.95): ', num2str(npc)]);

Vk = eigvec(:,1:npc); % eigen vectors for PCs

sigma = lambda(1:npc, 1:npc); % eigenvalues for PCs


% Hotelling T2
T2lim = npc*(N-1)/(N-npc)*finv(0.95, npc, N-npc);

T2limits = zeros(npc,1); % Individual T2 limits

for i=1:npc
    T2limits(i) = sqrt(sigma(i,i))*tinv(0.98, N-1);
    
end

% SPE
zeta1 = 0;
zeta2 = 0;
zeta3 = 0;

for i = (npc+1):nvar
   zeta1 = zeta1 + lambda(i,i);
   zeta2 = zeta2 + lambda(i,i)^2;
   zeta3 = zeta3 + lambda(i,i)^3;
end

h0 = 1-(2*zeta1*zeta3)/(3*zeta2^2);
ca = norminv(0.95,0,1);
SPElim = zeta1*(ca*h0*sqrt(2*zeta2)/zeta1+1+zeta2*h0*(h0-1)/zeta1^2)^(1/h0);


%% New data

Xn = X; % Data
N2 = length(Xn); % Num of obs
nvar2 = size(Xn,2); % Num of var

% Scaling
XnScaled = Xn - ones(N2,1)*Xmean;
XnScaled = XnScaled./(ones(N2,1)*Xstd);

% Score
score = Vk'*XnScaled';

% Indexes
T2indexes = zeros(N2,1);
SPEindexes = zeros(N2,1);

for i=1:N2
    T2indexes(i) = XnScaled(i,:)*Vk*inv(sigma)*Vk'*XnScaled(i,:)';

    r = (eye(nvar)-Vk*Vk')*XnScaled(i,:)';
    SPEindexes(i) = r'*r;

end

% Limits as vectors for plotting
T2limPlot(1:N2) = T2lim;
SPElimPlot(1:N2) = SPElim;


% Plotting T2 indexes
figure;
plot(T2indexes);
hold on;
plot(T2limPlot,'r');
hold off;
grid;
title('T2 indexes');
xlabel('Samples');
ylabel('T2 index');

% Plotting SPE indexes
figure;
plot(SPEindexes);
hold on;
plot(SPElimPlot, 'r');
hold off;
grid;
title('SPE indexes');
xlabel('Samples');
ylabel('SPE index');




% Contribution plots
cont = zeros(npc,nvar,N2);

% cont = 
%               Variables (j)
%           [a11 a12 a13 a14 ... a1N]
% PCs (i)   [a21 a22 a23 a24 ... a2N]    * Observations (k)
%           [...                    ]
%           [aN1 aN2 aN3 aN4 ... aNN]

for k = 1:N2 % Observation
    for i=1:npc % Principal Component
        for j=1:nvar % Variable
            cont(i,j,k) = score(i,k)/sigma(i,i)*Vk(j,i)*XnScaled(k,j);
        end
    end
end

contPlot = zeros(N2,nvar); % Contribution sums
for k = 1:N2
    if(T2indexes(k) > T2lim) % Check if observation is faulty
        for i=1:nvar
            for j=1:npc
                if(abs(score(j,k)) > T2limits(j)) % Check which variables are faulty
                    if(cont(j,i,k) > 0) % Only positive values
                        contPlot(k,i) = contPlot(k,i) + cont(j,i,k);
                    end
                end
            end
        end
    end
end


% Plotting contribution plots
titles = {'Contribution Var1', 'Contribution Var2', 'Contribution Var3', 'Contribution Var4' ,...
    'Contribution Var5', 'Contribution Var6', 'Contribution Var7', 'Contribution Var8',...
    'Contribution Var9','Contribution Var10', 'Contribution Var11'};
dim = sqrt(length(titles)); % Figure dimensions
figure;

for i = 1:length(titles)
   subplot(round(dim),ceil(dim),i);
   plot(contPlot(:,i));
   grid;
   title(titles{i});
   xlabel('Samples');
   ylabel('Contribution');
end

