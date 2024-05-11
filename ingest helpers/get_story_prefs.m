function pref_table = get_story_prefs(subj_table)

id = subj_table.subjectidnumber(1);
unique_prefs = unique(subj_table.story_prefs);

pref_table = [];
for i = 1:length(unique_prefs)
    pref_list = unique_prefs{i};
    pref_split = split(pref_list, ",");
    for j = 1:length(pref_split)
        pref = pref_split{j};
        score_split = split(pref, ":");
        story = score_split(1);
        if length(score_split) >=2 
            score = score_split(2);
            row.story_num = clean_score(story);
            row.score = str2double(clean_score(score));
            row.id = id;
    
            pref_table = [pref_table; row];
        end

    end
end

if ~isempty(pref_table)
    pref_table = struct2table(pref_table);
    pref_table = unique(pref_table);
end

end

function stripped_score = clean_score(score_str)

stripped_score1 = strrep(score_str,"'","");
stripped_score2 = strrep(stripped_score1,"}","");
stripped_score3 = strrep(stripped_score2,"{","");
stripped_score = strip(stripped_score3);
            
end