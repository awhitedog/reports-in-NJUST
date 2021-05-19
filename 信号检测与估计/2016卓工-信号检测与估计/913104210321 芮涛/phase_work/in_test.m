clear all;
x=[1,6,11];
y=[0,1,0];
xi=[2,3,4,5,7,8,9,10];
yi=interp1(x,y,xi,'spline')
yi=interp1(x,y,xi,'cubic')