[lattice, bondList] = averievite([-3.079521341606202,3.079521341606202,-8.515488261706102,9.117807321983395]);

%figure
%powSpec = lattice.powspec(0:0.01:2.5, 'Evect', 5:0.01:15, 'nRand', 1e3, 'hermit', true, 'imagChk', false, 'fid', 0, 'tid', 0);
%sw_plotspec(powSpec)
figure
powSpec2 = sw_instrument(powSpec, 'norm',true, 'dE',0.1, 'dQ',0.05,'Ei',25);
sw_plotspec(powSpec2)