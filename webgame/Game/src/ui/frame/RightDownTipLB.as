package ui.frame
{
	import common.managers.Lang;
	import common.utils.CtrlFactory;
	
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	import netc.Data;
	
	import ui.base.beibao.BeiBao;
	import ui.base.jiaose.JiaoSe;
	
	/**
	 * 礼包 
	 * @author steven guo
	 * 
	 */	
	public class RightDownTipLB extends RightDownTip
	{
		public function RightDownTipLB()
		{
			m_links = "win_newgift";

			_init();
		}
		
		override protected function clickListener(e:MouseEvent):void
		{
			switch(e.target.name){
				case "submit":
					//礼包
					_useItem(m_itemData.pos);
					
					if(m_itemData.itemid==10200011)
					{
						
						//引导人物一键装备
						
					}
					else if(20 == Data.myKing.level)
					{
						
						//引导宠物一键装备
					}
					else
					{
						//直接开启背包
//						BeiBao.getInstance().open(true);
					}
					close();
					break;
				case "btnClose":
					close();
					break;
				default:
					break;
			}
			
			
		}
		
		override protected function repaint():void
		{
			if(null == mc)
			{
				return ;
			}
			var sprite:MovieClip= mc["itemIcon"]; 
			

			if(2 == m_itemData.sort && m_itemData.itemid >= 10200018  && m_itemData.itemid<= 10200025)
			{
				//宝箱 ，从中过滤出关于 礼包的物品  tool_level 表示 礼包的等级
				mc["tf"].htmlText = "<font><b>"+Lang.getLabel("40026_huode_xin_zhuangbei" ,[m_itemData.level] )+"</b></font>";
				//mc["submit"].label = "立即使用";
				mc["submit"].label = Lang.getLabel("50005_RightDownTip");
				
				
				m_is = true;
			}
			
			
			//mc["miaoshu"].htmlText = m_description;
			
			if(null != m_itemData)
			{
				ItemManager.instance().setToolTipByData(mc["itemIcon"],m_itemData,1);
			}
			else
			{
				ItemManager.instance().setEquipFace(mc["itemIcon"],false);
				
				CtrlFactory.getUIShow().removeTip(sprite);
			}
		}
		
		
		
	}
	
	
	
}


