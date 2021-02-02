# bolidosGUI
Desktop app for meteor detection using CCTV cameras (e.g Watec). 

This app automatically detects and saves events of moving objects on the sky. 
If a GPS dongle is connected to the PC it parses RMC NMEA sentences to get coordinates and time.

It also enables the user to mask out unwanted regions on the images (e.g. trees, buildings, etc).

For locations with high light pollution, where clouds appear bright in the nightsky, it also implements a tunable cloud detection algorithm. The user can choose a cloud fraction threshold to avoid recordings of events in cloudy nights.

Finally, the user may enter an FTP server to send the recorded events of a night, during the day after.

The source code can be used to compile in MATLAB to any desired OS. 
