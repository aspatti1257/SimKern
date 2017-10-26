function [accuracy] = predictTestDataWithSvmClassification(testData,bestModel)

% predict test data
[predictions] = svmpredict(zeros(size(testData.classes,1),size(testData.classes,2)),testData.dummycodedFeatures,bestModel,'-q');

%compute performance metric
[accuracy] = computeAccuracy(testData.classes,predictions);

end