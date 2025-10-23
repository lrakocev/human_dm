load("new_trial_data.mat")

all_data = [];
for i = 1:length(new_trial_data)
    all_data = [all_data; new_trial_data{i}];
end

%% eye-tracking features

figure
scatter3(all_data.num_guesses, all_data.num_saccads, all_data.reaction_time)
zlabel("num guessing periods")
ylabel("num saccads")
xlabel("reaction time")

figure
scatter3(all_data.reaction_time, all_data.num_saccads, all_data.pupil_diameter)
xlabel("num guessing periods")
ylabel("num saccads")
zlabel("pupil diameter")

figure
scatter3(all_data.reaction_time, all_data.num_guesses, all_data.pupil_diameter)
xlabel("num guessing periods")
ylabel("reaction time")
zlabel("pupil diameter")

% heart-rate - need to re-run + re-calc features

figure
scatter3(all_data.min_hr, all_data.max_hr, all_data.mean_hr)
xlabel("min hr")
ylabel("max hr")
zlabel("mean hr")

figure
scatter3(all_data.min_hr, all_data.max_hr, all_data.direction)
xlabel("min hr")
ylabel("max hr")
zlabel("direction")

%%

%load("prim_table.mat")

figure
scatter3(prim_table.mean_appr, prim_table.r_impulse, prim_table.r_interact)
xlabel("mean appr")
ylabel("rew impulse")
zlabel("rew interaction")

figure
scatter3(prim_table.mean_appr, prim_table.r_interact, prim_table.sesh_var)
xlabel("mean appr")
ylabel("rew interact")
zlabel("session var")

figure
scatter3(prim_table.mean_appr, prim_table.c_interact, prim_table.c_impulse)
xlabel("mean appr")
ylabel("cost interact")
zlabel("cost impulse")

figure
scatter3(prim_table.mean_appr, prim_table.c_interact, prim_table.sesh_var)
xlabel("mean appr")
ylabel("cost interact")
zlabel("session var")


figure
scatter3(prim_table.mean_appr, prim_table.c_interact, prim_table.r_impulse)
xlabel("mean appr")
ylabel("cost interact")
zlabel("rew impulse")


figure
scatter3(prim_table.mean_appr, prim_table.c_impulse, prim_table.r_impulse)
xlabel("mean appr")
ylabel("cost impulse")
zlabel("rew impulse")