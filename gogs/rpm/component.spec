%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
Source1: gogs 
Source2: gogs.conf
Source3: gogs.service
URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
BuildRequires: golang
Requires: git

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
go build -o gogs

mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -m 755 gogs $RPM_BUILD_ROOT/usr/bin/
mkdir -p  $RPM_BUILD_ROOT/etc/gogs/
mkdir -p  $RPM_BUILD_ROOT/var/lib/gogs/
mkdir -p  $RPM_BUILD_ROOT/var/log/gogs/
mkdir -p  $RPM_BUILD_ROOT/usr/share/gogs/
cp -r templates $RPM_BUILD_ROOT/usr/share/gogs/
cp -r public $RPM_BUILD_ROOT/usr/share/gogs/
cp -r conf $RPM_BUILD_ROOT/usr/share/gogs/
cp gogs.ini $RPM_BUILD_ROOT/etc/gogs/

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/

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
systemctl stop gogs
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755,-,-)/usr/bin/gogs
%attr(755,gogs,gogs)/var/lib/gogs/
%attr(755,gogs,gogs)/var/log/gogs/
/usr/share/gogs/
%attr(755,gogs,gogs)/etc/gogs/
%attr(640,gogs,gogs)/etc/gogs/gogs.ini
%config(noreplace)/etc/gogs/gogs.ini
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
