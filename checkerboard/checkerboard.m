%% Plot Background

figure(1);
axes('color', [0.929 0.694 0.125]);
hold on;
for i=1:19
    plot([i-10, i-10], [9 -9] , 'color', [0, 0, 0]);
    plot([9 -9], [i-10, i-10] , 'color', [0, 0, 0]);
end

axis square;
axis([-10 10 -10 10])

%% Draw Point

r = 0.05;
for back_index=0:360
    line([0, r * cos((back_index) * pi/180)], [0, r * sin((back_index) * pi/180)], 'LineWidth', 5, 'Color', [0 0 0])
end

% plot(r*cos((0:1:360)*pi/180), r*sin((0:1:360)*pi/180), 'k')
%% Draw 9 points

points_x = [-6 0 6];
points_y = [-6 0 6];

for i=1:3
    for j=1:3
        for back_index=0:360
            line([points_x(i),points_x(i) + r * cos((back_index) * pi/180)], [points_y(j), points_y(j) + r * sin((back_index) * pi/180)], 'LineWidth', 5, 'Color', [0 0 0])
        end
    end
end 

%% Insert title
ASCII=64;
title([num2str(0),' 김수영', ' vs ', '알파고 ', num2str(3)])
for n=1:19
    text(9.5, 9-n+1, num2str(n))
    text(-9+n-1, -9.5, char(ASCII+n))
end

%% Draw Black/White Points
r_big = 0.5;

for i=0:5
    X = randi(19);
    Y = randi(19);

    for back_index=0:360
        % Draw White Points
        if rem(i, 2) == 1 
            line([X-10, X-10 + r_big * cos((back_index) * pi/180)], [Y-10, Y-10 + r_big * sin((back_index) * pi/180)], 'LineWidth', 5, 'Color', [1 1 1])
        % Draw Black Points
        else
            line([X-10, X-10 + r_big * cos((back_index) * pi/180)], [Y-10, Y-10 + r_big * sin((back_index) * pi/180)], 'LineWidth', 5, 'Color', [0 0 0])
        end
    end
end