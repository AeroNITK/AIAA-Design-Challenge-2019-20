function value = Obj_Func_TS(x)
    
    global Aircraft
    
%    Aircraft.Wing.S = x(1);
    Aircraft.Wing.Aspect_Ratio = x(1);
    Aircraft.Wing.taper_ratio = x(2);
    Aircraft.Wing.Sweep_qc = x(3);
    Aircraft.Wing.t_c_root = x(4);
    Aircraft.Performance.TbyW = x(5);
    Aircraft.Performance.WbyS = x(6);
    Aircraft.Performance.M_cruise = x(7);
    Aircraft.Performance.altitude_cruise1 = x(8);
    
    Aircraft.Weight.MTOW = 400000;  % Initial Guess
    
    Aircraft = Performance(Aircraft);
    
    error = 1; % Dummy value to start the while loop
    
    while error > 0.005
    
        error = Aircraft.Weight.MTOW;
        %Aircraft.Wing.b = sqrt(Aircraft.Wing.Aspect_Ratio*Aircraft.Wing.S);
        Aircraft = Sizing(Aircraft);
        Aircraft = Aero(Aircraft);

        Aircraft = Payload_Weight(Aircraft);
        Aircraft = Empty_Weight(Aircraft);
        Aircraft = Fuel_Weight(Aircraft);
        Aircraft.Weight.MTOW = Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight...
                               + Aircraft.Weight.empty_Weight;

        error = abs(error - Aircraft.Weight.MTOW);
    
    end
    
    %Aircraft.Performance.WbyS = Aircraft.Weight.MTOW/Aircraft.Wing.S;
    
    value = Aircraft.Weight.MTOW;

end