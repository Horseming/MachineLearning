function C = spectral(W,sigma, num_clusters)
% SC Spectral clustering using a sparse similarity matrix (t-nearest-neighbor).
% ʹ��Normalized���Ʊ任
% ����  : W              : N-by-N ����, �����Ӿ���
%            sigma          : ��˹�˺���,sigmaֵ
%            num_clusters   : ������
%
% ���  : C : N-by-1���� ����������ǩֵ
%
    format long
    m = size(W, 1);

    %�������ƶȾ���  ���ƶȾ�����Ȩֵ����õ���ʵ����һ���ø�˹�˺���
	W = W.*W;   %ƽ��
	W = -W/(2*sigma*sigma);
    S = full(spfun(@exp, W)); % ������S��Ϊ���ƶȾ���Ҳ�����ⲻ�����ڽӾ�����㣬���ǲ������ƶȾ���
    
    %��öȾ���D
    D = full(sparse(1:m, 1:m, sum(S))); %���Դ˴�DΪ���ƶȾ���S��һ��Ԫ�ؼ������ŵ��Խ����ϣ��õ��Ⱦ���D
    
    % ���������˹���� Do laplacian, L = D^(-1/2) * S * D^(-1/2)
    L = eye(m)-(D^(-1/2) * S * D^(-1/2)); %������˹����
    
    % ���������� V
    %  eigs 'SM';����ֵ��С����ֵ
    [V, ~] = eigs(L, num_clusters, 'SM');

    % ������������k-means
    C=kmeans(V,num_clusters);
end