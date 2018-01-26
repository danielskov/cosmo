function dpr=gpr(mpr,fixed_stuff)
m=mpr2m(mpr,fixed_stuff);
d = g(m,fixed_stuff);
dpr = d2dpr(d,fixed_stuff);
