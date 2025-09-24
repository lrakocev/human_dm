%% viz of current space

midway_hmm_table = readtable("C:\Users\lrako\OneDrive\Documents\hmm_session_data_1.csv");

%%
x = 10000;
randidx = randi(height(midway_hmm_table), x, 1);

midway_hmm_rows = midway_hmm_table(randidx, :);

human_bics = midway_hmm_rows.bic;
mpc_1 = midway_hmm_rows.mpcs_1;
mpc_2 = midway_hmm_rows.mpcs_2;
mpc_3 = midway_hmm_rows.mpcs_3;

%% 
figure
histogram(human_bics)
title('3 feature bics')

figure
histogram(mpc_1)
hold on
histogram(mpc_2)
hold on
histogram(mpc_3)
title('3 feature mpcs')
hold off

figure
scatter(mpc_1, human_bics)
xlabel('mpcs')
ylabel('bics')
title('3 feature mpcs vs bics')

%%
%filtered_hmm_table = midway_hmm_rows(midway_hmm_rows.bic <= 1500 & midway_hmm_rows.mpcs_1 > 0.9, :);
filter_t_matrices = midway_hmm_rows(midway_hmm_rows.t_1 > 0.01 & midway_hmm_rows.t_2 > 0.01 ...
    & midway_hmm_rows.t_3 > 0.01 & midway_hmm_rows.t_4 > 0.01, :);

filter_t_matrices = filter_t_matrices(filter_t_matrices.mpcs_1 > 0.9 | filter_t_matrices.mpcs_2 > 0.9 | filter_t_matrices.mpcs_3 > 0.9, :);
filter_t_matrices = sortrows(filter_t_matrices,"bic","ascend");

