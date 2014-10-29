package world.map.starts
{
	public interface IMapTileModel
	{
		function isBlock(p_startX : int, p_startY : int, p_endX : int, p_endY : int) : int;
		
		function get map():Array
	}
}