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

	
