function [reaction_time,location] = calc_reaction_time(gaze_data,word_length)

    filtered_idx = (gaze_data(:, 1) ~= -999 & gaze_data(:, 2) ~= -990);
    gaze_data = gaze_data(filtered_idx, :);

    if length(gaze_data) > 10
        location = get_et_locations(gaze_data, word_length);
    
        potential_spots = [];
        w = round(length(gaze_data) / 10);
    
         if w < 25
                read_thresh = .33;
            else
                read_thresh = .1;
         end
    
        for i = w:length(location) - w
		    window = location(i:i+w);
		    num_read = sum(window == "r");
		    num_react = sum(window == "g");
            num_decide = sum(window == "y");
            num_outside = sum(window == "b");
		    prop_read = num_read / length(window);
		    prop_react = (num_react + num_decide) / length(window);
            if prop_read < read_thresh && prop_react > .5
			    potential_spots = [potential_spots; i];
            end
        end
    
        reading_end = min(potential_spots);
        if ~isempty(reading_end)
            reaction_time = length(location) - reading_end;
        else
            reaction_time = w;
        end
    else
        reaction_time = 0;
    end

   % debug_viz(location, gaze_data)

end

function debug_viz(location, gaze_data)

figure
for i = 1:length(location)
    scatter(gaze_data(i,1),gaze_data(i,2),20,location{i})
    hold on
end
hold off

figure
plot(gaze_data(:,1),gaze_data(:,2),'--')

figure
for i = 1:length(location)
    scatter(i, 0, 10,location{i})
    hold on
end
hold off
end