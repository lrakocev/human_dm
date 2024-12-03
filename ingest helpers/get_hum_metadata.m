function results = get_hum_metadata()

datasource = 'PostgreSQL30'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"
conn = database(datasource,username,password); %creates the database connection

%query = "Select * FROM human_dec_making_table";
query = "SELECT subjectidnumber, tasktypedone, hunger, tired, pain, stress, sex, genderid, age, race, ethnicity, relationship_status, sexual_orientation, education, college, major FROM human_dec_making_table_utep";
results = fetch(conn,query);

results = unique(results);

end