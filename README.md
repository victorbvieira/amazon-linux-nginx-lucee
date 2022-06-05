amazon-linux-nginx-lucee
==================

A set of bash scripts for standing up a Lucee server using nginx and Tomcat on Amazon Linux. Uses 

What does it do?
----------------

1. **Updates Amazon Linux** - simply runs `yum update -y` and `yum upgrade -y`
2. **Downloads Lucee** - uses curl to download lucee jars from BitBucket places jars in `"https://release.lucee.org/rest/update/provider/loader/$lucee_version`
3. **Installs & Configures Tomcat 9** - download tomcat9 updates the `web.xml` `server.xml` and `catalina.properties` to configure Lucee servlets and mod_cfml Valve.  (Tomcat/Lucee run on port 8080 by default).
4. **JVM/Tomcat9** - Check services.
5. **Installs & Configures nginx** - runs `yum install nginx -y` to install nginx. Creates a web root directory. Creates a `lucee.config` file so you can just `include lucee.config` for any site that uses CFML
6. **Set Default Lucee Admin Password** - uses cfconfig to set the Lucee server context password and default web context password. If environment variable ADMIN_PASSWORD exists that is used, otherwise a random password is set.  

Take a look in the `scripts/` subfolder to see the script for each step.

How do I run it?
----------------

1. **Download this repository** - 
2. **Extract repository** - 
3. **Configuration** - You can either Edit the `install.sh` and change any configuration options such as the Lucee Version or JVM version - or you can use environment variables (see below).
4. **Run install.sh** - make sure you are root or sudo and run `./install.sh` you may need to `chmod u+x install.sh` to give execute permissions to the script.

Setting up a Virtual Host
-------------------------

By default nginx on Amazon Linux looks in the folder `/etc/nginx/conf.d/` for configuration nginx files, for example `/etc/nginx/sites-enabled/me.example.com.conf` at a minimum it will look like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		include lucee.conf;
	}

After making changes you need to restart or reload nginx:

	sudo service nginx restart

special thanks
==============
[Pete Freitag](https://github.com/pfreitag)
Special thanks for creating the [ubuntu-nginx-lucee](https://github.com/foundeo/ubuntu-nginx-lucee) repository which was used as a base to adapt Ubunto commands for Amazon Linux and Nginx update

[Andreas](https://github.com/andreasRu)
Thanks Andreas, for the hours you spent together with me configuring the CommandBox in a Rasperbey, this was the beginning for this script

[Daniel Mejia](https://github.com/webmandman)
That with a lot of patience and persistence we discovered that the Commandbox did not run in java 17, thanks for the help

[PC Silva](https://github.com/pcsilva)
With him I learned a lot about nginx and to understand its folder structure