class brackets {

	exec {'add-apt-repository -y ppa:webupd8team/brackets':
		path => ["/usr/bin"],
	}

	exec {'apt-get update':
		path => ["/usr/bin"],
		require => Exec["apt-get update"],
	}
	
	package{'brackets':
		ensure => "installed",
		allowcdrom => "true",
	}
}
