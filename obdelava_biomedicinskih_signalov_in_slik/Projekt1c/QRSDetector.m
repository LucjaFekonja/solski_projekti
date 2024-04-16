function crossings = QRSDetector(filename, Fs)

signal = load(filename);
x1 = signal.val(1,:);
x2 = signal.val(2,:);

y = signal_conditioner(x1, x2);
crossings_main = main_detector(y, Fs);

e = energy_collector(y, Fs);
crossings_secondary = secondary_detector(e, Fs);

crossings = crossings_main;
for i = 1:length(crossings_secondary)
    e = crossings_secondary(i);
    absDifferences = abs(crossings_main - e);
       
    % Check if there is no value in array1 with absolute difference less
    % than 2*Fs/5
    if all(absDifferences >= 2 * Fs / 5)
        crossings(end + 1) = e;
    end
end
   
crossings = sort(crossings);
end