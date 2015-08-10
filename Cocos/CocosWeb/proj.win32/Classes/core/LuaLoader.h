#include "lua.h"
#include "lauxlib.h"
#include "cocos2d.h"
USING_NS_CC;
#define CODE_MASK 128

extern "C"
{
	int decode_lua_loader(lua_State *L)
	{
		std::string filename(luaL_checkstring(L, 1));
		size_t pos = filename.rfind(".lua");
		if (pos != std::string::npos)
		{
			filename = filename.substr(0, pos);
		}

		pos = filename.find_first_of(".");
		while (pos != std::string::npos)
		{
			filename.replace(pos, 1, "/");
			pos = filename.find_first_of(".");
		}
		filename.append(".lua");

		Data codeBuffer = FileUtils::getInstance()->getDataFromFile(filename.c_str());
		unsigned char* _char = codeBuffer.getBytes();
		//-------------decode here
		for (int i = 0; i<codeBuffer.getSize(); i++)
		{ 
			_char[i] ^= 128;//xor decode
		}
		//-------------

		if (_char)
		{
			if (luaL_loadbuffer(L, (char*)_char, codeBuffer.getSize(), filename.c_str()) != 0)
			{
				luaL_error(L, "error loading module %s from file %s :\n\t%s",
					lua_tostring(L, 1), filename.c_str(), lua_tostring(L, -1));
			}
			codeBuffer.clear();
		}
		else
		{
			CCLOG("can not get file data of %s", filename.c_str());
		}

		return 1;
	}
}