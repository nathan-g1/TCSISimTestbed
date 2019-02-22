# SimEngineBenchmark

## Table of Contents
  1. [Introduction](https://github.com/nkymark/SimEngineBenchmark#introduction)
  2. [Modelling The Engine](https://github.com/nkymark/SimEngineBenchmark#modelling-the-engine)
  3. [Fault Scenarios](https://github.com/nkymark/SimEngineBenchmark#fault-scenarios)
  4. [Residuals Generation](https://github.com/nkymark/SimEngineBenchmark#residuals-generation)
  5. [Simulation Environment](https://github.com/nkymark/SimEngineBenchmark#the-simulation-environment)


## Introduction
Research on fault diagnosis and fault isolation on highly nonlinear dynamic systems such as the engine of a vehicle has garnered huge interest in recent years, especially with the automotive industry heading towards autonomous operations and big data. This simulation benchmark model of a single turbocharged petrol engine engine system is designed and developed for testing and evaluation of residuals generation and fault diagnosis methods. 

This benchmark model will serve as an excellent platform to demonstrate the effectiveness in simulating and presenting results on the fault diagnostic of automotive systems for the development and comparison of current and future research methods as well as for teaching initiatives. The engine model used is based on the mean value engine model (MVEM) with a PI-based boost controller. The benchmark is programmed in the MATLAB/Simulink environment and it provides realistic simulations of the engine system with a selection of faults of interest and industrial-standard driving cycles via a GUI interface. The simulation kit is available free and as an open-source, and distribued under the [GNU license](https://en.wikipedia.org/wiki/GNU_General_Public_License). 

If you use this benchmark model in your research, please cite the following publication:
- K. Y. Ng, E. Frisk, M. Krysander, and L. Eriksson, "A Single Turbocharged Petrol Engine System as a
Simulation Benchmark Model for Fault Diagnosis", 2019.


## Modelling The Engine
The simulation environment uses a 1.8L 4-cylinder single turbocharged spark ignited (TCSI) petrol engine as the benchmark. It consists of the following subsystems: Air filter, Compressor, Intercooler, Throttle, Intake manifold, Engine block, Exhaust manifold, Turbine, Wastegate, and Exhaust system. The engine system is modelled using dynamical equations that describe the air flow through the subsystems in the engine. These equations are derived based on the mean value engine model (MVEM) for a single turbocharged petrol engine as reported by Eriksson in the following paper:
- [L. Eriksson. "Modeling and control of turbocharged SI and DI engines," *Oil & Gas Science and Technology-Revue de l'IFP*, 62(4), pp.523-538, 2007.](https://ogst.ifpenergiesnouvelles.fr/articles/ogst/abs/2007/04/ogst06101/ogst06101.html)

<p><img src="/Figures/EngineDiag.png" width="500" align="right"><span>A PI-based boost controller with anti-windup is used to produce the control inputs: Throttle effective area and Wastegate actuator for the turbocharger. In addition to the control inputs, the engine has the following actuators: Reference engine speed, Air-fuel ratio, Ambient pressure, and Ambient temperature. In addition, the engine has the following sensor measurements: Temperatures (compressor, intercooler, intake manifold), Pressures (compressor, intercooler, intake manifold, exhaust manifold), Air filter mass flow, and Engine torque.</span></p>

The new European standard Worldwide harmonised Light vehicle Test Procedure (WLTP) driving cycle is used to verify the performance of the boost controller.


## Fault Scenarios
The benchmark model considers sensor, actuator, and variable faults in different parts of the engine system. There are 11 faults; 6 variable faults (``fp_af``, ``fC_vol``, ``fW_af``, ``fW_th``, ``fW_c``, ``fW_ic``), 1 actuator measurement fault (``fx_th``), and 4 sensor measurement faults (``fyW_af``, ``fyp_im``, ``fyp_ic``, ``fyT_ic``).

The faults are of different degrees of severity. Some faults are less severe and the engine can be reconfigured to a reduced performance operation mode to accommodate the faults until the vehicle is sent into the workshop for repair and maintenance. Some other faults are more severe that if not detected and isolated promptly, might cause permanent and serious damages to the engine system, which in turn will endanger the occupants in the vehicle as well as other road users.


## Residuals Generation



## The Simulation Environment
The figure below shows the GUI of the benchmark model in MATLAB. Through this interface, the user can set the preferences for simulation settings, design and test their residuals generation and fault diagnosis schemes, as well as view simulation results.
![](/Figures/GUI.png)
###### The main GUI of the benchmark model in MATLAB; 1) Sets the fault mode for simulation. 2) Sets the driving cycle. 3) Sets the simulation mode. 4) Runs the simulation. 5) Exits and closes the benchmark GUI. 6) Shows the simulation progress and log. 7) Click to open the reference generator Simulink model. 8–9) Click to open the boost controller and engine Simulink model. 10) Click to open the residuals generator Simulink model. 11) Click to open the fault diagnosis design scheme M-file. 12) Click to open the residuals generator design scheme M-file. 13) Displays the residuals generated. 14) Displays the reference torque vs actual torque of the engine. 15) Displays the fault signal induced (normalised).

In the top right section of the GUI, a block diagram representation of the engine control system, residuals generator, and fault diagnosis scheme can be found. The user can click on each block to access the corresponding Simulink model or M-file. For example, the user could use the ‘Residuals Generator (Simulink)’, ‘Residuals Generator Design (M-file)’, and ‘Fault Isolation Scheme Design (M-file)’ components to edit their design and codes for the residuals generation and fault diagnosis algorithms. The ‘RUN SIMULATION’ pushbutton starts the simulation and the ‘EXIT’ pushbutton exits the simulation environment and closes the GUI.

The results obtained from the simulation are displayed in the bottom right section of the GUI. The results displayed are the reference vs actual engine torque, and the normalised plot of the fault induced. A ‘Simulation Log’ is also available in the bottom left section of the GUI to show a summary of the simulation settings and to provide an update in real-time on the progress of the simulation. The plots and the ‘Simulation Log’ are automatically saved into the folder ``‘/Results/DrivingCycle_FaultMode_Date’`` that is located in the same directory as the simulation environment. A MATLAB MAT-file containing key variables and data from the simulation is also saved.

The simulation kit contains the following key files:
- ``main.m`` - Main execution file. Run this file to start the GUI.
- ``Engine.mdl`` - Simulink model of the closed-loop nonlinear engine system. Open the model from the GUI using either the ‘Boost Controller (Simulink)’ or ‘Engine System (Simulink)’ blocks.
- ``GenerateResiduals.m`` - Codes for the residuals generation algorithm to be placed here. Open the file from the GUI using the ‘Residuals Generator Design (M-file)’ button.
- ``ResidualsGen.mdl`` - Simulink model of the residuals generator. The model is called and run from ``GenerateResiduals.m``. The default residuals generated are also filtered and normalised, and added with signal noise. Open the model from the GUI using the ‘Residuals Generator (Simulink)’ block. Replace the ‘Residuals Generator’ in the Simulink model as desired to accommodate other methods for residuals generation.
- ``RunFI.m`` - Algorithm for fault diagnosis to be placed here. Open the file from the GUI using the ‘Fault Isolation Scheme Design (M-file)’ block.


