function f=compare(x)
	global r_al pena N_equ N_inequ;
	h_equ=0;
	h_inequ=0;
	[h,g]=constrains(x);
	for i=1:N_equ
		h_equ=h_equ+h(i).^2;
	end
	for i=1:N_inequ
		h_inequ=h_inequ+(min(g(i),r_al(i+N_equ)/pena)).^2;
	end
	f=sqrt(h_equ+h_inequ);
end