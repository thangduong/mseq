% MERGEDTEST2   Test code
%
peaks = detectpeaks(merged);
peaks = peaks(:,2)';
close all;
figure;
a = ['r'; 'g'; 'b'; 'c'; 'y']; 
b = peaks;
b(find(b<2000)) = 1000;
b(find(b>2000)) = -1000;
for i=34:38, 
   m = fastm(16,45,[0 rotatevector(b,-i*512)]); 
   hold on; 
   plot(m(1:100)/65535 + 1000*(i-34), a(i-33,:)); 
   disp([num2str(i) ' ' a(i-33,:)]); 
end;