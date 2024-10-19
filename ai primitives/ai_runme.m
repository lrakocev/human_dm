save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\train_by_section\';

load('C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\mat files\full space w types.mat')
starting_table = further_filter;
% use same rand_rows from testing_bias_sig_fit.m if possible
n = 5000;
rows_used = randperm(height(starting_table), n);
possible_table = starting_table(rows_used, :);
possible_table = sortrows(possible_table, ["a","b","c"]);
mkdir(save_to)
h = height(possible_table);
max_iter = round(h/4);
min_iter = 1;
num_iter = 5;
num_models = 20;
section_num = round(h/num_models);
num_pts_to_train_on = 50;

model_num = 1;
model_data = [];

count = 0;
for i = 1:num_models

    full_training_data = possible_table(((i-1)*section_num)+1:(i*section_num),:);
    for m = 1:num_iter
        train_idx = randperm(section_num, num_pts_to_train_on);
        rows = full_training_data(train_idx, :);
    
        t = [];
        rew = [];
        for r = 1:num_pts_to_train_on
            row = rows(r,:);
            row_t = [row.lvl1 row.lvl2 row.lvl3 row.lvl4];
            t = [t; row_t];
            rew = [rew; 1 2 3 4];
        end

        net = feedforwardnet(10);
        net = configure(net, {rew});
        net = train(net, {rew}, t);
    
        ys = net(rew);
            
        for y = 1:height(ys)
            all_appr = ys(y,:);
            if all(~isnan(all_appr))
                for sig_type = 2:4
                    try
                        [a,b,c] = fit_sigmoid_w_diff_methods([1 2 3 4], all_appr, sig_type);
                        row.a = a;
                        row.b = b;
                        row.c = c;
                        row.appr_vals = all_appr;
                        row.model = i;
                        model_data = [model_data; row];
                        
                    catch
                        continue
                    end
                end
            end
        end
    end
end

new_name = "testing_model_bias_" + string(datetime('today'));
save(new_name+'.mat','model_data')

%% simple plot

figure
colors = distinguishable_colors(num_models);
plot_n = 2500;

model_data = sortrows(model_data, ["a","b","c"]);

hs = [];
prev_m = 0;
for i = 1:plot_n
    rand_idx = randperm(height(model_data), 1);
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

