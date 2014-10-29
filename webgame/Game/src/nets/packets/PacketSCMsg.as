package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.Structequipidattrs2
    import netc.packets2.StructVariant2
    /** 
    *系统消息
    */
    public class PacketSCMsg implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10088;
        /** 
        *阵营编号，为0不处理
        */
        public var campid:int;
        /** 
        *道具属性
        */
        public var arrItemequipattrs:Vector.<Structequipidattrs2> = new Vector.<Structequipidattrs2>();
        /** 
        *错误代码
        */
        public var tag:int;
        /** 
        *参数信息
        */
        public var arrItemparams:Vector.<StructVariant2> = new Vector.<StructVariant2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(campid);
            ar.writeInt(arrItemequipattrs.length);
            for each (var equipattrsitem:Object in arrItemequipattrs)
            {
                var objequipattrs:ISerializable = equipattrsitem as ISerializable;
                if (null!=objequipattrs)
                {
                    objequipattrs.Serialize(ar);
                }
            }
            ar.writeInt(tag);
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
            campid = ar.readInt();
            arrItemequipattrs= new  Vector.<Structequipidattrs2>();
            var equipattrsLength:int = ar.readInt();
            for (var iequipattrs:int=0;iequipattrs<equipattrsLength; ++iequipattrs)
            {
                var objequipidattrs:Structequipidattrs2 = new Structequipidattrs2();
                objequipidattrs.Deserialize(ar);
                arrItemequipattrs.push(objequipidattrs);
            }
            tag = ar.readInt();
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
