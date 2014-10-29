package ui.frame
{
	import netc.Data;

	/**
	 *	职业控制
	 *  2014-08-18 
	 */
	public class Metier
	{
		public function Metier()
		{
		}
		/**
		 *	男女 
		 */
		public static const SEX_NAN:int = 1;
		public static const SEX_NV:int = 2;


		public static function getSexName(sex:int):String{
			return sex==SEX_NAN?"男":sex==SEX_NV?"女":"";
		}
		
	}
}