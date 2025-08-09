function mk_new_dir_for_pig(new_name, names)

    mkdir(new_name)
    cd(new_name)
   
    for i = 1:length(names)
        name = names(i);
        mkdir(name)
    end
end