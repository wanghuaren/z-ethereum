import json
import os
import re
import time


class TidyProto(object):

    all_file = [
                "/home/ubuntu/prod/go/src/osen/pkg/proto/admin.proto",
                "/home/ubuntu/prod/go/src/osen/pkg/proto/exec.proto",
                "/home/ubuntu/prod/zerocap_market_data/zerocap_market_data.proto",
                "/home/ubuntu/prod/zerocap_otc/otc.proto"
                ]   # 所有的proto文件的路径
    fun_method = {}     # 所有接口的请求方法
    fun_no_method = {}  # 不存在请求方法的接口

    def __init__(self, route_path, proto_path="/home/ubuntu/swagger/swagger-ui-4.6.2", total_proto='Protal.proto'):
        self.proto_path = proto_path
        self.route_path = route_path
        self.total_proto = total_proto
        self.full_path = f"{proto_path}/{total_proto}"

    def run(self):
        # # 获取目标文件夹下所有的proto文件
        # self.find_all_proto(self.proto_path)

        # 1、获取admin服务所有接口的请求方法
        self.get_all_method()

        # 2、通过各服务的proto文件与步骤一获取的请求方法，生成总体的proto文件
        self.tidy_proto()

        # 3、通过protoc插件生成对应的json文件
        if not self.generate_json():

            # 4、修改生成的 json 文件，添加 host，schemes，token配置
           self.json_deal()

    def tidy_proto(self):
        """
        This method is to generate a new proto file through the proto file of each service and the request method
        obtained by self.get_all_method

        :return:
        """
        head = '''syntax = "proto3";
package pb;

option go_package = "pkg/pb";
import "google/api/annotations.proto";'''
        rpc = ''
        message = ''

        body_get = '''
        option (google.api.http) = {
          get: "/v1/%s"
        };
      }\n'''
        body_post = '''
        option (google.api.http) = {
          post: "/v1/%s"
          body: "*"
        };
      }\n'''

        for file in self.all_file:
            desc = ""  # 注释信息
            sla = '\\'
            if '/' in file:
                sla = "/"

            self.fun_no_method[file.split(sla)[-1]] = []
            with open(f'{file}', encoding='utf-8') as f:
                while True:
                    content = f.readline()
                    if not content:
                        break
                    if content.startswith("service"):
                        serve = content.split(" ")[1]
                        if serve == "Admin":
                            serve = "Osen"
                        rpc = rpc + '\n\nservice %s {\n'%serve

                    if content.startswith("message"):
                        while True:
                            content_messge = f.readline()
                            if '}' in content_messge or not content_messge:
                                content = content + '}\n\n'
                                break
                            content = content + content_messge
                        message = message + content

                    if content.startswith("  //") or content.startswith("	//"):  # 获取该接口的注释
                        desc += "    " + content

                    if 'rpc' in content and '//' not in content:
                        fun = content.strip(" ").split(" ")[1].split('(')[0].strip()

                        if self.fun_method.get(fun, None) == "get":
                            content = re.findall(r'[\t a-zA-Z0-9(){]*', content)[0] + "\n" + desc + body_get % fun
                            desc = ""
                        elif self.fun_method.get(fun, None) == "post":
                            content = re.findall(r'[\t a-zA-Z0-9(){]*', content)[0] + "\n" + desc.strip("\n") + body_post % fun
                            desc = ""
                        else:
                            if '}' not in content:
                                content = content + '}'
                            desc = ""
                            self.fun_no_method[file.split(sla)[-1]].append(fun)
                        rpc = rpc + content

            # 每个proto文件对应一个服务
            rpc = rpc + '}\n\n'
        text = head + rpc + message
        with open(self.full_path, 'wb') as f:
            f.write(text.encode())

    def find_all_proto(self, filepath):
        """
        This method is used to get all the proto files in the target folder

        :params:
            filepath  string,  like: "/home/ubuntu/prod/zerocap-admin/"

        :return:
        """
        # 遍历filepath下所有文件，包括子目录
        files = os.listdir(filepath)
        for fi in files:
            fi_d = os.path.join(filepath, fi)
            if os.path.isdir(fi_d):
                self.find_all_proto(fi_d)
            if os.path.splitext(fi_d)[-1] == '.proto':
                self.all_file.append(fi_d)

    def get_all_method(self):
        """
        This method is the request method used to obtain all interfaces of the admin service

        :return:
        """
        with open(f'{self.route_path}', encoding='utf-8') as f:
            while True:
                content = f.readline()
                if not content:
                    return self.fun_method
                if " get " in content or " post " in content:
                    if ' "/' not in content:
                        value = content.strip(" ").split(' "')
                        self.fun_method[value[1].split('"')[0]] = value[0]
                    else:
                        value = content.strip(" ").split(' "/')
                        self.fun_method[value[1].split('"')[0]] = value[0]

    def generate_json(self):
        """
        This method is to generate the corresponding json file through the protoc plugin

        :return:
        """

        result = 'fail'
        try:
            protoc_command = f"protoc -I {self.proto_path}  -I /home/ubuntu/go/src -I /home/ubuntu/go/src/google/api --openapiv2_out={self.proto_path} --openapiv2_opt logtostderr=true --openapiv2_opt json_names_for_fields=true {self.full_path}"
            result = os.popen(protoc_command).read()
        except Exception as e:
            print("generate_json error:", e)
        return result

    def json_deal(self):
        """
        This method is used to modify the generated json file, add host, schemes, token configuration

        :return:
        """
        all_api_desc = {}  # 接口名和接口注释的字典
        api_name = ""
        with open(self.full_path) as f:
            while True:
                content = f.readline()
                if not content:
                    continue
                if content.startswith("message"):
                    break

                if "rpc" in content:
                    match = re.search(r'rpc (\w+)', content)
                    api_name = match.group(1)
                    all_api_desc[api_name] = []

                if "//" in content and api_name != "":  # 注释行
                    new_con = content.strip("\n").lstrip("//").strip(" ").strip("\t")
                    all_api_desc[api_name].append(new_con)

        swagger_path = f'{self.proto_path}/Protal.swagger.json'
        token = {"name": "token", "in": "header", "type": "string"}
        with open(swagger_path) as f:
            data = json.load(f)
            data['host'] = "api-3.defi.wiki"
            data["schemes"] = ["https"]
            for path in data["paths"]:
                if 'get' in data["paths"][path]:
                    api_name = data["paths"][path]["get"]["operationId"].split("_")[1]  # 接口名
                    desc_info = all_api_desc.get(api_name)
                    if desc_info:
                        summary = desc_info[0]
                        description = "".join([i+"\n" for i in desc_info[1:]])
                        data["paths"][path]["get"]["summary"] = summary.lstrip("//").strip(" ")
                        data["paths"][path]["get"]["description"] = description.replace("//", "")

                    if data["paths"][path]['get'].get('parameters', None):
                        data["paths"][path]['get']['parameters'].append(token)
                    else:
                        data["paths"][path]['get']['parameters'] = [token]
                else:
                    api_name = data["paths"][path]["post"]["operationId"].split("_")[1]  # 接口名
                    desc_info = all_api_desc.get(api_name)
                    if desc_info:
                        summary = desc_info[0]
                        description = "".join([i+"\n" for i in desc_info[1:]])
                        data["paths"][path]["post"]["summary"] = summary.lstrip("//").strip(" ")
                        data["paths"][path]["post"]["description"] = description.replace("//", "")

                    if data["paths"][path]['post'].get('parameters', None):
                        data["paths"][path]['post']['parameters'].append(token)
                    else:
                        data["paths"][path]['post']['parameters'] = [token]

        filename = f'{self.proto_path}/dist/result.json'
        with open(filename, 'w') as f:
            f.write(json.dumps(data))


if __name__ == '__main__':
    # 1、生成总体的proto文件
    # route_path = r"D:\Workon\sprint11\zerocap-admin\config\routes.rb"

    route_path = "/home/ubuntu/prod/zerocap-admin/config/routes.rb"
    proto = TidyProto(route_path)
    proto.run()
    print("admin中没有请求方法的接口", proto.fun_no_method)