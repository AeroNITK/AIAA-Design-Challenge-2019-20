function value = Obj_Func_TS(x)
    
    global Aircraft
    
    Aircraft.Wing.S = x(1);
    Aircraft.Wing.Aspect_Ratio = x(2);
    Aircraft.Wing.b = sqrt(Aircraft.Wing.Aspect_Ratio*Aircraft.Wing.S);
    Aircraft.Wing.taper_ratio = x(3);
    Aircraft.Wing.Sweep_qc = x(4);
    Aircraft.Wing.t_c_root = x(5);
    Aircraft.Performance.TbyW = x(6);
    
    Aircraft.Weight.MTOW = 350000;  % Initial Guess
    
    Aircraft = Performance(Aircraft);
    
    Aircraft.Performance.WbyS = Aircraft.Weight.MTOW/Aircraft.Wing.S;
    
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
    
    value = Aircraft.Weight.MTOW;

end