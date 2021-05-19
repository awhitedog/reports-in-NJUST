function f=AL_obj(x)
	global r_al pena N_equ N_inequ;
	h_equ=0;
	h_inequ=0;
	[h,g]=constrains(x);
	for i=1:N_equ
		h_equ=h_equ-h(i)*r_al(i)+(pena/2)*h(i).^2;
	end
	for i=1:N_inequ
		h_inequ=h_inequ+(0.5/pena)*(max(0,(r_al(i)-pena*g(i))).^2-r_al(i).^2);
	end
	f=obj(x)+h_equ+h_inequ;
end