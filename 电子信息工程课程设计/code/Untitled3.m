snr=sum(pdatsgn2)/(sum(pdatsgn1)-sum(pdatsgn2));
display('�ĵ�ͼ�������Ϊ:')
display(num2str(snr))

%Q��
Q=[0 0 0 0 0];
Qloc=[0 0 0 0 0];
dat=[datsgn2(90:100)];
dat=abs(dat);
[Q(1),loc1]=max(dat);
loc1=loc1+89;
dat=[datsgn2(307:317)];
dat=abs(dat);
[Q(2),loc2]=max(dat);
loc2=loc2+306;
dat=[datsgn2(521:531)];
dat=abs(dat);
[Q(3),loc3]=max(dat);
loc3=loc3+520;

dat=[datsgn2(737:747)];
dat=abs(dat);
[Q(4),loc4]=max(dat);
loc4=loc4+736;1
dat=[datsgn2(950:960)];
dat=abs(dat);
[Q(5),loc5]=max(dat);
loc5=loc5+949;
Qloc(1)=loc1;
Qloc(2)=loc2;
Qloc(3)=loc3;
Qloc(4)=loc4;
Qloc(5)=loc5;
VQ=sum(Q)/5;
%S��
S=[0 0 0 0 0];
Sloc=[0 0 0 0 0];
dat=[datsgn2(113:123)];
dat=abs(dat);
[S(1),loc1]=max(dat);
loc1=loc1+112;
dat=[datsgn2(328:338)];
dat=abs(dat);
[S(2),loc2]=max(dat);
loc2=loc2+327;
dat=[datsgn2(543:553)];
dat=abs(dat);
[S(3),loc3]=max(dat);
loc3=loc3+542;
dat=[datsgn2(757:767)];
dat=abs(dat);
[S(4),loc4]=max(dat);
loc4=loc4+756;
dat=[datsgn2(972:982)];
dat=abs(dat);
[S(5),loc5]=max(dat);
loc5=loc5+971;
Sloc(1)=loc1;
Sloc(2)=loc2;
Sloc(3)=loc3;
Sloc(4)=loc4;
Sloc(5)=loc5;
vs=sum(S)/5;
qrs=Sloc-Qloc;
Averageqrs=sum(qrs)/fs/5;    
display('���˵�QRS��ȣ�s��Ϊ:')
display(num2str(Averageqrs))
if Averageqrs>=0.06&&Averageqrs<=0.1
    display('�����˵�QRS�����60-100ms����˴���QRS�������')
else
display('�����˵�QRS�����60-100ms����˴���QRS��Ȳ�����')
end
% p��
P=[0 0 0 0 0];
pl=[0 0 0 0 0];
data2=[datsgn2(53:77)];
[P(1),location1]=max(data2);
p1location=53+location1;
data2=[datsgn2(272:296)];
[P(2),location2]=max(data2);
p2location=272+location2;
data2=[datsgn2(491:515)];
[P(3),location3]=max(data2);
p3location=491+location3;
data2=[datsgn2(710:734)];
[P(4),location4]=max(data2);
p4location=710+location4;
data2=[datsgn2(929:953)];
[P(5),location5]=max(data2);
p5location=929+location5;
pl(1)=p1location;
pl(2)=p2location;
pl(3)=p3location;
pl(4)=p4location;
pl(5)=p5location;
% t��
T=[0 0 0 0 0];
tl=[0 0 0 0 0];
data2=[datsgn2(140:180)];
[T(1),tlocation1]=max(data2);
t1location=53+tlocation1;
data2=[datsgn2(359:399)];
[T(2),tlocation2]=max(data2);
t2location=359+tlocation2;
data2=[datsgn2(578:618)];
[T(3),tlocation3]=max(data2);
t3location=578+tlocation3;
data2=[datsgn2(797:837)];
[T(4),tlocation4]=max(data2);
t4location=797+tlocation4;
data2=[datsgn2(1016:1024)];
[T(5),tlocation5]=max(data2);
t5location=1016+tlocation5;
tl(1)=t1location;
tl(2)=t2location;
tl(3)=t3location;
tl(4)=t4location;
tl(5)=t5location;
vp=sum(P)/5;
vt=sum(T)/5;
display('���˵�P������(mv)Ϊ:')
display(num2str(vp))
if vp<0.25
    display('������P������<0.25mv����˴��˵�P����������')
else
display('������P������<0.25mv����˴��˵�P�����Ȳ�����')
end
display('���˵�ST�η�ΧΪ-0.21��0.05mv����������ST�η�ΧΪ-0.05��0.3mv����˴��˵�ST�η��ȷ�Χ���ƣ����������������ļ�ȱѪ������')
time=[datsgn2(48:58)];
average=sum(time)/11;
value=[datsgn2(60:70)];
value=value-average;
value=value.*value;
[minvalue,locp]=min(value);
locp=locp+59;
Ptime=(p1location-locp)*2/fs;
display('���˵�P�����(s)Ϊ:')
display(num2str(Ptime))
if Ptime<0.11
    display('������P�����<0.11�룬��˴��˵�P���������')
else
display('������P�����<0.11�룬��˴��˵�P����Ȳ�����')
end
value=[datsgn2(85:95)];
value=value-average;
value=value.*value;
[minvalue,locq1]=min(value);
locq1=locq1+84;
value=[datsgn2(90:100)];
value=value-average;
value=value.*value;
[minvalue,locq2]=min(value);
locq2=locq2+89;
Qtime=(locq2-locq1)/fs;
display('���˵�Q�����(s)Ϊ:')
display(num2str(Qtime))
if Qtime<0.11
    display('������Q�����<0.04�룬��˴��˵�Q���������')
else
display('������Q�����<0.04�룬��˴��˵�Q����Ȳ�����')
end
PRtime=(locq1-locp)/fs-Ptime;
display('���˵�PR���Ϊ(s)Ϊ:')
display(num2str(PRtime))
if PRtime<=0.2&&PRtime>=0.12
    display('������PR���Ϊ120ms-200ms����˴��˵�PR�������')
else
display('������PR���Ϊ120ms-200ms����˴��˵�PR��Ȳ�����')
end
value=[datsgn2(169:179)];
value=value-average;
value=value.*value;
[minvalue,loct2]=min(value);
loct2=loct2+168;
QTtime=(loct2-locq1)/fs;
display('���˵�QT���Ϊ(s)Ϊ:')
display(num2str(QTtime))
if QTtime<=0.43&&PRtime>=0.34
    display('������QT���Ϊ340ms-430ms����˴��˵�QT�������')
else
display('������QT���Ϊ340ms-430ms����˴��˵�QT��Ȳ�����')
end 
if beat>=60&&beat<=100
display('�������彡��')
else
display('���˲�����')   
end