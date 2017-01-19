% read the input digit in a specific location 
function [i_r,j_r,k,diag,count,w,n_r,u_r,d_plus_in, d_minus_in] = D_in_control(d_plus,d_minus)
unrolling = 8;
delta = 3;
persistent i; 
persistent j;
    if(isempty(i)&& isempty(j))
        i=0;  % left shift delta 0
        j=0;
    end
persistent diag_c;
persistent count_c;
persistent ite_k;
if isempty(diag_c) || isempty(count_c) || isempty(ite_k)
    diag_c = 0;
    count_c = 1;
    ite_k = 0;  % ite_k == 0, store the original x and y; ite_k > 0 store each iteration digits
end

% digit input read
% in hardware count_c = 1,3,6,10,...to last digit, next clk diag_c + 1;
% in software,count_c = 1,2,4,7,...to first digit, current call diag_c + 1;
if count_c == (diag_c+1)*diag_c/2 + 1
    diag_c = diag_c + 1;
end
    
if count_c == (diag_c-1)*diag_c/2 + 1    
    ite_k = 0;  % generate original input x,y 
else 
    % valid in 1st digit of delta group
    if i == 0 && j == 0
    ite_k = ite_k + 1;
    end
end

% digit assignment in delta group
if diag_c - ite_k == 1
    % import the first 4 digit in each iteration
    i = i + 1;    
        d_plus_in = d_plus(pairing(0,ite_k),i);
        d_minus_in = d_minus(pairing(0,ite_k),i);
    if i == delta + 1
        count_c = count_c + 1;
        i = 0;
    end
    w=0;n_r=0;u_r=0;
else % diad_c - ite_k > 1
    j = j+1;
        w = (delta+1)+(diag_c-ite_k - 2)*delta + j;
        n_r = ceil(w/unrolling) - 1;
        if mod (w,unrolling)==0
            u_r = unrolling;
        else
            u_r = mod (w,unrolling);
        end
        %u_r = mod (w,unrolling);
        %d_minus_in = d_minus(ite_k,(delta+1)+(diag_c-ite_k)*delta + j);
        d_plus_in = d_plus(pairing(n_r,ite_k),u_r);
        d_minus_in = d_minus(pairing(n_r,ite_k),u_r);
    %end
    if j == delta
        count_c = count_c + 1;
        j = 0;
    end

end
i_r=i;
j_r=j;
k=ite_k;
diag=diag_c;
count=count_c;
end



