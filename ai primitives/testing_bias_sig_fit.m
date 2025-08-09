function model_data = testing_bias_sig_fit(sigmoid_table, n, save_to)

    downsample_n = round(height(sigmoid_table) / n);
    downsampled = downsample(sigmoid_table, downsample_n);
    model_data = []; 

    for y = 1:height(downsampled)
        row = downsampled(y,:);
        all_appr = [row.lvl1 row.lvl2 row.lvl3 row.lvl4];
        for sig_type = 2:4

            [a,b,c] = fit_sigmoid_w_diff_methods([1 2 3 4], all_appr,sig_type);
            row.a = a;
            row.b = b;
            row.c = c;
            row.type = sig_type;
            model_data = [model_data; row];

         
       end
    end
    
    save(save_to + ".mat",'model_data')
    
    % simple plot
    
    figure
    plot_n = height(model_data);
    
    hs = [];
    for i = 1:plot_n
        row = model_data(i,:);
        a = log(abs(row.a));
        b = log(abs(row.b));
        c = log(abs(row.c));

        scatter3(a,b,c);
        hold on    
    end
    title("testing bias w sigmoid fit")
end