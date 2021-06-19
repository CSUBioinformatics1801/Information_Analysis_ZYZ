function draw_radar_circle(data,prefer_range,labels)
    n=length(data);
    lim=zeros(n,2);
    for j=1:n
        lim(j,1)=prefer_range(j,1)-(prefer_range(j,2)-prefer_range(j,1));
        lim(j,2)=prefer_range(j,2)+(prefer_range(j,2)-prefer_range(j,1));
    end
    adj_data=zeros(n,1);
    adj_preferl=zeros(n,1);
    preferl_point=zeros(n,2);
    adj_preferu=zeros(n,1);
    preferu_point=zeros(n,2);
    
    set(gca,'units','normal','pos',[0 0 1 1]);
    axis off
    axis equal
    hold on
    for i=1:5
        draw_circle(0,0,i*100,'--',[0.5,0.5,0.5],0.75);
    end
    for i=1:n
        theta=2*pi/n*i+pi/2;
        plot([0,500*cos(theta)],[0,500*sin(theta)],'k-','linewidth',2);
        if data(i)<lim(i,1)
            adj_data(i)=0;
        elseif data(i)>lim(i,2)
            adj_data(i)=500;
        else
            adj_data(i)=(data(i)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        end
        adj_preferl(i)=(prefer_range(i,1)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        preferl_point(i,1:2)=[adj_preferl(i)*cos(theta);adj_preferl(i)*sin(theta)];
        adj_preferu(i)=(prefer_range(i,2)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        preferu_point(i,1:2)=[adj_preferu(i)*cos(theta);adj_preferu(i)*sin(theta)];
        text_around(510*cos(theta),510*sin(theta),labels{i},theta);
    end
    draw_circle(0,0,500/3,'-',[0.2,0.2,0.9],1.5);
    draw_circle(0,0,500/3*2,'-',[0.9,0.2,0.2],1.5);
    for i=1:n
        theta=2*pi/n*i+pi/2;
        for j=1:5
            text_around(j*100*cos(theta),j*100*sin(theta),num2str(lim(i,1)+(lim(i,2)-lim(i,1))/5*j),theta+pi/2,7);
        end
    end
    y=[adj_data;adj_data(1)];
    x=[2*pi/n*(1:n)'+pi/2;2*pi/n*(n+1)+pi/2];
    m=length(x)*2-1;
    x_2=zeros(m,1);
    y_2=zeros(m,1);
    for i=1:m
        if mod(i,2)==0
            x_2(i)=(x(i/2)+x(i/2+1))/2;
            y_2(i)=(y(i/2)+y(i/2+1))/2;
        else
            x_2(i)=x((i+1)/2);
            y_2(i)=y((i+1)/2);
        end
    end
    xx=linspace(x_2(1),x_2(end),100);  
    yy=spline_period(x_2,y_2,xx);
    point=zeros(length(yy),2);
    for i=1:length(point)
        point(i,1:2)=[yy(i)*cos(xx(i));yy(i)*sin(xx(i))];
    end
    fill(point(:,1),point(:,2),[0.9 0.9 0.7])
    alpha(0.5);
    texts=findobj(gca,'Type','Text');
    minx=-500;
    maxx=500;
    miny=-500;
    maxy=500;
    for i=1:length(texts)
        rect=get(texts(i),'Extent');
        x=rect(1);
        y=rect(2);
        dx=rect(3);
        dy=rect(4);
        if x<minx
            minx=x;
        elseif x+dx>maxx
            maxx=x+dx;
        end
        if y<miny
            miny=y;
        elseif y+dy>maxy
            maxy=y+dy;
        end
    end
    axis([minx-50,maxx+50,miny-20,maxy+20]);
end

function [] = draw_circle(x,y,r,line_type,color,linewidth)  
    theta=0:0.01:2*pi;  
    circlex=x+r*cos(theta);  
    circley=y+r*sin(theta);  
    plot(circlex,circley,line_type,'color',color,'linewidth',linewidth);  
end  

function yy=spline_period(x,y,xx)
    n=length(x)-1; %n????????
    h=zeros(n,1);
    lambda=zeros(n,1);
    mu=zeros(n,1);
    g=zeros(n,1);
    for k=1:n        
        h(k)=x(k+1)-x(k);   %h(i)????????
    end
    for k=1:(n-1)                  %?????
       mu(k)=h(k)/(h(k+1)+h(k));
       lambda(k)=1-mu(k);
       g(k)=6/(h(1+k)+h(k))*((y(k+2)-y(k+1))/h(k+1)-(y(k+1)-y(k))/h(k));
    end
    mu(n)=h(n)/(h(1)+h(n));
    lambda(n)=1-mu(n);
    g(n)=6/(h(1)+h(n))*((y(2)-y(1))/h(1)-(y(n+1)-y(n))/h(n));
    A=zeros(n,n);
    for k=1:(n-1)
        A(k,k)=2;
        A(k,k+1)=lambda(k);
        A(k+1,k)=mu(k+1);
    end
    A(n,n)=2;
    A(1,n)=mu(1);
    A(n,1)=lambda(n);
    [L,U,p] = lu(A,'vector');
    M = U\(L\(g(p,:)));
    M=[M(n);M];  %M0,M1,M2..Mn
    yy=zeros(size(xx));
    k=2;
    for i=1:length(xx)
        if xx(i)>x(k) && k<length(x)
            k=k+1;
        end
        %[x(k-1),x(k)]
        yy(i)=M(k-1)*((x(k)-xx(i))^3)/6/h(k-1)+...
            M(k)*((xx(i)-x(k-1))^3)/6/h(k-1)+...
            (y(k-1)-M(k-1)/6*h(k-1)*h(k-1))*(x(k)-xx(i))/h(k-1)+...
            (y(k)-M(k)/6*h(k-1)*h(k-1))*(xx(i)-x(k-1))/h(k-1);
    end
end

function text_around(x,y,txt,theta,fontsize)
    if nargin==4
        fontsize=10;
    end
    section=mod(theta+pi/12,2*pi);
    if section>pi+pi/6
        %???
        if section>1.5*pi+pi/6
            %???
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','left','Fontsize',fontsize);
        elseif section>1.5*pi
            %???
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','center','Fontsize',fontsize);
        else
            %???
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','right','Fontsize',fontsize);
        end
    elseif section>pi
        %?????
        text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','right','Fontsize',fontsize);
    elseif section>pi/6
        %???
        if section>0.5*pi+pi/6
            %???
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','right','Fontsize',fontsize);
        elseif section>0.5*pi
            %???
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','center','Fontsize',fontsize);
        else
            %???
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','left','Fontsize',fontsize);
        end
    else
        %?????
        text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','left','Fontsize',fontsize);
    end
end