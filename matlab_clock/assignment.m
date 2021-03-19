figure(1);
Time = clock;

subplot(2, 3, 1)
axis square;
axis off;
colckTitle1 = text(0, 0, [num2str(Time(4)) '시'], 'FontSize', 60);

subplot(2, 3, 2)
axis square;
axis off;
title([num2str(Time(1)) ' ' num2str(Time(2)) ' ' num2str(Time(3)) ' ' ])

colckTitle2 = text(0, 0, [num2str(Time(5)) '분'], 'FontSize', 60);

subplot(2, 3, 3)
axis square;
axis off;
colckTitle3 = text(0, 0, [num2str(floor(Time(6))) '초'], 'FontSize', 60);

subplot(2, 3, 4)
axis square;
axis off;

subplot(2, 3, 5)
Radius_H = 5;
Radius_M = 6;
Radius_S = 7;
Radius_B = 7.5;

Big_clock_Rad = 7.5;
Small_clock_Rad = 2;
Small_clock_X = 3.5;

Hour2Angle = 360 / 12;
Min2Angle = 360 / 60;
Sec2Angle = 360 / 60;
Angle2Rad = pi / 180;

Min2Sec = 6 / 60;
Hour2Min = 30 / 60;

for back_index=0:360
    line([0, Radius_B * cos((90 - back_index) * pi / 180)], [0, Radius_B * sin((90 - back_index) * pi / 180)], 'LineWidth', 2, 'Color', [1 1 1])
end

hold on
plot(Big_clock_Rad * cos((0:1:360)* pi / 180), Big_clock_Rad * sin((0:1:360)* pi / 180), 'k')
plot(Small_clock_X + Small_clock_Rad * cos((0:1:360)* pi / 180), Small_clock_Rad * sin((0:1:360)* pi / 180), 'k')

axis square;
axis off;

ClockHand_H = line([0, 0], [0, Radius_H], 'LineWidth', 2, 'Color', [1 0 0])
ClockHand_M = line([0, 0], [0, Radius_M], 'LineWidth', 2, 'Color', [0 0 0])
ClockHand_S = line([0, 0], [0, Radius_S], 'LineWidth', 2, 'Color', [0 0 1])

while(1)
    Time = clock;

    hour_x = Radius_H * cos((90 - mod(Time(4), 12) * Hour2Angle - Time(5) * Hour2Min) * Angle2Rad);
    hour_y = Radius_H * sin((90 - mod(Time(4), 12) * Hour2Angle - Time(5) * Hour2Min) * Angle2Rad);

    min_x = Radius_M * cos((90 - Time(5) * Min2Angle - Time(6) * Min2Sec) * Angle2Rad);
    min_y = Radius_M * sin((90 - Time(5) * Min2Angle - Time(6) * Min2Sec) * Angle2Rad);

    sec_x = Small_clock_X + Small_clock_Rad * cos((90 - Time(6) * Sec2Angle) * Angle2Rad);
    sec_y = Small_clock_Rad * sin((90 - Time(6) * Sec2Angle) * Angle2Rad);

    set(ClockHand_H, 'XData', [0, hour_x], 'YData', [0, hour_y]);
    set(ClockHand_M, 'XData', [0, min_x], 'YData', [0, min_y]);
    set(ClockHand_S, 'XData', [Small_clock_X, sec_x], 'YData', [0, sec_y]);

    set(colckTitle1, 'String', [num2str(Time(4)) '시'])
    set(colckTitle2, 'String', [num2str(Time(5)) '분'])
    set(colckTitle3, 'String', [num2str(floor(Time(6))) '초'])

    drawnow;
end


subplot(2, 3, 6)
axis square;
axis off;