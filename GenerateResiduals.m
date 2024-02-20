% Simulates the Residuals Generator for the 'Original 9' residuals based on the current sensors
% setup.
%
% (C) Mark Ng, 2019
% Ulster University, UK
%
%-------------------------------------------------------------------------%
%                    Main Codes For Residuals Generation                  
%-------------------------------------------------------------------------%
Log = PrintLog( Log, 'Simulating Residuals................. ', 1, handles.outputLog );

%-------------------------------------------------------------------------%
% Open and simulate the Simulink file. Requires modification to the
% Simulink file
%-------------------------------------------------------------------------%
load_system( 'ResidualsGen' );
sim( 'ResidualsGen', max( T_z ) );
bdclose 'ResidualsGen' ;
Log = PrintLog( Log, ' [ DONE ]', 3, handles.outputLog );

%-------------------------------------------------------------------------%
% Main codes here
%-------------------------------------------------------------------------%
thr = 5;    % threshold for detection of fault
load std_Data;
for ii = 1:size( Residuals.Data,2 )
    defRes(:,ii) = ( Residuals.Data(:,ii) - mean( Residuals.Data(:,ii) ) ) / std_NF_def(ii);
end

defTime = Residuals.Time;
defRes = [defTime defRes];

assignin( 'base', 'defRes', defRes );

%-------------------------------------------------------------------------%
Log = PrintLog( Log, 'Residuals Generated.', 1, handles.outputLog );
Log = PrintLog( Log, ' ', 1, handles.outputLog );

%-------------------------------------------------------------------------%
% Run sync for time-varying vectors
%-------------------------------------------------------------------------%
load_system( 'SyncTime' );
set_param( 'SyncTime','StartTime', '1', 'StopTime', num2str( T_z(end) - 1 ) );
sim SyncTime;
bdclose SyncTime;

faultSig_sync.Name    = faultSig.Name;
inputSig_sync.Name    = inputSig.Name;
outputSig_sync.Name   = outputSig.Name;
statesSig_sync.Name   = statesSig.Name;
omega_eREF_sync.Name  = omega_eREF.Name;
Tq_eREF_sync.Name     = Tq_eREF.Name;
residualSig_sync.Name = {'rT_c' 'rp_c' 'rT_ic' 'rp_ic' 'rT_im' 'rp_im' 'rW_af' 'rTq_e' 'rp_em'};
assignin( 'base', 'residualSig_sync', residualSig_sync );
assignin( 'base', 'faultSig_sync', faultSig_sync );
assignin( 'base', 'inputSig_sync', inputSig_sync );
assignin( 'base', 'outputSig_sync', outputSig_sync );
assignin( 'base', 'statesSig_sync', statesSig_sync );
assignin( 'base', 'omega_eREF_sync', omega_eREF_sync );
assignin( 'base', 'Tq_eREF_sync', Tq_eREF_sync );

%-------------------------------------------------------------------------%
% Plot residual signals
%-------------------------------------------------------------------------%
Log   = PrintLog( Log, 'Plotting residual signals............', 1, handles.outputLog );
subplot( 1,1,1,'Parent',handles.res_plot );
ResSen = [1 1 0 1 0 0 0 0 0 0 0; 
    1 1 1 1 1 1 0 0 0 0 0; 
    0 1 0 1 0 0 0 0 0 1 0; 
    1 1 1 1 1 1 0 1 0 0 0; 
    0 1 0 1 0 1 0 0 0 0 0;
    1 1 1 1 1 1 0 0 1 0 0; 
    1 1 1 1 1 1 1 0 0 0 1;
    1 1 1 1 1 1 0 0 0 0 0;
    1 1 0 1 0 0 0 0 0 0 0];
activeFault = find( toggle == 1 ) - 1;

for ii = 1:size( residualSig_sync.Data,2 )
    subplot( 3, 3, ii );
    plotResiduals = plot( residualSig_sync.Time, residualSig_sync.Data(:,ii) );
    yl = ylim;
    hold( 'on' );
    
    if ( activeFault == 1 ) || ( activeFault == 3 ) || ( activeFault == 9 )
        patch( [200 200 residualSig_sync.Time(end) residualSig_sync.Time(end)], [yl(1) yl(2) yl(2) yl(1)], [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7],'EdgeColor', [0.7 0.7 0.7] );
    elseif ( activeFault == 6 ) || ( activeFault == 10 )
        count = 30;
        while count <= 1800
            patch( [count count (count+40) (count+40)], [yl(1) yl(2) yl(2) yl(1)], [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7],'EdgeColor', [0.7 0.7 0.7] );
            count = count + 200;
        end
    elseif ( activeFault == 2 ) || ( activeFault == 8 ) || ( activeFault == 11 )
        count = 30;
        while count <= 1800
            patch( [count count (count+30) (count+30)], [yl(1) yl(2) yl(2) yl(1)], [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7],'EdgeColor', [0.7 0.7 0.7] );
            count = count + 150;
        end
    elseif ( activeFault == 5 )     
        patch( [0.4*residualSig_sync.Time(end) 0.4*residualSig_sync.Time(end) 0.8*residualSig_sync.Time(end) 0.8*residualSig_sync.Time(end)], [yl(1) yl(2) yl(2) yl(1)], [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7],'EdgeColor', [0.7 0.7 0.7] );
    elseif ( activeFault == 4 ) || ( activeFault == 7 )
        patch( [0.4*residualSig_sync.Time(end) 0.4*residualSig_sync.Time(end) residualSig_sync.Time(end) residualSig_sync.Time(end)], [yl(1) yl(2) yl(2) yl(1)], [0.7 0.7 0.7], 'FaceColor', [0.7 0.7 0.7],'EdgeColor', [0.7 0.7 0.7] );
    end
    
    if activeFault == 0 
        plotResiduals = plot( residualSig_sync.Time, residualSig_sync.Data(:,ii), 'Color', [0, 0.4470, 0.7410], 'Linewidth', 1.8 );
    elseif ResSen(ii,activeFault) == 1 
        plotResiduals = plot( residualSig_sync.Time, residualSig_sync.Data(:,ii), 'Color', [0.6350, 0.0780, 0.1840], 'Linewidth', 1.8 );
    else
        plotResiduals = plot( residualSig_sync.Time, residualSig_sync.Data(:,ii), 'Color', [0, 0.4470, 0.7410], 'Linewidth', 1.8 );
    end
    
    plotResiduals = plot( [0 residualSig_sync.Time(end)], [thr thr], 'r--' );
    plotResiduals = plot( [0 residualSig_sync.Time(end)], [-thr -thr], 'r--' );
    grid( 'on' );
    
    if (activeFault == 0)
        axis( [0 residualSig_sync.Time(end) -10 10] );
    else
        axis( [0 residualSig_sync.Time(end) yl(1) yl(2)] );
    end
%     title( residualSig_sync.Name{ii} );
    ylabel( sprintf( 'Normalized %s', residualSig_sync.Name{ii} ) );
    xlabel( 'Time (s)' );
%     set( gca,'XTick',[] );
end

Log = PrintLog( Log, ' [ DONE ]', 3, handles.outputLog );
Log = PrintLog( Log, ' ', 1, handles.outputLog );
Log = PrintLog( Log, '------------------------------------------------', 1, handles.outputLog );
Log = PrintLog( Log, ' ', 1, handles.outputLog );

%-------------------------------------------------------------------------%

