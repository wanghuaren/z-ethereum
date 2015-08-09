package ui.view.view2.mrfl_qiandao
{
	import common.managers.Lang;
	import common.utils.res.ResCtrl;
	
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import netc.Data;
	import netc.packets2.*;
	
	import world.WorldEvent;
	
	/**
	 *	登陆用户名显示【登陆滚屏信息】
	 *  @2012－10－18 andy 
	 */
	public class ChouJiangUserName
	{
		public var txt_loginuser:TextField;
		public var arrName:Vector.<StructGetItemLog2> = new Vector.<StructGetItemLog2>();
		private var arrTemp:Array = [];
		
		
		//定时器
		//private var timer:Timer;
		//每次显示几个
		private const SHOW_COUNT:int=8;
		//备用名字
		//private const ranName:Array = ["馨馨", "谢娜", "东寒妹", "魔女丫头", "魔法美少女", "浪客剑心", "流水清风", "江山虞美人", "月妃", "郁闷的月儿", "哀伤的狐狸", "芽芽小七", "神泣", "飘渺紫嫣", "年年奔大康", "季末涵", "龙城狂霸拽", "雲杰", "雾影", "悍武帝", "痴情小米", "谁与共流年", "直幸福著", "﹂臉殘笑", "﹍淺笑|傾城", "﹎七婇炫躌≈", "﹎恋爱糿兒圓", "游乐丶刀月", "晨曦豪少", "姐只是神话", "尐樓聽風雨", "烤鸡屁屁", "囧涵", "圣域魔法师", "＂主ソ旋律丶", "＂純白色、恋", "＆逍遥＆", "(战魂)", "剑之传奇", "一蓑烟雨", "月丨夜", "小明", "壮VS壮", "晨曦灵魂", "无敌", "～爱情☆转角", "￠冷面阎罗￠", "￠含沙射影￠", "￠絕⌒戀雪☆", "混混虎", "小斑马", "风雪初晴", "夏天", "冬雪", "～爱情☆转角", "￠冷面阎罗￠", "￠含沙射影￠", "￠絕⌒戀雪☆", "￠轩辕№破天", "￥李逍遥￥", "天下无双", "未來侑多遠", "月光小鱼", "轮回d王8拳", "小魔女", "宝庆幸福", "李寻欢", "未来不远", "宝庆汐儿", "成吉思汗", "宝庆陆虎", "大蛇丸", "蓅瑩", "盗F13", "卍妖后", "听一半歌o0", "彼岸丶流年", "虎爺", "三三四四", "绝版青春", "缘冰", "奇人", "猫猫", "妖精2", "香儿", "纵横轩儿", "无聊", "天下无敌", "地理", "无聊玩下", "夜殇逍遥", "冬天的记忆", "梦雾", "十月", "枫情", "l离姐远点", "伤心", "兂雙咒", "黄金云", "超V雨", "完颜婷", "神话中的姐", "一xiao尕儿", "辣椒妹子", "潇湘夫人Oo", "斩护卫"];
		private const ranName:Vector.<StructGetItemLog2> = new Vector.<StructGetItemLog2>();
		private static var _instance:ChouJiangUserName;
		public static function getInstance():ChouJiangUserName{
			if(_instance==null){
				_instance=new ChouJiangUserName();
			}
			return _instance;
		}
		public function ChouJiangUserName()
		{
		}
		
		public function init(txt:TextField,loginuser:String):void{
			txt_loginuser=txt;			
			//arrTemp=loginuser.split(";");
			//arrName=new Array();
			reset();
			
			
			//timer=new Timer(1000);
			//timer.addEventListener(TimerEvent.TIMER,timerHandler);
			//timer.start();
			//timerHandler();
		}
		
		public function timerHandler(e:WorldEvent):void{
			if(arrName==null||txt_loginuser==null){
				sotpTimer();
				return;
			}
			
			if(arrName.length<SHOW_COUNT){
				//reset();
			}
			//txt_loginuser.text="";
			var str:String=""; 
			
			
			for(var i:int=0;i<SHOW_COUNT;i++){
				
				if(i < arrName.length){
				//str+= arr[0]==1?"<font color='#51b4f3'>♂"+arr[1]+"</font>":"<font color='#f780d7'>♀"+arr[1]+"</font>";
				//str+="<font color='#a3a2a2'>进入决战九天</font><br/>";
				
				str+= "<font color='#33cc33'>[" + arrName[i].PlayerName + "]</font>";
				
				if(null == Lang.getLabel("pub_chou_jiang_huo_de"))
				{
					str+="抽奖获得";
				}else{
					str+=  Lang.getLabel("pub_chou_jiang_huo_de");
				}
				//---------------------------------------------------------------------
				var cell:StructBagCell2=new StructBagCell2();
				// 10300038	 一级魂器	 二级以此类推
				cell.itemid=arrName[i].ItemId;
				Data.beiBao.fillCahceData(cell);
				//-----------------------------------------------------------------------
				
				str+= ResCtrl.instance().getFontByColor(cell.itemname,cell.toolColor-1);
				str+= arrName[i].ItemNum.toString();
				str+= Lang.getLabel("pub_ge");
				str+="<br/>";
				}
			}
			
			txt_loginuser.htmlText=str;
			arrName.shift();
		}
		
		private function reset():void{
//			if(arrTemp.length<50){
//				var add:int=50-arrTemp.length;
//				var sex:int=1;
//				for(var i:int=0;i<add;i++){
//					sex=Math.ceil(Math.random()*2);
//					arrTemp.push(sex+","+ranName[i]);
//				}
//			}
			//arrName=arrName.concat(arrTemp).concat(arrTemp).concat(arrTemp).concat(arrTemp).concat(arrTemp);
			
			arrName= new Vector.<StructGetItemLog2>();
		}
		
		public function sotpTimer():void{
//			if(timer!=null){
//				timer.reset();
//				timer.removeEventListener(TimerEvent.TIMER,timerHandler);
//			}
		}
	}
}