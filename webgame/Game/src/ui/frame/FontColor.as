package ui.frame
{
	import flash.text.TextField;
	
	import netc.Data;

	/**
	 *	颜色控制
	 *  2013-10-25 
	 *  请不要在此类写业务逻辑
	 */
	public class FontColor
	{
		public function FontColor()
		{
		}
		/**
		 *	聊天频道颜色 
		 */
		public static const COLOR_NAME:String = "FFFAAF";
		public static const COLOR_PU_TONG:String = "fff5d2";
		public static const COLOR_DUI_WU:String = "6bdefb";
		public static const COLOR_BANG_PAI:String = "4a9afe";
		public static const COLOR_SHI_JIE:String = "fcc738";
		public static const COLOR_XI_TONG:String = "ff9b0b";
		public static const COLOR_JIAO_YI:String = "e65eff";
		
		/**
		 *	任务颜色 
		 */
		public static const COLOR_ZHU_XIAN:String = "fcc738";
		public static const COLOR_ZHI_XIAN:String = "4a9afe";
		public static const COLOR_RI_CHANG:String = "4a9afe";
		public static const COLOR_HUO_BAN:String = "4a9afe";
		public static const COLOR_LIAN_GU:String = "4a9afe";
		public static const COLOR_HUAN:String = "4a9afe";
		public static const COLOR_HUANG:String = "4a9afe";

		/**
		 *	道具颜色 白黄蓝紫红
		 */
		public static const COLOR_TOOL_1:String = "fff5d2";
		public static const COLOR_TOOL_2:String = "fcc738";
		public static const COLOR_TOOL_3:String = "8afd5c";
		public static const COLOR_TOOL_4:String = "4a9afe";
		public static const COLOR_TOOL_5:String = "e65eff";
		public static const COLOR_TOOL_6:String = "ff6a78";
		
		/**
		 *	NPC{传}
		 */
		public static const COLOR_NPC:String = "8afd5c";
		public static const COLOR_CHUAN:String = "fcc738";
		
		/**
		 *	物品不足颜色
		 */
		public static const TOOL_ENOUGH:String = "9afd5c";//足
		public static const TOOL_NOT_ENOUGH:String = "ff0000";//不足
		public static const YOU_XIA_JIAO_ENOUGH:int = 0x8afd5c;//右下角提示信息颜色(绿)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function setToolNeedNum(tool_id:int,
											  tool_name:String,
											  need_tool_num:int,
											  txt_tool_name:TextField):void
		{
			var num:int = Data.beiBao.getBeiBaoCountById(tool_id);
			
			if(num >= need_tool_num){
				
				txt_tool_name.htmlText = "<font color='#" + FontColor.TOOL_ENOUGH + "'><u>" + tool_name + "x" + need_tool_num.toString() + "</u></font>";
			}
			else{
				txt_tool_name.htmlText = "<font color='#" + FontColor.TOOL_NOT_ENOUGH + "'><u>" + tool_name + "x" + need_tool_num.toString() + "</u></font>";
			}
		}
		
		
		
		
		
		
	}
}