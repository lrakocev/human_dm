function story_data = combine_stories_for_map(approach_data, story_type)

all_story_trials = [];
for N = 1:length(approach_data)
    appr_table = approach_data{N};
    correct_type = appr_table(appr_table.story_type == story_type, :);
    all_story_trials = [all_story_trials; correct_type];
end

unique_stories = unique(all_story_trials.story_num);

story_data = cell(1,length(unique_stories));
for N = 1:length(unique_stories)
    story = unique_stories(N);
    appr_table = all_story_trials(all_story_trials.story_num == story, :);
    num_ids = length(unique(appr_table.subjectidnumber));
    combined_table = [];
    for r = 1:4
        for c = 1:4
            all_r_c = appr_table(appr_table.rew == r & appr_table.cost == c, :);
            if ~isempty(all_r_c)
                all_r_c.timing(all_r_c.timing==-1) = nan;
                all_r_c.approach_rate(isnan(all_r_c.timing)) = nan;
                r_c_row = all_r_c(1,:);
                r_c_row.subjectidnumber = story + " , n = " + string(num_ids);
                r_c_row.approach_rate = mean(all_r_c.approach_rate, 'omitnan');
                r_c_row.timing = mean(all_r_c.timing, 'omitnan');
                combined_table = [combined_table; r_c_row];
            end
        end
    end
    story_data{N} = combined_table;
end


end