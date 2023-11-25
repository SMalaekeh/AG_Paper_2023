%% ShapeFile
tic
clear;clc;
cd 'D:\Civil\Master\Ms.cTheses\Data\ShapeFiles\Shape_File_Counties_98\Iran_Shapefiles';
S = shaperead('irn_admbnda_adm2_unhcr_20190514.shp');
[~,index] = sortrows([S.Code_1].'); S = S(index); clear index
%load(not_none)
%% Extracting Data of CMIP6
%cd 'D:\Civil\Master\Ms.cTheses\Data\Forecast'
filename = "tasmax_day_CESM2_ssp245_r4i1p1f1_gn_20150101-21001231_v20200528.nc";
temp = ncread (filename, 'tasmax'); %Change
long = ncread (filename, 'lon');
lat = ncread (filename, 'lat');
time = ncread(filename, 'time');
[X,Y] = meshgrid(long,lat);
N = 427;
iwant = cell(N,size(time,1));
for i = 1:size(S,1)
    i
%     Iranx = x(i,:);
%     Irany = y(i,:);
%     Iranx = Iranx(1:find(Iranx==0));
%     Irany = Irany(1:find(Irany==0));
    Iranx = S(i).X;
    Irany = S(i).Y;
    idx = inpolygon(X(:),Y(:),Iranx',Irany');
    for t = 1:size(time,1)
        i
        temp1 = temp(:,:,t)';
        iwant{i,t}=temp1(idx);
    end
end
%%
Final=zeros(size(iwant,1),size(iwant,2));
for i = 1:size(iwant,1)
    for j = 1:size(iwant,2)
        A = iwant{i,j};
        A=A(not(isnan(A)));
        Final(i,j)=mean(A);
    end
end
code = struct2cell(S);
code = cell2mat(code(14,:))';
Final = [code, Final];
csvwrite('Pr_SSP1-2.6_CMCC.csv',Final)

%% only counties that are not NAN
Number = 1:427;
Final = Final(~isnan(Final(:,3)));
save(Final)
