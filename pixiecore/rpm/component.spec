%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source0: %{pkgname}-%{version}.tar.gz
Source1: pixiecore
Source2: pixiecore.conf
Source3: pixiecore.service
URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
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
go build -o pixiecore


mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -m 755 pixiecore $RPM_BUILD_ROOT/usr/bin/
mkdir -p  $RPM_BUILD_ROOT/var/lib/pixiecore/



mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}

%post
setcap 'cap_net_bind_service=+ep' /usr/bin/pixiecore

%pre

getent group pixiecore >/dev/null || groupadd -r pixiecore
getent passwd pixiecore >/dev/null || \
    useradd -r -g pixiecore -d /var/lib/pixiecore -s /sbin/nologin \
    -c "pixiecore daemon user" pixiecore

systemd-tmpfiles --create /usr/lib/tmpfiles.d/pixiecore.conf

systemctl daemon-reload


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755,-,-)/usr/bin/pixiecore
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
