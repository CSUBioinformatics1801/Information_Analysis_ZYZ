arr=[61	60	64	63	65	67	70	68	74	77	76	80	86	90	92];
[m,n]=size(arr);
alf=0.2;
for j=1:2
    s(1,j)=arr(1,1)
end
for i=2:m
    for j=1:2
        if j==1
            s(i,j)=alf*arr(i,1)+(1-alf)*s(i-1,j);
        else
            s(i,j)=alf*s(i,j-1)+(1-alf)*s(i-1,j);
        end
    end
end
temp=alf/(1-alf);
for i=1:m
    at(i,1)=2*s(i,1)-s(i,2);
    bt(i,1)=temp*(s(i,1)-s(i,2));
    yy(i+1)=at(i,1)+bt(i,1);
end
for i=2:n
    y1(i-1)=yy(i);
end
for i=2:n
    b(i-1)=arr(i);
end
for i=1:3
    y2(i)=at(m,1)+bt(m,1)*(i+1);
end
year=[1999:2011];
year=year';
y1=y1';
y2=y2';
b=b';
data=cat(1,y1,y2);
data1=cat(1,b,y2);
plot(year,data,'-rs','markerFaceColor','g', 'MarkerSize',3);
plot(year,data,'-rs',year,data1,'-rs');