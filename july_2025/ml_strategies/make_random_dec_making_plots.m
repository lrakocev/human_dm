function make_random_dec_making_plots(path_to_save, num)

    observed_p_appr = rand(4,4);

    imagesc(observed_p_appr);
    colormap("default");
    set(gca,'YDir','normal')
    
    fighandle = gcf;
    set(gcf,'renderer','Painters')

    saveas(fighandle,strcat(path_to_save,'\random_map_' + string(num) + '.png'),"png")        
    close all
end