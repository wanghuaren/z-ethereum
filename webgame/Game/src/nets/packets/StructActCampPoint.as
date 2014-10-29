package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCampPoint2
    import netc.packets2.StructCampPlayerRankInfo2
    /** 
    *阵营排行榜活动积分
    */
    public class StructActCampPoint implements ISerializable
    {
        /** 
        *活动标识
        */
        public var actid:int;
        /** 
        *积分
        */
        public var points:StructCampPoint2 = new StructCampPoint2();
        /** 
        *玩家排行数据
        */
        public var arrItemplayers:Vector.<StructCampPlayerRankInfo2> = new Vector.<StructCampPlayerRankInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(actid);
            points.Serialize(ar);
            ar.writeInt(arrItemplayers.length);
            for each (var playersitem:Object in arrItemplayers)
            {
                var objplayers:ISerializable = playersitem as ISerializable;
                if (null!=objplayers)
                {
                    objplayers.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            actid = ar.readInt();
            points.Deserialize(ar);
            arrItemplayers= new  Vector.<StructCampPlayerRankInfo2>();
            var playersLength:int = ar.readInt();
            for (var iplayers:int=0;iplayers<playersLength; ++iplayers)
            {
                var objCampPlayerRankInfo:StructCampPlayerRankInfo2 = new StructCampPlayerRankInfo2();
                objCampPlayerRankInfo.Deserialize(ar);
                arrItemplayers.push(objCampPlayerRankInfo);
            }
        }
    }
}
