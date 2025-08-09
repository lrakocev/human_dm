function [r_nout, c_nout] = calc_story_power(clean_approach_data)

subj_r1s = [];
subj_r4s = [];
subj_c1s = [];
subj_c4s = [];

for i = 1:length(clean_approach_data)

    approach_data = clean_approach_data{1,i};
    unique_stories = unique(approach_data.story_num);

    for j = 1:length(unique_stories)
        story = unique_stories(j);
        r1 = mean((approach_data(approach_data.rew == 1 & approach_data.cost ==4 & ...
            approach_data.story_num == story,:).approach_rate),'omitnan');
        r4 = mean((approach_data(approach_data.rew == 4 & approach_data.cost == 1 & ...
            approach_data.story_num == story,:).approach_rate),'omitnan');
        
        c1 = mean((approach_data(approach_data.cost == 1 & ...
            approach_data.story_num == story,:).approach_rate),'omitnan');
        c4 = mean((approach_data(approach_data.cost == 4 & ...
            approach_data.story_num == story,:).approach_rate),'omitnan');
    
        subj_r1s = [subj_r1s; r1];
        subj_r4s = [subj_r4s; r4];
        subj_c1s = [subj_c1s; c1];
        subj_c4s = [subj_c4s; c4];
    end

end

[mu_r1, sd_r1] = get_summary(subj_r1s);
[mu_r4, sd_r4] = get_summary(subj_r4s);

r_nout = sampsizepwr('t',[mu_r1, sd_r1],mu_r4,0.9);

[mu_c1, sd_c1] = get_summary(subj_c1s);
[mu_c4, sd_c4] = get_summary(subj_c4s);

c_nout = sampsizepwr('t',[mu_c1, sd_c1],mu_c4,0.9);

end

function [mu, sd] = get_summary(input)

mu = mean(input,'omitnan');
sd = std(input,'omitnan');
end