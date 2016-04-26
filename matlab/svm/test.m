clear;%����
clc;
dataOri =load('data.txt');
n = length(dataOri);%����������
dataSet = dataOri(:,1:3);
% dataSet=dataSet/(max(max(abs(dataSet)))-min(min(abs(dataSet))));
labels = dataOri(:,4);%����־
labels(labels==0) = -1;

% load('Flame.mat');
% dataSet = Flame;
% n = length(dataSet);%����������
% labels = dataOri(:,4);%����־
% labels(labels==0) = -1;

sigma=1;        %��˹�˺���
TOL = 0.0001;   %����Ҫ��
C = 1;          %����������ʧ������Ȩ��
b = 0;          %��ʼ���ýؾ�b
bold=0;
bnew=0;
Wold = 0;       %δ����aʱ��W(a)
Wnew = 0;       %����a���W(a)

a = ones(n,1)*0.2;  %����a�������ʼ��a,a����[0,C]

%��˹�˺�����������
% K=dataSet;
K=pdist(dataSet);
K=squareform(K);
K = -K.^2/(2*sigma*sigma);
K=exp(K);
% K = full(spfun(@exp, K));
% for i=1:n
%     K(i,i)=1;
% end

sum=(a.*labels)'*K;

while 1
    %����ʽѡ�㣬n1,n2����ѡ���2����
    n1 = 1;
    n2 = 2;
    %n1����һ��Υ��KKT�����ĵ�ѡ��
    while n1 <= n
        if labels(n1) * (sum(n1) + b) == 1 && a(n1) >= C && a(n1) <=  0
            break;
        end
        if labels(n1) * (sum(n1) + b) > 1 && a(n1) ~=  0
            break;
        end
        if labels(n1) * (sum(n1) + b) < 1 && a(n1) ~=C
            break;
        end
        n1 = n1 + 1;
    end
    
    %n2�������|E1-E2|��ԭ��ѡȡ
    E2 = 0;
    maxDiff = 0;%�����������
    E1 = sum(n1) + b - labels(n1);%n1�����
    for i = 1 : n
        tempW = sum(i) + b - labels(i);
        if abs(E1 - tempW)> maxDiff
            maxDiff = abs(E1 - tempW);
            n2 = i;
            E2 = tempW;
        end
    end
    
    %���½��и���
    a1old = a(n1);
    a2old = a(n2);
    KK = K(n1,n1) + K(n2,n2) - 2*K(n1,n2);
    a2new = a2old + labels(n2) *(E1 - E2) / KK;
    
    yy=labels(n1) * labels(n2);
    if yy==-1
        L=max(0,a2old - a1old);
        H=min(C,C + a2old - a1old );
    else
        L=max(0,a1old + a2old - C);
        H=min(C,a1old + a2old);
    end
    
    a2new=min(a2new,H);
    a2new=max(a2new,L);
    a1new = a1old + yy * (a2old - a2new);
    
    %����a
    a(n1) = a1new;
    a(n2) = a2new;
    
    %����Ei��b
    sum=(a.*labels)'*K;
    
    Wold = Wnew;
    Wnew = 0;%����a���W(a)
    tempW=0;
    for i = 1 : n
        for j = 1 : n
            tempW= tempW + labels(i )*labels(j)*a(i)*a(j)*K(i,j);
        end
        Wnew= Wnew+ a(i);
    end
    Wnew= Wnew - tempW/2;
    
    %���¸���b��ͨ���ҵ�ĳһ��֧������������
    bold=b;
    if a1new>=0 && a1new<=C
        b=(a1old-a1new)*labels(n1)*K(n1,n1)+(a2old-a2new)*labels(n2)*K(n2,n1)-E1+bold;
    elseif a2new>=0 && a2new<=C
        b=(a1old-a1new)*labels(n1)*K(n1,n2)+(a2old-a2new)*labels(n2)*K(n2,n2)-E2+bold;
    else      % (a1new<0||a1new>C)&&(a2new<0||a2new>C)
        b1=(a1old-a1new)*labels(n1)*K(n1,n1)+(a2old-a2new)*labels(n2)*K(n2,n1)-E1+bold;
        b2=(a1old-a1new)*labels(n1)*K(n1,n2)+(a2old-a2new)*labels(n2)*K(n2,n2)-E2+bold;
        b=(b1+b2)/2;
    end
    
    %�ж�ֹͣ����
    if abs(Wnew/ Wold - 1 ) <= TOL
        break;
    end
end

for i = 1 : n
    if sum(i) + b  < 0
        fprintf('-1\n');
    else 
        fprintf('1\n');
    end
end
%������������ԭ���࣬�������������svm������
% for i = 1 : n
%     fprintf('��%d��:ԭ��� ',i);
%     if i <= 50
%         fprintf('-1');
%     else
%         fprintf(' 1');
%     end
%     fprintf('    �б���ֵ%f      ������',sum(i) + b);
%     if sum(i) + b  < 0
%         fprintf('-1\n');
%     else 
%         fprintf('1\n');
%     end
% end

% result=zeros(n,1);
% %������������ԭ���࣬�������������svm������
% for i = 1 : n
%     if abs(sum(i) + b - 1) < 0.5
%         result(i)=2;
%     else
%         result(i)=1;
%     end
% end

% labels(labels==-1)=2;
% result(result==-1)=2;

% score=nmi(labels,result);