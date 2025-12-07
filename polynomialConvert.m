%jonesArray in form [x, a1, a2, a3, ...]
%x is the highest exponent, the a_n are the coefficients
% of t^x, t^(x-1), t^(x-2), etc.
function Jones = polynomialConvert(jonesArray)
    syms t
    highestPower = jonesArray(1);
    jonesArray = jonesArray(2:end);
    Jones = 0;
    for i = 1:length(jonesArray)
        Jones = Jones + jonesArray(i)*t^(highestPower-(i-1));
    end
end
