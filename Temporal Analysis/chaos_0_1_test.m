function kmedian = chaos_0_1_test(x,fs_frac)

% Z1TEST  Gottwald-Melbourne 0-1 test for chaos
%
% Input: x       - time series vector
%        fs_frac - sampling frequency
%
% Z1TEST(X) is the result of the 0-1 test applied to the vector X.
% Result is near to 0 for non-chaotic data and near 1 for chaotic data.
% see  http://arxiv.org/pdf/0906.1418v1.  Paul Matthews, July 2009.
% https://in.mathworks.com/matlabcentral/fileexchange/25050-0-1-test-for-chaos

% Refer to https://asmedigitalcollection.asme.org/gasturbinespower/article/143/12/121022/1115684/Dynamical-Characterization-of-Thermoacoustic
% Equations referenced w.r.t. the above JEGTP Paper

x = x(1:fs_frac:end);
s=size(x);

if s(2)==1
    x=x';
end

N=length(x);
j=1:N;
t=1:round(N/10);
M=zeros(1,round(N/10));
c=pi/5+rand(1,100)*3*pi/5;  % 100 random c values in [pi/5,4pi/5]

for its=1:100
    p=cumsum(x.*cos(j*c(its))); % eqn 1 in the JEGTP paper
    q=cumsum(x.*sin(j*c(its))); % eqn 1 in the JEGTP paper
    
    for n=1:round(N/10)
        M(n)=mean( (p(n+1:N)-p(1:N-n)).^2 + (q(n+1:N)-q(1:N-n)).^2 )- ...
            mean(x)^2*(1-cos(n*c(its)))/(1-cos(c(its))); % eqn 2 in the JEGTP paper
    end
    kcorr(its)=corr(t',M');
end

%  plot(c,kcorr,'*');xlabel('c');ylabel('k'); % useful diagnostic plots
%  plot(t,M);xlabel('t');ylabel('M')
% Two crude attempts to check for oversampling:

if (max(x)-min(x) )/mean(abs(diff(x))) > 10 || ...
        median(kcorr(c<mean(c))) - median(kcorr(c>mean(c))) > 0.5
    disp('Warning: data is probably oversampled.')
    disp('Use coarser sampling or reduce the maximum value of c.')
end

kmedian=median(kcorr);