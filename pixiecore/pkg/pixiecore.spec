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
cp pixiecore-* $RPM_BUILD_ROOT/usr/bin/pixiecore
chmod 755 $RPM_BUILD_ROOT/usr/bin/pixiecore
#mkdir -p  $RPM_BUILD_ROOT/etc/pixiecore/
#mkdir -p  $RPM_BUILD_ROOT/var/lib/pixiecore/
#mkdir -p  $RPM_BUILD_ROOT/var/log/pixiecore/
#mkdir -p  $RPM_BUILD_ROOT/usr/share/pixiecore/
#cp -r templates $RPM_BUILD_ROOT/usr/share/pixiecore/
#cp -r public $RPM_BUILD_ROOT/usr/share/pixiecore/
#cp pixiecore.ini $RPM_BUILD_ROOT/etc/pixiecore/

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 rhel/pixiecore.service %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 rhel/pixiecore %{buildroot}/etc/sysconfig/
install -pm644 rhel/pixiecore.conf %{buildroot}/usr/lib/tmpfiles.d/


%post
true

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
#%attr(755,pixiecore,pixiecore)/var/lib/pixiecore/
#%attr(755,pixiecore,pixiecore)/var/log/pixiecore/
#/usr/share/pixiecore/
#/etc/pixiecore/
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
