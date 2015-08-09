package ui.view.view2.mrfl_qiandao
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.base.huodong.HuoDongBridge;
	import ui.view.view2.mrfl_qiandao.DuiHuanLiBao_CDKey;
	import ui.view.view2.mrfl_qiandao.QianDao;
	import ui.view.view2.mrfl_qiandao.QianDaoPage_2;
	
	/**
	 *每日福利 
	 * @author Administrator
	 * 
	 */
	public class MeiRiFuLiWin extends UIWindow
	{
		private static var m_instanc:MeiRiFuLiWin
		public function MeiRiFuLiWin()
		{
			super(getLink(WindowName.win_mei_ri_fu_li));
		}
		public static function getInstance():MeiRiFuLiWin
		{
			if (m_instanc == null)
			{
				m_instanc=new MeiRiFuLiWin();
			}
			return m_instanc;
		}
		override public function get width():Number
		{
			return 550;
		}
		
		override public function get height():Number
		{
			return 510;
		}
		public function setType(v:int):void{			
			
			type=v;
			super.open();
		}
		override protected function openFunction():void{
			init();
		}
		override protected function init():void
		{
			super.blmBtn=3
			if(type==0)type=1;
			
			mcHandler({name:"cbtn"+type});
		}
		private var delayTime:Number=0;
		private var date:Date;
		override public function mcHandler(target:Object):void
		{
			
			var name:String=target.name;
			date = new Date();
			var ddd:int = date.time-delayTime
			if (name.indexOf("cbtn") >= 0)
			{
				if(date.time-delayTime<400){
					return;
				}else
					super.mcHandler(target);
				delayTime=date.time;
				this.type=int(name.replace("cbtn", ""));
				(this.mc as MovieClip).gotoAndStop(type);
				if(type==3){
					
					
					mc["scollrDuihuanBar"].visible = true;
					mc["spdes"].visible = false;
					DuiHuanLiBao_CDKey.getInstance().setMc(mc as MovieClip);
					return;
				}else if(type ==2){
					QianDaoPage_2.getInstance().setUi(mc);
				}else if(type ==1){
					QianDao.getInstance().setUI(mc);
				}
				return;
			}
			super.mcHandler(target);
			if(type==1){
				QianDao.getInstance().mcHandler(target);
			}else if(type==2){
				QianDaoPage_2.getInstance().mcHandler(target);
			}else if(type==3){
				DuiHuanLiBao_CDKey.getInstance().mcHandler(target);
			}
		}
		//窗口关闭事件
		override protected function windowClose():void
		{
			(this.mc as MovieClip).gotoAndStop(1); 
			super.windowClose();
		}
	}
}