%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
Source1: dnscherry
Source2: dnscherry.conf
Source3: dnscherry.service

URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
BuildArch: noarch
Requires: python-cherrypy, python-ldap, python-mako, python-dns
BuildRequires: python-setuptools,

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
python setup.py install --force --root=$RPM_BUILD_ROOT --no-compile -O0 --prefix=/usr

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/


%post
getent group dnscherry >/dev/null || groupadd -r dnscherry
getent passwd dnscherry >/dev/null || \
    useradd -r -g dnscherry -d /var/lib/dnscherry -s /sbin/nologin \
    -c "DnsCherry daemon user" dnscherry

systemd-tmpfiles --create /usr/lib/tmpfiles.d/dnscherry.conf

systemctl daemon-reload

%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755, root, root) /usr/bin/dnscherryd
/usr/share/dnscherry/
/usr/lib/python2.7/site-packages/dnscherry*
/usr/lib/systemd/system/dnscherry.service
/usr/lib/tmpfiles.d/*
%config /etc/dnscherry/*
%config /etc/sysconfig/dnscherry

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
