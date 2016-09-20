function antsApplyWarp(subject,ROI,histoVol,path,val)

% this code will apply the warp calculated in antsCreateWarp.m to the MPM ROIs
%
%
% Input:
% subject = name of the subject directory in the histoRecons
% ROI =  the MPM ROI you want to register to the histo vol 
% histoVol = 3D histological volume
% path = path to directory where the subject's anatomies are kept
% val = value of the ROI
%
% example
% antsApplyWarp('pm1','MPM_mFus_3dAllin.nii.gz','pm1_histrecon.nii.gz','~/projects/CytoArchitecture/pm1',1);
% 
% MAB 2016 

roi_in = fullfile(path, [ ROI '.nii.gz']);
roi_out = fullfile(path ,[ROI '_' subject '_ANTS.nii.gz']);
refFile = fullfile(path,[histoVol '.nii.gz']);
warpTrans = fullfile(path, [subject '1Warp.nii.gz']);
affineMat = fullfile(path, [subject '0GenericAffine.mat']);

cmd= ['antsApplyTransforms -d 3 -i ' roi_in ' -o ' roi_out ' -r ' refFile ' -t ' warpTrans ' -t ' affineMat];
display(cmd)
system(cmd)


%% change ROI color and threshold
nii = readFileNifti(roi_out);

data = nii.data;
% binarize the output of the nonlinear warping
data(data <.4) = 0;
data(data >= .4) = val;

nii.data = data;
nii.fname = roi_out;
writeFileNifti(nii)

end

