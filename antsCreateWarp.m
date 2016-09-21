function antsCreateWarp(subject,mriVol,histoVol,path,calcReg)
% antsCreateWarp(subject,mriVol,histoVol,path,calcReg)
%
%  This code anatomically aligns the mri volume anatomy of a subject to the 3D histological reconstuction 
%  generates: new volume fullfile(path, [subject '_3dAllin_Qwarp.nii.gz']);
%  and a transformation: fullfile(path, [subject '_3dAllin_Qwarp_WARP.nii.gz']);
%
% This is run on a per subject basis -- 
% after running this function we will use the transform to register all the
% ROIs to the histological reconstruction
%
% Input:
% subject = name of the subject directory in the histoRecons
% mriVol =  PM subject lincol mri volume 
% histoVol = 3D histological volme
% path = path to directory where the subject's anatomies are kept
% calcReg = 1 or 0, if 1 if calculates the registration files, if 0 it just applies the tranformations
%
%
% example
% antsCreateWarp('pm1','pm1_anat_3dAllin.nii.gz','pm1_histrecon.nii.gz','~/projects/CytoArchitecture/pm1',0);
% 
% MAB March 2016


%runs the ANTs script for volume transformation file generation

outFile = fullfile(path, [subject]);
moveIt = fullfile(path, [mriVol '.nii.gz']);
fixed  = fullfile(path, [histoVol '.nii.gz']);

if calcReg
	cmd = ['antsRegistrationSyNQuick.sh -f ' fixed ' -m ' moveIt ' -d 3 -o ' outFile ' -n 12'];
	display(cmd)	
	system(cmd)
end
% Apply transform

warpTrans = fullfile(path, [subject '1Warp.nii.gz']);
affineMat = fullfile(path, [subject '0GenericAffine.mat']);
input = moveIt;
refFile =fixed;  
output = fullfile(path, [subject, '_deformed.nii.gz']);

cmd= ['antsApplyTransforms -d 3 -i ' input ' -o ' output ' -r ' refFile ' -t ' warpTrans ' -t ' affineMat];
display(cmd)
system(cmd)

