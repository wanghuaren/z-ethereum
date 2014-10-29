package common.utils
{
	public class DataUtil
	{
		public function DataUtil()
		{
		}
		
		/**
		 * 根据货币单位获取对应的货币描述
		 * @value 货币值
		 * @unit 货币单位 defult = 0，基本单位 1：万 2：亿 
		 */
		public static function getCoinByUnit(value:int,unit:int = 0):String{
			var suffix:String = "";
			if (unit==1){//万
				if (value>=10000){
					value = value/10000;
					suffix = "万";
				}
			}else if (unit==2){
				if (value>=100000000){
					value = value/100000000;
					suffix = "亿";
				}else{
					if (value>=10000){
						value = value/10000;
						suffix = "万";
					}
				}
			}
			return value+suffix;
		}
	}
}