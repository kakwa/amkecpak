%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
Source1: uts-server
Source2: uts-server.conf
Source3: uts-server.service
Source4: uts-server.cnf
URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
#BuildArch: noarch
BuildRequires: cmake, openssl-devel, libcivetweb-devel
Requires: openssl-libs, libcivetweb

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
cmake . -DCMAKE_INSTALL_PREFIX=%{_prefix}
make install DESTDIR=$RPM_BUILD_ROOT
install -D -m 0640 %{SOURCE4} $RPM_BUILD_ROOT/etc/uts-server/uts-server.cnf

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}

%pre

if ! getent passwd uts-server > /dev/null ; then
  adduser --system --home /var/lib/uts-server \
    --no-create-home --shell /sbin/nologin uts-server
fi

%post
systemctl daemon-reload
systemd-tmpfiles --create /usr/lib/tmpfiles.d/uts-server.conf

%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755, root, root)/usr/bin/uts-server
/usr/lib/tmpfiles.d/*
%{_unitdir}/uts-server.service
%config /etc/uts-server/*
%config /etc/sysconfig/uts-server


%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
