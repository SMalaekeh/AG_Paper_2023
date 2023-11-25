%%  Reading ShapeFile
clear;clc;
cd 'D:\Civil\Master\Ms.cTheses\Data\ShapeFiles\Shape_File_Counties_98\Iran_Shapefiles';
S = shaperead('irn_admbnda_adm2_unhcr_20190514.shp');
[~,index] = sortrows([S.Code_1].'); S = S(index); clear index
% Sort Structure By yourself
%% Calling Function
cd 'D:\Civil\Master\Ms.cTheses\Data\Climate\Climate_Panel\Temp_AgrEra5';
direct = dir;
matrix =[];
for i = 63:422
    i
    date = (direct(i).name);
    cd 'D:\Civil\Master\Ms.cTheses\Data\Climate\Climate_Panel';
    matrix = Code_NC_AgrEra5(S,date,matrix);
end
Codes=[];
for i = 1:size(S,1)
    Codes(i) = S(i).Code_1;
end
matrix = [Codes' matrix];
csvwrite('Temp_Daily_1986_2015',matrix)