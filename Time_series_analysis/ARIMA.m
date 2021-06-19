%%
clc,clear,close all

%y = [4.8 4.1 6 6.5 5.8 5.2 6.8 7.4 6 5.6 7.5 7.8 6.3 5.9 8 8.4]';
y = [61 60 64 63 65 67 70 68 74 77 76 80 86 90 92]';
t = 1:length(y);
t = t';
figure;
plot( t, y );
%%
% y_h_adf = adftest(y);
% y_h_kpss = kpsstest(y);
% n=0;
% while((y_h_adf ==0&&y_h_kpss ==1))
%     y = diff(y);
%     y_h_adf = adftest(y);
%     y_h_kpss = kpsstest(y);
%     n=1+n;
%     if(n>=10)
%         break;
%     end
% end
%% ACF?PACF 
figure
subplot(211),autocorr( y );
subplot(212),parcorr( y );
figure
dy = diff( y );
subplot(211),autocorr( dy );
subplot(212),parcorr( dy );

%% ARIMA ??
Mdl = arima(1,1,3);
EstMdl = estimate(Mdl,y);
res = infer(EstMdl,y);

%% ????
figure
subplot(2,2,1)
plot(res./sqrt(EstMdl.Variance))
title('Standardized Residuals')
subplot(2,2,2),qqplot(res)
subplot(2,2,3),autocorr(res)
subplot(2,2,4),parcorr(res)

%% ??
predict_length=8;
[yF,yMSE] = forecast(EstMdl,predict_length,'Y0',y);
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);

figure
h4 = plot(y,'b','LineWidth',2);
hold on
h5 = plot(length(y)+1:length(y)+predict_length,yF,'r','LineWidth',2);
h6 = plot(length(y)+1:length(y)+predict_length,UB,'k--','LineWidth',1.5);
plot(length(y)+1:length(y)+predict_length,LB,'k--','LineWidth',1.5);
legend('origin','predict_a_v_g','95%',...
    'Location','NorthWest');
hold off
%%
% Mdl = arima(1, 1, 3);  %???????1??????
% EstMdl = estimate(Mdl,y);
% [res,~,logL] = infer(EstMdl,y);   %res???
% 
% stdr = res/sqrt(EstMdl.Variance);
% figure('Name','????')
% subplot(2,3,1)
% plot(stdr)
% title('Standardized Residuals')
% subplot(2,3,2)
% histogram(stdr,10)
% title('Standardized Residuals')
% subplot(2,3,3)
% autocorr(stdr)
% subplot(2,3,4)
% parcorr(stdr)
% subplot(2,3,5)
% qqplot(stdr)
%  