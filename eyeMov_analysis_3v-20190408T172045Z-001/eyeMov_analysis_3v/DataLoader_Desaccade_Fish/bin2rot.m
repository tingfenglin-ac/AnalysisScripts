function [rot, rn, reg] = raw2rot(data, gains, ref, option)

%BIN2ROT.M
%Version 1.1
%Oct. 19, 1996
%D. Straumann
%	Feb-2002: Print output only if "PrintFlag" is set - TH
%
%Purpose	Produces rotations vectors from digitized data.
%		Like raw2rot, but no subtraction of 2^11.
%		
%Description	Remark
%		The below description uses the right-hand rule with
%		the following Cartesian coordinate system:
%		x: about nasooccipital pointing forward
%		y: horizontal (interaural) pointing leftward
%		z: perpendicular to x and y pointing upward
%
%		Data format
%		Matrix with 6 cols:
%		(1) torsional field direction coil (x)
%		(2) vertical field direction coil (y)
%		(3) horizontal (interaural) field direction coil (z)
%		(4) torsional field torsion coil (x)
%		(5) vertical field torsion coil (y)
%		(6) horizontal (interaural) field torsion coil (z)
%
%		The data is extracted from REX-files by READREX.M
%
%		Data is A/D converted by a 12-bit converter. Numbers range
%		from 0 to 4096. Therefore 2048 have to be subtracted from 
%		each data channel.
%
%		Gains format
%		Vector with 6 elements.
%		During in-vitro calibrations the signals are inverted such
%		that positive signals appear leftward, upward, and with 
%		positive torsion (extorsion of the right eye, intorsion of
%		the left eye).
%		(1) Maximal signal with direction coil sensitivity vector 
%		along x
%		(2) along y
%		(3) along z
%		(4) Maximal signal with torsion coil sensitivity vector 
%		along x
%		(5) along y
%		(6) along z
%
%Input		data
%		gains
%		ref: reference position = 6 element vector or 0 (= first sample taken)
%		option (optional): 0 = compute, rotate, and plot (default), 
%				   1 = compute and rotate.
%				   2 = compute only.
%		
%Output		rot:	rotation vectors (see Haustein 1989): 3 cols (x, y, z - components).
%		rn:	rotated data with best-fit plane in y-z-plane
%		reg:	4 col vector (yslope, zslope, offset, stdev).
%
%Call		r = bin2rot(data, gains, option, ref_option)
%
%Program Structure:
%\dom\bin2rot.m
%	\dom\len3d.m
%*****************************************************************

PrintFlag = 0;
% 0 ... No printing
% 1 ... Printing to standard output
% 2 ... Printing to standard error

PrintTxt = 'Checking arguments...';
sprintf('%s', PrintTxt)
if nargin < 2
  disp('  Bad argument number.');
  return;
end;

if nargin < 3
  option = 0;
  ref = 0;
end;

if nargin < 4
  option = 0;
end;

PrintTxt = 'Checking input formats...';
sprintf('%s', PrintTxt)
[dr dc] = size(data);
if dc ~= 6
  disp('  Data matrix must have 6 cols.');
  return;
end;

[gr gc] = size(gains);
if (gr~= 1)
  gains = gains';
end;

[gr gc] = size(gains);
if (gc ~= 6) & (gr ~= 1)
  disp('  Gains vector must have 6 elements...');
  return;
end;

PrintTxt = 'Constructing reference sample';
sprintf('%s', PrintTxt)
if (length(ref) == 6)
  data = [ref; data];
end;

PrintTxt = 'Computing relative gains (z is reference)...';
sprintf('%s', PrintTxt)

gdx = gains(1) / (abs(gains(3)));
gdy = gains(2) / (abs(gains(3)));
gdz = gains(3) / (abs(gains(3)));
gtx = gains(4) / (abs(gains(6)));
gty = gains(5) / (abs(gains(6)));
gtz = gains(6) / (abs(gains(6)));

PrintTxt = 'Dividing all data channels with gains (sign correction included)...';
sprintf('%s', PrintTxt)
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
clear R11 R22 R33;
R32 = f13 * r(1,2) + f23 * r(2,2) + f33 * r(3,2);
R23 = f12 * r(1,3) + f22 * r(2,3) + f32 * r(3,3);
rot1 = (R32 - R23) ./ alpha;
clear R32 R23;
R13 = f11 * r(1,3) + f21 * r(2,3) + f31 * r(3,3);
R31 = f13 * r(1,1) + f23 * r(2,1) + f33 * r(3,1);
rot2 = (R13 - R31) ./ alpha;
clear R13 R31;
R21 = f12 * r(1,1) + f22 * r(2,1) + f32 * r(3,1);
R12 = f11 * r(1,2) + f21 * r(2,2) + f31 * r(3,2);
rot3 = (R21 - R12) ./ alpha;
clear R21 R12 alpha;
clear f11 f12 f13 f21 f22 f23 f31 f32 f33;
rot = [rot1 rot2 rot3];
clear rot1 rot2 rot3;

