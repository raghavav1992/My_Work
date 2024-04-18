#!/bin/bash

create_user(){
  #. $1 => username
  #. $2 => ssh public key
  echo "creating { $1 } system user..."
  useradd -m $1 && mkdir /home/$1/.ssh
  usermod -s /bin/bash -aG sudo $1
  echo "$1:1234567890" | chpasswd
  echo "$2" > /home/$1/.ssh/authorized_keys
}

create_ssh_2fa(){
  echo "enabling the ssh password authentication..."
  sed -i 's/PasswordAuthentication\ no/PasswordAuthentication\ yes/g' /etc/ssh/sshd_config
  sed -i 's/ChallengeResponseAuthentication\ no/ChallengeResponseAuthentication\ yes\nAuthenticationMethods publickey,password/g' /etc/ssh/sshd_config
  systemctl reload sshd
}

create_motd(){
  echo "creating { message of the day } ..."
  cat << "EOF" > /etc/motd
 
                               )        (       )     )
     (      *   )  *   )    ( /(   *   ))\ ) ( /(  ( /(
     )\   ` )  /(` )  /((   )\())` )  /(()/( )\()) )\())
  ((((_)(  ( )(_))( )(_))\ ((_)\  ( )(_))(_)|(_)\ ((_)\
   )\ _ )\(_(_())(_(_()|(_) _((_)(_(_()|_))   ((_) _((_)
   (_)_\(_)_   _||_   _| __| \| ||_   _|_ _| / _ \| \| |
    / _ \   | |    | | | _|| .` |  | |  | | | (_) | .` |
   /_/ \_\  |_|    |_| |___|_|\_|  |_| |___| \___/|_|\_|
  
  #######################################################################
  This system is for the use of authorized users only. This system is a 
  property of Mobisy Technologies. Individuals using this computer system 
  are subject to having all their activities on this system monitored and 
  recorded by system personnel. Any misuse will be liable for prosecution 
  or other disciplinary actions.
  
   ** DISCONNECT IMMIDIATELY IF YOU ARE NOT AUTHORIZED PERSON !!!
  
  #######################################################################

EOF
}
create_user raghavav "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC51zOligeWaXyz790sonxooyZpu9Wc8lCOCNCrvpuVn8NBPKoV1o6lvILmcJcvSjU9mWWFMILLMgxf8umK+g5zNCxglYoQSKS1gINj8fV/N0pqoJuydW1u7lhCqUlzhosE9lkYo8C+YiceZ27kvMMa3Hx/k7wx+gSVGS/sq/qbdhMckrj8BDNxp27UR5HRl+NSY6bgLqs53zjWihLrRK1VxcPtcOr4650yTtGdRd9Chz4jZPauxE+Ca9YT4j8bQxjXwi6T9R1MOkw9U3vykpbWtOIQnwQ/wWxMVZIUOZbJ9L9QmdziCh1avtOWQ/0CIUjmHVTbKt7P8Hubid2G2MqXrsOs+ReI+BixshXnj3wcfbf98JAVrU83+Y7sqLMMyCl8jvrjyA/ImJwXNcgz0/kUG7NNVpnq6FjrIKAUEJ4/R8hgHh29IkXT6+zQNBqlnv9xAiUehwxjptceaCVGfnkDjLXbpDczaDzHlI4lH67bUQ2oKvmwwPDjgX9hFrKCi2M= ubuntu@raghavav-l"

create_motd
create_ssh_2fa
#CWAgent_install