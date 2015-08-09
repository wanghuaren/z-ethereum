package ui.view.view2.mrfl_qiandao
{
	import common.config.xmlres.server.Pub_DropResModel;
	import common.managers.Lang;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import netc.DataKey;
	import netc.packets2.StructCDKey2;
	import nets.packets.PacketCSExchangeCDKey;
	import nets.packets.PacketCSGetCDKeyInfo;
	import nets.packets.PacketSCExchangeCDKey;
	import nets.packets.PacketWCGetCDKeyInfo;
	import ui.frame.UIWindow;
	import ui.view.view1.ExchangeCDKey;

	public class DuiHuanLiBao_CDKey
	{
		private static var m_instance:DuiHuanLiBao_CDKey;
		private var mc:MovieClip;

		public function DuiHuanLiBao_CDKey()
		{
//			HuoDongZhengHe.scExchangeCDkeyFun = scExchangeSuccess;
		}

		public static function getInstance():DuiHuanLiBao_CDKey
		{
			if (null == m_instance)
			{
				m_instance=new DuiHuanLiBao_CDKey();
			}
			return m_instance;
		}

		public function setMc(v:MovieClip):void
		{
			mc=v;
			_initCom();
			DataKey.instance.register(PacketWCGetCDKeyInfo.id, getCDKeyInfoCallback);
			DataKey.instance.register(PacketSCExchangeCDKey.id, SCExchangeCDKey);
			mc['duihuanpanle'].visible=false;
			_onFrameScript_CDkey();
		}

		private function _onFrameScript_CDkey():void
		{
			if (3 != (mc as MovieClip).currentFrame)
			{
				return;
			}
			else
			{
				sendCSGetCDKeyInfo();
			}
		}

		private function sendCSGetCDKeyInfo():void
		{
			var p:PacketCSGetCDKeyInfo=new PacketCSGetCDKeyInfo();
			DataKey.instance.send(p);
		}

		private function SCExchangeCDKey(p:PacketSCExchangeCDKey):void
		{
			Lang.showMsg(Lang.getServerMsg(p.tag));
			if (p.tag == 0)
			{
				scExchangeSuccess();
			}
			else
			{
			}
		}

		/**兑换成功 回调函数
		 */
		public function scExchangeSuccess():void
		{
			mc['duihuanpanle']["txt"].text="";
			mc['duihuanpanle'].visible=false;
			Lang.showMsg(Lang.getClientMsg('20079_Huodonghecheng_Dunhuan'));
		}

		private function getCDKeyInfoCallback(p:IPacket):void
		{
			var _p:PacketWCGetCDKeyInfo=p as PacketWCGetCDKeyInfo;
			var obj:Object=new Object();
			obj.arrItems=_p.cdkeyinfo.arrItemitems;
			setDuihuanPanel(obj);
		}

		private function setDuihuanPanel(obj:Object):void
		{
			var objd:Object=obj;
			if (null == mc)
			{
				return;
			}
			var arritem:Vector.<StructCDKey2>=objd.arrItems;
			var spstruct:Sprite=new Sprite();
			for (var i:int=0; i < arritem.length; i++)
			{
//				var dd:Pub_DropResModel = 
				var c:Class=GamelibS.getswflinkClass('game_index', "duihuanItem");
				var sp:Sprite=new c() as Sprite;
				var hdzhItem:DuiHuanLiBaoItem=new DuiHuanLiBaoItem(sp, StructCDKey2(arritem[i]))
				spstruct.addChild(hdzhItem);
				sp.y=102 * i;
			}
			mc["scollrDuihuanBar"].visible=true;
			mc['scollrDuihuanBar'].source=spstruct;
		}

		private function _initCom():void
		{
		}
		private var CDkeyType:int=0;

		// 面板点击事件
		public function mcHandler(target:Object):void
		{
			switch (target.name)
			{
				case "duihuan":
					var str:String=mc['duihuanpanle']["txt"].text;
					var type:int=CDkeyType;
					sendDuihuanCDkey(str, type);
					break;
				case "btnClose_duihuan":
				case "btn_centrl":
					mc['duihuanpanle'].visible=false;
					break;
				case "btnSubmit":
					var item:DuiHuanLiBaoItem=target.parent.parent.parent as DuiHuanLiBaoItem;
					mc['duihuanpanle']["txt"].text="";
					CDkeyType=item.m_id;
					mc['duihuanpanle'].visible=true;
					break;
				case "submit":
					break;
			}
		}

		public function sendDuihuanCDkey(str:String, type:int):void
		{
			if (str == "")
				return;
			var vo:PacketCSExchangeCDKey=new PacketCSExchangeCDKey();
			vo.cdkey=str;
			vo.type=type
			DataKey.instance.send(vo)
		}
	}
}
