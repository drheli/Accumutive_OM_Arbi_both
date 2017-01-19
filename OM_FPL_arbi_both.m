function [i,x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,CAx_plus,CAx_minus,CAy_plus,CAy_minus,CAx_plus_sel, CAx_minus_sel,CAy_plus_sel, CAy_minus_sel, cout_one_plus, cout_one_minus, cout_two_plus, cout_two_minus, shift_o_plus, shift_o_minus,u_f,enable,res_enable,compare_frac,v_int_plus, v_int_minus,v_frac_plus, v_frac_minus,w_int_plus,w_int_minus,w_frac_plus, w_frac_minus,p1,p0,d,c,k,u_r,n_r,count,d_o_plus,d_o_minus] = OM_FPL_arbi_both ()
unrolling = 8;
% persistent p_out_plus; persistent p_out_minus;
% if isempty(flag)
%     p_out_plus = zeros(1,4*unrolling); p_out_minus = zeros(1,4*unrolling); 
% end
persistent p_plus;
persistent p_minus;
if isempty(p_plus) || isempty(p_minus)
    p_plus = 0;
    p_minus = 0;
end

for j=1:1000
[d,c,k,u_r,n_r,d_plus_in, d_minus_in,d_o_plus,d_o_minus] = D_control(p_plus,p_minus);

[i,x_plus_rev,x_minus_rev,y_plus_rev,y_minus_rev,CAx_plus,CAx_minus,CAy_plus,CAy_minus,CAx_plus_sel, CAx_minus_sel,CAy_plus_sel, CAy_minus_sel, cout_one_plus, cout_one_minus, cout_two_plus, cout_two_minus, shift_o_plus, shift_o_minus,u_f,enable,res_enable,compare_frac,v_int_plus, v_int_minus,v_frac_plus, v_frac_minus,w_int_plus,w_int_minus,w_frac_plus, w_frac_minus,p_plus,p_minus,count] = OM_FPT_ALG(d_plus_in, d_minus_in, d_plus_in, d_minus_in, k,u_r,n_r);
p1=p_plus;
p0=p_minus;
end
