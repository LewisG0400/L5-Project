%\begin{table}[]
%\caption{\label{}} 
%\begin{center}
%\begin{tabular}{llllll}
%\br
%Result \# & J1       & J2     & J3    & Jd     & Chi Squared \\
%\mr
%1 & -3.9935 & 0.062289 & 1.5049 & 0.38967 & 0.1705 \\
%2 & -4.4376 & 3.9685 & -2.6920 & -2.8203 & 0.1741 \\
%3 & -3.4866 & 1.5994 & -0.29691 & -1.1644 & 0.1752 \\
%4 & -3.3707 & 1.0578 & -0.40095 & -0.34891 & 0.1940 \\
%5 & -4.3036 & 2.097 & -0.28347 & -1.5210 & 0.1963 \\
%6 & -3.5227 & -0.42463 & 1.7568 & 0.63953 & 0.1983 \\
%7 & -3.9199 & 0.10225 & 0.50286 & 0.92911 & 0.2067 \\
%8 & -3.5034 & 0.043765 & -0.21245 & 1.1597 & 0.2077 \\
%9 & -3.4234 & 0.11253 & -0.11532 & 0.94448 & 0.21154 \\
%10 & -3.9038 & 0.0907 & -0.2465 & 1.3152 & 0.2232 \\
%\br
%\end{tabular}
%\end{center}
%\end{table}

function print_top10_as_latex_table(top10, columnNames)
    disp("\begin{table}[]")
    disp("\caption{\label{}}}")
    disp("\begin{center}")
    disp("\begin{tabular}")
    disp("\begin{tabular}{" + repmat('l', 1, size(top10(1).exchangeInteractions, 1) + 3) + "}")
    disp("\br")
    %disp("Result \# & J1 & J2 & J3 & Jd & Chi Squared")
    disp(columnNames)
    disp("\mr")
    for i = 1:size(top10, 2)
        exchangesStrings = join(arrayfun(@(exchange) num2str(exchange, 4), top10(i).exchangeInteractions, 'uniformOutput', false), ' & ');
        %disp(char(exchangesStrings))
        %disp(size(char(exchangesStrings)))
        disp(num2str(i) + "&" + string(exchangesStrings) + " & " + num2str(top10(i).getChiSquared(), 4) + " & " + num2str(top10(i).getWeissTemperature()) + "\\")
    end
    disp("\br")
    disp("\end{tabular}")
    disp("\end{center}")
    disp("\end{table}")
end