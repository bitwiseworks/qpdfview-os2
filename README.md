This is the home of the qpdfview port for OS/2 and OS/2 based systems.

qpdfview is a tabbed document viewer using Poppler, libspectre, DjVuLibre, CUPS and Qt, licensed under GPL version 2 or later.

The project homepage is "https://launchpad.net/qpdfview". The project maintainer is "Adam Reichold <adam.reichold@t-online.de>".

It depends on libQtCore, libQtGui. It also depends on libQtSvg, libQtSql, libQtDBus, libcups, resp. libz if SVG, SQL, D-Bus, CUPS, resp. SyncTeX support is enabled. It also depends on libmagic if Qt version 4 is used and libmagic support is enabled. The PDF plug-in depends on libQtCore, libQtXml, libQtGui and libpoppler-qt4 or libpoppler-qt5. The PS plug-in depends on libQtCore, libQtGui and libspectre. The DjVu plug-in depends on libQtCore, libQtGui and libdjvulibre. The Fitz plug-in depends on libQtCore, libQtGui and libmupdf.

The Fitz plug-in is currently considered experimental due to the lack of a maintainer. It also lacks support for various features, e.g. meta-data, encryption, text search, text extraction, form fields and annotations.

It is built using "lrelease qpdfview.pro", "qmake qpdfview.pro" and "make". It is installed using "make install". The installation paths are defined in "qpdfview.pri".

The following build-time options are available:
    * 'without_svg' disables SVG support, i.e. fallback and application-specific icons will not be available.
    * 'without_sql' disables SQL support, i.e. restoring tabs, bookmarks and per-file settings will not be available.
    * 'without_dbus' disables D-Bus support, i.e. the '--unique' command-line option will not be available.
    * 'without_pkgconfig' disables the use of pkg-config, i.e. compiler and linker options have to be configured manually in "qpdfview.pri".
    * 'without_pdf' disables PDF support, i.e. the PDF plug-in using Poppler will not be built.
    * 'without_ps' disables PS support, i.e. the PS plug-in using libspectre will not be built.
    * 'without_djvu' disables DjVu support, i.e. the DjVu plug-in using DjVuLibre will not be built.
    * 'with_fitz' enables Fitz support, i.e. the Fitz plug-in using MuPDF will be built.
    * 'without_image' disable image support, i.e. the plug-in using Qt's built-in image I/O will not be built.
    * 'static_pdf_plugin' links the PDF plug-in statically (This could lead to linker dependency collisions.)
    * 'static_ps_plugin' links the PS plug-in statically. (This could lead to linker dependency collisions.)
    * 'static_djvu_plugin' links the DjVu plug-in statically. (This could lead to linker dependency collisions.)
    * 'static_fitz_plugin' links the Fitz plug-in statically. (This could lead to linker dependency collisions.)
    * 'static_image_plugin' links the image plug-in statically.
    * 'without_cups' disables CUPS support, i.e. the program will attempt to rasterize the document instead of requesting CUPS to print the document file.
    * 'without_synctex' disables SyncTeX support, i.e. the program will not perform forward and inverse search for sources.
    * 'without_magic' disables libmagic support, i.e. the program will determine file type using the file suffix.
    * 'without_signals' disabled support for UNIX signals, i.e. the program will not save bookmarks, tabs and per-file settings on receiving SIGINT or SIGTERM.

For example, if one wants to build the program without support for CUPS and PostScript, one could run "qmake CONFIG+="without_cups without_ps" qpdfview.pro" instead of "qmake qpdfview.pro".

The fallback and application-specific icons are derived from the Tango icon theme available at "http://tango.freedesktop.org".
