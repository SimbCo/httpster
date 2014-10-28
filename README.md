httpster
========

Simple http server for quick loading of content.

Installation is done via npm, which is installed along with NodeJS on most platforms.

    npm -g install httpster

Then from any directory where you want to have an http service running, just run

    httpster

That will start up a web server on port 3333 and let you serve up any static content you wish. If you want to change the port or directory that the server runs from pass in the -p or -d options

    httpster -p 8080 -d /home/somedir/public_html

### HTML5 Pushstates

If you want to run a local site that supports HTML5 Pushstates (aka being able to refresh the page), pass in the option `-s` or `--pushstate`. This will map all 4oh4's to the `index.html` you specified as root directory.

### Basic Authentication

Since you can use httpster to deploy to PaaS providers like heroku you can now secure those deployments with basic authentication.  The `-b` or `--basic_auth` options will read the HTTPSTER_AUTH_USER and HTTPSTER_AUTH_PASS variables from your environment for authentication.

    httpster -b
or
    httpster --basic_auth

If testing this locally you can also use a .env file in the directory you will run httpster from.

    HTTPSTER_AUTH_USER=desired_username
    HTTPSTER_AUTH_PASS=desired_password

Then use the `-e` or `--env` option to specify to load the environmental variables

    httpster --env --basic_auth

### Contributions

If you have some issue please feel free to add a ticket here. If you have any suggestions for features that would make this more useful please feel free to let me know.

Thanks to @GarthDB for asking for this and making me realize that I needed it too.
