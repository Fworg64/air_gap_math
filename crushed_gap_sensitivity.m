% This script models the "Air Gap" sensor, after the air gap has been
% crushed out, and both the flexPCB and case deform from the input force.

syms F f h d d1 d2 d1n d2n kt ks kpi1 kpi2 e A L cb ce1 ce2 cm
%    F: input force
%    f: resonant frequency
%    h: nominal total sensor height
%    d: total sensor displacement from nominal
%   d1: element 1 (top) displacement from nominal
%   d2: element 2 (bottom) displacement from nominal
%  d1n: nominal distance for top element between electrode and case
%  d2n: nominal distance for bottom element b/w electrode and case
%   kt: total stiffness of sensor
%   ks: stiffness of steel walls
% kpi1: stiffness of element 1 (top)
% kp12: stiffness of element 2 (bottom)
%    e: dielectric permittivity of polyimide
%    A: Area of sensing element electrode
%    L: Inductance in sensing circuit
%   cb: base capacitance of sensing circuit
%  ce1: capacitance of element 1 (top)
%  ce2: capacitance of element 2 (bottom)
%   cm: capacitance as measured by circuit

% Total stiffness model, sensor case parallel to series polyimide elements
kt = ks + (1/kpi1 + 1/kpi2)^(-1)

% Sensor height
h = d1n + d2n

% Sensor deformation model, total displacement from total stiffness
d = F / kt

% Sensor element 1 displacement
d1 = d / (1 + kpi2/kpi1)

% Sensor element 2 displacement
d2 = d / (1 + kpi1/kpi2)

% Sensor capacitance model, between electrode and case, top side
ce1 = e * A / (d1n - d1)

% Other element, between electrode and case, bottom side
ce2 = e * A / (d2n - d2)

% Measured capacitance relation to cap network with parallel env cap
cm = cb + ce1 + ce2

% Sensor resonant frequency model
f = 1 / (2*pi*sqrt(L*cm))

df_dF = simplify(diff(f, F))
display(latex(df_dF))

A = 3.75e-4
e = 8.854e-12 * 3.2
d1n = 0.32e-4
d2n = 1.35e-4 % 100um of PI and 25um of soldermask and 10um of super glue
ks = 5.0e9
kpi1 = 8.0e8 * 2.9e-3 / d1n
kpi2 = 8.0e8 * 2.9e-3 / d2n
L = 18e-6
cb = 33e-12
F = [0:1e3:200e3];

cap_values = subs(cm);
freq_values = subs(f);
sensitivity_values = subs(df_dF);
strain_values = subs(d/h);

figure();
subplot(4,1,1);
plot(sensitivity_values);
title("Hertz per Newton vs Force")

subplot(4,1,2);
plot(freq_values);
title("Frequency vs Force")

sgtitle("Crushed Gap")

subplot(4,1,3);
plot(cap_values);
title("Sensor Cap vs Force")

subplot(4,1,4);
plot(strain_values);
title("Sensor Strain vs Force")

