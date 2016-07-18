%Weberead data visualization
%
%% Planet OS API
apiPlanet = 'http://api.planetos.com/v1/';
apikey = 'api key here';



%% baltic surface temperature data
dataset_id = 'myocean_sst_baltic_daily';
count=50;
urlPlanet2 = [apiPlanet 'datasets/' dataset_id '/point'];
rdata = webread(urlPlanet2, 'apikey', apikey,'lat', 58.8,'lon', 18.96 , 'count', count);

datapre=struct2cell(rdata.entries)';


for i=1:size(datapre,1)
    
 rr{i} = (struct2cell(datapre{i,3}))';
 rt(i) =  datetime(datapre{i,2}.time, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss','TimeZone','UTC');

end
 % temperature in kelvin is in one
for i=1:size(datapre,1)
t     = cell2mat(rr{1,i});
ts(i) = t(1);

end
figure
plot(rt,ts)
title(['Surface temperature of baltic sea'])


%baltic beochemistry data
dataset_id2 = 'copernicus_biogeo_baltic_hourly';
count=50;
urlPlanet3 = [apiPlanet 'datasets/' dataset_id2 '/point'];
cdata = webread(urlPlanet3, 'apikey', apikey,'lat', 58.8,'lon', 18.96 , 'count', count);
dpre=struct2cell(cdata.entries)';

for i=1:size(dpre,1)
    
 cr{i} = (struct2cell(dpre{i,3}))';
 ct(i) =  datetime(dpre{i,2}.time, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss','TimeZone','UTC');
c     = cell2mat(cr{1,i});
ns(i) = c(1);
np(i) = c(2);
nc(i) = c(3);
nd(i) = c(4);
end
for i=1:size(dpre,1)

end
chemicals=[ns; np; nc; nd];
