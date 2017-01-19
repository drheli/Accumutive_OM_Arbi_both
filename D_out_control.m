% store the output p in the specific location
function [i,j,k,diag,count,d_o_plus,d_o_minus,n_w,w_w] = D_out_control(p_plus,p_minus)
unrolling = 8;
delta = 3;
persistent i_w; 
persistent j_w;
    if(isempty(i_w)&& isempty(j_w))
        i_w=0;  % left shift delta 0
        j_w=0;
    end
persistent d_plus_w;
persistent d_minus_w;
    if(isempty(d_plus_w)&& isempty(d_minus_w))
        d_plus_w = zeros(1024,unrolling + delta);  % left shift delta 0
        d_minus_w = zeros(1024,unrolling + delta);
    end
persistent diag_c_w;
persistent count_c_w;
persistent ite_k_w;
if isempty(diag_c_w) || isempty(count_c_w) || isempty(ite_k_w)
    diag_c_w = 0;
    count_c_w = 1;
    ite_k_w = 1;  % ite_k = 1 store 1st iteration digits
end

% digit output write
% in hardware count_c_w = 1,3,6,10,...to last digit, next clk diag_c + 1;
% in software,count_c_w = 1,2,4,7,...to first digit, current call diag_c + 1;  
if count_c_w == (diag_c_w+1)*diag_c_w/2 + 1
    diag_c_w = diag_c_w + 1;
end

if count_c_w == (diag_c_w-1)*diag_c_w/2 + 1
    ite_k_w = 1;   % generate 1st iteration digits 
else 
    % valid in 1st digit of delta group
    if i_w == 0 && j_w == 0
    ite_k_w = ite_k_w + 1;
    end
end

% digit assignment in delta group
if diag_c_w - ite_k_w == 0
    % import the first 4 digit in each iteration
    i_w = i_w + 1;
    if i_w == delta + 1
        count_c_w = count_c_w + 1;
        d_plus_w(pairing(0,ite_k_w),i_w-delta) = p_plus;
        d_minus_w(pairing(0,ite_k_w),i_w-delta) = p_minus;
        i_w = 0;
    end
    %d_o_plus = d_plus_w(pairing(0,ite_k_w),delta+1 : unrolling + delta);
    %d_o_minus = d_minus_w(pairing(0,ite_k_w),delta+1 : unrolling + delta);
    d_o_plus = d_plus_w(pairing(0,ite_k_w),:);
    d_o_minus = d_minus_w(pairing(0,ite_k_w),:);
    w_w = 0; n_w = 0;
else % diad_c - ite_k > 0
    % w_w is very important parameter to determine the digit location
    j_w = j_w+1;
        %w_w = (delta+1)+(diag_c_w-ite_k_w -1)*delta + j_w - delta;
        w_w = (diag_c_w-ite_k_w -1)*delta + j_w + 1;
        n_w = ceil(w_w/unrolling) - 1;
        if mod (w_w,unrolling)==0
            u_w = unrolling;
        else
            u_w = mod (w_w,unrolling);
        end
        %u_r = mod (w,unrolling);
        %d_minus_in = d_minus(ite_k,(delta+1)+(diag_c-ite_k)*delta + j);
        d_plus_w(pairing(n_w,ite_k_w),u_w) = p_plus;
        d_minus_w(pairing(n_w,ite_k_w),u_w) = p_minus;
    if j_w == delta
        count_c_w = count_c_w + 1;
        j_w = 0;
    end
    %d_o_plus = d_plus_w(pairing(n_w,ite_k_w),delta+1 : unrolling + delta);
    %d_o_minus = d_minus_w(pairing(n_w,ite_k_w),delta+1 : unrolling + delta);
    d_o_plus = d_plus_w(pairing(n_w,ite_k_w),:);
    d_o_minus = d_minus_w(pairing(n_w,ite_k_w),:);
end
i=i_w;
j=j_w;
k=ite_k_w;
diag=diag_c_w;
count=count_c_w;
end
    