#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# 获取日期
Date=$(date +"%F")
# 获取时间
Time=$(date +"%R(24h) %:z")
# 用日期当作文件名写进变量里
FileName="$Date.txt"
# 文件们应该都放在哪里
FilePath="./"
# 要使用的文本编辑器
# 可以正常释放参数，比如 "vim --opt"
# 启动编辑器时使用的是 exec 命令，但不用担心搞出注入'攻击'，比如字符串以 "-a xxx, -c, -l" 开头，因为最终用的是 `exec -- $var`
# 脚本会将文件路径接在字符串的最后面，比如 "vim --opt /file.txt"
EditorExec="vim"
# 文件的权限（每次编辑时更改）
NewFilePermission="640"

# 输入选项
Options=$(getopt -o hTtd -l help -- "$@")
# 如果有错误参数导致getopt报错则退出
if [ ! $? -eq 0 ];
then
    echo "diary.bash: 获取参数出错"
    exit 1
fi
# 格式化getopt的输出
eval set -- "$Options"

# 测试模式
# if [ $1 == "-T" ];
# then
#     #更改目录到脚本所在目录和名称
#     FilePath="../temp"
#     FileName="test."$FileName

#     #输出变量
#     echo Date: $Date
#     echo Time: $Time
#     echo Name: $FileName
#     echo Path: $FilePath
#     echo EditorExec: $EditorExec
#     echo Filemode: $NewChangeMode
#     echo Option: $@

#     #让人能看见输出，留出反应的时间
#     read -p "按回车确认参数" -s
#     #read -p是不加换行的，自己打印一个空行
#     echo ""

#     # 将变量移到下一位，不让后面的case重复检测
#   shift
# fi


# 主程序
# 组合文件位置
FileLocation="$FilePath/$FileName"

# 处理传入的参数，处理完后跳出
while true;
do
    case $1 in
        -t)
            # 如果加入参数则插入 换行 时间
            echo "">>"$FileLocation" || exit 1
            echo "==== $Time ====">>"$FileLocation" || exit 1
        ;;
        -d)
            echo "diary.bash: 正在执行删除操作"
            # 最后确认
            read -p "按回车键删除\"$FileLocation\"" -s
            # read -p是不加换行的，自己打印一个空行
            echo ""
            rm -i "$FileLocation" || exit 1
            exit 0
        ;;
        -h | --help)
            echo "这是一个用于快速记录日记的脚本"
            echo "创建新文件时会默认加入当前日期与时间"
            echo "[已弃用] -T 测试模式（仅第一位参数可用）"
            echo "-t 插入当前时间"
            echo "-d 删除当前文件"
            echo "--help 查看有效的选项们（本页面）"
            exit 0
        ;;
        --)
            # 最后一个输出跳出
            break
        ;;
        ?)
            echo "diary.bash: 无效参数，但已经在 getopt 中定义"
            exit 2
        ;;
    esac
    # 把 $1 向后移动变成原先 $2 的内容
    shift
done

# 通用的逻辑

# 创建文件
if [ ! -f "$FileLocation" ];
then
    # 如果文件不存在
    # 创建文件
    touch "$FileLocation" || exit 1
    if [ ! $? -eq 0 ];
    then
        echo "diary.bash: 无法创建文件"
        exit 3
    fi

    # 设置权限
    chmod $NewFilePermission "$FileLocation" || exit 1
    echo "$Date $(date +%A) $Time">>"$FileLocation" || exit 1
fi

# 用编辑器打开文件
# 注: exec 会将当前脚本解释器的进程替换为编辑器进程
# 所以它后面的语句永远不会被执行，也不需要关心传递返回码的问题
exec -- $EditorExec "$FileLocation"
