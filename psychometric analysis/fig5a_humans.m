ex_id = 45643;
combined_data = appr_avoid_combined_data;
for N = 1:length(combined_data)
    appr_table = combined_data{N};
    if ~isempty(appr_table)
    subid = appr_table.subjectidnumber(1);
    if subid == ex_id
    
    cost_levels = 1/4:1/4:1;
    reward_levels = 1/4:1/4:1;
    
    % fake data to illustrate
        observed_p_appr = zeros(4);
    rs = repelem(reward_levels,1,length(reward_levels))';
    cs = repmat(cost_levels,1,length(cost_levels))';
    ps = zeros(length(cost_levels)*length(reward_levels),1);
    
    i = 1;
    for r=1:length(reward_levels)
        for c=1:length(cost_levels)
            ps(i) = appr_table(appr_table.cost == c & appr_table.rew == r,:).approach_rate ;
            observed_p_appr(c,r) = ps(i);
            i = i+1;
        end
    end
    
    ps = ps / 100;
    observed_p_appr = observed_p_appr / 100;
    
    syms R C
    
    g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
            'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
            'dependent', 'z' );
    
    % Call fit and specify the value of c.
    f = fit( [rs, cs], ps, g, 'StartPoint', [1; 0; 1; 0] );
    
    fsurf(@(R,C) 1./(1+exp(-f.a_R.*R+f.b_R))*1./(1+exp(f.a_C.*C+f.b_C)), [0, 1])
    frc = 1/(1+exp(-f.a_R*R+f.b_R))*1/(1+exp(f.a_C*C+f.b_C));
    boundary_line = solve(frc==.5, C);
    
    B = tiledlayout(1,3);
    
    % Plotting
    nexttile
    imagesc(observed_p_appr);
    colormap('default');
    cb = colorbar;
    cb.Ticks = [0 0.5 1];
    clim([0 1]);
    hold on
    x_cont_prelim = linspace(0, 1.5, 1000); %array from 0 to 1000 with increments of 1.5
    dashed_curve_prelim = subs(boundary_line, R, x_cont_prelim)*4;
    x_cont = x_cont_prelim(imag(dashed_curve_prelim)==0);
    dashed_curve = dashed_curve_prelim(imag(dashed_curve_prelim)==0);
    %plot(x_cont*4, dashed_curve, ':k', 'LineWidth',5)
    %hold on
    plot(x_cont_prelim, dashed_curve_prelim, ':k', 'LineWidth', 5)
    hold on
    %rectangle('Position',[0.5 1.5 4.0 1], 'LineWidth',5)
    ylabel(cb,'approach rate')
    set(gca,'xtick',[], 'ytick',[], 'FontSize',20, 'YDir','normal');
    xlabel('reward')
    ylabel('cost')
    title("3D Psychometric fun. for subject id:" + string(subid));
    hold off
    
    % psychometric functions
    colors = ["r","g","b","c"];
    nexttile
    rev = 1/4:1/4:1;
    for rew=1:4
        R_ = rev(rew);
        scatter(rev, observed_p_appr(:,rew),'filled', colors(rew))
        hold on
        fplot(1./(1+exp(-f.a_R.*R_+f.b_R))*1./(1+exp(f.a_C.*C+f.b_C)),colors(rew))
        title("2 var choice profile (cost)")
        xlim([-5 2])
        hold on
    end
    hold off
    
    nexttile
    for cost=1:4
        C_ = rev(cost);
        scatter(rev,observed_p_appr(cost, :),'filled', colors(cost))
        hold on
        fplot(1./(1+exp(-f.a_R.*R+f.b_R))*1./(1+exp(f.a_C.*C_+f.b_C)), colors(cost))
        title("2 var choice profile (benefit)")
        xlim([-5 2])
        hold on
    end
    hold off
    savefig('final_run/stacked_functions/'+string(subid) + "_map.fig")
    end
    end
end