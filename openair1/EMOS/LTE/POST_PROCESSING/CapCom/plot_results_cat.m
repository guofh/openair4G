%plot_results_cat

%clear all;
close all;
%clc;

%load '/homes/latif/test_devel/openair1/EMOS/LTE/POST_PROCESSING/CapCom/Parcour2_Part2_Results/results_UE.mat';

%%
mm=imread('cordes.png');
in = 0;

plotwrtdistanceCalc;


%% plot K-factor
plot_gps_coordinates(mm, [gps_data_cat.longitude], [gps_data_cat.latitude], K_fac_cat);

%% set throughput to 0 when UE was not connected
UE_connected = all(reshape([minestimates.UE_mode]==3,100,[]),1);
nn = fieldnames(throughput);
for n = 1:length(nn)
    eval([nn{n} '_cat(~UE_connected) = 0;']);
end

%% get real throughput from modem
dlsch_error = double([1 diff([minestimates_cat.dlsch_errors])]);
rateps_modem = (1-dlsch_error) .* double([minestimates_cat.tbs]);
rateps_modem([minestimates.UE_mode]~=3) = 0;
rateps_modem = sum(reshape(rateps_modem,100,[]),1)*6;


%% plot as CDFs
in = in+1;    
h_fig = figure(in);
colors = {'b','g','r','c','m','y','k','b--','g--','r--','c--','m--','y--','k--'};
legend_str = {};
ni=1;
for n = 1:length(nn)
    hold on
    si = strfind(nn{n},'64Qam');
    if si
        eval(['[f,x] = ecdf(' nn{n} '_cat);']);
        plot(x,f,colors{ni},'Linewidth',2);
        legend_tmp = nn{n};
        legend_tmp(si:si+10) = [];
        legend_str{ni} = legend_tmp;
        ni=ni+1;
    end
end
[f,x] = ecdf(rateps_modem);
plot(x,f,colors{ni},'Linewidth',2);
legend_str{ni} = 'rateps_modem';
ni=ni+1;


legend(legend_str,'Interpreter','none','Location','SouthOutside');
xlabel('Throughput [bps]')
ylabel('P(x<abscissa)')
grid on



%% plot as a function of the speed of the UE (histogram)

in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 1stRX');
xlabel('Speed[Meters/Second]');
ylabel('Throughput[Bits/sec]');
hold on;
plot([gps_data_cat.speed], rateps_SISO_64Qam_eNB1_1stRx_cat,  'bx');
plot([gps_data_cat.speed], rateps_alamouti_64Qam_eNB1_1stRx_cat,'go');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')

in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2ndRX');
xlabel('Speed[Meters/Second]');
ylabel('Throughput[Bits/sec]');
hold on;
plot([gps_data_cat.speed], rateps_SISO_64Qam_eNB1_2ndRx_cat,  'bx');
plot([gps_data_cat.speed], rateps_alamouti_64Qam_eNB1_2ndRx_cat,'go');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')


