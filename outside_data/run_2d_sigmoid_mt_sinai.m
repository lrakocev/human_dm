unique_ids = unique(imt_formatted.id);
mt_sinai_2d_trial_table = [];
for j = 1:length(unique_ids)
    id = unique_ids(j);
    func = create_2d_psychs_for_mt_sinai(imt_formatted, id);
    row.id = id; 
    
    row.a_R = func.a_R;
    row.a_C = func.a_C;
    row.b_R = func.b_R;
    row.b_C = func.b_C;


    mt_sinai_2d_trial_table = [mt_sinai_2d_trial_table; row];
end

mt_sinai_2d_trial_table = struct2table(mt_sinai_2d_trial_table);

%%

figure
scatter3(mt_sinai_2d_trial_table.a_R, mt_sinai_2d_trial_table.b_R, mt_sinai_2d_trial_table.b_C);
xlabel("a_R")
ylabel("b_R")
zlabel("b_C")
title("2d sigmoid clustering for mt sinai data")
savefig("C:\Users\lrako\OneDrive\Documents\human_dm\dec_2025\mt_sinai_2d_sigmoid.fig")