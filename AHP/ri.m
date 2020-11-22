function RI=ri(n)
n=ceil(n);
if n<=0,error('n must be bigger than 0!')
end
if n==0||n==1,RI=0;
return;
end
times=1000;
scaler=[9;8;7;6;5;4;3;2;1;1/2;1/3;1/4;1/5;1/6;1/7;1/8;1/9];
A=zeros(n);
lamda=zeros(times,1);
for num=1:times
    rank=ceil(17*rand(n));
    for i=1:n
        for j=i:n
            A(i,j)=scaler(rank(i,j));
            A(j,i)=1/A(i,j);
            A(i,i)=1;
        end
    end
    rigenvector=eig(A);
    lamda(num)=max(rigenvector);
end
lamda_avg=sum(lamda)/times;
RI=(lamda_avg-n)/(n-1);