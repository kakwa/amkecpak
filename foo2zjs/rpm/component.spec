%define foo2zjs_ver @VERSION@
%global _smp_ncpus_max 1

Name:           foo2zjs
Version:        0.%{foo2zjs_ver}
Release:        @RELEASE@%{?dist} 

Summary:        Linux printer driver for ZjStream protocol

Group:          System Environment/Libraries
License:        @LICENSE@
Vendor:         @MAINTAINER@

URL:            http://foo2zjs.rkkda.com/
Source0:        %{name}-%{foo2zjs_ver}.tar.gz

Patch0:         %{name}-dynamic-jbig.patch
Patch1:         %{name}-device-ids.patch
Patch2:         %{name}-fsf-address.patch
Patch3:         %{name}-man-pages.patch

Requires:       lcms argyllcms
Requires(post): /usr/bin/rm
BuildRequires:  jbigkit-devel groff ghostscript bc python-cups cups


%package -n foo2hp
Summary:        Linux printer driver for HP 1600, HP 2600n
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2xqx
Summary:        Linux printer driver for HP LaserJet M1005 MFP
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2lava
Summary:        Linux printer driver for Zenographics LAVAFLOW protocol
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2qpdl
Summary:        Linux printer driver for Samsung CLP-300, CLP-600, CLP-3160
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2slx
Summary:        Linux printer driver for SLX protocol (Lexmark C500n etc.)
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2hiperc
Summary:        Linux printer driver for HIPERC protocol (Oki C3400n etc.)
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2oak
Summary:        Linux printer driver for OAKT protocol (HPLJ1500 etc.)
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2hbpl
Summary:        Linux printer driver for HBPL protocol
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm

%package -n foo2ddst
Summary:        Linux printer driver for DDST protocol
Group:          System Environment/Libraries
Requires:       lcms foo2zjs
Requires(post): /usr/bin/rm


%description
foo2zjs is an open source printer driver for printers that use the Zenographics
ZjStream wire protocol for their print data, such as the Minolta/QMS magicolor
2300 DL or Konica Minolta magicolor 2430 DL or HP LaserJet 1020 or HP LaserJet
Pro P1102 or HP LaserJet Pro P1102w or HP LaserJet Pro CP1025nw. These printers
are often erroneously referred to as winprinters or GDI printers. However,
Microsoft GDI only mandates the API between an application and the printer
driver, not the protocol on the wire between the printer driver and the
printer. In fact, ZjStream printers are raster printers which happen to use a
very efficient wire protocol which was developed by Zenographics and licensed
by most major printer manufacturers for at least some of their product lines.
ZjStream is just one of many wire protocols that are in use today, such as
Postscript, PCL, Epson, etc.

Users of this package are requested to visit the author's web page at
http://foo2zjs.rkkda.com/ and consider contributing.

%description -n foo2hp
foo2hp is an open source printer driver for printers that use the Zenographics
ZjStream wire protocol for their print data, such as the HP Color LaserJet
2600n and the HP Color LaserJet CP1215. These printers are often erroneously
referred to as winprinters or GDI printers. However, Microsoft GDI only
mandates the API between an application and the printer driver, not the
protocol on the wire between the printer driver and the printer. In fact,
ZjStream printers are raster printers which happen to use a very efficient wire
protocol which was developed by Zenographics and licensed by most major printer
manufacturers for at least some of their product lines. ZjStream is just one of
many wire protocols that are in use today, such as Postscript, PCL, Epson, etc.

Users of this package are requested to visit the author's web page at
http://foo2hp.rkkda.com/ and consider contributing.

%description -n foo2xqx 
foo2xqx is an open source printer driver for printers that use the HP/Software
Imaging "XQX" stream wire protocol for their print data, such as the HP
LaserJet P1005, HP LaserJet P1006, HP LaserJet P1505, and the HP LaserJet M1005
MFP, These printers are often erroneously referred to as winprinters or GDI
printers. However, Microsoft GDI only mandates the API between an application
and the printer driver, not the protocol on the wire between the printer driver
and the printer. In fact, "XQX" printers are raster printers which happen to
use a very efficient wire protocol which was developed by HP/Software Imaging.
"XQX" is just one of many wire protocols that are in use today, such as
Postscript, PCL, Epson, ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2xqx.rkkda.com/ and consider contributing.

