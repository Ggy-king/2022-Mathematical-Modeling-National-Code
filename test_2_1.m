%%  读取处理后的数据集
data_result = xlsread('高钾铅钡分类.xlsx');
M = size(data_result, 1);

%%  添加截距项
L_train = data_result(:, 1: end - 1);
R_train = data_result(:, end);

%%  建立模型
ctree = fitctree(L_train, R_train, 'MinLeafSize', 8);

%%  查看决策树视图
view(ctree, 'mode', 'graph');

%%  仿真测试
T_sim1 = predict(ctree, L_train);

%%  计算准确率
error1 = sum((T_sim1 == R_train)) / M * 100 ;

%%  绘图
figure
plot(1: M, R_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'预测结果对比'; ['准确率=' num2str(error1) '%']};
title(string)
xlim([1, M])
grid

%%  混淆矩阵
figure
cm = confusionchart(R_train, T_sim1);
cm.Title = 'Confusion Matrix for Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
