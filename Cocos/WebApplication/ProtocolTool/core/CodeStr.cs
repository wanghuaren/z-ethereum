using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ProtocolTool.core
{
    class CodeStr
    {
        private static string _strCS_PBase;
        private static string _strCS_PBase_XML;
        private static string _strCS_PFactory;
        private static string _strCS_PFactory_Case;
        private static string _strCS_Table;
        private static string _strCS_Table_Proper;

        private static string _strCH_PBase;
        private static string _strCPP_PBase;
        private static string _strCH_PFactory;
        private static string _strCH_PFactory_Include;
        private static string _strCPP_PFactory;
        private static string _strCPP_PFactory_IF1;
        private static string _strCPP_PFactory_IF2;
        private static string _strCH_Table;
        private static string _strCH_Table_Value;
        private static string _strCPP_Table;
        private static string _strCPP_Table_Value;
        public static string strCS_PBase_XML
        {
            get
            {
                if (_strCS_PBase_XML == null)
                    _strCS_PBase_XML = File.ReadAllText("template/protocol/C#/PBase.cs.xml.txt");
                return _strCS_PBase_XML;
            }
        }
        public static string strCS_PBase
        {
            get
            {
                if (_strCS_PBase == null)
                    _strCS_PBase = File.ReadAllText("template/protocol/C#/PBase.cs.txt");
                return _strCS_PBase;
            }
        }
        public static string strCS_PFactory
        {
            get
            {
                if (_strCS_PFactory == null)
                    _strCS_PFactory = File.ReadAllText("template/protocol/C#/PFactory.cs.txt");
                return _strCS_PFactory;
            }
        }
        public static string strCS_PFactory_Case
        {
            get
            {
                if (_strCS_PFactory_Case == null)
                    _strCS_PFactory_Case = File.ReadAllText("template/protocol/C#/PFactory.cs.case.txt");
                return _strCS_PFactory_Case;
            }
        }
        public static string strCS_Table
        {
            get
            {
                if (_strCS_Table == null)
                    _strCS_Table = File.ReadAllText("template/protocol/C#/Table.cs.txt");
                return _strCS_Table;
            }
        }
        public static string strCS_Table_Proper
        {
            get
            {
                if (_strCS_Table_Proper == null)
                    _strCS_Table_Proper = File.ReadAllText("template/protocol/C#/Table.cs.proper.txt");
                return _strCS_Table_Proper;
            }
        }

        public static string strCH_PBase
        {
            get
            {
                if (_strCH_PBase == null)
                    _strCH_PBase = File.ReadAllText("template/protocol/C++/PBase.h.txt");
                return _strCH_PBase;
            }
        }
        public static string strCPP_PBase
        {
            get
            {
                if (_strCPP_PBase == null)
                    _strCPP_PBase = File.ReadAllText("template/protocol/C++/PBase.cpp.txt");
                return _strCPP_PBase;
            }
        }

        public static string strCH_PFactory
        {
            get
            {
                if (_strCH_PFactory == null)
                    _strCH_PFactory = File.ReadAllText("template/protocol/C++/PFactory.h.txt");
                return _strCH_PFactory;
            }
        }
        public static string strCH_PFactory_Include
        {
            get
            {
                if (_strCH_PFactory_Include == null)
                    _strCH_PFactory_Include = File.ReadAllText("template/protocol/C++/PFactory.h.include.txt");
                return _strCH_PFactory_Include;
            }
        }
        public static string strCPP_PFactory
        {
            get
            {
                if (_strCPP_PFactory == null)
                    _strCPP_PFactory = File.ReadAllText("template/protocol/C++/PFactory.cpp.txt");
                return _strCPP_PFactory;
            }
        }
        public static string strCPP_PFactory_IF1
        {
            get
            {
                if (_strCPP_PFactory_IF1 == null)
                    _strCPP_PFactory_IF1 = File.ReadAllText("template/protocol/C++/PFactory.cpp.if1.txt");
                return _strCPP_PFactory_IF1;
            }
        }
        public static string strCPP_PFactory_IF2
        {
            get
            {
                if (_strCPP_PFactory_IF2 == null)
                    _strCPP_PFactory_IF2 = File.ReadAllText("template/protocol/C++/PFactory.cpp.if2.txt");
                return _strCPP_PFactory_IF2;
            }
        }
        public static string strCH_Table
        {
            get
            {
                if (_strCH_Table == null)
                    _strCH_Table = File.ReadAllText("template/protocol/C++/Table.h.txt");
                return _strCH_Table;
            }
        }
        public static string strCH_Table_Value
        {
            get
            {
                if (_strCH_Table_Value == null)
                    _strCH_Table_Value = File.ReadAllText("template/protocol/C++/Table.h.value.txt");
                return _strCH_Table_Value;
            }
        }
        public static string strCPP_Table
        {
            get
            {
                if (_strCPP_Table == null)
                    _strCPP_Table = File.ReadAllText("template/protocol/C++/Table.cpp.txt");
                return _strCPP_Table;
            }
        }
        public static string strCPP_Table_Value
        {
            get
            {
                if (_strCPP_Table_Value == null)
                    _strCPP_Table_Value = File.ReadAllText("template/protocol/C++/Table.cpp.value.txt");
                return _strCPP_Table_Value;
            }
        }

    }
}
