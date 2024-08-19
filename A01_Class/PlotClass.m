classdef PlotClass < handle

    properties (Access = private)
        X
        Y
        Ux
        Uy
        smin
        smax
    end

    properties (Access = private)
        NumDOFNode
        x
        Tn
        u
        sig
        scale
        units
    end
    
    methods (Access = public)

        function plot2DBars(obj, data, x, Tn, u, sig, scale, units)
            obj.Init(data, x, Tn, u, sig, scale, units);
            obj.Plotsettings();
            obj.ColobarLabelsSettings();
   
        end

    end


    methods (Access = private)

        function Init(obj, data, x, Tn, u, sig, scale, units)
            obj.NumDOFNode = data.NumDOFNode;
            obj.x = x; 
            obj.Tn = Tn;
            obj.u = u;
            obj.sig = sig;
            obj.scale = scale;
            obj.units = units;
            obj.X = obj.x(:,1);
            obj.Y = obj.x(:,2);
            obj.Ux = obj.scale*obj.u(1:obj.NumDOFNode:end,1);
            obj.Uy = obj.scale*obj.u(2:obj.NumDOFNode:end,1);
            obj.smin = min(obj.sig);
            obj.smax = max(obj.sig);
        end

        function Plotsettings(obj)
            % Open plot window
            figure; box on; hold on; axis equal;
            % Plot undeformed structure
            plot(obj.X(obj.Tn'),obj.Y(obj.Tn'),'-', ...
                'Color',0.85*[1,1,1],'LineWidth',1);
            % Plot deformed structure with colorbar for stresses 
            patch(obj.X(obj.Tn')+obj.Ux(obj.Tn'),obj.Y(obj.Tn')+obj.Uy(obj.Tn'),[obj.sig';obj.sig'], ...
                'EdgeColor','interp','LineWidth',2);  
        end

        function ColobarLabelsSettings(obj)
            % Colorbar settings
            clims = get(gca,'clim');
            clim(max(abs(clims))*[-1,1]);
            n = 128; % Number of rows
            c1 = 2/3; % Blue
            c2 = 0; % Red
            s = 0.85; % Saturation
            c = hsv2rgb([c1*ones(1,n),c2*ones(1,n);1:-1/(n-1):0,1/n:1/n:1;s*ones(1,2*n)]');
            colormap(c); 
            cb = colorbar;
            
            % Add labels
            title(sprintf('scale = %g (\\sigma_{min} = %.3g %s | \\sigma_{max} = %.3g %s)',obj.scale,obj.smin,obj.units,obj.smax,obj.units)); 
            xlabel('x (m)'); 
            ylabel('y (m)');
            cb.Label.String = sprintf('Stress (%s)',obj.units); 
        end

       

    end
    
end