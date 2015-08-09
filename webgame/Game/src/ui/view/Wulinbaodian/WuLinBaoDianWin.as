package ui.view.wulinbaodian
{
	import model.wulinbaodian.WuLinBaodianView;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class WuLinBaoDianWin extends UIWindow
	{
		
		
		public var getItemClickContent:Function;
		private static var _instance:WuLinBaoDianWin = null;
		public function WuLinBaoDianWin()
		{
			super(getLink(WindowName.win_wu_lin_bao_dian_dao_hang));
		}

	
		public static function getInstance(val:Function=null):WuLinBaoDianWin{
			if (_instance==null){
				_instance = new WuLinBaoDianWin();
			}
			
			return _instance;
		}
		private var m_wlZi:WuLinBaoDianCont;
		override protected function init():void{
			super.init();
			m_wlZi = WuLinBaoDianCont.getInstance();
			mcHandler({name:"btn_shengji"});
		}
		
		override public function mcHandler(target:Object):void{
			super.mcHandler(target);
			var name:String=target.name;
			switch(name){
				case "btn_bianqian":
//					WoYaoBianQiang_Window.getInstance().open();//原我要变强界面不要了
					if(!m_wlZi.isOpen)m_wlZi.open(true);
					m_wlZi.mc["title"].gotoAndStop(1);
					if(getItemClickContent!=null){
						getItemClickContent(0);
					}
					break;
					break;
				case "btn_shengji":
					if(!m_wlZi.isOpen)m_wlZi.open(true);
					
					m_wlZi.mc["title"].gotoAndStop(2);
					if(getItemClickContent!=null){
						getItemClickContent(1);
					}
					
					break;
				case "btn_zhuanqian":
					if(!m_wlZi.isOpen)m_wlZi.open(true);
					m_wlZi.mc["title"].gotoAndStop(3);
					if(getItemClickContent!=null){
						getItemClickContent(2);
					}
					break;
				case "btn_pk":
					if(!m_wlZi.isOpen)m_wlZi.open(true);
					m_wlZi.mc["title"].gotoAndStop(4);
//					mc["woyaoPanel"].visible = true;
					if(getItemClickContent!=null){
						getItemClickContent(3);
					}
					break;
				case "btn_zhuangbei":
					if(!m_wlZi.isOpen)m_wlZi.open(true);
					m_wlZi.mc["title"].gotoAndStop(5);
//					mc["woyaoPanel"].visible = true;
					if(getItemClickContent!=null){
						getItemClickContent(4);
					}
					break;
				
				default:
					break;
			}
		}
		
	
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open();
			WuLinBaodianView.getInstance();
			
		}
		override protected function windowClose():void{
				super.windowClose();
				m_wlZi.winClose();
			}
			
			override public function getID():int
			{
				return 1075;
			}
		}
	}