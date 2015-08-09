using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.OleDb;
using System.Reflection;

using WebApplication.Classes.protocol;
namespace WebApplication.Classes.utils
{
    public class DBCtrl
    {
        private static DBCtrl _instance;
        public static DBCtrl instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new DBCtrl();
                }
                return _instance;
            }
        }
        public string desc;
        public DBCtrl()
        {
            //Tool _tool = new Tool();
            //_tool.userName = "admin";
            //_tool.tabName = "tabUser";
            //BackData _backData= doSQLFind(_tool);
            //desc = (_backData.data[0] as Tool).desc;
        }
        public OleDbConnection getConn()
        {
            string connstr = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + System.AppDomain.CurrentDomain.BaseDirectory + "\\App_Data\\accessDB.mdb";
            OleDbConnection tempconn = new OleDbConnection(connstr);
            return (tempconn);
        }
        public BackData doSQLAdd(PBase _pBase)
        {
            string tabName = _pBase.tabName;
            PBase _tempTool = new PBase();
            _tempTool.result = "0";
            _tempTool.tabName = _pBase.tabName;
            BackData backData = new BackData();
            backData.data.Add(_tempTool);
            string strCom = "insert into " + tabName;
            //try
            //{
            OleDbConnection conn = getConn();
            conn.Open();

            string strField = "(";
            string strValue = "(";
            Dictionary<string, string> param = classToDic(_pBase);

            foreach (string field in param.Keys)
            {
                if (field != "ID")
                {
                    strField += field + ",";
                    strValue += "'" + param[field] + "',";
                }
            }

            strField = strField.Substring(0, strField.Length - 1) + ")";
            strValue = strValue.Substring(0, strValue.Length - 1) + ")";

            strCom += strField + " values " + strValue;
            OleDbCommand insertcmd = new OleDbCommand(strCom, conn);
            insertcmd.ExecuteNonQuery();

            conn.Close();
            _tempTool.result = "1";
            //}
            //catch (Exception e)
            //{
            //    throw (new Exception("数据库更新出错:" + strCom + "\r" + e.Message));
            //}
            return backData;
        }

        public BackData doSQLDel(PBase _pBase)
        {
            PBase _tempTool = new PBase();
            _tempTool.result = "0";
            _tempTool.tabName = _pBase.tabName;
            BackData backData = new BackData();
            backData.data.Add(_tempTool);
            string tabName = _pBase.tabName;
            string strCom = "delete * from " + tabName;
            try
            {
                OleDbConnection conn = getConn();
                conn.Open();


                strCom += " where ";
                Dictionary<string, string> param = classToDic(_pBase);
                foreach (string field in param.Keys)
                {
                    if (param[field] != "" && field != "tabName" && field != "act")
                    {
                        strCom += field + "='" + param[field] + "' and ";
                    }
                }
                strCom = strCom.Substring(0, strCom.Length - 5);
                OleDbCommand myCommand = new OleDbCommand(strCom, conn);
                myCommand.ExecuteNonQuery();
                conn.Close();
                _tempTool.result = "1";

            }
            catch (Exception e)
            {
                throw (new Exception("数据库更新出错:" + strCom + "\r" + e.Message));
            }
            return backData;
        }

        public BackData doSQLEdit(PBase _pBase)
        {
            PBase _tempTool = new PBase();
            _tempTool.result = "0";
            _tempTool.tabName = _pBase.tabName;
            BackData backData = new BackData();
            backData.data.Add(_tempTool);
            string tabName = _pBase.tabName;
            string strCom = "update " + tabName + " set ";
            //try
            //{
            OleDbConnection conn = getConn();
            conn.Open();
            Dictionary<string, string> param = classToDic(_pBase);
            int numUpData = 0;
            OleDbCommand myCommand;
            foreach (string field in param.Keys)
            {
                if (field != "ID" && field != "userid"){
                    strCom += field + "='" + param[field] + "',";
                    numUpData++;
                }
                if (numUpData == 5)
                {
                    strCom = strCom.Substring(0, strCom.Length - 1);
                    strCom += " where id=" + param["ID"] + " and userid='" + param["userid"] + "'";
                    myCommand = new OleDbCommand(strCom, conn);
                    myCommand.ExecuteNonQuery();

                    strCom = "update " + tabName + " set ";
                    numUpData = 0;
                }
            }
            if (numUpData > 0)
            {
                strCom = strCom.Substring(0, strCom.Length - 1);
                strCom += " where id=" + param["ID"] + " and userid='" + param["userid"] + "'";
                myCommand = new OleDbCommand(strCom, conn);
                myCommand.ExecuteNonQuery();
            }
            conn.Close();
            _tempTool.result = "1";

            //}
            //catch (Exception e)
            //{
            //    throw (new Exception("数据库更新出错:" + strCom + "\r" + e.Message));
            //}
            return backData;
        }

        public BackData doSQLFind(PBase _pBase = null)
        {
            BackData backData = new BackData();

            string tabName = _pBase.tabName;
            string strCom = "Select * from " + tabName;
            //try
            //{
            OleDbConnection conn = getConn();
            conn.Open();

            if (_pBase != null)
            {
                Dictionary<string, string> param = classToDic(_pBase);
                strCom += " where ";
                foreach (string field in param.Keys)
                {
                    if (field != "tabName" && field != "act" && field != "result")
                    {
                        strCom += field + "='" + param[field] + "' and ";
                    }
                }
            }
            strCom = strCom.Substring(0, strCom.Length - 5);
            OleDbCommand myCommand = new OleDbCommand(strCom, conn);
            OleDbDataReader reader = myCommand.ExecuteReader();
            PBase _tempTool;
            while (reader.Read())
            {
                _tempTool = PFactory.instance.stringToClass(new string[] {"tabName",tabName });
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    if (_tempTool.GetType().GetProperty(reader.GetName(i)) != null)
                    {
                        _tempTool.GetType().GetProperty(reader.GetName(i)).SetValue(_tempTool, reader.GetValue(i).ToString());
                    }
                }
                _tempTool.tabName = tabName;
                backData.data.Add(_tempTool);
            }
            conn.Close();
            //}
            //catch (Exception e)
            //{
            //    throw (new Exception("数据库更新出错:" + strCom + "\r" + e.Message));
            //}
            return backData;
        }
        private Dictionary<string, string> classToDic(PBase _pBase)
        {
            Dictionary<string, string> _dic = new Dictionary<string, string>();
            PropertyInfo[] _property = _pBase.GetType().GetProperties();
            for (int i = 0; i < _property.Length; i++)
            {

                if (_property[i].GetValue(_pBase, null) != null)
                {
                    _dic[_property[i].Name] = _property[i].GetValue(_pBase, null).ToString();
                }
            }
            return _dic;
        }

    }
}