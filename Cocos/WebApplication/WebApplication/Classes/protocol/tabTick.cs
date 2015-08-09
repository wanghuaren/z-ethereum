using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.Classes.protocol
{
    public class tabTick:PBase
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
        /// 所属订单ID
        /// </summary>
        private string _checkID;
        /// <summary>
        /// 所属订单ID
        /// </summary>
        public string checkID
        {
            set
            {
                _checkID = value;
            }
            get
            {
                return _checkID;
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
        /// 开票人地址
        /// </summary>
        private string _pAddress;
        /// <summary>
        /// 开票人地址
        /// </summary>
        public string pAddress
        {
            set
            {
                _pAddress = value;
            }
            get
            {
                return _pAddress;
            }
        }
		/// <summary>
        /// 开票人开户行
        /// </summary>
        private string _pBankName;
        /// <summary>
        /// 开票人开户行
        /// </summary>
        public string pBankName
        {
            set
            {
                _pBankName = value;
            }
            get
            {
                return _pBankName;
            }
        }
		/// <summary>
        /// 开票人账号
        /// </summary>
        private string _pBankNum;
        /// <summary>
        /// 开票人账号
        /// </summary>
        public string pBankNum
        {
            set
            {
                _pBankNum = value;
            }
            get
            {
                return _pBankNum;
            }
        }
		/// <summary>
        /// 开票人单位
        /// </summary>
        private string _pCompName;
        /// <summary>
        /// 开票人单位
        /// </summary>
        public string pCompName
        {
            set
            {
                _pCompName = value;
            }
            get
            {
                return _pCompName;
            }
        }
		/// <summary>
        /// 邮寄发票联系人
        /// </summary>
        private string _pContacts;
        /// <summary>
        /// 邮寄发票联系人
        /// </summary>
        public string pContacts
        {
            set
            {
                _pContacts = value;
            }
            get
            {
                return _pContacts;
            }
        }
		/// <summary>
        /// 邮寄发票地址
        /// </summary>
        private string _pContactsAdd;
        /// <summary>
        /// 邮寄发票地址
        /// </summary>
        public string pContactsAdd
        {
            set
            {
                _pContactsAdd = value;
            }
            get
            {
                return _pContactsAdd;
            }
        }
		/// <summary>
        /// 邮寄发票联系人电话
        /// </summary>
        private string _pContactsTel;
        /// <summary>
        /// 邮寄发票联系人电话
        /// </summary>
        public string pContactsTel
        {
            set
            {
                _pContactsTel = value;
            }
            get
            {
                return _pContactsTel;
            }
        }
		/// <summary>
        /// 开票人传真
        /// </summary>
        private string _pFax;
        /// <summary>
        /// 开票人传真
        /// </summary>
        public string pFax
        {
            set
            {
                _pFax = value;
            }
            get
            {
                return _pFax;
            }
        }
		/// <summary>
        /// 邮寄发票邮编
        /// </summary>
        private string _pMailNum;
        /// <summary>
        /// 邮寄发票邮编
        /// </summary>
        public string pMailNum
        {
            set
            {
                _pMailNum = value;
            }
            get
            {
                return _pMailNum;
            }
        }
		/// <summary>
        /// 开票申请人
        /// </summary>
        private string _pName;
        /// <summary>
        /// 开票申请人
        /// </summary>
        public string pName
        {
            set
            {
                _pName = value;
            }
            get
            {
                return _pName;
            }
        }
		/// <summary>
        /// 开票物品数量
        /// </summary>
        private string _pNum;
        /// <summary>
        /// 开票物品数量
        /// </summary>
        public string pNum
        {
            set
            {
                _pNum = value;
            }
            get
            {
                return _pNum;
            }
        }
		/// <summary>
        /// 开票物品单价
        /// </summary>
        private string _pPrice;
        /// <summary>
        /// 开票物品单价
        /// </summary>
        public string pPrice
        {
            set
            {
                _pPrice = value;
            }
            get
            {
                return _pPrice;
            }
        }
		/// <summary>
        /// 开票物品名
        /// </summary>
        private string _pProName;
        /// <summary>
        /// 开票物品名
        /// </summary>
        public string pProName
        {
            set
            {
                _pProName = value;
            }
            get
            {
                return _pProName;
            }
        }
		/// <summary>
        /// 开票物品规格
        /// </summary>
        private string _pSize;
        /// <summary>
        /// 开票物品规格
        /// </summary>
        public string pSize
        {
            set
            {
                _pSize = value;
            }
            get
            {
                return _pSize;
            }
        }
		/// <summary>
        /// 开票金额
        /// </summary>
        private string _pSumPrice;
        /// <summary>
        /// 开票金额
        /// </summary>
        public string pSumPrice
        {
            set
            {
                _pSumPrice = value;
            }
            get
            {
                return _pSumPrice;
            }
        }
		/// <summary>
        /// 开票人税号
        /// </summary>
        private string _pTaxNum;
        /// <summary>
        /// 开票人税号
        /// </summary>
        public string pTaxNum
        {
            set
            {
                _pTaxNum = value;
            }
            get
            {
                return _pTaxNum;
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