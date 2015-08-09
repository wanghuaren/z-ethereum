using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.Classes.protocol
{
    public class tabCustom:PBase
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
        /// 开户行
        /// </summary>
        private string _bankName;
        /// <summary>
        /// 开户行
        /// </summary>
        public string bankName
        {
            set
            {
                _bankName = value;
            }
            get
            {
                return _bankName;
            }
        }
		/// <summary>
        /// 账号
        /// </summary>
        private string _bankNum;
        /// <summary>
        /// 账号
        /// </summary>
        public string bankNum
        {
            set
            {
                _bankNum = value;
            }
            get
            {
                return _bankNum;
            }
        }
		/// <summary>
        /// 出生
        /// </summary>
        private string _bron;
        /// <summary>
        /// 出生
        /// </summary>
        public string bron
        {
            set
            {
                _bron = value;
            }
            get
            {
                return _bron;
            }
        }
		/// <summary>
        /// 客户名
        /// </summary>
        private string _cName;
        /// <summary>
        /// 客户名
        /// </summary>
        public string cName
        {
            set
            {
                _cName = value;
            }
            get
            {
                return _cName;
            }
        }
		/// <summary>
        /// 营业方式,如:直营
        /// </summary>
        private string _compMode;
        /// <summary>
        /// 营业方式,如:直营
        /// </summary>
        public string compMode
        {
            set
            {
                _compMode = value;
            }
            get
            {
                return _compMode;
            }
        }
		/// <summary>
        /// 公司名
        /// </summary>
        private string _compName;
        /// <summary>
        /// 公司名
        /// </summary>
        public string compName
        {
            set
            {
                _compName = value;
            }
            get
            {
                return _compName;
            }
        }
		/// <summary>
        /// 规格
        /// </summary>
        private string _cSize;
        /// <summary>
        /// 规格
        /// </summary>
        public string cSize
        {
            set
            {
                _cSize = value;
            }
            get
            {
                return _cSize;
            }
        }
		/// <summary>
        /// 配送公司
        /// </summary>
        private string _dispathComp;
        /// <summary>
        /// 配送公司
        /// </summary>
        public string dispathComp
        {
            set
            {
                _dispathComp = value;
            }
            get
            {
                return _dispathComp;
            }
        }
		/// <summary>
        /// 配送医院1
        /// </summary>
        private string _dispathMed1;
        /// <summary>
        /// 配送医院1
        /// </summary>
        public string dispathMed1
        {
            set
            {
                _dispathMed1 = value;
            }
            get
            {
                return _dispathMed1;
            }
        }
		/// <summary>
        /// 配送医院2
        /// </summary>
        private string _dispathMed2;
        /// <summary>
        /// 配送医院2
        /// </summary>
        public string dispathMed2
        {
            set
            {
                _dispathMed2 = value;
            }
            get
            {
                return _dispathMed2;
            }
        }
		/// <summary>
        /// 厂家名
        /// </summary>
        private string _facName;
        /// <summary>
        /// 厂家名
        /// </summary>
        public string facName
        {
            set
            {
                _facName = value;
            }
            get
            {
                return _facName;
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
        /// 产品
        /// </summary>
        private string _prodName;
        /// <summary>
        /// 产品
        /// </summary>
        public string prodName
        {
            set
            {
                _prodName = value;
            }
            get
            {
                return _prodName;
            }
        }
		/// <summary>
        /// 税号
        /// </summary>
        private string _taxNum;
        /// <summary>
        /// 税号
        /// </summary>
        public string taxNum
        {
            set
            {
                _taxNum = value;
            }
            get
            {
                return _taxNum;
            }
        }
		/// <summary>
        /// 电话
        /// </summary>
        private string _tel;
        /// <summary>
        /// 电话
        /// </summary>
        public string tel
        {
            set
            {
                _tel = value;
            }
            get
            {
                return _tel;
            }
        }
		/// <summary>
        /// 发票地址
        /// </summary>
        private string _tickAdd;
        /// <summary>
        /// 发票地址
        /// </summary>
        public string tickAdd
        {
            set
            {
                _tickAdd = value;
            }
            get
            {
                return _tickAdd;
            }
        }
		/// <summary>
        /// 发票单件名称
        /// </summary>
        private string _tickComp;
        /// <summary>
        /// 发票单件名称
        /// </summary>
        public string tickComp
        {
            set
            {
                _tickComp = value;
            }
            get
            {
                return _tickComp;
            }
        }
		/// <summary>
        /// 发票电话
        /// </summary>
        private string _tickTel;
        /// <summary>
        /// 发票电话
        /// </summary>
        public string tickTel
        {
            set
            {
                _tickTel = value;
            }
            get
            {
                return _tickTel;
            }
        }
		/// <summary>
        /// 所属业务员
        /// </summary>
        private string _userid;
        /// <summary>
        /// 所属业务员
        /// </summary>
        public string userid
        {
            set
            {
                _userid = value;
            }
            get
            {
                return _userid;
            }
        }
    }
}