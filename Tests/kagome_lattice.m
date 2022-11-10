kagome = spinw;
kagome.genlattice('lat_const',[6 6 10],'angled',[90 90 120],'spgr','P -3')
kagome.addatom('r',[1/2 0 0],'S', 1,'label','MCu1','color','orange')
plot(kagome,'range',[10 10 1])

kagome.gencoupling('maxdistance', 7)

% Set up exchange interactions over the lattice.
kagome.addmatrix('label','J1','value',1,'color','black')
kagome.addcoupling('mat','J1','bond',1)
%kagome.addcoupling('mat','J2','bond',2)
%kagome.addcoupling('mat','Jd','bond',4)

plot(kagome, 'range', [20 20 1])