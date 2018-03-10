function  [lead_f, lead_g]=leadf(r_source,r_det,normal_v,lsc)
%
%  calculation of lead field for f and g component
%  in the spherical homogeneous conductor
%  using Sarvas formula
%  appeared in Phys. Med. Biol. Vol.32, 11-22, 1987
%
%  r_source : source coordinate   (cm)         (raw vector)
%  r_det    : detector coordinate (cm)       (raw vector)
%  normal_v : detector normal dorection     (raw vector)
%  lsc      : local sphere center  (cm)      (raw vector)
%
    const=10^-7;  % for r (cm), Q (nAm), B (pT)
%

numvoxels = length(r_source);
numsensors = length(r_det);

r_det = coord_diff(r_det,lsc);
r_source = coord_diff(r_source,lsc);

lsc  = 0; % origin set at local sphere center
%    lsc      = (lsc      -lsc);  % origin set at local sphere center

Qf = zeros(size(r_source));
Qg = zeros(size(r_source));
Qefg1=[0 1 0]; %  derive leads_f by assuming Qefg=[0 1 0]
Qefg2=[0 0 1]; %  derive leads_g by assuming Qefg=[0 0 1]
for i=1:length(r_source);
    Qf(i,:)=efg2xyz(Qefg1, r_source(i,:), lsc);
    Qg(i,:)=efg2xyz(Qefg2, r_source(i,:), lsc);
end
aa1f = cross(Qf,r_source);
temp = repmat(aa1f,[1 1 numsensors]);
temp = shiftdim(temp,2);
aa1f = reshape(temp,[numsensors*numvoxels 3]);

aa1g = cross(Qg,r_source);
temp = repmat(aa1g,[1 1 numsensors]);
temp = shiftdim(temp,2);
aa1g = reshape(temp,[numsensors*numvoxels 3]);

r_det = repmat(r_det,numvoxels,1);
normal_v = repmat(normal_v,numvoxels,1);
temp = repmat(r_source,[1 1 numsensors]);
temp = shiftdim(temp,2);
r_source = reshape(temp,[numsensors*numvoxels 3]);
clear temp;

a_vec = r_det - r_source;
a_mag = rownorm(a_vec);
rd_mag = rownorm(r_det);
%
    F = a_mag.*(rd_mag.*a_mag + rd_mag.^2 - dotfast(r_source,r_det,2));
    coef1 = (1./rd_mag).*a_mag.^2 + 
(1./a_mag).*dotfast(a_vec,r_det,2)+2.*a_mag+2.*rd_mag;
    coef2 = a_mag + 2*rd_mag +  (1./a_mag).*dotfast(a_vec,r_det,2);
    vec_F= rowmult(coef1,r_det) - rowmult(coef2,r_source);


    % derive leads_f by assuming Qefg=[0 1 0]
    B = rowmult(const./F.^2,rowmult(F,aa1f) - 
rowmult(dotfast(r_det,aa1f,2),vec_F));
    lead_f = dotfast(B,normal_v,2);

    %  derive leads_g by assuming Qefg=[0 0 1]
    B = rowmult(const./F.^2,rowmult(F,aa1g) - 
rowmult(dotfast(r_det,aa1g,2),vec_F));
    lead_g = dotfast(B,normal_v,2);

lead_f =  reshape(lead_f,numsensors,numvoxels);
lead_g =  reshape(lead_g,numsensors,numvoxels);
