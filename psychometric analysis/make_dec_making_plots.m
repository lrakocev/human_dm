function make_dec_making_plots(appr_table, path_to_save, story_type, want_bdry, want_scale, want_save)

    subid = appr_table.subjectidnumber(1);

    %figure
    cost_levels = 1:1:4;
    reward_levels = 1:1:4;
    
    observed_p_appr = zeros(4);
    rs = repelem(reward_levels,1,length(reward_levels))';
    cs = repmat(cost_levels,1,length(cost_levels))';
    ps = zeros(length(cost_levels)*length(reward_levels),1);
    
    i = 1;
    for r=1:length(reward_levels)
        for c=1:length(cost_levels)
            r_c_table = appr_table(appr_table.cost == c & appr_table.rew == r,:);
            if ~isempty(r_c_table)
                ps(i) = r_c_table.approach_rate ;
            else
                ps(i) = NaN;
            end
            observed_p_appr(c,r) = ps(i);
            i = i+1;
        end
    end

    mean_p = mean(ps,'omitnan');
    ps = fillmissing(ps,'constant',mean_p);

    ps = ps/100;
    observed_p_appr = observed_p_appr / 100;

    if want_scale
        min_p = min(ps);
        max_p = max(ps);
    else
        min_p = 0;
        max_p = 1;
    end

    syms R C
    
    g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
    'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
    'dependent', 'z' );
    
    % Call fit and specify the value of c.
    f = fit( [rs, cs], ps, g, 'StartPoint', [1; 0; 1; 0]); 
    
    fsurf(@(R,C) 1./(1+exp(-f.a_R.*R+f.b_R))*1./(1+exp(f.a_C.*C+f.b_C)), [0, 1])
    frc = 1/(1+exp(-f.a_R*R+f.b_R))*1/(1+exp(f.a_C*C+f.b_C));
    boundary_line = solve(frc==.5, C);

    if want_bdry
        B = tiledlayout(1,2);
        nexttile
    end
    
    imagesc(observed_p_appr);
    colormap("default");
    cb = colorbar;
    cb.Ticks = [min_p (min_p+max_p)/2 max_p];
    caxis([min_p max_p]);
    set(gca,'xtick',[], 'ytick',[], 'FontSize',20, 'YDir','normal');
    ylabel(cb,'approach rate')
    set(gca,'xtick',[], 'ytick',[], 'FontSize',20, 'YDir','normal');
    xlabel('reward')
    ylabel('cost')
    title("3D Psychometric fun. for subject: " + string(subid))
    
    if want_bdry
        nexttile
        x_cont_prelim = linspace(0, 1.5, 1000);
        dashed_curve_prelim = subs(boundary_line, R, x_cont_prelim)*4;
        x_cont = x_cont_prelim(imag(dashed_curve_prelim)==0);
        dashed_curve = dashed_curve_prelim(imag(dashed_curve_prelim)==0);
    
        plot(x_cont*4, dashed_curve, '--k', 'LineWidth',5)
    end

    if want_save
        fighandle = gcf;
        set(gcf,'renderer','Painters')
        saveas(fighandle,strcat(path_to_save,'/',story_type,'/map_', string(subid),'.fig'))
        close all
    end
end
