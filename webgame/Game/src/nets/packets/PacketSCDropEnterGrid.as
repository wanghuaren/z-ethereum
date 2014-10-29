package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDropList2
    /** 
    *掉落进入视野
    */
    public class PacketSCDropEnterGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1009;
        /** 
        *掉落id
        */
        public var monsterid:int;
        /** 
        *掉落id
        */
        public var objid:int;
        /** 
        *产生坐标x
        */
        public var spawn_posx:int;
        /** 
        *产生坐标y
        */
        public var spawn_posy:int;
        /** 
        *坐标x
        */
        public var posx:int;
        /** 
        *坐标y
        */
        public var posy:int;
        /** 
        *掉落列表数据
        */
        public var arrItemlist:Vector.<StructDropList2> = new Vector.<StructDropList2>();
        /** 
        *0:无动画 1:有动画
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(monsterid);
            ar.writeInt(objid);
            ar.writeInt(spawn_posx);
            ar.writeInt(spawn_posy);
            ar.writeInt(posx);
            ar.writeInt(posy);
            ar.writeInt(arrItemlist.length);
            for each (var listitem:Object in arrItemlist)
            {
                var objlist:ISerializable = listitem as ISerializable;
                if (null!=objlist)
                {
                    objlist.Serialize(ar);
                }
            }
            ar.writeByte(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            monsterid = ar.readInt();
            objid = ar.readInt();
            spawn_posx = ar.readInt();
            spawn_posy = ar.readInt();
            posx = ar.readInt();
            posy = ar.readInt();
            arrItemlist= new  Vector.<StructDropList2>();
            var listLength:int = ar.readInt();
            for (var ilist:int=0;ilist<listLength; ++ilist)
            {
                var objDropList:StructDropList2 = new StructDropList2();
                objDropList.Deserialize(ar);
                arrItemlist.push(objDropList);
            }
            flag = ar.readByte();
        }
    }
}
