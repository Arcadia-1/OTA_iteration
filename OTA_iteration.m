clear;
clc;
close all;

%%

global gmidn gmidp idwn idwp ftn ftp;
load('gmidn.mat');
load('gmidp.mat');
load('idwn.mat');
load('idwp.mat');
load('ftn.mat');
load('ftp.mat');


[Itot, Id1, Id2, W1, W2, W3, W4] = Itot_ota2stg(0.5, 0.5, 0.5, 0.5)

%%
function [Itot, Id1, Id2, W1, W2, W3, W4] = Itot_ota2stg(kc1, kc2, g31, g42)

global gmidn gmidp idwn idwp ftn ftp;


PMadd = 0;
scalegm1 = 1;
scalegm2 = 1;

T = 290;
k = 13807;

VDD = 3;
gamma = 0.67;

Cf = 200;
Cs = 400;
Cl = 400;
DR = 72;
fc = 150;
PM = 72;
e0 = 5e-3;

gain = Cs / Cf;
kp = tan(deg2rad(PM+PMadd));

L1 = 5;
L2 = 2;
L3 = 2;
L4 = 5;


kcdb1 = 0.7;
kcdb2 = 0.2;
kcdb3 = 0.7;
kcdb4 = 1;
VDSmin = 0.5;

Cgg1 = kc1 * Cs;
Cgg2 = kc2 * Cl;

beta = Cf / (Cf + Cs + Cgg1);

Cjunction1 = (kcdb1 + kcdb3) * Cgg1;
Cjunction2 = (kcdb2 + kcdb4) * Cgg2;

C1 = Cjunction1 + Cgg2;
C2 = Cjunction2 + Cl + (1 - beta) * Cf;

Vodmax = VDD - 2 * VDSmin;

Von2 = 0.5 * Vodmax * Vodmax / (10^(DR / 10 - 12)); %uV* uV
Cc = 2 * k * T * gamma / beta * (1 + g31) / (Von2 - 2 * k * T / Cl * gamma * (1 + g42)) %fF

gm1 = 2 * pi * fc * Cc / beta / 1000 * scalegm1 %uA/V
gm2 = kp * 2 * pi * fc * (C1 + C2 + C1 + C2 / Cc) / 1000 * scalegm2 %uA/V

ft1 = gm1 / 2 / pi / Cgg1; %GHz
ft2 = gm2 / 2 / pi / Cgg2; %GHz
gm3 = g31 * gm1; %uA/V
gm4 = g42 * gm2; %uA/V

gmid1 = min(15, interp1(ftp(:, L1), gmidp(:, L1), ft1)); %1/V
gmid2 = min(15, interp1(ftn(:, L2), gmidn(:, L2), ft2)); %1/V
gmid3 = g31 * gmid1; %1/V
gmid4 = g42 * gmid2; %1/V

Id1 = gm1 / gmid1;
Id2 = gm2 / gmid2;

Itot = 2 * (Id1 + Id2);

idw1 = exp(interp1(gmidp(:, L1), log(idwp(:, L1)), gmid1)); % uA/um
idw2 = exp(interp1(gmidn(:, L2), log(idwn(:, L2)), gmid2)); % uA/um
idw3 = exp(interp1(gmidn(:, L3), log(idwn(:, L3)), gmid3)); % uA/um
idw4 = exp(interp1(gmidp(:, L4), log(idwp(:, L4)), gmid4)); % uA/um

W1 = Id1 / idw1;
W2 = Id2 / idw2;
W3 = Id1 / idw3;
W4 = Id2 / idw4;

end