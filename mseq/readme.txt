M-Sequence Tools

This directory contains a bunch of MEX and .m files to do various things with m-sequences.  Each 
mex file (.dll files in Windows) has a corresponding .m file containing a description of how to 
use the mex file.  There is one common file DLL file (matlabaux.dll) that is used by all of the 
mex file, and that needs to be placed in a directory that is in the Windows' PATH directory.  

1.  Do one of the following two steps:
	a.  Copy "matlabaux.dll" to c:\windows\system32 (or your corresponding windows32 directory)
	b.  Add the directory containing "matlabaux.dll" to your windows PATH environment variable
2.  Add the directory containing all the mex and corresponding .m files to your Matlab's path.
3.  Use help <function> to find out information on how to use the functions.

Here are the functions:


findmseqseed		Finds a bunch of seeds that will generate an maximal sequence
fastwalsh		Does a fast walsh-hadamard transform
mexmseqfindprod		Finds the location of a product of two sequences
slowseqp		Generates a sequence using the tap-register scheme as described by Sutter
detectpeaks		Detect the peaks of a signal using some heuristics (good for photodiode testing)
peaksdemo		Scrolls trhough the data to test the detectpeaks function.  Data assumed
			  to be collected with the 'getdata' function.  This code is very
			  idiosyncratic and shouldn't be used unless you know what you're doing.
makewalsh		This function is strictly for Thang's understand of some material.  It uses
			  the recursive (and rather archaic) definition of the Walsh kernel matrix
			  to generate the walsh kernel matrix of a given order.
mfromwalsh		Ditto as above.  This function is strictly for Thang's understand of the material.
			  It is very slow.
makemkernel		Ditto as above.  This function is strictly for Thang's understand of the material.
			  Makes an m-transform kernel by generating an m-sequence using slowseqp and
			  then shifting it per row appropriately.


M-Transform Code ------ any M-transform (according to Sutter's SIAM paper, and not too hard to understand)
                        is in the same equivalence class with the Walsh-Hadamard transform (i.e.
                           it can be written as M = P1 * W * P2 where M is the m-transform kernel matrix,
                           W is the walsh transform kernel matrix, P1 and P2 are permutation matrices)
                        The following functions allow a fast computation of m-transform according to
			Sutter's SIAM paper.
=======================
prewalshperm		Applies P2 to an array of data
postwalshperm		Applies P1 to an array of data
fastwalsh		Performs fast walsh transform on an array of data
fastm			The three functions above are mex files, so they should be fast.  This function
			   calls the three functions above to do an m-transform.
createbcplut		Prewalsh perm uses the generating register scheme to generate a bunch of
			   numbers.  This scheme works fast with a "bit count parity" look up table.
			   While fastm (and, hence, prewalshperm) generates this table automatically,
			   if these functions are called inside a loop, this lookup table should be
			   generated once by some code outside the loop and passed into either fastm
			   of prewalshperm.  Type 'help createbcplut' in matlab for info on how to use.
rotatevector		This function simply rotates a vector either forward or backward.  This is
			   for m-transforms of a shifted m-sequence.

TODO: merge rotatevector and prewalshperm into one function (one permutation matrix);  this will speed 
up things a little bit.



Please note that only the functions in the m-transform section (for now; there may be more in the future)
are used in the analysis of data.  All the functions such as 'slowseqp', 'detectpeaks', etc. are used to
either find a good seed or for testing purposes.

Finally, sometimes I refer to the Walsh transform as the Walsh-Hadamard transform (just to sound fancy, I suppose).
As far as I know (I may be wrong on this), there is no difference.  Hadamard defined a set of matrices
with certain properties.  A brief survey of old literature suggests that actually people are searching
for Hadamard matrices of different dimensions.  This may or may not be true anymore.  I haven't yet had time
to do a more comprehensive survey of the literature on this.  Walsh-Hadamard matrix defined by Walsh (actually,
Walsh defined a set of closed orthogonal functions, but similarly enough) satisfying the conditions defined by 
Hadamard.  I think a more accurate statement is to say that Walsh transforms are Hadamard transforms for matrices
of dimensions 2^J for integer J > 0.