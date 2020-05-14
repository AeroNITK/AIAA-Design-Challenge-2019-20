c=1.0
mVb=0.005212
mVc=0.003759
mVd=0.001878
Vb=458.3313
Vc=484.692
Vd=605.865

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
plot(xb,yb,'--y',xc,yc,'--m',xd,yd,'--c',xb,yb2,'--r',xc,yc2,'--g',xd,yd2,'--b',xb,yp,'--k',xv1,yv1,'--k',xv2,yv2,'--k')
legend({'V_{b} Speed','V_{c} Speed','V_{d} Speed','V_{b} Speed','V_{c} Speed','V_{d} Speed'},'Location','southeast','Orientation','vertical')
plot(xa,ya,'k')
plot(xA,yA1,'k',xA,yA2,'k',xD,yD,'k',xbc,yB1,'k',xcd,yC1,'k',xbc,yB2,'k',xcd,yC2,'k')
set(findall(gca, 'Type', 'Line'),'LineWidth',1.2);
hold off
ax=gca
xlim([0 800])
ylim([-3 5])
ax.XTick=[0 100 200 300 400 500 600 700 800]
ax.YTick=[-3.0 -2.0 -1.0 0 1.0 2.0 3.0 4.0 5.0]
ax.FontSize = 13
title('V-n Gust Diagram')
xlabel('Speed V in KEAS')
ylabel('Load Factor n')
str={'V_{b}','V_{c}','V_{d}'}
text([Vb Vc Vd ],[0.3 0.3 0.2],str,'FontSize',13)
dim = [.8 .5 .3 .3];
str = {'V_{b} = 458.33','V_{c} = 484.69','V_{d} = 605.86'}
annotation('textbox',dim,'String',str,'FitBoxToText','on')
