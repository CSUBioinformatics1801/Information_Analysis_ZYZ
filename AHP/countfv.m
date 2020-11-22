A=[1 8 5 3;1/8 1 1/2 1/6; 1/5 2 1 1/3;1/3 6 3 1];
[x,y]=eig(A);
lamda_max=max(max(y));