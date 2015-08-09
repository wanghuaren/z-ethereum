using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.OleDb;
using System.Data;
using System.IO;

namespace ProtocolTool.core
{
    class DBCtrl
    {
        private static DBCtrl _instance;
        public static DBCtrl instance
        {
            get
            {
                if (_instance == null)
                    _instance = new DBCtrl();
                return _instance;
            }
        }
        private OleDbConnection strConnection;

        private Dictionary<string, string> dicTabData = new Dictionary<string, string>();
        public string dbPah = "";
        public OleDbConnection conn
        {
            get
            {

                if (strConnection == null)
                    strConnection = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + dbPah + ";Persist Security Info=False");
                if (strConnection.State == ConnectionState.Open)
                    strConnection.Close();
                if (strConnection.State == ConnectionState.Closed)
                {
                    try
                    {
                        strConnection.Open();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                        strConnection = null;
                    }
                }
                return strConnection;
            }
        }

        public void saveTabData(string _path)
        {
            if (conn == null) return;
            string strSession = "";

            string str = AppDomain.CurrentDomain.BaseDirectory;

            if (Directory.Exists(str + "/C++"))
                Directory.Delete(str + "/C++", true);
            if (Directory.Exists(str + "/C#"))
                Directory.Delete(str + "/C#", true);

            string strCS1 = "";

            string strCS2 = "";

            string strCS3 = "";
            string strCS33 = "";

            string strC3 = CodeStr.strCPP_PFactory;
            string strC33 = "";
            string strC333 = "";

            string strC4 = "";

            string strC5;
            string strC55 = "";

            string strC6;
            string strC66 = "";

            DataTable shemaTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });
            foreach (DataRow dr in shemaTable.Rows)
            {
                strCS1 += CodeStr.strCS_PBase_XML.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strCS2 += CodeStr.strCS_PFactory_Case.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strCS3 = CodeStr.strCS_Table.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strC33 += CodeStr.strCPP_PFactory_IF1.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");
                strC333 += CodeStr.strCPP_PFactory_IF2.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strC4 += CodeStr.strCH_PFactory_Include.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strC5 = CodeStr.strCH_Table.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strC6 = CodeStr.strCPP_Table.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");

                strSession += "session(\"" + dr["TABLE_NAME"] + "\")=\"" + dr.ItemArray[5] + "\"\n";

                DataTable columnTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[] { null, null, dr["TABLE_NAME"].ToString(), null });
                foreach (DataRow dr2 in columnTable.Rows)
                {
                    strSession += "session(\"" + dr["TABLE_NAME"] + "-" + dr2["COLUMN_NAME"] + "\")=\"" + dr2.ItemArray[27] + "\"\n";

                    if ((dr2["COLUMN_NAME"] + "") != "tabName" && (dr2["COLUMN_NAME"] + "") != "result" && (dr2["COLUMN_NAME"] + "") != "act")
                    {
                        strCS33 += CodeStr.strCS_Table_Proper.Replace("${TAB_COLUMN}", dr2["COLUMN_NAME"] + "");
                        strCS33 = strCS33.Replace("${TAB_COLUMN_DESC}", dr2.ItemArray[27] + "");
                    }

                    if ((dr2["COLUMN_NAME"] + "") != "tabName" && (dr2["COLUMN_NAME"] + "") != "result" && (dr2["COLUMN_NAME"] + "") != "act")
                    {
                        strC55 += CodeStr.strCH_Table_Value.Replace("${TAB_COLUMN}", dr2["COLUMN_NAME"] + "");
                        strC55 = strC55.Replace("${TAB_COLUMN_DESC}", dr2.ItemArray[27] + "");
                    }
                    strC66 += CodeStr.strCPP_Table_Value.Replace("${TAB_COLUMN}", dr2["COLUMN_NAME"] + "");
                    strC66 = strC66.Replace("${TAB_NAME}", dr["TABLE_NAME"] + "");
                }

                strCS3 = strCS3.Replace("${PROPER}", strCS33);
                strCS33 = "";

                write(str + "/C#/protocol/" + dr["TABLE_NAME"] + ".cs", strCS3);

                strC5 = strC5.Replace("${TABLEH_VALUE}", strC55);
                strC55 = "";

                write(str + "/C++/protocol/" + dr["TABLE_NAME"] + ".h", strC5);

                strC6 = strC6.Replace("${TABLECPP_VALUE}", strC66);
                strC66 = "";

                write(str + "/C++/protocol/" + dr["TABLE_NAME"] + ".cpp", strC6);
            }
            write(str + "/C#/protocol/PBase.cs", CodeStr.strCS_PBase.Replace("${XML}", strCS1));
            strCS1 = "";

            write(str + "/C#/protocol/PFactory.cs", CodeStr.strCS_PFactory.Replace("${CASE}", strCS2));

            write(str + "/C++/protocol/PBase.h", CodeStr.strCH_PBase);

            write(str + "/C++/protocol/PBase.cpp", CodeStr.strCPP_PBase);

            write(str + "/C++/protocol/PFactory.h", CodeStr.strCH_PFactory.Replace("${INCLUDE}", strC4));
            strC4 = "";

            strC3 = strC3.Replace("${IF1}", strC33.Substring(9));
            strC3 = strC3.Replace("${IF2}", strC333.Substring(9));

            write(str + "/C++/protocol/PFactory.cpp", strC3);

            write(str + "/session.asp", "<%\n" + strSession + "%>");
            strSession = "";
        }
        public void write(string filename, string content)
        {

            string path = Path.GetDirectoryName(filename);
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            File.WriteAllText(filename, content, Encoding.UTF8);

        }

    }
}
