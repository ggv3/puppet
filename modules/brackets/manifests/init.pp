class brackets {
	
	exec {'sudo add-apt-repository -y ppa:webupd8team/brackets':
		path => ["/usr/bin"],
	}

	exec {'apt-get update':
		path => ["/usr/bin"],
		require => Exec["sudo add-apt-repository -y ppa:webupd8team/brackets"],
	}

	package{'brackets':
		ensure => "installed",
		require => Exec["apt-get update"],
		allowcdrom => "true",
	}
}
