package ui.view.jingjie
{
	import com.xh.display.XHLoadIcon;
	
	import common.config.Att;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.XmlRes;
	import common.config.xmlres.server.Pub_Bourn_StarResModel;
	import common.managers.Lang;
	import common.utils.StringUtils;
	
	import engine.event.DispatchEvent;
	import engine.support.IPacket;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.DataKey;
	import netc.dataset.MyCharacterSet;
	
	import nets.packets.PacketCSStarActive;
	import nets.packets.PacketCSStarCurrMaxID;
	import nets.packets.PacketSCStarActive;
	import nets.packets.PacketSCStarCurrMaxID;
	
	import org.osmf.net.StreamingURLResource;
	
	import ui.frame.FontColor;
	import ui.frame.ItemManager;
	import ui.frame.UIPanel;
	import ui.frame.WindowName;
	
	import world.FileManager;
	
	/**
	 * svn/侠客行/trunk/策划案2.0/X.星界修改案
	 * 
	 * 星界
	 * 
	 * @author steven guo
	 * 
	 */	
	public class JingJiePanel extends UIPanel
	{
		// 目前一共12页(青龙、白虎、朱雀、玄武)，每页10个按钮。
		private static const PAGE_NUM:int = 9;
		
		private var curID:int = 0;
		public var arrData:Array = null;
		private static var _instance:JingJiePanel;
		public static function instance():JingJiePanel{
			if(_instance==null){
				_instance=new JingJiePanel();
			}
			return _instance;
		}
		public function JingJiePanel()
		{
			super(this.getLink(WindowName.win_xing_jie));
		}
		
		override public function init():void
		{
			super.init();
			super.pageSize=10;
			super.curPage=1;
			arrData = [];
			DataKey.instance.register(PacketSCStarActive.id,_responseSCStarActive);
			
			Data.myKing.addEventListener(MyCharacterSet.STAR_VALUE_UPD,_onStarValueUpd); 
			
			Lang.addTip(mc["btnDesc"],"10034_xingjie",150);
			mc['mcEffecti_fail'].mouseEnabled=mc['mcEffecti_fail'].mouseChildren=false;
			mc['mcEffecti_success'].mouseEnabled=mc['mcEffecti_success'].mouseChildren=false;
			//当前星辰值
			_onStarValueUpd();
			
			curID = Data.myKing.dragPoint;
			_countMaxPageNum();
			curPage=maxPage;
			_changeToPage();
		}	
		
		private var currClickIdx:int = 0;
		override public function mcHandler(target:Object):void
		{
			var name:String = target.name;
			super.mcHandler(target);
			switch(name)
			{
				case "btnXiuLian":
					_requestCSStarActive();
					break;
				default:
					break;
			}
			
			
		}
		
		private function _onStarValueUpd(e:DispatchEvent = null):void
		{
			var color:String=FontColor.TOOL_ENOUGH;
			var _config:Pub_Bourn_StarResModel = XmlManager.localres.getBoneStarXml.getResPath(curID+1) as Pub_Bourn_StarResModel;
			if(_config!=null&&Data.myKing.StarValue<_config.star_value){
				color=FontColor.TOOL_NOT_ENOUGH;
			}
			mc["txt_point1"].htmlText="<font color='#"+color+"'>"+Data.myKing.StarValue+"</font>";
		}
		
		
		private function _changeToPage():void
		{
			if(curPage<0)
			{
				curPage=1;
			}
			if(curPage > maxPage)
			{
				curPage = maxPage;
			}
			(mc as MovieClip).gotoAndStop(curPage);
//				mc["mcLM"].source=FileManager.instance.httpPre("uiskin/newskin/game_index2/js"+(curPage<9?"0"+(curPage+1))+".swf");
			refresh();
		}
		
		private function _countMaxPageNum():void
		{
			maxPage = Math.floor(curID / pageSize) + 1;
			if(maxPage > PAGE_NUM)
			{
				maxPage = PAGE_NUM ;
			}
		}



		
		private function refresh():void
		{
			var _lineFrame:int = 1;
			if(curPage < maxPage || curID >=(PAGE_NUM * pageSize))
			{
				_lineFrame = pageSize;
			}
			else
			{
				_lineFrame = curID % pageSize;
			}
			currClickIdx=_lineFrame+1;
			var _tipBaseIdx:int = (curPage-1)*pageSize;
			var _tipIdx:int = 0;
			var _tipString:String = "";
			for(var i:int = 1 ; i <= pageSize ; ++i)
			{
				_tipIdx = _tipBaseIdx + i;
				_tipString = null;
				//已激活
				if(i <= _lineFrame)
				{
					mc['_b'+i].gotoAndStop(2);
					_tipString = _getTipString(_tipIdx,true);
				}
				//已开启
				else if(i == (_lineFrame+1))
				{
					mc['_b'+i].gotoAndStop(3);
					_tipString = _getTipString(_tipIdx,false);
				}
				//未开启
				else
				{
					mc['_b'+i].gotoAndStop(1);
					_tipString = _getTipString(_tipIdx,false);

				}    
				mc['_b'+i].buttonMode = true;
				mc['_b'+i].tipParam = [_tipString];
				Lang.addTip(mc['_b'+i],'pub_param',150);
			}
			mc['mcLine'].gotoAndStop(_lineFrame);
			showAtt();
		}
		
		
		/***********   通讯  ************/
		
		/**
		 * 修炼 
		 * 
		 */		
		private function _requestCSStarActive():void
		{
			var _p:PacketCSStarActive = new PacketCSStarActive();
			DataKey.instance.send(_p);
		}
		private function _responseSCStarActive(p:PacketSCStarActive):void
		{
			if(super.showResult(p)){
				//ItemManager.instance().showWindowEffect("effect_zhuang_bei_success",mc,259,178);
				_showEffecti_success(currClickIdx);
				Data.myKing.dragPoint=p.star_id;
				curID = Data.myKing.dragPoint;
				var _config:Pub_Bourn_StarResModel = XmlManager.localres.getBoneStarXml.getResPath(curID) as Pub_Bourn_StarResModel;
				Lang.showMsg(Lang.getClientMsg("40002_StarActive_1",[_config.star_name]));    
				_countMaxPageNum();
				
				curPage=maxPage;
				_changeToPage();	
			}else{
				if(26015 == p.tag){
					//ItemManager.instance().showWindowEffect("effecti_fail",mc,400,178);
					_showEffecti_fail(currClickIdx);
				}
			}
		}
		
		/***********   内部方法  ************/
		private function getAtt(num:int):Array
		{
			var _config:Pub_Bourn_StarResModel = null ;//
			var _values:Array = [];
			var func:int=0;
			
			for(var i:int = 1 ; i <= num ; i++)
			{
				_config = XmlManager.localres.getBoneStarXml.getResPath(i) as Pub_Bourn_StarResModel;
				if(null == _config)
				{
					continue;
				}
				for(var k:int=1;k<=10;k+=2){
					func=_config["func"+k];
					if(func > 0)
					{
						if(null == _values[func])
						{
							_values[func] = {func:func,name:Att.getAttName(func),valueMin:_config["value"+k] ,valueMax:_config["value"+(k+1)]} ;
						}
						else
						{
							_values[func].valueMin += _config["value"+k];
							_values[func].valueMax += _config["value"+(k+1)];
						}
					}
				}
			}
			var _arrSort:Array = [];
			_arrSort[ATT_MAX_COUNT-1]=null;
			//50,21,23,22,24,41,37
			//何云峰 2014-1-25
			//19,21,23,22,24,41,37
			for each(var v:*in _values)
			{
				switch(v.func)
				{
					//case 50:
					case 19:
						_arrSort[0] = v;
						break;
					case 21:
						_arrSort[1] = v;
						break;
					case 23:
						_arrSort[2] = v;
						break;
					case 109:
						_arrSort[3] = v;
						break;
					case 22:
						_arrSort[4] = v;
						break;
					case 24:
						_arrSort[5] = v;
						break;
					case 41:
						_arrSort[6] = v;
						break;
					case 37:
						_arrSort[7] = v;
						break;
					default:
						break;
				}
			}
			return _arrSort;
		}
		private var ATT_MAX_COUNT:int=8;
		private function showAtt():void
		{
			var arrAtt:Array=getAtt(curID);
			var nextID:int=curID+1;
			if(nextID>super.pageSize*PAGE_NUM)nextID=super.pageSize*PAGE_NUM;
			var arrAttNext:Array=getAtt(nextID);
			
			var n:int = 0;
			var attName:String="";
			var attValue:String="";
			var attValueNext:String="";
			
			var att:Object;
			var attNext:Object;
			var k:int=0;
			for(var i:int=0;i<ATT_MAX_COUNT;i++)
			{
				mc["mc_row"+i].visible=false;
				att=arrAtt[i];
				attNext=arrAttNext[i];
				if(attNext==null)continue;
				
				attName+=attNext.name+":\n";
				if(attNext.valueMin > 0 && attNext.valueMax > 0)
				{
					attValueNext +=Att.getAttValuePercent(attNext.func, attNext.valueMin)+
						"-"+Att.getAttValuePercent(attNext.func, attNext.valueMax);
					if(att!=null){
						attValue+=Att.getAttValuePercent(att.func, att.valueMin)+
							"-"+Att.getAttValuePercent(att.func, att.valueMax);
					}else{
						attValue+="0-0";
					}
				}
				else if(attNext.valueMin > 0 && attNext.valueMax <= 0)
				{
					attValueNext+= Att.getAttValuePercent(attNext.func, attNext.valueMin);
					if(att!=null){
						attValue+=Att.getAttValuePercent(att.func, att.valueMin)
					}else{
						attValue+="0";
					}
				}
				else
				{
					
				}
				attValueNext+= "\n";
				attValue+="\n";
				
				if(att!=null){
					if(attNext.valueMin>att.valueMin || attNext.valueMax>att.valueMax){
						mc["mc_row"+k].visible=true;
					}else{
						mc["mc_row"+k].visible=false;
					}
				}else{
					mc["mc_row"+k].visible=true;
				}
				k++;
			}
			mc["txt_name"].htmlText=attName;
			mc["txt_value"].htmlText=attValue;
			mc["txt_value_next"].htmlText=attValueNext;
			
			var _config:Pub_Bourn_StarResModel = XmlManager.localres.getBoneStarXml.getResPath(curID) as Pub_Bourn_StarResModel;
			var _configNext:Pub_Bourn_StarResModel = XmlManager.localres.getBoneStarXml.getResPath(nextID) as Pub_Bourn_StarResModel;
			if(_config!=null){
				
				mc['txt_drag_name'].text=curID%10==0?10:curID%10;
				mc['txt_drag_name'].x=146;
				mc["txt_zhanDouLi"].text=_config.grade_value;
				mc["mc_lm_name"].visible=true;
				mc["mc_lm_name"].gotoAndStop(Math.ceil(curID/10));
				
			}else{
				
				mc['txt_drag_name'].text="请修炼你的龙脉";
				mc['txt_drag_name'].x=114;
				mc["txt_zhanDouLi"].text="0";
				mc["txt_point2"].text="0";
				mc["mc_lm_name"].visible=false;
			}
			mc["txt_point2"].text=_configNext.star_value;
			_onStarValueUpd();
		}
		/**
		 * 获得 tip 显示字符串
		 * @param id       id值
		 * @param isJiHuo  是否已经激活
		 * @return 
		 * 
		 */		
		private function _getTipString(id:int,isJiHuo:Boolean):String
		{
			var _ret:String = null;
			var _config:Pub_Bourn_StarResModel = XmlManager.localres.getBoneStarXml.getResPath(id) as Pub_Bourn_StarResModel;
			if(isJiHuo)
			{
				_ret = _config.star_name+"　<font color='#00FF00'>【已激活】</font><br>";
			}
			else
			{
				_ret = _config.star_name+"　<font color='#00FF00'>【未激活】</font><br>";
			}
			
			var func:int=0;
			for(var f:int=1;f<=10;f+=2){
				func=_config["func"+f];
				if(func > 0)
				{
					_ret += "<font color='#FF9900'>"+Att.getAttName(func)+"</font> <font color='#00FF00'>"+
						Att.getAttValuePercent(func,_config["value"+f])+"";
					if(_config["value"+(f+1)] > 0)
					{
						_ret +="-"+Att.getAttValuePercent(func,_config["value"+(f+1)])+"</font><br>";
					}
					else
					{
						_ret +="</font><br>";
					}
				}
			}
			if(!isJiHuo)
			{
				if(_config.star_value > Data.myKing.StarValue)
				{
					_ret +="<font color='#FF9900'>需要龙脉点:</font><font color='#FF0000'>"+_config.star_value+"</font><br>";
				}
				else
				{
					_ret +="<font color='#FF9900'>需要龙脉点:</font><font color='#00FF00'>"+_config.star_value+"</font><br>";
				}
				//_ret +="<font color='#FF9900'>需要星尘值:</font><font color='#FF0000'>"+_config.star_value+"</font><br>";
				_ret +="<font color='#FF9900'>成功几率:</font><font color='#00FF00'>"+int(_config.rate/100)+"%</font>";
			}
			
			return _ret;
		}
		
		
		override public function windowClose() : void 
		{
			super.windowClose();
		}
		
		
		
		private function _showEffecti_fail(idx:int):void
		{
			var _x:int = mc['_b'+idx].x + (mc['_b'+idx].width >> 1);
			var _y:int = mc['_b'+idx].y + (mc['_b'+idx].height >> 1);
			
			mc['mcEffecti_fail'].x = _x - 40;
			mc['mcEffecti_fail'].y = _y - 20;
			mc['mcEffecti_fail'].gotoAndPlay(2);	
		}
		private function _showEffecti_success(idx:int):void
		{
			var _x:int = mc['_b'+idx].x + (mc['_b'+idx].width >> 1);
			var _y:int = mc['_b'+idx].y + (mc['_b'+idx].height >> 1);
			
			mc['mcEffecti_success'].x = _x - 40;
			mc['mcEffecti_success'].y = _y - 20;
			mc['mcEffecti_success'].gotoAndPlay(2);
		}
		
		
		/**
		 * 角色界面显示 
		 * 
		 */		
		public function getCurAtt(curDrag:int):String
		{
			var arrAtt:Array=getAtt(curDrag);

			var n:int = 0;
			var attValue:String="";
			
			var att:Object;

			for(var i:int=0;i<ATT_MAX_COUNT;i++)
			{
				att=arrAtt[i];
				if(att==null)continue;
				
				attValue+=att.name+"：";
				if(att.valueMin > 0 && att.valueMax > 0)
				{
					attValue +=Att.getAttValuePercent(att.func, att.valueMin)+
						"-"+Att.getAttValuePercent(att.func, att.valueMax);
				}
				else if(att.valueMin > 0 && att.valueMax <= 0)
				{
					attValue+= Att.getAttValuePercent(att.func, att.valueMin);
				}
				else
				{
					
				}
				attValue+="\n";

			}
			if(attValue==""){
				attValue="";
			}
			return attValue;

		}
	}
}





