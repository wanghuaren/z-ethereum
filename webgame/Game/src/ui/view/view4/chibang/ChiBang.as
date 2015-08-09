package ui.view.view4.chibang
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.lib.IResModel;
	import common.config.xmlres.lib.IXMLLib;
	import common.config.xmlres.server.Pub_ToolsResModel;
	import common.config.xmlres.server.Pub_WingResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	
	import model.Chibang.ChibangModel;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSWingLevelUp;
	import nets.packets.PacketSCWingLevelUp;
	
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**
	 *翅膀 
	 * @auth hpt 2014年8月12日 09:23:26
	 * <!--
	 翅膀系统
	 -->
	 <packet id="54500" name="CSWingLevelUp" desc="翅膀系统" sort="1">
	 </packet>
	 <packet id="54501" name="SCWingLevelUp" desc="翅膀系统" sort="2">
	 <prop name="tag" type="3" length="0" desc="错误码"/>
	 <prop name="msg" type="7" length="256" desc="信息"/>
	 </packet>
	 * 
	 * Data 里面的m_nWingLevel 字段
	 */
	public class ChiBang extends  UIWindow
	{
		
		private var cbIdx:int = 1;
		private var m_chibang_level:int ;
		private static var _instance:ChiBang;
		private var currWing:Pub_WingResModel;
		private var nextWing:Pub_WingResModel;
		private var idxWing:Pub_WingResModel;
		public function ChiBang(DO:DisplayObject=null)
		{
			super(getLink(WindowName.win_chi_bang));
		}

		public static function getInstance():ChiBang
		{
			if (_instance == null)
				_instance=new ChiBang();
			return _instance;
		}
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must, type);
			DataKey.instance.register(PacketSCWingLevelUp.id, chibangSCWingLevelUp);
			Data.myKing.addEventListener(MyCharacterSet.WING_UPDATA, _wing_updata);
		}
