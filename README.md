This is an web site project based on [Awestruct](http://awestruct.org/).  It generates the complete web site and documentation of the [Netty project](http://netty.io/).  To contribute to the project documentation, simply fork this repository and issue a pull request.

### How to install Awestruct

Your system must have a working Ruby installation because Awestruct is written in Ruby.  You can install Awestruct using the `gem` command:

    $ gem install awestruct -- --with-cflags=-w

### How to generate and test the web site

First, fork the [official repository](https://github.com/netty/netty-website) and clone it into your local storage:

    $ git clone git@github.com:<username>/netty-website.git
    
Modify the web site as you wish, and start an embedded web server using Awestruct.  The web site will be available at `http://localhost:4242/`

    $ cd netty-website
    $ awestruct --auto --server

You might want to install `rb-fsevent` so that Awestruct notices the file system changes immediately to update the output.  You will see the following message:

    FSSM -> An optimized backend is available for this platform!
    FSSM ->     gem install rb-fsevent

