clc,clear;
yt=[61	60	64	63	65	67	70	68	74	77	76	80	86	90	92];
n=length(yt); 
alpha=[0.1 0.3];
m=length(alpha); 
yhat(1,1:m)=yt(1);
yhat2(1,1:m)=yt(1);
for i=2:n 
 yhat(i,:)=alpha*yt(i)+(1-alpha).*yhat(i-1,:); 
 yhat2(i,:)=alpha*yhat(i)+(1-alpha).*yhat2(i-1,:); 
end
at=2.*yhat-yhat2;
bt=(yhat-yhat2);
for i=1:m
    bt(:,i)=alpha(i)/(1-alpha(i)).*bt(:,i);
end

y1=yt';
err=sqrt(mean((repmat(y1,1,m)-yhat).^2));
xlswrite('yt',yhat);
yhat1_16=alpha*yt(n)+(1-alpha).*yhat(n,:);
yhat2_16=alpha*yhat(n)+(1-alpha).*yhat2(n,:);
y0116=at(n,1)+bt(n,1);
y0315=at(n,2)+bt(n,2);


% alpha1=0.1;
% alpha2=0.3;
% beta=0.3;
% gamma=0.5;
% fc=10;
% k=2;
% 
% S=[61	60	64	63	65	67	70	68	74	77	76	80	86	90	92];
% plot(S,'r');
% n=length(S);
% a(1)=sum(S(1:k))/k;
% b(1)=(sum(S(k+1:2*k))-sum(S(1:k)))/k^2;
% s=S-a(1);
% y=a(1)+b(1)+s(1);
% 
% f=zeros(144,1);
% for i=1:n+fc
%     if i==length(S)
%         S(i+1)=a(end)+b(end)+s(end-k+1);
%     end
% a(i+1)=alpha1*(S(i)-s(i))+(1-alpha1)*(a(i)+b(i));
% b(i+1)=beta*(a(i+1)-a(i))+(1-beta)*b(i);%??
% s(i+1)=gamma*(S(i)-a(i)-b(i))+(1-gamma)*s(i);%??
% y(i+1)=a(i+1)+b(i+1)+s(i+1);
% end
% 
% hold on
% plot(y,'b');
% hold off