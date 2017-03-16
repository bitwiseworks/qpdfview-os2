/* qpdfview Build Script */
/* version history */
/* version 0.1.0 from 25.03.2013 Silvan (first edition) */
/* version 0.1.1 from 25.04.2013 Silvan (new poppler lib) */
/* version 0.1.2 from 29.05.2013 Silvan (application version from qpdfview.pri) */
/* version 0.1.3 from 17.06.2013 Silvan (added .ps support) */
/* version 0.1.4 from 08.08.2013 Silvan (new poppler lib) */
/* version 0.1.5 from 20.08.2013 Silvan (added diff option) */
/* version 0.1.6 from 15.10.2013 Silvan (copy all help*.html) */
/* version 0.2.0 from 16.10.2013 Silvan (get some info form qpdfview_os2.pri) */
/* version 0.2.1 from 03.12.2013 Silvan (help files now in help dir) */
/* version 0.2.2 from 26.09.2014 Silvan (don't copy the tiff.dll) */
/* version 0.2.3 from 29.09.2014 Silvan (don't copy the poppler*.dll) */
/* version 1.0.0 from 05.09.2016 Silvan (don't copy the djvu*.dll) */
/* version 1.0.1 from 06.09.2016 Silvan (don't copy the spectre*.dll) */

/* init the version string (don't forget to change) */
version = "1.0.1"
version_date = "06.09.2016"
'@echo off'

parse arg command option
parse source . . scriptFile

