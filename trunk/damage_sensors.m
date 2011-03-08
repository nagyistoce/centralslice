function damage_radon = damage_sensors(Radon, damage_ratio)
damage_radon = Radon;  %copy the Radon image

if(damage_ratio ~= 0) % use this function only when necessary

[numb_sensor scan_angle] = size(Radon); %find the size of the Radon image
total_damage = round((numb_sensor - 1)*damage_ratio) + 1; %total number of sensor damage

sensor_index = round(1 + (numb_sensor-1).*rand(1, total_damage)); 
damage_radon(sensor_index,:) = 0; %specify which sensors need to be nullified

end
