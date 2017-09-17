%% Speed Time
if plot_speed_win
    figure(h_st_w);
    hold on
    scatter(min_data_win,speed_data_win)
    title('Wind Speed Vs. Time')
    ylabel('Wind Speed [m/s]')
    xlabel('Minutes Elapsed in Day')
    hold off
end

%% Heading Time
if plot_dir_win
    figure(h_ht_w);
    hold on
    scatter(min_data_win,dir_data_win)
    title('Wind Direction Vs. Minutes Elapsed')
    ylabel('Wind Direction [deg]')
    xlabel('Minutes Elapsed in Day')
    hold off
end

%% Speed PDF
if plot_speed_pdf_win
    figure(h_s_w);
    hold on
    
    % histogram
    stem(x_hist_speed,y_hist_speed);

    % weibull pdf
    plot(x_fit,y_fit,'r')
    
    title('Green Building Wind Speed PDF')
    ylabel('Probability')
    xlabel('Wind Speed [m/s]')
    legend('data','wbl-fit')
    axis([0,speed_max,0,max(y_hist_speed)+0.02])
    hold off
end

%% Heading PDF
if plot_dir_pdf_win
    figure(h_h_win);
    hold on
    
    % histogram
    stem(x_hist_dir,y_hist_dir);
    
    % gaussian fi
    plot(x_gauss_dir,1/heading_bins*ones(1,length(y_gauss_dir)),'r')
    
    title('Green Building Wind Heading PDF')
    ylabel('Probability')
    xlabel('Wind Heading [deg]')
    legend('data','uni-ideal')
    axis([0,360,0,max(y_hist_dir)])
    hold off
end

%% X Velocity PDF
if plot_u_pdf_win
    figure(h_u_w);
    hold on
    
    % histogram
    stem(x_hist_u,y_hist_u);
    
    % gaussian fi
    plot(x_gauss_u,y_gauss_u,'r')
    
    title('Green Building X-Velocity PDF')
    ylabel('Probability')
    xlabel('X Velocity [m/s]')
    legend('data','gauss-fit')
    axis([-max(abs(x_hist_u)),max(abs(x_hist_u)),0,max(y_hist_u)])
    hold off
end

%% Y Velocity PDF
if plot_v_pdf_win
    figure(h_v_w);
    hold on
    
    % histogram
    stem(x_hist_v,y_hist_v)
    
    % gaussian fit
    plot(x_gauss_v,y_gauss_v,'r')
    
    title('Green Building Y-Velocity PDF')
    ylabel('Probability')
    xlabel('Y Velocity [m/s]')
    legend('data','gauss-fit')
    axis([-max(abs(x_hist_v)),max(abs(x_hist_v)),0,max(y_hist_v)])
    hold off
end

%% XY Velocity PDF
if plot_uv_pdf_win
    figure(h_uv_w);
    hold on
    view(3)
    
    % histogram
    stem3(x_hist_uv1,x_hist_uv2,y_hist_uv,'b*')
    
    % gaussian fit
    surface(x1,x2,F)
    alpha(0.5)
    colormap(gray)
    
    title('U and V Joint PDF (Heading)')
    ylabel('<-- South  North -->')
    xlabel('<-- West East -->')
    hold off
end

%% Unscented Transform
if plot_ut_win
    % plot u sigma points
    if plot_u_pdf_win
        y_gauss_us = normpdf(m(:,1)',u_mean_ut,u_std_ut);

        figure(h_u_w)
        hold on
        scatter(m(:,1)',y_gauss_us,'g*')
        hold off
    end

    % plot v sigma points
    if plot_v_pdf_win
        y_gauss_vs = normpdf(m(:,2)',v_mean_ut,v_std_ut);

        figure(h_v_w)
        hold on
        scatter(m(:,2)',y_gauss_vs,'g*')
        hold off
    end

    % plot uv sigma points
    if plot_uv_pdf_win
        z_gauss_uvs = mvnpdf(m,uv_mean_ut',uv_cov_ut);

        figure(h_uv_w)
        hold on
        scatter3(m(:,1)',m(:,2)',z_gauss_uvs,'g*')
        hold off
    end
end