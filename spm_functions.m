% get list of subject folders in unproc dir
[SUBJECT] = string(GetSubDirsFirstLevelOnly(pwd));

% segment
ANALYSIS = 'Segmentation';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "t1_raw.nii";
    subfolder = "/t1/proc/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        segment(file);
    end
    % mv created files to ./t1/proc
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% smooth
ANALYSIS = 'Smooth';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "";
    subfolder = "/t1/proc/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        smooth(file);
    end
    % mv created files to ./t1/proc
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% coregister
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'Coregistration';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "";
    subfolder = "/t1/proc/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% Noramlize
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'Normalization';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "*.txt";
    subfolder = "/t1/raw/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% forward deformation
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'Forward Deformation';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "*.txt";
    subfolder = "/t1/raw/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% brain masking
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'Brain Masking';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "*.txt";
    subfolder = "/t1/raw/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% global asl value
ANALYSIS = 'Global ASL Calculation';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = ""; %%%
    subfolder = "//"; %%%
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% brain vol value
ANALYSIS = 'Brain Volume Calculation';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "*.txt";
    subfolder = "/t1/raw/";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        brain_vol(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% invwarp
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'Inverse Warp to Native Space';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "";
    subfolder = "";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        do_stuff(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

% aal roi
% TODO: create loop/fnc for getting multiple img files from diff
% directories
ANALYSIS = 'ASL ROI Calculation';
for i = 1:length(SUBJECT)
    subj_folder = SUBJECT(i);
    fname = "*";
    subfolder = "";
    target_dir = strcat(subj_folder, subfolder, fname);
    file_arr = dir(target_dir);
    if size(file_arr)>0
        file = file_arr(1).name;
        aal_roi(file);
    end
    completed = (i/length(SUBJECT))*100;
    disp([ANALYSIS ': Completed ' num2str(completed) '%']);
end

function [subDirsNames] = GetSubDirsFirstLevelOnly(parentDir)
    % Get a list of all files and folders in this folder.
    files = dir(parentDir);
    names = {files.name};
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');
    % Extract only those that are directories.
    subDirsNames = names(dirFlags);
end

function aal_mask(gm_file,invwarp)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.util.imcalc.input = {[gm_file,',1'];
                                            [invwarp,',1']
                                            };
    matlabbatch{1}.spm.util.imcalc.output = 'aal_mask';
    matlabbatch{1}.spm.util.imcalc.outdir = {''};
    matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0.3)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = -7;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch)
end

function aal_roi(gm_img,aal_img,DIR)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.util.imcalc.input = {
                                            [gm_img,',1'];
                                            [aal_img,',1']
                                            };
    matlabbatch{1}.spm.util.imcalc.output = 'roi_';
    matlabbatch{1}.spm.util.imcalc.outdir = {[DIR]};
    matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>0.3)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = -7;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch)
end

function asl_global(bmask,output)
    vol = spm_vol(bmask);
    globalvol = spm_global(vol);
    outfile = strcat('global_',output,'.csv');
    % save('global.txt', 'globalvol', '-ascii')
    dlmwrite(outfile, globalvol, 'precision', '%f');
end

function bmask(coreg_fmap,pushfwd_deform)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.util.imcalc.input = {
                                            [coreg_fmap,',1'];
                                            [pushfwd_deform,',1']
                                            };
    matlabbatch{1}.spm.util.imcalc.output = 'bmask';
    matlabbatch{1}.spm.util.imcalc.outdir = {''}; % pass in dir
    matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = -7;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run', matlabbatch)
end

function brain_vol(IMG)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    mask = '/usr/local/MATLAB/spm12/tpm/mask_ICV.nii';
    matlabbatch{1}.spm.util.tvol.matfiles = {[IMG]};
    matlabbatch{1}.spm.util.tvol.tmax = 3;
    matlabbatch{1}.spm.util.tvol.mask = {[mask],',1'};
    matlabbatch{1}.spm.util.tvol.outf = 'brain_vol';
    spm_jobman('run', matlabbatch)
end

function coreg(smoothed_t1_img, fmap, pdmap)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[smoothed_t1_img,',1']}; % reference image = smoothed gray matter image
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = {[fmap,',1']}; % source image = asl fmap or pdmap
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = {[pdmap,',1']}; % other image = pdmap or asl fmap
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 7;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'coreg_';
    spm_jobman('run', matlabbatch)
end

function invwarp(deform_field,smooth_gm,dir)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    mask = '/usr/local/MATLAB/aal_for_SPM12/aal.nii';
    matlabbatch{1}.spm.util.defs.comp{1}.def = {[deform_field]};
    matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {[mask]};
    matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
    matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savepwd = 1; %TODO: CHANGE % save to pwd
    matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {[smooth_gm]};
    matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
    matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
    matlabbatch{1}.spm.util.defs.out{1}.push.prefix = 'invwarp_';
    spm_jobman('run', matlabbatch)
end

function normalise(deform_field, bias_t1, coreg_fmap, coreg_pdmap)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = {[deform_field]};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {
                                                                [bias_t1,',1'];
                                                                [coreg_fmap,',1'];
                                                                [coreg_pdmap,',1']
                                                                };
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                              78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 7;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{2}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{2}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{2}.spm.spatial.smooth.dtype = 0;
    matlabbatch{2}.spm.spatial.smooth.im = 0;
    matlabbatch{2}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run', matlabbatch)
end

function fwd_deform(deform_field,smoothed_gm)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    mask = '/usr/local/MATLAB/spm12/tpm/mas_ICV.nii';
    matlabbatch{1}.spm.util.defs.comp{1}.def = {[deform_field]}; % deformation field (e.g. y file)
    matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {[mask]}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
    matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savepwd = 1; % save to pwd
    matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {[smoothed_gm]}; % smoothed gm file
    matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
    matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
    matlabbatch{1}.spm.util.defs.out{1}.push.prefix = 'fwddeform_';
    spm_jobman('run', matlabbatch);
end

function segment(t1_img)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    tpm_img = '/usr/local/MATLAB/spm12/tpm/TPM.nii';
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {[t1_img,',1']}; % analyze raw t1 img
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1]; % save bias corrected
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,1'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,2'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,3'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,4'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,5'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\atward\Documents\MATLAB\spm12\tpm\TPM.nii,6'}; % TODO: change dir location for this on the vm
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1]; % save forward deformation
    spm_jobman('run', matlabbatch);
end

function smooth(gm_img)
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    clear matlabbatch;
    matlabbatch{1}.spm.spatial.smooth.data = {[gm_img,',1']}; % image to smooth
    matlabbatch{1}.spm.spatial.smooth.fwhm = [5 5 5];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run', matlabbatch);
end
