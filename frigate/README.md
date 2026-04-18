Steps to install frigate and configure it with the cameras:

1. Install Debian v13 via a usb key flashed using Balena Etcher
- do not install the graphical interface
- enable ssh
(the different steps can be found here: https://www.youtube.com/watch?v=Ncr8tsNYtjQ&list=PLcQNbqlFaNVH6WtMXU6bsxZIBpzllurTV&index=4)

2. Ensure the IP address does not change (either give the machine a static IP or make sure the router always gives the same one to this machine)

3. Connect via ssh using the username / pwd you chose during the debian 13 installation
username:pwd@ip_address

4. type "su -" and use the adming password

5. copy there the frigate.sh script

6. chmod +x frigate.sh

7. ./frigate.sh
(enter the username you chose during the debian v13 installation)

8. disconnect (needed to apply the new permissions to the username)
- exit
- exit (2nd time)
- ssh again to the machine

9. cd ./frigate

10. docker compose up -d

11. in the browser go to the MACHINE_IP_ADDRESS:5000 (do not forget the port)

12. in frigate go to settings => edit configuration, and apply the config described in the frigate_configuration.yml file
