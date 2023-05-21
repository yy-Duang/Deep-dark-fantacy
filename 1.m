% 加载数据集
data = readtable('dataset.csv');

% 删除含有缺失值的行
data = rmmissing(data);

% 提取特征和目标变量
features = data(:, {'market_id', 'created_at', 'order_protocol', 'total_items', 'subtotal', ...
    'num_distinct_items', 'min_item_price', 'max_item_price', 'total_onshift_partners', ...
    'total_busy_partners', 'total_outstanding_orders'});
target = data(:, 'actual_delivery_time');

% 转换为持续时间并转换为秒
features.created_at = seconds(features.created_at - features.created_at(1));
target.actual_delivery_time = seconds(target.actual_delivery_time - target.actual_delivery_time(1));

% 计算特征的均值和标准差
feature_mean = mean(table2array(features));
feature_std = std(table2array(features));

% 归一化特征
normalized_features = (table2array(features) - feature_mean) ./ feature_std;

% 构建神经网络模型
hidden_units = 20;
net = feedforwardnet(hidden_units);

% 数据归一化
normalized_targets = normalize(table2array(target), 'range');


% 转置特征和目标变量，以适应神经网络的输入格式
normalized_features = normalized_features';
normalized_targets = normalized_targets';

% 训练神经网络模型
net = train(net, normalized_features, normalized_targets);

% 使用模型进行预测
% 在这里定义 test_features 变量，并传递要预测的特征数据
test_features = normalized_features(1:11, 1:17900);  % 使用第一个样本的特征进行预测
predicted_delivery_time = net(test_features);

% 反归一化预测结果
min_target = min(table2array(target));
max_target = max(table2array(target));
predicted_delivery_time = (predicted_delivery_time .* (max_target - min_target)) + min_target;

% 显示预测结果
predicted_delivery_time_vector = predicted_delivery_time';

% 将预测结果写入CSV文件
filename = 'predicted_delivery_time.csv';
writematrix(predicted_delivery_time, filename);

