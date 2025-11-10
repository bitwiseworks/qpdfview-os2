# define destdir
PLUGIN_DESTDIR = lib

# define the djvu part
DJVU_PLUGIN = qpdfdjvu
DJVU_PLUGIN_NAME = $$DJVU_PLUGIN".dll"

# define the poppler part
PDF_PLUGIN = qpdfpdf
PDF_PLUGIN_NAME = $$PDF_PLUGIN".dll"

# define the ps part
PS_PLUGIN = qpdfps
PS_PLUGIN_NAME = $$PS_PLUGIN".dll"

# define the image part
IMAGE_PLUGIN = qpdfimg
IMAGE_PLUGIN_NAME = $$IMAGE_PLUGIN".dll"

# define the vendor part
DEF_FILE_VENDOR = bww bitwise works GmbH
DEF_FILE_VERSION = $$APPLICATION_VERSION
DEF_FILE_DESCRIPTION = OS/2 and OS/2-based systems port of qpdfview by Adam Reichold
