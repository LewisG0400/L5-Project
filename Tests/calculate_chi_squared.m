AFkagome = spinw;
AFkagome.genlattice('lat_const',[6 6 10],'angled',[90 90 120],'spgr','P -3')
AFkagome.addatom('r',[1/2 0 0],'S', 1,'label','MCu1','color','r')
plot(AFkagome,'range',[2 2 1])

AFkagome.gencoupling('maxDistance',7)
disp('Bonds:')
AFkagome.table('bond',[])

AFkagome.addmatrix('label','J1','value',1.00,'color','r')
AFkagome.addmatrix('label','J2','value',0.11,'color','g')
AFkagome.addcoupling('mat','J1','bond',1)
AFkagome.addcoupling('mat','J2','bond',2)
plot(AFkagome,'range',[3 3 1])

S0 = [1 -2 1; 2 -1 -1; 0 0 0];
AFkagome.genmagstr('mode','direct','k',[0 0 0],'n',[0 0 1],'unit','lu','S',S0);
disp('Magnetic structure:')
AFkagome.table('mag')
AFkagome.energy

plot(AFkagome,'range',[3 3 1])

afkPow = AFkagome.powspec(linspace(0,2.5,150),'Evect',linspace(0,3,250),...
    'nRand',1e3,'hermit',false,'imagChk',false);

figure
sw_plotspec(afkPow,'axLim',[0 0.2])

[first_index_in_range, last_index_in_range] = get_index_range(1.0, 0.1, afkPow.hklA);

calculate_chi_squared_value(first_index_in_range, last_index_in_range, afkPow.swConv);

function [first_index, last_index] = get_index_range(Q_centre, Q_range, Q_data)
    first_index_t = 1;
    last_index = 1;

    Q_min = Q_centre - Q_range;
    for i = 1:size(Q_data, 2)
        if Q_data(i) >= Q_min
            first_index_t = i;
            break;
        end
    end

    Q_max = Q_centre + Q_range;
    for i = first_index_t:size(Q_data, 2)
        if Q_data(i) >= Q_max
            last_index = i;
            break;
        end
    end

    first_index = first_index_t;
end

function chi_squared = calculate_chi_squared_value(first_index, last_index, data)
    sliced_data = data(:, first_index:last_index);
    total_energies = sum(sliced_data, 2);

    figure
    plot(total_energies)

    chi_squared = sum(total_energies);
end