select * from human_dec_making_table_utep limit 10;

--- adding the columns initially

alter TABLE human_dec_making_table_utep
add COLUMN eye_tracker_data_json text;

ALTER TABLE human_dec_making_table_utep
ALTER COLUMN eye_tracker_data_json TYPE text
USING eye_tracker_data_json::JSONB;

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json  = eye_tracker_data;

---- updating 

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json = REPLACE(eye_tracker_data_json, '''', '""');

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json = REPLACE(eye_tracker_data_json, '""', '""');

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json = REPLACE(eye_tracker_data_json, '(', '[');

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json = REPLACE(eye_tracker_data_json, ')', ']');

UPDATE human_dec_making_table_utep
SET eye_tracker_data_json = REPLACE(eye_tracker_data_json, 'nan', '-999');

alter TABLE human_dec_making_table_utep
alter COLUMN eye_tracker_data_json type jsonb
using eye_tracker_data_json::jsonb;

-- testing
SELECT
    jsonb_path_query_array(eye_tracker_data_json, '$.gaze_data.left_pupil_diameter')
FROM human_dec_making_table_utep

-- making changes
alter table human_dec_making_table_utep
add COLUMN left_pupil_diameter type varchar

update human_dec_making_table_utep
set left_pupil_diameter = jsonb_path_query_array(eye_tracker_data_json, '$.gaze_data.left_pupil_diameter') 

update human_dec_making_table_utep
set left_gaze_coords = jsonb_path_query_array(eye_tracker_data_json, '$.gaze_data.left_gaze_point_on_display_area') 

-- HR

alter TABLE human_dec_making_table_utep
add COLUMN heart_rate_json text;

UPDATE human_dec_making_table_utep
SET heart_rate_json  = heart_rate_data;

UPDATE human_dec_making_table_utep
SET heart_rate_json = REPLACE(heart_rate_data, 'None', '[]');


ALTER TABLE human_dec_making_table_utep
ALTER COLUMN heart_rate_json TYPE JSONB
USING heart_rate_data::JSONB;

update human_dec_making_table_utep
set raw_heart_rate = jsonb_path_query_array(heart_rate_json, '$.hr') 

-- afterwards 

ALTER TABLE human_dec_making_table_utep
ALTER COLUMN heart_rate_data TYPE text;

ALTER TABLE human_dec_making_table_utep
ALTER COLUMN eye_tracker_data TYPE text;

select * from human_dec_making_table_utep where trial_start like '%2026%' limit 100;
select * from human_dec_making_table_utep where (subjectidnumber,story_num) in ('28690', '/social/story_17');

