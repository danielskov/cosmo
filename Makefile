documentroot=/var/www/html

#http:
	#python -m http.server & open "http://localhost:8000"

open:
	open "https://cosmo.au.dk" #&& open "http://localhost/~ad/cosmo"

folders:
	mkdir -p input && chmod 777 input && mkdir -p archive && mkdir -p wait

deploy:
	rsync -rav index.php recaptchalib.php \
		uploadhistory.php head.html navigation.html \
		foot.html pages js img font css $(documentroot)/

sync-matlab:
	cosmo-sshfs && \
		rsync -rav matlab/m_pakke2014maj11 ~/cosmo-server/cosmo/matlab/
