function [Xk] = myfft(xn)
N=length(xn);           % Asign value to N
n=0:N-1;                % row vector for n
k=0:N-1;                % row vecor for k
WN=exp(-1j*2*pi/N);     % fixed value (w)
nk=n'*k;                % creates a N by N matrix of nk values
WNnk=WN.^nk;            % FFT matrix
Xk =WNnk*xn;            % Resultant FFT
end