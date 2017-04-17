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
