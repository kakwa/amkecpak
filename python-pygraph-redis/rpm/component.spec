%define pkgname @NAME@
%define modname pygraph_redis

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
BuildArch: noarch

%description
@DESCRIPTION@

%package -n python2-%{modname}
Summary:        @SUMMARY@, python2
Requires: python2-redis
BuildRequires:  python2-devel
BuildRequires:  python2-setuptools

%description -n python2-%{modname}
@DESCRIPTION@
Python 2 version.

%package -n python3-%{modname}
Summary:        @SUMMARY@, python3
Requires: python3-redis
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools

%description -n python3-%{modname}
@DESCRIPTION@
Python 3 version.

%prep
%setup -q -n %{pkgname}-%{version}

%build
%py2_build
%py3_build

%install
%py2_install
%py3_install

%clean
rm -rf \$RPM_BUILD_ROOT

%files -n python2-%{modname}
%{python2_sitelib}/%{modname}/
%{python2_sitelib}/%{modname}-%{version}-*.egg-info/

%files -n python3-%{modname}
%{python3_sitelib}/%{modname}/
%{python3_sitelib}/%{modname}-%{version}-*.egg-info/


%changelog
* Wed Feb 01 2013 @MAINTAINER@ <@MAINTAINER_EMAIL@> 0.0.1-1
- initial Version initiale
