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

% classify with SVM

svmodel= fitcsvm(train,trainO);
[label,score] = predict(svmodel,test);
ScoreSVMModel = fitPosterior(svmodel,test,testO);

% miss classification
cvmd1 = crossval(svmodel);
misclass1 = kfoldLoss(cvmd1);

cvmd2 = crossval(ScoreSVMModel);
misclass2 = kfoldLoss(cvmd2);


