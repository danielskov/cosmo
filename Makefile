documentroot=/var/www/html

#http:
	#python -m http.server & open "http://localhost:8000"

open:
	open "http://localhost/~ad/cosmo"

deploy:
	sudo rsync -rav index.php uploadhistory.php pages js img font css $(documentroot)/
