Remarks on how to use this code
===============================


1.  This directory contains code for MEX files and .m files for Matlab to do various things.
2.  The MEX files source code are C++ code to be compiled with Visual C++ (I use 6.0, but
    I don't think the version should be that important).  It probably is possible (in fact,
    it is possible) to use matlab's mex function to compile all the code in here, but it's
    just much simpler to use VC++.
3.  To build the stuff in here, simply open the workspace file 'klein.dsw'.  This file
    should contain a bunch of projects.  These projects will compile to .DLL files that
    are MEX files (with the exception of matlabaux.dll).  All of the other .DLL files
    use matlabaux.dll, which contains code that is common in most of them.  This way the
    code space becomes smaller.
4.  The compiled .DLL (mex) files are stored in the BIN directory.  The BIN directory
    should contain .M files with descriptions of what the MEX files do.  Read the readme.txt
    file in the BIN directory for more info  on how to get things up and running after
    all the mex files (that you need) and matlabaux.dll are compiled.
5.  The function 'compile.m' also compiles all the code in this directory INSIDE matlab.  
    Note that if this function is used, there will be no matlabaux.dll.  It will be compiled
    into the individual mex files.  'compile.m' should work for Windows and Linux.
               - Thang 