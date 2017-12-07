# 入流模型选择器函数

include("uniforminflow.jl")
include("dynamicinflow.jl")
include("rigidwake.jl")
include("freewake.jl")
include("vpm.jl")

function inflow(x,judge="均匀入流") # 这是一个入流模型选择器函数
    # 通过改变judge的值来选择不同的入流模型
    # judge的值默认为“均匀入流”，可选动态入流、刚性尾迹、自由尾迹和涡粒子模型
    if judge=="均匀入流"
        return uniforminflow()
    elseif judge=="动态入流"
        return dynamicinflow()
    elseif judge=="刚性尾迹"
        return rigidwake()
    elseif judge=="自由尾迹"
        return freewake()
    elseif judge=="涡粒子"
        return vpmwake()
    else
        print("错误！无法理解输入的模型，请检查输入是否有误")
        return false
    end
end 
