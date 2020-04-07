function value = Obj_Func(x)

    global Aircraft
    
    Aircraft = Performance(Aircraft);
    Aircraft.Performance.WbyS = x(2);   % Independent variable 1
    Aircraft.Performance.TbyW = x(1);   % Independent variable 2
    
    Aircraft.Weight.MTOW = 350000;  % Initial Guess
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
