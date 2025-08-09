function plot_sigmoid_from_coeffs(a,b,c,plot_both,tit)

a = transf(a);
b = transf(b);
c = transf(c);
x = [1; 2; 3; 4];
figure
if plot_both
nexttile
test_2(b, c)
title("2 param sigmoid")
end

nexttile
test_3(a, b, c)
title("3 param sigmoid")


nexttile
test_4(a, b, c, -5)
title("4 param sigmoid d=-5")


nexttile
test_4(a, b, c, -2)
title("4 param sigmoid d=-2")


nexttile
test_4(a, b, c, 2)
title("4 param sigmoid d=2")

nexttile
test_4(a, b, c, 5)
title("4 param sigmoid d=5")

sgtitle(tit)
end

function a = transf(a)
a=exp(abs(a));
end

function test_2( b, c)
fplot(@(x) 1/(1+b*exp(-c*(x))))
end

function test_3(a, b, c)
fplot(@(x) a/(1+b*exp(-c*(x))))
end

function test_4(a, b, c,d)
fplot(@(x) a/(1+b*exp(-c*(x-d))))
end