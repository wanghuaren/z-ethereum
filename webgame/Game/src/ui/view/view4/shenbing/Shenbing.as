package ui.view.view4.shenbing
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_GodResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import display.components.CheckBoxStyle1;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSGodUp;
	import nets.packets.PacketSCGodUp;
	
	import ui.frame.FontColor;
	import ui.frame.ImageUtils;
	import ui.frame.UIPanel;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**神兵   25级开启
	 * @author Administrator
	 * <packet id="55101" name="CSGodUp" desc="神兵升级" sort="1">
    <prop name="isCoin3" type="3" length="0" desc="是否使用元宝100%成功"/>
  </packet>
  <packet id="55102" name="SCGodUp" desc="神兵升级返回" sort="2">
    <prop name="tag" type="3" length="0" desc="错误码"/>
  </packet>

	 */
	public class Shenbing extends UIPanel
	{
		private static var _instance:Shenbing;
		private var cbIdx:int = 1;
		/**神兵等级 * */
		private var m_level:int;
		
		private var shenbingXmlLen:int ;
		public function Shenbing(DO:DisplayObject=null)
			{
				super(this.getLink(WindowName.win_shen_bing));
			}
			
			public static function getInstance(reload:Boolean=false):Shenbing
			{
				if (_instance == null && reload == false)
				{
					_instance=new Shenbing();
				}
				return _instance;
			}
			private var m_cb_isP:CheckBoxStyle1 = null;
			override public function init():void
			{
				cbIdx =m_level=Data.myKing.godlvl;
				if(cbIdx==0)cbIdx = 1;
				super.sysAddEvent(Data.myKing,MyCharacterSet.SUI_PIAN6_UPD, SUI_PIAN_UPD);
				Data.myKing.addEventListener(MyCharacterSet.GOD_UPDATA, _god_updata);
				shenbingXmlLen = XmlManager.localres.getGodXml.xmlLength;
				setzuanStar();
				showshenbing();
				m_cb_isP = mc["fuxuankuang"] as CheckBoxStyle1;
				m_cb_isP.selected = false;
				Lang.addTip(mc["ruhehuode"],"shenbingHowget",150);
				mc["mc_sb_name"].visible=false;
				mc["mc_jie"].visible=false;
				if(cbIdx<10)
				{
					StringUtils.setUnEnable(mc['btnPrev']);
				}else if(cbIdx+10>shenbingXmlLen){
					StringUtils.setUnEnable(mc['btnNext']);
				}
				setJianTou();
				_countAtt_curr();
				_countAtt_nextJie();
				showTxtContent();
			}
//			private var shenbingXmlLen:int;
			
			/**
			 *改变神兵展示显示  名字 
			 * 
			 */
			private function showshenbing():void
			{
				
				var showM:Pub_GodResModel;
				showM=XmlManager.localres.getGodXml.getResPath(cbIdx) as Pub_GodResModel;
				shenbingXmlLen =XmlManager.localres.getGodXml.xmlLength;
				if(showM!=null){
					var path:String=FileManager.instance.getshenbingById(showM.res_id);
					mc["mcshenbing"].source=path;
//					ImageUtils.replaceImage(mc,mc["mcshenbing"],path);
				}
			}
			/**
			 *设置神兵名字，战斗力 ，成功率 ，材料消耗txt 
			 * 
			 */
			private function showTxtContent():void
			{
				var showM:Pub_GodResModel=XmlManager.localres.getGodXml.getResPath(m_level) as Pub_GodResModel;
				if(m_level==0||showM==null){
					mc["txt_not_open"].htmlText =Lang.getLabel("5014_shenbingweikaiqi");//"神兵未开启";
					mc["txt_zhanDouLi"].htmlText = "0";//
					//mc["tf_chenggonglv"].htmlText = showM.succeed_odd/100+"%";//成功率
				}else{
					mc["txt_not_open"].htmlText="";
					mc["txt_zhanDouLi"].htmlText = showM.grade_value;//
					mc["mc_sb_name"].visible=true;
					mc["mc_jie"].visible=true;
					mc["mc_sb_name"].gotoAndStop(Math.ceil(m_level/10));
				}
				
				var showM2:Pub_GodResModel=XmlManager.localres.getGodXml.getResPath(m_level+1) as Pub_GodResModel;
				var colorStr:String = "<font color='#8afd5c'>";
			
				if(showM2!=null){
					if(Data.myKing.value6<showM2.need_exp)
					{
						colorStr = "<font color='#ff0000'>";
					}
					var yinliangStrColor:String =  "<font color='#8afd5c'>";
					if(Data.myKing.coin1<showM2.cost_coin1)
					{
						yinliangStrColor = "<font color='#ff0000'>";
					}
						mc["tf_xiaohaoyuanbao"].htmlText =Lang.getLabel("5014_shenbingxhyb",[showM2.cost_coin3]);// "消耗"+showM2.cost_coin3+"元宝成功率100%";//消耗元宝
						mc["tf_chenggonglv"].htmlText = showM2.succeed_odd/100+"%";//成功率
						mc["tf_xiaohao"].htmlText = colorStr+showM2.need_exp+" "+Lang.getLabel("5014_shentiesuipian")+"</font>"//"神铁碎片";
						mc["tf_xiaohao_yinliang"].htmlText =yinliangStrColor+ showM2.cost_coin1	+Lang.getLabel("pub_yin_liang")+"</font>";//"银两";
				}else{
					mc["tf_xiaohao_yinliang"].htmlText ="0 "+Lang.getLabel("pub_yin_liang")+"</font>";
				}
				mc["tf_num"].htmlText = Data.myKing.value6;
//				mc["tf_dengji_name"].htmlText = showM.god_name;
				mc["mc_jie"].gotoAndStop(Math.ceil(showM.god_lv/10));
				if(m_level+1>=shenbingXmlLen){
//					mc["tf_dengji_name"].htmlText = Lang.getLabel("5014_shentiemanji");//"已达满级";
					mc["tf_xiaohao"].htmlText = "";
					mc["tf_xiaohao_yinliang"].htmlText = "";
					mc["tf_chenggonglv"].htmlText = "";
					StringUtils.setUnEnable(mc["duanzao"]);
				}
			}
			
			/**
			 *显示 星星数量 
			 */
			private function setzuanStar():void
			{
				var _10_ji:int = (m_level-1)%10+1;
				for(var i:int = 1;i<=10;i++)
				{
					if(i<=_10_ji)
					{
						mc["zuan"+i].gotoAndStop(2);
					}else{
						mc["zuan"+i].gotoAndStop(1);
					}
				}
			}
			override public function mcHandler(target:Object):void
			{
				var name:String=target.name;
				switch (name)
				{
					case "btnPrev": //
						if(cbIdx>10){
							cbIdx-=10;
						}
						setJianTou();
						showshenbing();
						break;
					case "btnNext": //
						
						if(cbIdx+10<shenbingXmlLen){
							cbIdx+=10;
						}
						setJianTou();
						showshenbing();
						break;
					case "fuxuankuang":
						m_cb_isP.selected = !	m_cb_isP.selected;
						break;
					case "duanzao":
						shengjiShenbing();
						break;
					default:
						break;
				}
				
			}
			/**
			 * @
			 * <packet id="55101" name="CSGodUp" desc="神兵升级" sort="1">
			 <prop name="isCoin3" type="3" length="0" desc="是否使用元宝100%成功"/>
			 </packet>
			 <packet id="55102" name="SCGodUp" desc="神兵升级返回" sort="2">
			 <prop name="tag" type="3" length="0" desc="错误码"/>
			 </packet>
			 
			 */
			private function shengjiShenbing():void
			{
				DataKey.instance.register(PacketSCGodUp.id, chibangSCGodUp);
				var _p:PacketCSGodUp = new PacketCSGodUp();
				
				_p.isCoin3 = m_cb_isP.selected? 1:0;
				DataKey.instance.send(_p);
			}
			private function chibangSCGodUp(p:IPacket):void
			{
				var _p:PacketSCGodUp=p as PacketSCGodUp;
				
				if (0 != _p.tag)
				{
					Lang.showResult(_p);
					return;
				}
				showshenbing();
			}
			private function setJianTou():void
			{
				if(cbIdx<=10)
				{
					StringUtils.setUnEnable(mc["btnPrev"]);
				}else{
					StringUtils.setEnable(mc["btnPrev"]);
				}
				if(cbIdx+10>=shenbingXmlLen)
				{
					StringUtils.setUnEnable(mc["btnNext"]);
				}else{
					StringUtils.setEnable(mc["btnNext"]);
				}
			}
		
			
			/**
			 *当前属性 
			 * @param level
			 * 
			 */
			private function _countAtt_curr():void
			{
				
				var _arrValues:Array=_countAtt(m_level);
				var n:int=1;
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
				var _arrValues:Array=_countAtt(m_level+1);
				var n:int=1;
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
						
						_str+="";
						
					}
					mc['tf_next_' + n].text=_str;
					++n;
				}
			}
			private function _countAtt(level:int):Array
			{
				var _arrValues:Array=[];
				var _config:Pub_GodResModel=null; //
				var _values:Array=[];
				for (var i:int=level; i <= level; ++i)
				{
					_config=XmlManager.localres.getGodXml.getResPath(i) as Pub_GodResModel;
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
						case 19:
							_arrValues[0]=v;
							break;
						case 21:
							_arrValues[1]=v;
							break;
						case 23:
							_arrValues[2]=v;
							break;
						case 109:
							_arrValues[3]=v;
							break;
						case 37:
							_arrValues[4]=v;
							break;
						default:
							break;
					}
				}
				if (null == _arrValues[0])
				{
					_arrValues[0]={func: 0, name: Att.getAttName(19), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[1])
				{
					_arrValues[1]={func: 0, name: Att.getAttName(21), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[2])
				{
					_arrValues[2]={func: 0, name: Att.getAttName(23), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[3])
				{
					_arrValues[3]={func: 0, name: Att.getAttName(109), valueMin: 0, valueMax: 0};
				}
				if (null == _arrValues[4])
				{
					_arrValues[4]={func: 0, name: Att.getAttName(37), valueMin: 0, valueMax: 0};
				}
				return _arrValues;
			}
			/**
			 *	碎片值有变化
			 */
			public function SUI_PIAN_UPD(e:DispatchEvent=null):void
			{
				mc["tf_num"].htmlText = Data.myKing.value6;
				showTxtContent();
			}
			private function _god_updata(e:DispatchEvent=null):void
			{
				cbIdx=m_level = Data.myKing.godlvl;
				setzuanStar();
				showshenbing();
				_countAtt_curr();
				_countAtt_nextJie();
				showTxtContent();
			}
		}
}