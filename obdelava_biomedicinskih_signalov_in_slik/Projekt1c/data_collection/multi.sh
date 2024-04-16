

% Run this script to evaluate the QRS detector in QRSDetect.m on all records.

% --- THE FOLLOWING SCRIPT RUNS THE EVALUATION AND PRINTS THE AGGREGATED RESULTS ---
% (see instructions on the web classroom regarding how to calculate the Se and +P)

% First remove the eval1.txt, eval2.txt, and results.txt files from the previous run.
if (isfile('eval1.txt')) delete('eval1.txt'); end
if (isfile('eval2.txt')) delete('eval2.txt'); end
if (isfile('results.txt')) delete('results.txt'); end

% For all records
for record = RECORDS
    % If the Matlab file for this record does not exist
    if (~isfile(sprintf('%sm.mat', record)))
        % Convert the record into Matlab using wfdb2mat (creates recordm.mat)
        cmd=sprintf('wfdb2mat -r %s', record);
        system(cmd);
    end

    % Delete the .asc and .qrs files from the previous run, just in case the detector
    % fails to overwrite the .asc file or if wrann fails to convert it for some reason.
    df = sprintf('%s.asc', record);
    if (isfile(df)) delete(df); end;
    df = sprintf('%s.qrs', record);
    if (isfile(df)) delete(df); end;

    % Run and evaluate the detector the this record
    Detector(record);

    % Convert the created .asc file to WFDB format using wrann
    cmd = sprintf('wrann -r %s -a qrs <%s.asc', record, record);
    system(cmd);

    % Evaluate the detector .qrs annotation against reference .atr annotations
    % and add the resulting statistics to eval1.txt and eval2.txt files.
    % Optionally, the -f 0 option forces bxb not to skip the first 5 minutes of the
    % record, although this will report a warning that can be disregarded.
    cmd = sprintf('bxb -r %s -a atr qrs -l eval1.txt eval2.txt -f 0', record);
    [status, cmdout] = system(cmd);
end

% After the run, calculate the aggregated statistics, save the results into results.txt
system('sumstats eval1.txt eval2.txt >results.txt');

% Print the results from results.txt. Note: do not use the Gross or Average
% results in the bottom two lines, you have to manually calculate Se and +P
% according to the instructions given in General notes (regarding assignments)
% available on the web classroom).
type results.txt