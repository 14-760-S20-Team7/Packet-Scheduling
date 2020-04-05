git clone https://github.com/saeed/eiffel_linux.git
cd eiffel_linux
git checkout working_ffs-based_qdisc
# download diff from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/?id=474c90156c8dcc2fa815e6716cc9394d7930cb9c, save as kernel.patch
patch -p1 < kernel.patch
sudo apt-get update
sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc
sudo make && sudo make modules_install && sudo make install 
sudo update-grub 
sudo shutdown -r now
