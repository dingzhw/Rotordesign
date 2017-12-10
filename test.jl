file = open(pwd()*"\\output\\ga.log","r")
lines = readlines(file)
close(file)

file2 = open(pwd()*"\\output\\meantmp.log","w")
for i in 1:length(lines)
    if contains(lines[i],"===当代平均功率为")
        xxx = split(lines[i],"===当代平均功率为")[2]
        xxx = split(xxx,"===")[1]
        write(file2,xxx*"=\n")
    end

    # write(file2,"\n")
end
close(file2)
# for i in 1:length(lines)
#     print(lines[i])
#     print("\n")
# end

# 最重要的还是认真看文档，靠自己尝试虽然也能实现，
# 但是实在是太过于耗费时间了
