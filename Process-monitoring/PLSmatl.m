%% PLS
% Simple example of PLS algorithm for monitoring quality measurements of a
% paper machine
%%

load PLSexample1.mat;
X=paper_making_data(1:300,1:9);% faultless data are used for model training
Y=paper_making_data(1:300,10:11);% the last two columns are the quality variables
Xt=paper_making_data(:,1:9);% testing data is the whole data set
Yt=paper_making_data(:,10:11);% testing data is the whole data set


% Scaling
[ax,MU,SIGMA]=zscore(X);
[ay,MUy,SIGMAy]=zscore(Y);

Ax=zscore(Xt); %scale the testing data
[Xl,Yl,XS,YS,BETA] = plsregress(ax,ay,5);
BETA=BETA(2:end,:); % delete intercep vector from BETA

ayp=Ax*BETA;% model predict

ayp=ayp*diag(SIGMAy)+ones(1100,1)*MUy;% scaled model prediction to the original value

% Ploting prediction
figure;
subplot(2,1,1);
plot(ayp(:,1));
title('Basic weight(g/m2)');
hold on;
plot(Yt(:,1), 'r');
legend('predicted value', 'measured value')
subplot(2,1,2);
plot(ayp(:,1)-Yt(:,1));
legend('residual')


figure;
subplot(2,1,1);
plot(ayp(:,2));
title('Moisture(%)');
hold on;
plot(Yt(:,2), 'r');
legend('predicted value', 'measured value')
subplot(2,1,2);
plot(ayp(:,2)-Yt(:,2));
legend('residual');
