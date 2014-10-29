package common.utils.component
{
	import common.config.GameIni;
	import common.config.PubData;
	import common.utils.res.ResCtrl;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.BeiBaoSet;
	import netc.packets2.PacketSCGetEquipTip2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructPetEquipItem2;
	import netc.packets2.StructSCEquipTip2;
	
	import nets.packets.PacketCSGetEquipTip;
	import nets.packets.PacketSCGetEquipTip;
	
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	import ui.base.jiaose.JiaoSe;

	/**
	 *	悬浮信息【道具，装备，技能,星魂，阵法】
	 *  andy 2011-12-27
	 */
	public final class ToolTip extends EventDispatcher
	{
		//当前悬浮
		public var tip:Sprite;
		private var child:Sprite;
		private var curItem:Object;
		private var child2:Sprite;
		private static var _instance:ToolTip;

		public static function instance():ToolTip
		{
			if (_instance == null)
				_instance=new ToolTip();
			return _instance;
		}

		public function ToolTip()
		{
			tip=new Sprite();
			tip.name="pub_tip";
			tip.mouseChildren=false;
			tip.mouseEnabled=false;

			PubData.mainUI.Layer5.addChild(tip);
		}

		/**
		 *	 添加元件悬浮
		 */
		public function addTip(target:DisplayObject):void
		{
			if (target == null)
				return;
			
			
			
			target.removeEventListener(MouseEvent.ROLL_OVER, overHandle);
			target.removeEventListener(MouseEvent.ROLL_OUT, outHandle);
			
				target.addEventListener(MouseEvent.ROLL_OVER, overHandle, false, 0, true);
				target.addEventListener(MouseEvent.ROLL_OUT, outHandle, false, 0, true);
			
		}

		private function overHandle(me:MouseEvent):void
		{
			curItem=me.target;
			if (curItem.data == null)
				return;
			tip.visible=true;
			curItem.addEventListener(MouseEvent.MOUSE_MOVE, moveHandle);

			if (child != null && child.parent == tip)
			{
				tip.removeChild(child);
			}
			
			
			if (curItem.hasOwnProperty("arrBags") && curItem.arrBags is Array){
				child=ResCtrl.instance().getNewDesc(curItem.arrBags);
				tip.addChild(child);
				moveHandle();
			}else if (curItem.data != null && curItem.data is StructBagCell2 && curItem.data.sort == 13)
			{
				if ((curItem.data as StructBagCell2).equip_source == 4)
				{
					getEquipTipCompare(curItem.data as StructBagCell2, false);
				}
				else
				{
					getEquipTipCompare(curItem.data as StructBagCell2, true);
				}
			}
			else
			{
				if (curItem.data.hasOwnProperty("bagCell") && curItem.data.bagCell is StructBagCell2)
					child=ResCtrl.instance().getNewDesc(curItem.data.bagCell,curItem.name);
				else
					child=ResCtrl.instance().getNewDesc(curItem.data,curItem.name);
				if (child != null)
				{
					tip.addChild(child);
					moveHandle();
				}
			}
			overOther();
		}

		/**
		 *  2012-06-07
		 *	悬浮时执行额外功能
		 */
		private function overOther():void
		{
			if (curItem == null || child == null)
				return;
			//除了包裹，其他地方不需要【点击穿上装备】
			if (curItem.hasOwnProperty("notShowWear") && curItem.data.sort == 13)
			{
				var cnt:int=child.numChildren;
				for (var i:int=0; i < cnt; i++)
				{
					child.getChildAt(i)["mc_desc"]["txt_wear"].text="";
				}
			}
		}

		private function outHandle(me:MouseEvent):void
		{
			curItem=null;
			tip.visible=false;
			var _loc1:DisplayObject=me.target as DisplayObject;
			_loc1.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			if (child != null && child.parent == tip)
			{
				tip.removeChild(child);
			}
		}

		private function moveHandle(me:MouseEvent=null):void
		{
			if (tip.numChildren == 0)
				return;
			var _loc2:int=PubData.mainUI.mouseX + 5;
			var x_:int;
			var tip1:DisplayObject=(tip.getChildAt(0) as Sprite).getChildByName("tip1");
			var tip2:DisplayObject=(tip.getChildAt(0) as Sprite).getChildByName("tip2");
			var tip3:DisplayObject=(tip.getChildAt(0) as Sprite).getChildByName("tip3");
			if (_loc2 + tip.width > GameIni.MAP_SIZE_W&&_loc2>=GameIni.MAP_SIZE_W/2)
			{
				tip.x=_loc2 - tip.width - 10;
				if (tip3 != null)
				{
					if (tip3.x != 0)
					{
						tip3.x=0;
						tip2.x=tip3.width;
						tip1.x=tip3.width+tip2.width;
					}
				}
				else
				{
					if (tip2 != null && tip2.x != 0)
					{
						tip2.x=0;
						tip1.x=tip2.width;
					}
				}
			}
			else
			{
				tip.x=_loc2;
				if (tip3 != null)
				{
					if (tip3.x == 0)
					{
						tip1.x=0;
						tip2.x=tip1.width;
						tip3.x=tip1.width+tip2.width;
					}
				}
				else
				{
					if (tip2 != null && tip2.x == 0)
					{
						tip1.x=0;
						tip2.x=tip1.width;
					}
				}
			}
			var _loc3:int=PubData.mainUI.mouseY + 5;
			if (_loc3 + tip.height > GameIni.MAP_SIZE_H)
			{
				//因为屏幕高度小
				if (_loc3 - tip.height - 10 > 0)
				{
					tip.y=_loc3 - tip.height - 10;
				}
				else
				{
					tip.y=5;
				}
			}
			else
			{
				tip.y=_loc3;
			}

		}

		/**
		 *	移除监听
		 */
		public function removeTip(target:DisplayObject):void
		{
			target.removeEventListener(MouseEvent.ROLL_OVER, overHandle);
			target.removeEventListener(MouseEvent.ROLL_OUT, outHandle);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
		}

		/**
		 *	必须不显示
		 *  有时会因为突然失去焦点，悬浮不会消失
		 */
		public function notShow(me:MouseEvent=null):void
		{
			if (child != null && child.parent == tip)
			{
				tip.removeChild(child);
			}
		}

		/**
		 *	重置悬浮
		 *  包裹有一个装备，身上有一个装备，当点击包裹穿上装备后，脱下的装备出现在包裹立即更换悬浮
		 **/
		public function resetOver():void
		{
			if (this.curItem != null && curItem.data != null)
			{
				if (curItem.data is StructBagCell2)
				{
					(curItem as DisplayObject).dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
					//getEquipTipCompare(curItem.data);
				}
			}
		}

		/**
		 *	获得装备悬浮信【比较】
		 */
		public function getEquipTipCompare(data:StructBagCell2, isCompare:Boolean=true):void
		{
			if (data == null)
				return;
			var bags:Array=new Array;
			bags.push(data);
			//比较id
			var compareId:int=0;
			if ( data.pos <= BeiBaoSet.CANGKU_END_INDEX||
				(data.pos>=BeiBaoSet.XUN_BAO_INDEX&&data.pos<=BeiBaoSet.XUN_BAO_END_INDEX))
				compareId=data.itemid;
			if (isCompare && compareId > 0)
			{
				//和谁比较【主角还是伙伴】
				var compareWho:int=0;

				var pos:int=data.equip_type;
				switch (compareWho)
				{
					case 0:
						var arr:Array=Data.beiBao.getRoleEquipByType(data.equip_type);
						if (arr != null && arr.length > 0)
							bags=bags.concat(arr);
						break;
					default:
						break;
				}
			}

			child=ResCtrl.instance().getNewDesc(bags);
			tip.addChild(child);
			moveHandle();
		}

		public function addMCTip(target:Object, mcTip:Sprite, targetData:Object=null, targetDataElement:Array=null):void
		{
			if (target == null)
				return;
			if (!target.hasEventListener(MouseEvent.MOUSE_OVER))
			{
				target.addEventListener(MouseEvent.MOUSE_OVER, targetOverHandler);
			}
			try
			{
				target["funcOver"]=targetOverHandler;
			}
			catch (e:Error)
			{
							}
			function targetMoveHandler(e:MouseEvent):void
			{
				mcTip.visible=true;
				mcTip.x=PubData.mainUI.mouseX;
				if (mcTip.x + mcTip.width > GameIni.MAP_SIZE_W)
				{
					mcTip.x-=mcTip.width + 5;
				}
				else
				{
					mcTip.x+=5;
				}
				mcTip.y=PubData.mainUI.mouseY + 5;
				if (mcTip.y + mcTip.height > GameIni.MAP_SIZE_H)
				{
					mcTip.y-=mcTip.height + 5;
				}
				else
				{
					mcTip.y+=5;
				}
				if (mcTip.y < 0)
					mcTip.y=0;
			}
			function targetOutHandler(e:MouseEvent):void
			{

				if (null != mcTip.parent)
				{
					//PubData.mainUI.removeChild(mcTip);
					mcTip.parent.removeChild(mcTip);
				}

				target.removeEventListener(MouseEvent.MOUSE_OUT, targetOutHandler);
				target.removeEventListener(MouseEvent.MOUSE_MOVE, targetMoveHandler);
				// mcTip.visible=false;
			}
			function targetOverHandler(e:MouseEvent):void
			{
				mcTip.visible=false;
				PubData.mainUI.Layer5.addChild(mcTip);
				mcTip.name="WARREN_TIP";
				mcTip.mouseChildren=false;
				target.addEventListener(MouseEvent.MOUSE_OUT, targetOutHandler);
				target.addEventListener(MouseEvent.MOUSE_MOVE, targetMoveHandler);
				if (targetData == null)
				{
					for (var s:String in target)
					{
						if (target[s] == null)
						{
							delete target[s];
						}
						else if (mcTip.hasOwnProperty(s))
						{
							// fux_lang_xml
							if (target[s] as TextField)
							{
								mcTip[s].text=(target[s] as TextField).text;
							}
							else
							{
								mcTip[s].text=target[s];
							}
								// mcTip[s].text = target[s];
						}
					}
				}
				else
				{
					for (var i:int=0; i < targetDataElement.length; i++)
					{
						mcTip["t" + (i + 1)].text=targetData[targetDataElement[i]];
					}
				}

				mcTip.x=0;
				mcTip.y=0;
			}
		}
	}
}
