% fraud analysis using ggerman credit data
% description: http://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29

% load data
import('numeric.mat')
numeric= zscore(numeric);
% separate training and testing

train=numeric(1:500,1:20);
trainO=numeric(1:500,21);

test=numeric(501:end,1:20);
testO=numeric(501:end,21);

% classify with SVM without feature selection

svmodel= fitcsvm(train,trainO);
[label,score] = predict(svmodel,test);
ScoreSVMModel = fitPosterior(svmodel,test,testO);

% miss classification
cvmd1 = crossval(svmodel);
misclass1 = kfoldLoss(cvmd1);

cvmd2 = crossval(ScoreSVMModel);
misclass2 = kfoldLoss(cvmd2);


% Prediction with Feature selection

dataTrainG1 = train(grp2idx(trainO)==1,:);
dataTrainG2 = train(grp2idx(trainO)==2,:);

[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');
ecdf(p);
xlabel('P value');
ylabel('CDF value')

ftrain=[train(:,2),train(:,11),train(:,15:19)];
ftest =[test(:,2),test(:,11),test(:,15:19)];
svmodel= fitcsvm(ftrain,trainO);
[label,score] = predict(svmodel,ftest);
ScoreSVMModel = fitPosterior(svmodel,ftest,testO);
cvmd3 = crossval(svmodel);
misclass3 = kfoldLoss(cvmd3);
