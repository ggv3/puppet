class curl {

	exec {'apt-get update':
		path => ["/usr/bin"],
	}

	package {'curl':
		ensure => "installed",
		require => Exec["apt-get update"],
		allowcdrom => "true",

	}
}
