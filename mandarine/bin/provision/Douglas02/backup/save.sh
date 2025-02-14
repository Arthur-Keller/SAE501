ssh srvnfs "sudo dump -0u -f - /" | bzip2 > /mnt/data/srvnfs.1.bz2
ssh ldap "sudo dump -0u -f - /" | bzip2 > /mnt/data/ldap.1.bz2