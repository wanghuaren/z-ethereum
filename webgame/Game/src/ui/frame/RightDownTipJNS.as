package ui.frame
{
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	import common.utils.res.ResCtrl;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import ui.base.beibao.BeiBao;
	import ui.base.jineng.SkillShort;
	
	import world.WorldEvent;
	
	/**
	 * 技能书
	 * @author steven guo
	 * 
	 */	
	public class RightDownTipJNS extends RightDownTip
	{
		
		public function RightDownTipJNS()
		{
			m_links = WindowName.win_skill_book_tip;
			
			_init();
			if(this.mc!=null)
			this.mc.visible=false;
		}
		
		//2013-06-17 andy 点击连接学习装配
		override protected function _init():void{
			super._init();
	
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
		}
		
		/**
		 *	倒计时 【20秒没有点击，自动学习并关闭】
		 */
		private var cnt:int=0;
		private function timerHandler(e:TimerEvent):void{
			if(cnt>=1){
				cnt=0;
				study();
				return;
			}
			cnt++;
		}
		
		private function study():void{
			if(m_itemData==null)return;
			if(mc==null)return;
			SkillShort.setFlyStartPostion(mc["itemIcon"]);
			
			BeiBao.getInstance().useItem(m_itemData.pos);
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
			
			//var msg:String=Lang.getLabel("10213_rightdowntipjns",[m_itemData.itemname,"<font color='#"+ResCtrl.instance().arrColor[m_itemData.toolColor]+"'><b>"+m_itemData.itemname+"</b></font>"]) ;
			var msg:String=Lang.getLabel("10213_rightdowntipjns",[m_itemData.itemname,m_itemData.itemname]) ;
			Lang.showMsg({type:4,msg:msg});
			
			close();
		}
		
		override protected function clickListener(e:MouseEvent):void
		{
			switch(e.target.name){
				case "btnClose":
				case "btnclose":
					close();
					break;
				default:
					study();
					break;
			}

			
			
		}
		
		
		
		override protected function repaint():void
		{
			if(null == mc)
			{
				return ;
			}
			mc["mc_bg"].mouseChildren=false;
			(mc["mc_bg"] as MovieClip).buttonMode=true;
			(mc["mc_bg"] as MovieClip).useHandCursor=true;
			var sprite:MovieClip= mc["itemIcon"]; 
			sprite.mouseChildren=false;
			sprite.buttonMode=true;

			//装备	
			mc["tf"].mouseEnabled=false; 
			mc["tf"].htmlText =Lang.getLabel("10213_rightdowntipjns",[m_itemData.itemname,"<font color='#"+ResCtrl.instance().arrColor[m_itemData.toolColor]+"'><b>"+m_itemData.itemname+"</b></font>"]) ;
	
			if(null != m_itemData)
			{
				ItemManager.instance().setToolTipByData(sprite,m_itemData,1);
			}
			else
			{
				ItemManager.instance().removeToolTip(sprite);
			}
		}
		
		
		
		
		
	}
}