clear
clc

% NOTES:
% - linear svm training takes much longer than rbf svm??
% - rbf svm regression predicts same value
% - categorical variables need to be >0 for dummy coding
% - number of trees set to 50 (to make debugging faster)
% - search fewer hyperparameter values (to make debugging faster)
% load libsvm
addpath('')
%% read in data

%read full similarity matrix
f = '\Sim1SimilarityMatrixfinal.csv';
sm =  csvread(f);

%xfile needed for RF and normnal SVMs, but not used by custom kernel SVM
xfile = '\Sim0GenomesMatrix.csv';
x = csvread(xfile);

%collapse the MUT vars into 1 [if MUT.knockdown, which is x(:,1),
%is 0, then there is no mutation, so just multiple this with the
%discrete 19 mutation types]
x = horzcat(x(:,1).*x(:,2),x(:,3:end));
unstandardizedFeatures = x;
unstandardizedFeatures(:,1) = 1 + unstandardizedFeatures(:,1);

yfile = '\Sim0Output.csv';
y=csvread(yfile);
y=y';
classes = (y>= median(y)) + 0; % if you want to turn the case into a classification
% classes = y; % regression

%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.2 0.4 0.6 0.8 1];
categoricalIndices = logical([1 zeros(1,size(unstandardizedFeatures,2) - 1)]);
classificationBoolean = true;
%%
for i_reps = 1:10
[linSvm(i_reps),rbfSvm(i_reps),rf(i_reps),ckSvm(i_reps)] = runExperiment(unstandardizedFeatures,...
    classes,sm,splitRatios,classificationBoolean,subsamplingRatios,...
    categoricalIndices);
end
%% plotting for a single run
% clf
% hold on
% % plot(subsamplingRatios,linSvm.accuracy,'k-*')
% plot(subsamplingRatios,rbfSvm.accuracy,'b-*')
% plot(subsamplingRatios,rf.accuracy,'g-*')
% plot(subsamplingRatios,ckSvm.accuracy,'r-*')
% xlabel('Subsampling ratio')
% if classificationBoolean
%     ylabel('Accuracy')
% else
%     ylabel('R^2')
% end
% legend('lin SVM','rbf SVM','rf','ck SVM')

%% plotting
rbfResult = cat(1,rbfSvm(:).accuracy);
rfResult = cat(1,rf(:).accuracy);
ckResult = cat(1,ckSvm(:).accuracy);
linResult = cat(1,linSvm(:).accuracy);

clf
hold on
boxplot([linResult rbfResult rfResult ckResult],'position', [0.75 1.75 2.75 3.75 4.75 1 2 3 4 5 1.25 2.25 3.25 4.25 5.25 1.5 2.5 3.5 4.5 5.5],...
    'labels',{'lin' 'lin' 'lin' 'lin' 'lin' 'rbf' 'rbf' 'rbf' 'rbf' 'rbf' 'rf' 'rf' 'rf' 'rf' 'rf' 'ck' 'ck' 'ck' 'ck' 'ck'})
xlabel('Subsampling ratio')
if classificationBoolean
    ylabel('Accuracy')
else
    ylabel('R^2')
end
line([1.625 1.625],[-100 100],'Color','k')
line([2.625 2.625],[-100 100],'Color','k')
line([3.625 3.625],[-100 100],'Color','k')
line([4.625 4.625],[-100 100],'Color','k')

