%% This function has been written for the Impacts.m to calculate DX based on 
% different sceniors. It returns a matrix which contains the changes 1400/08/15
function [county] = DX_Calculator(county,forecast,scen)
    for_mat = table2array(forecast);
    % iterating over counties
    for i = 1:315
        state = county(i,2);
        index = find(for_mat(:,1)==state);
        % pr
        county(i,7) = for_mat(index,scen+2) - for_mat(index,2);
        % gdd8
        county(i,3) = for_mat(index,scen+15) - for_mat(index,15);
        % gdd8_S
        county(i,4) = for_mat(index,scen+15)^2 - for_mat(index,15)^2;
        % gdd30
        county(i,5) = for_mat(index,scen+28) - for_mat(index,28);
        % sdii
        county(i,9) = for_mat(index,scen+67) - for_mat(index,67);
        % gsl
        county(i,10) = for_mat(index,scen+80) - for_mat(index,80);
        % r_gdd34
        county(i,6) = sqrt(for_mat(index,scen+41)) - sqrt(for_mat(index,41));
        % csdi
        county(i,8) = for_mat(index,scen+54) - for_mat(index,54);
    end
end