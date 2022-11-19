%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  第（1）问中第二题
% 利用最小二乘法建立化学成分含量与是否风化之间的数学关系
% 对不同类型的文物分别建立模型 0 未风化 1 风化

%%  读取处理后的数据集
res_qb = xlsread('高钾预测.xlsx');
M = size(res_qb, 1);

for i = 0 : 3

    %%  添加截距项
    P_train = [res_qb(:, 1: end - 4), ones(M, 1)];
    T_train =  res_qb(:, end - i);
    
    %%  创建模型
    beta = regress(T_train, P_train);
    
    %%  预测拟合
    T_sim1 = P_train * beta;
    T_sim1(T_sim1 < 0) = 0;

    error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);

    %%  绘图
    figure
    plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
    legend('真实值', '预测值')
    xlabel('预测样本')
    ylabel('预测结果')
    string = {'预测结果对比'; ['RMSE=' num2str(error1)]};
    title(string)
    xlim([1, M])
    grid

    %%  读取铅钡未风化数据
    None_qb = P_train(13: end, :);
    None_qb(:, 1) = 0;
    T_sim2(:, i + 1) = None_qb * beta;
    T_sim2(T_sim2 < 0) = 0;

end

%%  铅钡预测结果
xlswrite('高钾预测结果.xlsx', T_sim2)
