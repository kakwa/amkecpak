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
mkdir ./tmpbin/
export PATH="`pwd`/tmpbin:$PATH" && \
unset GOROOT && \
export TMPDIR=`pwd`/tmpgobuild && \
export GOPATH=`pwd`/externals/ && \
cd ./externals/src/github.com/jteeuwen/go-bindata/go-bindata/ && \
go build && \
cd - && \
cp ./externals/src/github.com/jteeuwen/go-bindata/go-bindata/go-bindata ./tmpbin/ && \
cd ./externals/src/github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs/ && \
go build && \
cd - && \
cp ./externals/src/github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs/go-bindata-assetfs ./tmpbin/ && \
cd ./externals/src/github.com/eknkc/amber/amberc && \
go build && \
cd - && \
cp ./externals/src/github.com/eknkc/amber/amberc/amberc ./tmpbin/ && \
make gen && \
go build -o drone

mkdir -p  $RPM_BUILD_ROOT/usr/bin/
install -m 755 drone $RPM_BUILD_ROOT/usr/bin/
mkdir -p  $RPM_BUILD_ROOT/etc/drone/
mkdir -p  $RPM_BUILD_ROOT/var/lib/drone/
#mkdir -p  $RPM_BUILD_ROOT/var/log/drone/
#mkdir -p  $RPM_BUILD_ROOT/usr/share/drone/
#cp -r templates $RPM_BUILD_ROOT/usr/share/drone/
#cp -r public $RPM_BUILD_ROOT/usr/share/drone/
cp drone.env $RPM_BUILD_ROOT/etc/drone/
mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
install -pm644 rhel/drone.service %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 rhel/drone %{buildroot}/etc/sysconfig/
install -pm644 rhel/drone.conf %{buildroot}/usr/lib/tmpfiles.d/



%post
true

%pre

getent group drone >/dev/null || groupadd -r drone
getent passwd drone >/dev/null || \
    useradd -r -g drone -d /var/lib/drone -s /sbin/nologin \
    -c "Gogs daemon user" drone

systemd-tmpfiles --create /usr/lib/tmpfiles.d/drone.conf

systemctl daemon-reload


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755,-,-)/usr/bin/drone
%attr(755,drone,drone)/var/lib/drone/
/etc/drone/
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
