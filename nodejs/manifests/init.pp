class nodejs {
	
	exec {'curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -':
		path => "/usr/bin",
	}

	exec {'apt-get update':
		path => "/usr/bin",
		require => Exec["curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -"],
	}

	exec {'sudo apt-get install -y nodejs':
		path => "/usr/bin",
		require => Exec["apt-get update"],
	}
}
