# PV_rephasing-smartgrid

## PV rephasing
This repo contains the code and relevant data for the PV rephasing work done by the smart grid research group at DEEE UOP.<br>
This is the pioneering work in PV rephasing which introduces the concept of PV rephasing and its effectiveness in mitigating the voltage unbalance problem in the Low Voltage(LV) Grid due to rooftop solar PV penetration.

Research student: [Chaminda Bandara](https://scholar.google.com/citations?user=WwLxOJYAAAAJ&hl=en)<br>
Supervisors: [Prof J.B Ekanayake](http://eng.pdn.ac.lk/deee/academic-staff/prof.jb.ekanayake/index.html#home), [Dr. Roshan Godaliyadda](http://eng.pdn.ac.lk/deee/staff/academic/dr.gmri.godaliyadda/profile.php), [Dr. Parakrama Ekanayake](http://eng.pdn.ac.lk/deee/staff/academic/dr.mpb.ekanayake/profile.php)

You can find the published paper [here](https://www.sciencedirect.com/science/article/abs/pii/S0306261920314641). Please email authors(or smart grid team) if you are unable to access the full paper. <br>

## Description of research work

This is the first paper in the Smart Grid research community that introduces the concept of PV rephasing. The idea is to switch rooftop solar PV amongst the 3 phases in an optimized manner to reduce the voltage unbalance problem in the LV grid. The main contributions of the paper are:


## The network used in the research
The research findings are validated by simulating on an actual existing network in [Dehiwala, Sri Lanka](https://www.google.com/maps/place/Lotus+Grove/@6.8453557,79.8783252,15z/data=!4m5!3m4!1s0x0:0xa5e9d2a4922d6c45!8m2!3d6.8453557!4d79.8783252). The netowrk is called the Lotus Grove network- which is the name of the region. The schematic of the network is shown below.

<img src="Lotus Grove.png" alt="Lotus Grove" width="750" height="600"/>
<!-- ![random](<https://github.com/eepdnaclk/state_estimation-smartgrid/blob/main/Lotus Grove.png> "Lotus Grove Network") -->


## Running the code

The entire codebase is written in MATLAB. The script uses the MATLAB to OpenDSS interface to access OpenDSS for power flow simulations. Therefore, MATLAB and OpenDSS are used together for the simulations. <hr>

OpenDSS is an open source software which you can obtain [here](https://sourceforge.net/projects/electricdss/) for Windows or [here](https://sourceforge.net/p/electricdss/discussion/861976/thread/e13492c302/?limit=25#f639) for Linux and MacOS versions (Check Paulo Meira's comment). You will need to have the relevant DSSStartup.m scripts in the working directory of the MATLAB sscript to run your code. <hr>

Do explore the others. 
