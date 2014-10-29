package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActivityPrizeInfo2
    /** 
    *获得每日领取列表数据返回
    */
    public class PacketSCGetActivityPrizeList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24206;
        /** 
        *每日领取列表
        */
        public var arrItemactivityprizelist:Vector.<StructActivityPrizeInfo2> = new Vector.<StructActivityPrizeInfo2>();
        /** 
        *活跃点
        */
        public var activity:int;
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
            ar.writeInt(arrItemactivityprizelist.length);
            for each (var activityprizelistitem:Object in arrItemactivityprizelist)
            {
                var objactivityprizelist:ISerializable = activityprizelistitem as ISerializable;
                if (null!=objactivityprizelist)
                {
                    objactivityprizelist.Serialize(ar);
                }
            }
            ar.writeInt(activity);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemactivityprizelist= new  Vector.<StructActivityPrizeInfo2>();
            var activityprizelistLength:int = ar.readInt();
            for (var iactivityprizelist:int=0;iactivityprizelist<activityprizelistLength; ++iactivityprizelist)
            {
                var objActivityPrizeInfo:StructActivityPrizeInfo2 = new StructActivityPrizeInfo2();
                objActivityPrizeInfo.Deserialize(ar);
                arrItemactivityprizelist.push(objActivityPrizeInfo);
            }
            activity = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
