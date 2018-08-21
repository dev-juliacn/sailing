# 1. 生成网络函数
function generateNet(net0)
    (Ntotal,k) = size(net0);
    net = zeros(Int64,Ntotal,k);
    for hang=1:Ntotal
        for lie=1:k
            hl = convert(Int64, net0[hang,lie]);
            net[hang,lie] = hl;
        end
    end
    return net
end


# 2. 网络初始化函数
function initNet(net)
    (Ntotal,k) = size(net0);
    S = net;
    strategy = zeros(Int64,Ntotal,1);
    a = rand(1:Ntotal,1);
    strategy[a] = 1;
    return S,strategy
end


# 3. 更新策略函数
function updateStr(S,strategy,death_num,b)

    w = 0.01;
    (Ntotal,k) = size(S);

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
                death_neigh_Payoff[nn] = -k * 1 + b * death_nei_nei_strategyC;
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


function Round(net,b)
    S,strategy = initNet(net); #println(strategy); ok2
    (Ntotal,k) = size(net);
    nc = 1;
    while ((nc>0) && (nc<Ntotal))
        death_num = rand(1:Ntotal,1);
        old_strategy = strategy[death_num][1];  # 原策略
        # 更新策略
        new_strategy = updateStr(S,strategy,death_num,b);
        strategy[death_num] = new_strategy;
        nc = nc + new_strategy - old_strategy;
    end
    return nc
end


function main(net0,Ncwin,b)
    net = generateNet(net0); #println(net); ok1
    (Ntotal,k) = size(net0);
    for i=1:10000
        nc = Round(net,b);
        if (nc == Ntotal)
            Ncwin += 1;
        end
    end
end


net0 = readdlm("N500K4.txt" );
w = 0.01;
c = 1;
Ncwin = 0;
b = 3.9;
@time main(net0,Ncwin,b);
