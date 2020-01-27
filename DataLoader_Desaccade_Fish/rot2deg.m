%ROT2DEG	Transforms a rotation vector into the corresponding degree-value
%	This function takes a rotation vector, and returns
%		the corresponding degree-value.
%							
%		Call: function deg = rot2deg(rot)
%
%	ThH, 1995
%	Version 1.0
%
%*****************************************************************
%Program Structure:
%\conversions\rot2deg.m
%*****************************************************************

function deg = rot2deg(rot)

deg = ( 2 * atan(rot) * 180/pi);

