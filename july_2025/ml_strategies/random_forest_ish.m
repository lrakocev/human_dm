%% get appr lvl table

k=3;
appr_lvl_table = parameters_per_appr_lvl(all_data, k);

%% narrow down all_data to relevant variables

measures = ["approach_rate", "cost","rew","pupil_diameter","hunger",...
    "tiredness", "pain", "story_prefs"];

sub_table = [];
for i = 1:length(measures)
    measure = measures{i};
    measure_data = all_data.(measure);
    sub_table.(measure) = measure_data;
end

% i'm being stupid w the syntax and need the internet to check why
new_table = struct2table(sub_table);

%% all data, not aggreated at appr rate lvls

R2_full_appr = run_random_forest(new_table, "approach_rate");

%% appr rate 

rng(1);
appr_lvl_table.appr_lvl_top = [];
R2_appr = run_random_forest(appr_lvl_table, "appr_lvl_bottom");


%% entropy measures

R2_pain_ent = run_random_forest(appr_lvl_table, "pain_entropy");
R2_pupil_ent = run_random_forest(appr_lvl_table, "pupil_diameter_entropy");
R2_hunger_ent = run_random_forest(appr_lvl_table, "hunger_entropy");
R2_tired_ent = run_random_forest(appr_lvl_table, "tiredness_entropy");
R2_story_pref_ent = run_random_forest(appr_lvl_table, "story_prefs_entropy");

