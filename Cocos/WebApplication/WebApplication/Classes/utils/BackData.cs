using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using WebApplication.Classes.protocol;
namespace WebApplication.Classes.utils
{
    public class BackData
    {
        private List<PBase> _data = new List<PBase>();
        public List<PBase> data
        {
            set
            {
                _data = value;
            }
            get
            {
                return _data;
            }
        }
        public bool clear()
        {

            _data.Clear();
            return true;

        }
    }
}