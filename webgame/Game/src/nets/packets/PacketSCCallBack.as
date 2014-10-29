package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructIntParamList2
    import netc.packets2.StructCharParamList2
    /** 
    *通知客户端回调服务器方法
    */
    public class PacketSCCallBack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 21001;
        /** 
        *回调类型
        */
        public var callbacktype:int;
        /** 
        *整形参数列表
        */
        public var arrItemintparam:Vector.<StructIntParamList2> = new Vector.<StructIntParamList2>();
        /** 
        *字符串参数列表
        */
        public var arrItemcharparam:Vector.<StructCharParamList2> = new Vector.<StructCharParamList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(callbacktype);
            ar.writeInt(arrItemintparam.length);
            for each (var intparamitem:Object in arrItemintparam)
            {
                var objintparam:ISerializable = intparamitem as ISerializable;
                if (null!=objintparam)
                {
                    objintparam.Serialize(ar);
                }
            }
            ar.writeInt(arrItemcharparam.length);
            for each (var charparamitem:Object in arrItemcharparam)
            {
                var objcharparam:ISerializable = charparamitem as ISerializable;
                if (null!=objcharparam)
                {
                    objcharparam.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            callbacktype = ar.readInt();
            arrItemintparam= new  Vector.<StructIntParamList2>();
            var intparamLength:int = ar.readInt();
            for (var iintparam:int=0;iintparam<intparamLength; ++iintparam)
            {
                var objIntParamList:StructIntParamList2 = new StructIntParamList2();
                objIntParamList.Deserialize(ar);
                arrItemintparam.push(objIntParamList);
            }
            arrItemcharparam= new  Vector.<StructCharParamList2>();
            var charparamLength:int = ar.readInt();
            for (var icharparam:int=0;icharparam<charparamLength; ++icharparam)
            {
                var objCharParamList:StructCharParamList2 = new StructCharParamList2();
                objCharParamList.Deserialize(ar);
                arrItemcharparam.push(objCharParamList);
            }
        }
    }
}
