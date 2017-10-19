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

Motivation
==========

I found that packaging .deb or .rpm is a little annoying for various reasons:

* Remembering all the options of rpmbuild/dpkg-buildpackage/mock/cowbuilder is a pain.
* The rpm and deb tools don't follow the same patterns, it's hard to switch between one and the other.
* The upstream source recovery is a painful story.
* Easy updates are kind of difficult, specially with several distributions and distribution version to manage.
* Ordering the packages builds (ex: build this lib(s) before the final binary) is painful.
* There is no "end to end" build command (From "simple check out of some packaging file" to "complete repository generated")

To solve these issues, I've created a set of Makefiles  with easy to remember targets like **make rpm** or **make deb**.
These targets are chained in bigger targets like **make deb_repo** or **make rpm_repo** to build a complete package repository.
Using Makefiles also helps for parallel builds, the error handling, and delta (re)builds.
I've also created a few scripts to help with things like upstream source recovery, package initialization, or determining OS version.

I've also stolen some patterns I really liked from Gentoo and its .ebuild files:

* **Templatize upstream URLs**: Most upstream normalize how they ship sources. It's generally a tar.gz file with a fixed
  pattern like **<NAME>-<VERSION>.tar.gz**, it's quite easy to "templatize" upstream download
  URLs with a **$(VERSION)** variable. Doing so makes updates easier, just change one variable declaration and it's done.
* **MANIFEST files**: Another thing I liked was that they keep a **manifest** file with the **checksum** of upstream sources.
  It permits to have a safe guard against modification of an existing upstream release, gaining some
  basic guaranties about build reproductibility and avoiding surprises...
* **Keeping upstream recovery and build distinct**: Also the recovery of the upstream sources in Gentoo .ebuild files
  is a clearly distinct step from the build and install steps, no call to pip or wget in the middle of a compilation.

However, don't expect this framework to magically package anything for you.
Appart from a few metadata substitutions like version, license, packager's email or description, 
this framework keeps all the knobs of regular .deb or .rpm packaging.

Name
====

amkecpak is just an anagram of makepack (for Make Package).



Resources
=========

.. include:: ../../README.rst
