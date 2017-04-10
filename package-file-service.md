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
