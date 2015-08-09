using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.Classes.protocol
{
    public class tabUser:PBase
    {
        override public string tabName
        {
            set
            {
                _tabName = value;
            }
            get
            {
                return _tabName;
            }
        }
        override public string act
        {
            set
            {
                _act = value;
            }
            get
            {
                return _act;
            }
        }
       override public string result
        {
            set
            {
                _result = value;
            }
            get
            {
                return _result;
            }
        }
		
		
		/// <summary>
        /// 通知详情
        /// </summary>
        private string _desc;
        /// <summary>
        /// 通知详情
        /// </summary>
        public string desc
        {
            set
            {
                _desc = value;
            }
            get
            {
                return _desc;
            }
        }
		/// <summary>
        /// 
        /// </summary>
        private string _ID;
        /// <summary>
        /// 
        /// </summary>
        public string ID
        {
            set
            {
                _ID = value;
            }
            get
            {
                return _ID;
            }
        }
		/// <summary>
        /// 密码
        /// </summary>
        private string _password;
        /// <summary>
        /// 密码
        /// </summary>
        public string password
        {
            set
            {
                _password = value;
            }
            get
            {
                return _password;
            }
        }
		/// <summary>
        /// 业务员账号
        /// </summary>
        private string _userName;
        /// <summary>
        /// 业务员账号
        /// </summary>
        public string userName
        {
            set
            {
                _userName = value;
            }
            get
            {
                return _userName;
            }
        }
    }
}