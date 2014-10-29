package ui.base.login
{
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 *	登陆用户名显示【登陆滚屏信息】
	 *  @2012－10－18 andy 
	 */
	public class LoginUserName
	{
		public var txt_loginuser:TextField;
		public var arrName:Array;
		private var arrTemp:Array;

		
		//定时器
		private var timer:Timer;
		//每次显示几个
		private const SHOW_COUNT:int=8;
		//备用名字
		private const ranName:Array = ["咸语心", "月薇儿", "葛梦露", "流金岁月", "夔绿蕊", "褲灬衩", "席良哲", "滒丶冋唻了", "小西", "翟骊泓", "天王盖地虎", "公孙英卫", "乌鸦", "朱尔曼", "劇終", "癫狂书生", "丿弑神灬龙少", "巫马又菡", "风情無雙", "通天阴", "念寒", "麦穗儿", "Ren丨妙妙", "寇绮山", "尹梦柏", "衡月明", "月初阳", "童运良", "龍詩雲", "於子衿", "刘奇水", "南涅", "诸葛小亮", "八戒是青龙山", "壞小孑", "司寇澹雅", "九幽神龙", "庚梦山", "桓阳夏", "凌侠骞", "淳于灵儿", "薛宜春", "这份情", "冉小翠", "饶英纵", "流年", "壤驷辰良", "乖小乖", "殷元化", "宇文白凝", "孙娅", "端木兴修", "发发发", "乐正理全", "左慈", "张石北", "马桂芝", "太叔元化", "夏侯俊人", "虎哥", "路人甲", "科里嘛查", "闪闪惹人爱", "莫言莫问莫语", "成乐天", "杜蕾丝", "戴星波", "不是大哥", "阎智杰", "干开朗", "罗晴丽", "万纤风情", "索飞宇", "凡是", "唐才俊", "社会你宇祁哥", "林依晨", "兜兜", "端木俊杰", "华安", "左霭", "司徒弘阔", "CJ丶暗灵", "龙志勇", "明英华", "骆弘深", "充依丝", "欣欣", "苍宏浚", "笑看人生", "富傲南", "康少", "横槊", "醉梦先生", "女Y王", "元宛白", "慕容元魁", "慕寄容", "一世情殇", "诸葛婉慧", "谈飘", "车模VS兽兽", "灭宇", "贝冷雪", "未知名的情绪", "鬼狐", "孤月", "安亚旭", "宗政春雁", "司空旭鹏", "丫丫", "祖紫雪", "江鸿达", "东方梓芃", "厍初月", "皇甫运恒", "裘幼晴", "佛魔", "樊雨南", "耳朵妖怪", "尉迟文博", "明哥哥", "无丶爱", "阿童木", "游戏而已", "台骏桀", "韩高飞", "却静白", "余幻桃", "苍元甲", "蛇王", "单于寒云", "狂神", "濮阳晓山", "蓝雅雯", "没道理", "沈霸天", "依凝", "吴逍遥", "郑鸿云", "ZERO", "你爹", "繁复温暖丶", "暗夜", "近之则不逊", "陌妍浠丶", "雨晴", "张飞", "巫八剑", "无与伦比", "此人丶危险", "双安和", "秋灵珊", "居惜玉", "公西项明", "闻怀蕊", "半是残花香", "蔺醉", "冥月", "殴高远", "禄修贤", "狂战天下", "张飞章", "司徒梦露", "厉成仁", "雷子", "幸秋灵", "慕容吉星", "冷水绿", "满嘉纳", "疯女", "仇兴为", "死神之吻亮", "宁林", "屠城木马", "轻狂书生", "爷们", "东城卫修", "慕容睿博", "隆孤风", "尉迟正谊", "仇雅雯", "庞国豪", "聖灮", "吉昊然", "轩凌云", "浦晗昱", "刺刀", "东叶", "孤殇", "不小心", "秋风起", "可心小帅哥", "美雪儿"];
		 
		private static var _instance:LoginUserName;
		public static function getInstance():LoginUserName{
			if(_instance==null){
				_instance=new LoginUserName();
			}
			return _instance;
		}
		public function LoginUserName()
		{
		}
		
		public function init(txt:TextField,loginuser:String):void{
			txt_loginuser=txt;			
			arrTemp=loginuser.split(";");
			arrName=new Array();
			reset();
			
			
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
			timerHandler();
		}
		
		private function timerHandler(te:TimerEvent=null):void{
			if(arrName==null||txt_loginuser==null){
				sotpTimer();
				return;
			}
			
			if(arrName.length<SHOW_COUNT){
				reset();
			}
			txt_loginuser.text="";
			var str:String=""; 
			var arr:Array;
			
			for(var i:int=0;i<SHOW_COUNT;i++){
				arr=arrName[i].split(",");
				if(arr==null||arr.length<2){
					continue;
				}
				str+= arr[0]==1?"<font color='#51b4f3'>♂"+arr[1]+"</font>":"<font color='#f780d7'>♀"+arr[1]+"</font>";
				str+="<font color='#a3a2a2'>进入决战九天</font><br/>";
			}
			
			txt_loginuser.htmlText=str;
			arrName.shift();
		}
		
		private function reset():void{
			if(arrTemp.length<50){
				var add:int=50-arrTemp.length;
				var sex:int=1;
				for(var i:int=0;i<add;i++){
					sex=Math.ceil(Math.random()*2);
					arrTemp.push(sex+","+ranName[i]);
				}
			}
			arrName=arrName.concat(arrTemp).concat(arrTemp).concat(arrTemp).concat(arrTemp).concat(arrTemp);
		}
		
		public function sotpTimer():void{
			if(timer!=null){
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			}
		}
	}
}