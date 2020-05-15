function [] = cg_plotting( Xoe,Woe,Xto,Wto,Xoe_pb,Woe_pb,Xoe_f,Woe_f,LEMAC,MAC)
%Plotting the CG excursion diagram

xoe=(Xoe-LEMAC)/MAC;
xoe_pb=(Xoe_pb-LEMAC)/MAC;
xoe_f=(Xoe_f-LEMAC)/MAC;
xto=(Xto-LEMAC)/MAC;

xPoe_pb=[xoe,xoe_pb];
xPoe_f=[xoe,xoe_f];
xPpb_to=[xoe_pb,xto];
xPf_to=[xoe_f,xto];

yPoe_pb=[Woe,Woe_pb];
yPoe_f=[Woe,Woe_f];
yPpb_to=[Woe_pb,Wto];
yPf_to=[Woe_f,Wto];




figure
hold on
plot(xPoe_pb,yPoe_pb,xPoe_f,yPoe_f,xPpb_to,yPpb_to,xPf_to,yPf_to)
plot(xPoe_pb,yPoe_pb,'k^',xPoe_f,yPoe_f,'k^',xPpb_to,yPpb_to,'k^',xPf_to,yPf_to,'k^')
title('CG excursion diagram')
xlabel('Percentage of MAC')
ylabel('Weight (Kg)')
grid on
text(xoe+0.01,Woe,'Woe')
text(xoe_pb+0.01,Woe_pb,'Woe+PAX+LUG')
text(xoe_f+0.01,Woe_f,'Woe+Fuel')
text(xto+0.01,Wto,'Wto')

end

