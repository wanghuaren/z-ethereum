# zerocap_otc

### 目录结构

|-- zerocap_otc

&emsp;&emsp;|-- config  配置文件目录

&emsp;&emsp;&emsp;&emsp;|-- config.py 配置导入入口

&emsp;&emsp;&emsp;&emsp;|-- development.py 开发\测试环境配置

&emsp;&emsp;&emsp;&emsp;|-- production.py 生产环境配置

&emsp;&emsp;|-- db 数据库model定义目录

&emsp;&emsp;&emsp;&emsp;|-- base_models.py 模型基类，包括db对象

&emsp;&emsp;&emsp;&emsp;|-- models.py 项目模型定义

&emsp;&emsp;|-- external_api 第三方api

&emsp;&emsp;&emsp;&emsp;|-- fireblocks fireblocks相关接口

&emsp;&emsp;|-- internal 业务逻辑实现目录

&emsp;&emsp;&emsp;&emsp;|-- common 通用，比如error_manager

&emsp;&emsp;&emsp;&emsp;|-- yield_manager yield管理

&emsp;&emsp;&emsp;&emsp;|-- users 用户相关的逻辑处理

&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|-- data_helper.py 数据查询和封装

&emsp;&emsp;&emsp;&emsp;|-- transaction 交易相关的逻辑处理

&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|-- data_helper.py 数据查询和封装

&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|-- transaction .py 交易具体的逻辑

&emsp;&emsp;&emsp;&emsp;|-- ......

&emsp;&emsp;|-- scripts 相关脚本

&emsp;&emsp;&emsp;&emsp;|-- crontab_scripts 定时任务脚本

&emsp;&emsp;&emsp;&emsp;&emsp;&emsp|-- save_and_send_position.py 保存发送仓位数据


&emsp;&emsp;|-- service 服务定义

&emsp;&emsp;&emsp;&emsp;|-- mixins 根据业务定义mixins类，用以拆分文件

&emsp;&emsp;&emsp;&emsp;|-- otc_services.py grpc服务类实现

&emsp;&emsp;|-- test 测试目录

&emsp;&emsp;|-- utils 工具包

&emsp;&emsp;&emsp;&emsp;|-- calc.py 计算相关

&emsp;&emsp;&emsp;&emsp;|-- consts.py 常量定义

&emsp;&emsp;&emsp;&emsp;|-- date_time_utils.py 时间工具

&emsp;&emsp;&emsp;&emsp;|-- log_utils.py 日志工具

&emsp;&emsp;&emsp;&emsp;|-- path_utils.py 路径工具

&emsp;&emsp;&emsp;&emsp;|-- slack_utils.py slack工具

&emsp;&emsp;&emsp;&emsp;|-- zc_exception.py 异常工具

&emsp;&emsp;|-- app.py 服务启动脚本

&emsp;&emsp;|-- ......



### 环境变量

```shell
export otcPath = ~/prod/zerocap_otc
```

端口：5012
