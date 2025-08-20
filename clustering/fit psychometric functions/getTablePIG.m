function [newTable,rs] = getTablePIG(myDir,is_big)
myFiles = dir(fullfile(myDir,'*.mat')); %gets all .mat files in struct
if is_big
    h = height(myFiles);
    rand_rows = randperm(h, 5000);
    myFiles = myFiles(rand_rows, :);
end
A = [];
B = [];
C = [];
D = [];
E = [];
newTable= table(A,B,C,D,E);
rs = [];
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    %     fprintf(1, 'Now reading %s\n', fullFileName);
%     disp(fullFileName)
    load(fullFileName)
    baseFileName = string(baseFileName);

    R_file = fullfile(myDir + "_r", baseFileName);
    try
        %{
        coeffs = mdl1.Coefficients.Estimate;
        R = mdl1.Rsquared.Ordinary;
        C = [coeffs; 0; string(baseFileName)];
        %}
        C = [mdl1.b1, mdl1.b2, mdl3.b3, 0, baseFileName];
        T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
        load(R_file)
        R = gof1.rsquare;
    catch     
        try
            %{
            coeffs = mdl2.Coefficients.Estimate;
            R = mdl2.Rsquared.Ordinary;
            C = [coeffs; string(baseFileName)];
            %}        
            C = [mdl2.b1, mdl2.b2, mdl2.b3, mdl2.b4, baseFileName]; 
            T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
            load(R_file)
            R = gof2.rsquare;
        catch
            try        
                %{
                coeffs = mdl3.Coefficients.Estimate;
                R = mdl3.Rsquared.Ordinary;
                C = [coeffs; string(baseFileName)];
                %}
                C = [mdl3.b1, mdl3.b2, mdl3.b3, mdl3.b4, baseFileName];  
                T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
                load(R_file)
                R = gof3.rsquare;
            catch
                try        
                    %{
                    coeffs = mdl3.Coefficients.Estimate;
                    R = mdl3.Rsquared.Ordinary;
                    C = [coeffs; string(baseFileName)];
                    %}
                    C = [mdl4.b1, mdl4.b2, mdl4.b3, mdl4.b4, baseFileName]; 
                    T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
                    load(R_file)
                    R = gof4.rsquare;

                catch
                    try        
                        %{
                        coeffs = mdl3.Coefficients.Estimate;
                        R = mdl3.Rsquared.Ordinary;
                        C = [coeffs; string(baseFileName)];
                        %}
                        C = [mdl5.b1, mdl5.b2, mdl5.b3, mdl5.b4, baseFileName];  
                        T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
                        load(R_file)
                        R = gof5.rsquare;
                    catch
                        try        
                            %{
                            coeffs = mdl3.Coefficients.Estimate;
                            R = mdl3.Rsquared.Ordinary;
                            C = [coeffs; string(baseFileName)];
                            %}
                            C = [mdl6.b1, mdl6.b2, mdl6.b3, mdl6.b4, baseFileName];  
                            T = array2table(C,'VariableNames',{'A','B','C', 'D','E'});
                            load(R_file)
                            R = go6.rsquare;
                        catch
                            continue
                        end
                    end
                end
            end
        end
    end
    newTable = [newTable;T];
    rs = [rs; R];
    clear mdl1 mdl2 mdl3 mdl4 mdl5 mdl6
end
end