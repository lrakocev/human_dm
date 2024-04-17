function means_2d =  prep_means()

max_v_shift_start_means = create_start_means([-7 0; 3.5 7; 14 11; 3.3 -15]);
max_v_shift_alt_means =  create_start_means([-7 0; 3.5 7; 14 11]);

max_v_slope_start_means = create_start_means([-9 -14; 3.5 1.5; 14 -0.5;-5 0.2]);
max_v_slope_alt_means = create_start_means([-9 -14; 3.5 1.5; 14 -0.5]);

shift_v_slope_start_means = create_start_means([0 -13; 6.3 1.5; 13.4 0.7; -14.5 1.3]);
shift_v_slope_alt_means = create_start_means([0 -13; 6.3 1.5; 13.4 0.7]);

means_2d{1} = max_v_shift_start_means;
means_2d{2} = max_v_shift_alt_means;
means_2d{3} = max_v_slope_start_means;
means_2d{4} = max_v_slope_alt_means;
means_2d{5} = shift_v_slope_start_means;
means_2d{6} = shift_v_slope_alt_means;

end