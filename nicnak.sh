#! /bin/bash

# run as a daemon that will sit around and wait for a 
# specific set of conditions when the primary NIC's are 
# replaced and the udev needs cleaning out.

while ( true ); do
  
  # first .. check for the new ethernet devices
  eth4=$(ip link show eth4) 
  if [ $? == 1 ]; then
    # now check to see if bond0 is down because 
    # the interfaces died.
    bond_up=$(cat /proc/net/bonding/bond0| grep MII\ Status | grep up) 
    if [ $? == 1 ]; then
      # clear the rules
      rm /etc/udev/rules.d/70-persistent-net.rules

      # now we start the reboot process.
      shutdown -r +5 "Rebooting system to reset udev for NICs"
      
      # sleep till we're dead.
      sleep 600
      
    fi
  fi
  # check again in 10 minutes.
  sleep 600
done

    