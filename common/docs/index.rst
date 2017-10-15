Contents
========

.. toctree::
   :maxdepth: 4

   tools 
   cheatsheet
   init_package 
   building_package
   building_repo
   misc 

Name
====

amkecpak is just an anagram of makepack (for Make Package).

Motivation
==========

I've implemented this set of Makefiles and script to more easily build .deb and .rpm packages.

I found that packaging .deb or .rpm is a little annoying for various reasons:

* I've limited memory and I could not remember all the options of rpmbuild and dpkg-buildpackage.
  I deeply prefer having simple, easy to remember commands like **make deb** or **make rpm**.
* I also wanted to build several packages in parallel easily.
* I wanted to avoid upstream sources recovery by hand as it's somewhat annoying.
* I wanted to be capable to easily update my packages if a new upstream version is available.
* I didn't want huge build dependencies for this build system, only usual tools like make, tar, posix shell...
* I didn't want to mask the actual complexity of packaging software properly, I wanted to keep most
  of the knobs of regular .deb or .rpm packaging.

To achieve that, I used a set of Makefiles (for the parallel build capacity, 
the error handling, and the delta (re)build capacity). Plus some basic helper scripts to help with
upstream source recovery, package initialization, or determining OS version.

I've also stolen some patterns I really liked from Gentoo.

Most upstream normalize how they ship sources. It's generally a tar.gz file with a fixed
pattern like **<NAME>-<VERSION>.tar.gz**, this pattern is even automatically implemented
by hosting solution like GitHub.

Consequently it's relatively easy to "templatize" a download URL with a **$(VERSION)** variable, 
this variable could also be used for setting the package version.
This is generally how .ebuild files in Gentoo point to their respective upstreams.

Another thing I liked was that they keep a **manifest** file with the **hashes** of upstream sources.
It permits to have a safe guard against modification of an existing upstream release, gaining some
basic guaranties about build reproductibility and avoiding surprises...

Also the recovery of the upstream sources in Gentoo .ebuild files is a clearly distinct step from
the build and install steps, no call to pip or wget in the middle of a compilation.

I've copied these ideas in this build "infrastructure".

Resources
=========

.. include:: ../../README.rst
