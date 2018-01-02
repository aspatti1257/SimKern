function radiationBoxplot(algs,expInfo,classificationBoolean)
myFontsize = 12;
for i_algs = 1:length(algs)
    nnResult(i_algs,:) = algs(i_algs).nn.perfMetric;
    linSvmResult(i_algs,:) = algs(i_algs).linSvm.perfMetric;
    rbfSvmResult(i_algs,:) = algs(i_algs).rbfSvm.perfMetric;
    rfResult(i_algs,:) = algs(i_algs).rf.perfMetric;
    skSvmResult(i_algs,:) = algs(i_algs).skSvm.perfMetric;
    skRfResult(i_algs,:) = algs(i_algs).skRf.perfMetric;
    skNnResult(i_algs,:) = algs(i_algs).skNn.perfMetric;
end

numeroSubsamples = numel(expInfo(1).numeroTrainSamples);

numeroTrainSamples = expInfo(1).numeroTrainSamples;
numeroValidationSamples = expInfo(1).numeroValidationSamples(1);
numeroTestSamples = expInfo(1).numeroTestSamples(1);

% error check
if numel(unique(expInfo(1).numeroValidationSamples)) ~= 1 || numel(unique(expInfo(1).numeroTestSamples)) ~= 1 ...
        || any(expInfo(1).numeroTrainSamples ~= expInfo(2).numeroTrainSamples)
    error('Data splitting wrong.')
end
% colors
myBlue = [55 126 184] ./255;
myRed  = [228 26 28] ./255;
myGreen = [77 175 74] ./255;
myDarkGrey = [100 100 100] ./255;
myLightGrey = [150 150 150] ./255;
myGrey = [125 125 125] ./255;

%% boxplot figure radiation
% compute equal spacing between algorithm bars within a subsampling
% iteration
x = linspace(0,1,8);

% create labels for algorithms in boxplot
nnLabels = cell(1,numeroSubsamples);
nnLabels(:) = {'NN'};
linSvmLabels = cell(1,numeroSubsamples);
linSvmLabels(:) = {'lin. SVM'};
rbfSvmLabels = cell(1,numeroSubsamples);
rbfSvmLabels(:) = {'RBF SVM'};
rfLabels = cell(1,numeroSubsamples);
rfLabels(:) = {'RF'};
skSvmLabels = cell(1,numeroSubsamples);
skSvmLabels(:) = {'simkern SVM'};
skRfLabels = cell(1,numeroSubsamples);
skRfLabels(:) = {'simkern RF'};
skNnLabels = cell(1,numeroSubsamples);
skNnLabels(:) = {'simkern NN'};

plotLabels = [linSvmLabels rbfSvmLabels rfLabels skSvmLabels skRfLabels skNnLabels];

figure('Units','inches',...
    'Position',[0 0 8 4],...
    'PaperPositionMode','auto')
hold on
grid on
% set(gca,'FontSize',20)
fh = boxplot([linSvmResult rbfSvmResult rfResult skSvmResult skRfResult skNnResult],...
    'FactorSeparator',1,...
    'position',...
    [1:numeroSubsamples ...
    x(2)+(1:numeroSubsamples)...
    x(3)+(1:numeroSubsamples) ...
    x(4)+(1:numeroSubsamples) ...
    x(5)+(1:numeroSubsamples),...
    x(6)+(1:numeroSubsamples)],...
    'labels',...
    plotLabels,...
    'LabelOrientation',...
    'inline',...
    'BoxStyle',...
    'filled',...
    'Colors',...
    [myRed;myRed;myRed;...
    myGreen;myGreen;myGrey]);

% Find all text boxes and set font size and interpreter (LATEX doesnt work
% with LabelOrientation inline because matlab uses text() to create xticks in boxplot)
set(findobj(gca,'Type','text'),'FontSize',2/3 * myFontsize)
set(findobj(gca,'Type','text'),'Interpreter','latex')

% move all xtick labels (which are text boxes) down by a bit (because latex
% font is longer)
textObj = findobj(gca,'Type','text');
for i_text = 1:length(textObj)
    textObj(i_text).Position(2) = -5;%textObj(i_text).Position(2) + 40;
    textObj(i_text).HorizontalAlignment = 'right';
end


set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

% use latex font for yticklabels
set(gca,'TickLabelInterpreter','latex')

% set the box size ('Widths' doesn't work with 'Boxstyle' 'filled')
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
boxInd = strcmpi(myHandles2,'box');
box = myHandles(boxInd);
set(box,'linewidth',4);
% set median and whisker size
medianInd = strcmpi(myHandles2,'Median');
medianLines = myHandles(medianInd);
set(medianLines,'linewidth',1);
whiskerInd = strcmpi(myHandles2,'Whisker');
whiskerLines = myHandles(whiskerInd);
set(whiskerLines,'linewidth',1);

% set outlier color
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
outlierInd = strcmpi(myHandles2,'Outliers');
outlierColors = [myGrey;myGreen;myGreen;myRed;myRed;myRed];
for i_algo = 1:6 % the number of algorithms per subsample
    [myHandles((31 - 1) + i_algo:6:60).MarkerEdgeColor] = deal(outlierColors(i_algo,:));
    
end


curYLim = ylim;
vertPos = 1.01 * curYLim(2);
text(1,vertPos,['Trained on ' num2str(numeroTrainSamples(1)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')
text(1.9,vertPos,['Trained on ' num2str(numeroTrainSamples(2)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')
text(2.9,vertPos,['Trained on ' num2str(numeroTrainSamples(3)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')
text(3.9,vertPos,['Trained on ' num2str(numeroTrainSamples(4)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')
text(4.9,vertPos,['Trained on ' num2str(numeroTrainSamples(5)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')

if classificationBoolean
    ylabel('Accuracy',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
else
    ylabel('$R^{2}$',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
end

curYLim = ylim;
for i_subsamples = 1:(numeroSubsamples - 1)
    %     line([(i_subsamples + 0.8395) (i_subsamples + 0.8395)],[curYLim(1) curYLim(2)],'Color','k')
    % finds the exact middle between the last box of one subsample group
    % and the first box of the next subsample group and
    % plots a black line between those
    midBetweenBoxes = 0.5 * ((i_subsamples + x(6) + (i_subsamples + 1) ));
    line([midBetweenBoxes midBetweenBoxes],[curYLim(1) curYLim(2)],'Color','k')
end
% add model name
% curYLim = ylim;
% vertPosTitle = 0.99 * curYLim(2);
% text(1.0,vertPosTitle,'Cell irradiation model','Color','k','FontSize',14,'FontWeight','bold')
end