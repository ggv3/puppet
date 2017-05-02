class apache {

	package {'apache2':
		ensure => "installed",
		allowcdrom => "true",
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
		content => template("apache/html.template"),
		owner => "niko",
		group => "niko",
	}

	file {'/etc/apache2/sites-available/niko.conf':
                content => template("apache/niko.conf.template"),
                require => Package["apache2"],
		owner => "root",
                group => "root",
        }
	
	file {'/etc/apache2/sites-enabled/niko.conf':
		ensure => "link",
		target => "/etc/apache2/sites-available/niko.conf",
		notify => Service["apache2"],
                require => Package["apache2"],
	}
	
	file {'/etc/apache2/sites-enabled/000-default.conf':
		ensure => "absent",
		notify => Service["apache2"],
		require => Package["apache2"],
	}

	file {'/etc/hosts':
		content => template("apache/hosts.template"),
		owner => "root",
		group => "root",
		notify => Service["apache2"],

	}
}

	
