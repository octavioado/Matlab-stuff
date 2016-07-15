% the example for the selection of number of latent variables with PRESS
% the data from paper making are used for the example
% the data has 11 columns and 1100 observations
% the first 300 observations and the last 400 observations are faultless
% the last two columns are quality variables and the rest are process variables
% copy right chenghui, email: chenghui@cc.hut.fi
load PLSexample1.mat;
X=paper_making_data(1:300,1:9);% faultless data are used for model training
Y=paper_making_data(1:300,10:11);% the last two columns are the quality variables
Xt=paper_making_data(:,1:9);% testing data is the whole data set
Yt=paper_making_data(:,10:11);% testing data is the whole data set

maxlatv=min(size(X));% the maximal possible number of latent variables
m=size(Y,2);% the number of variables in Y
n=size(X,1)/3;% the number of observations in one group, the total training data is divided into 3 groups
Press=zeros(3,maxlatv);% the Press matrix, the column index is the latent variables number, while the row index is the group number
for i=1:3% for each group
    trainX=[X(1:(i-1)*100,:);X(i*100+1:300,:)];% for each group get new training data and testing data
    trainY=[Y(1:(i-1)*100,:);Y(i*100+1:300,:)];
    testX=X((i-1)*100+1:i*100,:);
    testY=Y((i-1)*100+1:i*100,:);
    for j=1:maxlatv% loop for the possible latent variables number
        [ax,mx,stdx] = auto(trainX);
        [ay,my,stdy] = auto(trainY);% scale the training data
        tempB=nipals(ax,ay,j);% calculate the regress model B2
        ax1=autos(testX, mx,stdx);%scale the testing data with the mean and standard deviation
        ay1=autos(testY, my,stdy);%
        ayp=ax1*tempB;% prediction from the model
        Press(i,j)=norm(ay1-ayp, 'fro')^2/(m*n);% calculate the Press value for the i group and j number of latent variables
    end
end

for i=1:3% plot the press curve for each group
    plot(Press(i,:), '--*');
    hold on;
end
title('Press vs latent variable number for each group')
Press=sum(Press, 1);% sum up the press value for all the groups respective to the latent variables number
minindex=find(Press==min(Press));% find the minimal press value giving the optimal value of latent variables number
figure;
plot(Press, 'r');
title('Press cumulative sum vs latent variable number')

[ax,mx,stdx] = auto(X);
[ay,my,stdy] = auto(Y);
B=nipals(ax,ay,minindex);% with the optimal number of latent variable, build the model

ax=autos(Xt,mx,stdx);% scale the new data, Xt is the whole data set with faulty 
ayp=ax*B;% model predict
ayp=ayp*diag(stdy)+ones(1100,1)*my;% scaled the model predicted value back to the real scale for Y

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
