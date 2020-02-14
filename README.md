# l4s-validation-artifacts
A repository to reproduce the results in the paper "Validating the Sharing Behavior and Latency Characteristics of the L4S Architecture"

## Instructions ##

Ubuntu 18.04 is installed on all nodes (see l4s-valid-setup.pdf).

## Install a Kernel tree which contains the DualPI2 qdisc and TCP Prague congestion control
   (Only on Server A, Client A and the AQM node)
		1. Install gcc and other build tools 
		   sudo apt update upgrade install build-essential libncurses-dev bison flex libssl-dev libelf-dev
		2. Clone L4S kernel 
		   git clone https://github.com/L4STeam/linux.git > L4SKernel
		3. Compile and Install the L4S kernel and don't forget to set the TCP Prague and DualPI2 qdisc modules when you run 'make menuconfig'!
		   cd L4SKernel 
		   cp -v /boot/config-$(uname -r) .config
		   make menuconfig
		   make -j $(nproc)
		   sudo make INSTALL_MOD_STRIP=1 modules_install && sudo make install
		   sudo update-grub
		   reboot
## Install OpenSSH Server on all nodes
	   sudo apt install openssh-server
## Allow sudo access on the Clients and Servers from the AQM node
	   1. ssh to the clients and servers
	   2. Run 'sudo visudo' and add 'YOUR_USERNAME ALL=(ALL) NOPASSWD: ALL' and save the changes.
## Clone this repository to the AQM node
	   1.  git clone https://github.com/dejeneboru/l4s-validation-artifacts.git > L4SValid
	   2.  cd L4SValid
	   3.  Copy 'trace_cwnd.sh' script to Server A and Server B
	       scp trace_cwnd.sh ${IP_SERVER_A}:/home/${YOUR_USERNAME}/
	       scp trace_cwnd.sh ${IP_SERVER_B}:/home/${YOUR_USERNAME}/
	   4. Don't forget to replace the 'SERVER_IP' field with server A's and server B's IP
	   5. Modifiy the script 'run_experiment.sh' by replacing the IPs of the clients, servers, and the AQM node with the IPs for your setup
	   6. Make all scripts (\*.sh) executable e.g., chmod +x run_experiment.sh
	   7. Set IP forwarding on AQM node
	      sudo sysctl -qw net.ipv4.ip_forward=1 
## Run the experiments by starting the run script from the AQM node.
	   ./run_experiment.sh
	   This will generate the data to reproduce figures 4, 5, 9, and 10 in the paper.

##  Reproducing Figure 6
	    To reproduce the experiment with RTT of DCTCP flow different from RTT of Cubic flow, you may emulate the RTTs on the servers' interface (Server A and Server B) instead of the AQM interface. Don't forget to set the servers's interface to your configuration!
	    1. Modify the script run_diff_rtt_expt.sh with the servers' interface of your configuration
	    2. Run the test  
	       ./run_diff_rtt_expt.sh

## Reproducing the result with single queue AQM (Figure 3)
	   1. Clone the DualPI2 qdisc which supports both Single Queue and Dual queue AQM and install on the AQM node. You might need to also setup the correct iproute package!
	   2. Start the experiment 
	      ./run_single_queue.sh 
	 


