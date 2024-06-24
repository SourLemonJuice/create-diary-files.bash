# diary.bash

这是我写的第一个有实际用途的`bash`脚本哦

用来在一个文件夹里以固定的命名规则创建文本文件，也就是所谓的日记\
我其实早就不用它了，毕竟写它有什么意义呢，都一样

不管怎么说，一个一直陪着我学习 linux 和 bash 的git储存库对我来说还是很有价值的，所以做点修改加一个自述文件就上传上来啦

## 配置变量

作为配置项的变量都定义在脚本的顶部，真正需要改的应该是这些地方（详细信息在脚本文件中有写）

```bash
FilePath="./"
EditorExec="vim"
NewFilePermission="640"
```

尤其是`FilePath`它是储存所有文件的目录，其结构类似这样

```text
${FilePath}
├── 2024-01-01.txt
└── 2024-01-02.txt
```

`EditorExec`则为启动编辑器的命令，要编辑的文件路径会被加在命令的最后，也只能加在最后\
`NewFilePermission`是创建文件的权限`chmod $NewFilePermission "$FileLocation"`

## 命令行中的用法

没什么，详情可以看 `--help` 后的输出

## License

This is free and unencumbered software released into the public domain.