%description -n foo2lava
foo2lava is an open source printer driver for printers that use the
Zenographics LAVAFLOW wire protocol for their print data, such as the Konica
Minolta magicolor 1600W or the Konica Minolta magicolor 2530 DL or the Konica
Minolta magicolor 1690MF or the Konica Minolta magicolor 2490 MFor the Konica
Minolta magicolor 4690 MF. These printers are often erroneously referred to as
winprinters or GDI printers. However, Microsoft GDI only mandates the API
between an application and the printer driver, not the protocol on the wire
between the printer driver and the printer. In fact, LAVAFLOW printers are
raster printers which happen to use a very efficient wire protocol which was
developed by Zenographics and licensed by most major printer manufacturers for
at least some of their product lines. LAVAFLOW is just one of many wire
protocols that are in use today, such as Postscript, PCL, Epson, ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2lava.rkkda.com/ and consider contributing.

%description -n foo2qpdl
foo2qpdl is an open source printer driver for printers that use the QPDL wire
protocol for their print data, such as the Samsung CLP-300 or the Samsung
CLP-310 or the Samsung CLP-315 or the Samsung CLP-325 or the Samsung CLP-365 or
the Samsung CLP-600 or the Samsung CLP-610ND or the Samsung CLP-620ND or the
Xerox Phaser 6110. These printers are often erroneously referred to as
winprinters or GDI printers. However, Microsoft GDI only mandates the API
between an application and the printer driver, not the protocol on the wire
between the printer driver and the printer. In fact, QPDL printers are raster
printers which happen to use a very efficient wire protocol. QPDL is just one
of many wire protocols that are in use today, such as Postscript, PCL, Epson,
ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2qpdl.rkkda.com/ and consider contributing.

%description -n foo2slx
foo2slx is an open source printer driver for printers that use the Software
Imaging K.K. SLX wire protocol for their print data, such as the Lexmark C500n.
These printers are often erroneously referred to as winprinters or GDI
printers. However, Microsoft GDI only mandates the API between an application
and the printer driver, not the protocol on the wire between the printer driver
and the printer. In fact, SLX printers are raster printers which happen to use
a very efficient wire protocol which was developed by Zenographics and cloned
by Software Imaging K.K. and licensed by most major printer manufacturers for
at least some of their product lines. SLX is just one of many wire protocols
that are in use today, such as Postscript, PCL, Epson, ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2slx.rkkda.com/ and consider contributing.

%description -n foo2hiperc
foo2hiperc is an open source printer driver for printers that use the HIPERC
wire protocol for their print data, such as the Oki C3400n and the Oki C5500n.

NOTE: This driver is currently in Alpha and supports uncompressed mode
only.

Users of this package are requested to visit the author's web page at
http://foo2hiperc.rkkda.com/ and consider contributing.

%description -n foo2oak
foo2oak is a printer driver for printers that use the Oak Technology (now
Zoran) OAKT protocol for their print data, such as the HP Color LaserJet 1500,
Kyocera KM-1635 and the Kyocera KM-2035. These printers are often erroneously
referred to as winprinters or GDI printers. However, Microsoft GDI only
mandates the API between an application and the printer driver, not the
protocol on the wire between the printer driver and the printer. In fact, OAKT
printers are raster printers which happen to use a fairly efficient wire
protocol which was developed by Oak Technology and licensed by some printer
manufacturers for at least some of their product lines. OAKT is just one of
many wire protocols that are in use today, such as Postscript, PCL, Epson,
ZjStream, etc. 

Users of this package are requested to visit the author's web page at
http://foo2oak.rkkda.com/ and consider contributing.

