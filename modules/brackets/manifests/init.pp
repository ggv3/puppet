class brackets {
	
	exec {'sudo add-apt-repository --allow-unauthenticated ppa:webupd8team/brackets':
		path => ["/usr/bin"],
		returns => [0, 2],
	}

	exec {'apt-get update':
		path => ["/usr/bin"],
		require => Exec["sudo add-apt-repository --allow-unauthenticated ppa:webupd8team/brackets"],
	}

	package{'brackets':
		ensure => "installed",
		require => Exec["apt-get update"],
		allowcdrom => "true",
	}
}
