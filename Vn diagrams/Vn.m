function []=Vn()
Vs1=211.847
Va=334.959
Vc=505.471
Vd=631.838
Vs1neg=261.096

nneg=-1.0
npos1=1.0
npos2=2.5

a=1/(Vs1*Vs1)
x1=0:1:Va
y1=a*(x1.^2)

x2=Va:1:Vd
y2=2.5*ones(size(x2))

y3=2.5:-0.1:0
x3=Vd*ones(size(y3))

x4=Vd:-1:Vc
m=1/(Vd-Vc)
c=-m*Vd
y4=m*x4+c

x5=Vs1neg:1:Vc
y5=-1*ones(size(x5))

a=-1/(Vs1neg*Vs1neg)
x6=0:1:Vs1neg
y6=a*(x6.^2)

xa=0:1:800
xb=0:1:Vs1
ye=-3:0.1:1
xc=Vs1*ones(size(ye))
yf=-3:0.1:2.5
yg=-3:0.1:2.5
xd=Va*ones(size(yf))
xe=Vc*ones(size(yg))
ya=0*ones(size(xa))
yb=-1*ones(size(xa))
yc=2.5*ones(size(xa))
yd=1*ones(size(xb))
yh=-3:0.1:2.5
xf=Vd*ones(size(yh))

ax=gca
hold on
plot(x1,y1,x2,y2,x3,y3,x4,y4,x5,y5,x6,y6)
plot(xa,ya,'k',xa,yb,'--',xa,yc,'--',xb,yd,'--',xc,ye,'--',xd,yf,'--',xe,yg,'--',xf,yh,'--')
hold off
xlim([0 800])
ax.XTick=[0 Vs1 Va Vc Vd 800]
ax.YTick=[-1.0 0 1.0 2.5]
ylim([-3 5])
title('V-n Diagram')
xlabel('Speed V in KEAS')
ylabel('Load Factor n')
str={'Vs1','Va','Vc','Vd','n lim pos'}
text([Vs1 Va Vc Vd 0],[0 0 0 0 2.6],str)




