%  Aircraft Payload & Crew Weight Calculation
%  ------------------------------------------------------------------------
%  Input : Aircraft structure datatpye.
%  Output : Aircraft sturcture datatype with appended payload data.
%  All units are in FPS System.

function Aircraft = Crew_Payload_Weight(Aircraft)

    %%% Crew (Pilots and Attendants)
    Aircraft.Crew.pilot = 2;
    Aircraft.Crew.attendants = 8;

    %%% No. of Passengers in economy and business class
    Aircraft.Passenger.economy = 350;
    Aircraft.Passenger.business = 50;
    
    %%% Individual weight of a person and baggage
    Aircraft.Weight.baggage = 30;
    Aircraft.Weight.person = 200;
    
    %%% Calculating weight of total payload ans crew
    Aircraft.Weight.payload = (Aircraft.Weight.baggage + Aircraft.Weight.person)...
                        *(Aircraft.Passenger.economy + Aircraft.Passenger.business);
                    
    Aircraft.Weight.crew = (Aircraft.Weight.baggage + Aircraft.Weight.person) ...
                        *(Aircraft.Crew.pilot + Aircraft.Crew.attendants);                

end