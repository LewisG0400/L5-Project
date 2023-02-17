function save_figs(filePrefix, folder)
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
      FigHandle = FigList(iFig);
      set(0, 'CurrentFigure', FigHandle);
      savefig(fullfile(folder, filePrefix + num2str(iFig) + '.fig'));
    end
end