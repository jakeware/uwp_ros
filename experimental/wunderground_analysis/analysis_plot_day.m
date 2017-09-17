%% Speed Time
if plot_time_day
    % speed
    figure(h_t_d);
    subplot(2,1,1)
    hold on
    title('Wind Speed and Heading Vs. Time')
    ylabel('Wind Speed [m/s]')
    xlabel('Minutes Elapsed in Day [min]')
    plot(min_data_day,speed_data_day)
    hold off

    % direction
    subplot(2,1,2)
    hold on
    ylabel('Wind Heading [deg]')
    xlabel('Minutes Elapsed in Day')
    scatter(min_data_day,dir_data_day,'.')
    set(gca,'YLim',[0 360])
    set(gca,'YTick',[0,90,180,270,360])
    set(gca,'YTickLabel',{'0 - N','90 - E','180 - S','270 - W','360 - N'})
    hold off
end

%% Speed PDF
if plot_speed_pdf_day
    figure(h_s_d);
    hold on
    
    % histogram
    stem(x_hist_speed_day,y_hist_speed_day);

    % weibull pdf
    plot(x_fit_day,y_fit_day,'r')
    
    title('Wind Speed PDF')
    ylabel('Probability')
    xlabel('Wind Speed [m/s]')
    hold off
end

%% Heading PDF
if plot_dir_pdf_day
    figure(h_h_d);
    hold on
    
    % histogram
    stem(x_hist_dir_day,y_hist_dir_day);
    
    % gaussian fi
    plot(x_gauss_dir_day,y_gauss_dir_day,'r')
    
    title('Wind Heading PDF')
    ylabel('Probability')
    xlabel('Wind Heading [deg]')
    hold off
end

%% X Velocity PDF
if plot_u_pdf_day
    figure(h_u_d);
    hold on
    
    % histogram
    stem(x_hist_u_day,y_hist_u_day);
    
    % gaussian fi
    plot(x_gauss_u_day,y_gauss_u_day,'r')
    
    title('X Velocity PDF')
    ylabel('Probability')
    xlabel('X Velocity [m/s]')
    hold off
end

%% Y Velocity PDF
if plot_v_pdf_day
    figure(h_v_d);
    hold on
    
    % histogram
    stem(x_hist_v_day,y_hist_v_day)
    
    % gaussian fit
    plot(x_gauss_v_day,y_gauss_v_day,'r')
    
    title('Y Velocity PDF')
    ylabel('Probability')
    xlabel('Y Velocity [m/s]')
    hold off
end

%% XY Velocity PDF
if plot_uv_pdf_day
    figure(h_uv_d);
    hold on
    view(3)
    
    % histogram
    stem3(x_hist_uv1_day,x_hist_uv2_day,y_hist_uv_day,'b*')
    
    % gaussian fit
    surface(x1_day,x2_day,F_day)
    alpha(0.5)
    colormap(gray)
    
    title('U and V Joint PDF (Heading)')
    ylabel('<-- South  North -->')
    xlabel('<-- West East -->')
    hold off
end

%% Unscented Transform
if plot_ut_day
    % plot u sigma points
    if plot_u_pdf_day
        y_gauss_us = normpdf(m(:,1)',u_mean_ut,u_std_ut);

        figure(h_u_d)
        hold on
        scatter(m(:,1)',y_gauss_us,'g*')
        hold off
    end

    % plot v sigma points
    if plot_v_pdf_day
        y_gauss_vs = normpdf(m(:,2)',v_mean_ut,v_std_ut);

        figure(h_v_d)
        hold on
        scatter(m(:,2)',y_gauss_vs,'g*')
        hold off
    end

    % plot uv sigma points
    if plot_uv_pdf_day
        z_gauss_uvs = mvnpdf(m,uv_mean_ut',uv_cov_ut);

        figure(h_uv_d)
        hold on
        scatter3(m(:,1)',m(:,2)',z_gauss_uvs,'g*')
        hold off
    end
end