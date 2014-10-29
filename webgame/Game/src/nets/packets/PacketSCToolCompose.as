package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructVariant2
    /** 
    *道具合成
    */
    public class PacketSCToolCompose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15050;
        /** 
        *标记 同CSToolCompose.flag
        */
        public var flag:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *参数信息
        */
        public var arrItemparams:Vector.<StructVariant2> = new Vector.<StructVariant2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
            ar.writeInt(arrItemparams.length);
            for each (var paramsitem:Object in arrItemparams)
            {
                var objparams:ISerializable = paramsitem as ISerializable;
                if (null!=objparams)
                {
                    objparams.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            arrItemparams= new  Vector.<StructVariant2>();
            var paramsLength:int = ar.readInt();
            for (var iparams:int=0;iparams<paramsLength; ++iparams)
            {
                var objVariant:StructVariant2 = new StructVariant2();
                objVariant.Deserialize(ar);
                arrItemparams.push(objVariant);
            }
        }
    }
}
