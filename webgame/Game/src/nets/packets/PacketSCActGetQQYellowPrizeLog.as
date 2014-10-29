package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructQQYellowLog2
    /** 
    *QQ黄钻续费礼包领取日志
    */
    public class PacketSCActGetQQYellowPrizeLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38138;
        /** 
        *日志信息
        */
        public var arrItemmsg:Vector.<StructQQYellowLog2> = new Vector.<StructQQYellowLog2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemmsg.length);
            for each (var msgitem:Object in arrItemmsg)
            {
                var objmsg:ISerializable = msgitem as ISerializable;
                if (null!=objmsg)
                {
                    objmsg.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemmsg= new  Vector.<StructQQYellowLog2>();
            var msgLength:int = ar.readInt();
            for (var imsg:int=0;imsg<msgLength; ++imsg)
            {
                var objQQYellowLog:StructQQYellowLog2 = new StructQQYellowLog2();
                objQQYellowLog.Deserialize(ar);
                arrItemmsg.push(objQQYellowLog);
            }
        }
    }
}
