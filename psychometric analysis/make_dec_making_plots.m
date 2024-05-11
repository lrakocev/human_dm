function make_dec_making_plots(appr_table, path_to_save, story_type, want_bdry, want_scale, want_save)

    subid = appr_table.subjectidnumber(1);
    cost_levels = 1/4:1/4:1;
    reward_levels = 1/4:1/4:1;
    
    observed_p_appr = zeros(4); %4x4 matrix where each row will be the reward level and each column the cost level
    rs = repelem(reward_levels,1,length(reward_levels))'; %repeat the reward levels array 4 times (1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4)
    cs = repmat(cost_levels,1,length(cost_levels))'; %repeat the cost_levels array 4 times (1 2 3 4 1 2 3 4 1 2 3 4 1 2 3 4)
    ps = zeros(length(cost_levels)*length(reward_levels),1); %create a 16x1 array which will be populated later
    
    i = 1;
    for r=1:length(reward_levels)
        for c=1:length(cost_levels)
            r_c_table =  appr_table(appr_table.cost == c & appr_table.rew == r,:);  %get the approach rate when cost = c and rew =r, and store it in ps
           
            if ~isempty(r_c_table)
                ps(i) = r_c_table.approach_rate;
            else
                ps(i) = NaN;
            end

            observed_p_appr(c,r) = ps(i); %each row represents the reward level and each column is the cost 
            i = i+1;
        end
    end

    mean_p = mean(ps,'omitnan'); %calculate the mean of the ps array 
    ps = fillmissing(ps,'constant',mean_p);%fill in any missing values with the mean of the rest

    ps = ps/100; %make the approach percentages in a decimal instead of a whole number
    observed_p_appr = observed_p_appr / 100; %make the matrix of approach_rate a decimal instead of a whole number

    if want_scale
        min_p = min(ps);
        max_p = max(ps);
    else
        min_p = 0;
        max_p = 1;
    end

    syms R C %just variables to be solved for later on, x and y values 
    
    g = fittype( @(a_R,b_R,a_C,b_C,R,C) 1./(1+exp(-a_R.*R+b_R))*1./(1+exp(a_C.*C+b_C)), ...
        'coefficients', {'a_R','b_R','a_C','b_C'}, 'independent', {'R', 'C'}, ...
        'dependent', 'z' );

    % Call fit and specify the value of c.
    f = fit( [rs, cs], ps, g, 'StartPoint', [1; 0; 1; 0]); 
    
    frc = 1/(1+exp(-f.a_R*R+f.b_R))*1/(1+exp(f.a_C*C+f.b_C)); %plug the found sigmoid parameters into the sigmoid formula (its a 2d sigmoid)
    boundary_line = solve(frc==.5, C); %the boundary line is supposed to be when there's 50% approach and 50% avoid
    
    something = [observed_p_appr(4,:);observed_p_appr(3,:);observed_p_appr(2,:);observed_p_appr(1,:)];
    

    [the_min,the_max] = bounds(observed_p_appr,"all");
    imagesc(observed_p_appr); 
    %imagesc(flipud(observed_p_appr));
    colormap("default");
    cb = colorbar;
   
    ylabel(cb,'approach rate')
    xlabel('reward')
    ylabel('cost')
    title("3D Psychometric fun. for subject: " + string(subid))

    set(gca,'YDir','normal')
    
    if want_bdry
        hold on;
        x_cont_prelim = linspace(0, 1.5, 1000); %array from 0 to 1000 with increments of 1.5
        dashed_curve_prelim = subs(boundary_line, R, x_cont_prelim)*4; %substitute R with the value of x in the x_cont_prelim array
        x_cont = x_cont_prelim(imag(dashed_curve_prelim)==0); %keep only the x values where the y-value is a real value
        dashed_curve = dashed_curve_prelim(imag(dashed_curve_prelim)==0);%keep only the y-values where the y-value is real
    
        plot(x_cont*4, dashed_curve, '--k', 'LineWidth',5)
        hold off
    end

    if want_save
        fighandle = gcf;
        set(gcf,'renderer','Painters')
        saveas(fighandle,strcat(path_to_save,'\',story_type,'\map_', string(subid),'.fig'))
        close all
    end

end