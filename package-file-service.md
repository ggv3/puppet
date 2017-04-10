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

>class apache {
>	package {'apache2':
>		ensure => "installed",
>	}
>}
