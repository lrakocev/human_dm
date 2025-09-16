function trial_word_length = create_trial_length_table(story_dir)

cd(story_dir)
task_dirs = string(ls(story_dir));

all_rows = [];
for i = 3:length(task_dirs)
    curr_task = task_dirs(i);
    task_story_dirs = string(ls(curr_task));
    cd(curr_task)
    for j = 3:length(task_story_dirs)
        task_story = task_story_dirs(j);
        cd(task_story)
        try
            lines = readlines("questions.txt");
            for k = 1:length(lines)
                line = lines(k);
                try
                [q_length, r, c] = parse_line(line);
                catch
                    continue
                end
    
                task_name = strip(curr_task);
                if strip(curr_task) == "super_sense"
                    task_name = "obvious_supersense";
                end
             
                row.reward_level = r;
                row.cost_level = c;
                row.q_length = q_length;
                row.task = task_name ;
                row.story = strip(task_story) ;
                row.tasktypedone = "/" + task_name + "/" + strip(task_story);
    
                all_rows = [all_rows; row];
            end
        catch
            cd("../")
            continue
        end
        cd("../")
    end
    cd(story_dir)
end

trial_word_length = struct2table(all_rows);

end

function [q_length, r, c] = parse_line(line)

    split_q = split(line, "?");
    actual_q = strip(split_q(1));
    r_c_val = strip(split_q(2));

    q_length = length(split(actual_q, " ")); 
    r_c_vals = regexp(r_c_val,"(R(?<rew>\d)[,]*\s*C(?<cost>\d)",'names');
    r = str2double(r_c_vals.rew);
    c = str2double(r_c_vals.cost);

end