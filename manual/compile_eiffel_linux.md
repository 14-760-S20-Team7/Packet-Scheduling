Compile Eiffel Linux Manual
----

1. Provision an `m4.xlarge/m4.2xlarge/m4.4xlarge` EC2 instance using AMI `Ubuntu Server 16.04 LTS (HVM), SSD Volume Type`

2. Login into instance
	
	```
	ssh -i <pem file> ubuntu@<instance public dns>
	```

3. Clone the Eiffel linux repo
	
	```
	git clone https://github.com/saeed/eiffel_linux.git
	cd eiffel_linux
	```
4. Checkout the FFS-based Qdisc for a full Eiffel-based rate limiter
	
	```
	git checkout working_ffs-based_qdisc
	```
5. Download patch from [here](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/?id=474c90156c8dcc2fa815e6716cc9394d7930cb9c), save as `kernel.patch`
6. Patch
	
	```
	patch -p1 < kernel.patch
	```
7. Install some packages for compiling
	
	```
	sudo apt-get update
	sudo apt-get install git fakeroot build-essential ncurses-dev 	xz-utils libssl-dev bc
	```
8. Compile. This step may take 10 ~ 30 minutes. You can check core number using command `nproc` 
	
	```
	sudo make -j <core number> && sudo make modules_install -j <core number> && sudo make install -j <core number>
	```
9. Add new kernel to grub's configure file
	
	```
	sudo update-grub 
	```
10. Restart to use new kernel
	
	```
	sudo shutdown -r now
	```