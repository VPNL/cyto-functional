function afniApplyAffine(subject,ROI,histoVol,path,val)

% This function will apply the affine transform created in
% afniCreateAffine.m to a given ROI 
%
% all the relevant files (anatomicals, ROIs and, tranformation files)
% should be in the same directory (this is the path input). 
%
% Input:
% subject = name of the subject directory in the histoRecons
% ROI =  the MPM ROI you want to register to the histo vol 
% histoVol = 3D histological volume
% path = path to directory where the subject's anatomies are kept
% val = the nonzero value in the binary ROI output. 
% example
% vol2volWarp('pm1','rh_MPM_mFus.nii.gz','pm1_historecon.nii.gz','~/projects/CytoArchitecture/segmentations/histoRecons/pm1',1);
% MAB 2016  

system('source /etc/afni/afni.sh')

%% run 3dAllineate from afni
roi_out = fullfile(path,[ROI '_' subject '_3dAllin.nii.gz']);
histo_vol = fullfile(path,histoVol);
roi_in = fullfile(path, [ ROI '.nii.gz']);
xfrm_1D = fullfile(path, [subject '.param.1D']);


cmd = ['3dAllineate -prefix ' roi_out ' -base ' histo_vol '  -input ' roi_in ' -1Dparam_apply ' xfrm_1D];
display(cmd)
system(cmd)


%% if you would want to try it with running 3dQwarp from afni
% xfrm_Qwarp = fullfile(path, [subject '_3dAllin_Qwarp_WARP.nii.gz']);
% 
% roi_Qwarp = fullfile(path, 'mpmROIs',[ROI '_' subject '_Qwarp.nii.gz']);
% cmd = ['3dNwarpApply -nwarp ' xfrm_Qwarp ' -source ' roi_out ' -prefix ' roi_Qwarp];
% 
% display(cmd)
% system(cmd)	
% 
%% change ROI color
nii = readFileNifti(roi_out);

data = nii.data;
% clean up the interpolations
data(data <.3) = 0;
data(data >= .3) = val;

nii.data = data;
nii.fname = roi_out;
writeFileNifti(nii)

end

