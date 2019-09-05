clc;
clear;
close all;

%% load Data

load 'model_vp_data';

%% Selection of FIS Generation Method

Option{1}='Grid Partitioning (genfis1)';
Option{2}='Subtractive Clustering (genfis2)';
Option{3}='FCM (genfis3)';

ANSWER=questdlg('Select FIS Generation Approach:',...
                'Select GENFIS',...
                Option{1},Option{2},Option{3},...
                Option{3});
pause(0.01);

%% Setting the Parameters of FIS Generation Methods

switch ANSWER
    case Option{1}
        Prompt={'Number of MFs','Input MF Type:','Output MF Type:'};
        Title='Enter genfis1 parameters';
        DefaultValues={'5', 'gaussmf', 'linear'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        pause(0.01);

        nMFs=str2num(PARAMS{1});	%#ok
        InputMF=PARAMS{2};
        OutputMF=PARAMS{3};
        
        fis=genfis1([TrainInputs TrainTargets],nMFs,InputMF,OutputMF);

    case Option{2}
        Prompt={'Influence Radius:'};
        Title='Enter genfis2 parameters';
        DefaultValues={'0.3'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        pause(0.01);

        Radius=str2num(PARAMS{1});	%#ok
        
        fis=genfis2(TrainInputs,TrainTargets,Radius);
        
    case Option{3}
        Prompt={'Number fo Clusters:',...
                'Partition Matrix Exponent:',...
                'Maximum Number of Iterations:',...
                'Minimum Improvemnet:'};
        Title='Enter genfis3 parameters';
        DefaultValues={'15', '2', '200', '1e-5'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        pause(0.01);

        nCluster=str2num(PARAMS{1});        %#ok
        Exponent=str2num(PARAMS{2});        %#ok
        MaxIt=str2num(PARAMS{3});           %#ok
        MinImprovment=str2num(PARAMS{4});	%#ok
        DisplayInfo=1;
        FCMOptions=[Exponent MaxIt MinImprovment DisplayInfo];
        
        fis=genfis3(TrainInputs,TrainTargets,'sugeno',nCluster,FCMOptions);
end

%% Training ANFIS Structure

Prompt={'Maximum Number of Epochs:',...
        'Error Goal:',...
        'Initial Step Size:',...
        'Step Size Decrease Rate:',...
        'Step Size Increase Rate:'};
Title='Enter genfis3 parameters';
DefaultValues={'1000', '0', '0.01', '0.9', '1.1'};

PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
pause(0.01);

MaxEpoch=str2num(PARAMS{1});                %#ok
ErrorGoal=str2num(PARAMS{2});               %#ok
InitialStepSize=str2num(PARAMS{3});         %#ok
StepSizeDecreaseRate=str2num(PARAMS{4});    %#ok
StepSizeIncreaseRate=str2num(PARAMS{5});    %#ok
TrainOptions=[MaxEpoch ...
              ErrorGoal ...
              InitialStepSize ...
              StepSizeDecreaseRate ...
              StepSizeIncreaseRate];

DisplayInfo=true;
DisplayError=true;
DisplayStepSize=true;
DisplayFinalResult=true;
DisplayOptions=[DisplayInfo ...
                DisplayError ...
                DisplayStepSize ...
                DisplayFinalResult];

OptimizationMethod=1;
% 0: Backpropagation
% 1: Hybrid
            
fis=anfis([TrainInputs TrainTargets],fis,TrainOptions,DisplayOptions,[],OptimizationMethod);


%% Apply ANFIS model to Data

TrainOutputs=evalfis(TrainInputs,fis);
TestOutputs=evalfis(TestInputs,fis);
ValidOutputs=evalfis(ValidInputs,fis);
AllOutputs=evalfis(AllInputs,fis);

%% Plot Results

figure;
axis tight
PlotResults(TrainTargets,TrainOutputs,'Train');

figure;
axis tight
PlotResults(TestTargets,TestOutputs,'Test');

figure;
axis tight
PlotResults(ValidTargets,ValidOutputs,'Validation');

figure;
axis tight
PlotResults(AllTargets,AllOutputs,'All');

if ~isempty(which('plotregression'))
    figure;
    plotregression(TrainTargets, TrainOutputs, 'Train', ...
                   TestTargets, TestOutputs, 'Test', ...
                   ValidTargets, ValidOutputs, 'Validation', ...
                   AllTargets, AllOutputs, 'All');
    set(gcf,'Toolbar','figure');
end

%% Additional validation
% Add_data_output=evalfis(Add_data_Input,fis);
% 
% if ~isempty(which('plotregression'))
%     figure;
%     plotregression(Add_data_Target, Add_data_output, 'Final');
%     set(gcf,'Toolbar','figure');
% end