function afniCreateAffine(subject,mriVol,histoVol,path)
% vol2volWarp(subject,mriVol,histoVol,path)
%
%  This code creates an affine tranform to roughly align the mri volume anatomy of a PM subject to the 3D histological reconstuction 
%  generates a new volume: fullfile(path, [subject '_3dAllin_Qwarp.nii.gz']);
%  and a transformation file: fullfile(path, [subject '.param.1D']); The .param.1D file
%  will be needed for the function afniApplyAffine.m
%
%  Input:
%  subject = name of the subject directory in the histoRecons
%  mriVol =  PM subject MRI anatomical
%  histoVol = 3D histological reconstruction volume
%  path = path to directory where the subject's anatomy files live
%
%  example
%  vol2volWarp('pm1','pm1_anatomy.nii.gz','pm1_histcorecon.nii.gz','~/projects/CytoArchitecture/segmentations/histoRecons/pm1');
% 
%  MAB March 2016

system('source /etc/afni/afni.sh')

%% run 3dAllineate from afni  -12 param alignment of the volumes
Allineate_out = fullfile(path, [subject '_3dAllin.nii.gz']);
inFile = fullfile(path, mriVol);
refFile= fullfile(path, histoVol);
oneDparam_out = fullfile(path, subject);

cmd = ['3dAllineate -prefix ' Allineate_out ' -base ' refFile ' -input ' inFile ' -cmass -twopass -1Dparam_save ' oneDparam_out];
display(cmd)
system(cmd)
