function xyz(x::Function)
    return x(π)
end

print(xyz(sin))

# 最重要的还是认真看文档，靠自己尝试虽然也能实现，
# 但是实在是太过于耗费时间了
