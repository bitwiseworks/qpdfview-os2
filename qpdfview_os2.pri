# define destdir
PLUGIN_DESTDIR = lib

# define the djvu part
DJVU_PLUGIN_LIBS += djvulibre
DJVU_PLUGIN = qpdfdjvu
DJVU_PLUGIN_NAME = $$DJVU_PLUGIN".dll"
DJVULIBRE_VERSION=3.5.27

# define the poppler part
PDF_PLUGIN_DEFINES += HAS_POPPLER_14 HAS_POPPLER_18 HAS_POPPLER_20 HAS_POPPLER_22 HAS_POPPLER_24 HAS_POPPLER_26 HAS_POPPLER_31 HAS_POPPLER_35
PDF_PLUGIN_LIBS += poppler-qt4
PDF_PLUGIN_INCLUDEPATH += /@unixroot/usr/include/poppler/qt4
PDF_PLUGIN = qpdfpdf
PDF_PLUGIN_NAME = $$PDF_PLUGIN".dll"
POPPLER_VERSION=0.49.0

# define the ps part
PS_PLUGIN_LIBS += spectre gs
PS_PLUGIN = qpdfps
PS_PLUGIN_NAME = $$PS_PLUGIN".dll"
LIBSPECTRE_VERSION=0.2.8

# define the cups part
CUPS_LIBS += cups
CUPS_VERSION=2.1.3

# define the image part
IMAGE_PLUGIN = qpdfimg
IMAGE_PLUGIN_NAME = $$IMAGE_PLUGIN".dll"

# define the vendor part
DEF_FILE_VENDOR = bww bitwise works GmbH
DEF_FILE_VERSION = $$APPLICATION_VERSION
DEF_FILE_DESCRIPTION = OS/2 and OS/2-based systems port of qpdfview by Adam Reichold
