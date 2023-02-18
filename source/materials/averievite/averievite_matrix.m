averieviteData = readmatrix("data\Cu5E20T01.txt");
[averieviteIntensities, avierieviteErrors, avQ, avE] = create_averievite_data(averieviteData);

figure
surf(avQ, avE(200:end), averieviteMat(200:end, :), averieviteMat(200:end, :))