%define pkgname @NAME@

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz

# Example of declaration of additional sources like .service file
# just put this files in the rpm/ directory
Source1: @NAME@
Source3: @NAME@.service

URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
BuildRequires: golang, libacl-devel, lxc-devel, acl, dnsmasq, lxc, squashfs-tools, device-mapper-persistent-data, tar, xz, iproute, rsync

%description
@DESCRIPTION@

%package server
Summary: @SUMMARY@, headers
Requires: acl, dnsmasq, lxc, squashfs-tools, device-mapper-persistent-data, tar, xz, iproute, rsync, @NAME@-client
%description server
@DESCRIPTION@, server



%prep

%setup -q -n %{pkgname}-%{version}

%package client
Summary: @SUMMARY@, headers
%description client
@DESCRIPTION@, client

%install

rm -rf $RPM_BUILD_ROOT

EGO_PN=github.com/lxc/lxd
mkdir -p ./tmpgobuild
unset GOROOT
unset GOPATH
export TMPDIR=`pwd`/tmpgobuild
export GOPATH=`pwd`/dist/
go install -v -x $EGO_PN/lxc
go install -v -x $EGO_PN/lxd
go install -v -x $EGO_PN/fuidshift

mkdir -p  %{buildroot}/usr/bin/
install -m 755 dist/bin/lxd %{buildroot}/usr/bin/
install -m 755 dist/bin/lxc %{buildroot}/usr/bin/
install -m 755 dist/bin/fuidshift %{buildroot}/usr/bin/

# example of installation of additional sources, here .service and associated files.
mkdir -p %{buildroot}%{_unitdir} 
#mkdir -p %{buildroot}/usr/lib/tmpfiles.d/ 
mkdir -p %{buildroot}/etc/sysconfig/ 
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir} 
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/ 


%post server

getent group lxd >/dev/null || groupadd -r lxd
getent passwd lxd >/dev/null || \
    useradd -r -g lxd -d /var/lib/lxd -s /sbin/nologin \
    -c "LXD daemon user" lxd


systemctl daemon-reload


%clean
rm -rf \$RPM_BUILD_ROOT

%files server
%defattr(644, root, root, 755)
%attr(755, -, -)/usr/bin/lxd
%attr(755, -, -)/usr/bin/fuidshift
/etc/sysconfig/*
%{_unitdir}/*

%files client
%defattr(644, root, root, 755)
%attr(755, -, -)/usr/bin/lxc



%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
