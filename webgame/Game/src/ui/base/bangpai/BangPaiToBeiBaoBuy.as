package ui.base.bangpai
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.*;
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	import engine.load.GamelibS;
	import engine.support.IPacket;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.*;
	
	import nets.packets.*;
	
	import ui.base.npc.NpcShop;
	import ui.base.vip.VipGift;
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;

	public class BangPaiToBeiBaoBuy extends UIWindow
	{
		private var bag:StructBagCell2;

		private static var _instance:BangPaiToBeiBaoBuy;

		public static function get instance():BangPaiToBeiBaoBuy
		{
			if (null == _instance)
			{
				_instance=new BangPaiToBeiBaoBuy();
			}
			return _instance;
		}

		public function BangPaiToBeiBaoBuy()
		{
			super(getLink(WindowName.win_bang_pai_buy));

		}
		/**
		 * 0 商店
		 * 1 帮贡
		 * */
		private var buyModel:int=0;

		/**
		 *
		 */
		public function setData(v:StructBagCell2, model:int=0):void
		{
			buyModel=model;
			bag=v;
			super.open(true);
		}

		override protected function openFunction():void
		{
			init();
		}

		override protected function init():void
		{

			(mc["txt_price"] as TextField).type=TextFieldType.DYNAMIC;
			mc["txt_price"].text=bag.need_contribute;

			(mc["txt_price"] as TextField).restrict="0-9";
			(mc["txt_price"] as TextField).maxChars=12;

//			mc["item"]["uil"].source=bag.icon;
			ImageUtils.replaceImage(mc["item"],mc["item"]['uil'],bag.icon);
			//mc["item"]["txt_num"].text=bag.num;
			mc["item"]["txt_num"].text='';
			mc["txt_name"].text=bag.itemname;
			mc["item"].data=bag;
			CtrlFactory.getUIShow().addTip(mc["item"]);

			this.uiRegister(PacketWCGuildGetBankItem.id, WCGuildGetBankItem);
			this.uiRegister(PacketSCGuildGetShopItem.id, BackSCGuildGetShopItem);
		}

		public function WCGuildGetBankItem(p:PacketWCGuildGetBankItem2):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
				}
			}
		}

		public function BackSCGuildGetShopItem(p:PacketSCGuildGetShopItem):void
		{
						if (p.hasOwnProperty('tag'))
			{
				if (super.showResult(p))
				{
					this.winClose();
					BangPaiMain.instance.getData(true);
				}
			}
		}

		override public function mcHandler(target:Object):void
		{
			var name:String=target.name;
			if (name.indexOf("item") >= 0)
			{
				type=int(name.replace("item", ""));

				return;
			}

			switch (target.name)
			{
				case "btnUp":
				case "btnBuy":
					//购买物品
					//alert.ShowMsg(Lang.getLabel("10181_booth",[bag.booth_price,bag.num,bag.itemname]),4,null,boothBuy);
					if (buyModel == 0)
					{
						var cs:PacketCSGuildGetBankItem=new PacketCSGuildGetBankItem();
						cs.pos=bag.pos;
						uiSend(cs);
					}
					else
					{
						var csShop:PacketCSGuildGetShopItem=new PacketCSGuildGetShopItem();
						csShop.itemid=bag.itemid;
						uiSend(csShop);
					}
					break;

				default:
					break;

			}
		}





	}
}
