Misc documentation
------------------

.. Add a prefix to all packages
.. ============================
.. 
.. If you want to prefix all your packages, just uncomment and fill **PREFIX**
.. at the beginning of **common/buildenv/Makefile.common**:
.. 
.. .. sourcecode:: make
.. 
..     # general prefix, comment if not needed
..     PREFIX=kakwa-
.. 
..     PKGNAME=$(PREFIX)$(NAME)
.. 
.. 
.. example with **PREFIX=kakwa-** for package dwm-desktop:
.. 
.. .. sourcecode:: none
.. 
..     dwm-desktop_5.9.0-1_amd64.deb  -> kakwa-dwm-desktop_5.9.0-1_amd64.deb


GPG cheat sheet
===============

Package are signed by a gpg key.

Here are some useful commands to manage this key:

Generate the GPG key:

.. sourcecode:: bash

    $ gpg --gen-key


List the keys:

.. sourcecode:: bash

    $ gpg -K


Export the private key (multiple hosts):

.. sourcecode:: bash

    $ gpg --export-secret-key -a "kakwa" > priv.gpg


Import the private key:

.. sourcecode:: bash

    $ gpg --import priv.gpg


import the key in debian:

.. sourcecode:: bash

    $ cat pub.gpg | apt-key add -

