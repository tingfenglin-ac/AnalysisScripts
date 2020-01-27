function [rot, fick] = wraw2rot(data, ref, eye, room, dironly_flag)
%room='sled';
% Adapted from raw2rot
load sh_gains
if exist('offsets')==2
   load offsets
elseif nargin>=4
   switch room
   case {'room2' 'monk' 'room1'}
      offsets=2048*ones(3,6);
   case {'sled' 'lloydsled'} %human or monkey
      offsets=zeros(3,6);
   end
elseif abs(sh_gains(1)) > 3000 %human sled (16-bit a/d)
   offsets=zeros(3,6);
else % default is room2
   offsets=2048*ones(3,6);
end

if nargin<5
    dironly_flag = 0;end

switch eye
    case 'r'
        if dironly_flag
            gains=sh_gains(1:3);
            offsets=offsets(1:3);
            ref = ref(1:3);
        else
            gains=sh_gains(1:6);
            offsets=offsets(1:6);
        end
    case 'l'
        if dironly_flag
            gains=sh_gains(7:9);
            offsets=offsets(7:9);
            ref = ref(1:3);
        else
            gains=sh_gains(7:12);
            offsets=offsets(7:12);
        end
    case 'h'
        gains=sh_gains(13:18);
        offsets=offsets(13:18);
end

if (length(ref) == 6) | (length(ref)==3 & dironly_flag)
   data = [ref; data];
end;

% subtract offsets
data=data-offsets(ones(size(data,1),1),:);

if dironly_flag
    rot = raw2rot_dironly(data,gains);
    return
end

%disp('Computing relative gains (z is reference)...');
gdx = gains(1) / (abs(gains(3)));
gdy = gains(2) / (abs(gains(3)));
gdz = gains(3) / (abs(gains(3)));
gtx = gains(4) / (abs(gains(6)));
gty = gains(5) / (abs(gains(6)));
gtz = gains(6) / (abs(gains(6)));

%disp('Dividing all data channels with gains (sign correction included)...');

dxv = data(:,1) ./ gdx;
dyv = data(:,2) ./ gdy;
dzv = data(:,3) ./ gdz;

txv = data(:,4) ./ gtx;
tyv = data(:,5) ./ gty;
tzv = data(:,6) ./ gtz;

clear data;

%Length of coil vectors
dlv = sqrt(dxv.^2 + dyv.^2 + dzv.^2);
%tlv = sqrt(txv.^2 + tyv.^2 + tzv.^2);

%Inproduct of both coil vectors
inpv = dxv.*txv + dyv.*tyv + dzv.*tzv;

%Orthogonalize torsional vector
toxv = txv - ((inpv .* dxv) ./ (dlv.^2));
clear txv;
toyv = tyv - ((inpv .* dyv) ./ (dlv.^2));
clear tyv;
tozv = tzv - ((inpv .* dzv) ./ (dlv.^2));
clear tzv inpv;

%Lenght of orthogonalized torsional vector
tolv = sqrt(toxv.^2 + toyv.^2 + tozv.^2);

%Construct instantaneous new orthogonal coordinate system of coils
f11 = dxv ./ dlv; clear dxv;
f12 = dyv ./ dlv; clear dyv;
f13 = dzv ./ dlv; clear dzv dlv;
f21 = toxv ./ tolv; clear toxv;
f22 = toyv ./ tolv; clear toyv;
f23 = tozv ./ tolv; clear tozv tolv;
f31 = [f12.*f23-f13.*f22];
f32 = [f13.*f21-f11.*f23];
f33 = [f11.*f22-f12.*f21];

%Take first data point as reference 
r = [f11(1) f12(1) f13(1);
   f21(1) f22(1) f23(1);
   f31(1) f32(1) f33(1)];

%Rotation matrix
R11 = f11 * r(1,1) + f21 * r(2,1) + f31 * r(3,1);
R22 = f12 * r(1,2) + f22 * r(2,2) + f32 * r(3,2);
R33 = f13 * r(1,3) + f23 * r(2,3) + f33 * r(3,3);

%Computing rotation vectors
alpha = 1 + R11 + R22 + R33;
%clear R11 R22 R33;
R32 = f13 * r(1,2) + f23 * r(2,2) + f33 * r(3,2);
R23 = f12 * r(1,3) + f22 * r(2,3) + f32 * r(3,3);
rot1 = (R32 - R23) ./ alpha;
%clear R32 R23;
R13 = f11 * r(1,3) + f21 * r(2,3) + f31 * r(3,3);
R31 = f13 * r(1,1) + f23 * r(2,1) + f33 * r(3,1);
rot2 = (R13 - R31) ./ alpha;
%clear R13 R31;
R21 = f12 * r(1,1) + f22 * r(2,1) + f32 * r(3,1);
R12 = f11 * r(1,2) + f21 * r(2,2) + f31 * r(3,2);
rot3 = (R21 - R12) ./ alpha;
%clear R21 R12 alpha;
clear f11 f12 f13 f21 f22 f23 f31 f32 f33;
rot = [rot1 rot2 rot3];
clear rot1 rot2 rot3;

% calculate fick angles
phi = -asin(R31);		%vertical rotation (second)
psi = asin(R32./cos(phi));	%torsional rotation (last)
theta = asin(R21./cos(phi));	%horizontal rotation (first)

fick = 180./pi*[psi -phi -theta]; % in degrees


if (length(ref) == 6)
   rot = rot(2:size(rot,1),:);
   fick = fick(2:size(fick,1),:);
end;

return;
%END WRAW2ROT
%