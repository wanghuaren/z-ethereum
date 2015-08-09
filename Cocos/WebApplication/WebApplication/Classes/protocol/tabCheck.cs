using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.Classes.protocol
{
    public class tabCheck:PBase
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
        /// 区域
        /// </summary>
        private string _area;
        /// <summary>
        /// 区域
        /// </summary>
        public string area
        {
            set
            {
                _area = value;
            }
            get
            {
                return _area;
            }
        }
		/// <summary>
        /// 备注
        /// </summary>
        private string _cDesc;
        /// <summary>
        /// 备注
        /// </summary>
        public string cDesc
        {
            set
            {
                _cDesc = value;
            }
            get
            {
                return _cDesc;
            }
        }
		/// <summary>
        /// 总额
        /// </summary>
        private string _cMoney;
        /// <summary>
        /// 总额
        /// </summary>
        public string cMoney
        {
            set
            {
                _cMoney = value;
            }
            get
            {
                return _cMoney;
            }
        }
		/// <summary>
        /// 客户
        /// </summary>
        private string _cName;
        /// <summary>
        /// 客户
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
        /// 件数
        /// </summary>
        private string _cNum;
        /// <summary>
        /// 件数
        /// </summary>
        public string cNum
        {
            set
            {
                _cNum = value;
            }
            get
            {
                return _cNum;
            }
        }
		/// <summary>
        /// 公司
        /// </summary>
        private string _compName;
        /// <summary>
        /// 公司
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
        /// 单价
        /// </summary>
        private string _cPrice;
        /// <summary>
        /// 单价
        /// </summary>
        public string cPrice
        {
            set
            {
                _cPrice = value;
            }
            get
            {
                return _cPrice;
            }
        }
		/// <summary>
        /// 规格-mg-ml-kg-个
        /// </summary>
        private string _cSize;
        /// <summary>
        /// 规格-mg-ml-kg-个
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
        /// 所属客户ID
        /// </summary>
        private string _customid;
        /// <summary>
        /// 所属客户ID
        /// </summary>
        public string customid
        {
            set
            {
                _customid = value;
            }
            get
            {
                return _customid;
            }
        }
		/// <summary>
        /// 厂家
        /// </summary>
        private string _facName;
        /// <summary>
        /// 厂家
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
        /// 订单日期
        /// </summary>
        private string _hDate;
        /// <summary>
        /// 订单日期
        /// </summary>
        public string hDate
        {
            set
            {
                _hDate = value;
            }
            get
            {
                return _hDate;
            }
        }
		/// <summary>
        /// 品名
        /// </summary>
        private string _hName;
        /// <summary>
        /// 品名
        /// </summary>
        public string hName
        {
            set
            {
                _hName = value;
            }
            get
            {
                return _hName;
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
        /// 付款方式
        /// </summary>
        private string _payMode;
        /// <summary>
        /// 付款方式
        /// </summary>
        public string payMode
        {
            set
            {
                _payMode = value;
            }
            get
            {
                return _payMode;
            }
        }
		/// <summary>
        /// 收货地址
        /// </summary>
        private string _reciveAdd;
        /// <summary>
        /// 收货地址
        /// </summary>
        public string reciveAdd
        {
            set
            {
                _reciveAdd = value;
            }
            get
            {
                return _reciveAdd;
            }
        }
		/// <summary>
        /// 收货人
        /// </summary>
        private string _reciveMan;
        /// <summary>
        /// 收货人
        /// </summary>
        public string reciveMan
        {
            set
            {
                _reciveMan = value;
            }
            get
            {
                return _reciveMan;
            }
        }
		/// <summary>
        /// 收货人电话
        /// </summary>
        private string _reciveTel;
        /// <summary>
        /// 收货人电话
        /// </summary>
        public string reciveTel
        {
            set
            {
                _reciveTel = value;
            }
            get
            {
                return _reciveTel;
            }
        }
		/// <summary>
        /// 发送方名称
        /// </summary>
        private string _sendName;
        /// <summary>
        /// 发送方名称
        /// </summary>
        public string sendName
        {
            set
            {
                _sendName = value;
            }
            get
            {
                return _sendName;
            }
        }
		/// <summary>
        /// 发送单号
        /// </summary>
        private string _sendNum;
        /// <summary>
        /// 发送单号
        /// </summary>
        public string sendNum
        {
            set
            {
                _sendNum = value;
            }
            get
            {
                return _sendNum;
            }
        }
		/// <summary>
        /// 发送查询电话
        /// </summary>
        private string _sendTel;
        /// <summary>
        /// 发送查询电话
        /// </summary>
        public string sendTel
        {
            set
            {
                _sendTel = value;
            }
            get
            {
                return _sendTel;
            }
        }
		/// <summary>
        /// 货运方式
        /// </summary>
        private string _sendWay;
        /// <summary>
        /// 货运方式
        /// </summary>
        public string sendWay
        {
            set
            {
                _sendWay = value;
            }
            get
            {
                return _sendWay;
            }
        }
		/// <summary>
        /// 订单状态 0未完成 1处理中 2已完成
        /// </summary>
        private string _state;
        /// <summary>
        /// 订单状态 0未完成 1处理中 2已完成
        /// </summary>
        public string state
        {
            set
            {
                _state = value;
            }
            get
            {
                return _state;
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