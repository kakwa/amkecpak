%define pkgname @NAME@
%define _unitdir /usr/lib/systemd/system/

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
Source1: gitea 
Source2: gitea.conf
Source3: gitea.service
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

# Build flags (excluded: tidb bindata)
TAGS="sqlite pam"

LDFLAGS="-X \"main.Tags=${TAGS}\" -extldflags=-Wl,-z,relro,-z,now"

export LDFLAGS TAGS

mkdir ./tmpgobuild
unset GOROOT && \
export TMPDIR=`pwd`/tmpgobuild && \
export GOPATH=`pwd`/externals/ && \
go build  -p 4 \
  -buildmode=pie \
  -ldflags="$(LDFLAGS)" \
  -tags="$(TAGS)" \
  -o gitea

mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -m 755 gitea $RPM_BUILD_ROOT/usr/bin/
mkdir -p  $RPM_BUILD_ROOT/etc/gitea/
mkdir -p  $RPM_BUILD_ROOT/var/lib/gitea/
mkdir -p  $RPM_BUILD_ROOT/var/lib/gitea/data
mkdir -p  $RPM_BUILD_ROOT/var/log/gitea/
mkdir -p  $RPM_BUILD_ROOT/usr/share/gitea/
cp -r templates $RPM_BUILD_ROOT/usr/share/gitea/
cp -r public $RPM_BUILD_ROOT/usr/share/gitea/
cp -r options $RPM_BUILD_ROOT/usr/share/gitea/
cp gitea.ini $RPM_BUILD_ROOT/etc/gitea/

mkdir -p %{buildroot}%{_unitdir}
mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
mkdir -p %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}
install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/

%post
true

%pre

getent group gitea >/dev/null || groupadd -r gitea
getent passwd gitea >/dev/null || \
    useradd -r -g gitea -d /var/lib/gitea -s /sbin/nologin \
    -c "Gitea daemon user" gitea

systemd-tmpfiles --create /usr/lib/tmpfiles.d/gitea.conf

systemctl daemon-reload


%preun
systemctl stop gitea
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%attr(755,-,-)/usr/bin/gitea
%attr(755,gitea,gitea)/var/lib/gitea/
%attr(750,gitea,gitea)/var/log/gitea/
/usr/share/gitea/
%attr(755,gitea,gitea)/etc/gitea/
%attr(640,gitea,gitea)/etc/gitea/gitea.ini
%config(noreplace)/etc/gitea/gitea.ini
/usr/lib/tmpfiles.d/*
/etc/sysconfig/*
%{_unitdir}/*

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
