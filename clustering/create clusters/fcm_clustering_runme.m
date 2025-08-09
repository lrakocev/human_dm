%% fcm clustering runme
% created by Luis David Davila

%dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\session_clustering';
% dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\sessions_oct_27';
dir = 'C:\Users\lrako\OneDrive\Documents\human dm\test_run\sessions_oct_27';


table_of_human_dir = get_dirs_with_data(dir);
centers = [-7.95484 -0.2253 -13.3709;
    3.83399 10.0293 2.36265;
    2.4325 -0.657053 -2.12422;
    12.4931 10.63 -1.04503;
    3.71879 -16.3966 1.35765];
   % 4.12 2.51 0.26];
call_FCM_for_all_human_data(table_of_human_dir,centers, ...
    strcat("6_cluster_dir_",string(datetime("today",'Format','MM-d-yyyy'))))
