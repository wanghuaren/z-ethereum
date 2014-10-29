package ui.frame
{
	import com.greensock.TweenLite;
	
	import common.config.PubData;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import netc.Data;
	import netc.DataKey;
	import netc.packets2.StructBagCell2;
	
	import nets.packets.PacketCSEquipItem;
	import nets.packets.PacketCSUseItem;
	import nets.packets.PacketSCUseItem;
	
	
	/**
	 * 游戏右下角的提示窗口
	 * @author steven guo
	 * 
	 */	
	public class RightDownTip
	{
		protected var mc:DisplayObject;
		
		protected var m_iconPath:String = "";
		
		protected var m_name:String = "";
		
		protected var m_description:String = "";
		
		protected var m_itemData:StructBagCell2 = null;
		
		/**
		 * 判断 是 礼包 还是 装备      true 表示礼包 ，  false 表示装备 
		 */		
		protected var m_is:Boolean ; 
		
		protected var m_links:String = "win_equip";
		
		public function RightDownTip()
		{
			
		}
		
		protected function _init():void
		{
			if(null == mc)
			{
				mc = GamelibS.getswflink("game_index1",m_links);
			}
			
			
			if(null != mc)
			{
				mc.addEventListener(MouseEvent.CLICK,clickListener);
	
				if(mc.hasOwnProperty("mc_effect"))
				{
					mc["mc_effect"].mouseEnabled = false;
					mc["mc_effect"].mouseChildren = false;
				}
				
				DataKey.instance.register(PacketSCUseItem.id,_SCUseItem);
			}
		
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		protected function replace():void
		{
			if(null == mc)
			{
				return ;
			}
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				if(m_links==WindowName.win_skill_book_tip){
					//技能书淡出效果
					/**m_gPoint.x = (mc.stage.stageWidth-mc.width)/2;
					m_gPoint.y = mc.stage.stageHeight-230;
					
					m_lPoint = mc.parent.globalToLocal(m_gPoint);
					
					mc.x = m_lPoint.x;
					mc.y = m_lPoint.y;
					
					mc.alpha=.2;

					
					TweenLite.to(mc, 2, {alpha:1});*/
				}else{
					m_gPoint.x = mc.stage.stageWidth /2+320;
					if(mc.stage.stageWidth /2-320<mc.width) {
						m_gPoint.x=mc.stage.stageWidth-mc.width;
					}
					m_gPoint.y = mc.stage.stageHeight;
					
					m_lPoint = mc.parent.globalToLocal(m_gPoint);
					
					mc.x = m_lPoint.x;
					mc.y = m_lPoint.y;
					
					mc.alpha=.5
					var _targetY:int = 220//mc.stage.stageHeight - mc.height + 60;
					
					//加了个延时显示 saiman
					TweenLite.to(mc, 1, {y:_targetY,alpha:1,delay:1.1});
					
					
				}
			}
			
		}
		
		
		public function open():void
		{
			_init();
			
			if(null == mc)
			{
				return ;
			}
			PubData.mainUI.AlertUI.addChild(mc);
			
			repaint();
			replace();
		}
		
		public function close():void
		{
			if(null != mc && null != mc.parent)
			{
				mc.parent.removeChild(mc);
			}
			
			_dispose();
		}
		
		
		protected function _dispose():void
		{
			if(mc)
			{
				if(mc["itemIcon"]!=null){
					if(mc["itemIcon"]["uil"]!=null)
						mc["itemIcon"]["uil"].source = "";
					mc["itemIcon"]["data"] = null;
				}
					
				mc["tf"].htmlText = "";
				//mc["miaoshu"].htmlText = "";
				
			}
			
			m_itemData = null;
		}
		
		public function setData(iconPath:String , name:String , description:String):void
		{
			m_iconPath = iconPath;
			m_name = name;
			m_description = description;
		}
		
		public function setDataByStructBagCell2(item:StructBagCell2):void
		{
			setData(item.icon,item.itemname,item.desc);
			
			m_itemData = item;
		}
		
		
		protected function repaint():void
		{
			
			
		}
		
		protected function clickListener(e:MouseEvent):void
		{
			switch(e.target.name){
				case "submit":
					//	Jineng.instance.open(true);
					//BeiBao.getInstance().open(true);
					
					if(m_is)
					{
						//礼包
						if (null != m_itemData)
							_useItem(m_itemData.pos);
					}
					else
					{
						//装备
						if(Data.myKing.level >= 1 && Data.myKing.level<= 12 && null != m_itemData)
						{
							//1－12级  给人物穿上
							_equipOn(m_itemData.pos);
						}
					}
					
					
					close();
					break;
				case "btnClose":
					close();
					break;
			}
			
			
		}
		
		/**
		 *	穿装备【主角】 
		 */
		protected function _equipOn(pos:int=0,equip_pos:int=0):void{
			var cleint:PacketCSEquipItem=new PacketCSEquipItem();
			cleint.srcindex=pos;
			cleint.equip_pos=equip_pos;
			DataKey.instance.send(cleint);
		}
		
		
		/**
		 *	使用道具 
		 */
		public function _useItem(pos:int=0):void{
			
			var cleint:PacketCSUseItem=new PacketCSUseItem();
			cleint.bagindex=pos;
			DataKey.instance.send(cleint);
		}
		
		public function _SCUseItem(p:PacketSCUseItem):void
		{
			
			if(0 != p.tag)
			{
				Lang.showResult(p);
				return ;
			}
		}
	}
	
}







