entity BCD is
port(d0,d1:in integer range 0 to 9;
binary:out integer range 0 to 63);
end BCD;
architecture one of BCD is
begin
binary<=d0+10*d1;
end one;
