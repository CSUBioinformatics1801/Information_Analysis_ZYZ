function [norm,nCR,bmtx]=rand_AHP(n)
judgemtx=ones(n);
randIndex = randperm(n);
    for i=1:n
        for j=1:n
            if(i~=j)
                 if((find(randIndex==j)-find(randIndex==i))>0)
                    judgemtx(i,j)=abs(round((find(randIndex==j)-find(randIndex==i))/(n-1)*5));
                    judgemtx(j,i)=1/judgemtx(i,j);
                 else
                     judgemtx(i,j)=abs(1/(round((find(randIndex==j)-find(randIndex==i))/(n-1)*5)));
                     judgemtx(j,i)=1/judgemtx(i,j);
                 end
            end
        end
    end
    [~,y]=eig(judgemtx);
    lamda_max=max(max(y));
    CI=(lamda_max-n)/(n-1);
    RI=ri(n);
    CR=CI/RI;
b=cumsum(judgemtx,2);
v=sum(b);
D=diag(v);
norm_b=b*(D^-1);
norm_judgemetx=norm_b(:,n);
norm=norm_judgemetx;
nCR=CR;
bmtx=judgemtx;
end