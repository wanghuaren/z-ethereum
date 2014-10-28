package com.engine.core.controls.model
{
	import com.engine.core.controls.service.IMessage;
	
	import flash.utils.getQualifiedClassName;
	/**
	 * 服务器模块核心封装实现。
	 * 外部模块的服务器部分实现实际上是该模块的子模块实现。
	 * 因此外部注册时要注册NAME常量名称
	 * @author saiman
	 * 
	 */
	public class ServierProtModule extends Module
	{
		public static const NAME:String=flash.utils.getQualifiedClassName(ServierProtModule)
		public function ServierProtModule()
		{
			super();
			this.register(NAME)
		}
		override public function subHandler(message:IMessage):void
		{
			super.subHandler(message)
		}
	}
}