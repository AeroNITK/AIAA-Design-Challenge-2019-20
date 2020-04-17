function [Xoe,Xoe_f,Xoe_pb,Xto] = CG_Calculator(wing,Htail,Vtail,engine,nacelle,MLG,fuel,payload,fuselage,propulsion)

%Formulas and approx assumption from commercial airplane design principles(CADP)
%UNLESS mentioned otherwise.

fuselage.cg=calc_fuselage_cg(fuselage);
Vtail.cg=calc_Vtail_cg(Vtail);
Htail.cg = calc_Htail_cg(Htail);
wing.cg=cal_wing_cg(wing);
propulsion.cg=calc_propulsion_cg(wing,engine,nacelle );
MLG.cg=calc_MLG_cg(wing);



%calculating cg and weight of fuselage and wing groups
Wcfg=fuselage.wt+Htail.wt+Vtail.wt;
Wcwg=wing.wt+propulsion.wt+MLG.wt;
Xcfg=(fuselage.wt*fuselage.cg+Vtail.wt*Vtail.cg+Htail.wt*Htail.cg)/Wcfg;
Xcwg=(wing.wt*wing.cg+propulsion.wt*propulsion.cg+MLG.wt*MLG.cg)/Wcwg;

X_d=wing.MAC*0.25; %X_d= Xoe-LEMAC
              %Torenbeek(1982):assume 20-25% MAC, CADP: assume 25-30% MAC
LEMAC=Xcfg+(Wcwg/Wcfg)*Xcwg-(1+Wcwg/Wcfg)*X_d; %finding the position of the wing


fuel.cg=wing.cg+LEMAC; %assumption (to be changed)

Xoe=LEMAC+X_d;    %operating empty cg
Woe=Wcfg+Wcwg; %operating empty weight
Woe_f=Woe+fuel.wt;
Xoe_f=(Xoe*Woe+fuel.cg*fuel.wt)/Woe_f; %operating empty weight + fuel
Woe_pb=Woe+payload.wt;
Xoe_pb=(Xoe*Woe+payload.cg*payload.wt)/Woe_pb; %operating empty +passenger + baggage weight
Wto= Woe+fuel.wt+payload.wt;
Xto=(Woe*Xoe+fuel.wt*fuel.cg+payload.cg*payload.wt)/Wto; %total weight

cg_plotting( Xoe,Woe,Xto,Wto,Xoe_pb,Woe_pb,Xoe_f,Woe_f,LEMAC,wing.MAC )


end

