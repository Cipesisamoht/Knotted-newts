%jonesArray in form [x, a1, a2, a3, ...]
%x is the highest exponent, the a_n are the coefficients
% of t^x, t^(x-1), t^(x-2), etc.
function [Jones_A,Jones_t] = polynomialConvert(jonesArray)
    syms A t
    highestPower = jonesArray(1);
    jonesArray = jonesArray(2:end);
    Jones_A = 0;
    Jones_t = 0;
    for i = 1:length(jonesArray)
        %In terms of A
        Jones_A = Jones_A + jonesArray(i)*A^(highestPower-(i-1));
        %In terms of t
        Jones_t = Jones_t + jonesArray(i)*t^((-1/4)*(highestPower-(i-1)));
    end
    
end
