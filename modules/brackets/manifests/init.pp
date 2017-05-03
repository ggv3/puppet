class brackets {

	exec {'add-apt-repository -y ppa:webupd8team/brackets':
		path => ["/usr/bin"],
	}

	exec {'apt-key update':
                path => ["/usr/bin"],
		require => Exec["add-apt-repository -y ppa:webupd8team/brackets"],
        }


	exec {'apt-get update':
		path => ["/usr/bin"],
		require => Exec["apt-get update"],
	}
	
	exec {'apt-get install -y brackets':
		path => ["/usr/bin"],
		require => Exec["apt-get update"],
	}
}
