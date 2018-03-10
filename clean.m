% CLEAN     This function cleans a directory for temporary/intermediate files
%
%   DELFILES = CLEAN([ROOT]) cleans directory given by [ROOT] by deleting
%   the following:
%
%       1.  Directories call "Debug"
%       2.  .ASV, .PLG, .OPT, .NCB, .LOG, .AUX, or .ILK files
%       3.  All files with name given in the GETMEXFILES function with
%       suffix '.DLL', '.MEXGLX'
%         
%
%   DELFILES = files that got deleted by this function.  [ROOT] defaults to
%   t:\klein.
%
% See also COMPILE.
%
function delfiles = clean(root)

if (nargin < 1)
%    root = 't:\mseq';
    root = '.';
end

mexfiles = getmexfiles;

delcvs = 1;
rootfiles = dir(root);
delfiles = {};
ndelfiles = 0;
%disp(['Cleaning directory : ' root]);
for i=1:length(rootfiles)
    if (rootfiles(i).isdir)
        if ((strcmp(rootfiles(i).name, '.')) || (strcmp(rootfiles(i).name, '..')))
        else
            if ((delcvs && strcmpi(rootfiles(i).name, 'cvs'))...
                    || strcmpi(rootfiles(i).name, 'debug')...
                    || strcmpi(rootfiles(i).name, 'release'))
                ndelfiles = ndelfiles+1;
                delfiles{ndelfiles} = [root '/' rootfiles(i).name];
                rmdir([root '/' rootfiles(i).name], 's');
                disp(['    deleting ' root '/' rootfiles(i).name]);
            else
                v = clean([root '/' rootfiles(i).name]);
                if (length(v))
                    for k=1:length(v)
                        ndelfiles = ndelfiles+1;
                        delfiles{ndelfiles} = v{k};
                    end
                end
            end           
        end
    else
        len = length(rootfiles(i).name);
        suffix = rootfiles(i).name(max(1,len-3):len);
        suffix4 = rootfiles(i).name(max(1,len-4):len);
        suffix6 = rootfiles(i).name(max(1,len-6):len);
        
        % if the entry is a file, delete it if it's in our list of deleting
        % files...
        if (strcmpi(suffix,'.ncb') || strcmpi(suffix,'.opt') || strcmpi(suffix,'.plg') ||...
                strcmpi(suffix,'.asv') || strcmpi(suffix,'.log') || strcmpi(suffix,'.aux') || ...
                strcmpi(suffix4,'.save') || strcmpi(suffix,'.ilk'))
            ndelfiles = ndelfiles+1;
            delfiles{ndelfiles} = [root '/' rootfiles(i).name];
            delete([root '/' rootfiles(i).name]);
            disp(['    deleting ' root '/' rootfiles(i).name]);
        else
            if (strcmpi(suffix, '.mat'))
                suffix8 = rootfiles(i).name(max(1,len-8):len);
                if (~strcmpi(suffix, '.keep.mat'))
                    ndelfiles = ndelfiles+1;
                    delfiles{ndelfiles} = [root '/' rootfiles(i).name];
                    delete([root '/' rootfiles(i).name]);
                    disp(['    deleting ' root '/' rootfiles(i).name]);                    
                end                    
            else
                if (strcmpi(suffix,'.dll') || strcmpi(suffix6, '.mexglx'))
                    fname = rootfiles(i).name(1:max(1,len - length(suffix)));
                    fname6 = rootfiles(i).name(1:max(1,len - length(suffix6)));
                    if (strcmpi(fname, 'matlabaux'))
                        ndelfiles = ndelfiles+1;
                        delfiles{ndelfiles} = [root '/' rootfiles(i).name];
                        delete([root '/' rootfiles(i).name]);
                        disp(['    deleting ' root '/' rootfiles(i).name]);                    
                    else
                        for j=1:length(mexfiles)
                            if (strcmpi(mexfiles{j}{2}, fname) || strcmpi(mexfiles{j}{2}, fname6))
                                ndelfiles = ndelfiles+1;
                                delfiles{ndelfiles} = [root '/' rootfiles(i).name];
                                delete([root '/' rootfiles(i).name]);
                                disp(['    deleting ' root '/' rootfiles(i).name]);
                                break;
                            end
                        end
                    end
                end
            end
        end
    end
end