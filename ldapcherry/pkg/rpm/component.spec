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
BuildArch: noarch
Requires: python-cherrypy, python-ldap, PyYAML, python-mako

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
python setup.py install --force --root=$RPM_BUILD_ROOT --no-compile -O0 --prefix=/usr
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 rhel/ldapcherryd.service %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 rhel/ldapcherryd %{buildroot}/etc/sysconfig/
install -pm644 rhel/ldapcherryd.conf %{buildroot}/usr/lib/tmpfiles.d/

%post
getent group ldapcherry >/dev/null || groupadd -r ldapcherry
getent passwd ldapcherry >/dev/null || \
    useradd -r -g ldapcherry -d /var/lib/ldapcherry -s /sbin/nologin \
    -c "LdapCherry daemon user" ldapcherry

systemd-tmpfiles --create /usr/lib/tmpfiles.d/ldapcherryd.conf

systemctl daemon-reload

%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755, root, root) /usr/bin/ldapcherryd
/usr/share/ldapcherry/
/usr/lib/python2.7/site-packages/ldapcherry*
/usr/lib/systemd/system/ldapcherryd.service
/usr/lib/tmpfiles.d/*
%config /etc/ldapcherry/*
%config /etc/sysconfig/ldapcherryd

%changelog
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
