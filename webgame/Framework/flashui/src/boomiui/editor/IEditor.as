package boomiui.editor
{
	import feathers.core.FeathersControl;
	
	public interface IEditor
	{
		
		function toXMLString() : String
			
		function destroy() : void
			
		function getComponent() : FeathersControl
			
		function setStyleName(name : String , value : *) : void
			
		function toCopy() : Editor
			
		function xmlToComponent(value : XML) : Editor
			
		function toArrayList() : Array
			
		function get type() : String
			
		function create() : void
	}
}