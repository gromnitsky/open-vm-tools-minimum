# New ports collection makefile for:	open-vm-tools-minimum for FreeBSD
# Date created:		30 Aug 2011
# Whom:			alexander.gromnitsky@gmail.com
#
# $FreeBSD$
#

PORTNAME=		open-vm-tools-minimum
PORTVERSION=		${BUILD_VER}
PORTREVISION=		1
CATEGORIES=		emulators
MASTER_SITES=		SF/open-vm-tools/${PORTNAME}/${RELEASE_DATE}
DISTNAME=		open-vm-tools-${RELEASE_DATE}-${BUILD_VER}

MAINTAINER=		alexander.gromnitsky@gmail.com
COMMENT=		Open VMware tools for FreeBSD VMware guests (a light version)

LICENSE=		LGPL21
LICENSE_FILE=		${WRKSRC}/COPYING

RELEASE_DATE=		2011.08.21
BUILD_VER=		471295

WRKSRC=			${WRKDIR}/open-vm-tools-${RELEASE_DATE}-${BUILD_VER}
GNU_CONFIGURE=		yes
USE_LDCONFIG=		yes

CONFLICTS=		open-vm-tools-[0-9]* open-vm-tools-nox11-[0-9]* \
	vmware-guestd[0-9]* vmware-tools[0-9]*

CONFIGURE_ARGS+=	--without-dnet --without-icu \
	--without-kernel-modules --without-procps --disable-docs \
	--without-pam --disable-unity --sysconfdir=${LOCALBASE}/etc

.if defined(WITHOUT_X11)
LIB_DEPENDS+=		glib-2.0:${PORTSDIR}/devel/glib20
CONFIGURE_ARGS+=	--without-x --without-gtk2
PLIST_SUB+=		X11="@comment "
.else
#.if defined(WITH_UNITY)
#CONFIGURE_ENV+=		CUSTOM_URIPARSER_CPPFLAGS="-I${LOCALBASE}/include/uriparser"
#LIB_DEPENDS+=		uriparser.1:${PORTSDIR}/net/uriparser
#.else
#CONFIGURE_ARGS+=	--disable-unity
#.endif
LIB_DEPENDS+=		gtkmm-2.4:${PORTSDIR}/x11-toolkits/gtkmm24
CONFIGURE_ARGS+=	--with-x
#CONFIGURE_ENV+=		LDFLAGS="-L${LOCALBASE}/lib" \
#	CPPFLAGS="-I${LOCALBASE}/include"
USE_XORG=		x11 ice sm xext xineramaproto xinerama xrandr xrender xtst
USE_GNOME=		gtk20 glib20
PLIST_SUB+=		X11=""
.endif

SUB_FILES=		pkg-message
USE_RC_SUBR=		vmware_vmtoolsd_vmsvc.sh

.include <bsd.port.pre.mk>

.if ${OSVERSION} < 800000
BROKEN=		does not compile on 6.x or 7.X
.endif

.if ${ARCH} == "sparc64"
IGNORE=		not yet ported to sparc64
.endif

post-install:
	${PREFIX}/bin/vmware-toolbox-cmd timesync enable
	@${CAT} ${PKGMESSAGE}

.include <bsd.port.post.mk>
