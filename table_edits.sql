UPDATE human_dec_making_table_utep
SET eye_tracker_data = REPLACE(eye_tracker_data, '''', '""');

UPDATE human_dec_making_table_utep
SET eye_tracker_data = REPLACE(eye_tracker_data, '(', '[');

UPDATE human_dec_making_table_utep
SET eye_tracker_data = REPLACE(eye_tracker_data, ')', ']');

UPDATE human_dec_making_table_utep
SET eye_tracker_data = REPLACE(eye_tracker_data, 'nan', '-999');

ALTER TABLE human_dec_making_table_utep
ALTER COLUMN eye_tracker_data TYPE JSONB
USING eye_tracker_data::JSONB;

-- testing
SELECT
    jsonb_path_query_array(eye_tracker_data, '$.gaze_data.left_pupil_diameter')
FROM human_dec_making_table_utep

-- making changes
alter table human_dec_making_table_utep
add COLUMN left_pupil_diameter type varchar

update human_dec_making_table_utep
set left_pupil_diameter = jsonb_path_query_array(eye_tracker_data, '$.gaze_data.left_pupil_diameter') 

-- HR
select heart_rate_data from human_dec_making_table_utep limit 100; 

ALTER TABLE human_dec_making_table_utep
ALTER COLUMN heart_rate_data TYPE JSONB
USING heart_rate_data::JSONB;

alter table human_dec_making_table_utep 
add COLUMN heart_rate type text

update human_dec_making_table_utep
set heart_rate_arr = jsonb_path_query_array(heart_rate_data, '$.hr') 
