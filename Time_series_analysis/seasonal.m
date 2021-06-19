%% import data
clc,clear,close all;
y = [4.8 4.1 6 6.5 5.8 5.2 6.8 7.4 6 5.6 7.5 7.8 6.3 5.9 8 8.4]';
year=length(y)/4;
S=zeros(1,4);
for i=1:length(y)
    if(mod(i,4)==0)
        S(4)=S(4)+y(i)/year;
    else
    S(mod(i,4))=S(mod(i,4))+y(i)/year;
    end
end
%% season decomposition
S=S./sum(S)*4;
TI=zeros(length(y),1);
range=(1:length(y))';
for i=0:year-1
    for s=1:4
      TI(i*4+s)=y(i*4+s)/S(s);
    end
end
% pn=polyfit(range,TI,1);
%% regression
Lxx=sum((range-mean(range)).^2);
Lxy=sum((range-mean(range)).*(TI-mean(TI)));
b1=Lxy/Lxx;
b0=mean(TI)-b1*mean(range);
y1=b1*range+b0;
p = polyfit(range,TI,1);
f = polyval(p,range);
[r2,rmse] = rsquare(TI,f);
figure;
plot(TI),hold on;
plot(y),hold on;
plot(y1,'linewidth',2);
xlabel('season');ylabel('sells');
legend('TI','TIS','regress','Location','NorthWest');
%% ARIMA
t = 1:length(TI);
t = t';
figure;
plot( t, TI );
%% ACF&PACF 
figure
subplot(211),autocorr( TI );
subplot(212),parcorr( TI );
figure
dy = diff( TI );
subplot(211),autocorr( dy );
subplot(212),parcorr( dy );
%% ARIMA 
Mdl = arima(3 ,1,2);
EstMdl = estimate(Mdl,TI);
res = infer(EstMdl,TI);
%% 
figure
subplot(2,2,1)
plot(res./sqrt(EstMdl.Variance))
title('Standardized Residuals')
subplot(2,2,2),qqplot(res)
subplot(2,2,3),autocorr(res)
subplot(2,2,4),parcorr(res)
%% predict
predict_length=8;
[yF,yMSE] = forecast(EstMdl,predict_length,'Y0',TI);
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);
figure
h4 = plot(TI,'b','LineWidth',1);
hold on
yF=[TI(length(TI));yF];
UB=[TI(length(TI));UB];
LB=[TI(length(TI));LB];
yF_S=yF;
UB_S=UB;
LB_S=LB;
for i=1:length(yF)
    if(mod(i,4)==1)
        yF_S(i)=yF_S(i)*S(4);
        UB_S(i)=UB_S(i)*S(4);
        LB_S(i)=LB_S(i)*S(4);
    elseif(mod(i,4)==0)
        yF_S(i)=yF_S(i)*S(3);
        UB_S(i)=UB_S(i)*S(3);
        LB_S(i)=LB_S(i)*S(3);
    else
        yF_S(i)=yF_S(i)*S(mod(i,4)-1);
        UB_S(i)=UB_S(i)*S(mod(i,4)-1);
        LB_S(i)=LB_S(i)*S(mod(i,4)-1);
     end
end
plot(y,'LineWidth',2);hold on;grid on;
plot(length(TI):length(TI)+predict_length,yF_S,'LineWidth',2);
h5 = plot(length(TI):length(TI)+predict_length,yF,'r','LineWidth',1);
plot(length(TI):length(TI)+predict_length,UB_S,'k--','LineWidth',1.5)
plot(length(TI):length(TI)+predict_length,LB_S,'k--','LineWidth',1.5)
h6 = plot(length(TI):length(TI)+predict_length,UB,'k--','LineWidth',0.5);
plot(length(TI):length(TI)+predict_length,LB,'k--','LineWidth',0.5);
legend('TI','TIS','predict_T_I_S','predict_T_I','95%',...
    'Location','NorthWest');
hold off%% ARIMA
t = 1:length(TI);
t = t';
figure;
plot( t, TI );
%% ACF&PACF 
figure
subplot(211),autocorr( TI );
subplot(212),parcorr( TI );
figure
dy = diff( TI );
subplot(211),autocorr( dy );
subplot(212),parcorr( dy );
%% ARIMA 
Mdl = arima(3 ,1,2);
EstMdl = estimate(Mdl,TI);
res = infer(EstMdl,TI);
%% 
figure
subplot(2,2,1)
plot(res./sqrt(EstMdl.Variance))
title('Standardized Residuals')
subplot(2,2,2),qqplot(res)
subplot(2,2,3),autocorr(res)
subplot(2,2,4),parcorr(res)
%% predict
predict_length=8;
[yF,yMSE] = forecast(EstMdl,predict_length,'Y0',TI);
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);
figure
h4 = plot(TI,'b','LineWidth',1);
hold on
yF=[TI(length(TI));yF];
UB=[TI(length(TI));UB];
LB=[TI(length(TI));LB];
yF_S=yF;
UB_S=UB;
LB_S=LB;
for i=1:length(yF)
    if(mod(i,4)==1)
        yF_S(i)=yF_S(i)*S(4);
        UB_S(i)=UB_S(i)*S(4);
        LB_S(i)=LB_S(i)*S(4);
    elseif(mod(i,4)==0)
        yF_S(i)=yF_S(i)*S(3);
        UB_S(i)=UB_S(i)*S(3);
        LB_S(i)=LB_S(i)*S(3);
    else
        yF_S(i)=yF_S(i)*S(mod(i,4)-1);
        UB_S(i)=UB_S(i)*S(mod(i,4)-1);
        LB_S(i)=LB_S(i)*S(mod(i,4)-1);
     end
end
plot(y,'^-','LineWidth',2);hold on;grid on;
plot(length(TI):length(TI)+predict_length,yF_S,'r^-','LineWidth',2);
h5 = plot(length(TI):length(TI)+predict_length,yF,'m','LineWidth',1);
plot(length(TI):length(TI)+predict_length,UB_S,'k--','LineWidth',1.5)
plot(length(TI):length(TI)+predict_length,LB_S,'k--','LineWidth',1.5)
h6 = plot(length(TI):length(TI)+predict_length,UB,'k--','LineWidth',0.5);
plot(length(TI):length(TI)+predict_length,LB,'k--','LineWidth',0.5);
legend('TI','TIS','predict_T_I_S','predict_T_I','95%',...
    'Location','NorthWest');
hold off