package com.bellaxu.struct
{
	import engine.support.IPacket;

	/**
	 * 游戏总线方法接口
	 * @author BellaXu
	 */
	public interface IGameLine
	{
		/**
		 * 注册监听
		 */
		function regist(pid:uint, func:Function):void;
		/**
		 * 发送协议
		 */
		function send(p:IPacket):void;
	}
}