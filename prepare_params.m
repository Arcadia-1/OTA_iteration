close all;
clc;
clear;

%%
run_sp_simulation('current_density_scan.sp')
m = loadsig('current_density_scan/current_density_scan.sw0');
lssig(m)

ovn = evalsig(m, 'ov_n');
ftn = evalsig(m, 'ft_n');
gmidn = evalsig(m, 'gm_id_n');
idwn = evalsig(m, 'id_w_n');

ovp = evalsig(m, 'ov_p');
ftp = evalsig(m, 'ft_p');
gmidp = -evalsig(m, 'gm_id_p');
idwp = -evalsig(m, 'id_w_p');

L = evalsig(m, 'sw_l');

save('gmidn', 'gmidn')
save('gmidp', 'gmidp')
save('idwn', 'idwn')
save('idwp', 'idwp')
save('ftn', 'ftn')
save('ftp', 'ftp')

plot_L_sweeping(ovn, ftn, L, 'V_o_v [V]', 'f_T [Hz]', 'ft_scan_nmos')
plot_L_sweeping(ovn, gmidn, L, 'V_o_v [V]', 'g_m/I_d [1/V]', 'gm_id_scan_nmos')
plot_L_sweeping(gmidn, idwn, L, 'g_m/I_d [1/V]', 'I_d/W [uA/um]', 'id_w_scan_nmos')

plot_L_sweeping(ovp, ftp, L, 'V_o_v [V]', 'f_T [Hz]', 'ft_scan_pmos')
plot_L_sweeping(ovp, gmidp, L, 'V_o_v [V]', 'g_m/I_d [1/V]', 'gm_id_scan_pmos')
plot_L_sweeping(gmidp, idwp, L, 'g_m/I_d [1/V]', 'I_d/W [uA/um]', 'id_w_scan_pmos')

%% Functions

function plot_L_sweeping(x, y, L, xaxis_name, yaxis_name, figure_name)

close all;
figure('Visible', 'off')
hold on;


l = strings;
for i = 1:10
    plot(x(1:end, i), y(1:end, i));
    l(i) = strcat('L=', num2str(L(i)*1e6), 'um');
end

set(gca, 'LineWidth', 1.5);

legend(l, 'Location', 'best')

grid on;
set(gca, 'GridLineStyle', ':', ...
    'GridColor', 'k', 'GridAlpha', 0.2);

xlabel(xaxis_name);
ylabel(yaxis_name);

print(['./Figures/', figure_name], '-djpeg', '-r600')

end

%% call hspice from matlab
function run_sp_simulation(sp_filename)

foldername = sp_filename(1:end-3);
if ~exist(foldername, 'dir')
    mkdir(foldername)
end

get_instruction = ['hspice -i ', sp_filename, ' -o ./', foldername, '/', foldername];
system(get_instruction)
end