package ui.view.view1.fuben
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_InstanceResModel;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	import common.managers.Lang;
	
	import engine.support.IPacket;
	
	import netc.DataKey;
	import netc.packets2.StructPlayerInstanceInfo2;
	
	import nets.packets.PacketCSPlayerInstanceInfo;
	import nets.packets.PacketSCPlayerInstanceInfo;
	
	import ui.base.fuben.FuBenMain;
	
	/**
	 *	选择副本面板
	 *  suhang 2012-2-13
	 */
	//public class FuBen extends UIWindow
	public class FuBen
	{
		//amd副本数据
		//private var instanceVec:Vector.<Pub_InstanceResModel> = new Vector.<Pub_InstanceResModel>;
		public static var instanceVec:Vector.<Pub_InstanceResModel> = new Vector.<Pub_InstanceResModel>;
		
		public static var instanceVecBySerieSort:Vector.<Pub_InstanceResModel> = new Vector.<Pub_InstanceResModel>;
		//public static var instanceVec2:Vector.<Pub_InstanceResModel> = new Vector.<Pub_InstanceResModel>;
		
		//服务器发来的副本信息
		//private var siiVec:Vector.<StructPlayerInstanceInfo2>;
		public static var siiVec:Vector.<StructPlayerInstanceInfo2>;
		
		//
		public static var exptime:int;
		
		/**
		 * 指定分类
		 */ 
		public static var serieSort:int = 0;
				

		public static function getSelectedData():Pub_InstanceResModel
		{
			return FuBen.instance.selectedData;
		}
		
		private static var _instance :FuBenMain = null;
		
		public static function get instance() : FuBenMain {
			if (null == _instance)
			{
				_instance= FuBenMain.instance;
			}
			else
			{
				if(FuBenDuiWu._instance==null||FuBenDuiWu._instance.parent==null){
					
				}else{
					_instance.alert.ShowMsg(Lang.getLabel("20022_FuBen"),1);
				}
			}
			
			return _instance;
		}
		
		public static function hasInstance():Boolean
		{
			if(null == _instance)
			{
				return false;
			}
			
			return true;
		}
		
		public static function init2():void
		{
			DataKey.instance.register(PacketSCPlayerInstanceInfo.id,SCPlayerInstanceInfo2);
		
			var vo:PacketCSPlayerInstanceInfo=new PacketCSPlayerInstanceInfo();
			
			DataKey.instance.send(vo);
			
		}	
		
		public static function SCPlayerInstanceInfo2(p:IPacket) : void {
			var value:PacketSCPlayerInstanceInfo = p as PacketSCPlayerInstanceInfo;
			siiVec = value.arrIteminstanceinfo;
			
		}
		
		//显示副本列表
		public static var _vecCompleteCount:int;
		public static function get isVecCompleteCountFull():Boolean
		{
			//if(3 == _vecCompleteCount)
			if(4 == _vecCompleteCount)
			{
				return true;
			}
			
			return false;
		}
		
		public static var _vec1CompleteCount:int;
		public static var _isVec1CompleteCount:Boolean;
		
		public static function get isVec1CompleteCount():Boolean
		{
			
			return _isVec1CompleteCount;
			
		}
		
		//
		public static var _vec2CompleteCount:int;
		public static var _isVec2CompleteCount:Boolean;
		
		public static function get isVec2CompleteCount():Boolean
		{
			
			return _isVec2CompleteCount;
			
		}
		
		public static function showListData():void
		{
			
			//
			_vecCompleteCount = 0;
			instanceVec.forEach(callbackByList_Data);	
			
		}
		
		public static function callbackByList_Data(itemData:Pub_InstanceResModel,
										index:int,
										arr:Vector.<Pub_InstanceResModel>):void 
		{
			
			
			
			//
			var sii:StructPlayerInstanceInfo2;
			
			for each(var spii:StructPlayerInstanceInfo2 in siiVec)
			{
				if(spii.instanceid == itemData.instance_id)
				{
					sii = spii;
					break;
				}
			}
			
			var limit:Pub_Limit_TimesResModel = XmlManager.localres.limitTimesXml.getResPath(itemData.instance_times) as Pub_Limit_TimesResModel;
						
			var curNum:int = (sii==null?0:sii.curnum);
			var maxNum:int = (limit!=null?limit.max_times:1);
			
			//活动编号 :
			//福溪村幻境 20004
			//守护玄黄剑 20001
			//深渊鬼蜮 20005
			/*&&				
			(itemData.instance_id == 20004 ||
			itemData.instance_id == 20001 ||
			itemData.instance_id == 20005)*/
			
			if(curNum == maxNum)
			{
				_vecCompleteCount++;
			}
			
			
			if(sii==null){
				sii = StructPlayerInstanceInfo2.getInstance().getItem;
				sii.instanceid = itemData.instance_id;
				sii.curnum = 0;
			}
			sii.maxnum = limit!=null?limit.max_times:1;
			
			//sprite.data = sii;
			//sprite.data = itemData;			
			//sprite.data2 = sii;
			
			//sprite.mouseChildren = false;
			//sprite.buttonMode = true;		
			
			//
			//sprite.removeEventListener(MouseEvent.CLICK, itemClickByList);
			//sprite.addEventListener(MouseEvent.CLICK, itemClickByList);
			
			//
			//mc_content.addChild(sprite);		
			
		}
		
		
		
		
		
		
	}
}