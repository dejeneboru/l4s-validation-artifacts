# l4s-validation-artifacts
A repository to reproduce the results in a paper "Validating the Sharing Behavior and Latency Characteristics of the L4S Architecture"

## Instructions ##
For our experiments, Ubuntu 18.04 is installed on all nodes, clients, servers, and the AQM node (see the setup figure).

## Install a Kernel tree which contains the DualPI2 Qdisc and TCP Prague
   (Only on Server A, Client A and the AQM node)

	1. Install gcc and other build tools 
	   sudo apt-get install build-essential libncurses-dev bison flex libssl-dev libelf-dev
	2. Clone L4S kernel 
	   git clone https://github.com/L4STeam/linux.git > L4SKernel
	3. Compile and Install the L4S kernel 
	   cd L4SKernel
	   cp -v /boot/config-$(uname -r) .config
	   make -j $(nproc)
	   sudo make INSTALL_MOD_STRIP=1 modules_install && sudo make install
	   sudo update-grub
	   reboot
	 


