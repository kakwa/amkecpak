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
#BuildArch: noarch
#BuildRequires: sed
Requires: dmenu, libXinerama, libXft, libX11

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
make
make install \
    DESTDIR=$RPM_BUILD_ROOT \
    PREFIX=%{_prefix}

%post
true


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%config/etc/dwm-desktop/*
%attr(755,-,-)/usr/bin/*
/usr/share/

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
