using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml.Serialization;

namespace WebApplication.Classes.protocol
{
	
	[XmlInclude(typeof(tabCheck))]
	[XmlInclude(typeof(tabCustom))]
	[XmlInclude(typeof(tabTick))]
	[XmlInclude(typeof(tabUser))]
    public class PBase
    {
        protected string _act;
        virtual public string act
        {
            get
            {
                return _act;
            }
            set
            {
                _act = value;
            }
        }
        protected string _tabName;
        virtual public string tabName
        {
            get
            {
                return _tabName;
            }
            set
            {
                _tabName = value;
            }
        }
        protected string _result;
        virtual public string result
        {
            get
            {
                return _result;
            }
            set
            {
                _result = value;
            }
        }
    }
}