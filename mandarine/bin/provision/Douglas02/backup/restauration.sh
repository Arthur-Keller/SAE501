#!/bin/bash

bzip2 -dc /mnt/data/srvnfs.1.bz2 | ssh srvnfs "cd /; restore -xof -"
bzip2 -dc /mnt/data/ldap.1.bz2 | ssh srvnfs "cd /; restore -xof -"