% COMPILE   Compiles code in the KLEIN directory
%   
%   COMPILE([ROOT], [FILES]) compiles files given by FILES.  FILES must be
%   cell, and if it is {}, then this function compiles all.  ROOT is the
%   root directory /mnt/data/klein (or t:\klein, for example).
% 
% REVISION HISTORY
%
% 12/2/2003     Thang       Created this file so I can compile the code
%                           nicely in linux as well as Windows without messy makefiles!
% 12/9/2003     Thang       Made this a function with two arguments.
% 12/16/2003    Thang       Lost a bunch of versio  n of this.  Added
%                           nmfastwalsh and some more default parameters
%
function compile(root, files)

if ((nargin < 1) | (length(root) == 0))
    if (ispc)
%        root = 't:\mseq';
    else
%        root = '/mnt/data/mseq';
    end 
    root = '.';
end

oldDir = pwd;

if (isdir(root))
    cd(root);
else
    disp(['Invalid parameter root = ' root]);
    disp(['Please read the help text and follow appropriately:']);
    help compile;
    return;
end

if (nargin < 2)
    files = {};
end

if (iscell(files) == 0)
    files = {files};
end

% each cell in mexfiles contains N subcells.  The first subcell is the name
% of the mex file to be compiled (must be in directory with the same name)
% and the subsequent subcells are cpp files to compile (matlabaux.cpp is
% assumed to be included)

mexfiles = getmexfiles;
curdir = pwd;

if (length(files) == 0)
    disp(['compiling ' num2str(length(mexfiles)) ' MEX files...']);
    for i=1:length(mexfiles)
        cmd = ['mex -DCOMPILE_IN_MATLAB -I' curdir '/matlabaux ' curdir '/matlabaux/matlabaux.cpp -outdir ' curdir '/mseq -output ' mexfiles{i}{2}];
        for j=3:length(mexfiles{i})
            cmd = [cmd ' ' curdir '/' mexfiles{i}{2} '/' mexfiles{i}{j}];
        end
        if (length(mexfiles{i}{1}))
            disp(['compiling : ' mexfiles{i}{2} ' - ' mexfiles{i}{1}]);
        else
            disp(['compiling : ' mexfiles{i}{2}]);
        end
        eval(cmd);
    end
else
    disp(['compiling ' num2str(length(files)) ' MEX files...']);
    for k=1:length(files)
        for i=1:length(mexfiles)
            if (strcmpi(files{k},mexfiles{i}{2}) == 1)
                cmd = ['mex -DCOMPILE_IN_MATLAB -I' curdir '/matlabaux ' curdir '/matlabaux/matlabaux.cpp -outdir ' curdir '/mseq -output ' mexfiles{i}{2}];
                for j=3:length(mexfiles{i})
                    cmd = [cmd ' ' curdir '/' mexfiles{i}{2} '/' mexfiles{i}{j}];
                end
                if (length(mexfiles{i}{1}))
                    disp(['compiling : ' mexfiles{i}{2} ' - ' mexfiles{i}{1}]);
                else
                    disp(['compiling : ' mexfiles{i}{2}]);
                end
                eval(cmd);
                break;
            end
        end
    end
end

cd(oldDir);