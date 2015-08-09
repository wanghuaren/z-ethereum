using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication.Classes.protocol
{
    public class PFactory
    {
        private static PFactory _instance;
        public static PFactory instance
        {
            get
            {
                if (_instance == null)
                    _instance = new PFactory();
                return _instance;
            }
        }
        public PBase stringToClass(string[] _data)
        {
            string _tabName = getTabName(_data);
            switch (_tabName)
            {
                
                case "tabCheck":
                    tabCheck _tabCheck = new tabCheck();
                    for (int i = 0; i < _data.Length; i++)
                    {
                        _tabCheck.GetType().GetProperty(_data[i++]).SetValue(_tabCheck, _data[i]);
                    }
                    return _tabCheck;
                case "tabCustom":
                    tabCustom _tabCustom = new tabCustom();
                    for (int i = 0; i < _data.Length; i++)
                    {
                        _tabCustom.GetType().GetProperty(_data[i++]).SetValue(_tabCustom, _data[i]);
                    }
                    return _tabCustom;
                case "tabTick":
                    tabTick _tabTick = new tabTick();
                    for (int i = 0; i < _data.Length; i++)
                    {
                        _tabTick.GetType().GetProperty(_data[i++]).SetValue(_tabTick, _data[i]);
                    }
                    return _tabTick;
                case "tabUser":
                    tabUser _tabUser = new tabUser();
                    for (int i = 0; i < _data.Length; i++)
                    {
                        _tabUser.GetType().GetProperty(_data[i++]).SetValue(_tabUser, _data[i]);
                    }
                    return _tabUser;
            }
            return null;
        }
        private string getTabName(string[] _data)
        {
            for (int i = 0; i < _data.Length; i++)
            {
                if (_data[i] == "tabName")
                {
                    return _data[i + 1];
                }
            }
            return "";
        }
    }
    
}