function check_eng_corr(all_data)

%{
all_data = [];
for i = 1:length(all_trial_data)
    curr_data = all_trial_data{i};
    if height(curr_data) > 16*5
        all_data = [all_data; curr_data];
    end
end
%}

approach_data = all_data.cost;
pupil_diam = all_data.pupil_diameter;
story_rel = all_data.story_prefs;
hunger = all_data.hunger;
tiredness = all_data.tiredness;
pain = all_data.pain;
%hr = all_data.heart_rate_data;

plot_corr(approach_data, pupil_diam, "pupil diam")
plot_corr(approach_data, story_rel, "story relevance")
plot_corr(approach_data, hunger, "hunger")
plot_corr(approach_data, tiredness, "tiredness")
plot_corr(approach_data, pain, "pain")
%plot_corr(approach_data, hr)

end

function plot_corr(v1, v2, tit)

figure
r = corr(v1, v2,'rows','complete');
scatter(v1, v2)
title("corr btwn approach rate and " + tit + ": " + string(r))

end
