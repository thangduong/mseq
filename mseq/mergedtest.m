% MERGEDTEST    Test code
%
ORDER= 15;
SEED=15;
peaks = detectpeaks(merged);
peaks = peaks(:,2)';
close all;
figure;

a = ['r'; 'g'; 'b'; 'c'; 'y']; 
b = merged;% - mean(merged);
N = 15;
v = slowseqp(16,45);
v = double(bitget(v(1:(length(v)-1)),1));
for i=1:17
   meanv(i) = mean(merged(i:17:length(merged)));
end
disp('subtracting the mean');
for i=1:floor(length(merged)/17)
   b(((i-1)*17+1):((i)*17)) =merged(((i-1)*17+1):((i)*17))- meanv;
end


for i=N:(N+5-1), 
   %   m = fastm(16,45,[0 rotatevector(b,-i*1024-1041+10)]); 
   tic
   m = fastm(ORDER,SEED,[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 rotatevector(b,(-i*1024-1041+1)*17)]); 
   toc
   hold on; 
   m(1)
   plot(m/65535 + 100 *(i-N), a(i-N+1,:)); 
   disp([num2str(i) ' ' a(i-N+1,:)]); 
end;
%a = ['r'; 'g'; 'b'; 'c'; 'y']; for i=45:49, m = fastm(16,45,[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 rotatevector(merged(1:(length(merged)-1)),-512*i)]); hold on; plot(m(1:50)/65535, a(i-44,:)); disp(num2str(i)); end;