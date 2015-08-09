using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace ProtocolTool.core
{
    class Encrypt
    {
        private static Encrypt _instance;
        public static Encrypt instance
        {
            get
            {
                if (_instance == null)
                    _instance = new Encrypt();
                return _instance;
            }
        }
        public Byte VERSION = 66;
        private string imagResPacket = "/Res.MPQ";
        private BinaryWriter imgResBW;
        public string rootPath;
        public void encryptRes(string _path)
        {
            if (_path == rootPath)
            {
                Directory.CreateDirectory(rootPath + "/../encrypt/res");
                imgResBW = new BinaryWriter(File.Create(rootPath + "/../encrypt/res" + imagResPacket));
            }
            DirectoryInfo directory = new DirectoryInfo(_path);
            if (directory.Exists)
            {
                DirectoryInfo[] _directory = directory.GetDirectories();
                for (int i = 0; i < _directory.Length; i++)
                {

                    encryptRes(_directory[i].FullName);
                }
                //if (_path.IndexOf("Resources\\res")>=0&&_path.IndexOf("Resources\\res")>=_path.Length-15)
                //{

                //}
                FileInfo[] _file = directory.GetFiles();
                for (int i = 0; i < _file.Length; i++)
                {

                    if (_file[i].Extension == ".lua")
                    {
                        encryptLua(_file[i]);
                    }
                    else if (_file[i].Extension == ".png" || _file[i].Extension == ".jpg")
                    {
                        encryptImg(_file[i]);
                    }
                    else if (_file[i].Extension == ".ttf" || _file[i].Extension == ".ttc")
                    {
                        encryptLua(_file[i]);
                    }
                }
            }
            if (_path == rootPath)
                imgResBW.Close();
        }

        private void encryptLua(FileInfo _file)
        {
            string _path = _file.FullName;
            _path = rootPath + "/../encrypt/" + _path.Replace(rootPath, "");

            FileInfo _fileWrite = new FileInfo(_path);
            FileStream _fileStrmWrite;
            if (_fileWrite.Exists)
            {
                _fileStrmWrite = new FileStream(_fileWrite.FullName, FileMode.Create);
            }
            else
            {
                Directory.CreateDirectory(_fileWrite.FullName.Replace(_fileWrite.Name, ""));
                _fileStrmWrite = File.Create(_path);
            }
            if (_file.Name == "main.lua" || _file.Extension == ".ttf" || _file.Extension == ".ttc")
            {
                _fileStrmWrite.Close();
                _file.CopyTo(_path, true);
                return;
            }

            FileStream _fileStrm = new FileStream(_file.FullName, FileMode.Open);
            BinaryReader _br = new BinaryReader(_fileStrm);
            BinaryWriter _bw = new BinaryWriter(_fileStrmWrite);

            Byte _code = 128;
            Byte _byte = 1;
            while (_br.BaseStream.Position < _br.BaseStream.Length)
            {
                _byte = _br.ReadByte();
                _byte ^= _code;
                _bw.Write(_byte);
            }
            _br.Close();
            _bw.Close();
            _fileStrm.Close();
            _fileStrmWrite.Close();
        }
        private void encryptImg(FileInfo _file)
        {
            string _path = rootPath + "\\..\\encrypt";
            _path += _file.DirectoryName.Replace(rootPath, "");
            if (!Directory.Exists(_path))
            {
                Directory.CreateDirectory(_path);
            }
            _path = rootPath + "\\..\\encrypt"+_file.FullName.Replace(rootPath, "");
            File.Create(_path);

            FileStream _fileRead = File.OpenRead(_file.FullName);
            BinaryReader _br = new BinaryReader(_fileRead);
            _path = _file.FullName.Replace(rootPath + "\\", "").Replace("\\", "/").Replace("LuaScript/", "");
            imgResBW.Write(VERSION);
            byte[] _pathByte = Encoding.UTF8.GetBytes(_path);
            imgResBW.Write(_pathByte.Length);
            imgResBW.Write(_pathByte);
            imgResBW.Write((Byte)0);
            imgResBW.Write((int)_br.BaseStream.Length);
            imgResBW.Write(_br.ReadBytes((int)_br.BaseStream.Length));
        }
    }
}
