## EU Truck Model - DAF Specialization
This project implements a high-fidelity truck and trailer vehicle model using Simscape and Simscape Multibody, specialized for the European DAF Truck configuration.

The main model is [sm_car_Axle3.slx](sm_car_Axle3.slx).

## Key Features
- **Script-Based Source of Truth**: Completely eliminated binary `.mat` dependencies. Parameters are now defined in human-readable MATLAB scripts for transparency and version control.
- **Single-Source Configuration**: Consolidated all DAF truck and trailer logic into unified parameter sets.
- **Asset Optimized**: Removed over 40MB of unreferenced CAD data; model icons are now specifically targeted to the DAF truck configuration.

## Model Description
The model performs both open- and closed-loop simulations for vocational and heavy-duty vehicle assessment.

![Model overview](Libraries/Images/Documentation/modelOverview.png) 

### Data Structure
The model configuration is driven by the following master scripts:
- `Scripts_Data/Data_Vehicle/paramVehicle_DAF.m`: Master parameters for the DAF 3-axle truck.
- `Scripts_Data/Data_Vehicle/paramTrailer_DAF.m`: Master parameters for the Kumanzi trailer.

Other transient data (Road, Scene, Maneuver) is managed via the standard Simscape Vehicle Template structures.

## Simulate the Model
Opening the MATLAB project automatically triggers `startup_sm_car.m`, which initializes the search paths and loads the DAF parameters into the workspace.

Pre-configured scenarios:
- **Wide Open Throttle**: Acceleration and braking performance.
- **Double Lane Change**: High-speed lateral stability.
- **Idle Test**: Static suspension and load tuning.

## Installation
Developed in MATLAB release **24b**.
Requires: Simscape, Simscape Multibody, Simscape Driveline, Automated Driving Toolbox, Vehicle Dynamics Blockset.

## Support
Lorenzo Nicoletti & Jan Janse van Rensburg

## Authors and Acknowledgment
- **Lorenzo Nicoletti**: Original Developer
- **Jan Janse van Rensburg**: Project Specialization & Optimization

## License
No license needed. Not open source.