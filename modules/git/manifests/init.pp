class git {
        package {'git':
                ensure => 'installed',
        }
	file {'/home/niko/git':
		ensure => 'directory',
		owner => 'niko',
		group => 'niko',
	}
}

