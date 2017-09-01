This release includes Linux* Base Drivers for Intel(R) Ethernet
Network Connections.

- igb driver supports all 82575-, 82576-, 82580-, I350-, I210-, I211- and
  I354-based gigabit network connections.
- igbvf driver supports 82576-based virtual function devices that can only
  be activated on kernels that support SR-IOV.
- e1000e driver supports all PCI Express gigabit network connections, except
  those that are 82575-, 82576-, 82580-, and I350-, I210-, and I211-based*.
  * NOTES:
    - The Intel(R) PRO/1000 P Dual Port Server Adapter is supported by
      the e1000 driver, not the e1000e driver due to the 82546 part being used
      behind a PCI Express bridge.
    - Gigabit devices based on the Intel(R) Ethernet Controller X722 are
      supported by the i40e driver.

igb-x.x.x.tar.gz
igbvf-x.x.x.tar.gz
e1000e-x.x.x.tar.gz


Due to the continuous development of the Linux kernel, the drivers are updated
 more often than the bundled releases. The latest driver can be found on
 http://e1000.sourceforge.net (and also on http://downloadcenter.intel.com.)


Upgrading
---------

If you currently have the e1000 driver installed and need to install e1000e,
perform the following:

- If your version of e1000 is 7.6.15.5 or less, upgrade to e1000 version
  8.x, using the instructions in the e1000 README.
- Install the e1000e driver using the instructions in the Building and
  Installation section below.
- Modify /etc/modprobe.conf to point your PCIe devices to use the new e1000e
  driver using alias ethX e1000e, or use your distribution's specific method
  for configuring network adapters like RedHat's setup/system-config-network
  or SuSE's yast2.


