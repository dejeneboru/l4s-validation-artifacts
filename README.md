# l4s-validation-artifacts
A repository to reproduce the results in a paper "Validating the Sharing Behavior and Latency Characteristics of the L4S Architecture"

## Instructions ##
For our experiments, Ubuntu 18.04 is installed on all nodes, clients, servers, and the AQM node (see the setup figure).

## Install a Kernel tree which contains the DualPI2 Qdisc and TCP Prague
   (Only on Server A, Client A and the AQM node)

	1. Install gcc and other build tools 
	   sudo apt update upgrade install build-essential libncurses-dev bison flex libssl-dev libelf-dev
	2. Clone L4S kernel 
	   git clone https://github.com/L4STeam/linux.git > L4SKernel
	3. Compile and Install the L4S kernel. Don't forget to set the TCP Prague and DualPI2 qdisc with 'make menuconfig' !
	   cd L4SKernel 
	   cp -v /boot/config-$(uname -r) .config
	   make menuconfig
	   make -j $(nproc)
	   sudo make INSTALL_MOD_STRIP=1 modules_install && sudo make install
	   sudo update-grub
	   reboot
## Install OpenSSH Server on all nodes 
   sudo apt install openssh-server

## All sudo access on the Clients and Servers from the AQM node
   1. ssh to the clients and servers
   2. Run 'sudo visudo' and add 'YOUR_USERNAME ALL=(ALL) NOPASSWD: ALL' and save the changes.

## Clone this repository to the AQM node
   1.  git clone https://github.com/dejeneboru/l4s-validation-artifacts.git > L4SValid
   2.  cd L4SValid
   3.  Copy 'trace_cwnd.sh' script to Server A and Server B
       scp trace_cwnd.sh ${IP_SERVER_A}:/home/${YOUR_USERNAME}/
       scp trace_cwnd.sh ${IP_SERVER_B}:/home/${YOUR_USERNAME}/
   4. Don't forget to replace the 'SERVER_IP' field with server A and server B's IPs
   5. Modifiy the script 'run_experiment.sh' by replacing the IPs of the clients, servers, and the AQM node with the IPs for your setup
   6. Make all scripts (\*.sh) executable e.g., chmod +x run_experiment.sh
   7. Set IP forwarding on AQM node
       sudo sysctl -qw net.ipv4.ip_forward=1
## Run the experiments by starting the run script from the AQM node
   ./run_experiment.sh




       


	 


