documentroot=/var/www/html

#http:
	#python -m http.server & open "http://localhost:8000"

open:
	open "http://localhost/~ad/cosmo"

folders:
	mkdir input && chmod 777 input && mkdir archive

deploy:
	sudo rsync -rav index.php uploadhistory.php pages js img font css $(documentroot)/

sync-matlab:
	cosmo-sshfs && rsync -rav matlab/m_pakke2014maj11 ~/cosmo-server/cosmo/matlab/
