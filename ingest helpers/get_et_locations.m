function location = get_et_locations(gaze_data, word_length)

    x_coords = gaze_data(:,1)*100;
    y_coords = gaze_data(:,2)*-100;
    gaze_data = [x_coords y_coords];
	max_y = -10; %max(y_coords);
	min_x = min(x_coords);
    
    added_q_len = get_added_q_len(word_length);

    read_rect = get_reading_box(max_y, added_q_len);
    react_rect = get_reaction_box(max_y, added_q_len);
    dec_rect = get_dec_box(max_y, added_q_len);

    location = [];
    for i = 1:length(x_coords)
        pt = gaze_data(i,:);
		if rect_contains(read_rect, pt)
			location = [location; "r"];
        elseif rect_contains(react_rect, pt)
			location = [location; "g"];
        elseif rect_contains(dec_rect, pt)
			location = [location; "y"];
        else
			location = [location; "b"];
        end
    end
end

function corners = get_reading_box(max_y, added_q_len)
	 corners = [-5, max_y, 97, 12 + added_q_len];
end

function corners = get_reaction_box(max_y, added_q_len)
    corners = [35, max_y-(added_q_len+13), 20, 7]; % max_y-added_q_len-13
end

function corners = get_dec_box(max_y, added_q_len)
 corners = [40, max_y-(added_q_len+21), 10, 15]; % max_y-added_q_len-21
end

function logic = rect_contains(rect, pt)
	x_logic = rect(1) < pt(1)  & pt(1) < rect(1)+rect(3);
    y_logic = rect(2) > pt(2) & pt(2) > rect(2)-rect(4);

    logic = x_logic & y_logic;
end

function line_length = get_added_q_len(word_length)

    if ~isnan(word_length)
        line_length = round(word_length / 16);
    else
        line_length = 0;
    end

end
