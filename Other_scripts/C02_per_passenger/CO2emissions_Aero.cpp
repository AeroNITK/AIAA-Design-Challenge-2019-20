//AeroNITK
//carbon dioxide emissions per passenger

#include<iostream>
#include<math.h>
#include<conio.h>

using namespace std;

int main()
{
	float totfuel=76330; //Wf value(SI UNITS) taken from the fuel estimation sheet
	float no_of_yseats=353,CO2; //353 economy class seats obtained from VSP model
	//the values in the following array vairables have been taken from the ICAO CO2 EMSSION CALCULATOR doc for the 40 travel routes
	float pax_freight_fac[50]={72.90,71.10,77.28,79.21,60.20,83.00 ,81.05 ,77.10 ,82.08 ,76.40 ,82.85 ,73.50 ,76.69 ,74.38 ,75.08 ,82.16 ,80.50 ,79.50 ,82.20 ,81.10,76.00 ,60.35 ,66.92 ,75.60 ,80.89 ,71.13 ,81.78 ,76.50 ,76.05 ,77.40 ,76.10 ,72.50 ,77.91 ,77.50 ,77.90 ,80.44 ,77.50 ,79.66 ,80.61 ,77.58 };
	float pax_load_factor[50]={72.90 ,83.90,83.09 ,90.74 ,84.41 ,84.41 ,86.96 ,92.96 ,89.68 ,63.49 ,81.26 ,62.28 ,79.99 ,80.65 ,77.17 ,82.16 ,79.63 ,63.49 ,63.49 ,77.10 ,63.49 ,82.16 ,84.41 ,94.90 ,79.99 ,96.23 ,84.41  ,93.34 ,79.99 ,79.99 ,82.64 ,84.41 ,84.63 ,79.56 ,81.26 ,81.26 ,66.34 ,84.44 ,77.50 ,62.28,79.99};
	
	for(int i=0;i<40;i++)
	{
		CO2=0;
		CO2=3.16*(totfuel*pax_freight_fac[i])/(no_of_yseats*pax_load_factor[i])	;
		
		cout<<"Carbon Dioxide Emissions for case "<<i+1<<"="<<CO2<<endl<<endl;
	}	
	
	return 0;
	
}

