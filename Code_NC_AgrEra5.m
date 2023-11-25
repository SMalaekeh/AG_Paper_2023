function Final_New = Code_NC_AgrEra5(S,date,Matrix)
%% Making Cells of Netcdf
cd 'D:\Civil\Master\Ms.cTheses\Data\Climate\Climate_Panel\Temp_AgrEra5';
filename =date;
var = ncread (filename, 'Temperature_Air_2m_Mean_24h',[2201,501,1],[251,161,inf]); %Change
long = ncread (filename, 'lon',2201,251);
lat = ncread (filename, 'lat',501,161);
time = ncread(filename,'time');
[X,Y] = meshgrid(long,lat);
N = 427;
iwant = cell(N,size(time,1));
for i = 1:size(S,1)
%     Iranx = x(i,:);
%     Irany = y(i,:);
%     Iranx = Iranx(1:find(Iranx==0));
%     Irany = Irany(1:find(Irany==0));
    Iranx = S(i).X;
    Irany = S(i).Y;
    idx = inpolygon(X(:)+0.05,Y(:)+0.05,Iranx',Irany');
    for t = 1:size(time,1)
        var1 = var(:,:,t)';
        iwant{i,t}=var1(idx);
    end
end
%% Making Matrix of Cells
Final=zeros(size(iwant,1),size(iwant,2));
for i = 1:size(iwant,1)
    for j = 1:size(iwant,2)
        A = iwant{i,j};
        A=A(not(isnan(A)));
        Final(i,j)=mean(A);
    end
end
Final_New = [Matrix Final];
end