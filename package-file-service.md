# Package, File, Service
Tarkoituksena oli asentaa ja konfiguroida palvelin package-file-service -tyyliin Puppetilla.

## Koneen tiedot
OS: Xubuntu 16.04 LTS, 64-bit

CPU: Intel Core i5 6600K @ 3.50 GHz

RAM: 16,00 Gt

## Valmistelut

Ensimmäiseksi hain päivitykset seuraavilla komennoilla:

	$ sudo apt-get update
	$ sudo apt-get upgrade

## Package

Tarkoituksenani oli asentaa Apache2 ja ottaa käyttöön käyttäjien kotihakemistot.

Ensimmäiseksi loin uuden moduulin

	$ mkdir apache
	$ cd apache/
	$ mkdir manifests
	$ mkdir templates
	$ cd manifests/
	$ nano init.pp

	class apache {
		package {'apache2':
			ensure => "installed",
		}
	}

	$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"apache":}'

	Notice: Compiled catalog for wxdb.elisa in environment production in 0.16 seconds
	Notice: /Stage[main]/Apache/Package[apache2]/ensure: ensure changed 'purged' to 'present'
	Notice: Finished catalog run in 4.86 seconds

## Service

Seuraavaksi lisäsin moduuliin osan, joka varmistaa, että apache2 on käynnissä.

	class apache {
        	package {'apache2':
                	ensure => "installed",
        	}
        	service {'apache2':
                	ensure => "running",
                	enable => "true",
                	require => Package["apache2"],
        	}	
	}

	$ sudo service apache2 stop
	$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"apache":}

	Notice: Compiled catalog for wxdb.elisa in environment production in 0.23 seconds
	Notice: /Stage[main]/Apache/Service[apache2]/ensure: ensure changed 'stopped' to 'running'
	Notice: Finished catalog run in 1.12 seconds

## File

Seuraavaksi tarkoituksena oli ottaa käyttöön käyttäjien kotihakemistot ja sitä varten hyödynsin Lauri Soivin [dokumenttia](https://soivi.net/2013/installing-apache-and-php-with-puppet-module/).

	class apache {
		package {'apache2':
		        ensure => "installed",
		}
		service {'apache2':
		        ensure => "running",
		        enable => "true",
		        require => Package["apache2"],
		}
		file {'/etc/apache2/mods-enabled/userdir.load':
		        ensure => "link",
		        target => "/etc/apache2/mods-available/userdir.load",
		        notify => Service["apache2"],
		        require => Package["apache2"],
		}
		file {'/etc/apache2/mods-enabled/userdir.conf':
		        ensure => "link",
		        target => "/etc/apache2/mods-available/userdir.conf",
		        notify => Service["apache2"],
		        require => Package["apache2"],
		}
	}

	$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"apache":}'

	Notice: Compiled catalog for wxdb.elisa in environment production in 0.28 seconds
	Notice: /Stage[main]/Apache/File[/etc/apache2/mods-enabled/userdir.conf]/ensure: created
	Notice: /Stage[main]/Apache/File[/etc/apache2/mods-enabled/userdir.load]/ensure: created
	Notice: /Stage[main]/Apache/Service[apache2]: Triggered 'refresh' from 2 events
	Notice: Finished catalog run in 2.20 seconds

Seuraavaksi lisäsin moduuliin osan, joka luo käyttäjän kotihakemistoon public_html-kansion ja sinne sisälle index.html -tiedoston, joka ottaa käyttöön templaten.

	$nano /home/niko/git/apache/templates/index_config

	<!DOCTYPE html>
	<html>
		<head>
		        <title> Hello world! </title>
		</head>
		<body>
		        <p>Hello World!</p>
		</body>
	</html>

	$ nano init.pp

	class apache {
		package {'apache2':
		        ensure => "installed",
		}
		service {'apache2':
		        ensure => "running",
		        enable => "true",
		        require => Package["apache2"],
		}
		file {'/etc/apache2/mods-enabled/userdir.load':
		        ensure => "link",
		        target => "/etc/apache2/mods-available/userdir.load",
		        notify => Service["apache2"],
		        require => Package["apache2"],
		}
		file {'/etc/apache2/mods-enabled/userdir.conf':
		        ensure => "link",
		        target => "/etc/apache2/mods-available/userdir.conf",
		        notify => Service["apache2"],
		        require => Package["apache2"],
		}
		file {'/home/niko/public_html':
		        ensure => "directory",
		        owner => "niko",
		        group => "niko",
		}
		file {'/home/niko/public_html/index.html':
		        content => template("apache/index_config"),
		        owner => "niko",
		        group => "niko",
		}
	}

	$ sudo puppet apply --modulepath /home/niko/git/puppet/ -e 'class{"apache":}'

	Notice: Compiled catalog for wxdb.elisa in environment production in 0.30 seconds
	Notice: /Stage[main]/Apache/File[/home/niko/public_html]/ensure: created
	Notice: /Stage[main]/Apache/File[/home/niko/public_html/index.html]/ensure: defined content as '{md5}dad13a7502a275e0db9c1c9c70de3ebb'
	Notice: Finished catalog run in 0.04 seconds

![Image](https://github.com/nikaar/puppet/blob/master/apache/puppet2.png "Hello World!")

## Lähteet

	http://terokarvinen.com/2013/ssh-server-puppet-module-for-ubuntu-12-04
	https://soivi.net/2013/installing-apache-and-php-with-puppet-module/
