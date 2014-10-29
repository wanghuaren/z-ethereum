package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructHorseList2
    /** 
    *坐骑列表
    */
    public class PacketSCHorseList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16006;
        /** 
        *坐骑列表
        */
        public var arrItemhorselist:Vector.<StructHorseList2> = new Vector.<StructHorseList2>();
        /** 
        *坐骑开启的数量
        */
        public var horse_num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemhorselist.length);
            for each (var horselistitem:Object in arrItemhorselist)
            {
                var objhorselist:ISerializable = horselistitem as ISerializable;
                if (null!=objhorselist)
                {
                    objhorselist.Serialize(ar);
                }
            }
            ar.writeInt(horse_num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemhorselist= new  Vector.<StructHorseList2>();
            var horselistLength:int = ar.readInt();
            for (var ihorselist:int=0;ihorselist<horselistLength; ++ihorselist)
            {
                var objHorseList:StructHorseList2 = new StructHorseList2();
                objHorseList.Deserialize(ar);
                arrItemhorselist.push(objHorseList);
            }
            horse_num = ar.readInt();
        }
    }
}
