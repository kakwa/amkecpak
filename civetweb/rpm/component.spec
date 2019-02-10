%define pkgname @NAME@

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz
URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
Requires: lib@NAME@
#BuildArch: noarch
BuildRequires: cmake, openssl-devel, clang

%description
@DESCRIPTION@

%package -n lib@NAME@-devel
Summary: @SUMMARY@, headers
Requires: lib@NAME@
%description -n lib@NAME@-devel
@DESCRIPTION@, headers

%package -n lib@NAME@
Summary: @SUMMARY@, library 
%description -n lib@NAME@
@DESCRIPTION@, library

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
cd src/
%cmake .. -DCMAKE_INSTALL_PREFIX=%{_prefix} \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DCMAKE_INSTALL_LOCALSTATEDIR=/var \
    -DCIVETWEB_DISABLE_CGI=ON \
    -DCIVETWEB_ENABLE_CXX=ON \
    -DCIVETWEB_ENABLE_IPV6=ON \
    -DCIVETWEB_ENABLE_WEBSOCKETS=ON \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DCIVETWEB_BUILD_TESTING=OFF

make
make install DESTDIR=$RPM_BUILD_ROOT

if ! [ "%{_lib}" = "lib" ]
then
  mkdir -p $RPM_BUILD_ROOT/usr/%{_lib}/
  mv $RPM_BUILD_ROOT/usr/lib/* $RPM_BUILD_ROOT/usr/%{_lib}/
  rmdir $RPM_BUILD_ROOT/usr/lib
fi

%post
true

%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files -n lib@NAME@
%defattr(644, root, root, 755)
/usr/%{_lib}/*

%files -n lib@NAME@-devel
%defattr(644, root, root, 755)
/usr/include/*.h

%files
%attr(755, root, root)/usr/bin/*

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
