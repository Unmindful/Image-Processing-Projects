function [xn] = myifft(Xk)
N=length(Xk);           % Asign value to N
n=0:N-1;                % row vector for n
k=0:N-1;                % row vecor for k
WN=exp(1i*2*pi/N);      % fixed value (w)
nk=n'*k;                % creates a N by N matrix of nk values
WNnk=WN.^nk;            % IFFT matrix
xn =(WNnk*Xk)/N;        % Resultant IFFT
end