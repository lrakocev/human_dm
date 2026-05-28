function [adj_results, r_ratings, c_ratings] = process_left_over_ingested_data(save_for_later, table_name)

results = save_for_later;

results = results(results.reward_level ~= "0" & results.decision_made ~= "None", :);

reload_python('ingest_helper');

adj_results = [];
count = 1; 
unique_ids = unique(results.subjectidnumber);
r_ratings = array2table(zeros(0,6),'VariableNames',{'lvl1','lvl2','lvl3','lvl4','tasktype','subid'});
c_ratings = array2table(zeros(0,6),'VariableNames',{'lvl1','lvl2','lvl3','lvl4','tasktype','subid'});
not_processed = {};
next_save_for_later = [];
for i = 1:length(unique_ids)
    id = unique_ids(i);
    id_table = results(results.subjectidnumber == string(id{1}), :);
    unique_stories = unique(id_table.tasktypedone);
    
    for s = 1:length(unique_stories)
        story = unique_stories(s);

        if contains(table_name, "utep")
            story_breakdown = strsplit(string(story),"/");
            try
                task_type = story_breakdown(2);
            catch
                task_type = "";
            end
            story_table = id_table(id_table.tasktypedone == string(story), :);
        else
            % to put into same format as utep data
            story_table = id_table(id_table.tasktypedone == string(story), :);
            task_type = "old_approach_avoid";
            story_table.tasktypedone = repelem("/old_approach_avoid/story_" + string(story), height(story_table))';
        end


        reward_prefs = story_table.reward_prefs(1);
        cost_prefs = story_table.cost_prefs(1);
        trial_date = story_table.trial_start(1);

        if string(cost_prefs{1}) == "[]" || string(reward_prefs{1}) == "[]" %|| trial_date{1} == "0"
            continue
        end

        r_ratings_map = map_ratings(reward_prefs);
        c_ratings_map = map_ratings(cost_prefs);

        r_levels = str2double(unique(story_table.reward_level))';
        c_levels = str2double(unique(story_table.cost_level))';

        try
            r_dict = py.ingest_helper.convert(reward_prefs, r_levels, trial_date);
            c_dict = py.ingest_helper.convert(cost_prefs, c_levels, trial_date);
    
            [r_mat_dict, rev_r_dict] = convert_py_dict(r_dict);
            [c_mat_dict, rev_c_dict] = convert_py_dict(c_dict);
        catch
            not_processed{count} = story_table;
            count = count + 1;
        end

        curr_r_ratings = get_fin_ratings(r_ratings_map, rev_r_dict);
        curr_c_ratings = get_fin_ratings(c_ratings_map, rev_c_dict);

        r_ratings = [r_ratings; table_row_from_dict(curr_r_ratings,task_type,id)];
        c_ratings = [c_ratings; table_row_from_dict(curr_c_ratings,task_type,id)];

        for j = 1:height(story_table)
            curr_r = string(story_table.reward_level(j)); 
            curr_c = string(story_table.cost_level(j));

            try
                story_table.rew(j) = r_mat_dict(curr_r);
            catch
                story_table.rew(j) = 0;
            end
            
            try
               story_table.cost(j) = c_mat_dict(curr_c);
            catch
                story_table.cost(j) = 0;
            end
            
        end

        try
            adj_results = [adj_results; story_table];
        catch
            not_processed{count} = story_table;
            count = count + 1;
        end
        
    end
end
end

function m = map_ratings(pref_cell)

pref_str = pref_cell{1};
pref_str_formatted = strrep(pref_str,"'",'"');
pref_str_formatted = strrep(pref_str_formatted,"None","NaN");
s = jsondecode(pref_str_formatted);
try
    f = length(fieldnames(s));
    keys = string(1:f);
    m = dictionary(keys',struct2cell(s));
catch
    m = dictionary();
end

end

function ratings = get_fin_ratings(ratings_dict, pref_dict)

try
    ratings = dictionary;
    dict_keys = pref_dict.keys();
    for i = 1:length(dict_keys)
        k = dict_keys(i);
        v = pref_dict(k);
        pts = ratings_dict(v);
        ratings(k) = pts;
    end
catch
    ratings = [];
end

end

function row = table_row_from_dict(ratings_dict,tasktype,id)

row = table;
try
    row.lvl1 = str2double(ratings_dict("1"));
    row.lvl2 = str2double(ratings_dict("2"));
    row.lvl3 = str2double(ratings_dict("3"));
    row.lvl4 = str2double(ratings_dict("4"));
catch
    row.lvl1 = NaN;
    row.lvl2 = NaN;
    row.lvl3 = NaN;
    row.lvl4 = NaN;
end
row.tasktype = tasktype;
row.subid = id;

end