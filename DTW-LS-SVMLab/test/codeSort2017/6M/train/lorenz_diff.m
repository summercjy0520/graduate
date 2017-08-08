function dydt = lorenz_diff(t,y)
dydt = [ -10*(y(1)-y(2));
          30*y(1)-y(1)*y(3)-y(2)
          -8/3*y(3)+y(1)*y(2)];  
end