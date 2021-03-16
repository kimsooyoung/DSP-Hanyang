Radius_H = 5;
Radius_M = 6;
Radius_S = 7;
Radius_B = 7.5;

Hour2Angle = 360 / 12;
Min2Angle = 360 / 60;
Sec2Angle = 360 / 60;
Angle2Rad = pi / 180;

Min2Sec = 6 / 60;
Hour2Min = 30 / 60;

for back_index=0:360
    line([0, Radius_B * cos((90 - back_index) * pi / 180)], [0, Radius_B * sin((90 - back_index) * pi / 180)], 'LineWidth', 5, 'Color', [1 1 1])
end

hold on
plot(7.5 * cos((0:1:360)* pi / 180), 7.5 * sin((0:1:360)* pi / 180), 'k')

axis square;
axis([-10 10 -10 10]);
axis off;

ClockHand_H = line([0, 0], [0, Radius_H], 'LineWidth', 5, 'Color', [1 0 0])
ClockHand_M = line([0, 0], [0, Radius_M], 'LineWidth', 5, 'Color', [0 0 0])
ClockHand_S = line([0, 0], [0, Radius_S], 'LineWidth', 5, 'Color', [0 0 1])

while(1)
    Time = clock;

    hour_x = Radius_H * cos((90 - mod(Time(4), 12) * Hour2Angle - Time(5) * Hour2Min) * Angle2Rad);
    hour_y = Radius_H * sin((90 - mod(Time(4), 12) * Hour2Angle - Time(5) * Hour2Min) * Angle2Rad);

    min_x = Radius_M * cos((90 - Time(5) * Min2Angle - Time(6) * Min2Sec) * Angle2Rad);
    min_y = Radius_M * sin((90 - Time(5) * Min2Angle - Time(6) * Min2Sec) * Angle2Rad);

    sec_x = Radius_S * cos((90 - Time(6) * Sec2Angle) * Angle2Rad);
    sec_y = Radius_S * sin((90 - Time(6) * Sec2Angle) * Angle2Rad);

    set(ClockHand_H, 'XData', [0, hour_x], 'YData', [0, hour_y]);
    set(ClockHand_M, 'XData', [0, min_x], 'YData', [0, min_y]);
    set(ClockHand_S, 'XData', [0, sec_x], 'YData', [0, sec_y]);

    drawnow;
end