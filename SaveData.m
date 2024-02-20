% This file saves the the key data and plots from the simulation into a local folder stored under
% '/Results/DrivingCycle_Fault_Date'. The data saved are:
%   - Input Signals (inputSig_sync)
%   - Output Signals (outputSig_sync)
%   - States (statesSig_sync)
%   - Faults (faultSig_sync)
%   - Reference Engine Torque and Speed (Tq_eREF_sync, omega_eREF_sync)
%   - Residuals (residualSig_sync)
%
% (C) Mark Ng, 2019
% Ulster University, UK
%
%-------------------------------------------------------------------------%
%              Create folder to store simulation results
%-------------------------------------------------------------------------%
Log = PrintLog( Log, 'Saving data and plots................ ', 1, handles.outputLog );
file   = [dCycle '_' faultSig.Name{fault} '_' strrep( date,'-','' )];
folder = sprintf( 'Results/%s',file );
if not( exist( folder,'dir' ) )
    mkdir( folder );
end
scrsz = get( 0,'ScreenSize' ); scrsz = scrsz(3:4);

%-------------------------------------------------------------------------%
%                              Save plots
%-------------------------------------------------------------------------%
SavePlot( [folder '/' file '_TorquePlot'], handles.tq_plot, scrsz, 0 );
SavePlot( [folder '/' file '_FaultSigPlot'], handles.fault_plot, scrsz, 0 );

% If Simulation Mode 2 chosen from GUI
if sim_mode == 2 
    % plotTitle = sprintf( 'Original 9 Residuals for %s', faults{fault} );
    SavePlot( [folder '/' file '_Residuals'], handles.res_plot, scrsz, 1 );
    
    % Codes to plot the residual signals as well as results from fault
    % diagnosis can be placed here.
    
    % The command "SavePlot( filename, tag, scrsz, sub )" can be used to save the plots into a 
    % local directory.
    
end

%-------------------------------------------------------------------------%
%                        Save Log into text file
%-------------------------------------------------------------------------%
Log = PrintLog( Log, ' [ DONE ]', 3, handles.outputLog );
Log = PrintLog( Log, sprintf( 'End of sequence.' ), 2, handles.outputLog );
Log = PrintLog( Log, sprintf( 'Total simulation time: %.1f seconds.', toc ), 2, handles.outputLog );
Log = PrintLog( Log, sprintf( ' ' ), 2, handles.outputLog );
Log = PrintLog( Log, '------------------------------------------------', 1, handles.outputLog );
fid = fopen( [folder '/' file '_Log.txt'],'w' );

for ii = 1:size( Log,1 )
    fprintf( fid, '%s\n', Log(ii,:) );
end
fclose( fid );

%-------------------------------------------------------------------------%
%                     Clear non-essential variables
%-------------------------------------------------------------------------%
evalin( 'base','clearvars -except inputSig_sync outputSig_sync statesSig_sync faultSig_sync omega_eREF_sync Tq_eREF_sync residualSig_sync' );

%-------------------------------------------------------------------------%
%                      Save data to .mat file
%-------------------------------------------------------------------------%
evalin( 'base', ['save ' folder '/' file '_data.mat'] );

%-------------------------------------------------------------------------%


%-------------------------------------------------------------------------%
%                        Save Output data into text file
%-------------------------------------------------------------------------%

%fid3 = fopen( [folder '/' file '_Tq_eREFdata.txt'],'w' );
%
%for ii = 1:size( Tq_eREF.Time,1 )
%   fprintf( fid3, '%\n', Tq_eREF.Data(ii,:));
%end
%fclose( fid3 );


fid3 = fopen([folder '/' file '_Tq_eREFdata.txt'], 'w');

for ii = 1:size(Tq_eREF.Time, 1)
    fprintf(fid3, '%f\n', Tq_eREF.Data(ii,:));
end

fclose(fid3);


fid4 = fopen([folder '/' file '_outputdata.txt'], 'w');

for ii = 1:size(outputSig.Time, 1)
    fprintf(fid4, '%f\n', outputSig.Data(ii,:));
end

fclose(fid4);

% statesSig


fid5 = fopen([folder '/' file '_statedata.txt'], 'w');

for ii = 1:size(statesSig.Time, 1)
    fprintf(fid5, '%f\n', statesSig.Data(ii,:));
end

fclose(fid5);


fid6 = fopen([folder '/' file '_omega_eREFdata.txt'], 'w');

for ii = 1:size(omega_eREF.Time, 1)
    fprintf(fid6, '%f\n', omega_eREF.Data(ii,:));
end

fclose(fid6);