in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2RX');
xlabel('Speed[Meters/Second]');
ylabel('Throughput[Bits/sec]');
hold on;
plot([gps_data_cat.speed], rateps_SISO_64Qam_eNB1_2Rx_cat,  'bx');
plot([gps_data_cat.speed], rateps_alamouti_64Qam_eNB1_2Rx_cat,'go');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_2Rx_maxq_cat,'rd');
plot([gps_data_cat.speed], rateps_beamforming_64Qam_eNB1_2Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')


%% plot on map

in = in+1;    
h_fig = figure(in);
[gps_x, gps_y] = plot_gps_coordinates(mm, [gps_data_cat.longitude], [gps_data_cat.latitude], rateps_SISO_64Qam_eNB1_2Rx_cat);
title('SISO Throughput (2Rx)');
in = in+1;    
h_fig = figure(in);
[gps_x, gps_y] = plot_gps_coordinates(mm, [gps_data_cat.longitude], [gps_data_cat.latitude], rateps_alamouti_64Qam_eNB1_2Rx_cat);
title('Alamouti Througput (2Rx)');
in = in+1;    
h_fig = figure(in);
[gps_x, gps_y] = plot_gps_coordinates(mm, [gps_data_cat.longitude], [gps_data_cat.latitude], rateps_beamforming_64Qam_eNB1_2Rx_maxq_cat);
title('optimal Beamforming (2Rx)');
in = in+1;    
h_fig = figure(in);
[gps_x, gps_y] = plot_gps_coordinates(mm, [gps_data_cat.longitude], [gps_data_cat.latitude], rateps_beamforming_64Qam_eNB1_2Rx_feedbackq_cat);
title('Beamforming using feedback (2Rx)');


%% plot as a function of time
in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 1stRX');
xlabel('Time[Seconds]');
ylabel('Throughput[Bits/sec]');
hold on;
plot(rateps_SISO_64Qam_eNB1_1stRx_cat,  'bx');
plot(rateps_alamouti_64Qam_eNB1_1stRx_cat,'go');
plot(rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot(rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')

in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2ndRX');
xlabel('Time[Seconds]');
ylabel('Throughput[Bits/sec]');
hold on;
plot(rateps_SISO_64Qam_eNB1_2ndRx_cat,  'bx');
plot(rateps_alamouti_64Qam_eNB1_2ndRx_cat,'go');
plot(rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot(rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')


in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2RX');
xlabel('Time[Seconds]');
ylabel('Throughput[Bits/sec]');
hold on;
plot(rateps_SISO_64Qam_eNB1_2Rx_cat,  'bx');
plot(rateps_alamouti_64Qam_eNB1_2Rx_cat,'go');
plot(rateps_beamforming_64Qam_eNB1_2Rx_maxq_cat,'rd');
plot(rateps_beamforming_64Qam_eNB1_2Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')


%% plot as a function of distance from BS (histogram)

in = in+1;
h_fig = figure(in);
title('Effective Throughputs for 1stRX');
xlabel('Distance from BS [Km]');
ylabel('Throughput [Bits/sec]');
hold on;
plot(dist,rateps_SISO_64Qam_eNB1_1stRx_cat,  'bx');
plot(dist,rateps_alamouti_64Qam_eNB1_1stRx_cat,'go');
plot(dist,rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot(dist,rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')

in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2ndRX');
xlabel('Distance from BS [Km]');
ylabel('Throughput[Bits/sec]');
hold on;
plot(dist,rateps_SISO_64Qam_eNB1_2ndRx_cat,  'bx');
plot(dist,rateps_alamouti_64Qam_eNB1_2ndRx_cat,'go');
plot(dist,rateps_beamforming_64Qam_eNB1_1Rx_maxq_cat,'rd');
plot(dist,rateps_beamforming_64Qam_eNB1_1Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')


in = in+1;    
h_fig = figure(in);
title('Effective Throughputs for 2RX');
xlabel('Distance from BS [Km]');
ylabel('Throughput[Bits/sec]');
hold on;
plot(dist,rateps_SISO_64Qam_eNB1_2Rx_cat,  'bx');
plot(dist,rateps_alamouti_64Qam_eNB1_2Rx_cat,'go');
plot(dist,rateps_beamforming_64Qam_eNB1_2Rx_maxq_cat,'rd');
plot(dist,rateps_beamforming_64Qam_eNB1_2Rx_feedbackq_cat,'c*');
legend('SISO','Alamouti','Optimal Beamforming', 'Beamforming with feedback')
 
%%
% in = in+1;
% h_fig = figure(in);
% title('Throughput SISO _ distance Travelled ')
% xlabel('Distance travelled [Km]')
% ylabel('Throughput [Bits/sec]')
% plot(dist_travelled, rps_SISO_4Qam_eNB1_cat,'bx');
% hold on
% plot(dist_travelled, rps_SISO_16Qam_eNB1_cat,'go' );
% plot(dist_travelled, rps_SISO_64Qam_eNB1_cat,'rd');
% 
% legend('QPSK','16QAM','64QAM')

%%
% in = in+1;    
% h_fig = figure(in);
% title('Alamouti');
% xlabel('Time[Seconds]');
% ylabel('Throughput');
% hold on;
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_SISO_16Qam_eNB1_cat,'bo');
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_Alamouti_16Qam_eNB1_cat,'rd');
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_Beamforming_16Qam_eNB1_maxq_cat,'go');
% hold off;
% legend('SISO','ALAM','BMFR')


%%
% in = in+1;    
% h_fig = figure(in);
% title(['Alamouti']);
% xlabel('Time[Seconds]');
% ylabel('Throughput');
% hold on;
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_SISO_4Qam_eNB1_cat,'bx');
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_SISO_16Qam_eNB1_cat,'go');
% plot(round(double(timestamp_cat(1:100:end))/1e9),rps_SISO_64Qam_eNB1_cat,'rd');
% hold off;
% legend('QPSK','16QAM','64QAM')
% 
% in = in+1;
% h_fig = figure(in);
% title('Throughput SISO _ distance from BS ');
% xlabel('Distance from BS [Km]');
% ylabel('Throughput [Bits/sec]');
% %dist(1:end);
% plot(dist, rps_SISO_4Qam_eNB1_cat,'bx');
% hold on;
% plot(dist, rps_SISO_16Qam_eNB1_cat,'go');
% plot(dist, rps_SISO_64Qam_eNB1_cat,'rd');
% hold off;
% legend('QPSK','16QAM','64QAM')
%  
% in = in+1;
% h_fig = figure(in);
% plot(dist_travelled, rps_SISO_4Qam_eNB1_cat,'bx');
% hold on
% plot(dist_travelled, rps_SISO_16Qam_eNB1_cat,'go' );
% plot(dist_travelled, rps_SISO_64Qam_eNB1_cat,'rd');
% title('Throughput SISO _ distance Travelled ')
% xlabel('Distance travelled [Km]')
% ylabel('Throughput [Bits/sec]')
% legend('QPSK','16QAM','64QAM')
