package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *客户端回调服务器方法
    */
    public class PacketCSCallBack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 21002;
        /** 
        *回调类型
        */
        public var callbacktype:int;
        /** 
        *回调参数1
        */
        public var callbackparam1:int;
        /** 
        *回调参数2
        */
        public var callbackparam2:int;
        /** 
        *回调参数3
        */
        public var callbackparam3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(callbacktype);
            ar.writeInt(callbackparam1);
            ar.writeInt(callbackparam2);
            ar.writeInt(callbackparam3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            callbacktype = ar.readInt();
            callbackparam1 = ar.readInt();
            callbackparam2 = ar.readInt();
            callbackparam3 = ar.readInt();
        }
    }
}
