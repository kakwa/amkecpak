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
#BuildArch: noarch
#BuildRequires: sed
Requires: openssl-libs, libcivetweb

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
cmake . -DCMAKE_INSTALL_PREFIX=%{_prefix}
make install DESTDIR=$RPM_BUILD_ROOT
install -D -m 0644 ./uts-server.cnf $RPM_BUILD_ROOT/etc/uts-server/uts-server.cnf
install -D -m 0644 ./uts-server.service %{buildroot}%{_unitdir}/uts-server.service
install -D -m 0644 ./uts-server.default %{buildroot}/etc/sysconfig/uts-server
install -D -m 0644 ./uts-server.tmpfile %{buildroot}/usr/lib/tmpfiles.d/uts-server.conf

%pre

if ! getent passwd uts-server > /dev/null ; then
  adduser --system --group --quiet --home /var/lib/uts-server \
    --no-create-home --disabled-login --force-badname uts-server
fi

%post
true


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
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
