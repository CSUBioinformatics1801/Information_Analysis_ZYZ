%% import data
clc,clear;
ori=[15 12 10 8 8 7 6 6 6 5 4 4 4 3 3 3 3]';
mags2=2.*ones(11,1);
mags1=ones(24,1);
mags=[ori;mags2;mags1];
%% auto classify
add_mag_it=1;
mgs_num=zeros(length(mags),3);
for i=1:length(mags)
    if(sum(mgs_num(:,add_mag_it))<sum(mags)/3)
        mgs_num(i,add_mag_it)=mags(i);
    else 
        add_mag_it=add_mag_it+1;
        mgs_num(i,add_mag_it)=mags(i);
    end
end
alpha=zeros(1,3);
for k=1:3
    alpha(k)=length(find(mgs_num(:,k)));
end
x=[1 2 3];
alpha=alpha./alpha(1);
MSE=100;
for i=0.01:0.01:3
    n_MSE=0;
    for t=1:3
        n_MSE= n_MSE+ (alpha(t)-i^(x(t)-1))^2;
    end
    if(MSE<n_MSE)
        break;
    else
        MSE=n_MSE;
    end    
end
%% show result
predictx=1:0.01:3;
predicty=i.^(predictx-1);
plot(predictx,predicty,'k--','LineWidth',1.5),hold on;
scatter(x,alpha,'r','LineWidth',1),hold on;
legend('Predict','True data');