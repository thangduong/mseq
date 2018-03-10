function compute_lead_field;

global workfile;
load(workfile);

%%%%% WAY too much b.s. just to get MRI voxel size...
global st;
fov  = get(findobj('Tag','field_of_view'),'String');
width = get(findobj('Tag','slice_width'),'String');
%Check for invalid entry
if (isempty(str2num(fov))==1 | isempty(str2num(width))==1)
	msgbox('Slice width or field of view cannot be empty','ERROR','error')
	return
end
%get volume from the 3D image
V=spm_vol(st.vols{1}.fname);
Y = spm_read_vols(V);
DIM=size(Y);
[VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP] = header(fov,width,DIM);
% clear V Y SCALE TYPE OFFSET DESCRIP;
%%%%% end b.s.

%%%%% user selection of reconstruction voxel size
desiredvoxelsize = inputdlg('Select reconstruction voxel 
size:','What''ll it be, huh?',1,{'5'});
if(isempty(desiredvoxelsize))
	return;
else
     reconstruction_size = str2num(char(desiredvoxelsize));
     MEG_VOX = [reconstruction_size reconstruction_size reconstruction_size];
end


%%%%%%%%%%%%%%% convert MEG parameters and voxel locations to MRI mm %%%%%%%%%
coil_coord_vx = transform_matrix_final_vx * [1000*coil_coord 
ones(length(coil_coord),1)]';
coil_coord_vx = coil_coord_vx(1:3,:)';
coil_coord = transform_matrix_final * [1000*coil_coord 
ones(length(coil_coord),1)]';
coil_coord = coil_coord(1:3,:)';

% remove translation from transformation so normal_direction vectors 
just rotate
transform_matrix_vector = transform_matrix_final;
transform_matrix_vector(:,4) = [0;0;0;1];
normal_direction = transform_matrix_vector * [normal_direction 
ones(length(normal_direction),1)]';
normal_direction = normal_direction(1:3,:)';
% nrm = sqrt(sum(normal_direction.^2,2))
% normal_direction = [normal_direction(:,1)./nrm 
normal_direction(:,2)./nrm normal_direction(:,3)./nrm];


helm(:,1:3) = coil_coord;
helm(:,10:12) = normal_direction;

lsc = transform_matrix_final * [1000*lsc 1]';
lsc = lsc(1:3)';

[i,j,k]=ind2sub(size(VOI),find(VOI));
% VOIvoxels = [(i-ORIGIN(1))*VOX(1) (j-ORIGIN(2))*VOX(2) (k-ORIGIN(3))*VOX(3)];
VOIvoxels = [i j k];

% fit to desired MEG voxel grid, shift such that origin is (0,0,0)mm
i = MEG_VOX(1)*round(i/MEG_VOX(1)) - ORIGIN(1)*VOX(1);
j = MEG_VOX(2)*round(j/MEG_VOX(2)) - ORIGIN(2)*VOX(2);
k = MEG_VOX(3)*round(k/MEG_VOX(3)) - ORIGIN(3)*VOX(3);

% remove duplicate voxels from fit, keep track of mapping with voxelindex
[voxels crap voxelindex] = unique([i j k],'rows');

% compatibility hack -- REMOVE SOMEDAY
% scaninfo = [-0.05 0.05 0.02 0.05 -0.02 0.12 0.005];

clear i j k;
save voxels.mat voxels VOIvoxels voxelindex MEG_VOX;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Precompute Leadfield (4.1) 
%%%%%%%%%%%%%%%%%
     Nvoxels=size(voxels,1);

     tic

     Lp1=zeros(size(helm,1),2,Nvoxels);  % Lead field for 306


%%%%%%%%%%%%%% DISPLAY SENSORS
            switch TYPE
             case 2  % uint8
                 maxvalue = uint8(realmax);
             case 4  % int16
                 maxvalue = 600;  % arbitrary value chosen to be above 
typical range of values
             otherwise  % assume 255 otherwise
                 maxvalue = 255;
         end;

         for i=1:size(coil_coord_vx,1)
             if (coil_coord_vx(i,1)>1 & coil_coord_vx(i,2)>1 & 
coil_coord_vx(i,3)>1 ...
                 & coil_coord_vx(i,1)<DIM(1) & 
coil_coord_vx(i,2)<DIM(2) & coil_coord_vx(i,3)<DIM(3))
                     %Paint the headshape points that are brought to 
MRI space with brightest intensity in the
                     % the image
 
Y(ceil(coil_coord_vx(i,1)),ceil(coil_coord_vx(i,2)),ceil(coil_coord_vx(i,3)))=maxvalue;
 
Y(ceil(coil_coord_vx(i,1)),ceil(coil_coord_vx(i,2)),floor(coil_coord_vx(i,3)))=maxvalue;
 
Y(ceil(coil_coord_vx(i,1)),floor(coil_coord_vx(i,2)),ceil(coil_coord_vx(i,3)))=maxvalue;
 
Y(floor(coil_coord_vx(i,1)),ceil(coil_coord_vx(i,2)),ceil(coil_coord_vx(i,3)))=maxvalue; 

 
Y(floor(coil_coord_vx(i,1)),floor(coil_coord_vx(i,2)),ceil(coil_coord_vx(i,3)))=maxvalue;
 
Y(floor(coil_coord_vx(i,1)),ceil(coil_coord_vx(i,2)),floor(coil_coord_vx(i,3)))=maxvalue;
 
Y(ceil(coil_coord_vx(i,1)),floor(coil_coord_vx(i,2)),floor(coil_coord_vx(i,3)))=maxvalue;
 
Y(floor(coil_coord_vx(i,1)),floor(coil_coord_vx(i,2)),floor(coil_coord_vx(i,3)))=maxvalue;

             end
         end
         % make an analyze format image
         Y1=reshape(Y,DIM(1)*DIM(2)*DIM(3),1);
         direc=pathname;
         %making image file "rawdata.img"
	%     fid=fopen([direc 'rawdata.img'],'w');
	%     fwrite(fid,Y1,'uint8');
         fid=fopen([direc 'rawdata.img'],'w');
         fwrite(fid,Y1,'int16');
         fclose_wrapper(fid);
         %making a header file "rawdata.hdr"
         switch(spm('ver'))
             case {'SPM99'}
                 spm_hwrite([direc 
'rawdata.img'],DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
             case {'SPM2'}
                 global st;
                 V=spm_vol(st.vols{1}.fname);
                 rawV = V;
                 rawV.fname = [direc 'rawdata.img'];
                 rawV=spm_create_vol(rawV);
             otherwise
                 error('what did I tell you? you''s gotsta have SPM2 
or SPM99 in yo'' path, homey!');
         end
         %display image
         spm_image('init',[direc 'rawdata.img']);
%%%%%%%%%% END SENSOR DISPLAY %%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%% new super-fast lead field computation
%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(1)
coil_coord1=helm(:,1:3);
coil_coord2=helm(:,1:3)+helm(:,10:12)*50.5;   % in mm
normal_direction=helm(:,10:12);

tic;
h = waitbar(0,'Please wait... pre-computing lead field...');
[lx1, ly1] = leadf_test_superfast(voxels,coil_coord1,normal_direction,lsc);
waitbar(0.5,h);
[lx2, ly2] = leadf_test_superfast(voxels,coil_coord2,normal_direction,lsc);
waitbar(0.9,h);
Lp1(:,1,:) = lx1-lx2;
Lp1(:,2,:) = ly1-ly2;
waitbar(1,h);
delete(h);
toc;
end
%%%%%%%%%%%%%%%%%%%%%%end  new super-fast lead field computation
%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% semi-fast lead field computation
% voxel by voxel, but all sensors simultaneously
if(0)
Lp2=zeros(size(helm,1),2,Nvoxels);  % Lead field for 306
h = waitbar(0,'Please wait... pre-computing lead field...');
tic;
     for i=1:Nvoxels;
         Lp2(:,:,i)=btiLp(voxels(i,:),helm,lsc, 2);
         waitbar(i/Nvoxels,h);
     end;
     close(h);
toc;
end

if(0)   % original lead field computation
Lp3=zeros(size(helm,1),2,Nvoxels);  % Lead field for 306
h = waitbar(0,'Please wait... pre-computing lead field...');
tic;
     for i=1:Nvoxels;
         Lp3(:,:,i)=btiLp_old(voxels(i,:),helm,lsc, 2);
         waitbar(i/Nvoxels,h);
     end;
     close(h);
toc;
end

save prcmp.mat Lp1

     toc



function Lp=btiLp(voxel,helm,lsc,coordsystem) %----------------------

% Lead field calculation for Neuromag : Gradiometer1
coil_coord1=helm(:,1:3);
coil_coord2=helm(:,1:3)+helm(:,10:12)*50.5;   % in mm
% coil_coord2=helm(:,1:3)+helm(:,10:12)*0.0505;  % in m

normal_direction=helm(:,10:12);
Nchannel=size(coil_coord1,1);

if(coordsystem==3)
	for i=1:Nchannel
 
[lx1,ly1,lz1]=hdsleadfield(voxel',coil_coord1(i,:)',normal_direction(i,:)',lsc');
 
[lx2,ly2,lz2]=hdsleadfield(voxel',coil_coord2(i,:)',normal_direction(i,:)',lsc');
         Lp(i,:)=[lx1-lx2 ly1-ly2 lz1-lz2];
  	end;
end;


if(coordsystem==2)
	[lx1,ly1]=leadf_test(voxel,coil_coord1,normal_direction,lsc); 
% test vecotrization
	[lx2,ly2]=leadf_test(voxel,coil_coord2,normal_direction,lsc);
     Lp = [lx1-lx2 ly1-ly2];
end

return; 
%------------------------------------------------------------------------

function Lp=btiLp_old(voxel,helm,lsc,coordsystem) %----------------------

% Lead field calculation for Neuromag : Gradiometer1
coil_coord1=helm(:,1:3);
coil_coord2=helm(:,1:3)+helm(:,10:12)*50.5;   % in mm
% coil_coord2=helm(:,1:3)+helm(:,10:12)*0.0505;  % in m

normal_direction=helm(:,10:12);
Nchannel=size(coil_coord1,1);

if(coordsystem==3)
	for i=1:Nchannel
 
[lx1,ly1,lz1]=hdsleadfield(voxel',coil_coord1(i,:)',normal_direction(i,:)',lsc');
         [lx2,ly2,lz2]=hdsleadfield(voxel',coil_coord2(i,:)',normal_direction(i,:)',lsc');
         Lp(i,:)=[lx1-lx2 ly1-ly2 lz1-lz2];
  	end;
end;


if(coordsystem==2)

     for i=1:Nchannel
         [lx1,ly1]=leadf(voxel,coil_coord1(i,:),normal_direction(i,:),lsc);
         [lx2,ly2]=leadf(voxel,coil_coord2(i,:),normal_direction(i,:),lsc);
         Lp(i,:)=[lx1-lx2 ly1-ly2];
	end;

end

return; 
%------------------------------------------------------------------------
