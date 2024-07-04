save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\train_by_section\';
mkdir(save_to)
h = height(possible_table);
max_iter = round(h/4);
min_iter = 1;
num_iter = 5;
num_models = 12;
section_num = round(h/num_models);
num_pts_to_train_on = 100;

model_num = 1;
model_data = [];

count = 0;
for i = 1:num_models

    full_training_data = possible_table(((i-1)*section_num)+1:(i*section_num),:);
    
    for y = 1:height(full_training_data)
        row = full_training_data(y,:);
        all_appr = [row.lvl1 row.lvl2 row.lvl3 row.lvl4];

        if all(~isnan(all_appr))
            try
                [a,b,c] = fit_sigmoid_w_diff_methods([1 2 3 4], all_appr, [], 1, 1);
                row.a = a;
                row.b = b;
                row.c = c;
                row.model = i;
                model_data = [model_data; row];
                
            catch
                continue
            end
        end
    end
end


save('testing_bias.mat','model_data')

%% simple plot

figure
colors = distinguishable_colors(num_models);
plot_n = height(model_data);

hs = [];
prev_m = 0;
for i = 1:plot_n
    %rand_idx = randperm(height(model_data), 1);
    rand_idx = i;
    row = model_data(rand_idx,:);
    a = log(abs(row.a));
    b = log(abs(row.b));
    c = log(abs(row.c));
    m = row.model;

    h = scatter3(a,b,c,[],colors(m,:));
    if m > prev_m 
        hs = [hs; h];
    end
    prev_m = m;
    hold on    
end
legend(hs)
title("testing bias w sigmoid fit")