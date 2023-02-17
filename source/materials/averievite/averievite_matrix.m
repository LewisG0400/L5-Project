averieviteData = readmatrix("data\Cu5E20T01.txt");
[averieviteMat, avQ, avE] = create_averievite_data_matrix(averieviteData, 100, 5);

figure
surf(avQ, avE, averieviteMat, averieviteMat)