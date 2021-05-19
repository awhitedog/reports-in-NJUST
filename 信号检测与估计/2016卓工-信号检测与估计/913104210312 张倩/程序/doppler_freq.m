function[fred]=doppler_freq(freq,ang,v,indicator)
format long
c=3.0e+8;
ang_rad=ang*pi/180;
lambda=c/freq;
if(indicator==1)
  fd=2.0*v*cos(ang_rad)/lambda;
else
  fd=-2.0*v*cos(ang_rad)/lambda;
end;
fred=fd;
end

