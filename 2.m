% 加载预测结果数据集
predicted_delivery_time_vector = readmatrix('predicted_delivery_time.csv');

% 创建一个空的datetime向量
predicted_delivery_time_datetime = datetime([],[],[]);

% 遍历predicted_delivery_time_vector中的每个元素，将其转换为datetime类型
for i = 1:numel(predicted_delivery_time_vector)
    predicted_delivery_time_datetime(i) = datetime(predicted_delivery_time_vector(i), ...
        'ConvertFrom', 'epochtime', 'Epoch', '2015/2/6  23:27:00');
end

% 显示恢复后的datetime数据
disp(predicted_delivery_time_datetime);


filename = 'predicted_delivery_time_datetime.csv';
writematrix(predicted_delivery_time_datetime', filename);
