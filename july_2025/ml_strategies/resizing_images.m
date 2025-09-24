s=dir;
idx=~startsWith({s.name},'.') & [s.isdir];
folders={s(idx).name};

nfolders = length(folders);
for J = 1 : nfolders
   thisfolder = folders(J);
   fileinfo = dir(thisfolder{1});
   fileinfo([fileinfo.isdir]) = [];   %remove . .. and other folders
   nfiles = length(fileinfo);
   for K = 1 : nfiles
       thisfile = fullfile(thisfolder{1}, fileinfo(K).name);
       thisimg = imread(thisfile);
       thisimg_smaller = imresize(thisimg, 0.5);
       %you would now want to save thisimg28... but you did not say WHERE
       %you want to save it
       imwrite(thisimg_smaller, "C:\Users\lrako\OneDrive\Documents\human dm\july_2025\dec_making_maps\" + thisfile)
   end
end