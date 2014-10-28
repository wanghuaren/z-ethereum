package engine.support
{

    /**
     * @author  WangHuaRen
     * @version 2011-10-21
     */
    public interface IMonitor
    {
		/**
		 * 动画播放FPS,每秒播放帧数
		 * */
        function get frameRateState():int;
		/**
		 * 跳帧总增量
		 * */
        function get offsetFrameRate():int;
		/**
		 * 监视动画运行状态
		 * */
        function refreshState():void;
		/**
		 * 状态监控
		 * 内容 info object="object" act="do" minlen="0" maxlen="0" minTime="0" maxTime="0" minfps="0" maxfps="0" minMemory="0" maxMemory="0" minRomanceNum="0" maxRomanceNum="0" minMovieNum="0" maxMovieNum="0" minMovieLoaded="0" maxMovieLoaded="0"
		 **/
		function addInfo(uname:String, attribute:Array, value:Array):void;
		/**
		 * 系统信息
		 * */
		function get SYSINFO():XML
    }
}