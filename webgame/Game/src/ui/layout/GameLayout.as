package ui.layout
{
	public class GameLayout
	{
		
		/**
		 * 0 - 默认模式
		 * 1 - 截照片模式对齐，即高度撑满，宽度按高度比例调整，图片中心点X轴居中
		 * 2 - 居中模式，不对图片大小进行修改，图片中心点X轴Y轴都居中
		 */ 
		public static const LOADING_PIC_ALIGN_MODE:int = 2;
		
		
		/**
		 * game_loading.fla 中的文档属性，尺寸:宽高
		 */ 
		
		
		//public static const LOADING_FLA_DOC:FlaDocumentSetting = new FlaDocumentSetting(1440,900,820,145,178,0);
		public static const LOADING_FLA_DOC:FlaDocumentSetting = new FlaDocumentSetting(1440,900,1000,145,178,0);
		
		/**
		 * 游戏的的加载界面大图宽高
		 */ 
		public static function get LOAD_X_JPG_INFO():LoadXJpgInfo
		{
			if(1 == LOADING_PIC_ALIGN_MODE)
			{
				return new LoadXJpgInfo(1440,900);
			}
			
			if(2 == LOADING_PIC_ALIGN_MODE)
			{
				return new LoadXJpgInfo(1920,600);
			}
			
			return new LoadXJpgInfo(1440,900);
		}
		
		/**
		 * game_login.fla
		 */ 
		//public static const LOGIN_FLA_DOC:FlaDocumentSetting = new FlaDocumentSetting(1440,900,638,108,0,0);
		public static const LOGIN_FLA_DOC:FlaDocumentSetting = new FlaDocumentSetting(1440,900,847,108,0,0);
		
		/**
		 * game_newrole.fla
		 * 
		 */ 
		//public static const NEW_ROLE_FLA_DOC:FlaDocumentSetting = new FlaDocumentSetting(1000,600,0,0,0,0);
		
		
		
		
		
		
		
		
	}
}