//		private var wingXML_Lib:IXMLLib;
		
		
		override protected function init():void{
			super.init();
			//Data.myKing.addEventListener(MyCharacterSet.WING_UPDATA, _wing_updata);
			
			mc["isjiefeng"].htmlText ="";
			mc["tf_shengjitiaojian"].htmlText ="";
			
			m_chibang_level =Data.myKing.winglvl;
			cbIdx =Data.myKing.winglvl;
			 currWing=XmlManager.localres.getWingXml.getResPath(m_chibang_level) as Pub_WingResModel;
			nextWing=XmlManager.localres.getWingXml.getResPath(m_chibang_level+1) as Pub_WingResModel;
			 
			 idxWing=currWing;
			 if(nextWing){
				var needWp:Pub_ToolsResModel = XmlManager.localres.getToolsXml.getResPath(nextWing.need_tool)as Pub_ToolsResModel;
				 var count:int=Data.beiBao.getBeiBaoCountById(nextWing.need_tool,true);
				if(needWp){
					if(count>=nextWing.num){
						//绿色
						mc["tf_xiaohaoNum"].htmlText = "<font color='#"+FontColor.TOOL_ENOUGH+"'>"+nextWing.num+"</font>"+"个"+needWp.tool_name;//消耗几个几阶翅膀
					}else{
						//红色
						mc["tf_xiaohaoNum"].htmlText ="<font color='#"+FontColor.TOOL_NOT_ENOUGH+"'>"+nextWing.num+"</font>"+"个"+needWp.tool_name;//消耗几个几阶翅膀
					}
					
				}
			 }
			idxSort = currWing.wing_sort;

			
			
			_countAtt_curr();
			_countAtt_nextJie();
			if(currWing!=null)
			{
				mc["txt_zhanDouLi"].text = currWing.grade_value;
			}else{
				mc["txt_zhanDouLi"].text ="0";
			}
		
			showChiBang();
			setJianTou();

			setzuanStar(currWing);
			if(m_chibang_level+1>=ChibangModel.getInstance().wingXmlLen)
			{
				mc["tf_shengjitiaojian"].htmlText ="已达最大等级";
				///达到最大等级
			}
		}

		/**
		 *显示 星星数量 
		 */
		private function setzuanStar(_wing:Pub_WingResModel):void
		{
			var currmaxW:int = _wing.wing_max_lv;
			
			for(var i:int = 1;i<=10;i++)
			{
				if(i<=currmaxW){
					mc["zuan"+i].visible = true;
					if(i<=ChibangModel.getInstance().getNumOfStarLight(_wing))
					{
						mc["zuan"+i].gotoAndStop(2);
					}else{
						mc["zuan"+i].gotoAndStop(1);
					}
				}else{
					mc["zuan"+i].visible = false;
					
					
				}
			
			}
		}
		private var idxSort:int;
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			var name:String=target.name;
			if (name.indexOf("cbtn") >= 0)
			{
				
				return;
			}
			switch (target.name)
			{
				case "shengjiebtn": //
					chibangCSWingLevelUp();
					break;
				case "btnPrev": //
					
					if(idxWing.wing_sort>1){
						idxSort-=1;
					}
					setChibangFanYe();
					break;
				case "btnNext": //
//					idxWing= XmlManager.localres.getWingXml.getResPath(cbIdx) as Pub_WingResModel;
					if(idxWing.wing_sort<ChibangModel.getInstance().maxSort){
						idxSort+=1;
					}
					setChibangFanYe();
					break;
				
				case "yumao_hecheng1": //
					ChiBangCompose.instance().open();
					break;
				
				default:
					break;
				
			}
		}
		private function setChibangFanYe():void
		{
			for each(var cmodel:Pub_WingResModel in ChibangModel.getInstance().wingArr)
			{
				if(cmodel.wing_sort == idxSort){
					idxWing = cmodel;
					setJianTou();
					showChiBang();
					break;
				}
			}
		}
		/**
		 *左右翻页箭头 
		 */
		private function setJianTou():void
		{
			if(idxWing.wing_sort<=1)
			{
				StringUtils.setUnEnable(mc['btnPrev']);
			}else{
				StringUtils.setEnable(mc['btnPrev']);
			}
			if(idxWing.wing_sort>=ChibangModel.getInstance().maxSort){
				StringUtils.setUnEnable(mc['btnNext']);
			}else{
				StringUtils.setEnable(mc['btnNext']);
			}
		}
	
		private function showChiBang():void
		{
			var sortMaxModel:Pub_WingResModel = ChibangModel.getInstance().getSortMaxModel(idxWing.wing_sort);
			if(currWing.wing_lv<sortMaxModel.wing_lv){
				mc["isjiefeng"].htmlText =Lang.getLabel("900017_chibangkaiqi");//未解封
				mc["tf_shengjitiaojian"].htmlText = Lang.getLabel("900019_chibangjiefeng",[sortMaxModel.wing_sort,sortMaxModel.wing_max_lv]);//"升到"+currWing.wing_max_lv+"星可解封此翅膀"
				
			}else{
				mc["isjiefeng"].htmlText = Lang.getLabel("900016_chibangkaiqi");//已解封
				mc["tf_shengjitiaojian"].htmlText ="";
				
			}
			var path:String=FileManager.instance.getChiBangById(idxWing.res_id);
			mc["mcchibang"].source=path;
			
			sortMaxModel= ChibangModel.getInstance().getSortMaxModel(currWing.wing_sort);
			
			mc["mc_name"].gotoAndStop(sortMaxModel.wing_sort);
			mc["mc_jie"].gotoAndStop(sortMaxModel.wing_sort);
		}
		
		/**
		 *当前属性 
		 * @param level
		 * 
		 */
		private function _countAtt_curr():void
		{
			var _arrValues:Array=_countAtt(m_chibang_level);
			var n:int=0;
			var _str:String=null;
			for each (var va:* in _arrValues)
			{
				if (n > 6)
				{
					break;
				}
				mc['tf_currName_' + n].text=va.name+":";
				_str="";
				if (va.valueMin > 0 && va.valueMax > 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
				}
				else if (va.valueMin > 0 && va.valueMax <= 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin);
				}
				else
				{
					_str+=0;
				}
				mc['tf_curr_' + n].text=_str;
				++n;
			}
		}
		/**
		 *下一等级属性
		 */
		private function _countAtt_nextJie():void
		{
			var _arrValues:Array=_countAtt(m_chibang_level+1);
			var n:int=0;
			var _str:String=null;
//			var _showName:Boolean=false;
			for each (var va:* in _arrValues)
			{
				if (n > 6)
				{
					break;
				}
				_str="";
				if (va.valueMin > 0 && va.valueMax > 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
					//					mc['mcJianTou_' + n].visible=true;
				}
				else if (va.valueMin > 0 && va.valueMax <= 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin);
				}
				else
				{
					
						_str+="0";
					
				}
				mc['tf_next_' + n].text=_str;
				++n;
			}
		}
		private function _countAtt(level:int):Array
		{
			var _arrValues:Array=[];
			var _config:Pub_WingResModel=null; //
			var _values:Array=[];
			for (var i:int=level; i <= level; ++i)
			{
				_config=XmlManager.localres.getWingXml.getResPath(i) as Pub_WingResModel;
				if (null == _config)
				{
					continue;
				}
				if (_config.func1 > 0)
				{
					if (null == _values[_config.func1])
					{
						_values[_config.func1]={func: _config.func1, name: Att.getAttName(_config.func1), valueMin: _config.value1, valueMax: _config.value2};
					}
					else
					{
						_values[_config.func1].valueMin+=_config.value1;
						_values[_config.func1].valueMax+=_config.value2;
					}
				}
				if (_config.func3 > 0)
				{
					if (null == _values[_config.func3])
					{
						_values[_config.func3]={func: _config.func3, name: Att.getAttName(_config.func3), valueMin: _config.value3, valueMax: _config.value4};
					}
					else
					{
						_values[_config.func3].valueMin+=_config.value3;
						_values[_config.func3].valueMax+=_config.value4;
					}
				}
				if (_config.func5 > 0)
				{
					if (null == _values[_config.func5])
					{
						_values[_config.func5]={func: _config.func5, name: Att.getAttName(_config.func5), valueMin: _config.value5, valueMax: _config.value6};
					}
					else
					{
						_values[_config.func5].valueMin+=_config.value5;
						_values[_config.func5].valueMax+=_config.value6;
					}
				}
				if (_config.func7 > 0)
				{
					if (null == _values[_config.func7])
					{
						_values[_config.func7]={func: _config.func7, name: Att.getAttName(_config.func7), valueMin: _config.value7, valueMax: _config.value8};
					}
					else
					{
						_values[_config.func7].valueMin+=_config.value7;
						_values[_config.func7].valueMax+=_config.value8;
					}
				}
				if (_config.func9 > 0)
				{
					if (null == _values[_config.func9])
					{
						_values[_config.func9]={func: _config.func9, name: Att.getAttName(_config.func9), valueMin: _config.value9, valueMax: _config.value10};
					}
					else
					{
						_values[_config.func9].valueMin+=_config.value9;
						_values[_config.func9].valueMax+=_config.value10;
					}
				}
				//_values[1] = _values[1] + _config.
			}
			//19,21,23,22,24,
			for each (var v:* in _values)
			{
				switch (v.func)
				{
//					case 19:
//						_arrValues[0]=v;
//						break;
					case 21:
						_arrValues[0]=v;
						break;
					case 23:
						_arrValues[1]=v;
						break;
					case 109:
						_arrValues[2]=v;
						break;
					case 22:
//						_arrValues[3]=v;
						break;
					
					case 24:
//						_arrValues[4]=v;
						break;
					default:
						break;
				}
			}
			if (null == _arrValues[0])
			{
				_arrValues[0]={func: 0, name: Att.getAttName(21), valueMin: 0, valueMax: 0};
			}
			if (null == _arrValues[1])
			{
				_arrValues[1]={func: 0, name: Att.getAttName(23), valueMin: 0, valueMax: 0};
			}
			if (null == _arrValues[2])
			{
				_arrValues[2]={func: 0, name: Att.getAttName(109), valueMin: 0, valueMax: 0};
			}
			if (null == _arrValues[3])
			{
//				_arrValues[3]={func: 0, name: Att.getAttName(22), valueMin: 0, valueMax: 0};
			}
			if (null == _arrValues[4])
			{
//				_arrValues[4]={func: 0, name: Att.getAttName(24), valueMin: 0, valueMax: 0};
			}
			return _arrValues;
		}
		private function _wing_updata(e:DispatchEvent=null):void
		{
			cbIdx =m_chibang_level = Data.myKing.godlvl;
			//shengjifun();
			
			init();
			//cbIdx = 1+m_chibang_level;
		}

		override public function winClose():void
		{
			super.winClose();
		}
		override public function getID():int
		{
			return 0;
		}
		private function chibangCSWingLevelUp():void
		{
			var _p:PacketCSWingLevelUp = new PacketCSWingLevelUp();
			DataKey.instance.send(_p);
		}
		private function chibangSCWingLevelUp(p:IPacket):void
		{
			var _p:PacketSCWingLevelUp=p as PacketSCWingLevelUp;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}
		/**可能用到的封装类
		 var horseMc:ResMcExt = new ResMcExt("NPC/Main_" + horseSkin + "ZS.swf", 1);
		 mc['mcZuoqi'].addChild(horseMc);
		 * 
		 * var vip:Pub_VipResModel=XmlManager.localres.getVipXml.getResPath(1);
		 */
		
		/**
		 * 角色界面悬浮使用  
		 * @return 
		 * 
		 */		
		public function getCurAtt(winglvl:int,isMe:Boolean=true):String{
			var _arrValues:Array=_countAtt(winglvl);
			var n:int=0;
			var _str:String="";
			for each (var va:* in _arrValues)
			{
				if (n > 6)
				{
					break;
				}
				_str+=va.name+"：";
				if (va.valueMin > 0 && va.valueMax > 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
				}
				else if (va.valueMin > 0 && va.valueMax <= 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin);
				}
				else
				{
					_str+=0;
				}
				_str+="<br/>";
				++n;
			}
			if(winglvl==0){
				if(isMe)
					_str="";
				else
					_str="";
			}
			return _str;
		}
	}
}