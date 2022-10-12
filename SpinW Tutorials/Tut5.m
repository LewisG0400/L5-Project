FMkagome = spinw;
FMkagome.genlattice('lat_const', [6 6 5], 'angled', [90 90 120], 'spgr', 'P -3')
FMkagome.addatom('r', [1/2 0 0], 'S', 1, 'label', 'MCu1', 'color', 'r')
disp('Magnetic atom position:')
FMkagome.table('matom')
plot(FMkagome, 'range', [2 2 1], 'atomColor', 'gold')

FMkagome.gencoupling('maxDistance', 4)
disp('Bonds (length in Amstrom):')
FMkagome.table('bond', [])

FMkagome.addmatrix('label', 'J1', 'value', -1, 'color', 'orange')
FMkagome.addcoupling('mat', 'J1', 'bond', 1)

plot(FMkagome,'range',[31 32 2],'unit','xyz','cellMode','single')

FMkagome.genmagstr('mode', 'helical', 'k', [0 0 0], 'n', [0 1 0], 'S', [0 1 0]')
disp('Magnetic structure:')
FMkagome.table('mag')
FMkagome.energy
plot(FMkagome,'range',[2 2 1])

fmkSpec = FMkagome.spinwave({[-1/2 0 0] [0 0 0] [1/2 1/2 0] 100},'hermit',false);
fmkSpec = sw_neutron(fmkSpec);
fmkSpec = sw_egrid(fmkSpec, 'Evect',linspace(0,6.5,100),'component','Sperp');
figure
sw_plotspec(fmkSpec,'mode',1,'colorbar',false,'axLim',[0 8])