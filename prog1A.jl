# 1. 生成网络函数
function generateNet(net0,Ntotal,k)
    net = zeros(Int64,Ntotal,k);
    for hang=1:Ntotal
        for lie=1:k
            hl = convert(Int64, net0[hang,lie]);
            net[hang,lie] = hl;
        end
    end
    return net
end


# 2. 更新策略函数
function updateStr(S,strategy,death_num,Ntotal,b,c,k,w)

    # 死亡节点的邻居序列
    death_neigh = S[death_num,:];
    death_neigh_strategy = zeros(Int64,1,4);
    # 死亡节点邻居的策略序列
    death_neigh_strategy = strategy[death_neigh];
    sum_dnei_str = sum(death_neigh_strategy);

    # 更新策略

    # 如果死亡邻居全为D或全为C，则学习该策略
    if sum_dnei_str == 0
        new_strategy = 0;
    elseif sum_dnei_str == k
        new_strategy = 1;
    else
        # 说明死亡节点邻居中既有C也有D，要分别计算邻居的收益
        # 计算死亡节点邻居的收益，就需要找出死亡节点邻居的邻居
        death_neigh_Payoff=zeros(1,k);
        for nn=1:k
            neighNow = death_neigh[nn];
            death_nei_nei = S[neighNow,:];
            # 计算出邻居的邻居的策略序列
            death_nei_nei_strategyC =  sum(strategy[death_nei_nei]);
            # 如果邻居节点i为C策略
            if strategy[neighNow] == 1
                death_neigh_Payoff[nn] = -k * c + b * death_nei_nei_strategyC;
            else
                death_neigh_Payoff[nn] = b * death_nei_nei_strategyC;
            end
        end
        death_neigh_fitness = 1 - w + w * death_neigh_Payoff;
        fitc = sum(death_neigh_fitness .* death_neigh_strategy);
        fitTotal = sum(death_neigh_fitness);
        Pc=fitc / fitTotal;
        probC = rand();
        if probC<=Pc
            new_strategy = 1;
        else
            new_strategy = 0;
        end

    end

    return new_strategy

end


# 3. 主函数
println(Dates.format(now(), "HH:MM:SS"))

# 1.1 变量定义
w = 0.01;
c = 1;
Ncwin = 0;
b = 4.0;

# 1.2 生成网络
net0 = readdlm("N500K4.txt" );
(Ntotal,k) = size(net0);
net = generateNet(net0,Ntotal,k);

# 1.3 轮回循环
for i=1:10000

    # 初始化网络，及其策略分布：1个C，499个D
    S = net;
    strategy = zeros(Int64,Ntotal,1);
    # 随机选择一个个体使其策略为C
    a = rand(1:Ntotal,1);
    strategy[a] = 1;
    # 初始c策略的人数
    nc = 1;

    while ((nc>0) && (nc<Ntotal))

        # 在每一步随机选择一个个体死亡，邻居并根据适应度竞争空位
        death_num = rand(1:Ntotal,1);
        old_str= strategy[death_num];  # 原策略
        old_strategy = old_str[1];
        # 更新策略
        @time new_strategy = updateStr(S,strategy,death_num,Ntotal,b,c,k,w);
        strategy[death_num] = new_strategy;
        nc = nc + new_strategy - old_strategy;

    end

    if nc == Ntotal
        Ncwin = Ncwin + 1;
    end

end

fix_p = Ncwin/10000;
println(fix_p);
println(Dates.format(now(), "HH:MM:SS"))
