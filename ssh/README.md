Tarkoituksena oli konfiguroida SSH uuteen porttiin Puppetilla.

Tehtävä on osa Haaga-Helian Linuxin keskitetty hallinta -kurssia.

## Koneen tiedot

OS: Windows 10, 64-bit

CPU: Intel Core i5 6600K @ 3.5 GHz

RAM: 16,00 Gt

## Valmistelut

Tehtävää varten asensin omalle kotikoneelleni Virtualboxin ja sen sisälle asentui Xubuntu 16.04

Ensimmäiseksi hain päivitykset seuraavilla komennoilla:

$ sudo apt-get update
$ sudo apt-get upgrade

$ sudo apt-get install -y git puppet

## Moduuli

Ensimmäiseksi loin uuden moduulin

$ mkdir ssh
$ cd ssh/
$ mkdir manifests
$ mkdir templates
$ cd manifests/
$ nano init.pp

	class ssh {
		package {'ssh':
			ensure => "installed",
		}
	}

$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"ssh":}'

	Notice: Compiled catalog for labra.elisa in environment production in 0.20 seconds
	Notice: /Stage[main]/Ssh/Package[ssh]/ensure: ensure changed 'purged' to 'present'
	Notice: Finished catalog run in 1.68 seconds

## Template

Seuraavaksi loin uuden templaten joka vaihtaa SSH:n portin ja päivitin init.pp:n.

$ sudo cp /etc/ssh/sshd_config /home/niko/git/puppet/ssh/templates/
$ sudo chown niko:niko /home/niko/git/puppet/ssh/templates/sshd_config 
$ nano /home/niko/git/puppet/ssh/templates/sshd_config

	Port 2222
	Protocol 2
	HostKey /etc/ssh/ssh_host_rsa_key
	HostKey /etc/ssh/ssh_host_dsa_key
	HostKey /etc/ssh/ssh_host_ecdsa_key
	HostKey /etc/ssh/ssh_host_ed25519_key
	UsePrivilegeSeparation yes
	
	KeyRegenerationInterval 3600
	ServerKeyBits 1024
	
	SyslogFacility AUTH
	LogLevel INFO
	
	LoginGraceTime 120
	PermitRootLogin prohibit-password
	StrictModes yes

	RSAAuthentication yes
	PubkeyAuthentication yes
	
	IgnoreRhosts yes
	RhostsRSAAuthentication no
	HostbasedAuthentication no
	
	PermitEmptyPasswords no
	
	ChallengeResponseAuthentication no
	
	X11Forwarding yes
	X11DisplayOffset 10
	PrintMotd no
	PrintLastLog yes
	TCPKeepAlive yes
	
	AcceptEnv LANG LC_*

	Subsystem sftp /usr/lib/openssh/sftp-server
	
	UsePAM yes
	
nano init.pp

	class ssh {
        	package {'ssh':
                	ensure => "installed",
        	}
	
        	service {'ssh':
                	ensure => "running",
                	enable => "true",
                	require => Package["ssh"],
        	}
        	file {'/etc/ssh/sshd_config':
                	content => template("ssh/sshd_config"),
                	require => Package["ssh"],
                	notify => Service["ssh"],
        	}
	}


$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"ssh":}'

	Notice: Compiled catalog for labra.elisa in environment production in 0.31 seconds
	Notice: /Stage[main]/Ssh/File[/etc/ssh/sshd_config]/content: content changed '{md5}2b0a5b3fb7601ccb0fe9922e8a636604' to '{md5}db374754d32c7ccdb0ae75b736430b79'
	Notice: /Stage[main]/Ssh/Service[ssh]: Triggered 'refresh' from 1 events
	Notice: Finished catalog run in 0.07 seconds

$ cat /etc/ssh/sshd_config

	Port 2222
	Protocol 2
	HostKey /etc/ssh/ssh_host_rsa_key
	HostKey /etc/ssh/ssh_host_dsa_key
	HostKey /etc/ssh/ssh_host_ecdsa_key
	HostKey /etc/ssh/ssh_host_ed25519_key
	UsePrivilegeSeparation yes
	
	KeyRegenerationInterval 3600
	ServerKeyBits 1024
	
	SyslogFacility AUTH
	LogLevel INFO
	
	LoginGraceTime 120
	PermitRootLogin prohibit-password
	StrictModes yes
	
	RSAAuthentication yes
	PubkeyAuthentication yes
	
	IgnoreRhosts yes
	RhostsRSAAuthentication no
	HostbasedAuthentication no
	
	PermitEmptyPasswords no
	
	ChallengeResponseAuthentication no
	
	X11Forwarding yes
	X11DisplayOffset 10
	PrintMotd no
	PrintLastLog yes
	TCPKeepAlive yes
	
	AcceptEnv LANG LC_*
	
	Subsystem sftp /usr/lib/openssh/sftp-server
	
	UsePAM yes

$ ssh niko@localhost

	ssh: connect to host localhost port 22: Connection refused

$ ssh niko@localhost -p 2222

	The authenticity of host '[localhost]:2222 ([127.0.0.1]:2222)' can't be established.
	ECDSA key fingerprint is SHA256:V+WuJF3LMxMzwLl+AGtMoRe8DEexb/3tv7v3MeaEmSM.
	Are you sure you want to continue connecting (yes/no)? y
	Please type 'yes' or 'no': yes
	Warning: Permanently added '[localhost]:2222' (ECDSA) to the list of known hosts

## Lähteet

http://terokarvinen.com/2013/ssh-server-puppet-module-for-ubuntu-12-04
