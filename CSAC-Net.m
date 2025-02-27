clear
close all
clc



n = 3;
for ii = 10:10
reset(gpuDevice())
c_matrix = [];
Accuracy = [];
Results=[];
                                                                                                                                                                                                                                                                    

d = 'D:\Paper_2_ECGCrossDataValid\Apnea_ECG_dataset\gradcam\fold_1_1D_vs_2D\finalExperiments';
% d2 = 'D:\Paper_2_ECGCrossDataValid\Apnea_ECG_dataset\normal_and_sifted_scal\normal_scal\fold_1';
fold_num = strcat(d, '\fold_', num2str(ii));

imdsTrain = imageDatastore(strcat(fold_num,'\training'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imdsValidation = imageDatastore(strcat(fold_num, '\testing'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%% taking 1/4th of training data randomly
[quarterSet,excludeData] = splitEachLabel(imdsTrain,0.25, 0.75,...
        'randomized');

[trainingSet,validationSet] = splitEachLabel(quarterSet,0.8, 0.2,...
        'randomized');
%% Layers
lgraph = layerGraph();
tempLayers = [
    imageInputLayer([299 299 3],"Name","imageinput")
    convolution2dLayer([7 7],32,"Name","conv_12")
    reluLayer("Name","relu_12")
    batchNormalizationLayer("Name","batchnorm_7")
    convolution2dLayer([5 5],64,"Name","conv_1","Stride",[2 2])
    reluLayer("Name","relu_1")
    batchNormalizationLayer("Name","batchnorm_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    globalAveragePooling2dLayer("Name","gapool_3")
    fullyConnectedLayer(128,"Name","fc_5")
    fullyConnectedLayer(256,"Name","fc_6")
    sigmoidLayer("Name","sigmoid_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],64,"Name","conv_16","Stride",[2 2])
    reluLayer("Name","relu_16_1")
    batchNormalizationLayer("Name","batchnorm_11_1")
    convolution2dLayer([9 9],32,"Name","9x9")
    reluLayer("Name","relu_16_2")
    batchNormalizationLayer("Name","batchnorm_11_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([7 7],32,"Name","7x7_1","Padding","same")
    reluLayer("Name","relu_16_3")
    batchNormalizationLayer("Name","batchnorm_11_3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([7 7],32,"Name","7x7_2","Padding","same")
    reluLayer("Name","relu_16_4")
    batchNormalizationLayer("Name","batchnorm_11_4")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([5 5],32,"Name","5x5_1_1","Padding","same")
    reluLayer("Name","relu_16_5")
    batchNormalizationLayer("Name","batchnorm_11_5")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([5 5],32,"Name","5x5_1_3","Padding","same")
    reluLayer("Name","relu_16_7")
    batchNormalizationLayer("Name","batchnorm_11_7")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_6","Padding","same")
    reluLayer("Name","relu_16_14")
    batchNormalizationLayer("Name","batchnorm_11_14")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_5","Padding","same")
    reluLayer("Name","relu_16_13")
    batchNormalizationLayer("Name","batchnorm_11_13")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([5 5],32,"Name","5x5_1_4","Padding","same")
    reluLayer("Name","relu_16_8")
    batchNormalizationLayer("Name","batchnorm_11_8")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_8","Padding","same")
    reluLayer("Name","relu_16_16")
    batchNormalizationLayer("Name","batchnorm_11_16")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_7","Padding","same")
    reluLayer("Name","relu_16_15")
    batchNormalizationLayer("Name","batchnorm_11_15")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([5 5],32,"Name","5x5_1_2","Padding","same")
    reluLayer("Name","relu_16_6")
    batchNormalizationLayer("Name","batchnorm_11_6")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_3","Padding","same")
    reluLayer("Name","relu_16_11")
    batchNormalizationLayer("Name","batchnorm_11_11")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_1","Padding","same")
    reluLayer("Name","relu_16_9")
    batchNormalizationLayer("Name","batchnorm_11_9")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_2","Padding","same")
    reluLayer("Name","relu_16_10")
    batchNormalizationLayer("Name","batchnorm_4")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_4");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_5");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_6_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],32,"Name","3x3_1_4","Padding","same")
    reluLayer("Name","relu_16_12")
    batchNormalizationLayer("Name","batchnorm_11_12")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_3");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_3");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_4");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = additionLayer(2,"Name","addition_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_8_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_7_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = depthConcatenationLayer(8,"Name","depthcat_2");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    globalAveragePooling2dLayer("Name","gapool")
    fullyConnectedLayer(512,"Name","fc_3")
    fullyConnectedLayer(1024,"Name","fc_4")
    sigmoidLayer("Name","sigmoid")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    multiplicationLayer(2,"Name","multiplication_2_1_2")
    convolution2dLayer([3 3],512,"Name","conv_4","Padding","same")
    reluLayer("Name","relu_4")
    batchNormalizationLayer("Name","batchnorm_5")
    convolution2dLayer([3 3],256,"Name","conv_5","Padding","same")
    reluLayer("Name","relu_5")
    batchNormalizationLayer("Name","batchnorm_6")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],128,"Name","conv_2","Padding","same")
    reluLayer("Name","relu_2")
    batchNormalizationLayer("Name","batchnorm_2")
    convolution2dLayer([3 3],1,"Name","conv_3","Padding","same")
    reluLayer("Name","relu_3")
    batchNormalizationLayer("Name","batchnorm_3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],128,"Name","conv_21","Padding","same","Stride",[2 2])
    reluLayer("Name","relu_22")
    batchNormalizationLayer("Name","batchnorm_18")
    convolution2dLayer([3 3],128,"Name","conv_22","Padding","same","Stride",[2 2])
    reluLayer("Name","relu_23")
    batchNormalizationLayer("Name","batchnorm_19")
    globalAveragePooling2dLayer("Name","gapool_8")
    fullyConnectedLayer(256,"Name","fc_12_3")
    sigmoidLayer("Name","sigmoid_5_3")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    globalAveragePooling2dLayer("Name","gapool_6")
    fullyConnectedLayer(128,"Name","fc_11")
    fullyConnectedLayer(256,"Name","fc_12_1")
    sigmoidLayer("Name","sigmoid_5_1")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    convolution2dLayer([3 3],128,"Name","conv_20","Padding","same","Stride",[2 2])
    reluLayer("Name","relu_21")
    batchNormalizationLayer("Name","batchnorm_17")
    globalAveragePooling2dLayer("Name","gapool_7")
    fullyConnectedLayer(256,"Name","fc_12_2")
    sigmoidLayer("Name","sigmoid_5_2")];
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_7_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_9");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_6_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = multiplicationLayer(2,"Name","multiplication_8_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = depthConcatenationLayer(4,"Name","depthcat_1");
lgraph = addLayers(lgraph,tempLayers);

tempLayers = [
    multiplicationLayer(2,"Name","multiplication_10")
    convolution2dLayer([3 3],512,"Name","conv_6","Padding","same")
    reluLayer("Name","relu_6")
    batchNormalizationLayer("Name","batchnorm_8")
    convolution2dLayer([3 3],256,"Name","conv_28_1","Padding","same","Stride",[2 2])
    reluLayer("Name","relu_28_1")
    batchNormalizationLayer("Name","batchnorm_23_1")
    globalAveragePooling2dLayer("Name","gapool_1")
    fullyConnectedLayer(128,"Name","fc_1")
    dropoutLayer(0.5,"Name","dropout_2")
    fullyConnectedLayer(2,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
lgraph = addLayers(lgraph,tempLayers);

% clean up helper variable
clear tempLayers;

%% Connections
lgraph = connectLayers(lgraph,"batchnorm_1","gapool_3");
lgraph = connectLayers(lgraph,"batchnorm_1","conv_16");
lgraph = connectLayers(lgraph,"sigmoid_2","multiplication_2_1_2/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_2","7x7_1");
lgraph = connectLayers(lgraph,"batchnorm_11_2","7x7_2");
lgraph = connectLayers(lgraph,"batchnorm_11_4","5x5_1_1");
lgraph = connectLayers(lgraph,"batchnorm_11_4","5x5_1_3");
lgraph = connectLayers(lgraph,"batchnorm_11_4","multiplication_2/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_4","multiplication_6_2/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_7","3x3_1_6");
lgraph = connectLayers(lgraph,"batchnorm_11_7","3x3_1_5");
lgraph = connectLayers(lgraph,"batchnorm_11_7","multiplication_1/in1");
lgraph = connectLayers(lgraph,"batchnorm_11_14","addition_2/in1");
lgraph = connectLayers(lgraph,"batchnorm_11_13","addition_2/in2");
lgraph = connectLayers(lgraph,"addition_2","multiplication_1/in2");
lgraph = connectLayers(lgraph,"addition_2","multiplication_2/in1");
lgraph = connectLayers(lgraph,"multiplication_1","depthcat_2/in6");
lgraph = connectLayers(lgraph,"multiplication_2","depthcat_2/in7");
lgraph = connectLayers(lgraph,"batchnorm_11_3","5x5_1_4");
lgraph = connectLayers(lgraph,"batchnorm_11_3","5x5_1_2");
lgraph = connectLayers(lgraph,"batchnorm_11_3","multiplication_4/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_3","multiplication_8_2/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_8","3x3_1_8");
lgraph = connectLayers(lgraph,"batchnorm_11_8","3x3_1_7");
lgraph = connectLayers(lgraph,"batchnorm_11_8","multiplication_7_2/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_16","addition_1/in1");
lgraph = connectLayers(lgraph,"batchnorm_11_6","3x3_1_3");
lgraph = connectLayers(lgraph,"batchnorm_11_6","3x3_1_4");
lgraph = connectLayers(lgraph,"batchnorm_11_6","multiplication_3/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_5","3x3_1_1");
lgraph = connectLayers(lgraph,"batchnorm_11_5","3x3_1_2");
lgraph = connectLayers(lgraph,"batchnorm_11_5","multiplication_5/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_9","addition_4/in2");
lgraph = connectLayers(lgraph,"batchnorm_4","addition_4/in1");
lgraph = connectLayers(lgraph,"addition_4","multiplication_5/in1");
lgraph = connectLayers(lgraph,"addition_4","multiplication_6_2/in1");
lgraph = connectLayers(lgraph,"multiplication_5","depthcat_2/in3");
lgraph = connectLayers(lgraph,"multiplication_6_2","depthcat_2/in8");
lgraph = connectLayers(lgraph,"batchnorm_11_12","addition_3/in2");
lgraph = connectLayers(lgraph,"batchnorm_11_11","addition_3/in1");
lgraph = connectLayers(lgraph,"addition_3","multiplication_3/in1");
lgraph = connectLayers(lgraph,"addition_3","multiplication_4/in1");
lgraph = connectLayers(lgraph,"multiplication_3","depthcat_2/in4");
lgraph = connectLayers(lgraph,"multiplication_4","depthcat_2/in5");
lgraph = connectLayers(lgraph,"batchnorm_11_15","addition_1/in2");
lgraph = connectLayers(lgraph,"addition_1","multiplication_8_2/in1");
lgraph = connectLayers(lgraph,"addition_1","multiplication_7_2/in1");
lgraph = connectLayers(lgraph,"multiplication_8_2","depthcat_2/in2");
lgraph = connectLayers(lgraph,"multiplication_7_2","depthcat_2/in1");
lgraph = connectLayers(lgraph,"depthcat_2","gapool");
lgraph = connectLayers(lgraph,"depthcat_2","multiplication_2_1_2/in1");
lgraph = connectLayers(lgraph,"sigmoid","multiplication_10/in2");
lgraph = connectLayers(lgraph,"batchnorm_6","conv_2");
lgraph = connectLayers(lgraph,"batchnorm_6","conv_21");
lgraph = connectLayers(lgraph,"batchnorm_6","gapool_6");
lgraph = connectLayers(lgraph,"batchnorm_6","conv_20");
lgraph = connectLayers(lgraph,"batchnorm_6","multiplication_7_1/in1");
lgraph = connectLayers(lgraph,"batchnorm_6","multiplication_9/in2");
lgraph = connectLayers(lgraph,"batchnorm_6","multiplication_6_1/in1");
lgraph = connectLayers(lgraph,"batchnorm_6","multiplication_8_1/in2");
lgraph = connectLayers(lgraph,"batchnorm_3","multiplication_9/in1");
lgraph = connectLayers(lgraph,"sigmoid_5_2","multiplication_7_1/in2");
lgraph = connectLayers(lgraph,"multiplication_7_1","depthcat_1/in3");
lgraph = connectLayers(lgraph,"multiplication_9","depthcat_1/in1"); 
lgraph = connectLayers(lgraph,"sigmoid_5_1","multiplication_6_1/in2");
lgraph = connectLayers(lgraph,"multiplication_6_1","depthcat_1/in2");
lgraph = connectLayers(lgraph,"sigmoid_5_3","multiplication_8_1/in1");
lgraph = connectLayers(lgraph,"multiplication_8_1","depthcat_1/in4");
lgraph = connectLayers(lgraph,"depthcat_1","multiplication_10/in1");

%% options
                options = trainingOptions('adam',...
                'InitialLearnRate',0.0001, 'MiniBatchSize',20,...
                'MaxEpochs', 50,...
                'Shuffle','every-epoch', ...
                'ValidationData', validationSet, ...
                'ValidationFrequency', 240, ...
                'ValidationPatience',Inf, ...
                'OutputNetwork', 'best-validation-loss', ...
                'Plots','training-progress');
                
%             % data augmentation
%                 imageAugmenter = imageDataAugmenter( ...
%                 'RandRotation',[-8 8], ...
%                 'RandXShear',[-5 5], ...
%                 'RandXTranslation',[-30 30], ...
%                 'RandYTranslation',[-10 10], ... 
%                 'RandXReflection', 1);
            
            
            %% results
%             imdsTrain_Aug = augmentedImageDatastore([299,299,3], imdsTrain,'DataAugmentation',imageAugmenter);
            [net,info] = trainNetwork(trainingSet,lgraph,options);
            
            %% save network/info
            save(strcat('E50Net', num2str(ii)), 'net')
            save(strcat('E50Info', num2str(ii)), 'info')

            [pred,probs] = classify(net,imdsValidation);
            [c_matrix,Result]= confusionmat(imdsValidation.Labels,pred);

            Accuracy = mean(pred == imdsValidation.Labels)*100;

            CMat = c_matrix; 
            tp=CMat(1,1);
            fp=CMat(2,1);
            fn=CMat(1,2);
            tn=CMat(2,2);

            Precision = tp./(tp+fp);
            Reccall = tp./(tp+fn);
            F1_Score = (2*Precision*Reccall)./(Precision+Reccall);
            Specificity = tn./(tn+fp);
end