if (length(ref) == 6)
  rot = rot(2:length(rot),:);
end;

if option == 2
  reg = 0;
  rn = 0;
  return;
end;

disp('Reducing data to about 500 samples for regression analysis...');
seq = [1:length(rot)];
div = ceil(length(rot) / 500);
ev = (rem(seq,div) == 0);
red = rot(ev,:);
clear seq ev

disp('Only using position with a length of less then 40 deg for regression.');
len_vec = len3d(red);
ev = (len_vec <= 0.3640);
red = red(ev,:);
clear len_vec ev

disp('Regression analysis...');
[b, bint, r, rint, stats] = regress(red(:,1), [red(:,2:3) ones(length(red), 1)], 0.01);
rstd = std(r);
mn = [b' rstd];
berr =  abs((bint(:,1) - bint(:,2)) ./ 2);
rstderr =  std(abs((rint(:,1) - rint(:,2)) ./ 2));
cf = [berr' rstderr];
clear bint rint;
reg = mn;

disp('Computing ideal plane...');
resy = [0.1763; 0.1763; -0.1763; -0.1763; 0.1763];
resz = [0.1763; -0.1763; -0.1763; 0.1763; 0.1763];
resx = mn(1) * resy + mn(2) * resz + mn(3);

disp('Rotating data into y-z-plane...');
offset = mn(3);
yslope = mn(1);
zslope = mn(2);
p = [-offset -zslope yslope];

r_cross1 = rot(:,2) .* p(3) - rot(:,3) .* p(2);
r_cross2 = rot(:,3) .* p(1) - rot(:,1) .* p(3);
r_cross3 = rot(:,1) .* p(2) - rot(:,2) .* p(1);
in_prod = p(1) .* rot(:,1) + p(2) .* rot(:,2) + p(3) .* rot(:,3);
rn1 = ( rot(:,1) + p(1) - r_cross1 ) ./ (1 - in_prod); clear r_cross1;
rn2 = ( rot(:,2) + p(2) - r_cross2 ) ./ (1 - in_prod); clear r_cross2;
rn3 = ( rot(:,3) + p(3) - r_cross3 ) ./ (1 - in_prod); clear r_cross3 in_prod;
rn = [rn1 rn2 rn3];
clear rn1 rn2 rn3 rcross1 rcross2 rcross3 in_prod

if option == 1
  return;
end;

disp('Plotting...');
%clf;
figure(gcf);

xmin = -.31;
xmax = .31;
ymin = -.31;
ymax = .31;

line_width = 1.5;

subplot(3,3,1), plot(rot(:,2), rot(:,3), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('y [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,2), plot(rot(:,1), rot(:,3), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,3), plot(rot(:,1), rot(:,2), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('y [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);

subplot(3,3,4), fill(resy, resz, 'c'), line('xdata', resy, 'ydata', resz, 'linewidth', line_width, 'color', 'black'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('y [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,5), fill(resx, resz, 'c'), line('xdata', resx, 'ydata', resz, 'linewidth', line_width, 'color', 'black'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,6), fill(resx, resy, 'c'), line('xdata', resx, 'ydata', resy, 'linewidth', line_width, 'color', 'black'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('y [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);

subplot(3,3,7), plot(rn(:,2), rn(:,3), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('y [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,8), plot(rn(:,1), rn(:,3), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('z [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);
subplot(3,3,9), plot(rn(:,1), rn(:,2), '.'), axis([xmin xmax ymin ymax]), axis('square'), xlabel('x [rot]'), ylabel('y [rot]'), set(gca,'XTick', [-.2 -.1 0 .1 .2]), set(gca, 'YTick', [-.2 -.1 0 .1 .2]);

string = sprintf('x = %.3f * y + %.3f * z + %.3f +/- %.4f', mn(1), mn(2), mn(3), mn(4));
axes('position', [0 0 1 1], 'Visible', 'off'  );
txt = text(0.05,0.02,string);
hold off;

return;
