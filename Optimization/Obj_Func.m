function value = Obj_Func(x)
        
    global Aircraft
    
    Aircraft = Performance(Aircraft);
    
    Aircraft.Performance.TbyW = x(1);
    Aircraft.Wing.Sweep_qc = x(2);
    Aircraft.Wing.t_c_root = x(3);
    Aircraft.Performance.M_cruise = x(4);
    Aircraft.Performance.altitude_cruise1 = x(5);
    Aircraft.Wing.taper_ratio = x(6);
    Aircraft.Wing.Aspect_Ratio = x(7);
%     Aircraft.Performance.WbyS = x(2);
    Aircraft.Wing.S = x(8);
    
    Aircraft.Weight.MTOW = 400000;  % Initial Guess
    error = 1; % Dummy value to start the while loop
    
    while error > 0.005
    
        error = Aircraft.Weight.MTOW;
        Aircraft = Sizing(Aircraft);
        Aircraft.Performance.WbyS = Aircraft.Weight.MTOW/Aircraft.Wing.S;
        Aircraft = Aero(Aircraft);

        Aircraft = Crew_Payload_Weight(Aircraft);
        Aircraft = Empty_Weight(Aircraft);
        Aircraft = Fuel_Weight(Aircraft);
        Aircraft.Weight.MTOW = Aircraft.Weight.crew + Aircraft.Weight.payload + Aircraft.Weight.fuel_Weight...
                               + Aircraft.Weight.empty_Weight;

        error = abs(error - Aircraft.Weight.MTOW);
    
    end
    
    value = Aircraft.Weight.MTOW;

end
