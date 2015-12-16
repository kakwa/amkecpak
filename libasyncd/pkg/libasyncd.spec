%define pkgname @NAME@

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
Requires: qlibc


%description
@DESCRIPTION@


%package devel
Summary: @SUMMARY@, header files
Group: System/Servers
Requires: @NAME@

%description devel
@DESCRIPTION@, header files

%prep

%setup -q -n %{pkgname}-%{version}
#./configure
#make

%install

#rm -rf $RPM_BUILD_ROOT
./configure --prefix=%{_prefix}
make install \
    DESTDIR=$RPM_BUILD_ROOT \
    PREFIX=%{_prefix} \
    QLIBC=system

%post
true


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)
%{_prefix}/lib/*.so*

%files devel
%{_prefix}/lib/*.a
%{_prefix}/include/*

%changelog
* Wed Feb 01 2013 Kakwa <carpentier.pf@gmail.com> 0.0.1-1
- initial Version initiale
