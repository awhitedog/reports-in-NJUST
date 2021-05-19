function [X,FVAL]=AL_main(x_al,r_al,N_equ,N_inequ)
	global r_al pena N_equ N_inequ;
	pena=10;
	c_scale=2;
	cta=0.5;
	e_al=1e-4;
	max_itera=100;
	out_itera=1;
	while out_itera<max_itera
		x_al0=x_al;
		r_al0=r_al;
		compareFlag=compare(x_al0);
		[X,FVAL]=fminunc(@AL_obj,x_al0);
		x_al=X;
		if compare(x_al)<e_al
			break;
		end
		if compare(x_al)/compareFlag>=cta
			pena=c_scale*pena;
		end
		[h,g]=constrains(x_al);
		for i=1:N_equ
			r_al(i)=r_al(i)-pena*h(i);
		end
		for i=1:N_inequ
			r_al(i+N_equ)=max(0,(r_al(i+N_equ)-pena*g(i)));
		end
		out_itera=out_itera+1;
	end
	X=x_al;
	FVAL=obj(X);
end