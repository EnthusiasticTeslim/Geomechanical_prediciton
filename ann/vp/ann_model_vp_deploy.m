function [y1] = ann_model_vp_deploy(x1)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 21-Aug-2019 21:33:38.
%
% [y1] = myNeuralNetworkFunction(x1) takes these arguments:
%   x = Qx6 matrix, input #1
% and returns:
%   y = Qx1 matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-1;-1;-1;-1;-1;-1];
x1_step1.gain = [1;1;1;1;1;1];
x1_step1.ymin = -1;

% Layer 1
b1 = [2.2041136641060812;-2.0004992366461747;2.2136400164882244;-1.4537646445531065;0.6484996717063749;0.72897364702139067;0.78933399329334986;-0.60457750112107178;3.2065999392952382;2.0060477459446751];
IW1_1 = [-3.6874431724039671 -1.5597589133735612 -2.7804918449665279 -0.61919900447562026 0.12682637762481244 0.15444502024029855;0.85482809879887944 -1.4463845327202598 0.24741289314157813 -0.65824442664888538 -0.21269687976384383 0.1914076133250279;-0.79476063240843131 1.8212868793603476 -0.25508547370153822 2.3097666923341973 -0.92393099012983781 -0.069288852327596948;2.2137987481772305 -0.98227026488643454 0.28854135546597071 -0.34229486692942812 0.021103040806723729 -0.1269706698492758;0.17244288616120221 -1.8377986993881277 -0.61566897440362656 -0.080863906143243403 -0.33893090420068112 -0.8491489229528757;-0.24314115400385852 2.1007641698749393 -2.2430089136256193 -1.2339883163372638 -1.265516146898523 0.10767056373006172;2.1018739270438735 -0.47170405809022109 -0.60279975528120233 1.4766720746233764 0.92521427775825982 -0.27523019933352505;0.6267760597151073 -0.28150339805389113 2.2471996903294813 0.66873832188372806 0.60284653201370286 -0.2802599232262204;0.3360741173751649 0.463560348971092 -0.86521401496901984 4.601481477935069 -2.146103888107278 0.66002527636162545;0.27677955908022955 0.1994023715739715 -1.4934116239847497 1.5795079590810066 -0.89502610957525452 0.57923125710402457];

% Layer 2
b2 = -0.61539843762954982;
LW2_1 = [-0.47309844106694854 -1.7203762503875581 -0.83960981999710771 1.1787457960520544 0.13564776528379638 -0.97060681750410527 -0.71794545340638738 -1.1559346562148716 -1.0436566894282413 1.8207643642758791];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.778423408842586;
y1_step1.xoffset = 2.62235054838787;

% ===== SIMULATION ========

% Dimensions
Q = size(x1,1); % samples

% Input 1
x1 = x1';
xp1 = mapminmax_apply(x1,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
y1 = mapminmax_reverse(a2,y1_step1);
y1 = y1';
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end