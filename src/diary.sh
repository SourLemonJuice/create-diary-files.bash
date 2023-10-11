#!/bin/bash
# SourLemonJuice

#获取日期
Date=$(date +"%F")
#获取时间
Time=$(date +"%H:%M")
#用日期当作文件名写进变量里
FileName="$Date.txt"
#文件们应该都放在哪里
FilePath="./"
#要使用的文本编辑器
EditorExec="vim"
#新文件的权限
NewChangeMode="664"

# 输入选项
Options=$(getopt -o Ttd -l help -- "$@")
# 如果有错误参数导致getopt报错则退出
if [ ! $? -eq 0 ];
then
	echo "获取参数出错"
	exit 1
fi
# 格式化getopt的输出
eval set -- "$Options"

# 测试模式
if [ $1 == "-T" ];
then
	#更改目录到脚本所在目录和名称
	FilePath="."
	FileName="test."$FileName

	#输出变量
	echo Date: $Date
	echo Time: $Time
	echo Name: $FileName
	echo Path: $FilePath
	echo EditorExec: $EditorExec
	echo Filemode: $NewChangeMode
	echo Option: $@

	#让人能看见输出，留出反应的时间
	read -p "按回车确认参数" -s
	#read -p是不加换行的，自己打印一个空行
	echo ""

	# 将变量移到下一位，不让后面的case重复检测
	shift
fi


# 主程序
# 组合文件位置
FileLocation="$FilePath/$FileName"

# 处理传入的参数，处理完后跳出
while true;
do
	case $1 in
		-t)
			# 如果加入参数则插入时间
			echo "$Time">>$FileLocation
		;;
		-d)
			echo "删除操作"
			# 最后确认
			read -p "按回车键删除\"$FileLocation\"" -s
			#read -p是不加换行的，自己打印一个空行
			echo ""
			rm $FileLocation
			exit 0
		;;
		--help)
			echo "这是一个快速创建日记的脚本"
			echo "创建新文件时会默认加入当前日期与时间"
			echo "-T 测试模式（仅第一位参数可用）"
			echo "-t 插入当前时间"
			echo "-d 删除当前文件"
			echo "--help 查看有效的选项们"
			exit 0
		;;
		--)
			# 最后一个输出跳出
			break
		;;
		?)
			echo "无效参数，但已经在getopt定义"
			exit 2
		;;
	esac
	# 把 $1 向后移动变成原先 $2 的内容
	shift
done

# 通用的逻辑

# 创建文件
if [ ! -f $FileLocation ];
then
	# 如果文件不存在
	# 创建文件
	touch $FileLocation
	if [ ! $? -eq 0 ];
	then
		echo "无法创建文件"
		exit 3
	fi

	# 设置权限
	chmod $NewChangeMode $FileLocation
	echo "$Date $Time">>$FileLocation
fi

# 用编辑器打开文件
$EditorExec $FileLocation
if [ ! $? -eq 0 ];
then
	echo "编辑器报错"
	exit 10
fi

exit 0
