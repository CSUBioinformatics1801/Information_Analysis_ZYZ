clear;
clc;
n1=3;n2=3;
[weight,weight_CR,weight_mtx]=rand_AHP(n1);
plan_weight=zeros(n2,n1);
plan_CR=zeros(1,n1);
plan_mtx=zeros(n2,n2,n1);
final_weight=zeros(n2,n1);
for i=1:n1
    [plan_weight(:,i),plan_CR(i),plan_mtx(:,:,i)]=rand_AHP(n2);
    final_weight(:,i)=plan_weight(:,i).*weight(i);
end