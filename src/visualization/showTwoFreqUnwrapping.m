function showTwoFreqUnwrapping(ph_high, ph_low, K, crossSection, xRange, highName, lowName)

figure, plot(ph_high(crossSection,xRange), 'DisplayName', highName)
hold on
plot(ph_low(crossSection,xRange), 'DisplayName', lowName)
plot(K(850, xRange) ...
    , 'DisplayName', "Code order")
xlabel('x (pixel)', 'FontSize', 24);
ylabel('phase (rad)', 'FontSize', 24)
xlim([135, 1480])
legend('FontSize',15)

end