% Initialize data points
D1 = [5	3	4	4];   
D2 = [4	3	4	5];
D3 = [3	2	1	3];
D4=[1	1	3	5];
D5=[5	3	4	2];
D6=[2	3	2	1];

P = [D1; D2; D3;D4;D5;D6];

% Spider plot
spider_plot(P,'AxesLabels', {'Rank Global', 'Rank China', 'Browse Number', 'Reverse Link'});

% Legend settings
legend('scic.org.cn/', 'scip.org/','chinacir.com.cn/','ccidnet.com/','sinoci.com.cn/','gartner.com/', 'Location', 'southoutside');