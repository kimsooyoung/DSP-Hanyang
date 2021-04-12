syms n positive
syms a b

f1(b, n) = b^n;
F1 = ztrans(f1)

f2(a, n) = a * sin(pi / 6 * n);
F2 = ztrans(f2)

f3(a, n) = exp(-a * n);
F3 = ztrans(f3)

ff1 = iztrans(F1)

ff2 = iztrans(F2)

ff3 = iztrans(F3)