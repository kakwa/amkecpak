%define pkgname @NAME@

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
URL: @URL@ 
Vendor: @MAINTAINER@
License: See project
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build

#BuildRequires: sed
#Requires: python

%description
@DESCRIPTION@

%package devel
Summary: @SUMMARY@, headers
%description devel
@DESCRIPTION@, headers

%package conv
Summary: @SUMMARY@, command line converter 
%description conv
@DESCRIPTION@, command line converter

%prep
%setup -q -n %{pkgname}-%{version}

%install
rm -rf $RPM_BUILD_ROOT
cmake . -DCMAKE_INSTALL_PREFIX=%{_prefix}
make install DESTDIR=$RPM_BUILD_ROOT

%post
true

%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
/usr/lib/*

%files devel
/usr/include/*.h

%files conv
%attr(755, root, root)/usr/bin/*

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version
