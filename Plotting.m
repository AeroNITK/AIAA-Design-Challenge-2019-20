% Script file for plotting results 

clear;
clc;
close all;

load('Aircraft.mat');

r2d = 180/pi;

%% Lift & Drag curve at cruise condition

% Figure 1
    x = Aircraft.Lift.zero_lift_without_flaps_M082:1:8.4;
    x = [-5.6:0.05:Aircraft.Lift.zero_lift_without_flaps_M082,x];
    y = Aircraft.Lift.lift_slope_M082 * (x - Aircraft.Lift.zero_lift_without_flaps_M082)/r2d;

    figure(1);

    plot(x,y,'LineWidth',1.2);
    hold on
    xlabel('Angle of attack (in degrees)');
    ylabel('Lift Coefficient (C_L)');
    title('Lift Coefficient (C_L) vs Angle of Angle at Cruise Condition');
    grid on

    xhline = 7:1:9;
    hline = Aircraft.Lift.CL_max_M082*ones(1,3);

    plot(0,0.4,'p','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor',[0.5,0.5,0.5]);

    plot(xhline,hline,'r--','LineWidth',1.5);

    legend('Lift Curve','Design C_L','C_L max line','Location','Northwest');
    
    hold off

% Figure 2
    figure(2);

    x = y;
    a = 1/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Drag.M_082.e);
    y = Aircraft.Drag.M_082.C_D_o + a*x.^2;

    plot(y,x,'LineWidth',1.2); hold on;
    xlabel('Drag Coefficient (C_D)');
    ylabel('Lift Coefficient (C_L)');
    title('Drag Polar Curves');
    grid on
    
    txline = [0,0.01,0.02,0.04];
    tyline = [0,0.2,0.4,0.8];
    
    plot(txline,tyline,'--','LineWidth',1.5);
    
    legend('Cruise','Location','Northwest');

%% Lift curve at cruise condition

% Figure 3
    x = Aircraft.Lift.zero_lift_without_flaps_M02:1:11.64;
    x = [-6.36:1:Aircraft.Lift.zero_lift_without_flaps_M02,x];
    y = Aircraft.Lift.lift_slope_M02 * (x - Aircraft.Lift.zero_lift_without_flaps_M02)/r2d;

    figure(3);

    plot(x,y,'-.','LineWidth',1.2);
    hold on
    xlabel('Angle of attack (in degrees)');
    ylabel('Lift Coefficient (C_L)');
    title('C_L vs Angle of Angle with Flaps @ Landing and Takeoff');
    grid on

    xhline = 9:1:11;
    hline = Aircraft.Lift.CL_max_M082*ones(1,3);

    plot(xhline,hline,'--','LineWidth',1.5);
    
    x = -10:1:16;
    y = (0.372 + Aircraft.Lift.del_CL_zero_alpha) + Aircraft.Lift.lift_slope_M02_with_flaps * (x) / r2d;
    
    plot(x,y,'LineWidth',1.5);
    
    xhline = 7:1:9;
    hline = (Aircraft.Lift.CL_max_M082 + Aircraft.HLD.del_CL_max_flaps_TO)*ones(1,3);
    
    plot(xhline,hline,'b--','LineWidth',1.5);
    
    xhline = 10.5:1:12.5;
    hline = (Aircraft.Lift.CL_max_M082 + Aircraft.HLD.del_CL_max_flaps_TO + Aircraft.HLD.del_CL_max_slats)*ones(1,3);
    
    plot(xhline,hline,'--','LineWidth',1.5);
    
    xhline = 15:1:17;
    hline = (Aircraft.Lift.CL_max_M082 + Aircraft.HLD.del_CL_max_flaps_L + Aircraft.HLD.del_CL_max_slats)*ones(1,3);
    
    plot(xhline,hline,'--','LineWidth',1.5);

    legend('C_L curve without flpas','C_L max clean','C_L curve with flaps','C_L max with TO Flaps', ...
        'C_L max with TO Flaps + slats','C_L max with L Flaps + slats','Location','Northwest');
    
    hold off;


%% Drag Polar
    figure(2);
    
    x = y;
    
    a = 1/(pi*Aircraft.Wing.Aspect_Ratio*Aircraft.Drag.M_02.e);
    y = Aircraft.Drag.M_02.C_D_o_L + a*x.^2;
    
    plot(y,x,'LineWidth',1.2);
    
    x = x(1:22);
    y = Aircraft.Drag.M_02.C_D_o_TO + a*x.^2;
    
    plot(y,x,'LineWidth',1.2);
    
    txline = [0,0.1,0.2];
    tyline = [0,1.07,2.14];
    
    plot(txline,tyline,'--','LineWidth',1.5);
    
    txline = [0,0.15,0.3];
    tyline = [0,1.33,2.66];
    
    plot(txline,tyline,'--','LineWidth',1.5);
    
    legend('Cruise','Tangent Line','Landing','Take-Off','Tangent Line Landing','Tangent Line Landing');
    

