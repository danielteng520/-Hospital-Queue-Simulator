# Hospital Queue Simulator

This repository contains the group project for **TMA1301: Computational Methods**. The project involves developing a simulator for a hospital self-service registration queueing system. The simulator manages patient arrivals and assigns them to kiosks according to different queueing rules. It also calculates performance metrics to assess the efficiency of the queueing system.

## Features
The simulator provides the following functionalities:
1. **Service Time and Arrival Time Generation**: Randomly generates service times for two kiosks and inter-arrival times for patients.
2. **Custom Random Number Generators**: Implements at least two random number generators, with adjustable ranges for realistic simulation.
3. **Queue Management Rules**:
   - **Round Robin**: Alternates patients between Kiosk #1 and Kiosk #2.
   - **Idle Kiosk Assignment**: Directs a patient to an idle kiosk, or Kiosk #1 if both are idle.
4. **User Inputs**:
   - Select the random number generator type.
   - Set the number of patients.
   - Choose the queue management rule.
5. **Real-Time Messages and Tables**:
   - Displays patient arrival and departure messages.
   - Shows tables for service time, inter-arrival time, and simulation results.

## Performance Metrics
The simulator includes calculations for:
- **Average Waiting Time in Queue**
- **Average Time Spent in System**
- **Idle Time of Kiosks**
- **Probability of Waiting**

## Example Output
The simulator displays messages for each patient, e.g.:

Based on your Computational Methods coding assignment, here’s a structured way to set up your GitHub repository for this project, including the repository name, description, and README.

Repository Name
Hospital-Queue-Simulator

Repository Description
"Simulator for a hospital self-service registration queueing system with customizable random number generators and queue management rules. Implements patient arrival, service times, and performance metrics in FreeMat."

README.md
Here’s a comprehensive README.md for your project repository:

markdown
Copy code
# Hospital Queue Simulator

This repository contains the group project for **TMA1301: Computational Methods**. The project involves developing a simulator for a hospital self-service registration queueing system. The simulator manages patient arrivals and assigns them to kiosks according to different queueing rules. It also calculates performance metrics to assess the efficiency of the queueing system.

## Project Overview
Hospitals often use self-service kiosks for patient registration to improve service efficiency. This simulator models the queueing process at two kiosks, allowing for custom rules in managing the queue and different random number generators for simulating arrival and service times.

## Features
The simulator provides the following functionalities:
1. **Service Time and Arrival Time Generation**: Randomly generates service times for two kiosks and inter-arrival times for patients.
2. **Custom Random Number Generators**: Implements at least two random number generators, with adjustable ranges for realistic simulation.
3. **Queue Management Rules**:
   - **Round Robin**: Alternates patients between Kiosk #1 and Kiosk #2.
   - **Idle Kiosk Assignment**: Directs a patient to an idle kiosk, or Kiosk #1 if both are idle.
4. **User Inputs**:
   - Select the random number generator type.
   - Set the number of patients.
   - Choose the queue management rule.
5. **Real-Time Messages and Tables**:
   - Displays patient arrival and departure messages.
   - Shows tables for service time, inter-arrival time, and simulation results.

## Performance Metrics
The simulator includes calculations for:
- **Average Waiting Time in Queue**
- **Average Time Spent in System**
- **Idle Time of Kiosks**
- **Probability of Waiting**

## Example Output
The simulator displays messages for each patient, e.g.:
Patient 1 arrives at minute 0, and gets service at minute 0 Departure of patient 1 at minute 8. Patient 2 arrives at minute 5, and gets service at minute 5 Departure of patient 2 at minute 8.

Tables of service time, inter-arrival time, and simulation results are also displayed.

## Instructions for Running the Simulator
1. This project requires **FreeMat** to run.
2. Download and install FreeMat if not already installed.
3. Run the code file in FreeMat to simulate the hospital queueing system.

## License
This project is for educational purposes as part of coursework for TMA1301.
