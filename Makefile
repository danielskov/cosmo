documentroot=/var/www/html

#http:
	#python -m http.server & open "http://localhost:8000"

open:
	open "http://localhost/~ad/cosmo"

deploy:
	rsync -rav index.php uploadhistory.php pages matlab js img font css archive
