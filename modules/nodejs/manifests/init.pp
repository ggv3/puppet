class nodejs {
	
	exec {'curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -':
		path => "/usr/bin",
	}

	exec {'apt-get update':
		path => "/usr/bin",
		require => Exec["curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -"],
	}

	package {'nodejs':
		ensure => "installed",
		require => Exec["apt-get update"],
		allowcdrom => "true",
	}
}
