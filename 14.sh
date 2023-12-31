## shell脚本一天一练系列 -- Day14
## 今日脚本需求:
## 写一个日志归档脚本，类似于系统的logrotate程序做日志归档。
## 假如服务的输出日志是1.log，要求每天归档一个，1.log第二天就变成1.log.1，
## 第三天1.log.2, 第四天 1.log.3  一直到1.log.5

### ------- 分割线,以下为脚本正文 -------
#!/bin/bash
# author: aming  (vx:  lishiming2009)
# version: v1
# date: 2023-09-22


## 思路：
## 我们要考虑到该脚本可能是初次执行，也可能是已经执行了好久
## 如果是初次执行，那么日志目录里只有1.log，而没有1.log.1, 1.log.2, ... 1.log.5
## 又或者说这些文件有部分或者全部
## 这些情况我们都要考虑到
## 就说最常规的一个情况：这些文件都存在
## 那么，我们就需要先删除掉最后面的那个1.log.5，
## 然后1.log.4改名字为1.log.5
## 再然后1.log.3改名字为1.log.4，以此类推


## 假设日志路径为/data
cd /data

## 首先删除掉最老的日志1.log.5，如果存在的话
if [ -f 1.log.5 ]
then
    rm -f 1.log.5
fi

## 使用for + seq 做从5到2倒序遍历循环
## 这里的用法，等同于 for i in 5 4 3 2 1
for i in `seq 5 -1 2`
do
    ## 如果日志存在，则后缀加1
    if [ -f 1.log.$[$i-1] ]
    then
        mv 1.log.$[$i-1] 1.log.$i
    fi
done

## 还差最后一个也要改名字
mv 1.log 1.log.1
## 还要新建一下1.log
touch 1.log

<<'COMMENT'
关键知识点总结：
1）for + seq用法
2）倒序是本脚本关键，因为要从最后面的文件开始处理，就好比一个萝卜一个坑，只有最前面的腾出地方，后面的才能到之前的坑里
COMMENT

