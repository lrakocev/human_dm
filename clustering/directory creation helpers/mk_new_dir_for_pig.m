function mk_new_dir_for_pig(new_name)

    mkdir(new_name)
    cd(new_name)
   
    mkdir 'cannon'
    mkdir 'relevance_pig'
    mkdir 'pupil_pig'
    mkdir 'cannon_r'
    mkdir 'relevance_pig_r'
    mkdir 'pupil_pig_r'
end