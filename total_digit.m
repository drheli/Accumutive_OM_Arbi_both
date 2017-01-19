function [total] = total_digit(delta,diag)

total=(delta+1) * diag + (diag - 1)*diag/2*delta;
end