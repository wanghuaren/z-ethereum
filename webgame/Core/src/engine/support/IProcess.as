package engine.support
{
	import engine.event.DispatchEvent;
	

	public interface IProcess
	{
		//function process(p:IPacket):DispatchEvent;
		
		//function process(p:IPacket):Array
		
		function process(p:IPacket):IPacket
			
	}
}