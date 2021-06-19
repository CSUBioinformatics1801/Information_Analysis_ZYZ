%% import data
data=[4.8 4.1 6 6.5 5.8 5.2 6.8 7.4 6 5.6 7.5 7.8 6.3 5.9 8 8.4]';
S = 4;                    %season 12 month
figflag = 'on';            %open figure
step = 8;                 %predict cycle
%% count S & T
for d = 0:3
    D1 = LagOp({1 -1},'Lags',[0,d]);     %nonseasonal lag operator
    D12 = LagOp({1 -1},'Lags',[0,1*S]);  %seasonal lag operator
    D = D1*D12;                          
    dY = filter(D,data);                 %differential calculation
    if(adftest(dY))               %data stable
        disp(['Nonseasonal',num2str(d),',Seasonal 1']);
        break;
    end
end
%%
max_ar = 3;  %
max_ma = 3;
max_sar = 3;
max_sma = 3;
try
    [AR_Order,MA_Order,SAR_Order,SMA_Order] = SARMA_Order_Select(dY,max_ar,max_ma,max_sar,max_sma,S,d); 
catch ME 
    msgtext = ME.message;
    if (strcmp(ME.identifier,'econ:arima:estimate:InvalidVarianceModel'))
         msgtext = [msgtext,'  ','unable to use arima,tranning data might be too few,unmatched the order,try to minimize max_ar,max_ma,max_sar,max_sma'];
    end
    msgbox(msgtext, 'err')
end
disp(['ARlags=',num2str(AR_Order),',MALags=',num2str(MA_Order),',SARLags=',num2str(SAR_Order),',SMALags=',num2str(SMA_Order)]);
%%
Mdl = creatSARIMA(AR_Order,MA_Order,SAR_Order,SMA_Order,S,d);  %create SARIMA
try
    EstMdl = estimate(Mdl,data);
catch ME %??????
    msgtext = ME.message;
    if (strcmp(ME.identifier,'econ:arima:estimate:InvalidVarianceModel'))
         msgtext = [msgtext,'  ','unable to use arima,tranning data might be too few,unmatched the order,try to minimize max_ar,max_ma,max_sar,max_sma'];
    end
    msgbox(msgtext, 'err')
    return
end
[res,~,logL] = infer(EstMdl,data);   %residue

stdr = res/sqrt(EstMdl.Variance);
figure('Name','residue check','Visible','on')
subplot(2,3,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,3,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,3,3)
autocorr(stdr)
subplot(2,3,4)
parcorr(stdr)
subplot(2,3,5)
qqplot(stdr)