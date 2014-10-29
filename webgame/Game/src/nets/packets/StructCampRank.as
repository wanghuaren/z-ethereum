package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCampPoint2
    import netc.packets2.StructActCampPoint2
    import netc.packets2.StructCampPlayerRankInfo2
    /** 
    *阵营数据
    */
    public class StructCampRank implements ISerializable
    {
        /** 
        *阵营总积分
        */
        public var total:StructCampPoint2 = new StructCampPoint2();
        /** 
        *阵营活动排行数据
        */
        public var arrItemacts:Vector.<StructActCampPoint2> = new Vector.<StructActCampPoint2>();
        /** 
        *玩家排行数据
        */
        public var arrItemplayers:Vector.<StructCampPlayerRankInfo2> = new Vector.<StructCampPlayerRankInfo2>();
        /** 
        *日期
        */
        public var day:int;

        public function Serialize(ar:ByteArray):void
        {
            total.Serialize(ar);
            ar.writeInt(arrItemacts.length);
            for each (var actsitem:Object in arrItemacts)
            {
                var objacts:ISerializable = actsitem as ISerializable;
                if (null!=objacts)
                {
                    objacts.Serialize(ar);
                }
            }
            ar.writeInt(arrItemplayers.length);
            for each (var playersitem:Object in arrItemplayers)
            {
                var objplayers:ISerializable = playersitem as ISerializable;
                if (null!=objplayers)
                {
                    objplayers.Serialize(ar);
                }
            }
            ar.writeInt(day);
        }
        public function Deserialize(ar:ByteArray):void
        {
            total.Deserialize(ar);
            arrItemacts= new  Vector.<StructActCampPoint2>();
            var actsLength:int = ar.readInt();
            for (var iacts:int=0;iacts<actsLength; ++iacts)
            {
                var objActCampPoint:StructActCampPoint2 = new StructActCampPoint2();
                objActCampPoint.Deserialize(ar);
                arrItemacts.push(objActCampPoint);
            }
            arrItemplayers= new  Vector.<StructCampPlayerRankInfo2>();
            var playersLength:int = ar.readInt();
            for (var iplayers:int=0;iplayers<playersLength; ++iplayers)
            {
                var objCampPlayerRankInfo:StructCampPlayerRankInfo2 = new StructCampPlayerRankInfo2();
                objCampPlayerRankInfo.Deserialize(ar);
                arrItemplayers.push(objCampPlayerRankInfo);
            }
            day = ar.readInt();
        }
    }
}
