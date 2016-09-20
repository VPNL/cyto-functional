function afniCreateAffine(subject,mriVol,histoVol,path)
% vol2volWarp(subject,mriVol,histoVol,path)
%
%  This code creates an affine tranform to roughly align the mri volume anatomy of a PM subject to the 3D histological reconstuction 
%  generates a new volume: fullfile(path, [subject '_3dAllin_Qwarp.nii.gz']);
%  and a transformation file: fullfile(path, [subject '.param.1D']); This
%  will be needed for the function afniApplyAffine.m
%
%  Input:
%  subject = name of the subject directory in the histoRecons
%  mriVol =  PM subject MRI anatomical
%  histoVol = 3D histological reconstruction volume
%  path = path to directory where the subject's anatomy files live
%
%  example
%  vol2volWarp('pm1494','pm1494histo_invNlin_corr_small_histcorr_pad_lin2colin27.nii.gz','pm1494histo_invNlin_corr_small_histcorr_pad.nii.gz','~/projects/CytoArchitecture/segmentations/histoRecons/pm1494');
% 
%  MB March 2016

system('source /etc/afni/afni.sh')

%% run 3dAllineate from afni  -12 param alignment of the volumes
Allineate_out = fullfile(path, [subject '_3dAllin.nii.gz']);
inFile = fullfile(path, mriVol);
refFile= fullfile(path, histoVol);
oneDparam_out = fullfile(path, subject);

cmd = ['3dAllineate -prefix ' Allineate_out ' -base ' refFile ' -input ' inFile ' -cmass -twopass -1Dparam_save ' oneDparam_out];
display(cmd)
system(cmd)
% %% if you want to try it with running 3dQwarp from afni
% %% run 3dQwarp from afni - nolinear alignment
% Qwarp_out = fullfile(path, [subject '_3dAllin_Qwarp.nii.gz']);
% cmd = ['3dQwarp -workhard -minpatch 5 -prefix ' Qwarp_out '  -source  ' Allineate_out ' -base ' refFile];
% display(cmd)
% system(cmd)	
