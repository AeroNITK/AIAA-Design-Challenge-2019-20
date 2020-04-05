%  Aircraft Payload Calculation
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended payload data.
%  All units are in FPS System.

function Aircraft = Payload_Weight(Aircraft)

    %%% Crew
    Aircraft.Crew.pilot = 2;
    Aircraft.Crew.attendants = 8;

    %%% Passenger
    Aircraft.Passenger.economy = 350;
    Aircraft.Passenger.business = 50;
    
    %%% Weight
    Aircraft.Weight.baggage = 30;
    Aircraft.Weight.person = 200;
    Aircraft.Weight.payload = (Aircraft.Weight.baggage + Aircraft.Weight.person)...
                        *(Aircraft.Passenger.economy + Aircraft.Passenger.business + ...
                          Aircraft.Crew.pilot + Aircraft.Crew.attendants);

end