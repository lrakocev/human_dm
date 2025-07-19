function mk_new_dir_for_pig(new_name)

    mkdir(new_name)
    cd(new_name)
   
    mkdir 'cannon'
    mkdir 'pig'
    mkdir 'cannon_r'
    mkdir 'pig_r'
end