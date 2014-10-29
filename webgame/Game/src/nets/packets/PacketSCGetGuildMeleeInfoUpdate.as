package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildFightInfoData2
    import netc.packets2.StructGuildFightInfoData2
    /** 
    *第一帮派战活动信息刷新
    */
    public class PacketSCGetGuildMeleeInfoUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39611;
        /** 
        *副本剩余时间 毫秒
        */
        public var last_time:int;
        /** 
        *活动信息
        */
        public var arrItemFightInfo:Vector.<StructGuildFightInfoData2> = new Vector.<StructGuildFightInfoData2>();
        /** 
        *活动信息
        */
        public var firstInfo:StructGuildFightInfoData2 = new StructGuildFightInfoData2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(last_time);
            ar.writeInt(arrItemFightInfo.length);
            for each (var FightInfoitem:Object in arrItemFightInfo)
            {
                var objFightInfo:ISerializable = FightInfoitem as ISerializable;
                if (null!=objFightInfo)
                {
                    objFightInfo.Serialize(ar);
                }
            }
            firstInfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            last_time = ar.readInt();
            arrItemFightInfo= new  Vector.<StructGuildFightInfoData2>();
            var FightInfoLength:int = ar.readInt();
            for (var iFightInfo:int=0;iFightInfo<FightInfoLength; ++iFightInfo)
            {
                var objGuildFightInfoData:StructGuildFightInfoData2 = new StructGuildFightInfoData2();
                objGuildFightInfoData.Deserialize(ar);
                arrItemFightInfo.push(objGuildFightInfoData);
            }
            firstInfo.Deserialize(ar);
        }
    }
}
