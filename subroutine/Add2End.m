function[A]=Add2End(A,B,dim)
if exist('A')==0
    A=[];
end
if dim==1
    A=[A;B];
else
    A=[A B];
end
end