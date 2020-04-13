function value = Obj_Func(x)

    global Aircraft
    d2r = pi/180;
    
    Aircraft = Performance(Aircraft);
    
    Aircraft.Performance.TbyW = x(1);   % Independent variable 2
    Aircraft.Performance.WbyS = x(2);   % Independent variable 1
    Aircraft.Wing.Sweep_qc = x(3);
    Aircraft.Wing.t_c_root = x(4);
    Aircraft.Performance.M_cruise = x(5);
    Aircraft.Performance.altitude_cruise1 = x(6);
    Aircraft.Wing.taper_ratio = x(7);
    Aircraft.Wing.Aspect_Ratio = x(8);
    Aircraft.Wing.b = x(9);
    
    Aircraft.Weight.MTOW = 400000;  % Initial Guess
    error = 1; % Dummy value to start the while loop
    
    while error > 0.005
    
        error = Aircraft.Weight.MTOW;
        Aircraft = Sizing(Aircraft);
        Aircraft = Aero(Aircraft);

        Aircraft = Payload_Weight(Aircraft);
        Aircraft = Empty_Weight(Aircraft);
        Aircraft = Fuel_Weight(Aircraft);
        Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight...
                               + Aircraft.Weight.empty_Weight;

        error = abs(error - Aircraft.Weight.MTOW);
    
    end
    
    Aircraft.Performance.Mdd = 0.95/cos(d2r*Aircraft.Wing.Sweep_LE) - Aircraft.Wing.t_c_root/cos(d2r*Aircraft.Wing.Sweep_LE)^2 ...
            -0.5/(10*cos(d2r*Aircraft.Wing.Sweep_LE)^3);
    
    value(1) = Aircraft.Weight.MTOW;
    
%     value(2) = 1/Aircraft.Performance.Mdd;

end
