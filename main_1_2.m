%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  第（1）问中第二题
% 利用最小二乘法建立化学成分含量与是否风化之间的数学关系
% 对不同类型的文物分别建立模型 0 未风化 1 风化

%%  读取处理后的数据集
res_gj = xlsread('高钾.xlsx');
M = size(res_gj, 1);

%%  添加截距项
P_train = [res_gj(:, 1: end - 1), ones(M, 1)];
T_train =  res_gj(:, end);

%%  创建模型
beta = regress(T_train, P_train);

%%  预测拟合
T_sim1 = P_train * beta;

%%  激活函数
T_sim1(T_sim1 >= 0.5) = 1;
T_sim1(T_sim1 <  0.5) = 0;

%%  计算准确率
error1 = sum((T_sim1 == T_train)) / M * 100 ;

%%  绘图
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'预测结果对比'; ['准确率=' num2str(error1) '%']};
title(string)
xlim([1, M])
grid

%%  混淆矩阵
figure
cm = confusionchart(T_train, T_sim1);
cm.Title = 'Confusion Matrix for Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

%%  输出公式系数
disp(beta')

%%  也就是 Y = 激活函数（x1w1+x2w2+...+xnwn）
%%  激活函数就是大于0.5就是1，小于0.5就是0