function main()
    clear all;
    clc;
    x_al=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];%
    r_al=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
    N_equ=7;
    N_inequ=30;
    [X,FVAL]=AL_main(x_al,r_al,N_equ,N_inequ)
end