%description -n foo2hbpl
foo2hbpl is an open source printer driver for printers that use the HBPL
version 2 wire protocol for their print data, such as the Dell 1355, Fuji Xerox
DocuPrint CM205 or the Xerox WorkCentre 6015. These printers are often
erroneously referred to as winprinters or GDI printers. However, Microsoft GDI
only mandates the API between an application and the printer driver, not the
protocol on the wire between the printer driver and the printer. In fact, HBPL
printers are raster printers which happen to use a very efficient wire
protocol. HBPL is just one of many wire protocols that are in use today, such
as Postscript, PCL, Epson, ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2oak.rkkda.com/ and consider contributing.

%description -n foo2ddst
foo2ddst is an open source printer driver for printers that use the DDST wire
protocol for their print data, such as the Ricoh SP 112, or the Ricoh SP 201Nw.
These printers are often erroneously referred to as winprinters or GDI printers.
However, Microsoft GDI only mandates the API between an application and the
printer driver, not the protocol on the wire between the printer driver and the
printer. In fact, DDST printers are raster printers which happen to use a very
efficient wire protocol. DDST is just one of many wire protocols that are in
use today, such as Postscript, PCL, Epson, ZjStream, etc.

Users of this package are requested to visit the author's web page at
http://foo2oak.rkkda.com/ and consider contributing.



%prep
%autosetup -n %{name}-%{foo2zjs_ver} -p 1

sed -i -e s/foo2zjs-icc2ps/icc2ps/g *wrapper*
sed -i -e s/775/755/ Makefile

# Samsung CLP-310 already included in foomatic-db package
rm foomatic-db/printer/Samsung-CLP-310.xml
rm PPD/Samsung-CLP-310.ppd

%build
%make_build CFLAGS="%{optflags}"


%install
install -d %{buildroot}%{_bindir}
install -d %{buildroot}%{_datadir}/foomatic/db/source/driver
install -d %{buildroot}%{_datadir}/foomatic/db/source/printer
install -d %{buildroot}%{_datadir}/foomatic/db/source/opt
install -d %{buildroot}%{_datadir}/cups/model

make DESTDIR=%{buildroot} BINPROGS= \
    install-prog install-extra install-crd install-man install-foo install-ppd

# Remove man page for usb_printerid which we don't ship
rm -f %{buildroot}%{_mandir}/man1/usb_printerid.1


