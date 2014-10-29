package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得已经学会坐骑技能列表返回
    */
    public class PacketSCGetHoreseSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16023;
        /** 
        *技能id
        */
        public var arrItemskill_l:Vector.<int> = new Vector.<int>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemskill_l.length);
            for each (var skill_litem:int in arrItemskill_l)
            {
                ar.writeInt(skill_litem);
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemskill_l= new  Vector.<int>();
            var skill_lLength:int = ar.readInt();
            for (var iskill_l:int=0;iskill_l<skill_lLength; ++iskill_l)
            {
                arrItemskill_l.push(ar.readInt());
            }
        }
    }
}