/* init the required vars */
qRC = 0
mRC = 0
buildDir    = strip(directory(),'T','\') /* Make sure we have no trailing backslash */
sourceDir = FixDir(filespec('D', scriptFile) || filespec('P', scriptFile))
vendorDir  = sourceDir || '\..\vendor\current'
diffDir    = sourceDir || '\..\'
srcDir     = sourceDir
OS2Dir     = sourceDir
installDir = buildDir || '\install'
installDirT= installDir || '\data'
qErrorFile = buildDir||'\qmake.err'
qOutFile   = buildDir||'\qmake.out'
mErrorFile = buildDir||'\make.err'
mOutFile   = buildDir||'\make.out'
qt4bin = '%unixroot%\usr\lib\qt4\bin\'

/* get the Qpdfview version */
Qpdfview_version = '0.0.0'
Qpdfview_build = ' '
call version
internal_build = translate(Qpdfview_version, '_', '.')

/* get some info from qpdfview_os2.pri */
psDir = ' '
call getpri

title = "Qpdfview for OS/2 and OS/2-based systems build script v" || version || " from " || version_date
say title
say
say "Build directory   :" buildDir
say "Source directory  :" sourceDir
say
say "Qpdfview version  :" Qpdfview_version
say "         build    :" Qpdfview_build 
say

/* translate command to all upercase */
command = translate(command)

if command = "" then signal help


if command = "INSTALL" then do
    if option \== "" then do
	Qpdfview_build = option
    end
    select
	when Qpdfview_build \== "" then do
	  zipFile = installDir || '\qpdfview-' || internal_build || '-' || Qpdfview_build || '.zip'
	end
	otherwise do
	  signal help
	end
    end 
end

/* now we translate also the option */
option = translate(option)

if sourceDir \== buildDir then do
    say "Shadow build in progress ..."
    say
end

say "Executing command: "command option

select
    when command = "MAKE" & option = "CLEAN" then do

        say "cleaning the tree"
        call make 'distclean'

        say "please execute this script again with 'make' to build Qpdfview"

    end
    when command = "MAKE" then do

        say "creating Qpdfview makefile"
        call qmake

        if qRC = 0 then do
            say "building Qpdfview"
	    if option = "" then do
            	call make
	    end
	    else do
		call make 'debug'
	    end
        end

    end

    when command = "INSTALL" then do

/* first delete everything */
	call deleteall

/* create the installDir,and the translation subdir */
	ok = SysMkDir(installDir)
	ok = SysMkDir(installDirT)

/* copy the exe */
	ok = SysCopyObject(buildDir||'\Qpdfview.exe',installDir)

/* copy all dll */
        ok = SysFileTree(buildDir||'\*.dll', rm.,'FOS')
        do i = 1 to rm.0
          ok = SysCopyObject(rm.i, installDir)
        end

/* copy the readme */
	rm.0 = 1
	rm.1 = 'install.os2'
	do i = 1 to rm.0
	cmdtorun = 'sed "s;_VERSION_;' || Qpdfview_version || ';g" ' || os2Dir || '\' || rm.i || ' | sed "s;_BUILD_;' || Qpdfview_build || ';g" >' || installDir || '\' || rm.i
        address cmd cmdtorun
	end

/* copy different stuff */
	rm.0 = 2
	rm.1 = 'CHANGES'
	frmDir.1 = os2Dir
	toDir.1 = installDir
	rm.2 = 'help*.html'
	frmDir.2 = os2Dir || '\help'
	toDir.2 = installDirT
	do i = 1 to rm.0
	cmdtorun = 'copy ' || frmDir.i || '\' || rm.i || ' ' || toDir.i
        address cmd cmdtorun
	end

/* create the qm files from ts files */
	ok = SysFileTree(srcDir||'\translations\*.ts', rm.,'FO')
        do i = 1 to rm.0
	    fileName = filespec('N',rm.i)
	    fileName = left(fileName,lastpos('.', fileName)-1) || '.qm'
            cmdtorun = qt4bin || 'lrelease ' || rm.i || ' -qm ' || installDirT || '\' || fileName
	    address cmd cmdtorun
        end

/* zip all dynamic stuff */
	ok = directory(installDir)
	cmdtorun = 'zip -r ' || zipFile || ' * -x *.zip'
	address cmd cmdtorun
        ok = directory(buildDir)

/* zip all icons */

    end

    when command = "UNINSTALL" then do

	call deleteall
	
    end

    when command = "DIFF" then do

	address cmd 'diff -Naur ' || vendorDir || ' ' || sourceDir || ' -x qpdfview.desktop >' || diffDir || 'qpdfview_' || Qpdfview_version || '_' || Qpdfview_build || '.diff'
	
    end

    otherwise do
        say 'Unknown parameter "'command'" - aborting...'
        exit 1
    end
end

/* cleanup the mess */
error:

if qRC = 0 & mRC = 0 then do
    ok = SysFileDelete(mOutFile)
    ok = SysFileDelete(mErrorFile)
    ok = SysFileDelete(qOutFile)
    ok = SysFileDelete(qErrorFile)
end
else do
    if mRC <> 0 then do
        say "Alarm! Make errors occured! Look at "mOutFile" and "mErrorFile
    end
    if qRC <> 0 then do
        say "Alarm! qMake errors occured! Look at "qOutFile" and "qErrorFile
    end
end

exit 0

qmake:
    sourceFile = sourceDir || '/qpdfview.pro'
    address cmd 'qmake "CONFIG+=without_pkgconfig" "CONFIG+=without_dbus" "CONFIG+=without_magic" ' sourceFile ' 2>'qErrorFile' 1>'qOutFile

    qRC = RC
    if qRC <> 0 then do
        call beep 880, 20
        say "Alarm! qmake RC="RC
    end
return

make:
    makeparm = arg(1)
    address cmd 'make 'makeparm' 2>'mErrorFile' 1>'mOutFile
    mRC = RC
    if mRC <> 0 then do
        call beep 880, 20
        say "Alarm! make RC="RC
    end
return


deleteall: /* delete installDir (including subdirs) except zip files */

    say "Delete all files except *zip in " installDir
    ok = SysFileTree(installDir||'\*', rm.,'FOS')
    do i = 1 to rm.0
       if translate(right(rm.i, 3)) \== 'ZIP' then do
          ok = SysFileDelete(rm.i)
       end
    end

    say "Delete zip file " zipFile
    ok = SysFileDelete(zipFile)

    say "Removing subdirs from " || installDir
    ok = SysFileTree(installDir||'\*', rm.,'OS')
    do i = 1 to rm.0
       ok = SysRmDir(rm.i)
    end

    call SysSleep(5)
return

/**
 *  Fixes the directory path by a) converting all slashes to back
 *  slashes and b) ensuring that the trailing slash is present if
 *  the directory is the root directory, and absent otherwise.
 *
 *  @param dir      the directory path
 *  @param noslash
 *      optional argument. If 1, the path returned will not have a
 *      trailing slash anyway. Useful for concatenating it with a
 *      file name.
 */
FixDir: procedure expose (Globals)
    parse arg dir, noslash
    noslash = (noslash = 1)
    dir = translate(dir, '\', '/')
    if (right(dir, 1) == '\' &,
        (noslash | \(length(dir) == 3 & (substr(dir, 2, 1) == ':')))) then
        dir = substr(dir, 1, length(dir) - 1)
    return dir

/**
 *  reads the version.cpp and gets the Qpdfview version from there
 */ 
version: procedure expose Qpdfview_version Qpdfview_build srcDir

    QpdfviewVer = ' '
    /* Qpdfview Version file */
    Version = srcDir || "\qpdfview.pri"

    do until lines(Version) = 0
        verline = linein(Version)
        if substr(Verline,30,19) = "APPLICATION_VERSION" then do
            parse var verline . ' '. ' ' QpdfviewVer
        end
    end

    ok = stream(Version,'c','close')
    if QpdfviewVer \== ' ' then do
    	QpdfviewVer = strip(QpdfviewVer,,'"')
	parse var QpdfviewVer ver '.' maj '.' min '.' Qpdfview_build
    	Qpdfview_version = ver || '.'|| maj || '.' || min
    end

    if Qpdfview_build == '' then do
    	Qpdfview_build = 'GA'
    end

    return

/**
 *  reads the qpdfview_os2.pri and some values from there
 */ 
getpri: procedure expose srcDir

    /* Qpdfview_os2.pri file */
    priFile = srcDir || "\qpdfview_os2.pri"

    do until lines(priFile) = 0
        verline = linein(priFile)
        verline = strip(verline,,' ')
    end

    ok = stream(priFile,'c','close')
    return

help:
    say "Parameters:"
    say "    make"
    say "    make debug"
    say "    make clean"
    say "    install build (build overwrites what this script finds)"
    say "    uninstall"
    say "    diff (creates a diff from vendor to trunk)"
exit 255
