## Swagger 参数注释的规范文档


**接口简要说明**

```
  proto文件中，如下，测试接口(第一行)为接口的简要注释

  // 测试接口
  rpc TestCall (TestCallRequestV1) returns (TestCallResponseV1) {}
```

**接口的逻辑说明**

```
  proto文件中，如下，除（测试接口<第一行>）外，其他注释(可以有多行)都为 
  接口的逻辑说明，展示格式有以下3种：

  // 测试接口
  // 用于测试接口
  rpc TestCall (TestCallRequestV1) returns (TestCallResponseV1) {}
  // 测试接口
  /* 用于测试接口 */
  rpc TestCall (TestCallRequestV1) returns (TestCallResponseV1) {}
  /* 测试接口
  用于测试接口 */
  rpc TestCall (TestCallRequestV1) returns (TestCallResponseV1) {}
  
```

**接口参数说明**

```
  proto文件中，如下，（symbol 必填、可填） 为接口参数symbol的注释

  message GetQuoteRequestV1 {
  // symbol 必填
  string symbol = 1;
  // 可填
  string entity = 2;
  }
```


