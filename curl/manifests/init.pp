class curl {
	exec {"apt-get update":
		path => ["/usr/bin"],
	}
}
