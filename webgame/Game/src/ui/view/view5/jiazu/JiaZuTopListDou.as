package ui.view.view5.jiazu
{
	import common.utils.clock.GameClock;
	
	import display.components.MoreLessPage;
	
	import engine.event.DispatchEvent;
	
	import common.config.GameIni;
	
	import model.jiazu.JiaZuEvent;
	import model.jiazu.JiaZuModel;
	
	import netc.Data;
	import netc.packets2.PacketSCGuildMeleeData2;
	import netc.packets2.StructGuildInfo2;
	import netc.packets2.StructGuildRankList2;
	
	import nets.packets.PacketCSMeleeRankList;
	import nets.packets.PacketSCGuildMeleeData;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view5.saloon.SaloonTopList;
	
	import world.WorldEvent;
	
	/**
	 * 家族排行版面板【大乱斗】 
	 * @author andy 2012-09-04
	 * 
	 */	
	public class JiaZuTopListDou extends UIWindow
	{
		private var guild:PacketSCGuildMeleeData
		private static var _instance:JiaZuTopListDou;
		public static function getInstance():JiaZuTopListDou
		{
			if(null == _instance)
			{
				_instance = new JiaZuTopListDou();
			}
			
			return _instance;
		}
		
		public function JiaZuTopListDou()
		{
			super(getLink(WindowName.win_jz_dou_list));
		}
		
		//面板初始化
		override protected function init():void 
		{
			this.x=GameIni.MAP_SIZE_W-mc.width-200;
			this.y=GameIni.MAP_SIZE_H/2-mc.height/2;
			
			//2012-09-06 andy 家族大乱斗排行榜刷新【5秒刷新一次】
			super.uiRegister(PacketSCGuildMeleeData.id,refresh);
			
			super.sysAddEvent(GameClock.instance,WorldEvent.CLOCK_TEN_SECOND,send5second);
			send5second();	
		}	
		
		
		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;
			switch(name)
			{
				case "btn_jiang4":
					SaloonTopList.getInstance().saloon_id = 4;
					SaloonTopList.getInstance().open();
					
					break;
				default:
					break;
			}
		}
		
		/**
		 *	10秒发送，客户端自己发送 
		 */
		private function send5second(we:WorldEvent=null):void{
			var client:PacketCSMeleeRankList=new PacketCSMeleeRankList();
			super.uiSend(client);
		}
		
		/**
		 *	显示信息 
		 */
		private function refresh(p:PacketSCGuildMeleeData):void{
			guild=p;
			show();
		}
		
		
		public function show():void{
			if(guild==null)return;
			var vec:Vector.<StructGuildRankList2>=guild.arrItemranklist;
			var len:int=vec.length;
			for(i=1;i<=5;i++){
				child=mc["item"+i];
				if(child==null)continue;
				if(i<=len){
					child["txt_name"].text=vec[i-1].guildName;
					child["txt_score"].text=vec[i-1].value;
					child.data=vec[i-1];
				}else{
					child["txt_name"].text="";
					child["txt_score"].text="";
				}
			}	
			mc["txt_cur_sort"].text=guild.guildno;
			mc["txt_score_total"].text=guild.guildvalue;
			mc["txt_kill_num"].text=guild.killnum;
			mc["txt_jz_score"].text=guild.playervalue;
		}
		
		override public function winClose():void
		{
			super.winClose();
			
		}
	}
	
	
}





