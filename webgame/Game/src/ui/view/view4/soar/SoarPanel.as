package ui.view.view4.soar
{
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_ExpResModel;
	import common.config.xmlres.server.Pub_SoarResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.StructLimitInfo2;
	
	import nets.packets.PacketCSSoar;
	import nets.packets.PacketCSSoarExpExchang;
	import nets.packets.PacketSCSoar;
	import nets.packets.PacketSCSoarExpExchang;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**
	 * 渡劫 转生
	 * @author steven guo
	 *
	 */
	public class SoarPanel extends UIPanel
	{
		public static const SOAR_EXCHANGE_NUM:int=89000085;
		public static const SOAR_OPEN_LEVEL:int=80;
		
		public function SoarPanel(DO:DisplayObject=null)
		{
			super(this.getLink(WindowName.win_du_jie));
			//			_initMsgListener();
		}
		private static var _instance:SoarPanel;
		
		public static function getInstance(reload:Boolean=false):SoarPanel
		{
			if (_instance == null && reload == false)
			{
				_instance=new SoarPanel();
			}
			return _instance;
		}
		
		private function _initMsgListener():void
		{
			//DataKey.instance.register(PacketSCPetFight.id,_responeSCPetFight);     
			DataKey.instance.register(PacketSCSoar.id, _responseSCSoar);
			DataKey.instance.register(PacketSCSoarExpExchang.id, _responseSCSoarExpExchang);
			Data.myKing.addEventListener(MyCharacterSet.SOAR_UPDATA, _soar_updata);
		}
		
		override public function init():void
		{
			_initMsgListener();
			mc['mcSoarExpExchang'].visible=false;
			mc['tf_level'].text="";
			mc['tf_curr_xiuwei_value'].text="";
			mc['txt_zhanDouLi'].text="";
			mc['tf_next_xiuwei_value'].text="";
			mc['tf_next_chenggonglv'].text="";
			//			mc['tf_curr_title'].text="";
			//			mc['tf_next_title'].text="";
			for (var i:int=1; i <= 7; ++i)
			{
				mc['tf_curr_' + i].text="";//转生前属性
				mc['tf_nextL_' + i].text="";//下阶属性
				mc['tf_nextZ_' + i].text="";//下转属性
				//				mc['mcJianTou_' + i].visible=false;
			}
			m_currLevel=Data.myKing.soarlvl;
			m_currValue=Data.myKing.soarexp;
			m_currId = m_currLevel+1;
			_repaint();
			showDuJiePic(m_currLevel);
			_repaintExchange();
			
		}
		
		/**
		 * 刷新渡劫兑换面板
		 *
		 */
		private function _repaintExchange():void
		{
			mc['tf_curr_xiuwei_value'].text=m_currValue;
			mc['mcSoarExpExchang']['tf_king_lv_0'].text=Data.myKing.level;
			mc['mcSoarExpExchang']['tf_king_lv_1'].text=Data.myKing.level - 1;
			//读取经验表
			var _Pub_ExpResModel:Pub_ExpResModel=XmlManager.localres.getPubExpXml.getResPath(Data.myKing.level) as Pub_ExpResModel;;
			mc['mcSoarExpExchang']['tf_Exchange_value'].text=_Pub_ExpResModel.soar_exp;
			mc['mcSoarExpExchang']['tf_soar_exp_coin'].text=Lang.getLabel("40100_tf_soar_exp_coin", [StringUtils.changeToTenThousand(_Pub_ExpResModel.soar_exp_coin)]);
			var _StructLimitInfo2:StructLimitInfo2=Data.huoDong.getLimitById(SOAR_EXCHANGE_NUM);
			if (_StructLimitInfo2 != null)
			{
				var _Exchange_times:int=_StructLimitInfo2.maxnum - _StructLimitInfo2.curnum;
				mc['mcSoarExpExchang']['tf_Exchange_times'].text=_Exchange_times;
			}
			if (Data.myKing.level < SOAR_OPEN_LEVEL)
			{
				mc['mcSoarExpExchang'].visible=false;
			}
		}
		//渡劫的当前等级
		private var m_currLevel:int=0;
		private var m_currId:int = 0;
		private var m_currValue:int=0;
		
		private function _repaint():void
		{
			if (null == mc)
			{
				return;
			}
			var nextJie:int = Math.ceil(m_currLevel/10);
			var _10_ji:int =  (m_currLevel-1)%10+1;
			var _currConfig:Pub_SoarResModel=XmlManager.localres.soarXml.getResPath(m_currLevel) as Pub_SoarResModel;
			var _nextConfig:Pub_SoarResModel=XmlManager.localres.soarXml.getResPath(m_currLevel +1) as Pub_SoarResModel;
			
			
			if (null != _currConfig)
			{
				//	mc['tf_curr_title'].text="当前渡劫神力如下：";
				mc["txt_zhanDouLi"].text = _currConfig.grade_value;
				mc['tf_level'].text=_currConfig.soar_name;//Lang.getLabel("40100_tf_soar_1", [StringUtils.changeToZH(nextJie-1),StringUtils.changeToZH(_10_ji)]);
			
			}
			else
			{
				//				mc['tf_curr_title'].text="当前渡劫神力如下：";
				mc['tf_level'].text=Lang.getLabel("40100_tf_soar_0");
			}
			
			if (null != _nextConfig)
			{
				//				mc['tf_next_title'].text=Lang.getLabel("40100_tf_soar_1", [StringUtils.changeToZH(_nextConfig.soar_lv)]) + "渡劫神力如下：";
				//				_countAtt_next(true,_nextConfig);
				mc['tf_next_xiuwei'].text=Lang.getLabel("40100_tf_soar_1");
				if (m_currValue >= _nextConfig.need_soar)
				{
					mc['tf_next_xiuwei_value'].htmlText="<font color='#00FF00'>" + _nextConfig.need_soar + "</font>";
				}
				else
				{
					mc['tf_next_xiuwei_value'].htmlText="<font color='#FF0000'>" + _nextConfig.need_soar + "</font>";
				}
				mc['tf_next_chenggonglv'].htmlText=(_nextConfig.odd/100)+"%";
				StringUtils.setEnable(mc['btnzhuansheng']);
			}
			else
			{
				//				mc['tf_next_title'].text="您已达到最高修为";
				mc['tf_next_xiuwei'].text=Lang.getLabel("40100_tf_soar_2");//"您已达到最高修为";
				mc['tf_next_xiuwei_value'].text="";
				mc['tf_next_chenggonglv'].text="";
				//				_countAtt_next(false,_nextConfig);
				StringUtils.setUnEnable(mc['btnzhuansheng']);
			}
		
			_countAtt_curr(m_currLevel);
			_countAtt_nextJie(m_currLevel+1);
			var _nextjie:int = nextJie*10+1;
			_countAtt_next(_nextjie);
			
			setzuanStar(_10_ji);
		}
		private function showDuJiePic(_lev:int):void
		{
			
			var dejie:int = _lev;
			
				var de:int = Math.ceil(_lev/10);
				if(de>6){
					de = de-6;
					dejie=61;
				}else{
					dejie=1;
				}
				
			for(var i = 1;i<7;i++)
			{
				if(i<=de){
					StringUtils.setEnable(mc["zhuansheng"+i]);
				}else{
					StringUtils.setUnEnable(mc["zhuansheng"+i]);
				}
				var _currConfig:Pub_SoarResModel=XmlManager.localres.soarXml.getResPath(dejie) as Pub_SoarResModel;
				
				
				if(_currConfig ==null) {
					mc["zhuansheng"+i].visible = false;
					continue;
				}else{
					mc["zhuansheng"+i].visible = true;
					
					mc["zhuansheng"+i]["txt_star"].text = "";
					mc["zhuansheng"+i]["txt_name"].text = "";
//					mc["zhuansheng"+i]["mc_result"].uil.source = FileManager.instance.getDuJieById(_currConfig.res_id);
					ImageUtils.replaceImage(mc["zhuansheng"+i]["mc_result"],mc["zhuansheng"+i]["mc_result"]["uil"],FileManager.instance.getDuJieById(_currConfig.res_id));
					dejie+=10;
				}
				
				
			}
			
		}
		private function _countAtt(level:int):Array
		{
			var _arrValues:Array=[];
			var _config:Pub_SoarResModel=null; //
			var _values:Array=[];
			for (var i:int=level; i <= level; ++i)
			{
				_config=XmlManager.localres.soarXml.getResPath(i) as Pub_SoarResModel;
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
				
				
				if (_config.func11> 0)
				{
					if (null == _values[_config.func11])
					{
						_values[_config.func11]={func: _config.func11, name: Att.getAttName(_config.func11), valueMin: _config.value11, valueMax: _config.value12};
					}
					else
					{
						_values[_config.func11].valueMin+=_config.value11;
						_values[_config.func11].valueMax+=_config.value12;
					}
				}
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
					case 22:
						_arrValues[4]=v;
						break;
					case 24:
						_arrValues[5]=v;
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
				_arrValues[4]={func: 0, name: Att.getAttName(22), valueMin: 0, valueMax: 0};
			}
			if (null == _arrValues[5])
			{
				_arrValues[5]={func: 0, name: Att.getAttName(24), valueMin: 0, valueMax: 0};
			}
			return _arrValues;
		}
		
		/**
		 *当前属性 
		 * @param level
		 * 
		 */
		private function _countAtt_curr(level:int):void
		{
			var _arrValues:Array=_countAtt(level);
			var n:int=1;
			var _str:String=null;
			for each (var va:* in _arrValues)
			{
				if (n > 7)
				{
					break;
				}
				if(level !=0){
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
				}else{
					mc['tf_curr_' + n].text="0";
				}
				
				++n;
			}
		}
		/**
		 *下一等级属性
		 */
		private function _countAtt_nextJie(_level):void
		{
			var _arrValues:Array=_countAtt(_level);
			var n:int=1;
			var _str:String=null;
			//			var _showName:Boolean=false;
			for each (var va:* in _arrValues)
			{
				if (n > 6)
				{
					break;
				}
				if(_level == 1){
					mc['tf_currName_' + n].text=va.name+":";
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
				mc['tf_nextL_' + n].text=_str;
				++n;
			}
		}
		/**
		 *下一阶属性 
		 * @param level
		 * 
		 */
		private function _countAtt_next(level:int):void
		{
			var _arrValues:Array=_countAtt(level);
			var _currConfig:Pub_SoarResModel=XmlManager.localres.soarXml.getResPath(level) as Pub_SoarResModel;
			if(_currConfig!=null){
				mc['tf_level2'].text=_currConfig.soar_name;
			}else{
				mc['tf_level2'].text="最高阶段";
			}
			var n:int=1;
			var _str:String=null;
			var _showName:Boolean=false;
			for each (var va:* in _arrValues)
			{
				if (n > 7)
				{
					break;
				}
				_str="";
				if (va.valueMin > 0 && va.valueMax > 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin) + "-" + Att.getAttValuePercent(va.func, va.valueMax);
					//					mc['mcJianTou_' + n].visible=true;
					_showName=true;
				}
				else if (va.valueMin > 0 && va.valueMax <= 0)
				{
					_str+=Att.getAttValuePercent(va.func, va.valueMin);
					//					mc['mcJianTou_' + n].visible=true;
					_showName=true;
				}
				else
				{
					if (_showName)
					{
						_str+="0";
					}
					else
					{
						_str="";
					}
					//					mc['mcJianTou_' + n].visible=false;
					mc['tf_nextName_' + n].text="";
				}
				if (_showName)
				{
					mc['tf_nextName_' + n].text=va.name+":";
				}
				else
				{
					mc['tf_nextName_' + n].text="";
				}
				mc['tf_nextZ_' + n].text=_str;
				++n;
			}
		}
		/**
		 *显示 星星数量 
		 */
		private function setzuanStar(_lev:int):void
		{
			for(var i:int = 1;i<=10;i++)
			{
				if(i<=_lev)
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
				case "btnzhuansheng":
					if (Data.myKing.level >= SOAR_OPEN_LEVEL)
					{
						_requestCSSoar();
					}
					else
					{
						Lang.showMsg(Lang.getClientMsg("40100_soar_0"));
					}
					break;
				case "btn_exp_zhuanhua":
					if (Data.myKing.level >= SOAR_OPEN_LEVEL)
					{
						mc['mcSoarExpExchang'].visible=!mc['mcSoarExpExchang'].visible;
						_repaintExchange();
					}
					else
					{
						Lang.showMsg(Lang.getClientMsg("40100_soar_1"));
					}
					break;
				case "btnSoarExchange":
					_requestCSSoarExpExchang();
					break;
				default:
					break;
			}
		}
		
		private function _requestCSSoar():void
		{
			var _p:PacketCSSoar=new PacketCSSoar();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCSoar(p:IPacket):void
		{
			var _p:PacketSCSoar=p as PacketSCSoar;
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}
		
		private function _requestCSSoarExpExchang():void
		{
			var _p:PacketCSSoarExpExchang=new PacketCSSoarExpExchang();
			DataKey.instance.send(_p);
		}
		
		private function _responseSCSoarExpExchang(p:IPacket):void
		{
			var _p:PacketSCSoarExpExchang=p as PacketSCSoarExpExchang;
			_repaintExchange();
			setTimeout(_repaintExchange, 200);
			setTimeout(_repaintExchange, 500);
			if (0 != _p.tag)
			{
				Lang.showResult(_p);
				return;
			}
		}
		
		private function _soar_updata(e:DispatchEvent=null):void
		{
			m_currLevel=Data.myKing.soarlvl;
			m_currValue=Data.myKing.soarexp;
			m_currId = m_currLevel+1;
			showDuJiePic(m_currLevel);
			_repaint();
			_repaintExchange();
			mc['tf_curr_xiuwei_value'].text=m_currValue;
		}
		
		
		
		/**
		 *当前属性 
		 * @param level
		 * 
		 */
		public function getCurAtt(soarlvl:int):String
		{
			var _arrValues:Array=_countAtt(soarlvl);
			var n:int=1;
			var _str:String="";
			for each (var va:* in _arrValues)
			{
				if (n > 7)
				{
					break;
				}
				if(soarlvl !=0){
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
					_str+="\n";
				}else{
					
				}
				
				++n;
			}
			if(_str==""){
				_str="您当前尚未开始转生。转生后不仅会提升人物属性，更可以装备转生装备，不仅更炫更帅，还拥有超高属性。转生功能将于80级开启。";
			}
			return _str;
		}
	}
}
