package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPrizeInfo2
    /** 
    *领取每日奖励返回
    */
    public class PacketSCGetActivityPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24202;
        /** 
        *获得奖励的id
        */
        public var prizeid:int;
        /** 
        *获得奖励的列表
        */
        public var arrItemprizelist:Vector.<StructPrizeInfo2> = new Vector.<StructPrizeInfo2>();
        /** 
        *获得奖励的序列id,用于获得对应物品
        */
        public var seqid:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(prizeid);
            ar.writeInt(arrItemprizelist.length);
            for each (var prizelistitem:Object in arrItemprizelist)
            {
                var objprizelist:ISerializable = prizelistitem as ISerializable;
                if (null!=objprizelist)
                {
                    objprizelist.Serialize(ar);
                }
            }
            ar.writeInt(seqid);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prizeid = ar.readInt();
            arrItemprizelist= new  Vector.<StructPrizeInfo2>();
            var prizelistLength:int = ar.readInt();
            for (var iprizelist:int=0;iprizelist<prizelistLength; ++iprizelist)
            {
                var objPrizeInfo:StructPrizeInfo2 = new StructPrizeInfo2();
                objPrizeInfo.Deserialize(ar);
                arrItemprizelist.push(objPrizeInfo);
            }
            seqid = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
