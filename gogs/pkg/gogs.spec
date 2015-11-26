%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
URL: @URL@ 
Vendor: Kakwa
License: See project
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
#BuildRequires: sed
#Requires: python

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT

mkdir ./tmpgobuild
unset GOROOT && \
export TMPDIR=`pwd`/tmpgobuild && \
export GOPATH=`pwd`/externals/ && \
go build

mkdir -p $RPM_BUILD_ROOT/usr/bin/
cp gogs-* $RPM_BUILD_ROOT/usr/bin/gogs
chmod 755 $RPM_BUILD_ROOT/usr/bin/gogs
mkdir -p  $RPM_BUILD_ROOT/etc/gogs/
mkdir -p  $RPM_BUILD_ROOT/var/lib/gogs/
mkdir -p  $RPM_BUILD_ROOT/var/log/gogs/
mkdir -p  $RPM_BUILD_ROOT/usr/share/gogs/
cp -r templates $RPM_BUILD_ROOT/usr/share/gogs/
cp -r public $RPM_BUILD_ROOT/usr/share/gogs/
cp gogs.ini $RPM_BUILD_ROOT/etc/gogs/

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 rhel/gogs.service %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 rhel/gogs %{buildroot}/etc/sysconfig/
install -pm644 rhel/gogs.conf %{buildroot}/usr/lib/tmpfiles.d/


%post
true

%pre

getent group gogs >/dev/null || groupadd -r gogs
getent passwd gogs >/dev/null || \
    useradd -r -g gogs -d /var/lib/gogs -s /sbin/nologin \
    -c "Gogs daemon user" gogs

systemd-tmpfiles --create /usr/lib/tmpfiles.d/gogs.conf

systemctl daemon-reload


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755,-,-)/usr/bin/gogs
%attr(644,gogs,gogs)/var/lib/gogs/
%attr(644,gogs,gogs)/var/log/gogs/
/usr/share/gogs/
/etc/gogs/
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
