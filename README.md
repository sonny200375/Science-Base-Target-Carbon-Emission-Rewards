# Science Base Target Carbon Emission Rewards
Science Based Target Carbon Emission Rewards is Simple Plutus Program as part ofset ambitious emissions reductions targets in line with  the latest climate science. It is focused on accelerating companies across the world to halve emissions  before 2030 and achieve net-zero emissions before 2050
The main objective of this standard is to provide a standardized and robust approach for corporates to set netzero targets that are aligned with climate science.
Near-term science-based targets galvanize the action required for significant emissions reductions to be achieved by 2030. Near-term emissions reductions are critical to not exceeding the global emissions budget and are not interchangeable with long-term targets.

# THE SCIENCE BEHIND SCIENCE-BASED NET-ZERO TARGETS
As described in SR15, scenarios that limit warming to 1.5°C with no or limited overshoot reach netzero CO2  emissions around 2050, accompanied by rapid reductions in non-CO2  GHG emissions. 
These scenarios entail profound transitions in the global energy, industry, urban, and land systems that involve:

• Full or near-full decarbonization for energy and industrial CO2 emissions achieving a zero-emissions energy supply system by mid-century.

• Eliminating CO2  emissions associated with agriculture, forestry, and land-use

• Deep reductions in non-CO2  emissions from all sectors.

• Removing CO2  from the atmosphere to neutralize residual emissions and, potentially, sustain net negative emissions that reduce cumulative CO2  in the atmosphere over-time

Figure 1 Schematic target year dependency of near-term SBT in comparison to the target year independency of long-term SBT. 
![sbtgraph](https://user-images.githubusercontent.com/77085029/208818638-70e22af1-1cc7-4964-8b29-1b0d8b14cc76.jpg)

# THE SCIENCE-BASED NET-ZERO TARGETS SCOPE BOUNDARY
This Simple Application simulated rewarding features for Information and Communication Technology (ICTs) companies in setting science based targets for greenhouse gases (GHGs) according to a set of new decarbonisation pathways, described in detail in Recommendation ITU-T L.1470 ‘GHG emissions trajectories for the ICT sector compatible with the UNFCCC Paris Agreement’1  and aligned to the IPCC Special Report on 1.5°C and developed to be used as a sectoral target-setting approach by the Science Based Targets Initiative (SBTi).

Figure 2 ICT Sector emissions trajectories
![ICT_Trajectory](https://user-images.githubusercontent.com/77085029/208819561-f5c8e01b-ab05-496f-b346-6e172d48ad21.png)

# CALCULATION OF SCIENCE-BASED NET-ZERO TARGETS
Sub-sector science based target (SBTs) is then calculated by multiplying the combined Scope 1 and 2 emissions in the base line year (CCb) by an emissions reduction factor (ERF). 
The emissions reduction factor is based on the appropriate sub-sector emission reduction pathway  and the baseline and target years.
Emission Reduction Factor values for mobile, fixed and data centre sub-sectors, and for different baseline and target years compatible

SBTs = CCb . ERF

Carbon Emission Based Rewards only can be withdraw or released when the SBT Validated achieve below Calculated SBT as year target.

Figure 3 Emission Reduction Factors
![datacentererf](https://user-images.githubusercontent.com/77085029/208820173-c70956eb-e047-443b-89ae-ce5f782cbb27.png)

# APPLICATION EXECUTION
This Application run on Plutus Environment and to perform simulation open the Plutus Test Background Environment through website https://playground.plutus.iohkdev.io/.

Copy and paste the program and executed the files.

# APPLICATION POSITIVE AND NEGATIVE TEST
To simulate the Reward Application can go through positive test which are follow condition :

a. SBT Valdated Value shall be below Calculated SBT , and

b. Address Beneficiary shall be the same with target reward Beneficiary, and

c. Pin Authorized to released the Rewards shall be the same

Figure 4 Positive Simulation Test with SBT Validation Lower than Calculated SBT 
![positivetest1](https://user-images.githubusercontent.com/77085029/208822936-473bafd7-1120-40a1-9206-24c31bc0930f.png)


Figure 5 Positive Simulation Test Result in Blockchain with SBT Validation Lower than Calculated SBT
![positivetest2](https://user-images.githubusercontent.com/77085029/208822954-ab5aaadf-262a-44d5-8ce8-d55e30f8390b.png)

To simulate negative tes Reward Scheme can go through follow condition :

a. SBT Valdated Value shall be above Calculated SBT , and

b. Address Beneficiary not the same with target reward Beneficiary, and

c. Pin Authorized to released the Rewards not the same


Figure 6 Negative Simulation Test with SBT Validation Higner than Calculated SBT 
![negativetest1](https://user-images.githubusercontent.com/77085029/208822233-dfac0f53-4f65-4606-8be1-489909a6cff2.png)


Figure 7 Negative Simulation Test Result in Blockchain with SBT Validation Higner than Calculated SBT
![negativetest2](https://user-images.githubusercontent.com/77085029/208822245-a353c5ca-72ef-44bd-8c93-c0e1f32cb64f.png)
