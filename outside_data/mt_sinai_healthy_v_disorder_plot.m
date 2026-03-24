function mt_sinai_healthy_v_disorder_plot(mt_sinai_trial_table, want_sign, save_to)

%400s = MDD

mt_sinai_trial_table.plot_x = log(abs(mt_sinai_trial_table.x_coord));
mt_sinai_trial_table.plot_y = log(abs(mt_sinai_trial_table.y_coord));
mt_sinai_trial_table.plot_z = log(abs(mt_sinai_trial_table.z_coord)); 

if want_sign
    mt_sinai_trial_table.plot_x = mt_sinai_trial_table.plot_x  .* sign(mt_sinai_trial_table.plot_x );
    mt_sinai_trial_table.plot_y = mt_sinai_trial_table.plot_y  .* sign(mt_sinai_trial_table.plot_y );
    mt_sinai_trial_table.plot_z = mt_sinai_trial_table.plot_z  .* sign(mt_sinai_trial_table.plot_z );
else

disorder_sinai = mt_sinai_trial_table(contains(mt_sinai_trial_table.id, "K4"),:);
healthy_sinai = mt_sinai_trial_table(contains(mt_sinai_trial_table.id, "K5"),:);

scatter3(healthy_sinai.plot_x, healthy_sinai.plot_y, healthy_sinai.plot_z,'g','x')

hold on 
scatter3(disorder_sinai.plot_x, disorder_sinai.plot_y, disorder_sinai.plot_z,'r','x')

legend(["healthy mt sinai"; "mdd mt sinai"])

if want_sign
    title("mt sinai healthy vs disorder - including poorly fit sigmoids - with sign")
else    
    title("mt sinai healthy vs disorder - including poorly fit sigmoids - original")
end

savefig(save_to + "\healthy_v_disorders.fig")
end