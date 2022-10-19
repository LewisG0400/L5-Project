AFkagome = spinw;
AFkagome.genlattice('lat_const',[6 6 10],'angled',[90 90 120],'spgr','P -3')
AFkagome.addatom('r',[1/2 0 0],'S', 1,'label','MCu1','color','r')
plot(AFkagome,'range',[2 2 1])

AFkagome.gencoupling('maxDistance',7)
disp('Bonds:')
AFkagome.table('bond',[])

AFkagome.addmatrix('label','J1','value',-3.8,'color','r')
AFkagome.addmatrix('label','J2','value',0,'color','g')
AFkagome.addmatrix('label','Jd','value',1.1,'color','b')
AFkagome.addcoupling('mat','J1','bond',1)
AFkagome.addcoupling('mat','J2','bond',2)
AFkagome.addcoupling('mat','Jd','bond',4)
plot(AFkagome,'range',[3 3 1])

mgIR=[  1   1   1
        0   0   0
        0   0   0];
AFkagome.genmagstr('mode','direct','nExt',[1 1 1],'unit','lu','n',[0 0 1],'S',mgIR,'k',[0 0 0]);
disp('Magnetic structure:')
AFkagome.table('mag')
AFkagome.energy

plot(AFkagome,'range',[3 3 1])

afkPow = AFkagome.powspec([0.15:0.01:2.41] ,'Evect',linspace(0,3,250),...
    'nRand',1e3,'hermit',true,'imagChk',false);

figure
sw_plotspec(afkPow,'axLim',[0 0.2])

experimental_data = readmatrix("../data/Haydeeite-Tsub-chiqw.dat");

[experimental_data_matrix, Q_buckets, E_buckets] = create_data_matrix(experimental_data, 150);

figure
surf(Q_buckets, E_buckets, experimental_data_matrix, experimental_data_matrix)
title("Experimental Data")
xlabel("Q (Å)")
ylabel("E (meV)")
zlabel("S(Q, ω)")
%set(gca, 'zscale', 'log')

total_energy_list_experimental = get_energy_slices(Q_buckets, experimental_data_matrix)
total_energy_list_theory = get_energy_slices(afkPow.hklA, afkPow.swConv);

scale_factor = max(total_energy_list_experimental) / max(total_energy_list_theory)
total_energy_list_theory = total_energy_list_theory * scale_factor

figure
subplot(2, 1, 1)
plot(total_energy_list_experimental)
title("Total energy for Q (experimental data)")
xlabel("Q +/- 0.1 (Å)")
ylabel("Total Energy (meV)")
subplot(2, 1, 2)
plot(total_energy_list_theory)
title("Total energy for Q (theoretical data)")
xlabel("Q +/- 0.1 (Å)")
ylabel("Total Energy (meV)")

chi_squared = calculate_chi_squared(total_energy_list_experimental, total_energy_list_theory)