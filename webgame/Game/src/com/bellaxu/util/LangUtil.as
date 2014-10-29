package com.bellaxu.util
{
	import com.bellaxu.debug.Debug;
	
	import com.bellaxu.data.GameData;
	import common.config.XmlConfig;
	
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import netc.packets2.StructVaraint2;
	
	import nets.packets.StructVaraint;

	/**
	 * 语言包工具集
	 * @author BellaXu
	 */
	public class LangUtil
	{
		public static const LANG_LOAD:String = "load.xml";
		public static const LANG_GAME:String = "game.xml";
		public static const LANG_MSG:String = "msg.xml";
		private static var langDic:Dictionary = new Dictionary();
		
		public static function init(domain:ApplicationDomain):void
		{
			initLoadLang(domain);
			initGameLang(domain);
			initMsgLang(domain);
		}
		
		private static function initLoadLang(domain:ApplicationDomain):void
		{
			var dic:Dictionary = new Dictionary();
			var path:String = LANG_LOAD.replace(".", "__");
			var cls:Class = domain.getDefinition(path) as Class;
			var xml:XML = XML(new cls());
			var subXml:XML;
			for each(subXml in xml.children())
			{		
				dic[String(subXml.@n)] = String(subXml.text());
			}
			langDic[LANG_LOAD] = dic;
			System.disposeXML(xml);
		}
		
		private static function initGameLang(domain:ApplicationDomain):void
		{
			var dic:Dictionary = new Dictionary();
			var path:String = LANG_GAME.replace(".", "__");
			var cls:Class = domain.getDefinition(path) as Class;
			var xml:XML = XML(new cls());
			//tips
			var tipsXml:XML = XML(xml.tips);
			var subXml:XML;
			for each (subXml in tipsXml.child("t"))
			{
				dic[String(subXml.@k)] = String(subXml.text());
			}
			//msgs
			var msgsXml:XML = XML(xml.msgs);
			for each (subXml in msgsXml.child("t"))
			{
				dic[String(subXml.@k)] = {type: int(subXml.@p), msg: String(subXml.text())};
			}
			//lbl
			var lblXml:XML = XML(xml.lbls);
			for each (subXml in lblXml.child("t"))
			{
				var word:String = String(subXml.text());
				word = word.replace(/\$2000/g, GameData.pf == GameData.PF_3366 ? "蓝钻" : "黄钻");
				dic[String(subXml.@k)] = word;
			}
			//lbl.arr
			var arr:Array = [];
			var arrXml:XML = null;
			for each (arrXml in lblXml.child("arr"))
			{
				arr = [];
				for each (subXml in arrXml.child("t"))
				{
					arr[int(subXml.@k)] = String(subXml.text());
				}
				dic[String(arrXml.@k)] = arr;
			}
			langDic[LANG_GAME] = dic;
			System.disposeXML(xml);
		}
		
		private static function initMsgLang(domain:ApplicationDomain):void
		{
			var dic:Dictionary = new Dictionary();
			var path:String = LANG_MSG.replace(".", "__");
			var cls:Class = domain.getDefinition(path) as Class;
			var xml:XML = XML(new cls());
			var subXml:XML;
			for each (subXml in xml..e)
			{
				dic[int(subXml.@i)] = {
					type: int(subXml.@p), 
					msg: String(subXml.@m), 
					t: int(subXml.@t), 
					l: int(subXml.@l), 
					s: int(subXml.@s), 
					ui: int(subXml.@ui)
				};
			}
			langDic[LANG_MSG] = dic;
			System.disposeXML(xml);
		}
		
		/**
		 * 获取LOAD_LANG对应的串值
		 */
		public static function getLoadLang(symbol:String):String
		{
			return langDic[LANG_LOAD][symbol];
		}
		
		/**
		 * 获取LANG_GAME的对应串值Object
		 */
		public static function getGameLangObj(key:String="", param:Array=null):Object
		{
			var obj:Object = langDic[LANG_GAME][key];
			if (obj == null)
				return new Object();
			var str:String = obj.msg;
			str=replaceParam(str, param);
			return {type: obj.type, msg: str};
		}
		
		/**
		 * 获取LANG_GAME的对应串值String
		 */
		public static function getGamelangStr(key:String="", param:Array=null):String
		{
			var str:String = langDic[LANG_GAME][key];
			return replaceParam(str, param);
		}
		
		/**
		 * 获取LANG_GAME的对应串值Arr
		 */
		public static function getGamelangArr(key:String=""):Array
		{
			return langDic[LANG_GAME][key];
		}
		
		/**
		 * 获得服务端操作信息
		 */
		public static function getMsgLang(key:int = 0, tempParam:Vector.<StructVaraint2> = null, msg:String = null):Object
		{
			var dic:Dictionary = langDic[LANG_MSG];
			var obj:Object = dic[key];
			if(!obj)
			{
				Debug.warn("unknown server msg.");
				return new Object();
			}
			var str:String = "";
			if (msg == null || msg == "")
			{
				var param:Array;
				if (tempParam != null)
				{
					param = [];
					for each (var sv:StructVaraint in tempParam)
					{
						param.push(sv.val);
					}
				}
				str = obj.msg;
				str = replaceParam(str, param);
			}
			else
			{
				str = msg;
			}
			if (obj == null)
				new Object();
			return {type: obj.type, msg: str, t: obj.t, l: obj.l, s: obj.s, ui: obj.ui};
		}
		
		/**
		 *	替换文字中带参数
		 *  @param word  文字
		 * 	@param param 参数数组
		 */
		public static function replaceParam(word:String="", param:Array=null):String
		{
			if (param == null)
				return word;
			var len:int=param.length;
			//服务端消息参数标记 %d,%s先替换成客户端参数标记 #param 
			while (word.indexOf("%d") >= 0)
			{
				word=word.replace("%d", "#param");
			}
			while (word.indexOf("%s") >= 0)
			{
				word=word.replace("%s", "#param");
			}
			for (var i:uint=0; i < len; i++)
			{
				word=word.replace("#param", param[i]);
			}
			return word;
		}
	}
}