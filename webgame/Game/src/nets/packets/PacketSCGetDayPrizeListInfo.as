package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDayPrizeInfo2
    /** 
    *获得每日奖励是否领取信息列表
    */
    public class PacketSCGetDayPrizeListInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24209;
        /** 
        *每日领取列表
        */
        public var arrItemactivityprizelist:Vector.<StructDayPrizeInfo2> = new Vector.<StructDayPrizeInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemactivityprizelist.length);
            for each (var activityprizelistitem:Object in arrItemactivityprizelist)
            {
                var objactivityprizelist:ISerializable = activityprizelistitem as ISerializable;
                if (null!=objactivityprizelist)
                {
                    objactivityprizelist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemactivityprizelist= new  Vector.<StructDayPrizeInfo2>();
            var activityprizelistLength:int = ar.readInt();
            for (var iactivityprizelist:int=0;iactivityprizelist<activityprizelistLength; ++iactivityprizelist)
            {
                var objDayPrizeInfo:StructDayPrizeInfo2 = new StructDayPrizeInfo2();
                objDayPrizeInfo.Deserialize(ar);
                arrItemactivityprizelist.push(objDayPrizeInfo);
            }
        }
    }
}
