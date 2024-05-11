function filtered_approach = add_pref_column(approach_data, subj_prefs, thresh)

filtered_approach = cell(1,length(approach_data));
for i = 1:length(approach_data)
    appr_table = approach_data{i};
    pref_table = subj_prefs{i};

    sub_table = [];
    if ~isempty(pref_table)  & string(appr_table.subjectidnumber(1)) == string(pref_table.id(1))

        unique_stories = unique(appr_table.story_num);
        for j = 1:length(unique_stories)
            story_num = unique_stories(j);
            story_table = appr_table(appr_table.story_num == story_num, :);
            pref_score = pref_table(pref_table.story_num == story_num, :).score;
            if length(pref_score) > 1
                pref_score = mean(pref_score,'omitnan');
            end
            
            if ~isempty(pref_score) & ~isempty(story_table)
                if pref_score >= thresh
                    story_table.story_prefs = repelem(pref_score,height(story_table),1);
                    sub_table = [sub_table;story_table];
                end
            end
        end
        filtered_approach(i) = {sub_table};
    end
end
end