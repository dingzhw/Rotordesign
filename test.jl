file = open("tmp","r")
lines = readlines(file)
close(file)

file2 = open("parameters2","w")
for i in 1:length(lines)
    xxx = split(lines[i],"=")[1]
    write(file2,xxx*"=\n")
    # write(file2,"\n")
end
close(file2)
# for i in 1:length(lines)
#     print(lines[i])
#     print("\n")
# end

# 最重要的还是认真看文档，靠自己尝试虽然也能实现，
# 但是实在是太过于耗费时间了
