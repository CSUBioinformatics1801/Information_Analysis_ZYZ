clc,clear
y=[61 60 64 63 65 67 70 68 74 77 76 80 86 90 92]; %??????
for k=1:3
m=length(y);
n=[2 3 4 5]; %n???????
for i=1:length(n) 
    for j=1:m-n(i)+1
        yhat{i}(j)=sum(y(j:j+n(i)-1))/n(i); %?y????
    end
    MSE(i)=1/(m-n(i))*sum((y(n(i)+1:m)-yhat{i}(1:m-n(i))).^2); %?MSE 
end
[ans,p]=min(MSE);
p=p+1;
year=2017;
year=year+k;
y=cat(2,y,[yhat{p}(m-n(p)+1)]);
fprintf('%d year',year);
fprintf('sum: %f\n',yhat{p}(m-n(p)+1));
fprintf('best MSE:%f\n',ans);
fprintf('n=%d\n',p);
end

Yd1 = diff(y);
yd1_h_adf = adftest(Yd1);
yd1_h_kpss = kpsstest(Yd1);


