Packet-Scheduling
===========================
## Description
### Background
![image](https://github.com/14-760-S20-Team7/Packet-Scheduling/blob/master/image/data_center.png)  
Modern data center can be pushing multiple types of traffic. They can be pushing user facing high priority web traffic, high priority backend traffic and lower priority copy traffic for application. This can cause multiple conflicts in the network. Besides, current servers can be servering a large amount of flows, like ten of thousands of flows at very high speed and given very small time budget per packet. Packet scheduling can easily become the network system bottleneck because of the large number of buffered packets. Thus, to optimize network performance, packet scheduling is a good and important component.  
In our project, we study and deploy [Eiffel](https://www.usenix.org/conference/nsdi19/presentation/saeed), an efficient and flexible software packet scheduling system, analyze its performance on AWS. And we are developing tool for priority configuration.

### Use Case
Software scheduler can be implemented in kernel space or usersapce. In our project, it would be implemented in the kernel module as qdisc (queueing discipline). To evaluate the traffic shaping effect, we use two AWS EC2 instances as the client and server, and use neper to generate a large number of flows between them. We measure the CPU overhead of different schedulers using `dstat`.

## Progress
### Research on Neper and BESS
- Neper (a load generator for linux kernel use case)
- BESS (a software switch for user space use case)

### Research on algorithm
- Priority Queue (cFFS)
- PIFO model extension  
-  Details about the above researches could be found in the [Midterm report](https://docs.google.com/document/d/1EVX2nIhreSNcIEetghqFkokzMUnvDQfx9hfE8U013dM/edit?ts=5e619bad#heading=h.lx1fcchkkaqo).
### **Current development (deploy trials)**
- Since the author didn’t explain the algorithm in detail, we decided to run one of the use cases first and see what could be found. We have found the linux-kernel implementation written by the author and want to deploy it on AWS.
- We follow the instructions [here](https://saeed.github.io/eiffel/).
  1. We tried both `working_ffs-based_qdisc` branch and `v4.10-gq` branch. And tried on m4.xlarge and m4.16xlarge. 
  2. In the step 3 of the tutorial, we follow the instructions [here](https://www.freecodecamp.org/news/building-and-installing-the-latest-linux-kernel-from-source-6d8df5345980/) to compile and install the designed version of linux kernel.
  3. To compile `working_ffs-based_qdisc` branch on m4.xlarge, we need another patch [here](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/?id=474c90156c8dcc2fa815e6716cc9394d7930cb9c).
  4. To run the new algorithm, we should still use `fq` instead of `gq` because the author simply built the new implementation on top of `fq` as we noticed in his code.


## Result  
  We deploy Eiffel on AWS (m4.4xlarge) successfully and analyze its CPU Utilization.
    ![image](https://github.com/14-760-S20-Team7/Packet-Scheduling/blob/master/image/FQ_Eiffel_CPU_Utilization.png)  
We perform the experiments on m4.xlarge, m4.2xlarge and m4.4xlarge on AWS. And here is the result of the experiment on m4.4xlarge. In this experiment, we started 1000 tcp flow with 4 threads using nepper. And we use `dstat` to collect the system cpu utilization every second. The result shown above supports the [author’s claim](https://www.usenix.org/system/files/nsdi19-saeed.pdf) that Eiffel reduces CPU overhead compared to FQ.

## Issues
We have met a lot of problems during the deployment of Eiffel, here is the problems and our solutions:
- **Fail to compile the Linux kernel**  
Solution: apply patch to the kernel.

- **Fail to deploy the custom queue as qdisc (Eiffel)**  
We followed the author’s instruction and tried to deploy the Eiffel queue as qdisc with command `tc qdisc add dev ens3 root gq`. But we find that the custom qdisc is not deployed by using `tc qdisc show`. Then we confirmed this by using `strace` and figured out that the system cannot find the target `.so` file and fails silently. Finally, we checked the scheduler Makefile and found out that the custom gq is actually deployed as `fq` instead of the `gq`.  
Solution: Use `tc qdisc add dev ens3 root fq` to deploy instead.

- **Fail to compile the Linux kernel on m4.16xlarge**  
We created an image of the provided Linux kernel on m4.large, and fail to use this image on m4.16xlarge. We also tried to compile this image on m4.16xlarge directly, but still fail after we reboot the machine. We suspect that the different version of linux may casue this error. 
Solution: Perform experiments on smaller machines.

## Next Step

To measure the overhead benefit of Eiffel packet scheduler, the kernel use case in paper just sends a large number of the same TCP flows. However, this evaluation only considers the time-based priority, but fails to consider wider rankings like different Quality of Service(QoS) rankings of packets. **In the next step, we will improve the completeness of kernel use cases by self-defined packets priority, and packaging this as a Linux command line tool serving as a self-defined INPUT/OUTPUT packet ranking tool.**

The packet carries six bits of Differentiated Service Codepoint(DSCP) in its IP, which can denote 64 kinds of importance or priority. The top 3 bits of DSCP defines Class Selector Codepoints(CS), mapping to IP priority level 0-7. For example, for Assured Forwarding(AF), the top 4th and 5th bits define the drop possibility level (01-Low Drop; 10-Medium Drop; 11-High Drop). 

We plan to modify the DSCP to generate different QoS packets through changing the iptables. More specifically, using command `sudo iptables -t mangle -A <OUTPUT/INPUT> -p tcp -s  <src ip> -d <dst ip> -j DSCP --set-dscp <dscp value>` to add rules, which set DSCP rules in the INPUT Chain and OUTPUT Chain in iptables.

## Links
[Eiffel](https://www.usenix.org/conference/nsdi19/presentation/saeed)  
[Qdisc implementation](https://github.com/saeed/eiffel_linux)  

