c=1.0
mVb=0.004553
mVc=0.003283
mVd=0.001641
Vb=460.9783
Vc=505.4711
Vd=631.8389

B1=c+mVb*Vb
C1=c+mVc*Vc
D1=c+mVd*Vd
D2=c-mVd*Vd
C2=c-mVc*Vc
B2=c-mVb*Vb

xa=0:1:800
ya=0*ones(size(xa))
xb=0:1:Vb
yb=c+mVb*xb
yb2=c-mVb*xb
xc=0:1:Vc
yc=c+mVc*xc
yc2=c-mVc*xc
xd=0:1:Vd
yd=c+mVd*xd
yd2=c-mVd*xd
M=B1/(Vb.^2)
yp=M*(xb.^2)
yv1=B2:0.1:B1
yv2=C2:0.1:C1
xv1=Vb*ones(size(yv1))
xv2=Vc*ones(size(yv2))

Mbc=(B1-C1)/(Vb-Vc)
Mbc2=(B2-C2)/(Vb-Vc)
Mcd=(C1-D1)/(Vc-Vd)
Mcd2=(C2-D2)/(Vc-Vd)


X=(c - (2*M*c - mVb*(mVb^2 + 4*M*c)^(1/2) + mVb^2)/(2*M))/mVb
Y=(2*M*c - mVb*(mVb^2 + 4*M*c)^(1/2) + mVb^2)/(2*M)

yD=D2:0.01:D1
xD=Vd*ones(size(yD))
xbc=Vb:1:Vc
xcd=Vc:1:Vd
yB1=B1+Mbc*(xbc-Vb)
yC1=C1+Mcd*(xcd-Vc)
yB2=B2+Mbc2*(xbc-Vb)
yC2=C2+Mcd2*(xcd-Vc)
xA=X:0.1:Vb
yA1=M*(xA.^2)
yA2=-mVb*xA+c
hold on
plot(xa,ya,'k')
plot(xb,yb,'--',xc,yc,'--',xd,yd,'--',xb,yb2,'--',xc,yc2,'--',xd,yd2,'--',xb,yp,'--',xv1,yv1,'--',xv2,yv2,'--')
plot(xA,yA1,'k',xA,yA2,'k',xD,yD,'k',xbc,yB1,'k',xcd,yC1,'k',xbc,yB2,'k',xcd,yC2,'k')
hold off
ax=gca
xlim([0 800])
ylim([-3 5])
ax.XTick=[0 Vb Vc Vd]
ax.YTick=[-1.0 0 1.0]
title('V-n Gust Diagram')
xlabel('Speed V in KEAS')
ylabel('Load Factor n')
str={'Vb','Vc','Vd','Vb speed','Vc speed','Vd speed','Vb speed','Vc speed','Vd speed'}
text([Vb Vc Vd Vb/4 Vc/2 Vd/2+50 Vb/4 Vc/2+20 Vd/2+50 ],[0 0 0 1.8 1.9 1.7 0.3 0 -0.2],str)