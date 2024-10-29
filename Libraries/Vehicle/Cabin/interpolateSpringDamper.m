function F = interpolateSpringDamper(LUT, dx) 
    dx_LUT = LUT(:,1);
    y_LUT  = LUT(:,2);

    % Divide the table in 1000 elements
    dx_interpol = linspace(min(dx_LUT),max(dx_LUT),1000);        
    F_interpolatet = interp1(dx_LUT,y_LUT,dx_interpol);

    % Find Element nearest to the current dx
    [~,index] = (min(abs(dx_interpol - dx)));

    % Corresponding force
    F = F_interpolatet(index);    

    F = interp1(dx_LUT,y_LUT,dx,'linear');

    if isnan(F)
       F = interp1(dx_LUT,y_LUT,dx,'nearest','extrap');
    end

    if isnan(F)
        disp(i)
    end
end