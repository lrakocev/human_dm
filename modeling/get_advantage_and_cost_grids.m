function [advantages,costs,net_advantages] = ...
    get_advantage_and_cost_grids(strio_incs,lh_incs,da_incs,...
    space_advantage_coefs,baseline_strio,baseline_LH,baseline_DA)
    
    [net_advantages,costs,advantages] = ...
        deal(zeros(length(strio_incs),length(lh_incs),length(da_incs)));
    spaces = (dec2bin(0:2^2-1)' - '0')';

%     spaces = (dec2bin(0:2^4-1)' - '0')';

    for i=1:length(strio_incs)
        for j=1:length(lh_incs)
            for k=1:length(da_incs)
    
                strio = strio_incs(i);
                lh = lh_incs(j);
                da = da_incs(k);
                    
                advantage = calculate_circuit_configuration_advantage(...
                    space_advantage_coefs,spaces,strio,1,1,lh,.5,da);

                cost = calculate_circuit_configuration_cost(1,strio,1,lh,...
                    .75,da,1,baseline_strio,1,baseline_LH,.75, baseline_DA);
                net_advantages(i,j) = advantage - cost;
        
                advantages(i,j,k) = advantage;
                costs(i,j,k) = cost;

            end
        end
    end

end