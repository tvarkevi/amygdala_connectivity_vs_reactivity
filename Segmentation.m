function log_fname = Segmentation(iSubject, subject_ID, t1_dir, ~, scans_dir, prefix, study_ID, working_dir, log_fname)

% Preprocessing of the fMRI data: Segmentation of the anatomical data
% into grey-matter (c1), white-matter (c2), and CSF (c3).
%
% Input arguments:
%       iSubject = 85;                          (subject iterator)
%       subject_ID = 'be1l080213';              (subject identifier)
%       t1_dir = '_4_1';                        (anatomical folder)
%       template_fn = 'G:\Classification of Amygdala Reactivity
%           (CAR)\Data\Nifti BETER\be1l080213\be1l080213_5_1\
%           swbe1l080213_5_1-0001.nii'          (reference image; reslice)
%       scans_dir = 'G:\Classification of Amygdala Reactivity
%           (CAR)\Data\Nifti BETER';            (scan data directory)
%       study_ID = 'be';                        (study identifier)
%       working_dir = 'G:\Classification of Amygdala Reactivity
%           (CAR)\Analysis';                    (working directory)
%       log_fname = 'log.txt';                  (log filename)
% Subfunctions: -
%
% List of open inputs:
%       inputs{1} = Segment: Volumes - cfg_files


inputs = {};

% ----- Print progress to command window ----- %
fprintf(['\n' num2str(iSubject) '\tSegmentation of subject: \t' subject_ID '\n']);

% ----- Specify subfolders ----- %
anatomical_folder = [subject_ID t1_dir];

% ----- Define inputs{1}: anatomical scan ----- %
this_scan = dir([scans_dir '\' subject_ID '\' anatomical_folder '\' prefix study_ID '*.nii']);
for iScan = 1:length(this_scan)
    inputs{1} = {[scans_dir '\' subject_ID '\' anatomical_folder '\' this_scan(iScan).name ',1']};
end

% ----- Run preprocessing ----- %
jobfile = {[working_dir '\Segmentation_job.m']};
try
    spm_jobman('run', jobfile, inputs{:});
    % ----- Write progress to log file ----- %
    fileID = fopen([working_dir '\' log_fname], 'a');
    fprintf(fileID, ['\t\tMatlab code executed with no errors\n']);
    fclose(fileID);
catch
    % ----- Write failure to log file ----- %
    fileID = fopen([working_dir '\' log_fname], 'a');
    fprintf(fileID, ['\t\tError at subject: ' subject_ID '\n']);
    fclose(fileID);
end

end
