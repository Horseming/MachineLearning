clc
clf
clear

%twoCircles���ݼ�
load('twoCircles.mat');
dataSetOri=twoCircles;
dataSet=dataSetOri/max(max(abs(dataSetOri)));
num_clusters=2;
sigma=0.1;

%XOR���ݼ�
% load('XOR.mat');
% dataSetOri=XOR;
% dataSet=dataSetOri/max(max(abs(dataSetOri)));
% num_clusters=4;
% sigma=0.1;


Z=pdist(dataSet);
W=squareform(Z);

C = spectral(W,sigma, num_clusters);

plot(dataSetOri(C==1,1),dataSetOri(C==1,2),'r.', dataSetOri(C==2,1),dataSetOri(C==2,2),'b.', dataSetOri(C==3,1),dataSetOri(C==3,2),'g.', dataSetOri(C==4,1),dataSetOri(C==4,2),'m.');