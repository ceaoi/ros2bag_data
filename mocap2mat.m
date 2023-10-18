% Data Parser for OptiTrack motion capture system
% Fromat Version: 1.23
% If you want to visualize the data
%   preview = true; 
clear
preview = false; 

% change filename
filename = 'optiTrack-example.csv';
data = readtable(filename);

%% 读取和保存
if data{1,2}==1.23
    timeStart = data{1,12};
    dateStr = timeStart;
    dt = datetime(dateStr, 'InputFormat', 'yyyy-MM-dd hh.mm.ss.SSS a');
    unixTime = posixtime(dt);
    disp(['数据的Linux时间为: ' num2str(unixTime) ' 秒']);
    
    trace = table();
    trace.time = data{7:end,2}+unixTime;
    trace.qx = data{7:end,3};
    trace.qy = data{7:end,4};
    trace.qz = data{7:end,5};
    trace.qw = data{7:end,6};
    trace.x = data{7:end,7};
    trace.y = data{7:end,8};
    trace.z = data{7:end,9};

    save(filename(1:end-4)+".mat","trace",'-mat');
end

%% 预览轨迹和姿态

if preview
    figure(1)
    plot3(trace.x,trace.y,trace.z);
    axis equal
    
    figure(2)
    plot(trace.z);
    
    figure(3)
    plot(trace.x,trace.y);
    xlabel("X (m)");
    ylabel("Y (m)");
    axis equal;
    
    q = quaternion(trace.qx,trace.qy,trace.qz,trace.qw);
    eul = quat2eul(q, 'ZYX');
    
    figure(4)
    plot(trace.time, eul(:,1));
    
    figure(5)
    plot(trace.time, eul(:,2));
    
    figure(6)
    plot(trace.time, eul(:,3));
end
