save_to = 'C:\Users\lrako\OneDrive\Documents\human dm\ai primitives\model_' + string(datetime("today"));
mkdir(save_to)

max_t = 5;
n_sim = 100;
noise = 10;
threshold = 2;
tstep = .01; % in seconds
n_action = length(drift_rate);
max_tsteps = max_t/tstep;

count = 0;
for ctx = 0:5  
    for sSPN = 0:20
        FSI_a = 1;
        FSI_b = 0.1;
        FSI = ctx ./ (FSI_b + FSI_a*vecnorm(ctx,2,2));
        FSI_c = 0.1;
        for GPi0 = 0:15
            for LH0 = 0:15
                RMTg0 = LH0;
                for DA_b = 1:4
                    for DA_a = 1:4
                        
                        [prob_in_space,LH,RMTg] = algorithmic_model(sSPN,FSI,FSI_c,GPi0,LH0,RMTg0,DA_a,DA_b);
                        all_apprs = [];
                        for rew = 1:4

                            drift_rate = prob_in_space * rew;
                            appr_rate = weiner_process_sim(drift_rate);

                            all_apprs = [all_apprs appr_rate];
                        end

                        if all(~isnan(all_apprs))
                            try
                                fit_sigmoid_ai([1 2 3 4], all_apprs, save_to, count, [])
                                count = count + 1;
                            catch
                                continue
                            end
                        end
                    end
                end
            end
        end
    end
end


table_of_human_dir = [];
table_of_human_dir.Task = "all";
table_of_human_dir.Data_Directory = save_to;
table_of_human_dir=struct2table(table_of_human_dir);

colors = distinguishable_colors(10);
call_spectral_clustering_combine_all_human_data...
    (table_of_human_dir,"cluster_thresh",0,10,colors,'euclidean');


