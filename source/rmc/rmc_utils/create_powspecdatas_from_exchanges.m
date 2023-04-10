function PowSpecDatas = create_powspecdatas_from_exchanges(exchanges, experimentalIntensityList, experimentalError, runtimeParameters)
    PowSpecDatas = [PowSpecData(exchanges(:, 1), runtimeParameters)];
    for i = 1:size(exchanges, 2)
        PowSpecDatas(i) = PowSpecData(exchanges(:, i).', runtimeParameters);
        try
            PowSpecDatas(i) = PowSpecDatas(i).calculatePowderSpectrum();
        catch e
            disp(e.message);
            continue;
        end
        PowSpecDatas(i) = PowSpecDatas(i).calculateIntensityList();
        PowSpecDatas(i) = PowSpecDatas(i).calculateChiSquared(experimentalIntensityList, experimentalError);
        PowSpecDatas(i) = PowSpecDatas(i).calculateWeissTemperature(1/2);
        PowSpecDatas(i) = PowSpecDatas(i);
    end
end

