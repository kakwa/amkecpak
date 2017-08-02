%define pkgname @NAME@

Name: %{pkgname}
Version: @VERSION@
Release: @RELEASE@%{?dist}
Source: %{pkgname}-%{version}.tar.gz

# Example of declaration of additional sources like .service file
# just put this files in the rpm/ directory
#Source1: @NAME@
#Source2: @NAME@.conf
#Source3: @NAME@.service

URL: @URL@ 
Vendor: @MAINTAINER@
License: @LICENSE@
Group: System/Servers
Summary: @SUMMARY@ 
BuildRoot: %{_tmppath}/%{pkgname}-%{zone}-%{version}-%{release}-build
BuildArch: noarch
#BuildRequires: sed
#Requires: sed
#Requires: python

%description
@DESCRIPTION@

%prep

%setup -q -n %{pkgname}-%{version}

%install

rm -rf $RPM_BUILD_ROOT
#make install \
#    DESTDIR=$RPM_BUILD_ROOT \
#    PREFIX=%{_prefix}


# example of installation of additional sources, here .service and associated files.
#mkdir -p %{buildroot}%{_unitdir} 
#mkdir -p %{buildroot}/usr/lib/tmpfiles.d/ 
#mkdir -p %{buildroot}/etc/sysconfig/ 
#install -pm644 %{SOURCE3} %{buildroot}%{_unitdir} 
#install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/ 
#install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/


%post
true


%preun
true

%clean
rm -rf \$RPM_BUILD_ROOT

%files
%defattr(644, root, root, 755)

%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
