close all
clear,clc
% ???? ???
arr = [61 60 64 63 65 67 70 68 74 77 76 80 86 90 92]';
[m,nn]=size(arr);
N = 5; % ??
Yd1 = diff(arr);
yd1_h_adf = adftest(Yd1);
yd1_h_kpss = kpsstest(Yd1);
% 1? ??
s1 = zeros(m,1);
for i=N:m
s1(i) = sum(arr(i-N+1:i,:))/N;
end
sx1 = s1;

% 2? ??
s2 = zeros(m,1);
for i=2*N-1:m
s2(i) = sum(s1(i-N+1:i,:))/N;
end
sx2 = s2;
% ????????????
% a = 2*m1 - m2
% b = 2/(N-1)*(m1 - m2)
a = 2*s1 - s2;
b = 2/(N-1)*(s1 - s2);
a(1:2*N-2) = 0;
b(1:2*N-2) = 0;

% ??
% fx(t) = a(t) + b(t)*tou % fx(t+tou) = a(t) + b(t)*tou
% tou?????????fx(t)???t+tou????? % fx(t+tou)???t+tou?????
tou1 = 1; % ????1?
fx1 = a + b *tou1;
tou2 = 2; % ????2?
fx2 = a + b *tou2;

fx1_new=[zeros(1);fx1];fx2_new=[zeros(2,1);fx2];
figure,plot(arr,'bo-');
hold on,grid on
plot(s1,'m^-'),plot(s2,'g^-'),plot(fx1_new,'--','linewidth',2),plot(fx2_new,'--','linewidth',2),hold on
legend('origin','S1','S2','fx1','fx2','Location','NorthWest');
xlabel('cycle');
ylabel('value');
title('Moving Average model');