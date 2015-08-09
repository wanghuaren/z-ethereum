package ui.view.newFunction
{
	import com.engine.utils.HashMap;
	
	import common.config.GameIni;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_Interface_ClewResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import netc.Data;
	
	import ui.base.renwu.MissionMain;

	//新功能判断逻辑
	public class FunJudge
	{
		public function FunJudge()
		{
		}
		/**
		 *	限制数据初始化
		 */
		private static var mapName:HashMap;

		private static function init():void
		{
			if (mapName == null)
			{
				mapName=new HashMap();
				var vec:Vector.<Pub_Interface_ClewResModel>=XmlManager.localres.getInterfaceClewXml.getResPath_BySort(1) as Vector.<Pub_Interface_ClewResModel>;
				for each (var item:Pub_Interface_ClewResModel in vec)
				{
					mapName.put(StringUtils.trim(item.ui_name), item);
				}
			}
		}
		/**
		 *	非窗体限制【某个面板的按钮 如：炼丹炉 升级 重铸】
		 */
		public static const CHONG_XING:String="btn_chon_gxing";
		public static const JIANDING:String="btn_jian_ding";
		public static const BAO_SHI:String="btn_bao_shi";
		public static const TUN_SHI:String="btn_tun_shi";
		public static const CHUAN_CHENG:String="btn_chuan_cheng";
		public static const ZHU_SHEN:String="btn_zhu_shen";
		public static const JUE_XING:String="btn_jue_xing";

		/**
		 *	点击打开窗体 判断限制开放等级【增加时需要和策划协商添加】
		 *  @param mcName 窗体名字
		 *  @param isShow 是否显示预告【废弃】
		 */
		public static function judgeByName(mcName:String, isShow:Boolean=true):Boolean
		{
			init();
			var ret:Boolean=true;
			var _kingLevel:int=Data.myKing.level;
			if (mapName.containsKey(mcName))
			{
				var item:Pub_Interface_ClewResModel=mapName.getValue(mcName);
				//调试环境功能直接打开【有的功能靠任务打开，屏蔽才可测试】
				if (GameIni.urlval == null && item.need_task > 0)
					return true;
				if ((item.need_task == 0 && _kingLevel < item.ui_level) || (item.need_task > 0 && MissionMain.instance.checkHistoryTaskIsHave(item.need_task) == false))
				{
					ret=false;
					if (isShow)
						Lang.showMsg(Lang.getClientMsg("pub_param", [item.msg]));
				}
			}
			return ret;
		}

		/**
		 *	根据升级等级，判断是否有开启新功能
		 *  2013-06-19 andy
		 */
		public static function checkLevel():void
		{
			init();
			var _kingLevel:int=Data.myKing.level;
			for each (var item:Pub_Interface_ClewResModel in mapName.values())
			{
				if (_kingLevel == item.ui_level && item.show_index >= 0)
				{
					excute(item);
//					break;
				}
			}
		}

		/**
		 *	根据完成任务，判断是否有开启新功能
		 *  2013-06-19 andy
		 */
		public static function checkTask(taskId:int):void
		{
//			init();
//			var _kingLevel:int = Data.myKing.level;
//			for each(var item:Pub_Interface_ClewResModel in mapName.values()){
//				if(taskId==item.need_task){
//					excute(item);
//					break;
//				}
//			}
		}

		private static function excute(item:Pub_Interface_ClewResModel):void
		{
			if (item.is_show == 1)
			{
				//要显示预告
				NewFunction.instance().setData(item);
			}
			else
			{
			}
		}

		public static function judgeByNameEqual(mcName:String):Boolean
		{
			init();
			var _kingLevel:int=Data.myKing.level;
			var _ret:Boolean=false;
			if (mapName.containsKey(mcName))
			{
				var item:Pub_Interface_ClewResModel=mapName.getValue(mcName);
				if (_kingLevel == item.ui_level)
				{
					_ret=true;
				}
			}
			return _ret;
		}

		/**
		 *	根据窗体名字获得开启等级
		 */
		public static function getNameLevel(mcName:String):int
		{
			init();
			var ret:int=0;
			var item:Pub_Interface_ClewResModel=mapName.getValue(mcName);
			if (item != null)
				ret=item.ui_level;
			return ret;
		}
	}
}
