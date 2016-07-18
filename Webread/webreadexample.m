% 
% Webread function example
% getting spacial data from planet OS api and from climate data api

% Planet OS api  data sourcing
apiPlanet = 'http://api.planetos.com/v1/';
apikey = '';
dataset_id = '';

% getting metada
urlPlanet = [apiPlanet 'datasets/' dataset_id];
mdata=webread(urlPlanet, 'apikey', apikey);



% getting actual data
count=50;
urlPlanet2 = [apiPlanet 'datasets/' dataset_id '/point'];
rdata = webread(urlPlanet2, 'apikey', apikey,'lat', 35.9073926681,'lon', -6.1876466940 , 'count', count);
test = struct2cell(mdata.Variables)';
variables=test(:,1);
variablesl=test(:,2);

% parsing the data
datapre=struct2cell(rdata.entries)';


for i=1:count
    
 rr{i} = (struct2cell(datapre{i,3}))';
 rt(i) =  datetime(datapre{i,2}.time, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss','TimeZone','UTC');

end
 % wind_speed is indexed 1 and 8 is hight of wind waves
for i=1:count
w     = cell2mat(rr{1,i});
ws(i) = w(1)
wh(i) = w(8)
end

%plotting

figure
subplot(2,1,1)
plot(rt,ws)
title([mdata.Title test(7,2) test(7,4)])
subplot(2,1,2)
plot(rt,wh)
title([mdata.Title test(12,2) test(12,4)])
