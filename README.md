httpster
========

Simple http server for quick loading of content.

Installation is done via npm, which is installed along with NodeJS on most platforms.

    npm -g install httpster

Then from any directory where you want to have an http service running, just run

    httpster

That will start up a web server on port 3333 and let you serve up any static content you wish. If you want to change the port or directory that the server runs from pass in the -p or -d options

    httpster -p 8080 -d /home/somedir/public_html

If you have some issue please feel free to add a ticket here. If you have any suggestions for features that would make this more useful please feel free to let me know.

Thanks to @GarthDB for asking for this and making me realize that I needed it too.
