using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;
using WebApplication.Classes.protocol;
using WebApplication.Classes.utils;
namespace WebApplication
{
    /// <summary>
    /// WebService1 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
   
    public class WebService1 : System.Web.Services.WebService
    {
        [WebMethod]
        public BackData requestData(string[] data)
        {
            PBase _pBase = PFactory.instance.stringToClass(data);
            if (_pBase != null)
            {
                switch (_pBase.act)
                {
                    case "1":
                        return DBCtrl.instance.doSQLAdd(_pBase);
                    case "2":
                        return DBCtrl.instance.doSQLDel(_pBase);
                    case "3":
                        return DBCtrl.instance.doSQLEdit(_pBase);
                    case "4":
                        return DBCtrl.instance.doSQLFind(_pBase);
                }
            }
            BackData backData = new BackData();
            _pBase = new PBase();
            _pBase.result = "0";
            //backData.data.Add(_pBase);
            
            return backData;
        }
    }

}
