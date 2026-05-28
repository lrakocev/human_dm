function make_dec_making_plots(appr_table, path_to_save, story_type, want_bdry, want_scale, want_save,subtit, for_ml, base_db, varargin)

    subid = appr_table.subjectidnumber(1);
    story_num = appr_table.story_num(1);
    if ~isempty(varargin{1})
        variable = string(varargin{1,1}{1,1});
    else
        variable = "approach_rate";
    end


    cost_levels = 1/4:1/4:1;
    reward_levels = 1/4:1/4:1;
    
    observed_p_appr = zeros(4); %4x4 matrix where each row will be the reward level and each column the cost level
    rs = repelem(reward_levels,1,length(reward_levels))'; %repeat the reward levels array 4 times (1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4)
    cs = repmat(cost_levels,1,length(cost_levels))'; %repeat the cost_levels array 4 times (1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4)
    ps = zeros(length(cost_levels)*length(reward_levels),1); %create a 16x1 array which will be populated later
    
    try
    i = 1;
    lvls_for_excel = [];
    for r=1:length(reward_levels)
        for c=1:length(cost_levels)
            lvls_for_excel = [lvls_for_excel; "(R" + r + ", C" + c + ")"];
            r_c_table =  appr_table(appr_table.cost == c & appr_table.rew == r,:);
            if ~isempty(r_c_table)
                ps(i) = mean(r_c_table.(variable),'omitnan');
            
            else
                ps(i) = NaN;
            end
            %ps(i) = 1./(1+exp(-2*r+3))*1./(1+exp(.6*c-2));
            observed_p_appr(c,r) = ps(i); %each row represents the reward level and each column is the cost 
            i = i+1;
        end
    end
    catch 
        return 
    end

    mean_p = mean(ps,'omitnan'); %calculate the mean of the ps array 
    ps = fillmissing(ps,'constant',mean_p);%fill in any missing values with the mean of the rest

    if variable == "approach_rate"
        ps = ps/100; %make the approach percentages in a decimal instead of a whole number
        observed_p_appr = observed_p_appr / 100; %make the matrix of approach_rate a decimal instead of a whole number
    end

    if want_scale
        min_p = min(ps);
        max_p = max(ps);
    else
        if length(varargin{1,1}) > 1
            min_p = varargin{1,1}{1,2};
            max_p = varargin{1,1}{1,3};
        else
            min_p = 0;
            max_p = 1;
        end
    end

    syms R C %just variables to be solved for later on, x and y values 
    
    g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
        'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z' );

    try
    % Call fit and specify the value of c.
    f = fit( [rs, cs], ps, g, 'StartPoint', [1; 0; 1; 0]); 
    
    % fsurf(@(R,C) 1./(1+exp(-f.a_R.*R+f.b_R))*1 ./ (1+exp(f.a_C.*C+f.b_C)), [0, 1]) %plots the background/ doesnt seem to matter
    frc = 1/(1+exp(-f.a_R*R+f.b_R))*1/(1+exp(f.a_C*C+f.b_C)); %plug the found sigmoid parameters into the sigmoid formula (its a 2d sigmoid)
    boundary_line = solve(frc==.5, C); %the boundary line is supposed to be when there's 50% approach and 50% avoid
    %line 49 puts .5 on the left hand side of 48, we substitute .5 for frc gives a line which is a reward as a function of cost
    catch
        return
    end
    % B = tiledlayout(1,2);


    [the_min,the_max] = bounds(observed_p_appr,"all");
    imagesc(observed_p_appr);%original
    % imagesc(flipud(observed_p_appr)) 
    colormap default
    if ~for_ml
        cb = colorbar;
        try
        cb.Ticks = [min_p (min_p+max_p)/2 max_p];
        clim([min_p max_p]);
        catch
            
        end
        % % set(gca,'xtick',[], 'ytick',[], 'FontSize',20, 'YDir','normal');
        ylabel(cb,'approach rate')
        % % set(gca,'xtick',[], 'ytick',[], 'FontSize',20, 'YDir','normal');
        xlabel('reward')
        ylabel('cost')
        title("3D Psychometric fun. for subject " + string(subid) + ", story type " + ...
            story_type);
        subtitle(subtit)
    end


    set(gca,'YDir','normal')
    
    if want_bdry
        % nexttile
        hold on;
        x_cont_prelim = linspace(0, 1.5, 1000); %array from 0 to 1000 with increments of 1.5
        dashed_curve_prelim = subs(boundary_line, R, x_cont_prelim)*4; %substitute R with the value of x in the x_cont_prelim array
        x_cont = x_cont_prelim(imag(dashed_curve_prelim)==0); %keep only the x values where the y-value is a real value
        dashed_curve = dashed_curve_prelim(imag(dashed_curve_prelim)==0);%keep only the y-values where the y-value is real
    
        plot(x_cont*4, dashed_curve, '--k', 'LineWidth',5)
        
        % ylim([0,1]);
        % xlim([0,1]);
    end

    fighandle = gcf;
    set(gcf,'renderer','Painters')
    if want_save
        if ~for_ml
            new_dir = strcat(path_to_save,'\',variable);
            mkdir(new_dir)

            saveas(fighandle,strcat(path_to_save,'\', variable,'\map_', story_type, '_', string(subid), '_', string(story_num),'.fig'),"fig")
        
            appr_table = appr_table(~isnan(appr_table.(variable)), :);
            table_to_write = appr_table(:,ismember(appr_table.Properties.VariableNames, {'subjectidnumber','rew','cost',char(variable)}));

            writetable(table_to_write, path_to_save + "\" + story_type + "_dec_making_maps.xlsx", ...
                "Range", "A1", "Sheet", variable);
            
            code_info = ["produced by: make_dec_making_plots.m"; "db: load('" + base_db + "')"; "boundary line: frc = 1/(1+exp(-f.a_R*R+f.b_R))*1/(1+exp(f.a_C*C+f.b_C));"];
            writematrix(code_info, path_to_save + "\" + story_type + "_dec_making_maps.xlsx", ...
                "Range", "F1", "Sheet", variable);
        
                
        end
        
        saveas(fighandle,strcat(path_to_save,'\',story_type,'\map_',  story_type, '_', string(subid), '_', string(story_num),'.png'),"png")
        close all
        end

end