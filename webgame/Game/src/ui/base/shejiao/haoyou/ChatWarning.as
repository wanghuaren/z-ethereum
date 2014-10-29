package ui.base.shejiao.haoyou
{
	import engine.load.GamelibS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import netc.packets2.PacketSCSayPrivate2;
	
	import scene.music.GameMusic;
	import scene.music.WaveURL;
	
	import ui.frame.ImageUtils;
	
	import world.FileManager;

	/**
	 *	好友私聊警告信息元件
	 *  andy 2012-03-23 
	 */
	public class ChatWarning extends Sprite{
		public var roleId:int;
		public var playerInfo:PacketSCSayPrivate2;
		
		private var mc:MovieClip;
		
		public function ChatWarning()
		{
			mc=GamelibS.getswflink("game_index","ChatWarningOne") as MovieClip;
			this.mouseChildren=false;
			this.buttonMode=true;
			this.addChild(mc);
			this.visible=false;
			playEffect(false);
			
		}
		
		public function setData(v:PacketSCSayPrivate2):void{
			roleId=v.userid;
			playerInfo=v;
//			mc["uil"].source=FileManager.instance.getHeadIconSById(v.headicon);
			ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconMById(v.headicon));
			mc["mc_name"]["txt_name"].text=playerInfo.username;
			mc["mc_name"].visible=false;
		}
		public function showName(v:Boolean=false):void{
			mc["mc_name"].visible=v;
		}
		
		public function playEffect(v:Boolean=true):void{
			if(v){
				mc["mc_effect"].play();
				mc["mc_effect"].visible=true;
				GameMusic.playWave(WaveURL.ui_siliao);
			}else{
				mc["mc_effect"].stop();
				mc["mc_effect"].visible=false;
			}
		}
	}
}