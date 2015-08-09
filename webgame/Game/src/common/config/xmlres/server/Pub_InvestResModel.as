
package common.config.xmlres.server
{
    import common.config.xmlres.lib.IResModel;
	public class Pub_InvestResModel  implements IResModel
	{
		private var _sort:int=0;//投资分类
		private var _need_coin3:int=0;//投资金额
		private var _repay_coin3:int=0;//汇报金额
		
	
		public function Pub_InvestResModel(
args:Array
		)
		{
			_sort = args[0];
			_need_coin3 = args[1];
			_repay_coin3 = args[2];
			
		}
											
                public function get sort():int
                {
	                return _sort;
                }

                public function get need_coin3():int
                {
	                return _need_coin3;
                }

                public function get repay_coin3():int
                {
	                return _repay_coin3;
                }

            public function toObject():Object
            {
	            var o:Object = {
		            sort:this.sort.toString(),
				need_coin3:this.need_coin3.toString(),
				repay_coin3:this.repay_coin3.toString()
	            };			
	            return o;
			
            }
	}
 }