%files
%license COPYING
%doc README ChangeLog
%{_bindir}/*zjs*
%{_bindir}/printer-profile
%{_datadir}/foo2zjs
%{_mandir}/man1/*zjs*
%{_mandir}/man1/printer-profile.1.gz
%{_datadir}/foomatic/db/source/driver/foo2zjs.xml
%{_datadir}/foomatic/db/source/driver/foo2zjs-z1.xml
%{_datadir}/foomatic/db/source/driver/foo2zjs-z2.xml
%{_datadir}/foomatic/db/source/driver/foo2zjs-z3.xml
%{_datadir}/foomatic/db/source/opt/foo2zjs*.xml
%{_datadir}/foomatic/db/source/opt/foo2xxx*.xml
%{_datadir}/foomatic/db/source/printer/Generic-ZjStream_Printer.xml
%{_datadir}/foomatic/db/source/printer/HP-LaserJet_1*.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_2430_DL.xml
%{_datadir}/foomatic/db/source/printer/Minolta-Color_PageWorks_Pro_L.xml
%{_datadir}/foomatic/db/source/printer/Minolta-magicolor_2200_DL.xml
%{_datadir}/foomatic/db/source/printer/Minolta-magicolor_2300_DL.xml
%{_datadir}/foomatic/db/source/printer/Minolta-magicolor_2430_DL.xml
%{_datadir}/foomatic/db/source/printer/Olivetti-d-Color_P160W.xml
%{_datadir}/cups/model/Generic-ZjStream_Printer.ppd.gz
%{_datadir}/cups/model/HP-LaserJet_1*.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_2430_DL.ppd.gz
%{_datadir}/cups/model/Minolta-Color_PageWorks_Pro_L.ppd.gz
%{_datadir}/cups/model/Minolta-magicolor_2200_DL.ppd.gz
%{_datadir}/cups/model/Minolta-magicolor_2300_DL.ppd.gz
%{_datadir}/cups/model/Minolta-magicolor_2430_DL.ppd.gz
%{_datadir}/cups/model/Olivetti-d-Color_P160W.ppd.gz

%files -n foo2hp
%license COPYING
%doc README ChangeLog
%{_bindir}/*hp*
%{_mandir}/man1/*hp*
%{_datadir}/foomatic/db/source/driver/foo2hp.xml
%{_datadir}/foomatic/db/source/opt/foo2hp*.xml
%{_datadir}/foomatic/db/source/printer/HP-Color_LaserJet_1600.xml
%{_datadir}/foomatic/db/source/printer/HP-Color_LaserJet_2600n.xml
%{_datadir}/foomatic/db/source/printer/HP-Color_LaserJet_CP1215.xml
%{_datadir}/cups/model/HP-Color_LaserJet_CP1215.ppd.gz
%{_datadir}/cups/model/HP-Color_LaserJet_1600.ppd.gz
%{_datadir}/cups/model/HP-Color_LaserJet_2600n.ppd.gz

%files -n foo2xqx
%license COPYING
%doc README ChangeLog
%{_bindir}/*xqx*
%{_mandir}/man1/*xqx*
%{_datadir}/foomatic/db/source/driver/foo2xqx.xml
%{_datadir}/foomatic/db/source/opt/foo2xqx*.xml
%{_datadir}/foomatic/db/source/printer/HP-LaserJet_M*.xml
%{_datadir}/foomatic/db/source/printer/HP-LaserJet_P*.xml
%{_datadir}/cups/model/HP-LaserJet_M*.ppd.gz
%{_datadir}/cups/model/HP-LaserJet_P*.ppd.gz

%files -n foo2lava
%license COPYING
%doc README ChangeLog
%{_bindir}/*lava*
%{_bindir}/opldecode
%{_mandir}/man1/*lava*
%{_mandir}/man1/opldecode.1.gz
%{_datadir}/foomatic/db/source/driver/foo2lava.xml
%{_datadir}/foomatic/db/source/opt/foo2lava*.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_2480_MF.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_2490_MF.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_2530_DL.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_1600W.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_1680MF.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_1690MF.xml
%{_datadir}/foomatic/db/source/printer/KONICA_MINOLTA-magicolor_4690MF.xml
%{_datadir}/foomatic/db/source/printer/Xerox-Phaser_6121MFP.xml
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_2480_MF.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_2490_MF.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_2530_DL.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_1600W.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_1680MF.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_1690MF.ppd.gz
%{_datadir}/cups/model/KONICA_MINOLTA-magicolor_4690MF.ppd.gz
%{_datadir}/cups/model/Xerox-Phaser_6121MFP.ppd.gz

%files -n foo2qpdl
%license COPYING
%doc README ChangeLog
%{_bindir}/*qpdl*
%{_mandir}/man1/*qpdl*
%{_datadir}/foomatic/db/source/driver/foo2qpdl.xml
%{_datadir}/foomatic/db/source/opt/foo2qpdl*.xml
%{_datadir}/foomatic/db/source/printer/Samsung-CL*.xml
%{_datadir}/foomatic/db/source/printer/Xerox-Phaser_6110.xml
%{_datadir}/foomatic/db/source/printer/Xerox-Phaser_6115MFP.xml
%{_datadir}/cups/model/Samsung-CL*.ppd.gz
%{_datadir}/cups/model/Xerox-Phaser_6110.ppd.gz
%{_datadir}/cups/model/Xerox-Phaser_6115MFP.ppd.gz
%{_datadir}/foo2qpdl/crd/black-text.ps
%{_datadir}/foo2qpdl/crd/CLP-300-1200x1200cms2
%{_datadir}/foo2qpdl/crd/CLP-300-1200x600cms2
%{_datadir}/foo2qpdl/crd/CLP-300-600x600cms2
%{_datadir}/foo2qpdl/crd/CLP-300cms
%{_datadir}/foo2qpdl/crd/CLP-600-1200x1200cms2
%{_datadir}/foo2qpdl/crd/CLP-600-1200x600cms2
%{_datadir}/foo2qpdl/crd/CLP-600-600x600cms2
%{_datadir}/foo2qpdl/crd/CLP-600cms


%files -n foo2slx
%license COPYING
%doc README ChangeLog
%{_bindir}/*slx*
%{_bindir}/gipddecode
%{_mandir}/man1/*slx*
%{_mandir}/man1/gipddecode.1.gz
%{_datadir}/foomatic/db/source/driver/foo2slx.xml
%{_datadir}/foomatic/db/source/opt/foo2slx*.xml
%{_datadir}/foomatic/db/source/printer/Lexmark-C500.xml
%{_datadir}/cups/model/Lexmark-C500.ppd.gz

%files -n foo2hiperc
%license COPYING
%doc README ChangeLog
%{_bindir}/*hiperc*
%{_mandir}/man1/*hiperc*
%{_datadir}/foomatic/db/source/driver/foo2hiperc*.xml
%{_datadir}/foomatic/db/source/opt/foo2hiperc*.xml
%{_datadir}/foomatic/db/source/printer/Oki-C*.xml
%{_datadir}/cups/model/Oki-C*.ppd.gz

%files -n foo2oak
%license COPYING
%doc README ChangeLog
%{_bindir}/*oak*
%{_mandir}/man1/*oak*
%{_datadir}/foomatic/db/source/opt/foo2oak*
%{_datadir}/foomatic/db/source/driver/foo2oak.xml
%{_datadir}/foomatic/db/source/driver/foo2oak-z1.xml
%{_datadir}/foomatic/db/source/printer/Generic-OAKT_Printer.xml
%{_datadir}/foomatic/db/source/printer/HP-Color_LaserJet_1500.xml
%{_datadir}/foomatic/db/source/printer/Kyocera-KM-1635.xml
%{_datadir}/foomatic/db/source/printer/Kyocera-KM-2035.xml
%{_datadir}/cups/model/Generic-OAKT_Printer.ppd.gz
%{_datadir}/cups/model/HP-Color_LaserJet_1500.ppd.gz
%{_datadir}/cups/model/Kyocera-KM-1635.ppd.gz
%{_datadir}/cups/model/Kyocera-KM-2035.ppd.gz

%files -n foo2hbpl
%license COPYING
%doc README ChangeLog
%{_bindir}/*hbpl*
%{_mandir}/man1/*hbpl*
%{_datadir}/foomatic/db/source/opt/foo2hbpl2*
%{_datadir}/foomatic/db/source/driver/foo2hbpl2.xml
%{_datadir}/foomatic/db/source/printer/Dell-1355.xml
%{_datadir}/foomatic/db/source/printer/Dell-C1765.xml
%{_datadir}/foomatic/db/source/printer/Epson-AcuLaser_CX17NF.xml
%{_datadir}/foomatic/db/source/printer/Epson-AcuLaser_M1400.xml
%{_datadir}/foomatic/db/source/printer/Fuji_Xerox-DocuPrint_CM205.xml
%{_datadir}/foomatic/db/source/printer/Fuji_Xerox-DocuPrint_CM215.xml
%{_datadir}/foomatic/db/source/printer/Fuji_Xerox-DocuPrint_M215.xml
%{_datadir}/foomatic/db/source/printer/Fuji_Xerox-DocuPrint_P205.xml
%{_datadir}/foomatic/db/source/printer/Xerox-Phaser_3010.xml
%{_datadir}/foomatic/db/source/printer/Xerox-Phaser_3040.xml
%{_datadir}/foomatic/db/source/printer/Xerox-WorkCentre_3045.xml
%{_datadir}/foomatic/db/source/printer/Xerox-WorkCentre_6015.xml
%{_datadir}/cups/model/Dell-1355.ppd.gz
%{_datadir}/cups/model/Dell-C1765.ppd.gz
%{_datadir}/cups/model/Epson-AcuLaser_CX17NF.ppd.gz
%{_datadir}/cups/model/Epson-AcuLaser_M1400.ppd.gz
%{_datadir}/cups/model/Fuji_Xerox-DocuPrint_CM205.ppd.gz
%{_datadir}/cups/model/Fuji_Xerox-DocuPrint_CM215.ppd.gz
%{_datadir}/cups/model/Fuji_Xerox-DocuPrint_M215.ppd.gz
%{_datadir}/cups/model/Fuji_Xerox-DocuPrint_P205.ppd.gz
%{_datadir}/cups/model/Xerox-Phaser_3010.ppd.gz
%{_datadir}/cups/model/Xerox-Phaser_3040.ppd.gz
%{_datadir}/cups/model/Xerox-WorkCentre_3045.ppd.gz
%{_datadir}/cups/model/Xerox-WorkCentre_6015.ppd.gz

%files -n foo2ddst
%license COPYING
%doc README ChangeLog
%{_bindir}/*ddst*
%{_mandir}/man1/*ddst*
%{_datadir}/foomatic/db/source/driver/foo2ddst.xml
%{_datadir}/foomatic/db/source/printer/Ricoh-SP_112.xml
%{_datadir}/foomatic/db/source/printer/Ricoh-SP_201Nw.xml
%{_datadir}/foomatic/db/source/opt/foo2ddst-InputSlot.xml
%{_datadir}/foomatic/db/source/opt/foo2ddst-MediaType.xml
%{_datadir}/foomatic/db/source/opt/foo2ddst-PageSize.xml
%{_datadir}/foomatic/db/source/opt/foo2ddst-Resolution.xml
%{_datadir}/cups/model/Ricoh-SP_112.ppd.gz
%{_datadir}/cups/model/Ricoh-SP_201Nw.ppd.gz


%post
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2hp
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2xqx
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2lava
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2qpdl
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2oak
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2slx
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2hiperc
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2hbpl
/usr/bin/rm -f /var/cache/foomatic/*

%post -n foo2ddst
/usr/bin/rm -f /var/cache/foomatic/*

%changelog
* Wed Aug 30 2017 Christopher Atherton <the8lack8ox@gmail.com> 0.20170412-6
- Remove non-free files from source

* Tue Aug 29 2017 Christopher Atherton <the8lack8ox@gmail.com> 0.20170412-5
- Remove ICC and firmware files due to licensing

* Mon Jul 31 2017 Christopher Atherton <the8lack8ox@gmail.com> 0.20170412-4
- Add some ICC profiles and firmware files

* Wed Jul 26 2017 Fedora Release Engineering <releng@fedoraproject.org> - 0.20170412-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_27_Mass_Rebuild

* Fri Apr 14 2017 Christopher Atherton <the8lack8ox@gmail.com> 0.20170412-2
- Add post for foo2ddst

* Fri Apr 14 2017 Christopher Atherton <the8lack8ox@gmail.com> 0.20170412-1
- Update to latest release

* Thu Sep 29 2016 Christopher Atherton <the8lack8ox@gmail.com> 0.20160904-3
- Add optflags to CFLAGS

* Mon Sep 12 2016 Christopher Atherton <the8lack8ox@gmail.com> 0.20160904-2
- Spec file cleanup

* Sun Sep 04 2016 Christopher Atherton <the8lack8ox@gmail.com> 0.20160904-1
- New Printer: Xerox Phaser 3010
- New Printer: Xerox Phaser 3040
- Update to latest release

* Mon Aug 01 2016 Christopher Atherton <the8lack8ox@gmail.com> 0.20160801-1
- Update to latest release

* Fri Jan 22 2016 Christopher Atherton <the8lack8ox@gmail.com> 0.20160122-1
- Update to latest release

* Thu Nov 26 2015 Christopher Atherton <the8lack8ox@gmail.com> 0.20151111-3
- Add BuildRequires dependency on cups for driver autodetection

* Wed Nov 25 2015 Christopher Atherton <the8lack8ox@gmail.com> 0.20151111-2
- Add subpackage dependency on parent package

* Wed Nov 11 2015 Christopher Atherton <the8lack8ox@gmail.com> 0.20151111-1
- Update to latest release
- New Printer: Epson AcuLaser CX17NF
- New Printer: Fuji Xerox DocuPrint CM215
- New Printer: Fuji Xerox DocuPrint M215
- New Printer: Xerox WorkCentre 3045

* Thu Jan 30 2014 Christopher Atherton <the8lack8ox@gmail.com> 0.20140126-1
- Update to latest release
- Add package foo2hbpl
- Fix simple man page errors
- Correct FSF addresses

* Wed Oct 5 2011 David Woodhouse <dwmw2@infradead.org> 0.20110909-1
- Update to latest release
- Add Konica Minolta variant of 2430DL and 2300DL
- BR python-cups to get foomatic autodeps working

* Tue Jun 7 2011 Cédric Olivier <cedric.olivier@free.fr> 0.20110602-1
- New program: hbpldecode for decoding Fuji-Zerox cp105b and Dell 1250c

* Sun Feb 13 2011 Cédric Olivier <cedric.olivier@free.fr> 0.20110210-1
- Update to last release
- New Printer: Olivetti d-Color P160W
- New Printer: HP LaserJet Pro CP1025nw
- New printers: HP LaserJet 1022n, HP LaserJet 1022nw
- New Printer: Oki C310dn

* Sat Oct 23 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20101016-1
- Update to last release
- Remove Samsung-CLP-310.xml which conflict with foomatic-db package

* Fri Sep 17 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20100817-1
- New foo2lava printer: Xerox Phaser 6121MFP (printer only)
- Added manual page for foo2zjs-icc2ps

* Thu Jul 22 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20100722-1
- New Printer: Oki C110
- Change PPD's for Konica Minolta mc1600W, mc1680MF, mc1690MF, mc2490 MF, mc2530 DL, mc4690MF, 
and Oki C110 if cups-devel is installed.
- Used for reporting marker (toner) levels via PJL on foo2lava printers.

* Tue May 11 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20100506-2
- add foo2zjs-dynamic-jbig patch to use jbigkit-devel package instead of static jbig source code

* Fri May 07 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20100506-1
- Update to 20100506
- New Printers: Oki C5650
- New Printers: HP LaserJet Pro P1102, P1102w
- New Printers: HP LaserJet Pro P1566
- New Printers: HP LaserJet Pro P1606dn

* Wed Mar 10 2010 Cedric Olivier <cedric.olivier@free.fr> 0.20100307-1
- Update to 20100307
- BugFix and adding new printers supports

* Sat Apr 25 2009 Lubomir Rintel <lkundrak@v3.sk> 0.20080826-3
- Add proper scriptlet requires

* Sun Mar 29 2009 Thorsten Leemhuis <fedora [AT] leemhuis [DOT] info> - 0.20080826-2
- rebuild for new F11 features

* Thu Sep 04 2008 David Woodhouse <dwmw2@infradead.org> 0.20080826-1
- Update to 20080826
- Fixes to build with jbigkit 2.0
- add foo2oak subpackage

* Mon Mar 24 2008 David Woodhouse <dwmw2@infradead.org> 0.20080324-1
- Update to 20080324
- add foo2slx and foo2hiperc subpackage

* Wed Aug 29 2007 David Woodhouse <dwmw2@infradead.org> 0.20070822-1
- Update to 2007-08-22 release
- Add foo2qpdl subpackage
- Add %%post script to remove foomatic cache

* Mon Jan 29 2007 David Woodhouse <dwmw2@infradead.org> 0.20070128-1
- Update to 2007-01-28 release

* Mon Jan 29 2007 David Woodhouse <dwmw2@infradead.org> 0.20070127-1
- Update to 2007-01-27 release
- Add foo2xqx, foo2lava subpackages
- Include foomatic files which are now absent from Fedora foomatic

* Wed Sep 13 2006 David Woodhouse <dwmw2@infradead.org> 0.20060929-1
- Review fixes

* Wed Sep 13 2006 David Woodhouse <dwmw2@infradead.org> 0.20060911-1
- Initial build.
