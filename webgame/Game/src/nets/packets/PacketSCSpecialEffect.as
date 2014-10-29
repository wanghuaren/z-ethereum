package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTargetList2
    /** 
    *陷阱特效
    */
    public class PacketSCSpecialEffect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14040;
        /** 
        *陷阱id
        */
        public var objid:int;
        /** 
        *目标列表
        */
        public var arrItemtargets:Vector.<StructTargetList2> = new Vector.<StructTargetList2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(arrItemtargets.length);
            for each (var targetsitem:Object in arrItemtargets)
            {
                var objtargets:ISerializable = targetsitem as ISerializable;
                if (null!=objtargets)
                {
                    objtargets.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            arrItemtargets= new  Vector.<StructTargetList2>();
            var targetsLength:int = ar.readInt();
            for (var itargets:int=0;itargets<targetsLength; ++itargets)
            {
                var objTargetList:StructTargetList2 = new StructTargetList2();
                objTargetList.Deserialize(ar);
                arrItemtargets.push(objTargetList);
            }
        }
    }
}
